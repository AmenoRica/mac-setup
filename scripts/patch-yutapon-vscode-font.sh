#!/usr/bin/env bash
set -euo pipefail

FONTTOOLS_PYTHON="${FONTTOOLS_PYTHON:-}"
if [[ -z "$FONTTOOLS_PYTHON" ]]; then
  if [[ -x /opt/homebrew/opt/fonttools/libexec/bin/python3 ]]; then
    FONTTOOLS_PYTHON="/opt/homebrew/opt/fonttools/libexec/bin/python3"
  elif command -v python3 >/dev/null 2>&1 && python3 -c 'import fontTools' >/dev/null 2>&1; then
    FONTTOOLS_PYTHON="$(command -v python3)"
  else
    echo "fonttools is required to patch Yutapon for VS Code. Skipping."
    exit 0
  fi
fi

REGULAR_SOURCE="${HOME}/Library/Fonts/yutapon_coding_081d.ttf"
BOLD_SOURCE="${HOME}/Library/Fonts/yutapon_coding_bold_081d.ttf"
OUTPUT_DIR="${HOME}/Library/Fonts"

if [[ ! -f "$REGULAR_SOURCE" ]]; then
  echo "Yutapon Coding font is not installed. Skipping VS Code font patch."
  exit 0
fi

"$FONTTOOLS_PYTHON" - "$REGULAR_SOURCE" "$BOLD_SOURCE" "$OUTPUT_DIR" <<'PY'
from pathlib import Path
import sys

from fontTools.ttLib import TTFont

regular_source = Path(sys.argv[1])
bold_source = Path(sys.argv[2])
output_dir = Path(sys.argv[3])

jobs = [(regular_source, "Regular", "YutaponCodingVSCode-Regular.ttf")]
if bold_source.exists():
    jobs.append((bold_source, "Bold", "YutaponCodingVSCode-Bold.ttf"))

family = "Yutapon Coding VSCode"

def replace_name_record(record, value):
    record.string = value.encode(record.getEncoding(), errors="replace")

for source, style, output_name in jobs:
    font = TTFont(source)

    space_glyph = None
    for table in font["cmap"].tables:
        if table.isUnicode():
            space_glyph = table.cmap.get(0x20)
            if space_glyph:
                break

    if not space_glyph:
        raise SystemExit(f"Could not find U+0020 glyph in {source}")

    for table in font["cmap"].tables:
        if table.isUnicode():
            table.cmap[0xA0] = space_glyph

    full_name = f"{family} {style}"
    postscript_name = full_name.replace(" ", "-")
    unique_id = full_name

    replacements = {
        1: family,
        2: style,
        3: unique_id,
        4: full_name,
        6: postscript_name,
        16: family,
        17: style,
    }

    for record in font["name"].names:
        if record.nameID in replacements:
            replace_name_record(record, replacements[record.nameID])

    output_path = output_dir / output_name
    font.save(output_path)
    print(f"Patched {source.name} -> {output_path}")
PY

echo "Patched Yutapon Coding VS Code font."
