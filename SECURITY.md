# Security Policy

## Supported configuration

This repository is primarily configured for the author's Arch Linux system. It
includes user configuration, system-wide configuration, and chezmoi lifecycle
scripts. Review the source and proposed changes before applying them; do not
assume every file is safe or suitable for another system.

## Applying this repository safely

- Initialize without applying, then inspect `chezmoi diff` before making
  changes to your home directory.
- Apply only configurations you understand and need. On a non-Arch system,
  exclude lifecycle scripts and review each selected target for compatibility.
- The system installers target Arch Linux and `/etc`; they may use `doas` to
  modify system files. Do not run them on other systems.
- Treat encrypted files and rendered templates as sensitive. Keep decryption
  identities and plaintext secrets out of Git and public issue reports.
- If sensitive data is exposed, rotate or revoke affected credentials, then
  contact the maintainer and GitHub Support as appropriate. Removing a file
  from the latest revision does not remove it from Git history, forks, or
  existing clones.

