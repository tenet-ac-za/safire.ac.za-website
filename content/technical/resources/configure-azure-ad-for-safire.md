---
date: 2021-05-31 14:40:00+02:00
slug: configure-azure-ad-for-safire
tags:
  - azure
  - configuration
  - metadata
  - technical
draft: true
title: Configuring an Azure AD Application for SAFIRE
url: /technical/resources/configure-azure-ad-for-safire/
---

This documentation assumes that you already have an Azure Active Directory configured and provisioned with your institution's user accounts

To configure Azure Active Directory as an identity provider for SAFIRE, you need to do 3 things:

1.) Create your own, new *Enterprise Application*\
2.) Set up single sign-on\
3.) Configure Attribute claims rules

## Create your own new Enterprise Application

In Federation terms, Identity Providers take on SAFIRE's metadata and configure SAFIRE as a 'Service Provider'. In Azure Active Directory, however, you need to change your thinking slightly, in that you need to think of SAFIRE as an *Enterprise application* that you need to create.

You will need to create your own new Enterprise Application in your organisation's Azure Active Directory role. You can do so by adding a *New application* and *Create your own application* under the 'Enterprise Applications' Management item.

You can name the application whatever makes sense to you, but in this document, we have named our new application "SAFIRE - South African Identity Federation". This application is integrating with other applications that are not in the Azure Application gallery.

## Set up single sign-on

Now that you have created your own application, you need to enable *SAML* based single sign-on and *Upload* SAFIRE's [Federation Hub metadata](https://metadata.safire.ac.za/) *file*. Azure's metadata Upload utility should pre-populate the *Basic SAML Configuration* from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the information was imported properly by the Upload utility.

## Configure Attribute claims rules

You now need to configure your application's *User Attributes & Claims*. Azure sets up a few default User Attributes & Claims rules, but we need to ensure these release the [Minimum attributes required for participation](https://safire.ac.za/technical/attributes/) for SAFIRE, by altering what has been pre-defined, or *Add new claim* 

On each of the *Additional Claims*, you will need to ensure the *Name* matches the OID for the corresponding attribute you will find at SAFIRE's Minimum attributes required for participation link above. 

e.g.: 

emailaddress changes to urn:oid:0.9.2342.19200300.100.1.3

*NOTE:* Azure defaults to using the identity Claims *Namespace* URI's, and SAFIRE uses SAML urn assertions. Thus you do not need to specify a Namespace for any of the asserted Additional Claims.

##### eduPersonPrincipalName

It is recommended that you use the 'user.userprincipalname' attribute, as this meets the required attribute definition of 'Single valued, scoped to home organisation' (see above link for more details).

##### eduPersonScopedAffiliation

Per the definition of eduPersonScopedAffiliation, You will need to use what user attributes you have in your Azure AD to create a transform rule, to assert a users role at your institution correctly.

eg. If 'user.extensionattribute1' contains 'staff' then output 'staff@example.ac.za'.

*NOTE:* eduPersonScopedAffiliation, is a scoped copy of [eduPersonAffiliation](https://safire.ac.za/technical/attributes/edupersonaffiliation/)'s format rules, and importantly, where an affiliation value says "implies…" the implied values must also be included in the returned set; This, however, is not currently possible in Azure, as Azure does not support multi-valued attributes, and therefore does not fully meet the requirements for the [Research and Scholarship entity category](https://safire.ac.za/safire/policy/arp/#research--scholarship). Given this is a limitation on the Software provider side, and to maintain SAFIRE's commitment to minimising the barrier to entry, asserting a single valued eduPersonScopedAffiliation will be acceptable for now e.g. 'staff@example.ac.za'.

SAFIRE are currently working on a workaround to this, and will contact affected Identity Providers with a solution soon.

