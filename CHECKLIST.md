# Setup Checklist

## Foundation

- [ ] Sign in to Apple ID.
- [ ] Install command line developer tools.
- [ ] Install Homebrew.
- [ ] Create or connect the GitHub repository.
- [ ] Run `./scripts/bootstrap.sh`.

## Shell And Terminal

- [ ] Choose default shell configuration.
- [ ] Configure terminal app and font.
- [ ] Add shell aliases and environment variables.

## Development

- [ ] Install language runtimes.
- [ ] Configure Git identity and signing.
- [ ] Configure editor.
- [ ] Configure SSH keys.
- [ ] Configure GitHub CLI authentication.

## Apps

- [ ] Add required apps to `Brewfile`.
- [ ] Install App Store apps through `mas`, if needed.
- [ ] Record license-only or manual-download apps in `docs/setup-log.md`.

## macOS Preferences

- [ ] Review `scripts/macos-defaults.sh`.
- [ ] Run macOS defaults script.
- [ ] Restart affected apps or reboot.

## Verification

- [ ] Run `brew bundle check`.
- [ ] Confirm GitHub clone works on a clean machine.
- [ ] Confirm bootstrap script is safe to re-run.

