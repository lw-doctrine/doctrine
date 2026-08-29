# C/C++ Template Family Doctrine

Status: Draft  
Last Reviewed: 2026-08-29

## Purpose

Define stable doctrine contracts for multi-model C/C++ template ecosystems, while keeping fast-changing implementation details in the template family repository.

This file intentionally stays thin to avoid policy churn.

## Scope

Applies to C/C++ template-family repositories and generated repositories that use CMake-first workflows.

## Stable Contracts

### 1. CMake-First Baseline

- C/C++ template families use CMake as the required build system.
- Generated repositories must provide a native generator path that works without optional tools.

### 2. Setup Friction Minimization

- Clone-to-first-build should be short and explicit.
- Repositories with non-trivial prerequisites should provide setup scripts.
- Setup guidance must be present in README with copy-paste commands.

### 3. Dependency Classification

- Dependencies must be classified as:
  - Required (must pass for normal build/test path)
  - Optional (recommended, non-blocking by default)
- Optional tools must never block the native baseline workflow.

### 4. Doctor/Install Script Contract

When setup scripts exist, default behavior should be doctor/validation first.

Recommended contract:

- Entry points:
  - `tools/setup/bootstrap.sh`
  - `tools/setup/bootstrap.ps1`
  - `tools/setup/bootstrap.cmd`
- Modes:
  - doctor (default)
  - install (best effort)
- Exit codes:
  - `0` ready
  - `2` missing required dependencies
  - `3` install attempted but incomplete/failed

### 5. Optional Tool Fallback Rule

- If Ninja presets are provided, native presets must also be provided.
- Missing Ninja is a warning path, not a hard failure path.

### 6. Language Scope Rule

- Primary language selectors (for example `--lang c|cpp`) define compiled target defaults only.
- Helper scripts in `tools/` may use other languages (for example Python) unless a repository policy explicitly prohibits it.

## What Stays Outside Doctrine

Keep these in template-family repository docs (not doctrine policy):

- Exact model list and file layouts
- CLI flag details that may evolve rapidly
- CI matrix depth and scheduling details
- Implementation specifics for package-manager commands

## Reference Implementation

- Template family repository: [lw-doctrine/repo-template-cpp-family](https://github.com/lw-doctrine/repo-template-cpp-family)
