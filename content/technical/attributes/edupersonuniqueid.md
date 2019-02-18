---
attributeExample: f6b272da-0f0f-4c9b-bcc6-5e63a464ccd2@example.ac.za
attributeFormat: |2
  Single valued, scoped to home organisation to ensure it is globally unique within the research and education sector. Should **not** be assumed to be a valid email address (see [_mail_](/technical/attributes/mail/)).

  The uniqueID portion MUST be unique within the context of the issuing identity system and MUST contain only alphanumeric characters (a-z, A-Z, 0-9). The length of the uniqueID portion MUST be less than or equal to 64 characters.

  The scope portion must exactly match one of the `<shibmd:Scope>` elements in the [identity provider's metadata](/technical/saml2/idp-requirements/).
attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.13
attributeReferences:
  - Name: eduPerson
    URL: https://www.internet2.edu/products-services/trust-identity/eduperson-eduorg/#service-features
date: 2019-02-18 16:16:16+02:00
layout: attributelist
slug: edupersonuniqueid
title: eduPersonUniqueId
url: /technical/attributes/edupersonuniqueid/
---

A persistent, opaque, non-reassignable, omnidirectional identifier that uniquely identifies the subject.
