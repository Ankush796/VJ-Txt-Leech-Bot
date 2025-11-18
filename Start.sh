#!/usr/bin/env bash
# start-web.sh
# ensures gunicorn binds to platform-provided PORT and uses safe worker count

# default port if not provided by platform
: "${PORT:=8000}"
# default workers (low memory): use 1 for small instances
: "${WEB_CONCURRENCY:=1}"

# gunicorn options tuned for stability
GUNICORN_CMD="gunicorn"
APP_MODULE="app:app"
WORKERS="${WEB_CONCURRENCY}"
BIND="0.0.0.0:${PORT}"
TIMEOUT="120"
MAX_REQS="1000"
JITTER="50"
ACCESS_LOG="-"
ERROR_LOG="-"

echo "Starting gunicorn: bind=${BIND} workers=${WORKERS}"

# exec so that gunicorn becomes PID 1 (proper signal handling)
exec $GUNICORN_CMD \
  -w "${WORKERS}" \
  -k sync \
  -b "${BIND}" \
  --timeout "${TIMEOUT}" \
  --max-requests "${MAX_REQS}" \
  --max-requests-jitter "${JITTER}" \
  --access-logfile "${ACCESS_LOG}" \
  --error-logfile "${ERROR_LOG}" \
  "${APP_MODULE}"
