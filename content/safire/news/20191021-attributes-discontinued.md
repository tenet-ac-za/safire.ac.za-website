---
date: 2019-10-15 09:30:00+02:00
slug: 20191021-attributes-discontinued
tags:
  - technical
title: Support for employeeNumber and o attributes discontinued
url: /safire/news/20191021-attributes-discontinued/
---

Support for the [`employeeNumber`]({{< ref "/technical/attributes/employeenumber.md" >}}) and [`o`]({{< ref "/technical/attributes/o.md" >}}) attributes was deprecated on 15 October 2019<!--more-->

The `employeeNumber` attribute was introduced to support a single service that has never materialised, RIMS and was not in use by any provider. Therefore support for it was completely discontinued as of 21 October 2019, along with the never-formally-supported attribute [`eduPersonUniqueId`]({{< ref "/technical/attributes/edupersonuniqueid.md" >}}).

The `o` attribute was consumed by a number of service providers, all of whom were contacted individually for comment prior to deprecation. As no dissenting opinions were received, it was formally deprecated on 15 October and will be discontinued entirely on 30 November 2019.

These two attributes were deprecated after a period of [consultation with the community](https://lists.tenet.ac.za/sympa/arc/safire-discuss/2019-10/msg00000.html).
