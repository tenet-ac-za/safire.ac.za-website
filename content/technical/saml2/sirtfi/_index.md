---
date: 2025-07-10 13:00:00+02:00
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

It is **strongly recommended** that all SAFIRE participants work towards Sirtfi compliance, and this has been [required for new identity providers]({{< ref "../idp-requirements/_index.md" >}}) since [September 2025]({{< ref "/safire/news/20250901-baseline-changes.md" >}}).

### Attesting Sirtfi compliance

If you need to attest to your institution's Sirtfi compliance, in addition to a [registration request]({{< ref "/technical/saml2/forms/_index.md" >}}) you also need to supply a statement of your Sirtfi compliance. You can use the following template:

  * [SAFIRE Sirtfi Compliance Template](./SAFIRE-Sirtfi-Compliance-Template.rtf)

This statement must be on institional letterhead, and should be signed by the person responsible for conducting the assessment (which may or may not be your technical contact). In large organisations it is typically signed by the head of an institutional CSIRT or equivelent information security function.

A suitably redacted copy of this statement will be published as part of your entity's listing (see below for examples).

#### Sirtfi v1.0 vs v2.0

There are currently two versions of the Sirtfi framework. Both coexist and remain valid.

However, since **1 September 2025**, SAFIRE no longer accepts new attestations for v1 alone. All new entities must adopt v2 of the framework. Existing v1 attestations remain valid, provided the entity remains compliant and completes the required annual review.

More information is available on the [REFEDS Sirtfi page](https://refeds.org/sirtfi).

#### Annual review

We undertake an annual review of entities that have published security contacts to ensure that the security contact details in metadata are still accurate. In the case of Sirtfi-complient entities this review is used as a basis to reaffirm the entity's Sirtfi compliance and entities that fail this review may have their assertion of compliance removed and may need to reattest compliance.

### Sirtfi-compliant entities

The following entities in SAFIRE have already attested their Sirtfi compliance and have this asserted in metadata:

{{< participantlist type="sirtfi" >}}

