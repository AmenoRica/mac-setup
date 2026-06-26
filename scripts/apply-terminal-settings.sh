#!/usr/bin/env bash
set -euo pipefail

CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
GHOSTTY_DIR="${CONFIG_HOME}/ghostty"
STARSHIP_CONFIG="${CONFIG_HOME}/starship.toml"
ZSHRC="${ZSHRC:-${HOME}/.zshrc}"
STARSHIP_BIN="$(command -v starship || true)"

if [[ -z "$STARSHIP_BIN" && -x /opt/homebrew/bin/starship ]]; then
  STARSHIP_BIN="/opt/homebrew/bin/starship"
fi

mkdir -p "$GHOSTTY_DIR" "$(dirname "$STARSHIP_CONFIG")"

cat > "${GHOSTTY_DIR}/config" <<'EOF'
theme = "Catppuccin Latte"

font-family = "Yutapon Coding VSCode Integrated"
font-family = "Symbols Nerd Font"
font-size = 23

background-opacity = 0.80
background-opacity-cells = true
background-blur = 30

window-padding-x = 150
window-padding-y = 75
window-padding-color = background

cursor-color = #dc8a78
selection-background = #dc8a78
selection-foreground = #eff1f5
EOF

if [[ -z "$STARSHIP_BIN" ]]; then
  echo "Starship is required before applying the terminal prompt preset."
  exit 1
fi

"$STARSHIP_BIN" preset jetpack -o "$STARSHIP_CONFIG"

touch "$ZSHRC"
if ! grep -Fq 'eval "$(starship init zsh)"' "$ZSHRC"; then
  printf '\n%s\n' 'eval "$(starship init zsh)"' >> "$ZSHRC"
fi

echo "Applied Ghostty and Starship settings."
