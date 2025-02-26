---
date: 2024-10-23 00:00:00+02:00
menu:
  main:
    identifier: participants-idp-fees
    name: Fees
    parent: participants-idp
    weight: 4
slug: fees
title: Fees for Identity Providers
url: /participants/idp/fees/
---

## Non-recurring costs

A once-off take-on charge of ***R 2750*** will be levied for each new production entity registered under the [SAML2 technology profile]({{< ref "/technical/saml2/_index.md" >}}) to cover the [administrative overheads]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) of processing a new identity provider registration.
{.fees-saml2}

There are no take-on or other initial non-recurring charges associated with the [RADIUS/EAP ("eduroam")]({{< ref "/technical/radius-eap/_index.md" >}}) technology profile.
{.fees-radius}

## Annual recurring costs

The annual recurring cost is calculated based on the technology profile as well as the number of [full-time equivalent](https://en.wikipedia.org/wiki/Full-time_equivalent) staff[^fte] and students at the participating institution.

{{< fees "idp" >}}

For public and private institutions recognised by the [Department of Higher Education and Training](http://www.dhet.gov.za), the FTE count from the last published HEMIS[^HEMIS] submissions will be used. For other organisations, a mutually agreeable method for determining FTE count must be derived.

All annual recurring costs are subject to an annual escalation to reflect the increasing costs of providing and maintaining the service.

## Discounts and exemptions

- **Institutions that subscribe to a basket of NREN services from TENET receive a 100% discount on SAFIRE's fees** so long as they continue to receive that basket.
- Non-profit or public benefit organisations properly registered as such in South Africa may request a discount.
- [TENET]({{< ref "safire/governance.md" >}}) may, at its sole discretion, elect to discount or exempt any organisation from paying SAFIRE's fees. Such discretion may be applied on recommendation from a [Member]({{< ref "/participants/idp/list.md" >}}) or the operations staff.
- All prices exclude value-added tax (VAT)
<!-- break to apply class separately -->
- &Dagger; eduroam identity providers with 150 or fewer users may use the eduroam Managed IdP service at no charge.
- Non-profit or public benefit eduroam identity providers that provide a reciprocal service provider used by other institutions receive a 50% discount on the RADIUS profile fees.
{.fees-radius}

[^fte]: For the avoidance of doubt, this covers the FTE count of all persons recognised as &quot;staff&quot; or &quot;student&quot; under the [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) definition, but excludes those who are merely &quot;employee&quot; under that definition. In HEMIS terms, this means the &quot;trade/craft&quot; and &quot;service&quot; personnel categories are excluded.
[^HEMIS]: DHET's Higher Education Management Information System, or its successor or equivalent government-mandated reporting system. Note that published HEMIS submissions usually lag by approximately two years.
