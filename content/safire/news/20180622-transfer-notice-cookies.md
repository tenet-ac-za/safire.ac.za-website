---
title: Change in the way the transfer notice is remembered
date: 2018-06-22T12:56:00+02:00
slug: 20180622-transfer-notice-cookies
tags:
---

During the login process, end-users are shown a transfer notice with a summary of the information that will be shared with the service provider. We've changed the way this works.
<!--more-->

The transfer notice page has always has the option to remember that the user has seen it, and ticking the "remember" box prevents it from being displayed on subsequent logins to the same service provider. Statistics show that the vast majority of users (>85%) tick this the first time the log in to a particular service provider, so we've changed it to default to being ticked. (Users can still un-tick it if they wish to have the notice re-displayed the next time the log in.)

When a user elects to have this notification remembered, we've historically stored that information in a database. However, doing so greatly complicates the [high availability]({{< relref "20180201-high-availability.md" >}}) architecture and introduces a single point of failure. After consultation with federation operators in other countries and having solicited the input of the [Participants' Forum]({{< relref "20180616-forum-tor.md" >}}), we've changed the Federation Hub to use browser cookies to remember this rather than a database.

Using cookies simplifies operations and improves reliability, but comes at the expense of making memory of the notice dependant on a specific browser instance. However this is not unfamiliar to end-users as most social providers now have a "remember this browser" option in their own login processes. Like those providers, we only remember for a limited period --- the cookie validity is currently set to about three months (90 days).

It also means that the old "consent admin" interface (consentadmin.safire.ac.za) is no longer available. Instead we've updated our [help page]({{< ref "/users/help.md" >}}) to tell users how to clear or delete cookies, and made corresponding changes in several other places to refer to this documentation.

Likewise we've removed many references to the word "consent" from the interface and from our end-user documentation, to reflect the fact that consent is not the only basis for lawful processing (and indeed, many service providers rely on legitimate interest as their basis rather than consent). We hope this will be less confusing to end-users.

An update to the [privacy statement](/safire/policy/privacy/) will follow in due course.

