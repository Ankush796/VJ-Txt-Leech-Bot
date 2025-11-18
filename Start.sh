
#!/usr/bin/env bash
# start.sh - starts gunicorn and binds to $PORT (Render provides PORT env)
PORT="${PORT:-8000}"

# use exec so gunicorn becomes PID 1 (proper signal handling)
exec gunicorn app:app \
  -w 4 \
  -b 0.0.0.0:${PORT} \
  --access-logfile - \
  --error-logfile - \
  --timeout 120 \
  --graceful-timeout 30 \
  --log-level info
