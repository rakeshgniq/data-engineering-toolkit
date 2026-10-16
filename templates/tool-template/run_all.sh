#!/usr/bin/env bash
# <Tool Name> - entry point
#   bash run_all.sh            -> run
#   bash run_all.sh --dry-run  -> preview only
#
# Read inputs from env vars when present, otherwise prompt. Never echo secrets.
set -e
cd "$(dirname "$0")"

DRY_RUN=""
[ "$1" = "--dry-run" ] && DRY_RUN="--dry-run"

[ -z "$EXAMPLE_HOST" ]     && read -p    "Host     : " EXAMPLE_HOST
[ -z "$EXAMPLE_PASSWORD" ] && { read -s -p "Password : " EXAMPLE_PASSWORD; echo; }
export EXAMPLE_HOST EXAMPLE_PASSWORD

PYTHON_CMD=$(command -v py || command -v python3 || command -v python)

"$PYTHON_CMD" main.py $DRY_RUN

