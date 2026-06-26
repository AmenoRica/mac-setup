#!/usr/bin/env bash
set -euo pipefail

FONT_DIR="${HOME}/Library/Fonts"
DOWNLOAD_URL="${NERD_SYMBOLS_URL:-https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$FONT_DIR"

if ls "$FONT_DIR"/SymbolsNerdFont*.ttf >/dev/null 2>&1; then
  echo "Symbols Nerd Font is already installed."
  exit 0
fi

echo "Downloading Symbols Nerd Font from Nerd Fonts."
curl -fL "$DOWNLOAD_URL" -o "$TMP_DIR/NerdFontsSymbolsOnly.zip"
unzip -q "$TMP_DIR/NerdFontsSymbolsOnly.zip" -d "$TMP_DIR/symbols"
find "$TMP_DIR/symbols" -type f -name 'SymbolsNerdFont*.ttf' -exec cp {} "$FONT_DIR" \;

if ! ls "$FONT_DIR"/SymbolsNerdFont*.ttf >/dev/null 2>&1; then
  echo "Symbols Nerd Font download did not contain SymbolsNerdFont*.ttf."
  exit 1
fi

echo "Installed Symbols Nerd Font."
