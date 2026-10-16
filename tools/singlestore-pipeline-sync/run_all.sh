#!/usr/bin/env bash
# Export SingleStore pipelines, then re-apply them.
#   bash run_all.sh            -> export + apply
#   bash run_all.sh --dry-run  -> export + list statements only (nothing executed)
set -e
cd "$(dirname "$0")"

DRY_RUN=""
[ "$1" = "--dry-run" ] && DRY_RUN="--dry-run"

read -p    "SingleStore host     : " SINGLESTORE_HOST
read -p    "SingleStore user     : " SINGLESTORE_USER
read -p    "SingleStore database : " SINGLESTORE_DATABASE
read -s -p "SingleStore password : " SINGLESTORE_PASSWORD; echo
export SINGLESTORE_HOST SINGLESTORE_USER SINGLESTORE_DATABASE SINGLESTORE_PASSWORD

PYTHON_CMD=$(command -v py || command -v python3 || command -v python)

"$PYTHON_CMD" export_pipelines.py --out pipelines.sql
"$PYTHON_CMD" run_sql_file.py --file pipelines.sql $DRY_RUN

