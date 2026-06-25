#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${CODEX_CONFIG_FILE:-${HOME}/.codex/config.toml}"
TMP_FILE="${CONFIG_FILE}.tmp"

mkdir -p "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"

awk '
  /^\[desktop\.appearanceLightChromeTheme\]/ { skip = 1; next }
  /^\[desktop\.appearanceLightChromeTheme\.fonts\]/ { skip = 1; next }
  /^\[desktop\.appearanceLightChromeTheme\.semanticColors\]/ { skip = 1; next }
  /^\[/ { skip = 0 }
  skip == 1 { next }
  /^\[desktop\]/ { in_desktop = 1; print; next }
  /^\[/ { in_desktop = 0 }
  in_desktop == 1 && /^appearanceTheme[[:space:]]*=/ { next }
  in_desktop == 1 && /^appearanceLightCodeThemeId[[:space:]]*=/ { next }
  { print }
' "$CONFIG_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$CONFIG_FILE"

if ! grep -q '^\[desktop\]' "$CONFIG_FILE"; then
  printf '\n[desktop]\n' >> "$CONFIG_FILE"
fi

awk '
  BEGIN { inserted = 0 }
  /^\[desktop\]/ {
    print
    print "appearanceTheme = \"light\""
    print "appearanceLightCodeThemeId = \"catppuccin\""
    inserted = 1
    next
  }
  { print }
  END {
    if (inserted == 0) {
      print ""
      print "[desktop]"
      print "appearanceTheme = \"light\""
      print "appearanceLightCodeThemeId = \"catppuccin\""
    }
  }
' "$CONFIG_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$CONFIG_FILE"

cat >> "$CONFIG_FILE" <<'EOF'

[desktop.appearanceLightChromeTheme]
accent = "#dc8a78"
contrast = 40
ink = "#4c4f69"
opaqueWindows = false
surface = "#eff1f5"

[desktop.appearanceLightChromeTheme.fonts]

[desktop.appearanceLightChromeTheme.semanticColors]
diffAdded = "#40a02b"
diffRemoved = "#d20f39"
skill = "#dc8a78"
EOF

echo "Applied Codex Catppuccin Latte theme with Rosewater accent."
