#!/usr/bin/env python3
"""
Export SingleStore pipeline definitions (single self-contained file).

What it does:
  1. Connects to SingleStore using the connection details below.
  2. Runs `SHOW PIPELINES` against the target database.
  3. For every pipeline found, runs `SHOW CREATE PIPELINE <name>`.
  4. Writes every CREATE PIPELINE statement, concatenated, into one .sql file.

HOW TO USE:
  -> Just edit the CONFIG section right below with your details, then run:
         python export_pipelines.py
  (Environment variables, if set, will override these values. You can ignore
   env vars entirely and only edit the CONFIG section.)

Requires:
  pip install PyMySQL
"""

import argparse
import os
import sys
from datetime import datetime, timezone

# =============================================================================
# CONFIG - EDIT THESE VALUES (use the same details as your DBeaver connection)
# =============================================================================
HOST = ""                       # e.g. "svc-abc123.aws.singlestore.com"
PORT = "3306"                               # e.g. 3306
USER = ""                       # e.g. "admin"
PASSWORD = ""               # your password
DEFAULT_DATABASE = ""
# Optional: set a fixed output file path. Leave as None for an auto-named file.
OUTPUT_FILE = None                    # e.g. r"C:\temp\pipelines.sql"
# =============================================================================

try:
    import pymysql
except ImportError:
    sys.exit(
        "PyMySQL is not installed. Run:\n"
        "    pip install PyMySQL"
    )


def get_connection(database: str):
    """Create a SingleStore/MySQL connection.

    Uses the CONFIG values above; environment variables override them if set.
    """
    host = os.environ.get("SINGLESTORE_HOST", HOST)
    user = os.environ.get("SINGLESTORE_USER", USER)
    password = os.environ.get("SINGLESTORE_PASSWORD", PASSWORD)
    port = int(os.environ.get("SINGLESTORE_PORT", str(PORT)))

    placeholders = {
        "HOST": (host, "your-host"),
        "USER": (user, "your-user"),
        "PASSWORD": (password, "your-password"),
    }
    unset = [name for name, (val, default) in placeholders.items() if not val or val == default]
    if unset:
        sys.exit(
            "Please edit the CONFIG section at the top of this script and set: "
            + ", ".join(unset)
            + "\n(Or provide them via environment variables SINGLESTORE_HOST / _USER / _PASSWORD.)"
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
    )


def get_pipeline_names(cursor) -> list:
    """Return the list of pipeline names from SHOW PIPELINES.

    SHOW PIPELINES returns the pipeline name in the first column
    (e.g. 'Pipelines_in_<db>'), followed by State, Scheduled, etc.
    """
    cursor.execute("SHOW PIPELINES")
    rows = cursor.fetchall()
    return [row[0] for row in rows]


def get_create_statement(cursor, pipeline_name: str) -> str:
    """Return the CREATE PIPELINE statement for a given pipeline.

    SHOW CREATE PIPELINE returns columns: Pipeline, Create Pipeline, ...
    We locate the column whose header contains 'Create'.
    """
    cursor.execute(f"SHOW CREATE PIPELINE `{pipeline_name}`")
    row = cursor.fetchone()
    if row is None:
        return ""

    col_names = [desc[0] for desc in cursor.description]
    create_idx = next(
        (i for i, name in enumerate(col_names) if "create" in name.lower()),
        1 if len(row) > 1 else 0,
    )
    return row[create_idx]


def make_runnable(create_sql: str) -> str:
    """Make a CREATE PIPELINE statement re-runnable (idempotent).

    SHOW CREATE PIPELINE returns either:
        CREATE PIPELINE `name` ...
        CREATE AGGREGATOR PIPELINE `name` ...
    Running those as-is fails if the pipeline already exists. We convert the
    leading `CREATE ` into `CREATE OR REPLACE ` so the script can be executed
    directly and repeatedly without errors.
    """
    stmt = create_sql.lstrip()
    upper = stmt.upper()
    if upper.startswith("CREATE OR REPLACE"):
        return stmt  # already idempotent
    if upper.startswith("CREATE "):
        # Replace only the first occurrence of the leading keyword.
        return "CREATE OR REPLACE " + stmt[len("CREATE "):]
    return stmt


def main():
    parser = argparse.ArgumentParser(
        description="Export SingleStore CREATE PIPELINE statements to a single .sql file."
    )
    parser.add_argument(
        "--database",
        default=os.environ.get("SINGLESTORE_DATABASE", DEFAULT_DATABASE),
        help=f"Database to inspect (default: {DEFAULT_DATABASE}).",
    )
    parser.add_argument(
        "--out",
        default=OUTPUT_FILE,
        help="Output .sql file path (default: ./<database>_pipelines_<UTC timestamp>.sql).",
    )
    args = parser.parse_args()

    database = args.database
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    out_path = args.out or f"{database}_pipelines_{timestamp}.sql"

    print(f"Connecting to SingleStore, database = {database} ...")
    conn = get_connection(database)
    try:
        with conn.cursor() as cursor:
            names = get_pipeline_names(cursor)
            print(f"Found {len(names)} pipeline(s) in '{database}'.")
            if not names:
                print("Nothing to export.")
                return

            written = 0
            with open(out_path, "w", encoding="utf-8") as f:
                f.write(f"-- SingleStore pipeline export (runnable / idempotent)\n")
                f.write(f"-- Database : {database}\n")
                f.write(f"-- Generated: {timestamp} (UTC)\n")
                f.write(f"-- Pipelines: {len(names)}\n")
                f.write(f"-- Note     : statements use CREATE OR REPLACE so this file\n")
                f.write(f"--            can be executed directly and repeatedly.\n")
                f.write(f"USE `{database}`;\n\n")

                for name in names:
                    print(f"  - exporting {name}")
                    create_sql = get_create_statement(cursor, name).strip()
                    create_sql = make_runnable(create_sql)
                    f.write("-- " + "=" * 70 + "\n")
                    f.write(f"-- Pipeline: {name}\n")
                    f.write("-- " + "=" * 70 + "\n")
                    if create_sql:
                        f.write(create_sql)
                        if not create_sql.endswith(";"):
                            f.write(";")
                        f.write("\n\n")
                        written += 1
                    else:
                        f.write(f"-- (No CREATE statement returned for {name})\n\n")

            print(f"\nDone. Wrote {written} pipeline definition(s) to:\n  {os.path.abspath(out_path)}")
    finally:
        conn.close()


if __name__ == "__main__":
    main()

