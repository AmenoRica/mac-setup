#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Mac setup bootstrap"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required before running this script."
  echo "Install it from https://brew.sh, then run this script again."
  exit 1
fi

echo "==> Updating Homebrew"
brew update

echo "==> Installing Brewfile entries"
brew bundle --file "${ROOT_DIR}/Brewfile"

if [[ "${RUN_MACOS_DEFAULTS:-0}" == "1" ]]; then
  echo "==> Applying macOS defaults"
  "${ROOT_DIR}/scripts/macos-defaults.sh"
else
  echo "==> Skipping macOS defaults"
  echo "Set RUN_MACOS_DEFAULTS=1 to apply scripts/macos-defaults.sh"
fi

echo "==> Done"

