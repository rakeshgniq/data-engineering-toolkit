# <Tool Name>

One-paragraph description: what problem this tool solves and when to use it.

## Quick start (bash)

```bash
curl -sL https://raw.githubusercontent.com/rakeshgniq/data-engineering-toolkit/main/install.sh | bash -s <tool-folder-name>
cd ~/data-engineering-toolkit/<tool-folder-name>
bash run_all.sh --dry-run
bash run_all.sh
```

## Inputs

| Variable / flag | Required | Description |
|---|---|---|
| `EXAMPLE_HOST` | yes | Prompted if not set |
| `--dry-run` | no | Preview only |

## Files

| File | Purpose |
|---|---|
| `run_all.sh` | Entry point |
| `requirements.txt` | Python deps |

## Requirements

- Python 3.8+
- Network access to …

