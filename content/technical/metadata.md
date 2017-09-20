---
date: 2016-09-12 10:34:11+00:00
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

# SAFIRE Federation Hub

This is the basic metadata for the SAFIRE federation, and contains information about the hub. It is intended for use by SAFIRE participants.

{{< metadata url="https://metadata.safire.ac.za/safire-hub-metadata.xml" entityId="true" >}}

# SAFIRE IdP Proxies

This is metadata for identity providers in the SAFIRE federation, reached via an IdP proxy to avoid centralised discovery. It is intended for use by SAFIRE participants who wish to run their own local discovery services.

{{< metadata url="https://metadata.safire.ac.za/safire-idp-proxy-metadata.xml" >}}

# Inter-federation Metadata

#### SAFIRE Participants into eduGAIN

This is a feed for eduGAIN containing only identity and service providers who wish to participate in inter-federation.

{{< metadata url="https://metadata.safire.ac.za/safire-edugain.xml" >}}

#### SAFIRE Service Providers consuming eduGAIN IdPs

This is a re-publication of the eduGAIN metadata after it has passed through SAFIRE's metadata aggregation and filters. It is intended for use by SAFIRE service providers who are participating in eduGAIN, and therefore only includes identity providers.

{{< metadata url="https://metadata.safire.ac.za/edugain-consuming.xml" >}}

#### SAFIRE Service Providers consuming Sirtfi-compliant eduGAIN IdPs

This is a re-publication of a subset of the eduGAIN metadata that only includes [Sirtfi-compliant](https://refeds.org/sirtfi) identity providers that have passed through SAFIRE's metadata aggregation and filters. It is intended for use by SAFIRE service providers who are participating in eduGAIN.

{{< metadata url="https://metadata.safire.ac.za/edugain-sirtfi-consuming.xml" >}}

