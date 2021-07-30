---
date: 2016-12-14 12:47:50+00:00
slug: configuring-shibboleth-identity-provider-for-safire
tags:
  - configuration
  - metadata
  - shibboleth
  - technical
title: Configuring Shibboleth Identity Provider for SAFIRE
url: /technical/resources/configuring-shibboleth-identity-provider-for-safire/
---

These instructions are based on the Shibboleth documentation and have not been extensively tested. If you use Shibboleth IdPv4, please feel free to [submit revisions]({{< ref "/safire/contact/_index.md" >}}) if necessary.

The [Shibboleth Identity Provider](http://shibboleth.net/products/) has [good documentation](https://wiki.shibboleth.net/confluence/display/IDP30), and so this is not a complete/worked example of how to configure it. Instead this provides the SAFIRE-specific snippets you may need when working through that documentation.

# Configuring a metadata provider to fetch SAFIRE metadata

The Shibboleth Identity Provider provides a [FileBackedHTTPMetadataProvider](https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631639/FileBackedHTTPMetadataProvider) that allows you to periodically fetch metadata. You should use this to keep SAFIRE's metadata up-to-date, checking for new metadata at least once a day (the example below checks every four hours).

## Configure a provider

To configure a metadata provider, edit conf/metadata-providers.xml and add the following:

```xml
<MetadataProvider id="SAFIREHubMetadata"
    xsi:type="FileBackedHTTPMetadataProvider"
    backingFile="%{idp.home}/metadata/safire-hub-metadata.xml"
    metadataURL="http://metadata.safire.ac.za/safire-hub-metadata.xml">
  <MetadataFilter xsi:type="SignatureValidation" certificateFile="%{idp.home}/credentials/safire-metadata.crt" />
  <MetadataFilter xsi:type="RequiredValidUntil" maxValidityInterval="P28D"/>
  <MetadataFilter xsi:type="EntityRoleWhiteList">
    <RetainedRole>md:SPSSODescriptor</RetainedRole>
  </MetadataFilter>
</MetadataProvider>
```

## Download SAFIRE's signing cert

Download a copy of [SAFIRE's signing certificate]({{< ref "/technical/metadata.md" >}}) and save it as credentials/safire-metadata.crt. This will allow you to verify the integrity of SAFIRE's metadata.

# Disable consent

If you have consent enabled (on by default), you need to disable it for the SAFIRE hub. To do this, add the following override to conf/relying-party.xml:

```xml
<util:list id="shibboleth.RelyingPartyOverrides">
  <bean parent="RelyingPartyByName" c:relyingPartyIds="https://iziko.safire.ac.za/">
    <property name="profileConfigurations">
      <list>
        <!-- SAFIRE hub handles consent -->
        <bean parent="Shibboleth.SSO" />
        <bean parent="SAML2.SSO" />
      </list>
    </property>
  </bean>
</util:list>
```

# Configure attribute release

You will need to configure Shibboleth Identity Provider to make use of an internal authentication source (e.g. [LDAP](https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631612/LDAPAuthnConfiguration), and you make use of an [attribute resolver](https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631549/AttributeResolverConfiguration) to provide [all of the attributes required by SAFIRE]({{< ref "/technical/attributes/_index.md" >}}). How you do this is site-specific and beyond the scope of this document.

Once you've done that, you need an attribute filter that will release the attributes to SAFIRE:

```xml
<AttributeFilterPolicy id="SAFIREAttributeFilter">
  <PolicyRequirementRule xsi:type="Requester" value="https://iziko.safire.ac.za/" />

  <!-- These are required for participation -->
  <AttributeRule attributeID="eduPersonPrincipalName">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="givenName">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="sn">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>

  <!-- These are strongly recommended, and needed for R&S -->
  <AttributeRule attributeID="displayName">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="eduPersonAffiliation">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="mail">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <!--
    These are optional and should be uncommented if your
    identity provider is able to support them
  -->
  <!--
  <AttributeRule attributeID="eduPersonEntitlement">
  <PermitValueRule xsi:type="ANY" />
    </AttributeRule>
  <AttributeRule attributeID="eduPersonOrcid">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="eduPersonPrimaryAffiliation">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="eduPersonScopedAffiliation">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="employeeNumber">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="preferredLanguage">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  <AttributeRule attributeID="schacHomeOrganization">
    <PermitValueRule xsi:type="ANY" />
  </AttributeRule>
  -->
</AttributeFilterPolicy>
```

# Other technical requirements

There are two additional [technical requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) that are not directly related to Shibboleth that you nevertheless need to meet.

## Logging requirements

You need to ensure that you configure log rotation of [Shibboleth IdP's logs](https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631710/LoggingConfiguration) to meet the minimum retention period specified in the technical requirements. How you do this depends on your operating system.

## Time synchronisation

Most modern operating systems do syncronise time, but you should verify that your server is set to synchronise time against a reliable timesource (such as [za.pool.ntp.org](https://www.ntppool.org/zone/za)).

