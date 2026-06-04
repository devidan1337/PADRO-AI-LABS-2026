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
