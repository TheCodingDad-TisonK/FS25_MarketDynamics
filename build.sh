#!/usr/bin/env bash
# build.sh — FS25_MarketDynamics
# Usage:
#   bash build.sh           → build zip only
#   bash build.sh --deploy  → build + copy to active mods folder

set -e

MOD_NAME="FS25_MarketDynamics"
DEPLOY_DIR="C:/Users/tison/Documents/My Games/FarmingSimulator2025/mods"
OUT_ZIP="${MOD_NAME}.zip"

INCLUDE=(
    main.lua
    modDesc.xml
    images/
    guiProfiles.xml
    src/
    gui/
    translations/
    xml/
)

echo "Building ${MOD_NAME}..."

# Filter to only existing paths
EXISTING=()
for item in "${INCLUDE[@]}"; do
    if [ -e "$item" ]; then
        EXISTING+=("$item")
    fi
done

# Remove old zip
rm -f "${OUT_ZIP}"

# Build with zip (preferred) or fall back to Python
PYTHON_CMD=""
if command -v python3 &>/dev/null; then PYTHON_CMD="python3"
elif command -v py &>/dev/null; then PYTHON_CMD="py"
elif command -v python &>/dev/null; then PYTHON_CMD="python"
fi

if command -v zip &>/dev/null; then
    zip -r "${OUT_ZIP}" "${EXISTING[@]}"
elif [ -n "$PYTHON_CMD" ]; then
    $PYTHON_CMD - "${OUT_ZIP}" "${EXISTING[@]}" <<'PYEOF'
import sys, zipfile, os, pathlib

out_zip  = sys.argv[1]
sources  = sys.argv[2:]

with zipfile.ZipFile(out_zip, "w", zipfile.ZIP_DEFLATED) as zf:
    for src in sources:
        p = pathlib.Path(src)
        if p.is_dir():
            for f in p.rglob("*"):
                if f.is_file():
                    arcname = str(f).replace("\\", "/")
                    zf.write(str(f), arcname)
        elif p.is_file():
            zf.write(str(p), str(p).replace("\\", "/"))

print(f"Created {out_zip}")
PYEOF
fi

echo "Built: ${OUT_ZIP}"

if [[ "$1" == "--deploy" ]]; then
    cp "${OUT_ZIP}" "${DEPLOY_DIR}/${OUT_ZIP}"
    echo "Deployed to: ${DEPLOY_DIR}"
fi
