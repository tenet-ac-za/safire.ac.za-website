---
date: 2020-03-10 11:43:00+02:00
menu:
  main:
    identifier: technical-saml2-coco
    parent: technical-saml2
slug: coco
linkTitle: Code of Conduct (CoCo)
title: GÉANT Code of Conduct (CoCo) for SAFIRE service providers
url: /technical/saml2/coco/
---

The [GÉANT Code of Conduct for Service Providers](https://wiki.refeds.org/display/CODE/Code+of+Conduct+for+Service+Providers) (CoCo) provides an approach for service providers who need to meet the European Union's data protection directive and/or the general data protection regulations. It may be required by SAFIRE service providers that provide services to European entities.

### Attesting CoCo compliance

If you need to attest to your service provider's CoCo compliance, in addition to a [registration request]({{< ref "/technical/saml2/forms.md" >}}) you also need to supply a statement of your CoCo compliance. You should be aware that, unlike [Sirtfi]({{< relref "../sirtfi/_index.md" >}}), CoCo introduces binding obligations on the organisation attesting compliance and operating the service provider.

You can use the following template:

  * [SAFIRE CoCo Compliance Template](./SAFIRE-CoCo-Compliance-Template.docx)

This statement must be on institional letterhead, and should be signed by your institution's Information Officer (as defined in the Protection of Personal Information Act) or other executive officer.

A suitably redacted copy of this statement will be published as part of your entity's listing (see below for examples).

#### Privacy Statement updates

In order to attest to CoCo compliance, you may need to update your service's Privacy Statement. In particular, your Privacy Statement MUST:

 * include the name, address and jurisdiction of the Service Provider. Ideally contact details for your Information Officer should be provided.
 * indicate a commitment to the Code of Conduct. The Privacy Statement should therefore include text about the Code and should link to the Code URL.

#### Attribute updates

You must review the attributes your Service Provider requires, and update your metadata to include `md:RequestedAttribute` elements to indicate all the attributes that the Service Provider will request. The `isRequired` flag MUST be used to indicate which attributes are required for the service to function and which are optional.

You should request any changes to your attributes prior to attesting to compliance.

#### Annual review

We undertake an annual review of CoCo-compliant entities, to ensure that the Privacy Statement still exists and that the Information Officer is still reachable. Entities that fail this review may have their assertion of compliance removed.

### CoCo-compliant entities

The following entities in SAFIRE have already attested their CoCo compliance and have this asserted in metadata:

{{< participantlist type="coco" >}}

