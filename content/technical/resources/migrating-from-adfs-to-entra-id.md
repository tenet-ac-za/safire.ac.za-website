---
date: 2025-07-15 11:55:00+02:00
slug: migrating-from-adfs-to-entra-id
tags:
  - azure
  - configuration
  - metadata
  - technical
title: Migrating a SAFIRE IdP from ADFS to Microsoft Entra ID
---
Microsoft [does not recommend deploying new instances of AD FS](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview). Instead, they encourage you to consider Entra ID (formerly Azure AD). This raises a common question: can you migrate an existing SAFIRE identity provider from AD FS to Entra ID?

Unfortunately, the answer is not straightforward. This document outlines the main challenges, along with some approaches you might consider.

## No direct migration path

In Entra ID, SAML identity providers are configured as "Enterprise Applications". However, the cloud SAML provider does not offer feature parity with AD FS and has some fundamental limitations. We've [previously documented]({{< ref "configuring-azure-ad-for-safire.md" >}}) how to integrate Entra ID with SAFIRE for a *new* identity provider and highlighted some of the caveats.

If you're migrating an *existing* identity provider, the challenge is even greater: you have existing users, some of whom may already have user profiles at one or more service providers.

This becomes a problem because user identifiers --- such as `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`, [eduPersonTargetedID]({{< ref "/technical/attributes/edupersontargetedid.md" >}}), or [pairwise-id]({{< ref "/technical/attributes/pairwise-id.md" >}}) --- are often generated based on your identity provider's entity ID. If the entity ID changes, **so do the user identifiers**. That means all users **will appear as new users** to service providers.

If you have many users accessing multiple services, this can cause significant disruption. In the best case, users might need to reconfigure their preferences; in the worst case, they could lose access entirely and be forced to reapply.

Unfortunately, Microsoft does not allow you to preserve an existing entity ID when creating a new Enterprise Application --- a new, machine-generated entity ID is always used. So, you cannot simply replace AD FS with Entra ID as a "drop-in" migration.

#### Option 1: Accept the churn

One approach is to accept that user profiles will break and plan for the fallout. This may be viable if:
  - You have few users;
  - Your IdP has been largely inactive; or
  - You're prepared to handle the support burden of a disruptive change.

If you go this route, carefully assess the impact. For example, whether key users will lose access to critical services. If possible, run both IdPs in parallel for a period. Some services may allow users to re-link their accounts if they can still log in with the old identity.

#### Option 2: Preserve the entity ID with a proxy

The less disruptive approach is to preserve your entity ID. While this can't be done natively in Entra ID, it's possible via a proxy. Two commonly used proxies are:
  - [SimpleSAMLphp](https://simplesamlphp.org/), which offers flexibility and can address some attribute release issues.
  - [SATOSA](https://github.com/IdentityPython/SATOSA), which is lightweight and easy to deploy in cloud or on-prem environments.

Ironically, this can also be done using [AD FS itself](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-fed-whatis).

We've published [guidance on using SimpleSAMLphp with Entra ID]({{< ref "configuring-simplesamlphp-to-use-azure.md" >}}). SAFIRE-specific SATOSA documentation is in development, but general SATOSA documentation is widely available.

> In future, SAFIRE may offer a hosted (SaaS) option to assist with this.
{.message-box}

## Limited attribute (claim) support

Another migration issue is that you might not be able to replicate your current attribute release policy. Entra ID has a less flexible claims language than AD FS and does not natively support multi-valued custom attributes. This particularly affects attributes like [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}), [eduPersonEntitlement]({{< ref "/technical/attributes/edupersonentitlement.md" >}}), and [eduPersonAssurance]({{< ref "/technical/attributes/edupersonassurance.md" >}}), which are all multi-valued by definition.

#### Option 1: Revisit your attribute release

With some effort, you can use Entra ID's claim rules to reproduce most attributes that are based purely on information already present in your directory. SAFIRE supports this by offering a [namespace workaround]({{< ref "/namespace/claims.md" >}}) for multi-valued attributes.

Because each organisation approaches this differently, there's no simple, one-size-fits-all guide. However, we include some suggestions in our [existing Entra ID documentation]({{< ref "configuring-simplesamlphp-to-use-azure.md" >}}) and on the attribute-specific pages ([eduPerson{Scoped}Affiliation]({{< ref "generating-edupersonaffiliation.md" >}}), [eduPersonEntitlement]({{< ref "generating-edupersonentitlement.md" >}})). We're also happy to provide advice where we can.

#### Option 2: Supplement your attribute release

If your business logic is too complex for Entra ID's native claims, or if it depends on multiple data sources, you can reproduce it using a proxy (which is particularly useful if you're already using one to preserve the entity ID). Our [SimpleSAMLphp documentation]({{< ref "configuring-simplesamlphp-to-use-azure.md" >}}) explains how to perform LDAP queries against an on-prem AD. You can also use other [authproc filters](https://simplesamlphp.org/docs/stable/simplesamlphp-authproc.html) to populate attributes from other sources.

> Note: If SAFIRE provides a SaaS proxy in future, it will not support custom business logic.
{.message-box .warning}

## subject-id changes

If you have used the [`objectGUID`](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-ada3/937eb5c6-f6b3-4652-a276-5d6bb8979658) directory attribute as a source attribute for generating the scoped SAML [`subject-id`]({{< ref "/technical/attributes/subject-id.md" >}}) attribute, you should be aware that `objectGUID` is **not** the same attribute as the EntraID `user.objectidentifer` attribute (available as the `http://schemas.microsoft.com/identity/claims/objectidentifier` claim).

The original on-prem `objectGUID` is [usually available](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/plan-connect-design-concepts#sourceanchor) as `user.onpremisesimmutableid`, albeit as a base64 encoded binary representation of the GUID. That means it is *in theory* possible to preserve a `subject-id` generated from an on-prem `objectGUID`. However, we're not aware of a claim transformation that will let you convert the base64 representation to the same string representation you may be using in AD FS.

For this reason, and given that `subject-id` was [introduced as a supported attribute]({{< ref "/safire/news/20250901-baseline-changes.md" >}}) long after the deprecation of AD FS, we would **strongly recommend** deferring the introduction of `subject-id` until after your Entra ID migration.

## No automated metadata refresh

Entra ID currently does not support dynamically refreshing remote metadata from a URL. This means there's no way to automatically track or incorporate updates to SAFIRE's metadata. While this would be a significant problem for service providers, in practice, metadata changes that affect identity providers are infrequent.

The [IdP Requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) place the responsibility on you to keep your metadata up to date and expect this to be an automated process. For this reason, Entra ID cannot be considered fully supported within SAFIRE.

That said, SAFIRE's metadata is stable enough that this limitation is generally considered manageable, provided you put a manual process in place to periodically check for updates and re-upload or merge any changes as needed.

## Benefits of a migration

While we've documented the major pitfalls above, there are also some clear benefits to switching from AD FS to Entra ID. The two most important are:

### Built-in MFA & FIDO2 support

A major benefit of switching to Entra ID is built-in multi-factor authentication. SAFIRE's federation hub includes [translation support]({{< ref "/safire/news/20220111-refeds-mfa-support.md" >}}) for the [REFEDS MFA profile](https://refeds.org/profile/mfa), allowing you to assert compliance easily. All you need to do is let us know you've enabled MFA and would like the quirk turned on for your identity provider.

Entra ID also [supports FIDO2/WebAuthn (Passkeys)](https://learn.microsoft.com/en-us/entra/identity/authentication/how-to-enable-passkey-fido2) and integrates with Windows Hello, offering stronger authentication options by default.

While it is possible to support both of these in AD FS, doing so typically requires paid-for extensions or third-party plugins.

### Consistent branding and user experience

If your institution already uses Entra ID widely, switching your SAFIRE identity provider to it can offer a more consistent login experience. One of the key benefits of federated SSO is centralising where users log in. Maintaining multiple environments (like AD FS and Entra ID) fragments that experience and increases the risk of user confusion -- and, by extension, phishing and other cybersecurity attacks.

This consistency is preserved even when using a proxy. In most cases (except during errors), users are transparently redirected through the proxy without seeing its interface.

