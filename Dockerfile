FROM python:3.13.5-slim AS builder

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libffi-dev \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN python -m venv /venv && \
    . /venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

FROM python:3.13.5-slim

RUN apt-get update && apt-get install -y \
    libpq5 \
    libffi7 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /venv /venv
COPY . .

ENV PATH="/venv/bin:$PATH"

EXPOSE 5000
CMD ["python", "app.py"]
