#!/bin/sh
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


efibootmgr --create --disk /dev/sda --part 1 --label "Abdullah's Encrypted ArchLinux" --loader /vmlinuz-linux --unicode 'cryptdevice=UUID=0914303a-e5ad-47f1-95ad-02fdbc469d25:cryptlvm root=UUID=2ac45312-1f1a-4af9-a744-00806a7cbc73 rw splash ipv6.disable=1 nmi_watchdog=0 consoleblank=60 acpi_backlight=thinkpad_acpi i915.i915_enable_fbc=1 i915.i915_enable_rc6=1 initrd=\intel-ucode.img initrd=\initramfs-linux.img resume=UUID=a65c01e6-084f-40d4-8304-cba022dff8ae' --verbose
