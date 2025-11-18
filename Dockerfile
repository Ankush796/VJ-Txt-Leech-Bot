# Dockerfile (web)
FROM python:3.10.8-slim-bullseye

WORKDIR /app

# copy only requirements first for cache
COPY requirements.txt /app/

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install python deps
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir --requirement requirements.txt

# copy rest
COPY . /app/

# Expose (optional)
EXPOSE 8000

# Bind to Render-provided PORT environment variable (fallback 8000).
# Use single worker to avoid memory pressure.
CMD ["bash", "-lc", "gunicorn -w 1 -b 0.0.0.0:${PORT:-8000} --access-logfile - --error-logfile - --timeout 120 app:app"]
