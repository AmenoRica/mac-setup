#!/usr/bin/env bash
set -euo pipefail

CODE_BIN="${CODE_BIN:-code}"
if ! command -v "$CODE_BIN" >/dev/null 2>&1; then
  CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

if [[ ! -x "$CODE_BIN" && "$CODE_BIN" == /* ]]; then
  echo "VS Code CLI not found."
  exit 1
fi

"$CODE_BIN" --install-extension Catppuccin.catppuccin-vsc
"$CODE_BIN" --install-extension vscodevim.vim

SETTINGS_DIR="${VSCODE_SETTINGS_DIR:-${HOME}/Library/Application Support/Code/User}"
SETTINGS_FILE="${SETTINGS_DIR}/settings.json"
mkdir -p "$SETTINGS_DIR"

NODE_BIN="${NODE_BIN:-}"
if [[ -z "$NODE_BIN" ]]; then
  if command -v node >/dev/null 2>&1; then
    NODE_BIN="$(command -v node)"
  elif [[ -x /Applications/Codex.app/Contents/Resources/cua_node/bin/node ]]; then
    NODE_BIN="/Applications/Codex.app/Contents/Resources/cua_node/bin/node"
  else
    echo "Node.js is required to update VS Code settings."
    exit 1
  fi
fi

VSCODE_SETTINGS_FILE="$SETTINGS_FILE" "$NODE_BIN" <<'EOF'
const fs = require("node:fs");
const path = process.env.VSCODE_SETTINGS_FILE;

let settings = {};
if (fs.existsSync(path)) {
  const raw = fs.readFileSync(path, "utf8").trim();
  settings = raw.length === 0 ? {} : JSON.parse(raw);
}

delete settings["editor.disableMonospaceOptimizations"];
delete settings["editor.experimentalGpuAcceleration"];

Object.assign(settings, {
  "workbench.colorTheme": "Catppuccin Latte",
  "catppuccin.accentColor": "rosewater",
  "editor.accessibilitySupport": "off",
  "editor.fontFamily": "'Yutapon Coding VSCode Integrated', 'Symbols Nerd Font', Menlo, Monaco, 'Courier New', monospace",
  "editor.lineNumbers": "relative",
  "editor.renderWhitespace": "boundary",
  "editor.renderControlCharacters": false,
  "editor.experimentalWhitespaceRendering": "svg",
  "terminal.integrated.fontFamily": "'Yutapon Coding VSCode Integrated', 'Symbols Nerd Font', monospace"
});

fs.writeFileSync(path, `${JSON.stringify(settings, null, 4)}\n`);
EOF

echo "Applied VS Code Catppuccin Latte theme with Rosewater accent."
