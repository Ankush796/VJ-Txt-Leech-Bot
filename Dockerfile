# Dockerfile (web)
FROM python:3.10.8-slim-bullseye

WORKDIR /app

# copy only requirements first for cache
COPY requirements.txt /app/

RUN apt-get update -y && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# python deps
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir --requirement requirements.txt

# copy app
COPY . /app/

# optional for local testing
EXPOSE 8000

# Use PORT env var if provided by platform, fallback to 8000
# Using bash -lc to expand ${PORT:-8000}
CMD ["bash", "-lc", "gunicorn -w 4 -b 0.0.0.0:${PORT:-8000} --access-logfile - --error-logfile - --timeout 120 app:app"]
