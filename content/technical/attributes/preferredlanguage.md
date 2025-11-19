---
attributeExample: xh
attributeFormat: |2
  Single valued language tag, as per BCP 47 and based on ISO 639.
attributeNotes: |2
  In addtion to being an attribute that can be requested by service providers, if
  the _preferredLanguage_ attribute contains one of the
  [supported languages]({{< ref "/safire/news/20191216-sesotho.md" >}}), it
  will be used to adjust the language of SAFIRE's transfer notice, some
  error messages, and other end-user facing components during login.
attributeOid: urn:oid:2.16.840.1.113730.3.1.39
attributeReferences:
  - Name: BCP 47
    URL: https://www.rfc-editor.org/info/bcp47
  - Name: Language Tags Registry
    URL: https://www.iana.org/assignments/language-subtags-tags-extensions/
  - Name: RFC 2798
    URL: https://tools.ietf.org/html/rfc2798
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
date: 2016-09-12 13:00:12+00:00
layout: attributelist
slug: preferredlanguage
title: preferredLanguage
url: /technical/attributes/preferredlanguage/
---

Subject's preferred or first language.
