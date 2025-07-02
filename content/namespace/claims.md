---
date: 2021-06-04 08:00:00+02:00
slug: claims
title: https://safire.ac.za/namespace/claims
url: /namespace/claims
---

The **https\://safire.ac.za/namespace/claims** namespace is used to define some claims provider identifiers for use with Active Directory Federation Services (AD FS) and Microsoft Entra ID (formerly Azure AD). Whilst well defined, these are non-standard claims that are likely not interoperable outside of SAFIRE.

A non-normative schema for the namespace is available at https://safire.ac.za/namespace/claims.xsd.

# https\://safire.ac.za/namespace/claims namespace registry

| Prefix | Use/Description |
:--------|:----------------|
| **https\://safire.ac.za/namespace/claims**… | Used for claims provider identifiers in AD FS or Azure AD |
| https\://safire.ac.za/namespace/claims/unscopedAffiliationSingleton | Space delimited singleton representation of [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}), utilising the same limited vocabulary (defined here as `safire:AffiliationVocabularyType`). |
| https\://safire.ac.za/namespace/claims/unscopedAffiliationSingleton/… [^suffix] | Suffixed singleton that will be merged as-is into [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}), utilising the same limited vocabulary (defined here as `safire:AffiliationVocabularyType`). |
| https\://safire.ac.za/namespace/claims/scopedAffiliationSingleton | Space delimited singleton representation of [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}), utilising the same limited vocabulary. |
| https\://safire.ac.za/namespace/claims/scopedAffiliationSingleton/… [^suffix] | Suffixed singleton that will be merged as-is into  [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}), utilising the same limited vocabulary. |
| https\://safire.ac.za/namespace/claims/primaryAffiliationSingleton | Singleton representation of [eduPersonPrimaryAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}), utilising the same limited vocabulary. Not actually required, but here for completeness.|
| https\://safire.ac.za/namespace/claims/entitlementSingleton | Space delimited singleton representation of [eduPersonEntitlement]({{< ref "/technical/attributes/edupersonentitlement.md" >}}). |
| https\://safire.ac.za/namespace/claims/entitlementSingleton/… [^suffix] | Suffixed singleton that will be merged as-is into [eduPersonEntitlement]({{< ref "/technical/attributes/edupersonentitlement.md" >}}). |


# Examples

Note that mixing suffixed and unsuffixed singleton namespace is **not recommended** and may have undefined behaviour.
{.message-box .warning}

#### Unsuffixed singletons

A SAML attribute statement containing the following attribute:
```xml
<saml:Attribute
    Name="https://safire.ac.za/namespace/claims/unscopedAffiliationSingleton"
    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
>
    <saml:AttributeValue>member staff</saml:AttributeValue>
</saml:Attribute>
```
will be re-mapped to:
```xml
<saml:Attribute
    Name="urn:oid:1.3.6.1.4.1.5923.1.1.1.1"
    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
>
    <saml:AttributeValue>member</saml:AttributeValue>
    <saml:AttributeValue>staff</saml:AttributeValue>
</saml:Attribute>
```

#### Suffixed singletons

The suffixed singletons can be specified multiple times, so long as each suffix is unique. Thus, a SAML attribute statement containing the following attributes:
```xml
<saml:Attribute
    Name="https://safire.ac.za/namespace/claims/unscopedAffiliationSingleton/01"
    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
>
    <saml:AttributeValue>member</saml:AttributeValue>
</saml:Attribute>
<saml:Attribute
    Name="https://safire.ac.za/namespace/claims/unscopedAffiliationSingleton/02"
    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
>
    <saml:AttributeValue>staff</saml:AttributeValue>
</saml:Attribute>
```
will be re-mapped to:
```xml
<saml:Attribute
    Name="urn:oid:1.3.6.1.4.1.5923.1.1.1.1"
    NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
>
    <saml:AttributeValue>member</saml:AttributeValue>
    <saml:AttributeValue>staff</saml:AttributeValue>
</saml:Attribute>
```

[^suffix]: "…" represents any suffix matching the pattern *[a-zA-Z0-9]{1,10}* (and explicitly excluding another "/").
