ARG BUILD_FROM

# Used to copy app
FROM ghcr.io/maziggy/bambuddy:0.2.1 AS original

FROM $BUILD_FROM AS base

WORKDIR /app

RUN apk add --no-cache \
  python3 \
  curl \
  wget \
  py3-opencv \
  ffmpeg \
  nginx

FROM base AS builder

RUN apk add --no-cache \
  build-base \
  uv \
  python3-dev

RUN uv venv \
  --clear \
  --no-python-downloads \
  --no-managed-python \
  --system-site-packages

COPY --from=original /app/requirements.txt /app/requirements.txt
# We want to use alpine's included py3-opencv system library, since it takes
# ages to build directly (>20 minutes on amd64 and >40 minutes on aarch64 in Github Actions)
# The venv uses the system site packages, but uv would still try to install the dependency anyway,
# so we have to comment them out of the requirements.txt
RUN sed -i 's/opencv-python-headless/# opencv-python-headless/' /app/requirements.txt
RUN sed -i 's/numpy/# numpy/' /app/requirements.txt

RUN uv pip install --index-strategy unsafe-best-match --compile-bytecode -r requirements.txt

FROM base

COPY --from=original /app /app
COPY --from=builder /app/.venv /app/.venv

# Copy root filesystem
COPY rootfs /

HEALTHCHECK --start-period=10m \
    CMD curl --fail http://127.0.0.1:8000 || exit 1
