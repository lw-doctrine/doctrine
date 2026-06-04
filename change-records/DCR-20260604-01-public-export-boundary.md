# DCR-20260604-01: Public Doctrine Export Boundary

Status: Draft  
Date: 2026-06-04  
Owner: TinMan

Related files:
- AI_CONTEXT.md
- export-policy.md
- naming.md
- project-standards.md
- identity.md
- usernames.md
- tools/doctrine-bootstrap.sh
- tools/doctrine-bootstrap.ps1
- tools/README.md
- .github/workflows/ci-doctrine.yml

## Context

Reusable public templates and generated repositories inherited doctrine files that mixed contributor-facing project guidance with maintainer-specific identity and account naming guidance.

## Decision

Default doctrine bootstrap exports are now limited to a contributor-neutral public baseline. Identity-specific doctrine and maintainer-local overlays are not copied into public templates or generated repositories by default.

Bootstrap and CI checks must fail when the public export contains known non-exportable identity markers.

## Rationale

Doctrine should define what contributors and AI agents need in project repositories. Maintainer-private identity and account guidance can remain useful at the source level, but it should not propagate as default project policy.

## Impact

- Repositories affected: doctrine, public template repositories, and generated repository snapshots.
- Behavior changes: default bootstrap no longer copies identity-specific doctrine into target repositories.
- Risks: downstream repositories that depended on copied identity guidance must document that dependency locally or maintain a private overlay.

## Migration Plan

- [ ] Update doctrine source files and bootstrap export policy.
- [ ] Refresh public template repositories from the cleaned doctrine baseline.
- [ ] Update template-family generation logic to respect the public export boundary.
- [ ] Audit existing public repositories for non-exportable identity markers.

Deadline: 2026-06-30
