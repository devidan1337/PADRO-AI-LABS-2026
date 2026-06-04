# WSL Obsidian Integration

## Date

2026-06-04

## Objective

Integrate Obsidian into PADRO-AI-LABS while maintaining WSL as the primary engineering environment.

## Initial Architecture

Windows Obsidian attempted to open:

\wsl$\Ubuntu\home\dev\projects\PADRO-AI-LABS-2026

## Problem

Obsidian generated:

EISDIR: illegal operation on a directory, watch

The vault existed and was accessible through Windows Explorer, but Obsidian could not reliably watch the filesystem.

## Investigation

Tests performed:

* Verified repository path
* Verified vault structure
* Verified .obsidian directory
* Tested Windows Explorer access
* Tested alternate vault locations
* Tested mapped drive approach
* Reviewed WSL filesystem behavior

## Root Cause

Electron filesystem watcher incompatibility with WSL UNC paths.

## Resolution

Installed Linux Obsidian directly inside WSL Ubuntu.

Opened:

/home/dev/projects/PADRO-AI-LABS-2026

as the Obsidian vault.

## Architectural Decision

Repository Root
→ Obsidian Vault
→ Git Repository
→ Program Brain

Single source of truth.

## Benefits

* No duplicate vaults
* No Windows watcher issues
* Native Linux filesystem access
* Cleaner Git integration
* Better future compatibility with Hermes and RAG workflows

## Related

[[CURRENT-ARCHITECTURE]]

[[HIGH-VALUE-LESSONS]]

[[RETRIEVAL-STANDARD]]
