ARG BUILD_FROM
FROM $BUILD_FROM

RUN \
    set -x && \
    apk add \
        certbot \
        curl

COPY rootfs /
