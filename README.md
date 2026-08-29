# Doctrine

Status: Stable  
Last Reviewed: 2026-08-29

Centralized engineering doctrine defining naming, coding philosophy, project standards, and repository governance.

This repository acts as a persistent reference for engineering decisions and conventions.

Doctrine is a public, contributor-neutral baseline. It is not a personal
handbook: maintainer identity, account ladders, and tool-local preferences
belong in private overlays.

---

## Navigation

### Naming

- [Naming Conventions](naming.md)

### Engineering

- [Coding Principles](coding.md)
- [Project Standards](project-standards.md)
- [C/C++ Template Family Doctrine](cpp-template-family.md)

### Repository Governance

- [Repo Governance Doctrine](repo-management.md)
- [Doctrine Governance](doctrine-governance.md)
- [Doctrine Export Policy](export-policy.md)
- [Repo Visibility Note Template](templates/repo-visibility-note-template.md)
- [Doctrine Change Record Template](templates/doctrine-change-record-template.md)

### AI Usage

- [AI Context](AI_CONTEXT.md)
- [Project Context Template](templates/project-context-template.md)
- [Claude Code Adapter Template](templates/CLAUDE.md)

### Meta

- [Release Notes](RELEASE_NOTES.md)
- [Bootstrap Scripts](tools/README.md)

---

## How To Use Doctrine

Doctrine is not meant to be read sequentially.

Use it as a reference:

- Starting a project → check Project Standards
- Naming something → check Naming
- Writing code → check Coding
- Building template ecosystems → check C/C++ Template Family Doctrine
- Using AI → configure personal preferences locally, then use `AGENTS.md` and `PROJECT_CONTEXT.md` in the repository
- Changing policy → check Doctrine Governance + DCR Template
- Exporting doctrine to public repositories → check Doctrine Export Policy
- Preparing repo visibility decision → use Visibility Note Template

---

## Purpose

Doctrine exists to:

- Reduce decision fatigue
- Maintain consistency
- Preserve consistent engineering standards
- Standardize project structure
- Improve long-term maintainability

---

## Bootstrap Any Repository

Use the bootstrap scripts in [`tools/`](tools/) to copy the public doctrine baseline into any project repo.

The bootstrap baseline follows [`export-policy.md`](export-policy.md). Identity-specific files and maintainer-local overlays are not copied by default.

### macOS / Linux

```bash
./tools/doctrine-bootstrap.sh /path/to/target-repo
```

### Windows PowerShell

```powershell
.\tools\doctrine-bootstrap.ps1 -TargetRepo C:\path\to\target-repo
```

### Windows CMD

```cmd
tools\doctrine-bootstrap.cmd C:\path\to\target-repo
```

Use `--force` (Bash) or `-Force` (PowerShell) to overwrite existing doctrine files.
Use `--refresh-baseline` (Bash) or `-RefreshBaseline` (PowerShell) to refresh
only the Doctrine-owned snapshot under `docs/doctrine/`; it preserves local
agent instructions and project context.
