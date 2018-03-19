---
date: 2016-12-14 09:16:16+00:00
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

Edit your shibboleth2.xml configuration file. In the default file, you will find an example <MetadataProvider>. At about that point in the file, you should add a new metadata provider for SAFIRE. These examples

If you wish to use SAFIRE's central discovery, your entry should be similar to the following:

```xml
<MetadataProvider type="XML"
    uri="https://metadata.safire.ac.za/safire-hub-metadata.xml"
    backingFilePath="safire-hub-metadata.xml"
    verifyHost="true"
    reloadInterval="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt"/>
</MetadataProvider>
```

If you wish to use your own local discovery, your entry should be similar to the following:

```xml
<MetadataProvider type="XML"
    uri="https://metadata.safire.ac.za/safire-idp-proxies-metadata.xml"
    backingFilePath="safire-idp-proxies-metadata.xml"
    verifyHost="true"
    reloadInterval="14400">
  <MetadataFilter type="RequireValidUntil" maxValidityInterval="2419200"/>
  <MetadataFilter type="Signature" certificate="safire-metadata.crt"/>
</MetadataProvider>
```

Note that you do not need both entries. Instead, you need to choose between using SAFIRE's central discovery (keep the first, delete the second) or running your own local discovery (keep the second, delete the first) --- there are pros and cons to both approaches, and you need to work out which works best for your service.

If your service provider is going to participate in eduGAIN, you additionally need to include the [eduGAIN IdP metadata]({{< ref "/technical/metadata.md#safire-service-providers-consuming-edugain-idps" >}}). In this case, local discovery is the only option that makes sense as central discovery does not include eduGAIN identity providers.

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it in your Shibboleth directory as safire-metadata.crt. This will allow you to verify the integrity of SAFIRE's metadata.

## Test it works

If you restart shibd, you should see an entry in /var/log/shibboleth/shibd.log similar to the following:

INFO OpenSAML.MetadataProvider.XML : loaded XML resource (https://metadata.safire.ac.za/safire-hub-metadata.xml)

# Configure SSO

To allow the Shibboleth SP to find an identity provider, you need to configure the <SSO> stanza in shibboleth2.xml. How you do this will depend on whether you've opted for centralised discovery or local discovery.

SAFIRE's central discovery service provides the simplest configuration since the federation hub merely looks like a single identity provider. To use central discovery, you need to configure SSO like this:

```xml
<SSO entityID="https://iziko.safire.ac.za/">
  SAML2
</SSO>
```

Note that references to SAML1 have been removed, because SAFIRE only supports SAML2.

If you want to use local discovery, you will need to install and configure a discovery service such as [Shibboleth Embedded Discovery Service](http://shibboleth.net/products/embedded-discovery-service.html) or [DiscoJuice](http://discojuice.org/). Provided you got the metadata step right, there's no SAFIRE-specific configuration required. Your <SSO> stanza just needs to point at your discovery service.

# Configure attribute mapping

To take full advantage of SAFIRE, you need to configure an attribute map to support all of SAFIRE's [attributes](/technical/attributes/). The default attribute-map.xml will support the basics, and you can use our [sample attribute map](https://testsp.safire.ac.za/attribute-map.xml) to construct a more complete version.

# Improving generated metadata

By default, Shibboleth publishes its generated metadata at a well-known URL (https://your.shib.server/Shibboleth.sso/Metadata). You can use this to obtain the copy of metadata you need to supply to SAFIRE. However, but default the auto-generated metadata does not include many of the [required elements](/technical/saml2/idp-requirements/).

You can improve the generated metadata (and thus require less editing) by providing Shibboleth with a template containing the additional elements you wish to include in your metadata. To do this, you need to find and edit the MetadataGenerator handler stanza in your config file to match this:

```xml
<Handler type="MetadataGenerator" Location="/Metadata" signing="false" template="metadata.xml" https="true" http="false" />
```

Then create metadata.xml as a stub containing those elements you wish to add to the generated metadata ([an example is available](/wp-content/uploads/2016/12/metadata.xml)). Save it in your Shibboleth config directory.

