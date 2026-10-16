# Data Engineering Toolkit

**Portal:** <https://rakeshgniq.github.io/data-engineering-toolkit/>

A centralized, self-service collection of bash-first utilities for Data Engineers.
Current focus: **SingleStore Pipeline Automation**. Every tool runs on the engineer's
own machine — no servers, no clusters, no stored credentials.

## Quick start

```bash
# install any tool (downloads tools/<name> to ~/data-engineering-toolkit/<name>)
curl -sL https://raw.githubusercontent.com/rakeshgniq/data-engineering-toolkit/main/install.sh | bash -s singlestore-pipeline-sync

cd ~/data-engineering-toolkit/singlestore-pipeline-sync
bash run_all.sh --dry-run
```

The portal's tool pages generate these commands for you from a small form.

## Repository structure

```
data-engineering-toolkit/
├── README.md
├── install.sh                 # curl-able installer: install.sh <tool-name>
├── tools/                     # one folder per utility
│   └── singlestore-pipeline-sync/
│       ├── README.md
│       ├── run_all.sh         # bash entry point (env vars or prompts)
│       ├── export_pipelines.py
│       ├── run_sql_file.py
│       ├── requirements.txt
│       └── databricks-app/    # optional Streamlit UI (same scripts)
├── templates/
│   └── tool-template/         # skeleton for new utilities
└── docs/                      # GitHub Pages site
    ├── index.html             # master index — rendered from tools.json
    ├── tools.json             # tool manifest (THE place to register a tool)
    ├── styles.css
    ├── script.js
    └── tools/
        └── singlestore-pipeline-sync.html
```

## Tools

| Tool | Status | Description |
|---|---|---|
| [singlestore-pipeline-sync](tools/singlestore-pipeline-sync) | stable | Export all `CREATE PIPELINE` definitions to an idempotent `.sql` and re-apply with dry-run |

## Adding a new tool

1. `cp -r templates/tool-template tools/<my-tool>` and implement it. Keep `run_all.sh`
   as the entry point; read inputs from env vars when present, otherwise prompt;
   never echo or store secrets.
2. Fill in `tools/<my-tool>/README.md` and `requirements.txt`.
3. Register it in `docs/tools.json` under `"tools"`:
   ```json
   {
     "id": "<my-tool>",            // must equal the folder name
     "name": "My Tool",
     "category": "singlestore",    // existing id, or add one under "categories"
     "icon": "tools",              // export | code | play | sync | tools | book
     "status": "beta",             // stable | beta | planned
     "summary": "One sentence.",
     "tags": ["..."],
     "page": "tools/<my-tool>.html",   // optional per-tool page, or null
     "repoPath": "tools/<my-tool>",
     "install": true
   }
   ```
4. (Optional) add `docs/tools/<my-tool>.html` — copy the pipeline-sync page as a starting point.
5. Push to `main`. The portal picks it up automatically; `install.sh <my-tool>` works immediately.

## Conventions

- **Bash only** for entry points (`run_all.sh`). Python for logic.
- Inputs via `UPPER_SNAKE` env vars with interactive fallback; passwords via `read -s`.
- Always support `--dry-run`.
- Never commit generated `.sql`, `.env` or credentials (see `.gitignore`).

## Publishing the portal (GitHub Pages)

Repo → **Settings → Pages → Build and deployment → Source: Deploy from a branch →
Branch: `main`, Folder: `/docs` → Save.** The site is live within ~1 minute at
<https://rakeshgniq.github.io/data-engineering-toolkit/> and redeploys on every push to `main`.

