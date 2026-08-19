# DCR-20260819-01: Private Maintainer Identity Overlay

Status: Approved  
Date: 2026-08-19  
Owner: Maintainer

Related files:

- README.md
- doctrine-governance.md
- export-policy.md
- .github/workflows/ci-doctrine.yml
- RELEASE_NOTES.md

## Context

The public Doctrine source still contained maintainer identity and account naming guidance after the public export boundary was introduced. Although bootstrap excluded those files, their presence in the public source created an inconsistent boundary and encouraged stale copies in public templates.

## Decision

Maintainer identity, account naming ladders, and personal AI preferences now live only in a private maintainer overlay. Public Doctrine contains contributor-neutral engineering and governance guidance only.

## Rationale

Reusable public templates must serve all contributors. Personal identity guidance does not help downstream contributors and can create accidental coupling between a project and one maintainer's account preferences.

## Impact

- Public Doctrine no longer stores identity or username files.
- Public template snapshots and generated repositories must not include maintainer identity content.
- Public validation rejects known maintainer identity markers in exported output.

## Migration Plan

- [x] Remove identity-specific files from public Doctrine.
- [ ] Refresh public templates from the contributor-neutral export allowlist.
- [ ] Audit Foundation public repositories for identity-marker leakage.
- [ ] Complete the separate organisation robustness pass before publishing a release.
