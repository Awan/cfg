#!/bin/bash
set -euo pipefail
KEY=/etc/secureboot/keys/db.key
CERT=/etc/secureboot/keys/db.crt

for f in /boot/EFI/Linux/arch-linux.efi \
         /boot/EFI/Linux/arch-linux-fallback.efi \
         /boot/EFI/systemd/systemd-bootx64.efi \
         /boot/EFI/BOOT/BOOTX64.EFI; do
    [ -f "$f" ] || continue
    sbverify --cert "$CERT" "$f" &>/dev/null && continue   # already signed, skip
    sbsign --key "$KEY" --cert "$CERT" --output "$f.signed" "$f"
    mv "$f.signed" "$f"
done
