# SingleStore Pipeline Sync

Exports every pipeline definition from a SingleStore database to `pipelines.sql`
(as `CREATE OR REPLACE PIPELINE …`) and then re-applies that file, statement by
statement. Use it to back up, review or re-deploy pipeline definitions.

## Quick start (local, bash)

```bash
# one-time install
curl -sL https://raw.githubusercontent.com/rakeshgniq/data-engineering-toolkit/main/install.sh | bash -s singlestore-pipeline-sync

cd ~/data-engineering-toolkit/singlestore-pipeline-sync
bash run_all.sh --dry-run   # export + preview statements, nothing executed
bash run_all.sh             # export + apply
```

You are prompted for host, user, database and password. The password is never
echoed, stored or logged. To skip the prompts, pre-set the variables:

```bash
SINGLESTORE_HOST=svc-xxx.singlestore.com SINGLESTORE_USER=admin SINGLESTORE_DATABASE=mydb bash run_all.sh --dry-run
```

(Password is still prompted unless `SINGLESTORE_PASSWORD` is exported.)

The portal page generates these commands for you:
<https://rakeshgniq.github.io/data-engineering-toolkit/tools/singlestore-pipeline-sync.html>

## Files

| File | Purpose |
|---|---|
| `run_all.sh` | Orchestrates export → apply. Reads `SINGLESTORE_*` env vars or prompts. |
| `export_pipelines.py` | `SHOW PIPELINES` + `SHOW CREATE PIPELINE` → `pipelines.sql` |
| `run_sql_file.py` | Executes a `.sql` file statement by statement (`--dry-run` supported) |
| `requirements.txt` | `PyMySQL` |
| `databricks-app/` | Optional Streamlit front-end for Databricks Apps (same scripts, web form) |

## Requirements

- Python 3.8+ and `pip install -r requirements.txt`
- Network access to the SingleStore host on port 3306 (VPN / internal DNS)
- Git Bash or WSL on Windows

