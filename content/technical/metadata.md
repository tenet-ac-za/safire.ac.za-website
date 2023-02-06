---
date: 2023-02-06T11:21:00+02:00
menu:
  main:
    identifier: technical-metadata
    parent: technical
    weight: 1
slug: metadata
title: SAFIRE Metadata
url: /technical/metadata/
---

SAFIRE publishes various metadata feeds, at the locations shown below. All feeds are signed using SAFIRE's metadata signing key, and the signatures should be verified before using this metadata.

# Metadata for identity providers

> This is metadata for entities that have [joined SAFIRE]({{< ref "/participants/idp/join.md" >}}) as an [identity provider]({{< ref "/participants/idp/list.md" >}}) and exchanged metadata with us.
{.message-box .warning}

### SAFIRE Federation Hub

This is the basic metadata for the SAFIRE federation, and contains information about the hub.

{{< metadata url="https://metadata.safire.ac.za/safire-hub-metadata.xml" entityId="true" >}}

The hub metadata can also be used by SAFIRE service providers who only wish to make use of central discovery services. However this mode of operation is **deprecated** as it is incompatible with current best practices for IdP discovery.

# Metadata for service providers

> This is metadata for entities that have [joined SAFIRE]({{< ref "/participants/sp/join.md" >}}) as a [service provider]({{< ref "/participants/sp/list.md" >}}) and exchanged metadata with us.
{.message-box .warning}

### SAFIRE IdP Proxies

This is metadata for identity providers in the SAFIRE federation, reached via an IdP proxy to avoid centralised discovery. It is intended for use by SAFIRE participants who wish to run their own local discovery services (this is best practice).

{{< metadata url="https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml" >}}

Service providers are strongly encouraged to also consume one of the eduGAIN IdP feeds in addtion to the IdP Proxies feed even if they have no immediate intention of using eduGAIN.

#### SAFIRE Service Providers consuming eduGAIN IdPs

This is a re-publication of the eduGAIN metadata after it has passed through SAFIRE's metadata aggregation and filters. It is intended for use by SAFIRE service providers who are participating in eduGAIN, and therefore only includes identity providers.

{{< metadata url="https://metadata.safire.ac.za/edugain-consuming.xml" >}}

#### SAFIRE Service Providers consuming Sirtfi-compliant eduGAIN IdPs

This is a re-publication of a subset of the eduGAIN metadata that only includes [Sirtfi-compliant](https://refeds.org/sirtfi) identity providers that have passed through SAFIRE's metadata aggregation and filters. It is intended for use by SAFIRE service providers who are participating in eduGAIN.

{{< metadata url="https://metadata.safire.ac.za/edugain-sirtfi-consuming.xml" >}}

# Inter-federation Metadata

SAFIRE also provides metadata to the [eduGAIN interfederation](https://edugain.org/) for use by academic federations around the world. Entities wishing to interfederate should receive this metadata from their local federation rather than directly from SAFIRE. You can view metadata we provide to eduGAIN in the [REFEDS metadata explorer tool](https://met.refeds.org/met/federation/edugain/).
