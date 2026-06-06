# stage 1 base image 994mb ~ 1.04 Gb
FROM python:3.11 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

#--------
# stage 2 
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/

COPY . .

EXPOSE 5000

CMD ["python","run.py"]

