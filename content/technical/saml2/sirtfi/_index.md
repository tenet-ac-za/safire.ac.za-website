---
date: 2021-03-31 08:00:00+02:00
menu:
  main:
    identifier: technical-saml2-sirtfi
    parent: technical-saml2
slug: sirtfi
linkTitle: Sirtfi
title: Sirtfi for SAFIRE providers
url: /technical/saml2/sirtfi/
---

The [Security Incident Response Trust Framework for Federated Identity](https://refeds.org/sirtfi) (Sirtfi) aims to enable the coordination of incident response across federated organisations. The framework provides a structured way for providers to indicate that they follow current information security best practices, thus raising their level of assurance and improving trust within the federated community.

It is **strongly recommended** that SAFIRE participants work towards Sirtfi compliance, and inclusion of a security contact is [required for identity providers]({{< ref "../idp-requirements/_index.md" >}}). In particular, identity providers need to be aware that a growing number of widely-used service providers --- such a CILogin --- require that identity providers are Sirtfi compliant before they will grant their users access to services.

### Attesting Sirtfi compliance

If you need to attest to your institution's Sirtfi compliance, in addition to a [registration request]({{< ref "/technical/saml2/forms.md" >}}) you also need to supply a statement of your Sirtfi compliance. You can use the following template:

  * [SAFIRE Sirtfi Compliance Template](./SAFIRE-Sirtfi-Compliance-Template.rtf)

This statement must be on institional letterhead, and should be signed by the person responsible for conducting the assessment (which may or may not be your technical contact). In large organisations it is typically signed by the head of an institutional CSIRT or equivelent information security function.

A suitably redacted copy of this statement will be published as part of your entity's listing (see below for examples).

#### Annual review

We undertake an annual review of Sirtfi-compliant entities, to ensure that the security contact details in metadata are still accurate, and to reaffirm the entity's Sirtfi compliance. Entities that fail this review may have their assertion of compliance removed.

### Sirtfi-compliant entities

The following entities in SAFIRE have already attested their Sirtfi compliance and have this asserted in metadata:

{{< participantlist type="sirtfi" >}}

