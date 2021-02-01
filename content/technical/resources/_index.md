---
date: 2021-02-01 09:00:00+02:00
menu:
  main:
    identifier: technical-resources
    name: Technology Resources
    parent: technical
    weight: 4
slug: resources
title: Resources
url: /technical/resources/
---

This page contains links to more information and technical resources. It will be expanded as time passes, and stuff here may change significantly. The idea is to provide a starting point for people looking to implement an identity or service provider connected to SAFIRE.

# Introduction to Federation

  * The NSRC & GÉANT have produced an excellent series of videos giving a broad introductory overview of federation topics, which are available at [https://learn.nsrc.org/FedIdM](https://learn.nsrc.org/FedIdM).

# SAML2 Implementations

  * Shibboleth ([IdP](https://shibboleth.net/products/identity-provider) & [SP](https://shibboleth.net/products/service-provider))
  * [SimpleSAMLphp](https://simplesamlphp.org/)
  * [ADFS 2.0](https://technet.microsoft.com/en-us/windowsserver/dd448613.aspx)
  * [Google Apps for Education](https://support.google.com/a/topic/6194927)
  * [Others](https://en.wikipedia.org/wiki/SAML-based_products_and_services)?

# Identity provider deployment

  * [IdP Installer](https://github.com/idp-installer-manager/idp-installer-global) - Federated identity Appliance developed by [CANARIE](http://www.canarie.ca/en/caf-service/about) (CA) /[SWAMID](http://www.swamid.se/) (SE).
  * [Step-by-step IdP installation](https://tuakiri.ac.nz/confluence/display/Tuakiri/Installing+a+Shibboleth+3.x+IdP) - written by Tuakiri (NZ), but many of the principles follow through.
  * [TestShib](http://www.testshib.org/) - Test service provider.
  * [SAMLtest.id](https://samltest.id/) - test your IdP & SP

# Service Provider deployment

  * [AARC Blueprint Architecture](https://aarc-project.eu/architecture/) - a set of software building blocks that can be used to implement federated access management solutions for international research collaborations.
  * [Research & Scholarship](https://wiki.refeds.org/display/ENT/Research+and+Scholarship+FAQ) entity category
  * [How to turn web-based services into Service Providers of Identity Federation](http://courses.sci-gaia.eu/courses/GARR/SP101/2015_T4/about) (Sci-GaIA free online course)
  * [Wordpress](https://wordpress.org/plugins/shibboleth/)
  * [Moodle](https://docs.moodle.org/31/en/Shibboleth)

# User Interface/Login pages/Discovery

  * [Seamless Access](https://seamlessaccess.org/) - the Seamless Access discovery service, building on the outcomes of [RA21](https://ra21.org/). _(This is the recommended approach for people deploying new services.)_
  * [Shibboleth embedded discovery service](https://wiki.shibboleth.net/confluence/display/EDS10/Embedded+Discovery+Service)
  * ~~[eduGAIN DSX embedded discovery](https://wiki.geant.org/display/eduGAIN/Embedded+Discovery)~~ *[decommissioned]*
  * ~~[DiscoJuice](http://discojuice.org/) - user-friendly, JavaScript discovery service.~~ *[decomissioned]*

### Best Practices for UX
  * [RA21](https://ra21.org/): Resource Access for the 21st Century
  * [REFEDS Discovery Guide](https://discovery.refeds.org/) - best practices for integrating federation login into your web site.
  * [MDUI](https://wiki.refeds.org/display/FBP/MDUI+Advice) - metadata user interface extensions.

# Security/Incident response

  * [Security Incident Response Trust Framework for Federated Identity (Sirtfi)](https://refeds.org/sirtfi)

# SAFIRE-specific stuff

