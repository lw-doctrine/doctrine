# Release Notes

Status: Stable  
Last Reviewed: 2026-08-19

## Unreleased

### Removed Files
- identity.md
- usernames.md

### Added Files
- change-records/DCR-20260819-01-private-maintainer-overlay.md

### Updated Files
- README.md
- RELEASE_NOTES.md
- doctrine-governance.md
- export-policy.md
- .github/workflows/ci-doctrine.yml

### Notes
- Moved maintainer identity and username preferences out of public Doctrine into a private overlay.
- Tightened public-export validation to reject maintainer identity markers.

## v0.3.0 - 2026-06-04

### Added Files
- export-policy.md
- change-records/DCR-20260604-01-public-export-boundary.md

### Updated Files
- AI_CONTEXT.md
- README.md
- RELEASE_NOTES.md
- doctrine-governance.md
- identity.md
- naming.md
- project-standards.md
- templates/AGENTS.md
- tools/README.md
- tools/doctrine-bootstrap.sh
- tools/doctrine-bootstrap.ps1
- usernames.md
- .github/workflows/ci-doctrine.yml

### Notes
- Split public doctrine exports from maintainer-local identity overlays.
- Rewrote public AI context and naming defaults to be contributor-neutral.
- Excluded identity-specific doctrine from default bootstrap snapshots.
- Added bootstrap and CI contamination guards for known non-exportable identity markers.

## v0.2.0 - 2026-03-04

### Updated Files
- repo-management.md
- templates/AGENTS.md
- .github/workflows/ci-master-promotion.yml

### Notes
- Updated repository workflow policy so `master` remains stable and releases are promoted from `release/*` branches cut from `develop`.
- Added explicit protected-branch rules: no direct push to `master`/`develop`, and no admin bypass for protected-branch enforcement.
- Added emergency release branch guidance (`release/hotfix-*`) with merge-back to both `master` and `develop`.
- Updated master-promotion CI guard to require PRs into `master` to originate from `release/*`.
- Updated AI agent guidance to avoid direct protected-branch pushes even under admin credentials.

## v0.1.3 - 2026-03-04

### Updated Files
- repo-management.md
- templates/AGENTS.md

### Notes
- Added a GitHub Projects issue/commit granularity policy requiring issue-driven work, small unambiguous issues, and small issue-scoped commit sets by default.
- Added explicit exceptions for non-diff operational tasks, discovery-first work, and unavoidable architecture-level changes with required rationale.
- Updated AI agent guidance to require clear issue linkage for project-managed repos and to keep commit scope aligned to issue scope.

## v0.1.2 - 2026-02-28

### Added Files
- CODEOWNERS
- .github/workflows/release-tag.yml
- .github/workflows/ci-master-promotion.yml

### Updated Files
- repo-management.md

### Notes
- Added a root ownership mapping.
- Added draft GitHub release automation for semantic tags (`v*`) with generated release notes.
- Canonicalized branch promotion flow as `develop -> master` for releases and tagging on `master`.
- Added enforcement check requiring PRs to `master` to originate from `develop`.

## v0.1.1 - 2026-02-28

### Added Files
- cpp-template-family.md

### Updated Files
- README.md
- coding.md
- project-standards.md
- tools/doctrine-bootstrap.sh
- tools/doctrine-bootstrap.ps1

### Notes
- Added thin C/C++ template family doctrine with stable setup and dependency contracts.
- Added generalized setup-friction minimization principles to core standards.
- Updated doctrine bootstrap scripts and kept C/C++-specific doctrine out of generic snapshot copy lists.

## v0.1.0 - 2026-02-28

### Stable Files
- README.md
- AI_CONTEXT.md
- coding.md
- project-standards.md
- repo-management.md
- usernames.md
- templates/doctrine-change-record-template.md
- templates/repo-visibility-note-template.md

### Draft Files
- doctrine-governance.md
- identity.md
- naming.md

### Notes
- First formal doctrine baseline release.
- Repository governance policy, visibility policy, org placement policy, and commit signing policy are now stable.
- Added MIT license (`LICENSE`).
- Naming doctrine remains draft for further iteration.
