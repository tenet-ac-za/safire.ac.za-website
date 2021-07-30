---
date: 2016-11-04 09:12:33+00:00
slug: hsm-for-metadata-signing-20161104
tags:
  - collaboration
  - hsm
  - metadata
  - security
title: "Technical update: HSM for metadata signing"
url: /safire/news/hsm-for-metadata-signing-20161104/
---

Metadata is the basis of trust in any federation, and this makes the [key management practices ]({{< ref "/safire/policy/kmps/_index.md" >}})for metadata signing particularly important.

In response to suggestions from other federation operators, we've decided to try and get this "right" from the beginning --- at least as far is actually practical for a small federation in its early stages. And "right" means that we should store our metadata signing key in some form of [hardware security module](https://en.wikipedia.org/wiki/Hardware_security_module).

HSMs come in many shapes and sizes, and the kind [banks and certificate authorities use](https://cpl.thalesgroup.com/encryption/hardware-security-modules) are way out of our current reach. However, there are low-cost smartcard-based HSMs that might be a practical solution to the problem. So we've ordered a USB form factor [SmartCardHSM](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM) to do some testing with.

The specific device we've ordered is a [Nitrokey HSM](https://www.nitrokey.com/#comparison).  We previously ordered and tested an OpenPGP-based Nitrokey Pro in the hopes of gaining support for [4096 bit keys](https://www.keylength.com/), but it proved too crippled for this purpose --- so unfortunately we're stuck with 2048 bit keys for the time being. The Nitrokey has had an [independent security audit](https://www.nitrokey.com/news/2015/nitrokey-storage-got-great-results-3rd-party-security-audit) of both its [hardware](https://cure53.de/pentest-report_nitrokey-hardware.pdf) and [firmware](https://cure53.de/pentest-report_nitrokey.pdf) (albeit for a different product), which gives some confidence in the company. In addition, the underlying SmartCardHSM complies with the German Federal Office for Information Security's technical standards.

If our tests with this device work, then we'll make use of it when we generate our production [metadata signing keys]({{< ref "/technical/metadata.md" >}}).

_(Updated 2016-11-23 to reflect switch to Nitrokey HSM)_
