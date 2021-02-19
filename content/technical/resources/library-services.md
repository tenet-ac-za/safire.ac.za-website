---
date: 2021-02-19 12:49:06+02:00
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

# Values needed by information providers

Publishers and information providers may ask for an entity ID or IdP identity. If they're accessing your identity provider via eduGAIN, the value they will need is your institution's proxied entity ID. You can get this by finding on your institution in [our list of identity providers]({{< ref "/participants/idp/list.md" >}}) and then clicking on the `Metadata entityID` field to expand it. This will display other forms of the entity ID, including the `Proxied entityID` for you to copy-and-paste.

You may also be asked to make use of a "Wayfless" URL. Different providers have different mechanisms for constructing these, so you will need to refer to the providers's documentation. However, they will always involve a [URL-encoded](https://en.wikipedia.org/wiki/Percent-encoding) version of your entity ID --- follow the instructions in the preceding paragraph and copy the `Wayfless entityID`.

You may be asked for affiliation or scoped affiliation values. These are the values your institution sets for [_eduPersonScopedAffiliation_]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) and will be a value like `member@example.ac.za`. You may be able to figure out the correct ones by logging into our [test service provider](https://testsp.safire.ac.za/), but generally you should confirm them with your own identity provider administrator or IT support staff.

Finally, if you are asked for an entitlement value, you will most likely use `urn:mace:dir:entitlement:common-lib-terms` as described in the [common-lib-terms specification](https://www.internet2.edu/products-services/trust-identity-middleware/mace-registries/urnmace-namespace/urn-mace-dir-registry/urn-mace-dir-entitlement/) and [_eduPersonEntitlement_]({{< ref "/technical/attributes/edupersonentitlement.md" >}}). However, note that SAFIRE does [not release this by default]({{< ref "/safire/policy/arp/_index.md#default" >}}) so this will only work if we've explictly enabled it (which will be the case for ones marked as working that require this).


# Hints from other federations

Other federations have links to providers' documentation that may prove useful to those trying to get this to work:

  * [Edugate (Ireland)](https://edugate.heanet.ie/rr3/p/page/LibraryAccess)
  * [UK Federation](https://www.ukfederation.org.uk/content/Documents/WAYFlessServices)
  * [ACOnet (Austria)](https://wiki.univie.ac.at/display/federation/Library+Services)
