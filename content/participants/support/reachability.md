---
date: 2020-11-13 08:56:00+02:00
menu:
  main:
    identifier: participants-support-reachability
    parent: participants-support
    weight: 2
slug: reachability
title: IdP Reachability
---

As a courtesy, we monitor the reachability of the various South African [identity providers]({{< ref "/participants/idp/list.md" >}}) and make that information available at [**monitor.safire.ac.za**](https://monitor.safire.ac.za/safire/thruk/cgi-bin/status.cgi?servicegroup=instidps&style=detail&title=Institutional+Identity+Provider+Reachability&nav=0&hidetop=1).

The monitoring results can be interpreted as follows:

[Green / SAML_SSO OK]
: We managed to perform a SAML AuthN request and reach something that looked like a login page

[Yellow / SAML_SSO WARNING]
: Lets you know that while we managed to perform a SAML AuthN request, a problem was noted. This could be that a certificate is close to expiry or that the page we reached didn't behave like a normal login page.

[Red / SAML_SSO CRITICAL]
: Lets you know something went wrong. This could be because some part of the authentication infrastructure is not responding, the web server(s) involved reported an error, or because a certificate has expired.

## How monitoring works

The monitoring system tries to initate an SSO login from the [SAFIRE Test Service Provider](https://testsp.safire.ac.za/) approximately once every 15 minutes and confirms that it gets something that appears to be a login page from the identity provider. Because each identity provider is free to implement its own login requirements, unlike its [eduroam equivelent](https://eduroam.ac.za/status/), this test does *not* actually attempt to log into the identity provider.

The actual SAML implementation used by this system is somewhat limited and only supports standard bindings. It determines whether a login page is reached by scraping the HTML for a form with a username field, however this has proved sufficient for a number of different vendors' implementations.

When a problem occurs the monitoring system will attempt to determine whether this is a transient problem or a more sustained one. It does this by re-attempting the SAML transaction three times at two-minute intervals before reverting to its normal scheduling.

## Courtesy notifications

The monitoring system also loads contact details from the identity provider's metadata. This allows the monitoring system to send courtesy email notifications to the contacts if/when their service becomes unreachable for an extended period. These are configured to only be sent infrequently (approximately once per week) so as not to be too onerous during extended outages. However, contacts may get multiple notifications if your identity provider server responds inconsistently.

Contacts are free to opt-out of these notifications; we support RFC 8058 unsubscribe headers.

