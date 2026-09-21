---
attributeExample: |2
    * member@example.ac.za
    * employee@example.ac.za
    * student@edu.faculty.example.ac.za
    * faculty@science.faculty.example.ac.za
attributeFormat: |2
  Multi-valued, scoped, controlled vocabulary in the form _affiliation_@_scope_.

  The _affiliation_ on the left-hand side of the literal `@` is described by nouns from a controlled vocabulary. See [_eduPersonAffiliation_](/technical/attributes/edupersonaffiliation/) for the available nouns.

  The _scope_ portion on the right-hand side of the `@` scopes how the affiliation noun should be interpreted. It must match one of the `<shibmd:Scope>` elements in the [identity provider's metadata](/technical/saml2/idp-requirements/). Multiple `<shibmd:Scope>` elements may be required if sub-institutional scopes are used. Note that scopes are **case sensitive**.

  _eduPersonScopedAffiliation_ allows more granular affiliation information than can be provided with [_eduPersonAffiliation_](/technical/attributes/edupersonaffiliation/), and is preferred for this reason. _eduPersonAffiliation_ describes the principal's relationship to an entire institution; _eduPersonScopedAffiliation_ can describe a relationship to the institution, and also to a particular faculty, school, or division.

attributeNotes: |2
  The semantics of various affiliation nouns are described in detail in the [_eduPersonAffiliation_](/technical/attributes/edupersonaffiliation/#attribute-notes) notes.

  _eduPersonScopedAffiliation_ is [fairly widely shared](/safire/policy/arp/) and not generally considered [personally identifying information](https://www.justice.gov.za/inforeg/). For this reason care must be taken to ensure that the affiliation information asserted via this attribute is not too granular: faculty level information is appropriate but departmental level has the potential to inadvertently leak personal information.

  When using sub-instititional scopes (e.g. faculty), care must be taken to also include appropriate institutional scopes as well. For example, a `member` of a specific faculty is typically also a `member` of the institution itself. However, a `member` of a research unit might only be an `affiliate` of the institution that houses it. Leaving out institutional scopes entirely suggests no relationship with the parent institution.

  SAFIRE discontinued the automatic generation of _eduPersonScopedAffiliation_ from _eduPersonAffiliation_ from 1 November 2021.

attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.9
attributeReferences:
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: ePSA usage comparison
    URL: https://www.terena.org/activities/refeds/docs/ePSAcomparison_0_13.pdf
  - Name: IdP Requirements
    URL: /technical/saml2/idp-requirements/
  - Name: HEMIS Data Elements
    URL: http://www.heda.co.za/Valpac_Help/DED_031_040.htm#E039
date: 2021-11-01 16:00:00+02:00
layout: attributelist
slug: edupersonscopedaffiliation
title: eduPersonScopedAffiliation
url: /technical/attributes/edupersonscopedaffiliation/
---

Subject's role at their home organisation --- see also _[eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}})_.
