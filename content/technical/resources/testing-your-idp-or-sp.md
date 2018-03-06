---
date: 2017-06-15 08:44:46+00:00
slug: testing-your-idp-or-sp
tags:
  - edugain
  - technical
  - testing
title: Testing your IdP or SP
url: /technical/resources/testing-your-idp-or-sp/
aliases:
  - /safire/news/testing-your-idp-or-sp/
---

# Testing an Identity Provider

The most obvious way to test an Identity Provider is to make use of SAFIRE's Test Service Provider ([https://testsp.safire.ac.za/](https://testsp.safire.ac.za/)). This SP is always aware of SAFIRE's [full attribute set](/technical/attributes/) and emulates a locally connected SP. By logging in, Identity Provider administrators are able to test their integration with SAFIRE as well as their own attribute release. (Likewise, end users can use it to see what attributes their home institution releases about them.)

By logging in, Identity Provider administrators are able to test their integration with SAFIRE as well as their own attribute release. Likewise, end users can use it to see what attributes their home institution releases about them.

### Inter-federation

You may also want to test how your Identity Provider looks outside of SAFIRE. This the following are equivalent test service providers available from other federations in eduGAIN:

  * [SWITCH Interfederation Attribute Test](https://attribute-viewer.aai.switch.ch/interfederation-test/)
  * [GARR SP24 test SP](https://sp24-test.garr.it/)
  * [eduGAIN Attribute Release Check](http://release-check.edugain.org)

Each of the above should allow SAFIRE identity providers that have not opted out of eduGAIN to log in, and will show you what attributes are released. Note that the attribute release will be a subset of SAFIRE's attributes, as defined by our [attribute release policy](/safire/policy/arp/).

# Testing a Service Provider

In order to allow Service Providers to test their service works correctly within SAFIRE, we've created the SAFIRE Test Identity Provider ([https://testidp.safire.ac.za/](https://testidp.safire.ac.za/)). This is a limited use IdP that allows the registered contacts for a service to create accounts that only work with their service (you need to have access to the technical or support contact email to generate accounts).

The Test IdP creates several different accounts with predefined profiles representing the different user types (academic staff, students, administrative staff) you might find at a typical South African institution. Service Provider administrators can see what attributes are available for each profile by choosing the "show account details" links once you've generated accounts. However, you should be aware that the attributes received by your Service Provider will depend on the [attribute release policy](/safire/policy/arp/) that applies to it.

The SAFIRE Test Identity Provider is a local instance of the eduGAIN Access Check software and is registered within the SAFIRE Federation just as other South African identity providers are. It is not available within eduGAIN.

### Inter-federation

The [eduGAIN Access Check](https://access-check.edugain.org/) identity provider is registered by Fédération Éducation-Recherche in France, and thus can be used by SAFIRE service providers who've opted into eduGAIN to further check their integration with eduGAIN is working correctly and that users from other federations will be able to log in. It provides a slightly different set of user profiles to the SAFIRE instance, reflecting the many different user types around the world.
