param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TargetRepo,
    [switch]$Force,
    [switch]$RefreshBaseline
)

$ErrorActionPreference = "Stop"

if ($Force.IsPresent -and $RefreshBaseline.IsPresent) {
    throw "-Force and -RefreshBaseline cannot be used together."
}

if (-not (Test-Path -LiteralPath $TargetRepo -PathType Container)) {
    throw "Target directory does not exist: $TargetRepo"
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DoctrineRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$TargetPath = (Resolve-Path $TargetRepo).Path

function Copy-DoctrineFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRel,
        [Parameter(Mandatory = $true)][string]$DestRel
    )

    $Source = Join-Path $DoctrineRoot $SourceRel
    $Dest = Join-Path $TargetPath $DestRel

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "Missing source file: $Source"
    }

    $DestDir = Split-Path -Parent $Dest
    New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

    if ((Test-Path -LiteralPath $Dest) -and -not $Force.IsPresent) {
        Write-Host "skip  $DestRel (already exists)"
        return
    }

    Copy-Item -LiteralPath $Source -Destination $Dest -Force
    Write-Host "write $DestRel"
}

function Copy-DoctrineSnapshotFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRel,
        [Parameter(Mandatory = $true)][string]$DestRel
    )

    $Source = Join-Path $DoctrineRoot $SourceRel
    $Dest = Join-Path $TargetPath $DestRel

    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        throw "Missing source file: $Source"
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Dest) | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Dest -Force
    Write-Host "write $DestRel"
}

if (-not $RefreshBaseline.IsPresent) {
    Copy-DoctrineFile -SourceRel "templates/AGENTS.md" -DestRel "AGENTS.md"
    Copy-DoctrineFile -SourceRel "AI_CONTEXT.md" -DestRel "AI_CONTEXT.md"
}

$DoctrineFiles = @(
    "coding.md",
    "doctrine-governance.md",
    "export-policy.md",
    "naming.md",
    "project-standards.md",
    "repo-management.md"
)

foreach ($file in $DoctrineFiles) {
    if ($RefreshBaseline.IsPresent) {
        Copy-DoctrineSnapshotFile -SourceRel $file -DestRel "docs/doctrine/$file"
    } else {
        Copy-DoctrineFile -SourceRel $file -DestRel "docs/doctrine/$file"
    }
}

$TemplateFiles = @(
    "repo-visibility-note-template.md",
    "doctrine-change-record-template.md",
    "project-context-template.md",
    "CLAUDE.md"
)

foreach ($file in $TemplateFiles) {
    if ($RefreshBaseline.IsPresent) {
        Copy-DoctrineSnapshotFile -SourceRel "templates/$file" -DestRel "docs/doctrine/templates/$file"
    } else {
        Copy-DoctrineFile -SourceRel "templates/$file" -DestRel "docs/doctrine/templates/$file"
    }
}

$DoctrineIndex = Join-Path $TargetPath "docs/doctrine/README.md"
if ((Test-Path -LiteralPath $DoctrineIndex) -and -not $Force.IsPresent -and -not $RefreshBaseline.IsPresent) {
    Write-Host "skip  docs/doctrine/README.md (already exists)"
} else {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $DoctrineIndex) | Out-Null
    @"
# Doctrine Snapshot

This folder contains a local doctrine snapshot copied from the Doctrine repository.

## Source of Truth

The canonical source remains the Doctrine repository.

## Refresh

Run bootstrap again to add missing baseline files. Use `-RefreshBaseline` to
refresh only this Doctrine-owned snapshot without replacing local agent or
project-context files.

## Export Boundary

This snapshot contains the public doctrine baseline only.
Identity-specific files and maintainer-local overlays are intentionally not copied by default.
"@ | Set-Content -LiteralPath $DoctrineIndex
    Write-Host "write docs/doctrine/README.md"
}

if ($RefreshBaseline.IsPresent) {
    foreach ($retiredFile in @("identity.md", "usernames.md")) {
        $retiredPath = Join-Path $TargetPath "docs/doctrine/$retiredFile"
        if (Test-Path -LiteralPath $retiredPath -PathType Leaf) {
            Remove-Item -LiteralPath $retiredPath -Force
            Write-Host "remove docs/doctrine/$retiredFile"
        }
    }
}

function Assert-PublicExportClean {
    $ForbiddenPatterns = @(
        "Primary engineering identity",
        "Real/legal identity",
        "George Gil"
    )
    $ScanRoots = @(
        (Join-Path $TargetPath "AGENTS.md"),
        (Join-Path $TargetPath "AI_CONTEXT.md"),
        (Join-Path $TargetPath "docs/doctrine")
    )
    $Violations = @()

    foreach ($root in $ScanRoots) {
        if (-not (Test-Path -LiteralPath $root)) {
            continue
        }

        $files = @()
        if (Test-Path -LiteralPath $root -PathType Container) {
            $files = Get-ChildItem -LiteralPath $root -File -Recurse
        } else {
            $files = Get-Item -LiteralPath $root
        }

        foreach ($pattern in $ForbiddenPatterns) {
            $Violations += $files | Select-String -SimpleMatch -Pattern $pattern
        }
    }

    if ($Violations.Count -gt 0) {
        $Violations | ForEach-Object { Write-Error $_.ToString() }
        throw "Public export contamination guard failed."
    }
}

Assert-PublicExportClean

Write-Host "Bootstrap complete for: $TargetPath"
