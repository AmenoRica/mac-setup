#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMEBREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$HOMEBREW_SHELLENV"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required before running this script."
  echo "Install it from https://brew.sh, then run ./bootstrap.sh again."
  exit 1
fi

touch "${HOME}/.zprofile"
if ! grep -Fq "$HOMEBREW_SHELLENV" "${HOME}/.zprofile"; then
  printf '\n%s\n' "$HOMEBREW_SHELLENV" >> "${HOME}/.zprofile"
fi

brew update
brew bundle --file "${ROOT_DIR}/Brewfile"

"${ROOT_DIR}/scripts/apply-codex-theme.sh"
"${ROOT_DIR}/scripts/apply-vscode-settings.sh"
"${ROOT_DIR}/scripts/apply-terminal-settings.sh"

echo "Bootstrap complete."
