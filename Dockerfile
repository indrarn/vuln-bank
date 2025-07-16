FROM python:3.14-rc-alpine3.20 AS builder

RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    postgresql-dev \
    python3-dev \
    build-base

WORKDIR /app

COPY requirements.txt .

RUN python -m venv /venv && \
    . /venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


FROM python:3.14-rc-alpine3.20

RUN apk add --no-cache \
    postgresql-libs \
    libffi \
    openssl

WORKDIR /app

COPY --from=builder /venv /venv
COPY . .

ENV PATH="/venv/bin:$PATH"

EXPOSE 5000
CMD ["python", "app.py"]
