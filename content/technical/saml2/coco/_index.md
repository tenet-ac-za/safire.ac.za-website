---
date: 2025-07-10 13:00:00+02:00
menu:
  main:
    identifier: technical-saml2-coco
    parent: technical-saml2
slug: coco
linkTitle: Code of Conduct (CoCo)
title: REFEDS Data Protection Code of Conduct (CoCo) for SAFIRE service providers
url: /technical/saml2/coco/
---

The [REFEDS Data Protection Code of Conduct](https://refeds.org/category/code-of-conduct/v2) (CoCo) provides an approach for service providers who need to meet the European Union's General Data Protection Regulation. It may be required by SAFIRE service providers that provide services to European entities.

### Attesting CoCo compliance

If you need to attest to your service provider's CoCo compliance, in addition to a [registration request]({{< ref "/technical/saml2/forms/_index.md" >}}) you also need to supply a statement of your CoCo compliance. You should be aware that, unlike [Sirtfi]({{< relref "../sirtfi/_index.md" >}}), CoCo introduces **binding obligations** on the organisation attesting compliance and operating the service provider.

You can use the following template or a suitable-worded alternative:

  * [SAFIRE CoCo Compliance Template](./SAFIRE-CoCo-Compliance-Template.rtf)

This statement must be on institional letterhead, and should be signed by your institution's Information Officer or a suitably appointed Deputy Information Officer (as defined in the Protection of Personal Information Act, 2013).

A suitably redacted copy of this statement will be published as part of your entity's listing (see below for examples).

#### Metadata updates

SAFIRE's [technical requirements]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) already incorporate the CoCo requirements. However, you are encouraged to review the `<mdui:DisplayName>` and `<mdui:Description>` values you provide with a view to ensuring they're clearly understandable to end users in this context.

#### Privacy Statement updates

To attest to CoCo compliance, you may need to update your service's Privacy Statement. In particular, your Privacy Statement MUST:

 * include the name, address and jurisdiction of the Service Provider. Ideally contact details for your Information Officer should be provided.
 * indicate a commitment to the Code of Conduct. The Privacy Statement should therefore include text about the Code and should link to the Code URL.

#### Attribute updates

You must review the attributes your Service Provider requires, and update your metadata to include `<md:RequestedAttribute>` elements to indicate all the attributes that the Service Provider will request. The `isRequired` flag MUST be used to indicate which attributes are required for the service to function and which are optional.

You should request any changes to your attributes prior to attesting to compliance.

#### Security contact

While not mandatory under CoCo, SAFIRE additionally requires you publish a [Sirtfi-style security contact]({{< relref "../sirtfi/_index.md" >}}) in metadata before we will assert compliance.

#### Annual review

We undertake an annual review of CoCo-compliant entities, to ensure that the Privacy Statement still exists and that the Information Officer is still reachable. Entities that fail this review may have their assertion of compliance removed.

### CoCo-compliant entities

The following entities in SAFIRE have already attested their CoCo compliance and have this asserted in metadata:

{{< participantlist type="coco" >}}

