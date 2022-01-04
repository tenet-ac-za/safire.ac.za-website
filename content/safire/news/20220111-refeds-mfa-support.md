---
date: 2022-01-04 16:00:00+02:00
slug: 20220111-refeds-mfa-support
tags:
  - technical
title: Support for REFEDS MFA
---


On the evening of Tuesday 11 January, we will deploy a number of changes
to the SAFIRE Federation hub to allow for the bi-directional signalling
of [REFEDS MFA](https://refeds.org/profile/mfa). No downtime is expected,
and we do not anticipate any impact on any service- or identity-provider
that does not currently support such signalling. <!--more-->

Once complete, the changes summarised below should allow our Federation
to fully support the requirements of REFEDS MFA. A growing number of
research collaborations require the use of multi-factor authentication
for their users, and these changes ensure that those identity providers
that themselves support MFA are able to signal this when needed. Given
the predominance of Microsoft-based solutions (AD FS & Azure AD) in our
Federation, we've made a specific effort to ensure that these can be
used with minimal changes.

Participants looking for more information on signalling MFA are encouraged
to look at the [REFEDS MFA supporting material](https://wiki.refeds.org/display/PRO/MFA).

# Incoming MFA requests (service &rarr; identity provider)

Incoming requests containing a `<samlp:RequestedAuthnContext>` element
will be proxied to the identity provider. This change will allow service
providers to signal that they require multi-factor authentication. For
the most part, the RequestedAuthnContext will be proxied as requested.

However, in the specific case of identity providers that we
have tagged[^quirks] as Microsoft's
[AD FS]({{< ref "/technical/resources/configuring-adfs-for-safire.md" >}})
or [Azure AD]({{< ref "/technical/resources/configuring-azure-ad-for-safire.md" >}}),
incoming RequestedAuthnContext requests for the REFEDS MFA profile
(`https://refeds.org/profile/mfa`) will be rewritten into Microsoft's
`http://schemas.microsoft.com/claims/multipleauthn` claim. This
quirk allows service providers to trigger native support for MFA
in these identity providers without requiring specific changes on
the identity provider side. It can be disabled
[on request]({{< ref "/participants/support/_index.md" >}}) on a
per-IdP basis (for instance, in the case of AD FS using the
[ADFSToolkit](http://adfstoolkit.org/) and having native REFEDS MFA
support).

# Outgoing MFA assertions (identity &rarr; service provider)

As a result of [changes made in December](https://lists.tenet.ac.za/sympa/arc/safire-announce/2021-12/msg00000.html),
outbound responses will have any `<samlp:AuthnContextClassRef>` element
proxied to the service provider. Identity providers with native support
for REFEDS MFA can already use this to signal users' multi-factor
authentications to service providers.

With this change, we will additionally be able to translate outbound
assertions with a [`http://schemas.microsoft.com/claims/authnmethodsreferences` attribute]({{< ref "/technical/attributes/authnmethodsreferences.md" >}})
claim referencing `http://schemas.microsoft.com/claims/multipleauthn`
into the corresponding REFEDS MFA (`https://refeds.org/profile/mfa`)
`<samlp:AuthnContextClassRef>` assertion. However, because not
all multi-factor authentication methods supported by Microsoft are
compatible with REFEDS MFA, this quirk is **not enabled by default**. It
can be enabled on a per-IdP basis on request and after the IdP has
[confirmed]({{< ref "/participants/support/_index.md" >}}) their
implementation of MFA meets the requirements of the REFEDS MFA profile.

# Concomitant changes

The work required to support REFEDS MFA has allowed us to resolve several
other problems, which will be propagated at the same time. Notably,
these include:

 * Translation of the SAFIRE-specific
   [`https://safire.ac.za/namespace/claims` namespace]({{< ref "/namespace/claims.md" >}}) that was introduced to
   work around the [lack of support for multi-valued claims]({{< ref "/technical/resources/configuring-azure-ad-for-safire.md#3-configure-attribute-claims-rules" >}})
   in Azure AD will now only be enabled when an identity provider is
   tagged[^quirks] as Azure AD. (These claims will be ignored for all other
   identity providers.)

 * We will resume proxying the `<samlp:Scoping>` element
   to all identity providers except those tagged[^quirks] as AD FS or Azure AD.
   This quirk was [introduced in May 2017](https://github.com/simplesamlphp/simplesamlphp/issues/498) to work
   around [a bug in AD FS](https://docs.microsoft.com/en-za/azure/active-directory/develop/active-directory-single-sign-on-protocol-reference#scoping)
   that resulted in a hard error for those identity providers, and has
   applied globally since then. As
   [noted at the time](https://lists.tenet.ac.za/sympa/arc/safire-discuss/2017-05/msg00000.html),
   stripping the Scoping element violates the SAML2 specification. We're
   now able to target this quirk much more specifically and so will no
   longer withhold it globally.

 * SAML responses that do not contain a corresponding assertion will be
   proxied correctly. This will allows identity provider software such as
   Oracle Access Manager to signal that MFA is not configured for a user.

[^quirks]: You can confirm we've correctly classified your identity provider by [looking for its metadata](https://phph.safire.ac.za/?filter=fed%3A%5Esafire-fed-registry%24%20IDP%3A%5E%24) in our aggregator and verifying the values of the `urn:x-safire.ac.za:quirks` attribute. AD FS should include an AttributeValue of "adfs" and Azure AD should include an AttributeValue of "azure" (case is important).
