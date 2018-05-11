---
date: 2018-05-10 16:39:16+02:00
slug: 20180501-unplanned service outage
tags:
  - outage
title: Unplanned Service Outage
---
Between 14:35 and 16:30 SAST on Thursday 10 May, SAFIRE's federation hub
experienced an unexpected failure that would have prevented any users
from logging into federated services. <!--more-->

The cause of the failure was some invalid metadata imported from
another federation via eduGAIN. The faulty metadata was [imported by our
aggregator at about 10AM on 9 May](/safire/policy/maps/)
and shortly afterwards, SAFIRE's hub to refuse to load it. Transient
failures like this are not uncommon in a system that depends on metadata
from may other places, and the hub automatically relied on cached copies
for continued operations.

Shortly after 12:30 on 10 May, our [monitoring
system](https://monitor.safire.ac.za/) detected that the hub's metadata
had still not been refreshed and that the cache was depleting. This
prompted an investigation into the root cause, and it was discovered
that a SAML profile error was preventing the hub from loading metadata.

Unfortunately attempting to determine which of the approximately 3850
entities contained the error caused the cached metadata to expire
prematurely at 14:35. It then took several hours to uncover the cause
and restore functional metadata, during which time the federation hub
had no operational metadata and thus users would have been unable to
log into any federated service.

At 16:30 the problem was discovered and cached metadata was restored.
However, the problematic entity remained in the source metadata and
it was another hour or so before it could be filtered out.

Contact was made with the home federation of the problematic entity to
alert them to the issue. In addition, the filter mechanism described
above should prevent the same error from recurring (it filters on the
metadata problem rather than the specific entity).
