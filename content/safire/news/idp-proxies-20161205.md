--- 
date: 2016-12-05 14:54:52+00:00
slug: idp-proxies-20161205
tags: 
  - collaboration
  - metadata
  - wayf
title: "Technical update: IdP proxies"
url: /safire/news/idp-proxies-20161205/
---

Identity provider proxies allow the hub-and-spoke federation to appear as a full mesh, at least for the purposes of IdP discovery. This means that service providers can make use of local discovery and see a list of individual SAFIRE identity providers rather than seeing a single entry for the whole federation.

In turn, this eliminates the "double discovery" problem for service providers that use local discovery to select amongst a number of different federations (e.g. sites that use [DiscoJuice](http://discojuice.org/) or derivatives). Instead of clicking through two discovery interfaces (local to select the federation, central to select the IdP), end users can select their identity provider directly at the SP.

With help from the Danish federation, [WAYF](https://wayf.dk/), we've now manged to get identity provider proxies working for SAFIRE. We're making use of WAYF's BIRK software.

This necessitates some changes to [SAFIRE's metadata bundles]({{< ref "/technical/metadata.md" >}}). In particular, a new bundle (safire-idp-proxy-metadata.xml) is introduced for SPs wishing to only make use of the IdP proxies.

Service provider proxies are not yet supported.
