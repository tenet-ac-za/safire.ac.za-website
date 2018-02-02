---
title: High Availability Architecture
date: 2018-02-01T22:43:02+02:00
tags:
 - saml2
 - technical
---

A new high-availability architecture was recently deployed in order to improve the redundancy and resilience of the Federation infrastructure.
<!--more-->

There are now two instances of the SAFIRE federation hub and the associated IdP proxy end-points. One instance is physically located in Cape Town while the other is in Johannesburg. These two hub instances normally operate in an active-active configuration and requests round-robin between the two.

The hubs sit behind a redundant pair of HAProxy load balancers. The load balancers operate in an active-standby configuration with the current preference controlled by BGP announcements. If the active load balancer fails, the standby will automatically take over once BGP re-converges. This is based on the same technology [we've been using for the eduroam NRO](https://eduroam.ac.za/faq/admin/#architecture) since April last year.

[{{< figure src="/wp-content/uploads/2018/02/SAFIRE-HA-2018.svg" caption="New HA architecture" >}}](/wp-content/uploads/2018/02/SAFIRE-Architecture-20180131.pdf)

The load balancers are configured to use an affinity cookie to try and ensure that a given browser session always goes to the same instance of the hub. If a hub instance fails, the load balancer will automatically redirect the user to a remaining, available backend. In the worst case, this means that session information is lost and users would be asked to re-authenticate. However, session information is also synchronised between the hubs to reduce the likelihood of this occurring.

In addition to improving the redundancy and resilience of normal operations, the new configuration allows us to take a hub instance out of service if we need to. This should give us the ability to deploy more complex changes and upgrades with minimal service impact.
