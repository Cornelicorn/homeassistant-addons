#!/bin/bash

set -x

/httpreq-lego.sh present "$HTTPREQ_HOST"

sleep "$DNS_PROPAGATION_DELAY"
