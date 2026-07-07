ARG BUILD_FROM=ghcr.io/home-assistant/base:3.23

# Node.js 24.17.0 has a regression that breaks hafas-client's HTTPS requests
# with ERR_STREAM_PREMATURE_CLOSE (fixed in 24.18.0), and alpine 3.23's
# nodejs package ships exactly 24.17.0. Use the official Node.js binaries
# instead temporarely
FROM node:26.4.0-alpine AS node

# Build vbb-rest from source so node_modules match the shipped node version
FROM $BUILD_FROM AS builder

ARG VBB_REST_VERSION=6.0.7

RUN apk add --no-cache \
        git \
        libstdc++

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

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
        valkey

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=builder /app /app
WORKDIR /app

# Copy root filesystem
COPY rootfs /

HEALTHCHECK --start-period=2m \
    CMD wget --spider -q http://127.0.0.1:3000/ || exit 1
