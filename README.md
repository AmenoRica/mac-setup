# Mac Setup

Minimal, reproducible Mac setup.

## First Run

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone <this-repo-url> ~/mac-setup
cd ~/mac-setup
./bootstrap.sh
```

## Files

- `.gitignore`: ignored local files.
- `Brewfile`: Homebrew packages and apps.
- `README.md`: setup instructions.
- `bootstrap.sh`: setup entrypoint.

Add future files under subdirectories unless they are core entrypoint files.
