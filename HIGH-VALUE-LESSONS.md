# HIGH-VALUE LESSONS

## Obsidian + WSL
Windows Obsidian can fail when opening vaults through \\wsl$ paths because of filesystem watcher issues.

## Better Pattern
Run Obsidian inside WSL and open the repository directly:

/home/dev/projects/PADRO-AI-LABS-2026

## Git Lesson
Always confirm the current directory before committing:

pwd
git status

## Architecture Lesson
Avoid split-brain workflows. One source of truth is better than copying between Windows and Linux paths.

## Obsidian Vault Scope
Once Linux Obsidian successfully opened the repository root, the separate vault/ folder became redundant.

Better pattern:
Repository root = Obsidian vault = Git source of truth = Program Brain.

Linux differentiates between files and directories.

Before creating nested files, verify the target path type using:

ls -la

A file and directory may not share the same name in the same location.
