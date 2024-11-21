# Cornelicorn Home Assistant Add-on: Letsencrypt

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
2. Find the "letsencrypt httpreq" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

The Letsencrypt add-on can be configured via the add-on interface.
The configuration via YAML is also possible, see the examples below.

Navigate in your Home Assistant frontend to the add-ons overview page at
**Settings** -> **Add-ons**, and pick the **Let's Encrypt httpreq** add-on. On the top,
pick the **Configuration** page.

Provide the domain names to issue certificates for. Additionally, provide the
server used for the http requests, and path values for **Priv Key File**
and **Certificate File**.

The add-on by default uses Let's Encrypt's staging server to retrieve certificates.
Turn the **Staging** switch off after you ensured you can get a certificate with
your configuration.

### HTTPREQ settings

This add-on uses a lego-style httpreq request against a configurable server to
update the TXT value in DNS.

The available config options are

```yaml
httpreq_host: "https://example.com/api/lego"
httpreq_user: ""
httpreq_password: ""
dns_propagation_delay: 30
```

`httpreq_user` and `httpreq_password` are used for HTTP Basic Auth, if provided.
`dns_propagation_delay` is the delay to wait for dns propagation after adding
the records and before the validation is started.

### Configure certificate files

The certificate files will be available within the "ssl" share after successful
request of the certificates.

By default other addons are referring to the correct path of the certificates.
You can in addition find the files via the "samba" addon within the "ssl" share.

For example, to use the certificates provided by this add-on to enable TLS on
Home Assistant in the default paths, add the following lines to Home
Assistant's main configuration file, `configuration.yaml`:

```yaml
# TLS with letsencrypt add-on
http:
  server_port: 443
  ssl_certificate: /ssl/fullchain.pem
  ssl_key: /ssl/privkey.pem
```

### Create & renew certificates

The letsencrypt add-on creates the certificates once it is started: navigate
to **Settings** -> **Add-ons**, pick the **Let's Encrypt** add-on, click the
**START** button on the bottom. The add-on stops once the certificates are
created.

Certificates are not renewed automatically by the plugin. The add-on has to be
started again to renew certificates. If the add-on is started again, it checks
if the certificates are due for renewal. This is usually the case 30 days
before the certificates' due date. If the certificates are not due for renewal,
the add-on terminates without changes. If the certificates are due for renewal,
new certificates will be created.

There are multiple ways how the add-on can be started to check/renew the
certificates. One way to automate the certificate renewal it to configure a
renewal via [Home Assistant automation][haauto], and then restarting this
automation every night via the [Supervisor Addon restart action][supervisorrestart].

[haauto]: https://www.home-assistant.io/docs/automation/editor/
[supervisorrestart]: https://www.home-assistant.io/integrations/hassio/#service-hassioaddon_restart

In this example, the automation will run every day at the chosen time, checking
if a renewal is due, and will request it if needed.

## Certificate files

The certificate files will be available within the "ssl" share after successful request of the certificates.

By default other addons are referring to the correct path of the certificates.
You can in addition find the files via the "samba" addon within the "ssl" share.
