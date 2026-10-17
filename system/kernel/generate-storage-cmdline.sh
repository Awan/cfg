#!/bin/bash
set -euo pipefail

output=/etc/cmdline.d/00-storage.conf

die() {
    printf 'generate-storage-cmdline: %s\n' "$*" >&2
    exit 1
}

usage() {
    printf 'Usage: %s --dry-run|--write\n' "$0" >&2
    exit 2
}

if (( EUID != 0 )); then
    die 'run as root, for example: doas bash system/kernel/generate-storage-cmdline.sh --dry-run'
fi

(( $# == 1 )) || usage

mode=$1
case "$mode" in
    --dry-run|--write) ;;
    *) usage ;;
esac

for tool in awk blkid chmod cmp findmnt grep install lsblk mktemp mv rm sort swapon; do
    command -v "$tool" >/dev/null 2>&1 || die "required command not found: $tool"
done

root_source_raw=$(findmnt --noheadings --raw --output SOURCE --target /) || die 'cannot detect root source'
root_source=${root_source_raw%%\[*}

[[ -b "$root_source" ]] || die "root source is not a block device: $root_source_raw"

root_uuid=$(blkid -s UUID -o value "$root_source" 2>/dev/null || true)
root_fstype=$(blkid -s TYPE -o value "$root_source" 2>/dev/null || true)

[[ -n "$root_uuid" ]] || die "cannot detect root filesystem UUID: $root_source"
[[ -n "$root_fstype" ]] || die "cannot detect root filesystem type: $root_source"

root_chain=$(lsblk -s -r -n -p -o NAME,TYPE,FSTYPE "$root_source") || die 'cannot inspect root block-device chain'

mapfile -t luks_devices < <(awk '$3 == "crypto_LUKS" { print $1 }' <<<"$root_chain" | sort -u)
mapfile -t crypt_mappers < <(awk '$2 == "crypt" { print $1 }' <<<"$root_chain" | sort -u)

if (( ${#luks_devices[@]} > 1 || ${#crypt_mappers[@]} > 1 )); then
    die 'root uses nested or multiple encrypted mappings; configure its unlock chain explicitly'
fi

if (( ${#luks_devices[@]} != ${#crypt_mappers[@]} )); then
    die 'cannot match the root LUKS device to one active crypt mapping'
fi

crypt_name=
if (( ${#luks_devices[@]} == 1 )); then
    crypt_name=${crypt_mappers[0]##*/}
fi

hooks_line=$(grep -m1 -E '^[[:space:]]*HOOKS=' /etc/mkinitcpio.conf || true)
[[ -n "$hooks_line" ]] || die 'cannot read HOOKS from /etc/mkinitcpio.conf'

hooks_value=${hooks_line#*=}
hooks_value=${hooks_value#(}
hooks_value=${hooks_value%%)*}

has_hook() {
    [[ " $hooks_value " == *" $1 "* ]]
}

if awk '$2 == "lvm" { found=1 } END { exit !found }' <<<"$root_chain"; then
    if has_hook encrypt && ! has_hook lvm2; then
        die 'root uses LVM with encrypt, but lvm2 is missing from HOOKS'
    fi

    if has_hook sd-encrypt && ! has_hook sd-lvm2; then
        die 'root uses LVM with sd-encrypt, but sd-lvm2 is missing from HOOKS'
    fi

    if ! has_hook encrypt && ! has_hook sd-encrypt && ! has_hook lvm2 && ! has_hook sd-lvm2; then
        die 'root uses LVM, but no LVM hook is configured'
    fi
fi

read -r -a boot_args </proc/cmdline

root_arg_count=0
root_arg_matches=0
root_partuuid=$(blkid -s PARTUUID -o value "$root_source" 2>/dev/null || true)
root_label=$(blkid -s LABEL -o value "$root_source" 2>/dev/null || true)

for arg in "${boot_args[@]}"; do
    case "$arg" in
        root=*)
            root_arg_count=$((root_arg_count + 1))
            root_value=${arg#root=}

            case "$root_value" in
                UUID=*)
                    [[ "${root_value#UUID=}" == "$root_uuid" ]] && root_arg_matches=1
                    ;;
                PARTUUID=*)
                    [[ -n "$root_partuuid" && "${root_value#PARTUUID=}" == "$root_partuuid" ]] && root_arg_matches=1
                    ;;
                LABEL=*)
                    [[ -n "$root_label" && "${root_value#LABEL=}" == "$root_label" ]] && root_arg_matches=1
                    ;;
                *)
                    [[ "$root_value" == "$root_source" ]] && root_arg_matches=1
                    ;;
            esac
            ;;
    esac
done

[[ "$root_arg_count" -eq 1 && "$root_arg_matches" -eq 1 ]] || die 'running kernel root= does not match the mounted root; refusing to generate storage parameters'

cmdline_args=()

if (( ${#luks_devices[@]} == 1 )); then
    luks_device=${luks_devices[0]}
    luks_uuid=$(blkid -s UUID -o value "$luks_device" 2>/dev/null || true)
    [[ -n "$luks_uuid" ]] || die "cannot detect LUKS UUID: $luks_device"

    if has_hook encrypt && ! has_hook sd-encrypt; then
        current_cryptdevice=

        for arg in "${boot_args[@]}"; do
            case "$arg" in
                cryptdevice=*)
                    current_cryptdevice=${arg#cryptdevice=}
                    break
                    ;;
            esac
        done

        crypt_suffix=

        if [[ -n "$current_cryptdevice" ]]; then
            current_source=${current_cryptdevice%%:*}
            current_rest=${current_cryptdevice#*:}
            luks_partuuid=$(blkid -s PARTUUID -o value "$luks_device" 2>/dev/null || true)

            if [[ "$current_source" == "UUID=$luks_uuid" ||
                  "$current_source" == "$luks_device" ||
                  ( -n "$luks_partuuid" && "$current_source" == "PARTUUID=$luks_partuuid" ) ]]; then
                if [[ "$current_rest" == *:* ]]; then
                    current_options=${current_rest#*:}
                    [[ -z "$current_options" ]] || crypt_suffix=":$current_options"
                fi
            else
                die 'current cryptdevice= does not identify the detected root LUKS device'
            fi
        fi

        cmdline_args+=("cryptdevice=UUID=${luks_uuid}:${crypt_name}${crypt_suffix}")

    elif has_hook sd-encrypt && ! has_hook encrypt; then
        for arg in "${boot_args[@]}"; do
            case "$arg" in
                rd.luks.options=*|rd.luks.key=*|rd.luks.data=*|rd.luks.fido2-device=*|rd.luks.tpm2-device=*|rd.luks.pin=*)
                    die "custom systemd LUKS option needs explicit handling before generation: $arg"
                    ;;
            esac
        done

        cmdline_args+=("rd.luks.name=${luks_uuid}=${crypt_name}")
    else
        die 'root is encrypted, but HOOKS must contain exactly one of encrypt or sd-encrypt'
    fi
fi

cmdline_args+=("root=UUID=$root_uuid")
cmdline_args+=("rootfstype=$root_fstype")

if [[ "$root_fstype" == btrfs ]]; then
    root_fsroot=$(findmnt --noheadings --raw --output FSROOT --target /) || die 'cannot detect Btrfs root subvolume'

    if [[ -n "$root_fsroot" && "$root_fsroot" != "/" ]]; then
        if LC_ALL=C grep -q '[[:space:],]' <<<"$root_fsroot"; then
            die 'Btrfs subvolume contains whitespace or a comma; configure rootflags explicitly'
        fi

        cmdline_args+=("rootflags=subvol=${root_fsroot#/}")
    fi
fi

resume_enabled=0
has_hook resume && resume_enabled=1
has_hook sd-resume && resume_enabled=1

if (( resume_enabled )); then
    mapfile -t active_swaps < <(LC_ALL=C swapon --show | awk 'NR > 1 && NF { print $1 }')
    resume_candidates=()

    for swapdev in "${active_swaps[@]}"; do
        [[ -b "$swapdev" ]] || die "active swap is not a block device; swapfile resume needs explicit offset handling: $swapdev"

        swap_name=$(lsblk --nodeps --noheadings --raw --output NAME "$swapdev")
        [[ "$swap_name" == zram* ]] && continue

        swap_type=$(blkid -s TYPE -o value "$swapdev" 2>/dev/null || true)
        [[ "$swap_type" == swap ]] || die "cannot verify active swap device: $swapdev"

        swap_uuid=$(blkid -s UUID -o value "$swapdev" 2>/dev/null || true)
        [[ -n "$swap_uuid" ]] || die "active swap has no UUID: $swapdev"

        swap_chain=$(lsblk -s -r -n -p -o NAME,TYPE,FSTYPE "$swapdev") || die "cannot inspect swap device: $swapdev"
        mapfile -t swap_luks_devices < <(awk '$3 == "crypto_LUKS" { print $1 }' <<<"$swap_chain" | sort -u)

        if (( ${#swap_luks_devices[@]} > 1 )); then
            die "swap has multiple LUKS ancestors: $swapdev"
        fi

        if (( ${#swap_luks_devices[@]} == 1 )); then
            if (( ${#luks_devices[@]} != 1 )) || [[ "${swap_luks_devices[0]}" != "${luks_devices[0]}" ]]; then
                die "swap uses a separate LUKS container that needs explicit early-boot configuration: $swapdev"
            fi
        fi

        resume_candidates+=("$swap_uuid")
    done

    if (( ${#resume_candidates[@]} == 1 )); then
        cmdline_args+=("resume=UUID=${resume_candidates[0]}")
    elif (( ${#resume_candidates[@]} > 1 )); then
        current_resume=

        for arg in "${boot_args[@]}"; do
            case "$arg" in
                resume=UUID=*)
                    current_resume=${arg#resume=UUID=}
                    break
                    ;;
            esac
        done

        selected_resume=

        for candidate in "${resume_candidates[@]}"; do
            [[ "$candidate" == "$current_resume" ]] && selected_resume=$candidate
        done

        [[ -n "$selected_resume" ]] || die 'multiple active persistent swap devices; cannot choose a resume target safely'
        cmdline_args+=("resume=UUID=$selected_resume")
    fi
fi

render() {
    printf '# Generated locally; do not edit this file directly.\n'
    printf '%s\n' "${cmdline_args[@]}"
}

if [[ "$mode" == --dry-run ]]; then
    render
    exit 0
fi

install -d -m 0755 /etc/cmdline.d

tmp=$(mktemp "${output}.XXXXXX")
trap 'rm -f -- "$tmp"' EXIT

render > "$tmp"
chmod 0644 "$tmp"

if [[ -f "$output" ]] && cmp -s "$tmp" "$output"; then
    printf 'No changes needed: %s is already current.\n' "$output"
    exit 0
fi

mv -f -- "$tmp" "$output"
tmp=

printf 'Generated %s\n' "$output"
