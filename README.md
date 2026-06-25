# Mac Setup

Fresh Mac setup notes, scripts, and package lists.

The goal of this repository is simple:

1. Record every setup decision we make.
2. Keep setup commands repeatable.
3. Make the next Mac restore require as few manual steps as possible.

## Quick Start

On a new Mac:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone <this-repo-url> ~/mac-setup
cd ~/mac-setup
./scripts/bootstrap.sh
```

Replace `<this-repo-url>` after the GitHub repository is created.

## Repository Layout

- `Brewfile`: Homebrew packages, casks, and Mac App Store apps.
- `scripts/bootstrap.sh`: idempotent bootstrap entrypoint.
- `scripts/macos-defaults.sh`: macOS preference tweaks.
- `docs/setup-log.md`: chronological record of what changed and why.
- `docs/decisions.md`: durable decisions and tradeoffs.
- `CHECKLIST.md`: setup checklist for this Mac.

## Working Rule

When we install or configure something manually, we also update this repository
before moving on.

