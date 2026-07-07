# Cornelicorn Home Assistant Add-on: VBB REST API

This add-on runs [`vbb-rest`](https://github.com/derhuerst/vbb-rest), an HTTP REST API
for the public transport network of Berlin & Brandenburg (VBB). It wraps the VBB HAFAS
endpoint and exposes clean JSON endpoints for stations, departures, journeys, lines and
more, including realtime delays and disruptions.

HAFAS responses are cached in a bundled [Valkey](https://valkey.io/) instance, which
reduces load on the upstream API and speeds up repeated requests. The cache is persisted
in the add-on's data directory and survives restarts and updates.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
2. Find the "VBB REST API" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

After starting the add-on, the API and its bundled documentation are served on the
exposed port (default `3000` on the host, mapped to port `80` in the container). For
example:

```text
https://<your-home-assistant>:3000/stops/900100001/departures
```

The API documentation is available at
[github.com/derhuerst/vbb-rest/blob/6/docs/readme.md](https://github.com/derhuerst/vbb-rest/blob/6/docs/readme.md).

## Configuration

### Option: `ssl`

Enables/disables SSL (HTTPS) on the exposed port. Set it to `true` to serve the API over
HTTPS, `false` to serve it over plain HTTP.

### Option: `certfile`

The certificate file to use for SSL, stored in `/ssl/`. Only used when `ssl` is `true`.

### Option: `keyfile`

The private key file to use for SSL, stored in `/ssl/`. Only used when `ssl` is `true`.

### Option: `hostname` (optional)

The hostname the API uses for self-referential links and the OpenAPI spec. It does not
affect how the API can be reached. Defaults to `localhost`.
