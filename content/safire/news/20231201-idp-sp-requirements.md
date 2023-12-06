---
date: 2023-12-01T14:30:00+02:00
slug: 20231201-idp-sp-requirements
tags:
  - idp-requirements
  - sp-requirements
  - policy
title: Technical requirements for SAML2 IdPs and SPs updated
---

The SAML2 [IdP]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) and [SP]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) requirements have been updated to clarify certificate expectations.<!--more-->

In order to deal with some ambiguity in the interpretation of our certificate expectations, and to deal with some [likely changes on the horizon](https://www.chromium.org/Home/chromium-security/root-ca-policy/moving-forward-together/), we have tightened the wording to remove any possibility of misinterpretation.

Prior to 30 November, the wording was:

```
* SAML certificates included in metadata SHOULD be self-signed. RSA public keys MUST be at least 2048 bits in length, and EC public keys MUST be at least 256 bits in length. It is RECOMMENDED that new RSA deployments use key lengths of at least 3072 bits.
```

This has been revised in version v20231130 of both the [IdP]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) and [SP]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) requirements to read:

```
* Certificates included in `<ds:X509Certificate>` elements and used for assertion signing or encryption:
  * SHOULD be self-signed.
  * MUST use public keys that contain least 2048 bits (RSA) or 256 bits (EC). It is RECOMMENDED that new RSA deployments use key lengths of at least 3072 bits.
  * MUST have a Validity Period of more than 1 year. Certificates SHOULD be replaced before they expire.
  * MUST NOT reuse private key material for public-facing web servers or other non-SAML purporses.
```

where Validity Period is a reference to the definition in RFC5280. In addition, the propose Requirements for SAML2 Identity Providers includes a recommendation about attribute encryption that reflects what has long been our suggested practice:

```
* It is RECOMMENDED that attribute assertions are NOT encrypted. Such encryption is unnecessary given the requirement for an encrypted transport (https endpoints) and makes debugging difficult.
```

This change in wording has absolutely no impact on the currently-published SAML signing certificates of any existing identity- or service-provider. However, it does allow us to more readily refuse non-compliant ones in future.

At the same time, we made some minor cosmetic changes, such as replacing references to RFC 2119 with BCP 14 to reflect the update by RFC 8174.

