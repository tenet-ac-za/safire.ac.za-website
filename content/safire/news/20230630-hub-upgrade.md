---
date: 2023-06-26 14:54:00+02:00
slug: 20230630-hub-hupgrade
tags:
  - technical
title: Upgrade of SAFIRE federation hub (30 June)
---

On Friday 30 June we'll be performing a major version upgrade of the software that's at the core of SAFIRE's federation hub. Although no downtime is expected, you can expect the following:

* All users will need to re-authenticate the first time they access a service after the upgrade;
* There will be cosmetic changes to the user interface, particularly in the information transfer notice.<!--more-->

The upgrade we'll be performing has been extensively tested, including community testing by some of our identity providers. As such, we do not anticipate any problems and there should be no substantive change in functionality. However, with a change of this magnitude there's always a risk that something unforeseen will happen.

To mitigate that risk, we'll be performing the upgrade in three stages. From around mid-morning on the 30th, we'll begin migrating a subset of the users to the new version. If that goes smoothly, we'll perform a blue-green migration of the remaining users during the course of the afternoon. This is achieved by simply swapping the existing active (old) and standby (new) instances of our federation hub, allowing us to easily roll back to the current version if we need to. Finally, we'll complete the upgrade of the older (then standby) instance after the Monday morning peak, at which point full, normal redundancy will be restored. If an unexpected fail-over occurs during the migration, or if we need to revert for any reason, users will simply be directed back to the old, existing version of the software and will need to re-authenticate once more.

