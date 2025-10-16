---
date: 2025-08-20 11:55:00+02:00
slug: safire-compatibility-quirks
tags:
  - configuration
  - metadata
  - technical
title: SAFIRE federation hub compatibility quirks
---

To ensure broad compatibility with commonly used SAML identity providers, SAFIRE's federation hub can adjust its behaviour to handle specific quirks in some implementations. This is mainly intended for proprietary SAML software stacks that do not fully support our [deployment profiles]({{< ref "/technical/saml2/deployment-profiles.md" >}}). It is not a substitute for correcting misconfigurations.

Quirks are signalled in identity provider metadata by setting the `x-safire.ac.za:quirks` EntityAttribute as follows:
```xml
<mdattr:EntityAttributes>
  <saml:Attribute FriendlyName="quirks" Name="urn:x-safire.ac.za:quirks" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">
    <saml:AttributeValue>quirk1</saml:AttributeValue>
    <saml:AttributeValue>quirk2</saml:AttributeValue>
  </saml:Attribute>
</mdattr:EntityAttributes>
```
Note that is is only supported for identity providers that are [directly registered in SAFIRE]({{< ref "/participants/idp/_index.md" >}}).

# Quirks for specific software stacks

### `adfs`

The `adfs` quirk indicates that the remote identity provider is [Microsoft Active Directory Federation Services (AD FS)]({{< ref "configuring-adfs-for-safire.md" >}}).

Setting this quirk will cause the hub to:
  * strip all `<samlp:Scoping>` elements from inbound authentication requests, since these are [known to choke AD FS](https://docs.microsoft.com/en-za/azure/active-directory/develop/active-directory-single-sign-on-protocol-reference#scoping).
  * rewrite inbound requests for [REFEDS MFA]({{< ref "/safire/news/20220111-refeds-mfa-support.md" >}}) into Microsoft's native "multiauthn" signalling.
  * remap (some) outbound attribute statements from Microsoft claims into attributes understood by SAFIRE service providers. This feature is very limited, and identity providers are encouraged to send the correct attribute format.

### `azure`

The `azure` quirk indicates that the remote identity provider is a [Microsoft Entra ID enterprise application]({{< ref "configuring-azure-ad-for-safire.md" >}}).

Setting this quirk will cause the hub to:
  * strip portions of the `<samlp:Scoping>` element (specifically the `<samlp:IDPList>` and `ProxyCount`) from inbound authentication requests, since these are not supported by Entra ID and will cause an error.
  * rewrite inbound requests for [REFEDS MFA]({{< ref "/safire/news/20220111-refeds-mfa-support.md" >}}) into Microsoft's native "multiauthn" signalling.
  * remap (some) outbound attribute statements from Microsoft claims into attributes understood by SAFIRE service providers. This feature is very limited, and identity providers are encouraged to send the correct attribute format.
  * process SAFIRE's [custom claim namespace]({{< ref "/namespace/claims.md" >}}) to work around the lack of support for multi-valued attribues in Entra ID (affecting outbound attribute statements).

## Sub-options for AD FS and Entra ID

#### `subjectid`

The `subjectid` quirk causes the hub to generate a [general purpose subject identifier]({{< ref "/technical/attributes/subject-id.md" >}}) from Entra ID's `http://schemas.microsoft.com/identity/claims/objectidentifier` claim.
This quirk is deprecated in favour of generating directly in Entra ID (see [our documentation]({{< ref "configuring-azure-ad-for-safire.md" >}})).

#### `multipleauthn`

The `multipleauthn` quirk tells the hub to process Microsoft's [authnmethodsreferences]({{< ref "/technical/attributes/authnmethodsreferences.md" >}}) claim in an outbound attribute statement, potentially translating it to REFEDS MFA signalling. Setting this allows Entra ID or AD FS to indicate to a remote service that REFEDS-compatible MFA was used during authentication.

While translation of inbound MFA requests happens automatically, signalling the result on the corresponding outbound response must be specifically enabled with this quirk. This only happens [on request]({{< ref "/safire/contact/_index.md" >}}), and only after confirmation that REFEDS-compatible MFA is in use.

#### `nativerefedsmfa`

The `nativerefedsmfa` quirk tells the hub that the remote IdP (usually AD FS) natively supports REFEDS MFA signalling. It disables the rewriting of inbound requests for [REFEDS MFA]({{< ref "/safire/news/20220111-refeds-mfa-support.md" >}}).

# Standalone quirks

### `stripidplist`

The `stripidplist` quirk alters the handling of `<samlp:Scoping>` elements in incoming authentication requests. Rather than completely removing the Scoping element, this quirk causes only the `ProxyCount` attribute and any `<samlp:IDPList>` subelements to be removed. This has the effect of hiding the proxy while still revealing the original service provider in a `<samlp:RequesterID>` subelement.

This behaviour is implied by the `azure` quirk, but is useful for other SAML<->SAML proxies (such as SimpleSAMLphp operating in proxy mode).

### `orcidaa`

The `orcidaa` quirk causes the hub to try and retrieve an [eduPersonOrcid]({{< ref "/technical/attributes/edupersonorcid.md" >}}) attribute from the [Intembeko ORCID Hub](https://intembeko.orcid.ac.za/).
