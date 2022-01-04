---
date: 2021-02-01 19:20:00+02:00
slug: configuring-shibboleth-service-provider-for-safire
tags:
  - configuration
  - metadata
  - shibboleth
  - technical
title: Configuring Shibboleth Service Provider for SAFIRE
url: /technical/resources/configuring-shibboleth-service-provider-for-safire/
---

The [Shibboleth Service Provider](http://shibboleth.net/products/) has [good documentation](https://shibboleth.atlassian.net/wiki/spaces/SP3/overview), and so this is not a complete/worked example of how to configure it. Instead, this provides the SAFIRE-specific snippets you may need when working through that documentation.

# Installing Shibboleth Service Provider

Note that some package repositories ship out-of-date and [vulnerable](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2067399654/SecurityAdvisories) versions of the Shibboleth SP. However, the Swiss federation operator (SWITCHaai) maintains [up-to-date packages for Debian and Ubuntu](http://pkg.switch.ch/switchaai/).

# Choose an entityID

Perhaps the single most important thing you can do is choose an entityID, which you'll find in the `<ApplicationDefaults>` stanza in `shibboleth2.xml`. The entityID uniquely identifies your service and *should never change*, so needs to be [chosen carefully](https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/928645134/EntityNaming). SAFIRE [requires]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) it be a URL rooted in DNS space you own.

# Configuring a metadata provider to fetch SAFIRE metadata

Shibboleth Service Provider provides a [reloadable XML metadata provider](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2063696005/XMLMetadataProvider) that allows you to periodically fetch metadata. You should use this to keep SAFIRE's metadata up-to-date, checking for new metadata at least once a day (the example below checks every four hours).

## Configure Shibboleth

Edit your `shibboleth2.xml` configuration file. In the default file, you will find some example `<MetadataProvider>`s. At about that point in the file, you should add a new metadata provider to consume [SAFIRE's metadata for service providers]({{< ref "/technical/metadata.md#metadata-for-service-providers" >}}).

If you are only interested in South African institutions, your entry be similar to the following:

```xml
<MetadataProvider type="XML" validate="true"
    url="https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml"
    backingFilePath="safire-idp-proxy-metadata.xml"
    maxRefreshDelay="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt"/>
  <DiscoveryFilter type="Blacklist" matcher="EntityAttributes" trimTags="true"
    attributeName="http://macedir.org/entity-category"
    attributeNameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
    attributeValue="http://refeds.org/category/hide-from-discovery" />
</MetadataProvider>
```

If your service provider is going to participate in eduGAIN (internationally), you additionally need to include the [eduGAIN IdP metadata]({{< ref "/technical/metadata.md#safire-service-providers-consuming-edugain-idps" >}}):

```xml
<MetadataProvider type="XML" validate="true"
    url="https://metadata.safire.ac.za/edugain-consuming.xml"
    backingFilePath="safire-edugain-consuming.xml"
    maxRefreshDelay="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt" verifyBackup="false"/>
  <DiscoveryFilter type="Blacklist" matcher="EntityAttributes" trimTags="true"
    attributeName="http://macedir.org/entity-category"
    attributeNameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
    attributeValue="http://refeds.org/category/hide-from-discovery" />
</MetadataProvider>
```

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it in your Shibboleth directory as `safire-metadata.crt`. This will allow you to verify the integrity of SAFIRE's metadata.

## Test it works

If you restart shibd, you should see an entry in `/var/log/shibboleth/shibd.log` similar to the following:

INFO OpenSAML.MetadataProvider.XML : loaded XML resource (safire-idp-proxy-metadata.xml)

# Choose a Discovery Service

To allow the Shibboleth SP to find a suitable identity provider for a user, you will need a discovery service. There are a number of options available:

 * The [Seamless Access](https://seamlessaccess.org/) provides a Javascript-based discovery services that is served from a CDN.
 * The [Shibboleth Embedded Discovery Service](https://shibboleth.atlassian.net/wiki/spaces/EDS10/overview) can be used as-is, or customised to create a discovery service that matches your site's look and feel.
 * Anything else supporting the [SAML2 IdP Discovery Protocol](https://wiki.oasis-open.org/security/IdpDiscoSvcProtonProfile).

The Shibboleth EDS is a good choice if all you're trying to do is authenticate South African institutions, but we'd recommend looking at Seamless Access for most use cases.

Whatever discovery service you choose, you should follow it's documentation for installing it. Provided you got the metadata step right, there’s no SAFIRE-specific configuration required.

#### Legacy central discovery

It is possible configure Shibboleth SP to use SAFIRE's deprecated central discovery service, and previously this documentation covered it in detail. The gist is that you need to consume the [hub metadata]({{< ref "/technical/metadata.md#safire-federation-hub" >}}) and then configuring login as below. However, while marginally simpler, using this method does not comply with current user interface best practices and is therefore not recommended for new deployments.

```xml
<SSO entityID="https://iziko.safire.ac.za/">
  SAML2
</SSO>
```

# Configure SSO

Once you have a discovery service and you will need to configure the `<SSO>` stanza in shibboleth2.xml to point to it. For Seamless Access's [standard integration](https://seamlessaccess.atlassian.net/wiki/spaces/DOCUMENTAT/pages/84738148/Standard+Integration), that means:

```xml
<SSO discoveryProtocol="SAMLDS" discoveryURL="https://service.seamlessaccess.org/ds">
  SAML2
</SSO>
```

You should replace the `discoveryURL` above according the the documentation for your chosen discovery service.

Note that you should remove any legacy references to SAML1 in the `<SSO>` and `<Logout>` stanzas because SAFIRE only supports SAML2.

# Configure attribute mapping

To take full advantage of SAFIRE, you need to configure an attribute map to support all of SAFIRE's [attributes]({{< ref "/technical/attributes/_index.md" >}}). The default attribute-map.xml will support the basics, and you can use our [sample attribute map](https://testsp.safire.ac.za/attribute-map.xml) to construct a more complete version.

# Improving generated metadata

By default, Shibboleth publishes its generated metadata at a well-known URL (https://your.shib.server/Shibboleth.sso/Metadata). You can use this to obtain the copy of metadata you need to supply to SAFIRE. However, but default the auto-generated metadata does not include many of the [required elements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}).

You can improve the generated metadata (and thus require less editing) by providing Shibboleth with a template containing the additional elements you wish to include in your metadata. To do this, you need to find and edit the MetadataGenerator handler stanza in your config file to match this:

```xml
<Handler type="MetadataGenerator" Location="/Metadata" signing="false" template="metadata.xml" https="true" http="false" />
```

Then create metadata.xml as a stub containing those elements you wish to add to the generated metadata ([an example is available](/wp-content/uploads/2016/12/metadata.xml)). Save it in your Shibboleth config directory.

# Other technical requirements

There are two additional [technical requirements]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) that are not directly related to SimpleSAMLphp that you nevertheless need to meet.

## Logging requirements

You need to ensure that you configure log rotation of [Shibboleth SP's logs](https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065334602/Logging) to meet the minimum retention period specified in the technical requirements. How you do this depends on your operating system.

## Time synchronisation

Most modern operating systems do syncronise time, but you should verify that your server is set to synchronise time against a reliable timesource (such as [za.pool.ntp.org](https://www.ntppool.org/zone/za)).
