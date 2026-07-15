ARG BUILD_FROM=ghcr.io/home-assistant/base:3.24

FROM $BUILD_FROM AS builder

ARG VBB_REST_VERSION=6.0.7

# Use nodejs-current instead of nodejs: alpine 3.23/3.24 ship nodejs 24.17.0,
# which breaks hafas-client's HTTPS requests with ERR_STREAM_PREMATURE_CLOSE.
# The regression was fixed in 24.18.0 (nodejs/node#63834) but alpine has not
# picked that up.
RUN apk add --no-cache \
        git \
        libstdc++ \
        nodejs-current \
        npm

RUN git clone \
        --branch "${VBB_REST_VERSION}" \
        --depth 1 \
        https://github.com/derhuerst/vbb-rest.git \
        /app
WORKDIR /app

# Full install (incl. dev deps) to build the static docs, then prune
RUN npm install \
    && HOSTNAME=localhost npm run build \
    && npm prune --omit=dev \
    && npm cache clean --force \
    && rm -rf /app/.git

# Build final image
FROM $BUILD_FROM

RUN apk add --no-cache \
        libstdc++ \
        nginx \
        valkey \
        nodejs-current

COPY --from=builder /app /app
WORKDIR /app

# Copy root filesystem
COPY rootfs /

HEALTHCHECK --start-period=2m \
    CMD wget --spider -q http://127.0.0.1:3000/ || exit 1
