#!/usr/bin/env python3
"""
Execute a .sql file against SingleStore, statement by statement.

What it does:
  1. Reads a .sql file (e.g. the pipeline export produced by export_pipelines.py).
  2. Strips full-line `--` comments and blank lines.
  3. Splits the script into individual statements on `;`.
  4. Executes each statement against SingleStore, printing progress.
  5. Prints a summary (succeeded / failed). Optionally stops on first error.

HOW TO USE:
  -> Edit the CONFIG section below with your connection details, then run:
         py run_sql_file.py --file pick_n_pay__validation_pipelines_20260617T083748Z.sql

Requires:
  pip install PyMySQL
"""

import argparse
import os
import sys

# =============================================================================
# CONFIG - EDIT THESE VALUES (use the same details as your DBeaver connection)
# =============================================================================
HOST = ""                       # e.g. "svc-abc123.aws.singlestore.com"
PORT = "3306"                                # e.g. 3306
USER = ""                       # e.g. "admin"
PASSWORD = ""               # your password
DEFAULT_DATABASE = ""
# If True, keep going when a statement fails; if False, stop on first error.
CONTINUE_ON_ERROR = True
# =============================================================================

try:
    import pymysql
except ImportError:
    sys.exit("PyMySQL is not installed. Run:\n    pip install PyMySQL")


def get_connection(database: str):
    """Create a SingleStore/MySQL connection (env vars override CONFIG)."""
    host = os.environ.get("SINGLESTORE_HOST", HOST)
    user = os.environ.get("SINGLESTORE_USER", USER)
    password = os.environ.get("SINGLESTORE_PASSWORD", PASSWORD)
    port = int(os.environ.get("SINGLESTORE_PORT", str(PORT)))

    placeholders = {
        "HOST": (host, "your-host"),
        "USER": (user, "your-user"),
        "PASSWORD": (password, "your-password"),
    }
    unset = [n for n, (v, d) in placeholders.items() if not v or v == d]
    if unset:
        sys.exit(
            "Please edit the CONFIG section at the top of this script and set: "
            + ", ".join(unset)
        )

    return pymysql.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        database=database,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.Cursor,
        connect_timeout=30,
        autocommit=True,
    )


def split_statements(sql_text: str) -> list:
    """Split a SQL script into statements.

    - Removes full-line comments (lines whose first non-space chars are `--`).
    - Splits on `;`.
    These export files contain no semicolons inside a statement, so this is safe.
    """
    cleaned_lines = []
    for line in sql_text.splitlines():
        if line.lstrip().startswith("--"):
            continue
        cleaned_lines.append(line)
    cleaned = "\n".join(cleaned_lines)

    statements = []
    for raw in cleaned.split(";"):
        stmt = raw.strip()
        if stmt:
            statements.append(stmt)
    return statements


def short_label(stmt: str) -> str:
    """Make a one-line label for logging (first meaningful line, truncated)."""
    first_line = next((l.strip() for l in stmt.splitlines() if l.strip()), stmt)
    return (first_line[:90] + "...") if len(first_line) > 90 else first_line


def main():
    parser = argparse.ArgumentParser(
        description="Execute a .sql file against SingleStore, statement by statement."
    )
    parser.add_argument("--file", required=True, help="Path to the .sql file to execute.")
    parser.add_argument(
        "--database",
        default=os.environ.get("SINGLESTORE_DATABASE", DEFAULT_DATABASE),
        help=f"Database to connect to (default: {DEFAULT_DATABASE}).",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Parse and list statements without executing them.",
    )
    args = parser.parse_args()

    if not os.path.isfile(args.file):
        sys.exit(f"File not found: {args.file}")

    with open(args.file, "r", encoding="utf-8") as f:
        sql_text = f.read()

    statements = split_statements(sql_text)
    print(f"Parsed {len(statements)} statement(s) from {args.file}")

    if args.dry_run:
        for i, stmt in enumerate(statements, 1):
            print(f"  [{i}] {short_label(stmt)}")
        print("\nDry run only - nothing executed.")
        return

    print(f"Connecting to SingleStore, database = {args.database} ...")
    conn = get_connection(args.database)

    succeeded, failed = 0, 0
    failures = []
    try:
        with conn.cursor() as cursor:
            for i, stmt in enumerate(statements, 1):
                label = short_label(stmt)
                try:
                    cursor.execute(stmt)
                    # Drain any result set (e.g. from USE / informational stmts).
                    try:
                        cursor.fetchall()
                    except Exception:
                        pass
                    succeeded += 1
                    print(f"  [{i}/{len(statements)}] OK    : {label}")
                except Exception as exc:  # noqa: BLE001
                    failed += 1
                    failures.append((i, label, str(exc)))
                    print(f"  [{i}/{len(statements)}] FAIL  : {label}")
                    print(f"           -> {exc}")
                    if not CONTINUE_ON_ERROR:
                        print("\nStopping on first error (CONTINUE_ON_ERROR = False).")
                        break
    finally:
        conn.close()

    print("\n" + "=" * 60)
    print(f"Summary: {succeeded} succeeded, {failed} failed, {len(statements)} total")
    if failures:
        print("\nFailed statements:")
        for i, label, err in failures:
            print(f"  [{i}] {label}")
            print(f"       {err}")
    print("=" * 60)

    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()

