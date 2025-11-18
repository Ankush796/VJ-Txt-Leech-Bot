FROM python:3.10.8-slim-bullseye

WORKDIR /app

COPY requirements.txt /app/

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-tools ffmpeg aria2 python3-pip wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip \
 && pip3 install --no-cache-dir --requirement requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
