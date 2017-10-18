---
date: 2017-07-24 13:47:06+00:00
slug: library-resources
tags:
  - collaboration
  - library
  - publishers
  - technical
title: Integrating library resource providers via SAFIRE
url: /technical/resources/library-resources/
aliases:
 - /technical/resources/integrating-library-resource-providers-via-safire/
---

There is considerable interest in leveraging SAFIRE and eduGAIN to integrate with the various library resource providers, such as journal and database publishers.  Resource providers variously term this "Shibboleth", "SAML" or "Institutional" logins, and in most cases are already integrated with other federations around the world.

The following documents the integration status of various providers.

{{< libraryproviders >}}

# Values needed by publishers

Publishers may ask for an entity ID or IdP identity. If they're accessing your identity provider via eduGAIN, the value they will need is your institution's [proxied entity ID](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC). You can get this by clicking on your institution in [our list](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC), and then copying the entity ID field. (Note that the version displayed in the list is sometimes truncated.)

You may also be asked for a WAYFless URL. Different publishers have different mechanisms for constructing these, so you will need to refer to the publisher's documentation. However, they will always involve a [URL encoded](https://www.urlencoder.org/) version of the entity ID described in the preceding paragraph.

Finally, you may be asked for affiliation or scoped affiliation values. These are the values your institution sets for [_eduPersonScopedAffiliation_]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) and will be a value like member@example.ac.za. You may be able to figure out the correct ones by logging into our [test service provider](https://testsp.safire.ac.za/), but generally you should confirm them with your own identity provider administrator or IT support staff.

# Hints from other federations

Other federations have links to providers' documentation that may prove useful to those trying to get this to work:

  * [Edugate (Ireland)](https://edugate.heanet.ie/rr3/p/page/LibraryAccess)
  * [UK Federation](https://www.ukfederation.org.uk/content/Documents/WAYFlessServices)

