ARG BUILD_FROM

# Used to copy app
FROM ghcr.io/donkie/spoolman:0.23.1 AS original

# Used to build uv venv again with alpine base system
FROM $BUILD_FROM AS builder

RUN apk add --no-cache \
        uv \
        python3 \
        python3-dev \
        libpq-dev \
        libffi-dev

# Copy the whole app
COPY --from=original /home/app/spoolman /home/app/spoolman
WORKDIR /home/app/spoolman

# Recreate venv on alpine
RUN uv sync \
    --no-dev \
    --no-python-downloads \
    --no-managed-python \
    --compile-bytecode \
    --locked

# Build final image
FROM $BUILD_FROM

RUN apk add --no-cache \
        gosu \
        python3 \
        nginx

RUN addgroup app -g 1000 && \
    adduser app -D -G app -u 1000 && \
    mkdir -p /home/app/.local/share/spoolman && \
    chown -R app:app /home/app

COPY --chown=app:app --from=builder /home/app/spoolman /home/app/spoolman
RUN chown -R app:app /home/app

# HEALTHCHECK --start-period=10m \
#     CMD curl --fail http://127.0.0.1:8000 || exit 1


COPY rootfs /
