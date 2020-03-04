---
date: 2020-03-04 08:07:00+02:00
menu:
  main:
    identifier: technical-saml2-deployment-profiles
    name: Deployment Profiles
    parent: technical-saml2
    weight: 3
slug: deployment-profiles
title: SAML2 Deployment Profiles
url: /technical/saml2/deployment-profiles/
---

SAFIRE has never formally adopted a deployment profile. However, the _de facto_ WebSSO profile is based upon the "SAML2int" profile that is widely adopted by federations around the world.

SAFIRE wishes to be as interoperable as possible, given the contextual constraints we operate in. Thus most of the federation's technical requirements and recommendations are derived from one of two sources:

* [SAML V2.0 Deployment Profile for Federation Interoperability](https://kantarainitiative.github.io/SAMLprofiles/saml2int.html) [^SAML2int]
* [eduGAIN SAML profile](https://technical.edugain.org/doc/eduGAIN-saml-profile.pdf)

All new providers are expected to operate largely in compliance with these profiles, which in turn ensures maximum interoperability with other federations. Existing providers are always strongly encouraged to update their deployments where possible to track changes in the profiles. However, a minimum baseline of SAML2int v0.2 is expected.

[^SAML2int]: Work on the SAML2int profile was originally housed at [saml2int.org](https://saml2int.org/) but custoianship has passed to the [Kantara Initiative](https://kantarainitiative.org/).
