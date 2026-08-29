# DCR-20260829-01: Public Doctrine Source Stabilization

Status: Approved
Date: 2026-08-29
Owner: Maintainer

Related files:

- CODEOWNERS
- README.md
- cpp-template-family.md
- doctrine-governance.md
- export-policy.md
- tools/doctrine-bootstrap.sh
- tools/doctrine-bootstrap.ps1
- .github/workflows/ci-doctrine.yml

## Context

The public export boundary was implemented on development branches, but the
public stable release still contained retired identity files. Validation also
did not cover all current maintainer identity markers, and first-party GitHub
references still used retired ownership names.

## Decision

The public Doctrine source and every default export use the same
contributor-neutral boundary. Validation rejects current and retired
maintainer identity markers, case-insensitively, and the release workflow
promotes the completed boundary work to the public stable branch.

## Rationale

Doctrine is a reusable public baseline. A private identity overlay is useful
only when it stays private; an excluded-but-public source file still weakens
that boundary.

## Impact

- Repositories affected: Doctrine and downstream repositories that refresh its baseline.
- Behavior changes: bootstrap rejects a broader maintained set of private identity markers.
- Risks: downstream repositories with copied legacy identity content need an intentional local cleanup.

## Migration Plan

- [x] Update public Doctrine references and contamination guards.
- [x] Validate clean bootstrap and safe baseline refresh behavior.
- [x] Merge this work into `develop`.
- [x] Prepare the v0.4.0 release branch for stable promotion.

Deadline: 2026-08-29
