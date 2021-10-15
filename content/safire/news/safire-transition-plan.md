---
date: 2016-11-02 14:54:00+00:00
slug: safire-transition-plan
tags:
  - metadata
  - policy
  - website
title: SAFIRE Transition Plan
url: /safire/news/safire-transition-plan/
---

SAFIRE is in the process of transitioning, both in architecture (from full-mesh to hub-and-spoke) and governance (from the SCA to TENET). The purpose of this post is to provide more detail on the transitional arrangements.<!--more-->

## 1. Change freeze

There is a change freeze in force for the existing full-mesh federation. No new metadata will be added to the existing SAFIRE metadata aggregate and only emergency changes will be made. Should such changes be required, please communicate these to both TENET and the SCA.

## 2. Parallel operations

Both the existing full-mesh and the new hub-and-spoke federations will operate in parallel for a number of months, until such time as all existing, functional identity- and service providers have migrated. It is possible (perhaps likely) that there are some stale providers in the existing metadata, so some discretion will be used in determining the exact date at which parallel operations cease.

This date has been determined to be 30 June 2017: Shortly after midnight on 1 July 2017, all remaining identity providers in the full-mesh federation will expire. (Some IdPs who are part-way through the transition may expire sooner than this - individual IdPs have been contacted with details.)

Between 1 July and 31 July, service providers who have not completed the transition may still be able to access SAFIRE IdPs via a click-through warning. However this is not supported, and the functionality will be removed on 31 July.

After 31 July, the old full-mesh federation is no longer expected to work and may be dismantled at any point.

## 3. Order of transition

The intent is to migrate existing identity providers first, then to migrate existing service providers. However, in some instances organisations act as both identity- and service- providers, and so it may make sense to relax this slightly.

Caveat: whilst transitional arrangements exist to ensure IdPs that have transitioned remain available in the full-mesh federations, no such arrangements exist for SPs. Thus once an SP is migrated, it will become inaccessible to IdPs who have not yet completed the transition.

~~New services and identity providers may only join the hub-and-spoke federation, and will only have their metadata added after the transition from full-mesh has been completed.~~  New providers are being taken on concomitantly.

## 4. Individual transitions

At the appropriate time, the Project Director will contact individual entities to begin the process of transition. This may be broken up into a number of phases to deal with the logistical.

### 4.1 Participation agreement

As a first step, transitioning entities will need to complete and sign the SAFIRE [Participation Agreement]({{< ref "/safire/policy/participation/_index.md" >}}). This document outlines the various roles and responsibilities of the parties involved, and forms the basis of the trust relationship.

We anticipate that many organisations will need to put this document through their internal processes, and this may take time. In addition, these processes may slow or stall over the December/January period. For this reason, we invite all existing participants to begin this step immediately.

Please sign and scan (or electronically sign) a copy of the Participation Agreement and [email it to us]({{< ref "/safire/contact/_index.md" >}}). TENET is happy to [accept scanned documents and/or electronic signatures](https://www.michalsons.com/blog/spring-forest-trading-v-wilberry/14861), and will normally return an electronically signed copy to you.

Should your processes require original handwritten signatures, please post or courier two copies of the signed agreement to [TENET's offices]({{< ref "/safire/contact/_index.md" >}}) (one will ultimately be returned to you by post countersigned by TENET). In addition, to counteract postal delays, please send a scanned copy as above.

Queries about the agreement can be directed to the same place.

### 4.2 Metadata registry take-on

Existing metadata from the full-mesh federation will **not** be migrated to the hub-and-spoke federation. Instead, entities will be asked to supply new metadata for inclusion in the Federation registry. The reason for this is that the majority of metadata in the existing federation does not comply with the [MRPS]({{< ref "/safire/policy/mrps/_index.md" >}}) and other requirements.

Note that the technical transition does not need to be complete in order to add metadata into the new Federation Registry. In fact it might be desirable to do this sooner rather than later, since it will aid testing of the new technology.

To aid with preparing metadata, a SAML2 metadata validator  is available at [https://validator.safire.ac.za/](https://validator.safire.ac.za/). Whilst still in development, this applies very similar rules to SAFIRE's metadata aggregator and tries to check the technical requirements.

#### Identity Providers

The [new requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) for identity providers are documented. Identity providers will need to complete the [SAML2 IdP Registration Request form.]({{< ref "/technical/saml2/forms/_index.md" >}}) The completed form can be emailed together with the proposed metadata to {{< email "safire@tenet.ac.za" >}}.

#### Service Providers

The [new requirements]({{< ref "/technical/saml2/sp-requirements/_index.md" >}}) for service providers are documented. In particular, these three were not previously enforced and may require some thought/effort:

      * A list of attributes required/requested, in accordance with the [attribute release policy]({{< ref "/safire/policy/arp/_index.md" >}}). (See [supported attributes]({{< ref "/technical/attributes/_index.md" >}})).
      * A short (~ 160 character) description of you purpose that explains what service you provide. A well-worded description of purpose makes it obvious why you need the attributes you are requesting.
      * A link to your privacy policy, that explains how you handle personal information. It's okay for now if this is a draft or a placeholder - provided the URL is valid.

Metadata that does not contain the mandatory elements will **not** be added to the registry. We will work with you to ensure you have valid metadata.

Service providers will need to complete the [SAML2 SP Registration Request form.]({{< ref "/technical/saml2/forms/_index.md" >}}) The completed form can be emailed together with a copy of the proposed metadata to {{< email "safire@tenet.ac.za" >}}.

### 4.3 Provider configuration

Once the hub-and-spoke federation is technically operational, entities will need to reconfigure their providers to consume the new [Federation's metadata]({{< ref "/technical/metadata.md" >}}). It is recommended that you use a dynamic/automated metadata provider ([Shibboleth](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPMetadataProvider#NativeSPMetadataProvider-DynamicMetadataProvider), [SimpleSAMLphp](https://simplesamlphp.org/docs/stable/simplesamlphp-automated_metadata)) to do this and you refresh the metadata approximately every four hours.

#### Identity providers

IdPs may also need to review the [required and supported attributes ]({{< ref "/technical/attributes/_index.md" >}})to ensure that they will release the right information.

#### Service providers

SPs may need to review their access control policies, particularly if they are based on [attributes sent]({{< ref "/safire/policy/arp/_index.md" >}}).

### 4.4 Testing

Once the above steps are complete, the entity should test that things are working correctly. Identity providers can use the [Test Service Provider](https://testsp.safire.ac.za/) for this purpose.

### 4.5 Removal from full-mesh

Once the entity confirms that everything is working and that they have no remaining dependencies in the full-mesh federation, they can remove the full mesh configuration from their provider.

## 5. Logo & Branding

SAFIRE's logo has been [updated]({{< ref "/safire/news/logo-branding-update-20161017.md" >}}), and existing providers will need to replace any instances of the old logo they have. Please see the [brand guide]({{< ref "/technical/logos.md" >}}) for details.

## 6. Costs

To-date the costs of SAFIRE have been largely borne by the SCA and TENET. This is an interim arrangement, and it is expected that going forward costs will be recovered from identity provider (but **not** service providers). Please review section 3. of the [Participation Agreement]({{< ref "/safire/policy/participation/_index.md" >}}) for details.

## 7. New providers

~~We'll only take on new identity- and service providers once this transition is complete.~~
Information for new [service]({{< ref "/participants/sp/join.md" >}})- and [identity ]({{< ref "/participants/idp/join.md" >}})providers is available.

# Questions and updates

Its likely that, in preparing this document, we've overlooked or not clearly stated something. Thus if you have specific questions about how things will work, please [feel free to ask]({{< ref "/safire/contact/_index.md" >}}). We'll keep this document updated as this happens, so please check back here too.

_Last updated: 2017-06-29_
