--- 
attributeExample: ben@example.ac.za
attributeFormat: Multi-valued. Well formed email address.
attributeOid: urn:oid:0.9.2342.19200300.100.1.3
attributeReferences: 
  - Name: RFC2798
    URL: https://tools.ietf.org/html/rfc2798
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: RFC5322
    URL: https://tools.ietf.org/html/rfc5322#section-3.4
attributeNotes: |2
  Using _mail_ as a person identifer can have **serious information security implications**. The _mail_ attribute:-
   * is multi-valued (a user may have more than one email address);
   * not guarenteed to be unique (multiple users can share the same email address);
   * not persistant (a person's email address may change without warning);
   * may be reassigned (a new person may get the same email address as someone who has left);
   * is not validated against the `<shibmd:Scope>` elements, and may have a right-hand side that is not in-baliwick (i.e. it may contain a user's personal _example@gmail.com_ address rather than an institutional address).
date: 2021-05-03 16:00:00+02:00
layout: attributelist
slug: mail
title: mail
url: /technical/attributes/mail/
---

Subject's email address.

_Note that use of the *mail* attribute as a person identifier is **strongly discouraged**. Service providers looking for a person identifer should consider [eduPersonTargetedId]({{< relref "edupersontargetedid.md" >}}) or [eduPersonPrincipalName]({{< relref "edupersonprincipalname.md" >}})._
