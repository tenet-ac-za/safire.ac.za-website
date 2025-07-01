---
attributeExample: she/her/hers
attributeFormat: Single-values string.
attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.18
attributeReferences:
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: eduPersonDisplayPronouns
    URL: https://wiki.refeds.org/display/STAN/eduPersonDisplayPronouns
attributeNotes: |2
  This attribute is intended to be human readable rather than
  machine parsable, and represents pronouns as a human would like
  them displayed. No attempt should be made to parse or interpret
  _eduPersonDisplayPronouns_. Multiple personal pronouns should
  include separators to support human readability, e.g. “Ashe”,
  “she/her/hers”, “ella, ellas”, or “She/ella*, 她/她”.

  See the [REFEDS guidence](https://wiki.refeds.org/display/STAN/eduPersonDisplayPronouns)
  for more information.
date: 2024-02-05 14:04:00+02:00
layout: attributelist
slug: eduPersonDisplayPronouns
title: eduPersonDisplayPronouns
url: /technical/attributes/edupersondisplaypronouns/
---

Text representing the word(s) a person prefers as their personal pronoun(s).

_Note: While this attribute is supported by SAFIRE's infrastructure, it is not included in the list of [officially supported attributes]({{< relref "_index.md" >}})._
