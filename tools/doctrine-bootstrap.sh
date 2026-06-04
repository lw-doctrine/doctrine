#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: doctrine-bootstrap.sh [--force] <target-repo-path>

Copies the public doctrine baseline into a target repository.

Options:
  -f, --force    Overwrite existing files
  -h, --help     Show this help
EOF
}

force=0
target=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$target" ]]; then
        target="$1"
        shift
      else
        echo "Unexpected argument: $1" >&2
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$target" ]]; then
  usage
  exit 1
fi

if [[ ! -d "$target" ]]; then
  echo "Target directory does not exist: $target" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
doctrine_root="$(cd "${script_dir}/.." && pwd)"
target_dir="$(cd "$target" && pwd)"

copy_file() {
  local src="$1"
  local rel="$2"
  local dst="${target_dir}/${rel}"

  if [[ ! -f "$src" ]]; then
    echo "Missing source file: $src" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && $force -ne 1 ]]; then
    echo "skip  $rel (already exists)"
    return
  fi

  cp "$src" "$dst"
  echo "write $rel"
}

copy_file "${doctrine_root}/templates/AGENTS.md" "AGENTS.md"
copy_file "${doctrine_root}/AI_CONTEXT.md" "AI_CONTEXT.md"

for doctrine_file in \
  coding.md \
  doctrine-governance.md \
  export-policy.md \
  naming.md \
  project-standards.md \
  repo-management.md; do
  copy_file "${doctrine_root}/${doctrine_file}" "docs/doctrine/${doctrine_file}"
done

copy_file "${doctrine_root}/templates/repo-visibility-note-template.md" \
  "docs/doctrine/templates/repo-visibility-note-template.md"
copy_file "${doctrine_root}/templates/doctrine-change-record-template.md" \
  "docs/doctrine/templates/doctrine-change-record-template.md"

doctrine_index="${target_dir}/docs/doctrine/README.md"
if [[ -e "$doctrine_index" && $force -ne 1 ]]; then
  echo "skip  docs/doctrine/README.md (already exists)"
else
  mkdir -p "$(dirname "$doctrine_index")"
  cat >"$doctrine_index" <<'EOF'
# Doctrine Snapshot

This folder contains a local doctrine snapshot copied from the Doctrine repository.

## Source of Truth

The canonical source remains the Doctrine repository.

## Refresh

Re-run bootstrap when doctrine updates are needed.

## Export Boundary

This snapshot contains the public doctrine baseline only.
Identity-specific files and maintainer-local overlays are intentionally not copied by default.
EOF
  echo "write docs/doctrine/README.md"
fi

validate_public_export() {
  local failed=0
  local pattern
  local path
  local matches
  local scan_paths=(
    "${target_dir}/AGENTS.md"
    "${target_dir}/AI_CONTEXT.md"
    "${target_dir}/docs/doctrine"
  )
  local forbidden_patterns=(
    "Primary engineering identity"
    "Real/legal identity"
    "George Gil"
  )

  for pattern in "${forbidden_patterns[@]}"; do
    for path in "${scan_paths[@]}"; do
      [[ -e "$path" ]] || continue
      matches="$(grep -RInF "$pattern" "$path" || true)"
      if [[ -n "$matches" ]]; then
        echo "$matches" >&2
        failed=1
      fi
    done
  done

  if [[ $failed -ne 0 ]]; then
    echo "Public export contamination guard failed." >&2
    exit 1
  fi
}

validate_public_export

echo "Bootstrap complete for: $target_dir"
