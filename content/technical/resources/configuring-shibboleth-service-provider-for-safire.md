---
date: 2019-10-03 22:00:00+02:00
slug: configuring-shibboleth-service-provider-for-safire
tags:
  - configuration
  - metadata
  - shibboleth
  - technical
title: Configuring Shibboleth Service Provider for SAFIRE
url: /technical/resources/configuring-shibboleth-service-provider-for-safire/
---

The [Shibboleth Service Provider](http://shibboleth.net/products/service-provider.html) has [good documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/Installation), and so this is not a complete/worked example of how to configure it. Instead, this provides the SAFIRE-specific snippets you may need when working through that documentation.

# Installing Shibboleth Service Provider

Note that some package repositories ship out-of-date and [vulnerable](https://wiki.shibboleth.net/confluence/display/SHIB2/SecurityAdvisories) versions of the Shibboleth SP. However, the Swiss federation operator (SWITCHaai) maintains [up-to-date packages for Debian and Ubuntu](http://pkg.switch.ch/switchaai/).

# Configuring a metadata provider to fetch SAFIRE metadata

Shibboleth Service Provider provides a [dynamic metadata provider](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPMetadataProvider#NativeSPMetadataProvider-DynamicMetadataProvider) that allows you to periodically fetch metadata. You should use this to keep SAFIRE's metadata up-to-date, checking for new metadata at least once a day (the example below checks every four hours).

## Configure Shibboleth

Edit your shibboleth2.xml configuration file. In the default file, you will find an example `<MetadataProvider>`. At about that point in the file, you should add a new metadata provider to consume [SAFIRE's metadata for service providers]({{< ref "/technical/metadata.md#metadata-for-service-providers" >}}).

If you are only interested in South African institutions, your entry be similar to the following:

```xml
<MetadataProvider type="XML"
    uri="https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml"
    backingFilePath="safire-idp-proxy-metadata.xml"
    reloadInterval="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt"/>
</MetadataProvider>
```

If your service provider is going to participate in eduGAIN (internationally), you additionally need to include the [eduGAIN IdP metadata]({{< ref "/technical/metadata.md#safire-service-providers-consuming-edugain-idps" >}}):

```xml
<MetadataProvider type="XML"
    uri="https://metadata.safire.ac.za/edugain-consuming.xml"
    backingFilePath="safire-edugain-consuming.xml"
    reloadInterval="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt" verifyBackup="false"/>
</MetadataProvider>
```

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it in your Shibboleth directory as safire-metadata.crt. This will allow you to verify the integrity of SAFIRE's metadata.

## Test it works

If you restart shibd, you should see an entry in /var/log/shibboleth/shibd.log similar to the following:

INFO OpenSAML.MetadataProvider.XML : loaded XML resource (safire-idp-proxy-metadata.xml)

# Choose a Discovery Service

To allow the Shibboleth SP to find a suitable identity provider for a user, you will need a discovery service. There are a number of options available:

 * The [Shibboleth Embedded Discovery Service](http://shibboleth.net/products/embedded-discovery-service.html) can be used as-is, or customised to create a discovery service that matches your site's look and feel.
 * Both [eduTEAMS](https://wiki.geant.org/display/ED/Discovery+Service) and [Seamless Access](https://seamlessaccess.org/) provide Javascript-based discovery services that are served from a CDN.
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

Once you have a discovery service and you will need to configure the `<SSO>` stanza in shibboleth2.xml to point to it:
```xml
<SSO discoveryProtocol="SAMLDS"
     discoveryURL="https://sp.example.ac.za/path/to/ds">
    SAML2
</SSO>
```
You should set the `discoveryURL` according the the documentation for your chosen discovery service.

Note that you should remove references to SAML1 in the `<SSO>` and `<Logout>` stanzas because SAFIRE only supports SAML2.

# Configure attribute mapping

To take full advantage of SAFIRE, you need to configure an attribute map to support all of SAFIRE's [attributes](/technical/attributes/). The default attribute-map.xml will support the basics, and you can use our [sample attribute map](https://testsp.safire.ac.za/attribute-map.xml) to construct a more complete version.

# Improving generated metadata

By default, Shibboleth publishes its generated metadata at a well-known URL (https://your.shib.server/Shibboleth.sso/Metadata). You can use this to obtain the copy of metadata you need to supply to SAFIRE. However, but default the auto-generated metadata does not include many of the [required elements](/technical/saml2/idp-requirements/).

You can improve the generated metadata (and thus require less editing) by providing Shibboleth with a template containing the additional elements you wish to include in your metadata. To do this, you need to find and edit the MetadataGenerator handler stanza in your config file to match this:

```xml
<Handler type="MetadataGenerator" Location="/Metadata" signing="false" template="metadata.xml" https="true" http="false" />
```

Then create metadata.xml as a stub containing those elements you wish to add to the generated metadata ([an example is available](/wp-content/uploads/2016/12/metadata.xml)). Save it in your Shibboleth config directory.

