#!/bin/bash

/httpreq-lego.sh present "$HTTPREQ_HOST"

sleep "$DNS_PROPAGATION_DELAY"
