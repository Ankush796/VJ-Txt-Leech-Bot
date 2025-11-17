FROM python:3.10.8-slim-bullseye

# working dir first
WORKDIR /app

# copy only requirements first for better Docker cache
COPY requirements.txt /app/

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install python deps
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir --requirement requirements.txt

# copy rest of the app
COPY . /app/

# Optional: set a non-root user (uncomment if you want)
# RUN useradd -m myuser && chown -R myuser:myuser /app
# USER myuser

# Run gunicorn in foreground, logs to stdout/stderr, longer timeout
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "--access-logfile", "-", "--error-logfile", "-", "--timeout", "120", "app:app"]
