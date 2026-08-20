#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: doctrine-bootstrap.sh [--force | --refresh-baseline] <target-repo-path>

Copies the public doctrine baseline into a target repository.

Options:
  -f, --force    Overwrite existing files
  -r, --refresh-baseline
                 Refresh only Doctrine-owned files under docs/doctrine/
  -h, --help     Show this help
EOF
}

force=0
refresh_baseline=0
target=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force)
      force=1
      shift
      ;;
    -r|--refresh-baseline)
      refresh_baseline=1
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

if [[ $force -eq 1 && $refresh_baseline -eq 1 ]]; then
  echo "--force and --refresh-baseline cannot be used together." >&2
  exit 1
fi

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

copy_snapshot_file() {
  local src="$1"
  local rel="$2"
  local dst="${target_dir}/${rel}"

  [[ -f "$src" ]] || { echo "Missing source file: $src" >&2; exit 1; }
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "write $rel"
}

if [[ $refresh_baseline -eq 0 ]]; then
  copy_file "${doctrine_root}/templates/AGENTS.md" "AGENTS.md"
  copy_file "${doctrine_root}/AI_CONTEXT.md" "AI_CONTEXT.md"
fi

for doctrine_file in \
  coding.md \
  doctrine-governance.md \
  export-policy.md \
  naming.md \
  project-standards.md \
  repo-management.md; do
  if [[ $refresh_baseline -eq 1 ]]; then
    copy_snapshot_file "${doctrine_root}/${doctrine_file}" "docs/doctrine/${doctrine_file}"
  else
    copy_file "${doctrine_root}/${doctrine_file}" "docs/doctrine/${doctrine_file}"
  fi
done

for template_file in \
  repo-visibility-note-template.md \
  doctrine-change-record-template.md \
  project-context-template.md \
  CLAUDE.md; do
  if [[ $refresh_baseline -eq 1 ]]; then
    copy_snapshot_file "${doctrine_root}/templates/${template_file}" "docs/doctrine/templates/${template_file}"
  else
    copy_file "${doctrine_root}/templates/${template_file}" "docs/doctrine/templates/${template_file}"
  fi
done

doctrine_index="${target_dir}/docs/doctrine/README.md"
if [[ -e "$doctrine_index" && $force -ne 1 && $refresh_baseline -ne 1 ]]; then
  echo "skip  docs/doctrine/README.md (already exists)"
else
  mkdir -p "$(dirname "$doctrine_index")"
  cat >"$doctrine_index" <<'EOF'
# Doctrine Snapshot

This folder contains a local doctrine snapshot copied from the Doctrine repository.

## Source of Truth

The canonical source remains the Doctrine repository.

## Refresh

Run bootstrap again to add missing baseline files. Use `--refresh-baseline` to
refresh only this Doctrine-owned snapshot without replacing local agent or
project-context files.

## Export Boundary

This snapshot contains the public doctrine baseline only.
Identity-specific files and maintainer-local overlays are intentionally not copied by default.
EOF
  echo "write docs/doctrine/README.md"
fi

if [[ $refresh_baseline -eq 1 ]]; then
  for retired_file in identity.md usernames.md; do
    retired_path="${target_dir}/docs/doctrine/${retired_file}"
    if [[ -e "$retired_path" ]]; then
      rm "$retired_path"
      echo "remove docs/doctrine/${retired_file}"
    fi
  done
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
