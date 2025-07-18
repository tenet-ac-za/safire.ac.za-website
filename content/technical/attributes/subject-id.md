---
attributeExample: |2
  * d06df5c2-24dd-4506-b44d-fe99719dac5d@example.ac.za
attributeFormat: |2
  Single valued, scoped, case-insensitive. The syntax is per section 3.3 of the SAML V2.0 Subject Identifier Attributes Profile.

  The scope portion must match one of the `<shibmd:Scope>` elements in the [identity provider's metadata](/technical/saml2/idp-requirements/). Note that scopes are **case sensitive**.
attributeNotes: |2
  The _subject-id_ consists of two parts in the form `uniqueID@scope`. The uniqueID is a pseudonymous identifier for the subject at their home organisation, and the scope identifies the home organisation of the subject. The maximum combined length, including the "@" separator, is 255 characters.

  Identity providers generating _subject-id_ are encouraged to send opaque pseudonymous values for the uniqueID portion (specifically, it does not need to match `eduPersonPrincipalName` and probably should not).
attributeOid: urn:oasis:names:tc:SAML:attribute:subject-id
attributeReferences:
  - Name: SAML V2.0 Subject Identifier Attributes Profile Version 1.0
    URL: https://docs.oasis-open.org/security/saml-subject-id-attr/v1.0/cs01/saml-subject-id-attr-v1.0-cs01.html
layout: attributelist
date: 2025-06-30 09:30:00+02:00
slug: subject-id
title: subject-id
url: /technical/attributes/subject-id/
---

The General Purpose Subject Identifier is a long-lived, non-reassignable, omni-directional identifier suitable for use as a globally-unique external person identifier (key). Its value for a given subject is independent of the relying party to whom it is given.

_Note: While this attribute is supported by SAFIRE's infrastructure, it is not yet included in the list of [officially supported attributes]({{< relref "_index.md" >}})._
