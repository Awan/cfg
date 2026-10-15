# Contributing

Thanks for considering a contribution. This repository is primarily the
maintainer's personal Arch Linux configuration, so changes should be focused
and should not assume that every configuration applies to every system.

## Before making a change

- Check whether the file is active or under `archive/`. Archived files are
  retained for reference and are not managed or deployed by chezmoi.
- Prefer small, focused changes that preserve existing behavior.
- Do not commit passwords, tokens, private keys, personal contact data, or
  decrypted contents of files managed with chezmoi encryption. Use the
  repository's existing secret-management patterns where needed.
- For changes intended for another operating system, keep the platform
  limitations clear and ensure they do not invoke Arch-specific installers.

## Review and test

Inspect the rendered changes before applying them:

```sh
chezmoi diff
chezmoi status
```

For a local change, run the relevant checks available on your system. The CI
workflow is the source of truth for the full checks; it validates active Zsh
and shell files, the Vim configuration, chezmoi source application, and
encrypted-file handling. In particular, CI runs:

```sh
git ls-files -z -- "*.zsh" ":!archive/**" | xargs -0 -r zsh -n
zsh -n dot_zshenv dot_zshrc dot_zprofile
git ls-files -z -- "*.sh" "*.sh.tmpl" "dot_xprofile" ":!archive/**" |
  xargs -0 -r shellcheck -S error
bash .github/scripts/check-shell-files
vim -Nu NONE -n -es -c 'set rtp^=./dot_vim' -c 'source dot_vimrc' -c 'qa!'
```

The complete CI workflow also checks chezmoi rendering and runs TruffleHog
secret scanning. Do not add exceptions for real credentials; report false
positives with a narrowly scoped exclusion when appropriate.

## Submitting a change

Use a descriptive commit message and explain the motivation, behavior change,
and any platform-specific assumptions in the pull request. Do not include
unrelated generated files or changes to live machine configuration.

