#!/bin/sh -x
# shellcheck disable=2034
coded_by='

In the name of Allah, the most Gracious, the most Merciful.

 ▓▓▓▓▓▓▓▓▓▓
░▓ Author ▓ Abdullah <https://abdullah.today>
░▓▓▓▓▓▓▓▓▓▓ YouTube <https://YouTube.com/AbdullahToday>
░░░░░░░░░░

░█▀▀░█▀▀░▀█▀░█▀▀░▀█▀░█░█░█▀▄
░█▀▀░█▀▀░░█░░▀▀█░░█░░█░█░█▀▄
░▀▀▀░▀░░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀░
'


sudo efibootmgr --create --disk /dev/sda --part 1 --label "Abdullah's Encrypted ArchLinux" --loader /vmlinuz-linux --unicode 'cryptdevice=UUID=998b6b6f-c895-4e28-9c99-ec3e89a48ddc:cryptlvm root=UUID=87c40799-b141-48a5-a694-3384b0688f14 rw splash ipv6.disable=1 nmi_watchdog=0 consoleblank=60 acpi_backlight=thinkpad_acpi i915.i915_enable_fbc=1 i915.i915_enable_rc6=1 initrd=\intel-ucode.img initrd=\initramfs-linux.img resume=UUID=2bf653e3-e387-45b2-92ef-8740293859e2 psmouse-synaptics_intertouch=0 allow-discards' --verbose
