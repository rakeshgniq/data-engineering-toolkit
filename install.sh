#!/usr/bin/env bash
# Data Engineering Toolkit - installer
#
#   curl -sL https://raw.githubusercontent.com/rakeshgniq/data-engineering-toolkit/main/install.sh | bash -s <tool-name>
#
# Downloads tools/<tool-name>/ from the repo into ~/data-engineering-toolkit/<tool-name>
# and installs its Python requirements. Re-run to update.
set -e

REPO="rakeshgniq/data-engineering-toolkit"
BRANCH="${TOOLKIT_BRANCH:-main}"
TOOL="$1"
DEST="${TOOLKIT_HOME:-$HOME/data-engineering-toolkit}"

if [ -z "$TOOL" ]; then
  echo "Usage: install.sh <tool-name>"
  echo "Tools: https://${REPO%%/*}.github.io/${REPO##*/}/"
  exit 1
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Downloading $TOOL from $REPO@$BRANCH ..."
curl -sL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" | tar -xz -C "$TMP"

SRC="$TMP/${REPO##*/}-$BRANCH/tools/$TOOL"
[ -d "$SRC" ] || { echo "Tool '$TOOL' not found in repo."; exit 1; }

mkdir -p "$DEST"
rm -rf "$DEST/$TOOL"
cp -r "$SRC" "$DEST/$TOOL"

PYTHON_CMD=$(command -v py || command -v python3 || command -v python || true)
if [ -n "$PYTHON_CMD" ] && [ -f "$DEST/$TOOL/requirements.txt" ]; then
  echo "Installing Python requirements ..."
  "$PYTHON_CMD" -m pip install -q -r "$DEST/$TOOL/requirements.txt"
fi

echo
echo "Installed to: $DEST/$TOOL"
echo "Next:  cd $DEST/$TOOL && bash run_all.sh --dry-run"

