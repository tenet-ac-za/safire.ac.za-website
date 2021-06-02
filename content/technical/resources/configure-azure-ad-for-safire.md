---
date: 2021-05-31 14:40:00+02:00
slug: configure-azure-ad-for-safire
tags:
  - azure
  - configuration
  - metadata
  - technical
draft: true
title: Configuring Azure AD SAML-based SSO for SAFIRE
url: /technical/resources/configure-azure-ad-for-safire/
---

> The recommended way to integrate Azure AD into SAFIRE is via a [SAML Proxy such as Shibboleth](https://wiki.shibboleth.net/confluence/display/KB/Using+SAML+Proxying+in+the+Shibboleth+IdP+to+connect+with+Azure+AD). While it is possible to connect Azure AD directly into SAFIRE, this has a number of caveats and cannot be guarenteed as a long-term solution.

This documentation assumes that you already have an Azure Active Directory (Azure AD) tenant that is correctly configured and provisioned with your institution's user accounts.

To configure Azure AD as an identity provider for SAFIRE, you need to configure [SAML-based SSO](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-saml-single-sign-on). This requires yout to do three things:

 1. Create your own, new *Enterprise Application*
 2. Set up single sign-on
 3. Configure Attribute claims rules

## 1. Create your own new Enterprise Application

In identity federation terminology, Identity Providers take on SAFIRE's metadata and configure SAFIRE as a 'Service Provider'. In Azure AD, however, you need to change your thinking slightly, in that you need to think of SAFIRE as an *Enterprise application* that you need to create.

You will need to create your own new Enterprise Application in your organisation's Azure Active Directory role. You can do so by adding a *New application* and *Create your own application* under the 'Enterprise Applications' Management item.

You can name the application whatever makes sense to you, but in this document, we have named our new application "SAFIRE - South African Identity Federation". This application is integrating with other applications that are not in the Azure Application gallery.

## 2. Set up single sign-on

Now that you have created your own application, you need to enable *SAML* based single sign-on and *Upload* SAFIRE's [Federation Hub metadata]({{< ref "/technical/metadata.md#safire-federation-hub" >}}) *file*. Azure's metadata Upload utility should pre-populate the *Basic SAML Configuration* from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the information was imported properly by the Upload utility.

**NOTE:** SAFIRE's metadata changes periodically and the [IdP Requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) put **the onus on you to keep this up-to-date**. Unfortunately Azure AD cannot do this automatically, and so you will make these changes manually.

## 3. Configure Attribute claims rules

You now need to configure your application's *User Attributes & Claims*. Azure sets up a few default User Attributes & Claims rules, but we need to ensure these release the [Minimum attributes required for participation]({{< ref "/technical/attributes/_index.md" >}}) for SAFIRE, by altering what has been pre-defined, or *Add new claim*.

On each of the *Additional Claims*, you will need to ensure the *Name* matches the OID for the corresponding attribute you will find at SAFIRE's Minimum attributes required for participation link above.

e.g.:

emailaddress = mail = urn:oid:0.9.2342.19200300.100.1.3

**NOTE:** Azure defaults to using the identity Claims *Namespace* URI's, and SAFIRE uses SAML urn assertions. Thus you do not need to specify a Namespace for any of the asserted Additional Claims.

##### eduPersonPrincipalName

It is recommended that you use the 'user.userprincipalname' attribute, as this meets the required [eduPersonPrincipalName attribute definition](({{< ref "/technical/attributes/edupersonprincipalname.md" >}})) of 'Single valued, scoped to home organisation' (see above link for more details). However, not

##### eduPersonScopedAffiliation

Per the definition of [eduPersonScopedAffiliation](({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}})), You will need to use what user attributes you have in your Azure AD to create a transform rule, to assert a users role at your institution correctly.

eg. If 'user.extensionattribute1' contains 'staff' then output 'staff@example.ac.za'.

*NOTE:* eduPersonScopedAffiliation, is a scoped copy of [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}})'s format rules, and importantly, where an affiliation value says "implies…" the implied values must also be included in the returned set; This, however, is not  possible in Azure, as Azure does not currently support multi-valued attributes. As a result, the *only* permissible value for eduPersonScopedAffiliation with a single-valued attribute is `member@example.ac.za`.

While meets the minimum requirements for participation, it does not allow for enriched uses of the affiliation attributes as envisioned by the [Research and Scholarship entity category]({{< ref "/safire/policy/arp/_index.md#research--scholarship" >}})) and as used by many [library information providers]({{< ref "/technical/resources/library-services.md" >}}).
