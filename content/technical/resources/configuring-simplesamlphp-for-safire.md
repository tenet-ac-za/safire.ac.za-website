---
date: 2017-11-03 07:47:32+00:00
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

You should use the metarefresh and cron modules to manage SAFIRE's metadata automatically. SimpleSAMLphp provides documentation on [automated metadata management](https://simplesamlphp.org/docs/stable/simplesamlphp-automated_metadata) which explains the basics of how you set this up. This document assumes you have a [working cron module](https://simplesamlphp.org/docs/stable/simplesamlphp-automated_metadata#section_5) and have [enabled metarefresh](https://simplesamlphp.org/docs/stable/simplesamlphp-automated_metadata#section_2).

## Configure metarefresh

The first thing you need to do is configure the metarefresh module to fetch SAFIRE's metadata. The following sample config/config-metarefresh.php configures SimpleSAMLphp to fetch SAFIRE's metadata once per hour:

```php
<?php
/*
 * Sample config-metarefresh.php for the South African Identity Federation
 */
$config = array(
    'sets' => array(
        'safire' => array(
            'cron' => array('hourly'),
            'sources' => array(
                /*
                 * 1: SAFIRE Federation Hub - this is needed on all Identity Providers, and
                 * on Service Providers that wish to make use of centralised discovery.
                 */
                array(
                    'conditionalGET' => true,
                    'src' => 'https://metadata.safire.ac.za/safire-hub-metadata.xml',
                    'certificates' => array('safire-metadata.crt'),
                    'template' => array(
                        'tags' => array('safire'),
                        'authproc' => array(
                            51 => array('class' => 'core:AttributeMap', 'oid2name'),
                        ),
                        /* adapt these for your own internal names and participation level */
                        'attributes' => array(
                          'eduPersonPrincipalName', 'givenName', 'sn', /* minimum */
                          'displayName', 'eduPersonAffiliation', 'mail', /* recommended */
                          'eduPersonEntitlement', 'eduPersonOrcid', 'eduPersonPrimaryAffiliation', 'eduPersonScopedAffiliation',
                          'employeeNumber', 'preferredLanguage', 'schacHomeOrganization',
                        ),
                        /* SAFIRE federation hub handles consent */
                        'consent.disable' => true,
                    ),
                ),
                /*
                 * 2: SAFIRE IdP Proxies - this is only needed on Service Providers that
                 * wish to make use of their own local discovery.
                 */
                array(
                    'conditionalGET' => true,
                    'src' => 'https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml',
                    'certificates' => array('safire-metadata.crt'),
                    'template' => array(
                        'tags'  => array('safire'),
                        'authproc' => array(
                            51 => array('class' => 'core:AttributeMap', 'oid2name'),
                        ),
                        /* adapt these for your own internal names and participation level */
                        'attributes' => array(
                          'eduPersonPrincipalName', 'givenName', 'sn', /* minimum */
                          'displayName', 'eduPersonAffiliation', 'mail', /* recommended */
                          'eduPersonEntitlement', 'eduPersonOrcid', 'eduPersonPrimaryAffiliation', 'eduPersonScopedAffiliation',
                          'employeeNumber', 'preferredLanguage', 'schacHomeOrganization',
                        ),
                        /* SAFIRE federation hub handles consent */
                        'consent.disable' => true,
                    ),
                ),
            ),
            'expireAfter' => 60*60*24*4, // Maximum 4 days cache time
            'outputDir' => 'metadata/safire-consuming/',
            'outputFormat' => 'flatfile',
            'types' => array('saml20-sp-remote','saml20-idp-remote'),
        ),
    ),
);
```

You'll note that there are two sources specified above. Only the first is necessary for identity providers (you can safely delete the second).

For service providers, you need to choose between using SAFIRE's central discovery (keep the first, delete the second) or running your own local discovery (keep the second, delete the first) --- there are pros and cons to both approaches, and you need to work out which works best for your service.

If your service provider is going to participate in eduGAIN, you additionally need to include the [eduGAIN IdP metadata]({{< ref "/technical/metadata.md#safire-service-providers-consuming-edugain-idps" >}}). In this case, local discovery is the only option that makes sense as central discovery does not include eduGAIN identity providers.

## Create directories

To get the above to work correctly, you need to create two directories within your SimpleSAMLphp installation and make them owned by your web server process (since the cron module runs as your web server):

```bash
cd /path/to/your/simplesamlphp;
mkdir -p data/ metadata/safire-consuming/;
chown www-data:www-data data/ metadata/safire-consuming/;
```

The data/ directory is necessary because we've set the 'conditionalGET' directive above: SAFIRE correctly sends HTTP 304 Not Modified responses, and so setting this to true will prevent metarefresh from unnecessarily fetching metadata.

## Alter your SimpleSAMLphp config

Finally, you need to alter you config/config.php to use the new metadata. To do this, find the 'metadata.sources' directive, and add the metadata/safire-consuming/ directory to it, something like this:

```php
'metadata.sources' => array(
    array('type' => 'flatfile'),
    array('type' => 'flatfile', 'directory' => 'metadata/safire-consuming'),
),
```

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it in your cert/ directory as as safire-metadata.crt. This will allow you to verify the integrity of SAFIRE's metadata.

## Test it works

If you go to the Federations tab of your SimpleSAMLphp web page, you should find a "Metarefresh: fetch metadata" link at the bottom. This will allow you to test that metarefresh can correctly fetch SAFIRE's metadata. Once you've run it, you should see entries in your remote metadata corresponding to the Federation.

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
$metadata['__DYNAMIC:1__'] = array(
    'scope' => array('yourrealm.example.net', 'yourotherrealm.example.net'),
    'attributes.NameFormat' => 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
    'SingleSignOnServiceBinding' => array('urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'),
    'SingleLogoutServiceBinding' => array('urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect'),
    'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
);
```

To produce better automated metadata, you should also configure the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui) correctly. (There's a [sample saml20-idp-hosted.php](/wp-content/uploads/2017/02/saml20-idp-hosted.php.txt) file available to help you do this.)

## Configure attribute release

If you're using SimpleSAMLphp as an identity provider, you need to configure an internal authentication source (e.g. [ldap:LDAP](https://simplesamlphp.org/docs/stable/ldap:ldap)) to provide [all of the attributes required by SAFIRE](/technical/attributes/). You may also need to configure [authentication processing filters](https://simplesamlphp.org/docs/stable/simplesamlphp-authproc) to map your internal attributes into the correct OID format. How you do this is site-specific and beyond the scope of this document.

# Configuring a Service Provider

## Configure SSO

If you're using SimpleSAMLphp as a service provider and you want to use SAFIRE's central discovery service, you need to add an 'idp' attribute to your [saml:SP configuration](https://simplesamlphp.org/docs/stable/saml:sp) in config/authsources.php:

```php
$config = array(
    'default-sp' => array(
        'saml:SP',
        'idp' => 'https://iziko.safire.ac.za/',
    ),
);
```

If you want to use local discovery, no SAFIRE-specific configuration should be required provided you got the metadata step correct.

To produce better automated metadata, you should also configure the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui) correctly. (There's a [sample authsources.php](/wp-content/uploads/2017/02/authsources.php.txt)  file available to help you do this.)

## Configure attribute mapping

SimpleSAMLphp's default attribute map contains almost all of SAFIRE's attributes. Depending on what version you're using, you [may need to add eduPersonOrcid](https://github.com/simplesamlphp/simplesamlphp/commit/63c7abf68deb670f85c6567366c7df83d1a43b67) if you need it.
