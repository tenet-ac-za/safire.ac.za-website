---
date: 2019-02-07 07:59:09+02:00
slug: 20190207-mrps-updated
tags:
  - mrps
  - idp-requirements
title: MRPS updated to allow regular expressions
url: /safire/news/20190207-mrps-updated
---

SAFIRE's [Metadata Registration Practice Statement]({{< ref "/safire/policy/mrps/_index.md" >}}), and the corresponding SAML2 [Identity Provider Requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) have been [updated]({{< ref "/safire/policy/mrps/v20190207.md" >}}) to allow for regular expressions in scopes.<!--more-->

This change, which was taken to the SAFIRE Participants Forum last year, has been made to facilitate the increasing use of sub-scopes to provide more granular access control for services such as [FigShare](https://figshare.com/). We're fully aware of the caveats involved in using regular expression scopes, and intend being very conservative about how we approach this. The specific wording in the MRPS is derived from a revision to the [REFEDS Metadata Registration Practice Statement template](https://github.com/REFEDS/MRPS/blob/master/mrps.md) that was widely discussed among the federation operator community.

The addition of support for regular expressions is backwards compatible with the [previous version]({{< ref "/safire/policy/mrps/v20170213.md" >}}) of the MRPS. For this reason, the `<mdrpi:RegistrationPolicy>` element of all entities with existing metadata in SAFIRE's registry may be bumped to signify compliance with the new MRPS.
