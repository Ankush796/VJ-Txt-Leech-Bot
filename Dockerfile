# Dockerfile (for web service)
FROM python:3.10.8-slim-bullseye

# create app dir
WORKDIR /app

# copy requirements first to use docker cache
COPY requirements.txt /app/

RUN apt-get update -y && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install python deps
RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir --requirement requirements.txt

# copy app files
COPY . /app/

# make start script executable
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# expose is optional on Render but useful locally
EXPOSE 8000

# entrypoint uses $PORT fallback to 8000
ENTRYPOINT ["/app/start.sh"]
