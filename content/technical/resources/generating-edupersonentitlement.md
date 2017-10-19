---
date: 2017-10-19T07:13:00Z
slug: generating-edupersonentitlement
tags:
  - eduPersonEntitlement
  - idp-requirements
  - simplesamlphp
  - technical
title: Generating eduPersonEntitlement
url: /technical/resources/generating-edupersonentitlement/
---

The [eduPersonEntitlement]({{< ref "/technical/attributes/edupersonentitlement.md" >}}) attribute is used to indicate a user's entitlement to access a specific service or resource.
For example, its most widely used value, `urn:mace:dir:entitlement:common-lib-terms`, is used to indicate [eligibility to access licensed content from information publishers](https://www.internet2.edu/products-services/trust-identity/mace-registries/urnmace-namespace/urn-mace-dir-registry/urn-mace-dir-entitlement/).

## Relationship to eduPersonScopedAffiliation

[Library information providers]({{< ref "/technical/resources/library-services.md" >}}) often support both _eduPersonEntitlement_ and _eduPersonScopedAffiliation_ as a means of limiting access to licensed resources.

It is likely that there is significant overlap between values used for [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) (and thus [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}})). For instance, many institutions view all members as being eligible to access their library resources. Thus an _eduPersonAffiliation_ of `member` is likely to have the same semantic meaning as an _eduPersonEntitlement_ of `urn:mace:dir:entitlement:common-lib-terms`.

However, because _eduPersonAffiliation_ can (and is likely to) contain other values, _eduPersonEntitlement_ is the more privacy-preserving option of the two. This means that using the common-lib-terms entitlement to control access to licensed content may be preferable to using eduPersonScopedAffiliation unless you've a specific reason to require scopes.

## Generating eduPersonEntitlement

The relationship between _eduPersonAffiliation_ and _eduPersonEntitlement_ means that you can often re-use many of the same techniques you might use to generate eduPersonAffiliation. Our documentation on [generating eduPersonAffiliation]({{< ref
"/technical/resources/generating-edupersonaffiliation.md" >}}) is a good starting point.

You may also be able to re-map existing attributes (such as eduPersonScopedAffiliation). For an idea of how to do this, see [ACOnet's documentation](https://wiki.univie.ac.at/display/federation/IDP+3+Attribute+resolution#IDP3Attributeresolution-eduPersonEntitlement).

## A note about the auto-generated values

To ease transition and lower barriers to entry, we have configured the Federation hub to [automatically generate eduPersonEntitlement]({{< ref
"/technical/attributes/edupersonentitlement.md" >}}) from eduPersonAffiliation if the former does not exist.

As a general rule, if you've any possibility of generating the correct values yourself, you should do this in preference to relying on the automatically generated value.

Any value of _eduPersonEntitlement_ (even an empty one) will suppress the automatic generation of _eduPersonEntitlement_ by the Federation hub. If you need to suppress generation of common-lib-terms for a user who matches the [hub's criteria]({{< ref "/technical/attributes/edupersonentitlement.md" >}}) but your IdP software is not capable of sending an empty value, you may assert [`urn:mace:safire.ac.za:entitlement:dummy`]({{< ref "/technical/namespaces.md#urn-mace-safire-ac-za" >}}) as a valid, but useless value.
