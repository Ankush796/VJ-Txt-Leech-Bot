FROM python:3.10.8-slim-bullseye

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/
WORKDIR /app/
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt

# Use gunicorn as the main server (foreground). Agar really zaroorat ho to main.py run karo,
# lekin background process Docker best-practice nahi hai — ek hi foreground process hona chahiye.
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
