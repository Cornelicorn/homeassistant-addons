#!/bin/bash

set -e

/httpreq-lego.sh present "$HTTPREQ_HOST"

sleep 30
