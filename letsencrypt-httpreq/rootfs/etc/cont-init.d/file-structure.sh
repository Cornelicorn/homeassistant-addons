#!/usr/bin/with-contenv bashio

mkdir -p /data/workdir
mkdir -p /data/letsencrypt

DOMAINS="$(bashio::config 'domains')"
QUIET="$(bashio::config 'quiet')"
STAGING="$(bashio::config 'staging')"

cat <<EOF >/certbot.ini
config-dir = /data/letsencrypt
work-dir = /data/workdir
non-interactive = true
standalone = false
key-type = rsa
rsa-key-size = 4096
reuse-key = true
keep-until-expiring = true
expand = true
agree-tos = true
eff-email = false
must-staple = true
preferred-challenges = dns
manual = true
manual-auth-hook = /httpreq-auth.sh
manual-cleanup-hook = /httpreq-cleanup.sh
quiet = ${QUIET}
staging = ${STAGING}

domains = ${DOMAINS}
EOF

if bashio::config.exists 'email'
then
    EMAIL="$(bashio::config 'email')"
    echo "email = ${EMAIL}" >>/certbot.ini
else
    echo "register-unsafely-without-email = true" >>/certbot.ini
fi

echo "default" > /netrc
chmod 0600 /netrc

if bashio::config.exists 'httpreq_user'
then
    HTTPREQ_USER="$(bashio::config 'httpreq_user')"
    echo "login ${HTTPREQ_USER}" >>/netrc
fi

if bashio::config.exists 'httpreq_password'
then
    HTTPREQ_PASSWORD="$(bashio::config 'httpreq_password')"
    echo "password ${HTTPREQ_PASSWORD}" >>/netrc
fi
