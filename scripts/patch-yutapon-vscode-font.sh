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
FONT_DIR="${HOME}/Library/Fonts"
OUTPUT_DIR="$FONT_DIR"

if [[ ! -f "$REGULAR_SOURCE" ]]; then
  echo "Yutapon Coding font is not installed. Skipping VS Code font patch."
  exit 0
fi

"$FONTTOOLS_PYTHON" - "$REGULAR_SOURCE" "$BOLD_SOURCE" "$FONT_DIR" "$OUTPUT_DIR" <<'PY'
from pathlib import Path
import sys
import tempfile
import unicodedata

from fontTools import subset
from fontTools.merge import Merger
from fontTools.ttLib import TTFont
from fontTools.ttLib.scaleUpem import scale_upem

regular_source = Path(sys.argv[1])
bold_source = Path(sys.argv[2])
font_dir = Path(sys.argv[3])
output_dir = Path(sys.argv[4])

patched_jobs = [(regular_source, "Regular", "YutaponCodingVSCode-Regular.ttf")]
if bold_source.exists():
    patched_jobs.append((bold_source, "Bold", "YutaponCodingVSCode-Bold.ttf"))

patched_family = "Yutapon Coding VSCode"
integrated_family = "Yutapon Coding VSCode Integrated"

hangul_ranges = (
    (0x1100, 0x11FF),
    (0x3130, 0x318F),
    (0xA960, 0xA97F),
    (0xAC00, 0xD7AF),
    (0xD7B0, 0xD7FF),
)
nerd_ranges = (
    (0xE000, 0xF8FF),
    (0xF0000, 0xFFFFD),
    (0x100000, 0x10FFFD),
)

def replace_name_record(record, value):
    record.string = value.encode(record.getEncoding(), errors="replace")

def set_names(font, family, style):
    full_name = f"{family} {style}"
    postscript_name = full_name.replace(" ", "-")
    replacements = {
        1: family,
        2: style,
        3: full_name,
        4: full_name,
        6: postscript_name,
        16: family,
        17: style,
    }

    for record in font["name"].names:
        if record.nameID in replacements:
            replace_name_record(record, replacements[record.nameID])

def patch_nbsp(font, source):
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

def drop_auxiliary_tables(font):
    for tag in ("FFTM", "PfEd", "gasp"):
        if tag in font:
            del font[tag]

def find_font(pattern, needle=None):
    for path in sorted(font_dir.glob(pattern)):
        if needle is None:
            return path
        if needle in unicodedata.normalize("NFC", path.name):
            return path
    return None

def unicodes_from_ranges(font_path, ranges):
    font = TTFont(font_path)
    codepoints = set()
    for table in font["cmap"].tables:
        if not table.isUnicode():
            continue
        for codepoint in table.cmap:
            if any(start <= codepoint <= end for start, end in ranges):
                codepoints.add(codepoint)
    font.close()
    return codepoints

def subset_font(font_path, ranges, target_upem):
    font = TTFont(font_path)
    options = subset.Options()
    options.ignore_missing_glyphs = True
    options.retain_gids = False
    options.recalc_bounds = True
    options.recalc_timestamp = False
    options.layout_features = ["*"]
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=unicodes_from_ranges(font_path, ranges))
    subsetter.subset(font)
    if font["head"].unitsPerEm != target_upem:
        scale_upem(font, target_upem)
    drop_auxiliary_tables(font)
    return font

def save_patched_font(source, style, output_name):
    font = TTFont(source)
    patch_nbsp(font, source)
    drop_auxiliary_tables(font)
    set_names(font, patched_family, style)
    output_path = output_dir / output_name
    font.save(output_path)
    print(f"Patched {source.name} -> {output_path}")
    font.close()
    return output_path

korean_source = find_font("*.ttf", "온글잎 긍정")
symbols_source = find_font("SymbolsNerdFont-Regular.ttf")

patched_outputs = {}
for source, style, output_name in patched_jobs:
    patched_outputs[style] = save_patched_font(source, style, output_name)

if not korean_source:
    print("Ownglyph GeungJeong font is not installed. Skipping integrated font.")
    raise SystemExit(0)

if not symbols_source:
    print("Symbols Nerd Font is not installed. Skipping integrated font.")
    raise SystemExit(0)

with tempfile.TemporaryDirectory() as temp_dir_name:
    temp_dir = Path(temp_dir_name)
    for style, patched_path in patched_outputs.items():
        base_upem = TTFont(patched_path)["head"].unitsPerEm
        korean_font = subset_font(korean_source, hangul_ranges, base_upem)
        symbols_font = subset_font(symbols_source, nerd_ranges, base_upem)
        korean_subset_path = temp_dir / f"korean-{style}.ttf"
        symbols_subset_path = temp_dir / f"symbols-{style}.ttf"
        korean_font.save(korean_subset_path)
        symbols_font.save(symbols_subset_path)
        korean_font.close()
        symbols_font.close()

        merged = Merger().merge([patched_path, korean_subset_path, symbols_subset_path])
        set_names(merged, integrated_family, style)

        output_name = f"YutaponCodingVSCodeIntegrated-{style}.ttf"
        output_path = output_dir / output_name
        merged.save(output_path)
        print(f"Integrated {patched_path.name}, {korean_source.name}, {symbols_source.name} -> {output_path}")
        merged.close()
PY

echo "Patched Yutapon Coding VS Code font and generated integrated font when sources are available."
