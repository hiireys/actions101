# From python:3.11-slim

# WORKDIR /app

# COPY requirements.txt .

# RUN pip install -r requirements.txt

# COPY . .

# CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "app:app"]

#above not safe as the base image has debian 12 which has lots of vulnerabilites

# -------- 1. Build stage --------
FROM python:3.11-slim AS builder

WORKDIR /app

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY requirements.txt .

# Install dependencies into a separate directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy app
COPY . .



# -------- 2. Runtime stage (distroless) --------
FROM gcr.io/distroless/python3-debian12

WORKDIR /app

# Copy installed dependencies
COPY --from=builder /install /usr/local

# Copy app code
COPY --from=builder /app /app

# Run as non-root (distroless provides this user)
USER nonroot

# Expose port (documentation only)
EXPOSE 5000

# Start app (no shell available)
CMD ["-m", "gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "app:app"]