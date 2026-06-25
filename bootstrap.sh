#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required before running this script."
  echo "Install it from https://brew.sh, then run ./bootstrap.sh again."
  exit 1
fi

brew update
brew bundle --file "${ROOT_DIR}/Brewfile"

echo "Bootstrap complete."
