ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23
FROM $BUILD_FROM

RUN \
    set -x && \
    apk add \
        certbot \
        curl

COPY rootfs /
