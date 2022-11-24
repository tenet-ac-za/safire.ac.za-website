---
date: 2022-11-24T15:25+02:00
slug: certificate-key-roll-over
tags:
  - configuration
  - metadata
  - technical
title: Performing a SAML certificate or key roll-over
url: /technical/resources/certificate-key-roll-over/
---

This document outlines a process for rolling over (changing) your SAML signing certificate and the associated private key.

> **NB!** You should be aware that this process is **NOT** instantaneous, and requires proper planning to ensure your users can continue using your provider without incident. Therefore, you need to begin the process well before the expiry of your existing SAML signing certificate (plan for at least a week). If you let your certificate expire, your users may not be able to log in, and it will take some time to recover from this.

## 1. Create the new key and certificate

The very first thing you need to do is generate a new certificate and private key. How you do this may depend on the software you use. However, you can see our [documentation on generating certificates]({{< relref "generating-certificates-for-safire.md" >}}) for further information.

## 2. Update your metadata

Once you've generated a new certificate, you should add it to your metadata. Do *NOT* remove the old certificate, and do *NOT* start signing requests with the new private key.

The intent of this step is to pre-publish your certificate so that any existing relying parties that consume your metadata learn about the new certificate *BEFORE* you start using it. If your software is not capable of such pre-publication, do not add the certificate. Instead find another way to distribute it to your relying parties.

## 3. Send the new certificate to SAFIRE

In common with other academic federations, SAFIRE does not learn about certificate changes automatically. Instead you need to [contact us]({{< ref "/safire/contact/_index.md" >}}) and [request a change]({{< ref "/technical/saml2/forms/_index.md" >}}) to the metadata SAFIRE has recorded in its registry. Make sure you include a copy of your new certificate in your request.

If you have other relying parties that, like SAFIRE, do not learn of changes automatically you should update those parties too.

## 4. Wait for metadata to propogage

You now need to wait for all relying parties (including SAFIRE) to learn of the change. SAML metadata typically doesn't propogate immediately. It is common for relying parties to only check for new metadata periodically, and you need to make sure that all parties have had a chance to fetch your new metadata.

If your only relying party is SAFIRE, we would recommend waiting at least two days after you've had confirmation from us that your new certificate has been committed.

If you have other relying parties that consume metadata directly, you may need to wait longer. In the worst case, look at the validity period for your metadata and wait at least that long before continuing (it can be several days, perhaps even weeks).

## 5. Start using the new certificate and key

Once you're sure that *ALL* relying parties have learnt of the change, you should configure your provider to use the new certificate and private key.

**This is the point at which a service-affecting change occurs.** However, if you've performed the above steps correctly and timeously, the change should be fairly atomic and your end-users should not be aware that it has occured.

## 6. Remove the old certificate from your metadata

After you've switched over the private key you use for signing, and you're sure things are working properly, you can safely remove the old certificate from your metadata.

## 7. Tell SAFIRE to remove the old certificate

If you've not pre-scheduled it with the SAFIRE operations team, you need to [contact us]({{< ref "/safire/contact/_index.md" >}}) and let us know the process is complete. You should do this on the same ticket as the original request (please preserve the subject).
