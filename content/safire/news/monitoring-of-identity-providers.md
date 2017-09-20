---
date: 2017-05-25 07:29:12+00:00
slug: monitoring-of-identity-providers
tags:
  - metadata
  - monitoring
  - technical
title: Monitoring of Identity Providers
url: /safire/news/monitoring-of-identity-providers/
---

As a courtesy, we monitor the reachability of the various South African identity providers and make that information available at [monitor.safire.ac.za](https://monitor.safire.ac.za/safire/thruk/cgi-bin/status.cgi?servicegroup=instidps&style=detail&title=Institutional+Identity+Provider+Reachability&nav=0&hidetop=1).

The monitoring system initiates a single sign-on request, and reports the outcome as follow:

  * **Green** means that we completed all the tests and found something that looked like a login page.

  * **Yellow** means that we got as far as what we think should be a login page, but didn't find a username field on it. The institution's own monitoring or I.T. help desk may be able to provide more information.

  * **Red** means that we weren't able to contact the identity provider for some reason. This could be because there's a network problem or that the there's some problem with the identity provider (service not running, certificates expired, metadata expired, etc).

The monitoring output shows the hosts we passed through on the way to what we believe is the login page. It may also give details of any problem(s) that were encountered.

<!-- more -->

# Implementation information

The monitoring system emulates a web browser attempting to log into the [test service provider](https://testsp.safire.ac.za/), and uses [IdP proxies]({{< ref "/technical/metadata.md" >}})/scoping elements to preselect an identity provider. It derives all of its information from the[ federation metadata](https://phph.safire.ac.za/overview?filter=fed%3A%5Esafire-fed-registry%24) and reloads this daily during the normal metadata update cycle.

The tests are implemented using a [Nagios-compatible plugin](https://github.com/safire-ac-za/monitoring-plugins) that makes use of LWP::UserAgent to implement a very minimal subset of the SAML2 protocol. The plugin could probably be improved significantly.

## Identification

To make it easier for you to find the monitoring system's attempts in your log files, the monitoring system issues a User-Agent string that begins with `check_saml_sso`. They will originate from monitor.safire.ac.za.

## Frequency

The monitoring system is configured to try and authenticate approximately once every 15 minutes. This means when everything is working properly you should see about eight authentication requests per hour.

When authentication first fails for a particular IdP, the monitoring system will attempt to determine whether this is a transient problem or a more sustained one. It does this by attempting to reach the login page five times at two-minute intervals before reverting to its normal scheduling. You can read about how this works in [naemon's documentation](http://www.naemon.org/documentation/usersguide/statetypes.html).

## Courtesy notifications

The monitoring system also loads contact details from metadata and generates contact objects from them. This allows the monitoring system to send courtesy notifications to the contacts if/when their realm becomes unreachable for an extended period. These are configured to only be sent infrequently (approximately once per week) so as not to be too onerous during extended outages. However, you may get multiple notifications if your IdP responds inconsistently.

## Experimental service

The monitoring system is an experimental service that may never become a production service. As such, whilst we will endeavour to ensure it's operating correctly, it is not formally supported. Instead, this system is provided as a courtesy to help improve the user experience and as a (hopefully) useful diagnostic tool to aid debugging. It exists as an adjunct to other monitoring.

You should not rely on this monitoring or the notifications it provides to the exclusion of your own monitoring --- responsibility for the correct operation of an identity provider always rests with the institution.
