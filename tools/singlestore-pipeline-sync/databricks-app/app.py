thin"""
Databricks App: web form to export SingleStore pipelines and re-apply them.

Runs export_pipelines.py then run_sql_file.py (both unchanged) as subprocesses.
Connection details are typed into the form and passed to the scripts via
environment variables only - the password is never written to disk or logged.
"""

import os
import subprocess
import sys
import tempfile

import streamlit as st

HERE = os.path.dirname(os.path.abspath(__file__))
EXPORT_SCRIPT = os.path.join(HERE, "export_pipelines.py")
RUN_SCRIPT = os.path.join(HERE, "run_sql_file.py")

st.set_page_config(page_title="SingleStore Pipeline Sync", page_icon="🔁")
st.title("SingleStore Pipeline Sync")
st.caption("Export all pipelines from a database, then re-apply them (CREATE OR REPLACE).")

with st.form("conn"):
    host = st.text_input("Host", placeholder="svc-xxx.singlestore.com")
    port = st.text_input("Port", value="3306")
    user = st.text_input("User")
    password = st.text_input("Password", type="password")
    database = st.text_input("Database")
    dry_run = st.checkbox("Dry run (export + preview only, execute nothing)", value=True)
    submitted = st.form_submit_button("Run")


def run(cmd: list, env: dict) -> int:
    """Run a command, stream its output into the page, return exit code."""
    box = st.empty()
    lines = []
    proc = subprocess.Popen(
        cmd, env=env, cwd=HERE,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1,
    )
    for line in proc.stdout:
        lines.append(line.rstrip())
        box.code("\n".join(lines[-200:]))
    proc.wait()
    return proc.returncode


if submitted:
    missing = [n for n, v in {"Host": host, "User": user, "Password": password, "Database": database}.items() if not v]
    if missing:
        st.error("Please fill in: " + ", ".join(missing))
        st.stop()

    env = os.environ.copy()
    env.update({
        "SINGLESTORE_HOST": host,
        "SINGLESTORE_PORT": port,
        "SINGLESTORE_USER": user,
        "SINGLESTORE_PASSWORD": password,
        "SINGLESTORE_DATABASE": database,
    })

    with tempfile.TemporaryDirectory() as tmp:
        out_file = os.path.join(tmp, "pipelines.sql")

        st.subheader("Step 1 - Export")
        rc = run([sys.executable, EXPORT_SCRIPT, "--database", database, "--out", out_file], env)
        if rc != 0 or not os.path.isfile(out_file):
            st.error("Export failed - nothing applied.")
            st.stop()

        with open(out_file, encoding="utf-8") as f:
            st.download_button("Download pipelines.sql", f.read(), file_name="pipelines.sql")

        st.subheader("Step 2 - " + ("Dry run" if dry_run else "Apply"))
        cmd = [sys.executable, RUN_SCRIPT, "--file", out_file, "--database", database]
        if dry_run:
            cmd.append("--dry-run")
        rc = run(cmd, env)

    if rc == 0:
        st.success("Done." + (" (dry run - nothing executed)" if dry_run else ""))
    else:
        st.error("Some statements failed - see output above.")

