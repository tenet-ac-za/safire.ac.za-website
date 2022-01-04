---
attributeExample: |2
  * urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport
  * http://schemas.microsoft.com/ws/2012/12/authmethod/otp
  * http://schemas.microsoft.com/claims/multipleauthn

attributeFormat: Multi-valued, containing URI references
attributeOid: http://schemas.microsoft.com/claims/authnmethodsreferences
attributeNotes: |2
  The _http://schemas.microsoft.com/claims/authnmethodsreferences_ claim is
  only supported in the specific case of
  [Microsoft AD FS](/technical/resources/configuring-adfs-for-safire)
  and [Azure AD](/technical/resources/configuring-azure-ad-for-safire)
  identity providers; in all other circumstances it is filtered out.

  It is possible for the Federation hub to translate a _authnmethodsreferences_
  claims asserting Microsoft's multi-factor authentication method
  (`http://schemas.microsoft.com/claims/multipleauthn`) into a corresponding
  `<samlp:AuthnContextClassRef>` element asserting the [REFEDS MFA](https://refeds.org/profile/mfa)
  profile of `https://refeds.org/profile/mfa`. However, because not all
  multi-factor authentication methods supported by Microsoft are compatible
  with REFEDS MFA, this quirk is **not enabled by default**.

  Identity providers that wish to make use of REFEDS MFA and require this quirk
  must explicitly request it, and confirm that the multi-factor authentication
  methods they use are compatible with REFEDS MFA.

attributeReferences:
  - Name: AD FS Operations Guide
    URL: https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/operations/create-a-rule-to-send-an-authentication-method-claim
  - Name: REFEDS MFA Profile
    URL: https://refeds.org/profile/mfa
date: 2022-01-04 14:35:00+02:00
layout: attributelist
slug: authnmethodsreferences
title: http://schemas.microsoft.com/claims/authnmethodsreferences
url: /technical/attributes/authnmethodsreferences/
---

Claim containing URI references to the authentication methods utilised by the subject

_Note: This attribute is **never released** to service providers, and
direct use of it is not possible._
