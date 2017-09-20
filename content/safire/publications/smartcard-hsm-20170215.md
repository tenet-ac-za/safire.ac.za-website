---
date: 2017-02-15 14:45:35+00:00
slug: smartcard-hsm-20170215
tags:
  - collaboration
  - hsm
  - kmps
  - metadata
  - security
  - technical
title: Using a Smartcard-based HSM for SAFIRE
url: /safire/publications/smartcard-hsm-20170215/
---

This post documents SAFIRE's experiments with, and ultimate deployment of, a smartcard-based HSM for SAML metadata signing in the hope that we can help other emerging federations along the way.<!-- more -->

# The need for an HSM

Our [original roadmap]({{< ref "/safire/publications/draft-technical-roadmap-july-2016.md" >}}) for the federation realised that sooner or later we'd need to think about using a [hardware security module](https://en.wikipedia.org/wiki/Hardware_security_module) to protect metadata signing keys. The trust relationships in federation are dependent on signed metadata, and in many ways, the metadata signing key is the trust anchor, just like the root certificate in a PKI certificate authority. Moreover, many federations before us had gone done this route and so it had to be a matter of time.

However, even a cursory look at commercial HSMs will put off any emergent federation: these things are expensive --- well beyond the budget of a small federation in its infancy. So the need for an HSM got pushed down the roadmap into a "we'd like to get there eventually" way. Instead, our original plan was to use [SoftHSM](https://www.opendnssec.org/softhsm/), or even to simply use a password-protected PEM key on disk, and to introduce a real™ HSM later on.

Then a chance discussion with another federation operator revealed two things:

  * SAML key rollovers are [really difficult to co-ordinate](http://wayf.dk/en/front-page/2016-metadata-update) because key exchange happens out-of-band and all connected providers need to make the change; and
  * [Some](https://tnc2013.terena.org/core/presentation/94) [federations ](https://www.terena.org/activities/tf-emc2/meetings/16/National%20Update%20on%20SSD,%20tf-emc2-22.09.2010.pdf)had made use of small, smartcard-based HSMs, either for development or in production.

with the result that we were advised to consider protecting our signing key sooner rather than later. The consensus amongst our community was to [postpone the generation of our first signing key]({{< ref "/safire/news/hsm-for-metadata-signing-20161104.md" >}}) in order to allow for some experimentation.

# HSM experiments

We learned that the "eToken Pro" smartcard-based HSM that had been successfully used by one of the other federations was no longer available, and that left us shopping for an (untested) alternative.

Past experience with DNSSEC had led to the discovery of the [German Privacy Foundation](http://www.privacyfoundation.de/)'s "[Crypto Stick](http://www.privacyfoundation.de/projekte/crypto_stick/crypto_stick_english/)" project, and that lead us to wonder whether the same product would work for metadata signing purposes. The idea of an open-source project based in Germany was appealing because the Germans have a strong privacy-protection record and --- to quote a fellow operator --- "usually you only have a choice of 3 secret services you can buy crypto hardware from: French, American, Israeli".

It turns out that the Crypto Stick project has evolved into [Nitrokey](https://www.nitrokey.com/), and they have an online shop. They were happy to ship to South Africa, and no doubt other places. (They came through customs as a USB flash drive.)

### Nitrokey Pro

We initially purchased a [Nitrokey Pro](https://www.nitrokey.com/#comparison), which is based on an [OpenPGP card](https://en.wikipedia.org/wiki/OpenPGP_card), as we were hoping to take advantage of the Pro's advertised support for 4096 bit keys.

Given its use case, the Pro doesn't support terribly many keys (3) - but that was okay for our purpose since we were only looking for two. However, it turns out that the Pro is even more limited than first appears. The PKCS#15 structure is burnt into the chip and cannot be changed, and has specific key usages preassigned. As a result, there's really only one usable key for signing purposes.

More importantly, it seems the Pro doesn't support a signing algorithm that's useful for our purposes. We'd wanted to use RSA-SHA256 signatures, but this doesn't appear to be supported.

The conclusion we came to was that the Pro wasn't usable for the purpose of signing metadata. It was a useful €50 experiment.

### Nitrokey HSM

We then purchased a [Nitrokey HSM](https://www.nitrokey.com/#comparison), which is a true [smartcard HSM](https://www.smartcard-hsm.com/). Whilst limited to 2048-bit keys, it is a lot more flexible than the Pro. There's also [better documentation available](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM) for getting it to work under Linux.

The Nitrokey HSM works as advertised: it works with [OpenSC ](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM)under Ubuntu; it can generate 2048-bit RSA keys and 192-bit ECC keys; it can sign using RSA-SHA256 digests; it can store enough keys for our purpose (we ended up generating four); and it provides a mechanism for securely backing up the keys.

The only real caveat is that it is quite slow --- something that's probably true of all smartcard-based HSMs. We could manage 1-2 signings per second, averaged over a period of several hours. This is obviously not fast enough to sign SAML assertions, but we expected that.

What wasn't entirely expected is that it's also not fast enough to sign [MDQ based feeds](https://github.com/iay/md-query).  (To give an idea of the scope of the problem, resigning the current [eduGAIN feed](https://met.refeds.org/met/federation/edugain/) as MDQ entities takes a bit over half an hour.) This is a limitation that's exacerbated by our aggregator, which regenerates (and re-signs) all MDQ entities on every update. If we could optimise that to only re-sign on changes/closer to expiry, we may be able to get away with the slowness of the HSM.

However, given our current size, we're happy simply signing [traditional monolithic aggregates](https://metadata.safire.ac.za/).

# Generating a metadata signing key

Having committed to making use of an HSM to store SAFIRE's metadata signing key, we wanted to make sure we took all reasonable steps to ensure its integrity --- without becoming so onerous as to become unfeasible. The [key ceremonies](https://en.wikipedia.org/wiki/Key_ceremony) used by [CAs](https://www.digicert.com/docs/cps/DigiCert_CPS_v410-Sept-12-2016-signed.pdf) and [DNS TLDs](https://www.iana.org/dnssec/ceremonies) are just that; unfeasible for a small federation. So we were looking for the middle ground.

Key generation was done at a ceremony at TENET’s Wynberg offices in the presence of a community observer from the [University of Cape Town](http://www.uct.ac.za/). The observer's role was largely to keep us honest and ensure we didn't take any shortcuts.

### Key generation

The signing keys were generated in hardware by one of the NitroKey HSMs we'd bought. On-board key generation takes advantage of the built-in [TRNG](https://en.wikipedia.org/wiki/Hardware_random_number_generator), and limits exposure of the key material.

To further limit exposure, during the ceremony this was plugged into an offline, [air-gapped ](https://en.wikipedia.org/wiki/Air_gap_(networking))computer booted using an [Ubuntu 16.0.1 LTS](https://wiki.ubuntu.com/XenialXerus/ReleaseNotes) live DVD. All drivers and other packages were [stock Ubuntu packages](http://packages.ubuntu.com/xenial/amd64/) and were verified against the publisher’s checksums before being installed in the clean environment. All writable media used for this exercise was kept in sealed original packaging until shortly before it was needed and unsealed media was not left unattended prior to the completion of the exercise.

We have some [prep notes from the SAFIRE metadata signing key generation ceremony](/wp-content/uploads/2017/02/NitrokeyHSMPrepNotes.pdf) that might help. The process for [initialising the HSM](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#initialize-the-device), changing the SO and user PINS,  [generating key pairs](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#generate-key-pair) and [generating and importing corresponding certificates](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#generate-a-key-pair-and-a-self-signed-certificate) is also reasonably well documented by OpenSC. Doing so required the following additional drivers and packages be installed into the Ubuntu live DVD environment: [libccid, ](http://packages.ubuntu.com/xenial/amd64/libccid)[libengine-pkcs11-openssl](http://packages.ubuntu.com/xenial/amd64/libengine-pkcs11-openssl), [opensc, ](http://packages.ubuntu.com/xenial/amd64/opensc)[opensc-pkcs11](http://packages.ubuntu.com/xenial/amd64/opensc-pkcs11), [apg](http://packages.ubuntu.com/xenial/amd64/apg). 

In total we generated four keys: two 2048-bit RSA keys, and two 256-bit ECC keys. Only one of these keys is actually in use --- the first RSA key. The remaining keys are generated "just in case" we ever need an additional key or find a compelling reason to change from RSA to elliptic curve.

All needed passphrases/PINs were also randomly generated in the clean environment, either as direct random bytes (for the SO pin) or [using APG](https://help.ubuntu.com/community/StrongPasswords).

### Key backup/duplication

Whilst still offline, the newly generated keys were replicated using the smartcard HSM’s [DKEK encrypted backup and restore mechanism](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#user-content-using-key-backup-and-restore), creating copies of each of the four keys on three separate HSMs. One of these HSMs is currently used to perform metadata signings, while the remaining two provide cold backups in the event of technology failures.

The smartcard HSM allows for multiple DKEK shares in an [n-of-m scheme](https://github.com/OpenSC/OpenSC/wiki/SmartCardHSM#user-content-using-a-n-of-m-threshold-scheme). This would allow multiple custodians to each hold part of the key and require that they get together to recombine them. However, given SAFIRE's small staff and the limitations on our ability to actually store them securely, this seemed overly onerous and may create a false sense of security. So we elected to generate a single DKEK share. Per the recommended procedure, both an electronic copy (on a USB flash stick) and a paper copy (Base64 encoded) were kept to facilitate future backups.

At the completion of the exercise, the spare HSMs and backups of the DKEK share were placed into sealed, tamper evident envelopes and deposited into separate safes. The keys for these safes are under the control of different people.

### Other keys

Finally, new SAML signing keys were generated for both our [federation hub]({{< ref "/safire/news/iziko-safire-ac-za.md" >}}) and the[ identity provider proxies]({{< ref "/safire/news/idp-proxies-20161205.md" >}}). These are not stored on the HSM, but took advantage of the clean environment we had set up to ensure that unencrypted private key material was never exposed to the Internet.

# Integrating the HSM

Having a signing key on an HSM is all very well, but we need to be able to automatically sign metadata aggregates using our metadata aggregator. This means that the HSM needs to be integrated.

### Physically securing the in-use HSM

We've seen reports of operators storing USB HSMs in safes. We decided this probably created a false sense of security, and so opted for what we considered a reasonable compromise.

Our USB HSM is connected to the internal USB port within the chassis of a Dell server (these ports are usually intended for boot media in SAN-connected servers). This effectively puts the HSM within a Faraday cage and also means it's not easily physically accessible (reducing the risk it will be removed by accident, etc). The server is configured to log chassis intrusion, providing some measure of an audit trail.

The server itself is located within a rack that is housed in a dedicated secure cage in a commercial data centre. Physical access to the cage is biometrically controlled and limited to TENET staff, and access to the data centre environment is controlled by data centre operator who does in-person identity verification before granting access.

The above all means it is possible for TENET staff unrelated to the SAFIRE project to access the HSM, but it is difficult for them to do so unnoticed and there's a third-party audit trail in the form of data centre access control logs.

### Connecting the HSM

We make use of VMware and our metadata aggregator is a dedicated virtual machine within this environment. To connect the HSM to this virtual machine, we make use of [USB pass-through](https://kb.vmware.com/kb/1022290) within VMware. Access to the physical USB device is limited to a single virtual machine, and this is enforced by VMware.

This means that it's possible for someone with access to the VMware console to redirect the HSM to another virtual machine --- but because of the way it integrates with our aggregator, it is difficult to do this (even temporarily) in a way that would go unnoticed/unlogged. Moreover, access to the VMware console is limited on a need-to-have basis.

We've thought of using a Raspberry Pi to create a dedicated networked version of the HSM to overcome this --- and may do this if it becomes necessary. However, that introduces different complications.

### Making the HSM available to the aggregator

We make use of WAYF's [PHPH](https://github.com/wayf-dk/phph) as our [metadata aggregator](https://phph.safire.ac.za/). Unfortunately this (or more accurately, the underlying XMLSec libraries and indeed PHP itself) does not have support for PKCS#11. This means we need a shim to allow the aggregator access to the HSM.

This is not an uncommon problem, and software exists to solve it. One example is [pyeleven](https://github.com/leifj/pyeleven), which provides a REST API. WAYF have a similar and largely compatible API written in Go, which they call [goeleven](https://github.com/wayf-dk/goeleven/).

Because PHPH already had support for HSMs via goeleven, it was natural that we used this. It turned out that some [minor patches](https://github.com/safire-ac-za/goeleven/commit/395e4309493e1162d0e4d30256fd0714b1f64638) were required to support the Nitrokey HSM, largely to work around OpenSC's [virtual slot mechanism](https://github.com/OpenSC/OpenSC/wiki/PKCS11-Module#user-content-virtual-slots) in their PKCS#11 module.

Although we don't use it, pyeleven was written to integrate PKCS#11 with [pyFF](https://github.com/leifj/pyFF) and so this mechanism will almost certainly work for other aggregator software too.

### Signing metadata

Our aggregator is configured to periodically regenerate and re-sign metadata, both to ensure it is up-to-date and to ensure it doesn't go stale/expire. This needs to happen in an automated, unattended way which means the HSM needs to be online and available.

To create some degree of privilege separation, the process that generates metadata runs as a different user to the goeleven shim. This means that the aggregator has no access to goeleven's configuration, and does not have access to the user PIN for the HSM.

The aggregator process also runs as a different user to the web-front end, meaning that the web server that's serving signed metadata has access to neither the aggregator's configuration nor goeleven's.

As a block diagram, it looks something like this:

[{{< figure src="/wp-content/uploads/2017/02/Nitrokey-HSM-Block-Diagram.svg" caption="Nitrokey HSM Block Diagram" >}}](/wp-content/uploads/2017/02/Nitrokey-HSM-Block-Diagram.svg)

which looks remarkably like an [onion](https://simple.wikipedia.org/wiki/Defense_in_depth_(computing))…

### Unexpected benefits of the shim

goeleven (and pyeleven) exists as a long-lived daemon. One advantage of this is that there's an always-open session to the HSM. Since the Nitrokey HSM only supports one session, this effectively makes it unavailable to any other process or user.

The goeleven process is [monitored](https://monitor.safire.ac.za/safire/thruk/cgi-bin/extinfo.cgi?type=2&host=md-cpt-01.safire.ac.za&service=HSM) by our network monitoring system. The monitoring system initiates regular test signings, and so would quickly pick up a missing/unavailable HSM --- the timing of which could then be compared against other logs, such as the data centre provider's access logs.

Both goeleven and pyeleven expose their API over HTTP. This means we could make use of tools like [haproxy](http://www.haproxy.org/) to load-balance between multiple smartcard-based HSMs either for DR/redundancy reasons, or to better handle the load of MDQ signing.

# Possible Improvements

That our HSM is housed within a server and connected via USB pass-through raises two concerns: that it's available (albeit with the caveats above) to host that on the public Internet; and that the VMware server is not necessarily dedicated to the federation. USB pass-through also limits our ability to use VMware's high availability features.

One possible solution to this is to create a dedicated network-attached HSM. We could do this by plugging the Nitrokey HSM into a [Raspberry Pi](https://www.raspberrypi.org/) or equivalent. This would run a minimal distribution, and would only accept [HTTPS connections](https://www.iab.org/2014/11/14/iab-statement-on-internet-confidentiality/) to the goeleven (or pyeleven) REST API. It could also run on a dedicated network with no access to the public Internet and no default route --- effectively a point-to-point connection to the metadata aggregation server.

If the network were properly designed, it would mean that all VMware host servers in a high-availability cluster would have access to it, and consequently vMotion migrations, etc would not be a problem. This design would also mean that there was no [spinning rust](http://etherealmind.com/network-dictionary-spinning-rust/) or other moving parts within the "HSM" system, greatly improving its theoretical [MTBF](https://en.wikipedia.org/wiki/Mean_time_between_failures).

The problem with this approach is that a Raspberry Pi has more geek-attractiveness and is easier to pocket and smuggle out of a data centre than a 2U rack-mounted server. So we'd need to revisit the physical security considerations. Which brings us back to the idea of housing the HSM in a safe with a hole drilled in it for cabling. Not sure what our hosting providers will think of that…

# Conclusion

Until MDQ is widely adopted and becomes a necessity, smartcard-based HSMs provide an affordable means for emergent federations to protect metadata signing keys. It's also possible to find compromises that address the most likely risk scenarios associated with these devices without getting impractical.

The Nitrokey HSM has been tested and works well under Ubuntu Linux. It exposes a PCKS#11 interface that is compatible with a variety of software, and shims exist to extend this compatibility.

Like most of SAFIRE's documents, this post is made available under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
