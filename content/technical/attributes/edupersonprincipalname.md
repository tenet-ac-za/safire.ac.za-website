--- 
attributeExample: vuyo.jorgensen@example.ac.za
attributeFormat: |2
  Single valued, scoped to home organisation to ensure it is globally unique within the research and education sector. eduPerson allows reassignment, but SAFIRE IdPs may not do this. Should **not** be assumed to be a valid email address (see [_mail_](/technical/attributes/mail/)).
  
  The scope portion must exactly match one of the `<shibmd:Scope>` elements in the [identity provider's metadata](/technical/saml2/idp-requirements/).
attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.6
attributeReferences: 
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: IdP Requirements
    URL: /technical/saml2/idp-requirements/
date: 2016-09-12 12:32:49+00:00
layout: attributelist
slug: edupersonprincipalname
title: eduPersonPrincipalName
url: /technical/attributes/edupersonprincipalname/
---

A non-opaque username that uniquely identifies the subject.
