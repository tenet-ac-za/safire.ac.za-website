---
date: 2023-07-13 16:31:00+02:00
slug: library-services
tags:
  - collaboration
  - library
  - publishers
  - technical
title: Integrating library information providers via SAFIRE
url: /technical/resources/library-services/
aliases:
 - /technical/resources/integrating-library-resource-providers-via-safire/
---

There is considerable interest in leveraging SAFIRE and eduGAIN to integrate with the various library information providers, such as academic content, journal, and database publishers. Information providers variously term this "Shibboleth", "SAML" or "Institutional" logins, and in most cases are already integrated with other federations around the world.

The following documents the integration status of various providers in SAFIRE.

{{< libraryproviders >}}

If there's something missing from the above, the information is out of date (or you know something we don't), or you'd simply like to help us unlock one of the other information providers, please [contact us]({{< ref "/safire/contact/_index.md" >}})! Our experience is it takes one or two interested libraries to help make the first connection, and then the entire community benefits from improved access.

Systems librarians interested in such integrations might also want to consider [subscribing to the safire-libs@lists](https://lists.tenet.ac.za/sympa/lists/ti/safire) mailing list.

# Values needed by information providers

### Metadata
Publishers and information providers may ask you for a copy of your institution's SAML/XML metadata, or for a URL where this can be downloaded from. Metadata is needed for a one-to-one (bi-lateral) setup and the provider may assume that this is what you're trying to do. However, it should not needed for federated login --- if they participate in federation, the provider should _already_ have your metadata which they've learnt via eduGAIN and from another federation.

Reinforce that you're trying to set up a _federated_ SAML authentication and ask them to check and see if they've learnt metadata for your entity ID (see below) from eduGAIN. You might be able to see the provider listed on [met.refeds.org](https://met.refeds.org/met/federation/edugain/) which would confirm this is the case. (It might also be useful to know that majority of the publishers and information providers listed here are registered via the UK Access Management Federation, and that SAFIRE learns metadata from them via eduGAIN.)

If you can't get beyond this step, please [contact us]({{< ref "/safire/contact/_index.md" >}}) and put us in touch with them.

### Entity ID
You will usually be asked for an entity ID or IdP identity. Entity IDs are globally unique persistent identifiers (think of them as like an ORCID iD or DOI for a specific service- or identity-provider). Yours uniquely identifies your institution's identity provider to the service.

If the provider is accessing your identity provider via eduGAIN, the value they will need is your institution's proxied entity ID. You can get this by finding on your institution in [our list of identity providers]({{< ref "/participants/idp/list.md" >}}) and looking at the `Metadata entityID` field. Note: it always starts with `https://proxy.safire.ac.za/…`.

### Wayfless URLs
You may also be asked to make use of a "Wayfless" URL. Different providers have different mechanisms for constructing these, so you will need to refer to the providers's documentation. However, they will always involve a [URL-encoded](https://en.wikipedia.org/wiki/Percent-encoding) version of your entity ID --- to get this, find your institution in [our list of identity providers]({{< ref "/participants/idp/list.md" >}}) and then click on  the `Metadata entityID` field to expand it. This will display other forms of the entity ID, including the `Wayfless entityID` for you to copy-and-paste.

### eduPersonScopedAffiliation
You may be asked for affiliation or scoped affiliation values. These are the values your institution sets for [_eduPersonScopedAffiliation_]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) and will be a value like `member@example.ac.za`. You may be able to figure out the correct ones by logging into our [test service provider](https://testsp.safire.ac.za/), but generally you should confirm them with your own identity provider administrator or IT support staff.

eduPersonScopedAffiliation uses a [controlled vocabulary]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) with `member` being the most permissive term. So `member@example.ac.za` is akin to saying "all staff, students, and affilates of example.ac.za". If you are licensing resources to specific subsets of your community, you may want a more specific term. However, check with your IdP admin for what your institution supports!

### eduPersonEntitlement
If you are asked for an entitlement value, you will most likely use `urn:mace:dir:entitlement:common-lib-terms` as described in the [common-lib-terms specification](https://www.internet2.edu/products-services/trust-identity-middleware/mace-registries/urnmace-namespace/urn-mace-dir-registry/urn-mace-dir-entitlement/) and [_eduPersonEntitlement_]({{< ref "/technical/attributes/edupersonentitlement.md" >}}). However, note that SAFIRE does [not release this by default]({{< ref "/safire/policy/arp/_index.md#default" >}}) so this will only work if we've explictly enabled it (which will be the case for ones marked as working that require this).

### Attributes
SAFIRE's default [attribute release policy]({{< ref "/safire/policy/arp/_index.md#default" >}}) releases the attributes most commonly needed by library and information providers in support of pseudonymous access. We also release the correct attributes for any provider marked as working above. However, if a provider tells you they require more/other attributes, you will need to [let us know]({{< ref "/safire/contact/_index.md" >}}) (preferably with a reference to documentation).

# Hints from other federations

Other federations have links to providers' documentation that may prove useful to those trying to get this to work:

  * [Edugate (Ireland)](https://edugate.heanet.ie/rr3/p/page/LibraryAccess)
  * [UK Federation](https://www.ukfederation.org.uk/content/Documents/WAYFlessServices)
  * [ACOnet (Austria)](https://wiki.univie.ac.at/display/federation/Library+Services)
