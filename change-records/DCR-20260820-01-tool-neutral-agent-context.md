# DCR-20260820-01: Tool-Neutral Agent Context Workflow

Status: Draft  
Last Reviewed: 2026-08-20

## Decision

Public Doctrine defines a portable project context contract: repository
`AGENTS.md`, optional root `PROJECT_CONTEXT.md`, and an optional thin
`CLAUDE.md` adapter. Personal agent preferences remain outside public Doctrine
in private, tool-local configuration.

## Rationale

The previous workflow required maintainers to repeatedly explain personal
preferences and project direction to each agent. A repository-local context
contract preserves project knowledge without exporting private identity or
account material.

## Consequences

- Bootstrap exports neutral templates but never creates a populated project
  context file.
- Existing repositories can refresh Doctrine-owned snapshots without replacing
  local instructions or project context.
- Tool-specific global configuration is intentionally outside the public
  baseline.

## Migration

Pilot FrameKit, Truffle, and OneDeck with project-local context files. Refresh
their public Doctrine snapshots after this change is merged.
