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

A once-off take-on charge will be levied for each new production entity registered under the [SAML2 technology profile]({{< ref "/technical/saml2/_index.md" >}}) to cover the [administrative overheads]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) of processing a new identity provider registration. This nominal charge is based on the average amount of time we spend processing a new entity.

## Recurring costs

The recurring costs for participation is calculated based on the technology profile as well as the number of [full-time equivalent](https://en.wikipedia.org/wiki/Full-time_equivalent) staff[^fte] and students at the participating institution using the following tiering:

| Tier | FTE Band      | Effective Max Discount |
|:----:|--------------:|:----------------------:|
| 1    | 0–500         | -                      |
| 2    | 501–1 000     | 10%                    |
| 3    | 1 001–2 500   | 15%                    |
| 4    | 2 501–5 000   | 20%                    |
| 5    | 5 001–10 000  | 25%                    |
| 6    | 10 001–15 000 | 30%                    |
| 7    | 15 001–30 000 | 40%                    |
| 7+   | > 30 000      | ≥ 45%                  |
{.fees .idp}

For public and private institutions recognised by the [Department of Higher Education and Training](http://www.dhet.gov.za), the FTE count from the last published MIS[^HEMIS] submissions will be used. For other organisations, a mutually agreeable method for determining FTE count must be derived.

Tiers 1–4 are invoiced annually at 12× monthly cost. Tiers 5–7 may be invoiced monthly or annually. All costs are subject to an annual escalation to reflect the increasing costs of providing and maintaining the service.

> Please [contact us]({{< ref "/safire/contact/_index.md" >}}) for an estimate or quote. We may need to know your current FTE count to produce this.
{.message-box .info}

## Discounts and exemptions

- Institutions that subscribe to a basket of NREN services from TENET receive up to 100% discount on federation participation fees so long as they continue to receive that basket and their total monthly spend with TENET exceeds the required threshold.
- [TENET]({{< ref "safire/governance.md" >}}) may, at its sole discretion, elect to discount or exempt any organisation from paying some or all of the federation participation fees. Such discretion may be applied on recommendation from a [Member]({{< ref "/participants/idp/list.md" >}}) or the operations staff.

[^fte]: For the avoidance of doubt, this covers the FTE count of all persons recognised as &quot;staff&quot; or &quot;student&quot; under the [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) definition, but excludes those who are merely &quot;employee&quot; under that definition. In HEMIS terms, this means the &quot;trade/craft&quot; and &quot;service&quot; personnel categories are excluded.
[^HEMIS]: DHET's Higher Education Management Information System (HEMIS), or its successor or equivalent government-mandated reporting system. Note that published HEMIS submissions usually lag by approximately two years.
