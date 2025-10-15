#!/usr/bin/env bash
set -e

while [ $# -gt 0 ]; do
  case "$1" in
    --timeout=*)
      TIMEOUT="${1#*=}"
      ;;
    --max-score=*)
      MAX_SCORE="${1#*=}"
      MAX_SCORE="${MAX_SCORE:-0}"
      ;;
    --test-dir=*)
      TEST_DIR="${1#*=}"
      TEST_DIR="${TEST_DIR:-./}"
      ;;
    --setup-command=*)
      SETUP_COMMAND="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Warning: Unknown argument.*\n"
      printf "***************************\n"
  esac
  shift
done

WORKSPACE_UID=$(stat -c "%u" .)
WORKSPACE_GID=$(stat -c "%g" .)

if ! getent group runner >/dev/null 2>&1; then
  addgroup --gid "$WORKSPACE_GID" runner
fi

if ! id -u runner >/dev/null 2>&1; then
  adduser --disabled-password --gecos "" --uid "$WORKSPACE_UID" --gid "$WORKSPACE_GID" runner
fi

chown -R runner:runner /opt/test-runner || true

exec gosu runner /opt/test-runner/bin/run.sh --timeout="$TIMEOUT" --max-score="$MAX_SCORE" --test-dir="$TEST_DIR" --setup-command="$SETUP_COMMAND"
