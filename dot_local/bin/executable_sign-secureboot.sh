#!/bin/bash
set -euo pipefail

KEY=/etc/secureboot/keys/db.key
CERT=/etc/secureboot/keys/db.crt

for tool in sbverify sbsign; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        printf 'secureboot: required command not found: %s\n' "$tool" >&2
        exit 127
    fi
done

if [[ ! -r "$KEY" || ! -r "$CERT" ]]; then
    printf 'secureboot: signing key or certificate is missing or unreadable\n' >&2
    exit 1
fi

tmp=
cleanup() {
    [[ -z "$tmp" ]] || rm -f -- "$tmp"
}
trap cleanup EXIT

for f in /boot/EFI/Linux/arch-linux.efi \
         /boot/EFI/Linux/arch-linux-fallback.efi \
         /boot/EFI/systemd/systemd-bootx64.efi \
         /boot/EFI/BOOT/BOOTX64.EFI; do
    [[ -f "$f" ]] || continue

    # Skip binaries already signed by the configured certificate.
    if sbverify --cert "$CERT" "$f" >/dev/null 2>&1; then
        continue
    fi

    # Keep the original boot binary untouched until signing and verification
    # have both succeeded.
    tmp=$(mktemp "${f}.signed.XXXXXX")
    if ! sbsign --key "$KEY" --cert "$CERT" --output "$tmp" "$f"; then
        printf 'secureboot: failed to sign %s\n' "$f" >&2
        exit 1
    fi

    if ! sbverify --cert "$CERT" "$tmp" >/dev/null; then
        printf 'secureboot: signature verification failed for %s\n' "$f" >&2
        exit 1
    fi

    mv -- "$tmp" "$f"
    tmp=
done
