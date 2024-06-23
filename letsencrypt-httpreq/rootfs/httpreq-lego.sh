#!/bin/bash

set -e

OPERATION="$1"
FORWARD_ENDPOINT="$2"

URL="${FORWARD_ENDPOINT}/${OPERATION}"

PAYLOAD="{\"fqdn\": \"_acme-challenge.${CERTBOT_DOMAIN}.\", \"value\": \"$CERTBOT_VALIDATION\"}"

curl -s --netrc-file /netrc --request POST --header "Content-Type: application/json" "$URL" --data "$PAYLOAD"
