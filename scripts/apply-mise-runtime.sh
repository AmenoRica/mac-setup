#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
MISE_DIR="${CONFIG_HOME}/mise"
MISE_CONFIG="${MISE_DIR}/config.toml"
ZSHRC="${ZSHRC:-${HOME}/.zshrc}"
MISE_BIN="$(command -v mise || true)"

if [[ -z "$MISE_BIN" && -x /opt/homebrew/bin/mise ]]; then
  MISE_BIN="/opt/homebrew/bin/mise"
fi

if [[ -z "$MISE_BIN" ]]; then
  echo "mise is required before applying runtime settings."
  exit 1
fi

mkdir -p "$MISE_DIR"
cp "${ROOT_DIR}/config/mise/config.toml" "$MISE_CONFIG"

touch "$ZSHRC"
if ! grep -Fq 'eval "$(mise activate zsh)"' "$ZSHRC"; then
  printf '\n%s\n' 'eval "$(mise activate zsh)"' >> "$ZSHRC"
fi

"$MISE_BIN" install

cleanup_homebrew_runtime() {
  local formula="$1"
  local dependents=""

  if ! brew list --formula "$formula" >/dev/null 2>&1; then
    return
  fi

  dependents="$(brew uses --installed "$formula" || true)"
  if [[ -n "$dependents" ]]; then
    echo "Keeping Homebrew ${formula}; installed formulae depend on it:"
    printf '%s\n' "$dependents"
    return
  fi

  brew uninstall "$formula"
}

cleanup_homebrew_runtime "node"
cleanup_homebrew_runtime "npm"
cleanup_homebrew_runtime "python@3.14"

echo "Applied mise runtime settings."
