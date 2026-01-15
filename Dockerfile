# ==========================================
# STAGE 1: Builder (Dùng để cài đặt thư viện)
# ==========================================
FROM python:3.9-slim as builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ==========================================
# STAGE 2: Runtime (Image cuối cùng để chạy)
# ==========================================
FROM python:3.9-slim

WORKDIR /app


COPY --from=builder /install /usr/local

# Copy code dự án vào
COPY . .

# Mở port
EXPOSE 5000

# Chạy app
CMD ["python", "app.py"]