# CURRENT ARCHITECTURE

## Source of Truth
/home/dev/projects/PADRO-AI-LABS-2026

## Core Design
WSL2 Ubuntu is the primary engineering environment.

## Tool Chain
Windows Host
→ WSL2 Ubuntu
→ Git/GitHub
→ Obsidian Linux App
→ Hermes Memory Architecture
→ Claude/Codex Workflows
→ Future RAG Index

## Key Decision
Use Linux Obsidian against the WSL filesystem to avoid Windows Electron watcher issues with \\wsl$ paths.
