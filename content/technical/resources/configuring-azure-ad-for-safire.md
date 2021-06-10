---
date: 2021-05-31 14:40:00+02:00
slug: configuring-azure-ad-for-safire
tags:
  - azure
  - configuration
  - metadata
  - technical
draft: true
title: Configuring Azure AD SAML-based SSO for SAFIRE
url: /technical/resources/configuring-azure-ad-for-safire/
aliases:
  - /technical/resources/configure-azure-ad-for-safire/
---

> The recommended way to integrate Azure AD into SAFIRE is via a [SAML Proxy such as Shibboleth](https://wiki.shibboleth.net/confluence/display/KB/Using+SAML+Proxying+in+the+Shibboleth+IdP+to+connect+with+Azure+AD). While it is possible to connect Azure AD directly into SAFIRE, this has several caveats and cannot be guaranteed as a long-term solution.

This documentation assumes that you already have an Azure Active Directory (Azure AD) tenant correctly configured and provisioned with your institution's user accounts.

To configure Azure AD as an identity provider for SAFIRE, you need to configure [SAML-based SSO](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-saml-single-sign-on). This requires you to do three things:

 1. Create your own, new *Enterprise Application*
 2. Set up single sign-on
 3. Configure Attribute claims rules

## 1. Create your own new Enterprise Application

In identity federation terminology, Identity Providers take on SAFIRE's metadata and configure SAFIRE as a 'Service Provider'. In Azure AD, however, you need to change your thinking slightly, in that you need to think of SAFIRE as an *Enterprise application* that you need to create.

You will need to create your own new *Enterprise Application* in your organisation's Azure Active Directory Service. You can do so by adding a *New application* and *Create your own application* under the *'Enterprise Applications'* Management item.

You can name the application whatever makes sense to you, but in this document, we have named our new application "SAFIRE - South African Identity Federation". This application is integrating with other applications that are not in the Azure Application gallery.

## 2. Set up single sign-on

Now that you have created your own application, you need to enable *SAML* based single sign-on and *Upload* SAFIRE's [Federation Hub metadata]({{< ref "/technical/metadata.md#safire-federation-hub" >}}) *file*. Azure's metadata Upload utility should pre-populate the *Basic SAML Configuration* from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the information was imported properly by the Upload utility.

**NOTE:** SAFIRE's metadata changes periodically and the [IdP Requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) puts **the onus on you to keep this up-to-date**. Unfortunately, Azure AD cannot do this automatically, and so you will make these changes manually.

## 3. Configure Attribute claims rules

You now need to configure your application's *User Attributes & Claims*. Azure sets up a few default User Attributes & Claims rules. Still, you need to ensure these release the [Minimum attributes required for participation]({{< ref "/technical/attributes/_index.md" >}}) for SAFIRE by altering what has been pre-defined, or *Add new claim*, depending on what attributes correspond to the attributes required for participation.

e.g.

| *Claim name* | *Value* |
|----------|----------|
| http\://schemas.xmlsoap.org/claims/CommonName  | user.displayname |
| http\://schemas.xmlsoap.org/claims/UPN  | user.userprincipalname  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress | user.mail  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname | user.givenname  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname | user.surname |

##### eduPersonPrincipalName

It is recommended that you map the 'user.userprincipalname' to an attribute that is scoped to a realm you are eligible to use. UPN serves this purpose in most cases and provides [eduPersonPrincipalName](({{< ref "/technical/attributes/edupersonprincipalname.md" >}})) with a 'Single valued, scoped to home organisation' value (see link for more details). It is, however, up to you to determine which attribute in your Azure AD best meets the required definition.

##### eduPersonScopedAffiliation

Per the definition of [eduPersonScopedAffiliation](({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}})), You will need to use what user attributes you have in your Azure AD to create a *transform* rule, to assert a users role at your institution correctly.

e.g. Pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'member@example.ac.za'

```

**NOTE:**  eduPersonScopedAffiliation, is a scoped copy of [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}})'s format rules, and importantly, where an affiliation value says "implies…" the implied values must also be included in the returned set. This, however, is not possible in Azure, as Azure does not currently support multi-valued attributes.

To solve this problem, you will need to (re-)configure the Attribute claims *transform* rule for eduPersonScopedAffiliation to release an attribute *Named* "scopedAffiliationSingleton" in SAFIRE's custom *Namespace* of **https\://safire.ac.za/namespace/claims** with attribute values that are separated by a space, and meet the format rules described in eduPersonAffiliation, scoped to your realm. If your Azure IdP asserts scopedAffiliationSingleton correctly, SAFIRE will reformat it into a multi-valued eduPersonScopedAffiliation attribute for you.

e.g. Pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'staff@example.ac.za member@example.ac.za employee@example.ac.za'

```

**OR**

```lang-none

IF 'user.extensionattribute4' CONTAINS 'student' THEN
  OUTPUT 'student@example.ac.za member@example.ac.za'

```

If you do not have a single attribute to use as in the above examples and you distinguish users based on group membership, you can look at creating Claim conditions Transformations.

e.g.

| *User type* | *Scoped Groups* | *Source* | *Value* |
|----------|----------|----------|----------|
| Members | *Select groups e.g. students* | Transformation | IF 'user.userprincipalname' NOT EMPTY THEN OUTPUT 'student@example.ac.za member@example.ac.za' |
| **OR**|
| Members | *Select groups e.g. alumni* | Transformation | IF 'user.userprincipalname' NOT EMPTY THEN OUTPUT 'alum@example.ac.za' |

##### eduPersonAffiliation

eduPersonAffiliation has the same semantics as eduPersonScopedAffiliation, but lacks the scope (the `@` sign and what follows, e.g. `@example.ac.za`). Thus you can re-used the claim rules you created for eduPersonScopedAffiliation to generate eduPersonAffiliation as well, and simply omit your scope from the attribute you output.

e.g. Pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'staff member employee'

```

As with eduPersonScopedAffiliation, you can work around Azure's multivalued attribute problem, you can release eduPersonAffiliation as an attribute named "unscopedAffiliationSingleton" in SAFIRE's https\://safire.ac.za/namespace/claims namespace.

#### Other attributes

What's shown here is only a subset of SAFIRE's [attribute set]({{< ref "/technical/attributes/_index.md" >}}. You're strongly encouraged to release others where you have the data available.
