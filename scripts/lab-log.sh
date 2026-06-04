#!/usr/bin/env bash

set -euo pipefail

ROOT="$HOME/projects/PADRO-AI-LABS-2026"
LOG_DIR="$ROOT/logs"
DATE="$(date +%Y-%m-%d)"
TIME="$(date +%H%M%S)"

mkdir -p "$LOG_DIR" "$ROOT/screenshots" "$ROOT/lessons-learned" "$ROOT/reports"

if [ $# -lt 1 ]; then
  echo "Usage:"
  echo "  lab-log.sh start lab01"
  echo "  lab-log.sh cmd lab01 'npm install -g @openai/codex'"
  echo "  lab-log.sh note lab01 'Fixed PATH issue with codex'"
  exit 1
fi

ACTION="$1"
LAB="${2:-general}"

SESSION_LOG="$LOG_DIR/${DATE}-${LAB}-session-${TIME}.log"
CMD_LOG="$LOG_DIR/${DATE}-${LAB}-commands.log"
DAILY_LOG="$ROOT/DAILY-LOG.md"
LESSONS="$ROOT/LESSONS-LEARNED.md"

case "$ACTION" in

  start)
    echo "Starting full terminal session log:"
    echo "$SESSION_LOG"
    echo
    echo "Type 'exit' or press Ctrl+D when finished."
    script -f "$SESSION_LOG"
    ;;

  cmd)
    if [ $# -lt 3 ]; then
      echo "Usage: lab-log.sh cmd lab01 'command here'"
      exit 1
    fi

    COMMAND="$3"

    {
      echo
      echo "============================================================"
      echo "Date: $(date)"
      echo "Lab: $LAB"
      echo "Command: $COMMAND"
      echo "============================================================"
    } | tee -a "$CMD_LOG"

    bash -c "$COMMAND" 2>&1 | tee -a "$CMD_LOG"
    ;;

  note)
    if [ $# -lt 3 ]; then
      echo "Usage: lab-log.sh note lab01 'note here'"
      exit 1
    fi

    NOTE="$3"

    {
      echo
      echo "## $DATE - $LAB"
      echo
      echo "- $NOTE"
    } >> "$DAILY_LOG"

    echo "Note added to DAILY-LOG.md"
    ;;

  lesson)
    if [ $# -lt 3 ]; then
      echo "Usage: lab-log.sh lesson lab01 'lesson here'"
      exit 1
    fi

    LESSON="$3"

    {
      echo
      echo "## $DATE - $LAB"
      echo
      echo "### Lesson"
      echo "- $LESSON"
    } >> "$LESSONS"

    echo "Lesson added to LESSONS-LEARNED.md"
    ;;

  status)
    echo "PADRO-AI-LABS logging status"
    echo "Root: $ROOT"
    echo "Logs:"
    ls -lah "$LOG_DIR"
    ;;

  *)
    echo "Unknown action: $ACTION"
    exit 1
    ;;

esac
