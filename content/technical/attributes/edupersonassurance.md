---
attributeExample: |2
  * https://refeds.org/assurance/profile/cappuccino
  * https://refeds.org/assurance/IAP/local-enterprise
attributeFormat: |2
  Multi-valued, set of URIs that assert compliance with specific standards for identity assurance.

  Those establishing values for this attribute should provide documentation (ideally at the identifying URL) explaining the semantics of the values.
attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.11
attributeReferences:
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: REFEDS Assurance
    URL: https://refeds.org/assurance/
layout: attributelist
date: 2019-10-02 09:30:00+02:00
slug: edupersonassurance
title: eduPersonAssurance
url: /technical/attributes/edupersonassurance/
---

Represents identity assurance profiles (IAPs), which are the set of standards that are met by an identity assertion, based on the Identity Provider's identity management processes, the type of authentication credential used, the strength of its binding, etc. An example of such profiles is given in the [REFEDS Assurance Framework](https://refeds.org/assurance/).

_Note: While this attribute is supported by SAFIRE's infrastructure, it is not included in the list of [officially supported attributes]({{< relref "_index.md" >}}). Participants wishing to make use of it are invited to [discuss their use-cases with us](https://lists.tenet.ac.za/sympa/info/safire-discuss)._
