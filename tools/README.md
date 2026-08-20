# Doctrine Bootstrap Tools

Bootstrap scripts copy the public doctrine baseline into another repository so AI agents and contributors follow the same engineering rules.

## Scripts

- `doctrine-bootstrap.sh` for macOS/Linux (Bash)
- `doctrine-bootstrap.ps1` for Windows PowerShell (also works with PowerShell Core on macOS/Linux)
- `doctrine-bootstrap.cmd` wrapper for Windows Command Prompt

## Usage

### Bash

```bash
./tools/doctrine-bootstrap.sh /path/to/target-repo
./tools/doctrine-bootstrap.sh --force /path/to/target-repo
./tools/doctrine-bootstrap.sh --refresh-baseline /path/to/target-repo
```

### PowerShell

```powershell
.\tools\doctrine-bootstrap.ps1 -TargetRepo C:\path\to\target-repo
.\tools\doctrine-bootstrap.ps1 -TargetRepo C:\path\to\target-repo -Force
.\tools\doctrine-bootstrap.ps1 -TargetRepo C:\path\to\target-repo -RefreshBaseline
```

### CMD

```cmd
tools\doctrine-bootstrap.cmd C:\path\to\target-repo
tools\doctrine-bootstrap.cmd -Force C:\path\to\target-repo
tools\doctrine-bootstrap.cmd -RefreshBaseline C:\path\to\target-repo
```

## Files Copied

- `AGENTS.md`
- `AI_CONTEXT.md`
- `docs/doctrine/*.md` doctrine snapshot files
- `docs/doctrine/templates/*.md` helper templates

`project-context-template.md` and `CLAUDE.md` are exported as snapshot
templates only. Bootstrap does not create root `PROJECT_CONTEXT.md` or
`CLAUDE.md`, because both require project-specific evidence.

`--refresh-baseline` / `-RefreshBaseline` refreshes only
`docs/doctrine/` content, including helper templates. It preserves root
`AGENTS.md`, `CLAUDE.md`, `AI_CONTEXT.md`, and `PROJECT_CONTEXT.md`.

The copied set follows [`../export-policy.md`](../export-policy.md). Identity-specific files and maintainer-local overlays are intentionally excluded from the default public export.

The scripts include a contamination guard and fail if exported files contain known non-exportable maintainer identity markers.
