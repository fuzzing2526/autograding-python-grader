#!/usr/bin/env bash
set -e

WORKSPACE_UID=$(stat -c "%u" .)
WORKSPACE_GID=$(stat -c "%g" .)

if ! getent group runner >/dev/null 2>&1; then
  addgroup --gid "$WORKSPACE_GID" runner
fi

if ! id -u runner >/dev/null 2>&1; then
  adduser --disabled-password --gecos "" --uid "$WORKSPACE_UID" --gid "$WORKSPACE_GID" runner
fi

chown -R runner:runner /opt/test-runner || true

exec gosu runner /opt/test-runner/bin/run.sh
