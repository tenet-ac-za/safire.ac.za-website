---
date: 2023-03-27 14:08:00+02:00
slug: configuring-simplesamlphp-for-safire
tags:
  - configuration
  - metadata
  - simplesamlphp
  - technical
title: Configuring SimpleSAMLphp for SAFIRE
url: /technical/resources/configuring-simplesamlphp-for-safire/
---

[SimpleSAMLphp](https://simplesamlphp.org/) has [good documentation](https://simplesamlphp.org/docs/stable/), and so this is not a complete/worked example of how to configure it. Instead this provides the SAFIRE-specific snippets you may need when working through that documentation.

# Configuring metarefresh to fetch SAFIRE metadata

You should use the metarefresh and cron modules to manage SAFIRE's metadata automatically. SimpleSAMLphp provides documentation on [automated metadata management](https://github.com/simplesamlphp/simplesamlphp-module-metarefresh/blob/master/docs/simplesamlphp-automated_metadata.md) which explains the basics of how you set this up. This document assumes you have a [working cron module](https://simplesamlphp.org/docs/stable/cron:cron) and have [installed and enabled metarefresh](https://github.com/simplesamlphp/simplesamlphp-module-metarefresh/blob/master/docs/simplesamlphp-automated_metadata.md#preparations).

## Configure metarefresh

The first thing you need to do is configure the metarefresh module to fetch SAFIRE's metadata. The following sample `config/module_metarefresh.php` (called `config-metarefresh.php` in SimpleSAMLphp 1.x) configures SimpleSAMLphp to fetch SAFIRE's metadata once per hour:

```php
<?php
/*
 * Sample module_metarefresh.php for the South African Identity Federation
 */
$config = [
    'sets' => [
        'safire' => [
            'cron' => ['hourly'],
            'sources' => [
                /*
                 * 1: SAFIRE Federation Hub - this is needed on all Identity Providers, and
                 * on Service Providers that wish to make use of centralised discovery.
                 */
                [
                    'conditionalGET' => true,
                    'src' => 'https://metadata.safire.ac.za/safire-hub-metadata.xml',
                    'certificates' => ['safire-metadata.crt'],
                    'template' => [
                        'tags' => ['safire'],
                        'authproc' => [
                            51 => ['class' => 'core:AttributeMap', 'oid2name'],
                        ],
                        /* adapt these for your own internal names and participation level */
                        'attributes' => [
                          /* minimum attributes required for participation */
                          'displayName', 'eduPersonPrincipalName', 'eduPersonScopedAffiliation',
                          'givenName', 'mail', 'sn',
                          /* optional attributes (send as many as you can) */
                          'eduPersonAffiliation', 'eduPersonAssurance', 'eduPersonEntitlement',
                          'eduPersonOrcid', 'eduPersonPrimaryAffiliation', 'preferredLanguage',
                          'schacHomeOrganization', 'subject-id', 'pairwise-id',
                        ],
                        /* SAFIRE federation hub handles consent/transfer notification */
                        'consent.disable' => true,
                    ],
                ],
                /*
                 * 2: SAFIRE IdP Proxies - this is only needed on Service Providers that
                 * wish to make use of their own local discovery.
                 */
                [
                    'conditionalGET' => true,
                    'src' => 'https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml',
                    'certificates' => ['safire-metadata.crt'],
                    'template' => [
                        'tags'  => ['safire'],
                        'authproc' => [
                            51 => ['class' => 'core:AttributeMap', 'oid2name'],
                        ],
                        /* adapt these for your own internal names and participation level */
                        'attributes' => [
                          /* minimum attributes required for participation */
                          'displayName', 'eduPersonPrincipalName', 'eduPersonScopedAffiliation',
                          'givenName', 'mail', 'sn',
                          /* optional attributes (send as many as you can) */
                          'eduPersonAffiliation', 'eduPersonAssurance', 'eduPersonEntitlement',
                          'eduPersonOrcid', 'eduPersonPrimaryAffiliation', 'preferredLanguage',
                          'schacHomeOrganization', 'subject-id', 'pairwise-id',
                        ],
                        /* SAFIRE federation hub handles consent/transfer notification */
                        'consent.disable' => true,
                    ],
                ],
            ],
            'expireAfter' => 60 * 60 * 24 * 7, // Maximum 7 days cache time
            'outputDir' => 'metadata/metadata-generated/',
            'outputFormat' => 'serialize',
            'types' => ['saml20-sp-remote','saml20-idp-remote'],
        ],
    ],
];
```

You'll note that there are two sources specified above. Only the first is necessary for identity providers (you can safely delete the second).

For service providers, you need to choose between using SAFIRE's central discovery (keep the first, delete the second) or running your own local discovery (keep the second, delete the first) --- there are pros and cons to both approaches, and you need to work out which works best for your service.

If your service provider is going to participate in eduGAIN, you additionally need to include the [eduGAIN IdP metadata]({{< ref "/technical/metadata.md#safire-service-providers-consuming-edugain-idps" >}}). In this case, local discovery is the only option that makes sense as central discovery does not include eduGAIN identity providers.

## Create directories

To get the above to work correctly, you need to create two directories within your SimpleSAMLphp installation and make them owned by your web server process (since the cron module runs as your web server):

```bash
cd /path/to/your/simplesamlphp;
mkdir -p data/ metadata/metadata-generated/;
chown www-data:www-data data/ metadata/metadata-generated/;
```

The data/ directory is necessary because we've set the 'conditionalGET' directive above: SAFIRE correctly sends HTTP 304 Not Modified responses, and so setting this to true will prevent metarefresh from unnecessarily fetching metadata.

## Alter your SimpleSAMLphp config

Finally, you need to alter you config/config.php to use the new metadata. To do this, find the 'metadata.sources' directive, and add the metadata/metadata-generated/ directory to it, something like this:

```php
'metadata.sources' => [
    ['type' => 'flatfile'],
    ['type' => 'serialize', 'directory' => 'metadata/metadata-generated'],
],
```

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it in your cert/ directory as as safire-metadata.crt. This will allow you to verify the integrity of SAFIRE's metadata.

## Test it works

If you go to the Federations tab of your SimpleSAMLphp admin portal, you should find a "Metarefresh: fetch metadata" link at the bottom. This will allow you to test that metarefresh can correctly fetch SAFIRE's metadata. Once you've run it, you should see entries in your remote metadata corresponding to the Federation.

If the cron module is correctly refreshing your metadata you should see log entries like this in SimpleSAMLphp's log:

```nohighlight
[b0160ff3fb] cron [metarefresh]: Executing set [safire]
```

# Configuring an Identity Provider

# Configure a hosted IdP

If you're using a SimpleSAMLphp [hosted IdP](https://simplesamlphp.org/docs/stable/simplesamlphp-reference-idp-hosted), you may need to add these options into your metadata/saml20-idp-hosted.php file:

```php
/*
 * Note that this is not a complete example!
 * It only shows options that must be set for SAFIRE
 */
$metadata['http://idp.example.ac.za/'] = [
    'host' => '__DEFAULT__',
    'scope' => ['yourrealm.example.ac.za', 'yourotherrealm.example.net'],
    'attributes.NameFormat' => 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
    'SingleSignOnServiceBinding' => ['urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'],
    'SingleLogoutServiceBinding' => ['urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'],
    'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
    /* convert the attributes to the format expected by SAFIRE */
    'attributes.NameFormat' => 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
    'authproc' => [
        100 => ['class' => 'core:AttributeMap', 'name2oid'],
        /* subject identifier - separated to ensure it only ever processes after name2oid */
        101 => ['class' => 'core:AttributeMap', 'name2urn',],
    ],

];
```

To produce better automated metadata, you should also configure the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui) correctly. (There's a [sample saml20-idp-hosted.php](/wp-content/uploads/2017/02/saml20-idp-hosted.php.txt) file available to help you do this.)

## Configure attribute release

If you're using SimpleSAMLphp as an identity provider, you need to configure an internal authentication source (e.g. [ldap:LDAP](https://simplesamlphp.org/docs/stable/ldap:ldap)) to provide [all of the attributes required by SAFIRE]({{< ref "/technical/attributes/_index.md" >}}). You may also need to configure [authentication processing filters](https://simplesamlphp.org/docs/stable/simplesamlphp-authproc) to map your internal attributes into the correct OID format. How you do this is site-specific and beyond the scope of this document.

# Configuring a Service Provider

## Configure SSO

If you're using SimpleSAMLphp as a service provider, you'll need to choose a discovery service to allow it to find a suitable identity provider for a user. SimpleSAMLphp comes with a number of built-in options, but it may be better to use [Seamless Access](https://seamlessaccess.org/).

Whatever discovery service you choose, you should follow it's documentation for installing it. or Seamless Access's [standard integration](https://seamlessaccess.atlassian.net/wiki/spaces/DOCUMENTAT/pages/84738148/Standard+Integration), that means:

```php
$config = [
    'default-sp' => [
        'saml:SP',
        'entityID' => 'https://myapp.example.org/',
        'discoURL' => 'https://service.seamlessaccess.org/ds',
    ],
];
```

Provided you got the metadata step right, there’s no SAFIRE-specific configuration required.

### Legacy central discovery

It is possible configure SimpleSAMLphp to use SAFIRE's deprecated central discovery service, and previously this documentation covered it in detail. The gist is that you need to consume the [hub metadata]({{< ref "/technical/metadata.md#safire-federation-hub" >}}) and then configuring login in your [saml:SP configuration](https://simplesamlphp.org/docs/stable/saml:sp) as below. However, while marginally simpler, using this method does not comply with current user interface best practices and is therefore not recommended for new deployments.

```php
$config = [
    'default-sp' => [
        'saml:SP',
        'entityID' => 'https://myapp.example.org/',
        'idp' => 'https://iziko.safire.ac.za/',
    ],
];
```

## Improve SP metadata

To produce better automated metadata, you should also configure the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui) correctly. (There's a [sample authsources.php](/wp-content/uploads/2017/02/authsources.php.txt)  file available to help you do this.)

# Other technical requirements

There are two additional [technical requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) that are not directly related to SimpleSAMLphp that you nevertheless need to meet for both [identity providers]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) and [service providers]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}).

## Logging requirements

You need to ensure that you configure log rotation of [SimpleSAMLphp's logs](https://simplesamlphp.org/docs/stable/simplesamlphp-maintenance#section_4) to meet the minimum retention period specified in the technical requirements. How you do this depends on your operating system.

## Time synchronisation

Most modern operating systems do syncronise time, but you should verify that your server is set to synchronise time against a reliable timesource (such as [za.pool.ntp.org](https://www.ntppool.org/zone/za)).
