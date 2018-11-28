---
date: 2018-11-28 09:27:00+02:00
slug: 20181128-isizulu-isixhosa
tags:
 - simplesamlphp
 - website
title: SAFIRE user interface available in IsiZulu and isiXhosa
---

The SAFIRE federation hub (including the [transfer notices]({{< relref "20180622-transfer-notice-cookies.md" >}}) is now available in both [IsiZulu](https://iziko.safire.ac.za/module.php/core/frontpage_welcome.php?language=zu) and [isiXhosa](https://iziko.safire.ac.za/module.php/core/frontpage_welcome.php?language=xh) in addition to the existing [Afrikaans](https://iziko.safire.ac.za/module.php/core/frontpage_welcome.php?language=af) and [English](https://iziko.safire.ac.za/module.php/core/frontpage_welcome.php?language=en). This covers the four most widely spoken home languages [according to Stats SA](http://www.statssa.gov.za/census/census_2011/census_products/Census_2011_Census_in_brief.pdf).<!--more-->

TENET commissioned a [professional translation](https://www.stcommunications.com/) of key parts of the SimpleSAMLphp user interface, which we've [contributed back to the project](https://github.com/simplesamlphp/simplesamlphp/pull/986). These two languages should be available to all users of SimpleSAMLphp in the [1.17.0 release](https://simplesamlphp.org/releaseplan).

We [continue to encourage](https://safire.ac.za/technical/saml2/idp-requirements/#language-and-localisation) participants in the federation to include all known translations --- particularly of their official names --- in their metadata. This is particularly relevant to South African universities, which typically translate their names into three or more languages. Where such translations exist, they will be correctly used within SAFIRE's user interface when an appropriate language is selected.

Users who notice any errors in translation (into any language) are welcome to [contact us]({{< ref "/safire/contact/_index.md" >}}), and we'll attempt to correct them.

