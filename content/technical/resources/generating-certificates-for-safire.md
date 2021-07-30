---
date: 2018-09-18 09:40:08+02:00
slug: generating-certificates-for-safire
tags:
  - configuration
  - metadata
  - technical
title: Generating certificates for SAFIRE
url: /technical/resources/generating-certificates-for-safire/
---

# Types of certificates

SAML installations typically use at least two[^1] different certificates: one of the public facing portions of a website, and one to establish a private trust relationship between providers. Whilst it is possible to use the same certificate for these two roles, this is not best practice nor is it recommended.

The technical requirements for [identity-]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) and [service-]({{< ref "/technical/saml2/sp-requirements/_index.md" >}})providers definitively specify the requirements and recommendations for these two types of certificates. What's below will give you some ideas on how to obtain/generate certificates that meet these requirements.

# Web server certificate

Your web server (i.e. Apache, nginx, Jetty, etc) should be configured using a certificate signed by a recognised certificate authority in the public key infrastructure – i.e. you need to use a certificate that will be trusted by end-user web browsers.

Simplistically, this is because your login page (IdPs) or service (SPs) will be directly accessed by the user's browser. However, during the authentication process, the single sign-on, single logout, or assertion consumer service endpoints specified in your metadata are also accessed by an end user's browser. Thus if this certificate is not trusted by your users' web browsers, they'll see certificate warnings during the login process.

The requirement is that you make use of "PKI that is reasonably likely to be embedded in the browser of all users of the identity and/or service provider." In most circumstances, this means a commercial certificate authority that participates in the [CA/browser forum](https://cabforum.org/). The [validator](https://validator.safire.ac.za/) checks this with [cURL's root certificate bundle](https://curl.haxx.se/docs/caextract.html).

It is not for SAFIRE to recommend a CA --- you can use [any commercial certificate authority](https://www.sslshopper.com/) of your choosing and that meets your individual requirements. It cost is an issue, consider something like [Let's Encrypt](https://letsencrypt.org/).  If you're eligible, the [SA NREN certificate service](https://www.tenet.ac.za/services/certs) may also be an option.

# SAML signing certificate

Your SAML signing certificate should **not** use public key infrastructure. This certificate is never presented to an end user's browser, it is only used to sign SAML messages between providers.

SAFIRE uses the [explicit key trust model](https://spaces.at.internet2.edu/display/InCFederation/Managing+Trust+in+Keys+Used+for+Metadata), which is defined in the [deployment profile]({{< ref "/technical/saml2/deployment-profiles.md" >}}). The trust relationship here is set up by explicitly specifying the keys in metadata exchange. The metadata itself forms the trust anchor, and thus there is no need for a trusted root certificate.

At the most simple level, using PKI for this certificate is a waste of money. However, there are a number of good reasons to prefer a self-signed certificate.

The one that's most often relevant is that commercially signed certificates tend to have relatively short validity periods (three months for Let's Encrypt; 1-3 years for paid-for CAs). This works well with browsers where there is a long-lived root certificate acting as a trust anchor. Because your metadata is the anchor in SAML, you will need to remember to update metadata (and possibly perform key rollover) each time you change your certificate. At best this creates unnecessary churn and extra work, and at worst, you forget and your provider potentially stops working.

It is (relatively) easy to revoke your web server's certificate if it is compromised because browsers understand [certificate revocation lists](https://en.wikipedia.org/wiki/Certificate_revocation_list). There's no equivalent in metadata, and revoking a compromised certificate involves new metadata and a potentially disruptive key rollover. This means that from a risk perspective, it also makes sense to use a separate private key to the public-facing parts of your web server (depending on how your deploy your provider, this may even be privilege separated). This would mean maintaining a separate certificate too.

Best practice is to use a long-lived self-signed certificate for SAML signing. SAFIRE recommends generating a certificate that is valid for at least **ten years**. You should use an [appropriate bit length](https://www.keylength.com/en/compare/?twirl=0&parambase={{< year 10 >}}) to ensure the key will remain secure throughout its lifetime.

## Generating a self-signed cert

To generate a self-signed certificate that meets SAFIRE's recommendations using OpenSSL, you need to do something like this (replacing the Example bits to match your organisation):

```bash
# separated to ensure BasicConstraints=CA:FALSE
openssl req -newkey rsa:3072 -keyout example_ac_za.pem -new -subj '/C=ZA/O=Example University/CN=idp.example.ac.za' -sha256 -out example_ac_za.req
openssl x509 -in example_ac_za.req -req -days 3652 -sha256 -signkey example_ac_za.pem -out example_ac_za.crt
```

The example above generates a private key that is password protected. You will need to specify your password in your provider configuration. Alternatively, you can add -nodes to each of the command lines to remove the password.

To add the above key and certificate to SimpleSAMLphp, [try something like this]({{< ref "/technical/resources/configuring-simplesamlphp-for-safire.md" >}}) your authsources.php or saml20-idp-hosted.php (as appropriate):

```php
'privatekey' => 'example_ac_za.pem',
'privatekey_pass' => 'YourPrivateKeyPassphrase', /* you encrypt your private key, right? */
'certificate' => 'example_ac_za.crt',
```

To add it to the Shibboleth Native SP, [try something like this]({{< ref "/technical/resources/configuring-shibboleth-service-provider-for-safire.md" >}}) in shibboleth2.xml:

```xml
<!-- Simple file-based resolver for using a single keypair. -->
<CredentialResolver type="File" key="example_ac_za.pem" password="YourPrivateKeyPassphrase" certificate="example_ac_za.crt"/>
```

[^1]: There are actually three: metadata is often signed with a separate certificate, which is also self-signed and uses the explicit key trust model. However in the context of federation, provider metadata is exchanged completely out-of-band and so you do not need to generate this certificate nor do you need to sign your metadata. (You should, however, verify the signature on [SAFIRE's metadata]({{< ref "/technical/metadata.md" >}}).)
