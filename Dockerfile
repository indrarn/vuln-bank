FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p static/uploads templates

COPY . .

RUN chmod 777 static/uploads

EXPOSE 5000

CMD ["python", "app.py"]
