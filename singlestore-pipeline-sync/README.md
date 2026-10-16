# SingleStore pipeline sync

Exports all pipelines from a database to `pipelines.sql`, then re-applies them.

```bash
pip install PyMySQL
bash run_all.sh            # export + apply
bash run_all.sh --dry-run  # export + preview statements, nothing executed
```

You will be prompted for host, user, database and password (password is not echoed or saved).

## Run as a Databricks App (web form, no cluster)

1. Upload this folder to your workspace (e.g. `/Workspace/Users/<you>/singlestore-pipeline-sync`).
2. Databricks → **Apps** → **Create app** → **Custom** → name it, choose the folder above as source → **Deploy**.
3. Open the app URL, fill in host / user / password / database, tick **Dry run** first, click **Run**.

The app runs the two scripts above directly; the password stays in memory for the request only.
Share the app URL with teammates via the app's **Permissions** (CAN USE).

