--- 
date: 2016-09-14 05:45:15+00:00
slug: metadata-refresh-during-transition
tags: 
  - metadata
title: Metadata refresh during transition
url: /safire/news/metadata-refresh-during-transition/
---

SAFIRE is currently transitioning from a full-mesh federation to a hub-and-spoke federation. As we change architectures, we will be asking all participants to re-submit their metadata. The current metadata has known errors, and so we want to ensure we don't inadvertently port any others. We will instead apply the prevailing [metadata registration practice statement]({{< ref "/safire/policy/mrps/_index.md" >}}) at the time of the transition.

The [identity]({{< ref "/participants/idp/list.md" >}})- and [service ]({{< ref "/participants/sp/list.md" >}})provider lists shown on this website are generated automatically from the underlying metadata and, at the time of writing, reflect the metadata from the full-mesh federation. As we transition architectures, these lists will be emptied and will then slowly be repopulated as we take on new metadata. This is expected behaviour and is not intended to prejudice any participant(s).
