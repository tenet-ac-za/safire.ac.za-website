---
date: 2021-06-04 08:00:00+02:00
slug: claims
title: https://safire.ac.za/namespace/claims
url: /namespace/claims
draft: true
---

The **https\://safire.ac.za/namespace/claims** namespace is used to define some claims provider identifiers for use with Active Directory Federation Services (AD FS) and Azure Active Directory (Azure AD). Whilst well defined, these are non-standard claims that are likely not interoperable outside of SAFIRE.

A normative schema for the namespace is available at https://safire.ac.za/namespace/claims.xsd.

# https\://safire.ac.za/namespace/claims namespace registry

| Prefix | Use/Description |
:--------|:----------------|
| **https\://safire.ac.za/namespace/claims**… | Used for claims provider identifiers in AD FS or Azure AD |
| https\://safire.ac.za/namespace/claims/unscopedAffiliationSingleton | Space delimited singleton representation of [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}), utilising the same limited vocabulary (defined here as `safire:AffiliationVocabularyType`). |
| https\://safire.ac.za/namespace/claims/scopedAffiliationSingleton | Space delimited singleton representation of [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}), utilising the same limited vocabulary. |

