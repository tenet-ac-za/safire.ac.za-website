---
date: 2024-06-10 11:22:00+02:00
slug: configuring-microsoft-entra-id-for-safire
tags:
  - azure
  - configuration
  - metadata
  - technical
title: Configuring Microsoft Entra ID (Azure) SAML-based SSO for SAFIRE
url: /technical/resources/configuring-microsoft-entra-id-for-safire/
aliases:
  - /technical/resources/configure-azure-ad-for-safire/
  - /technical/resources/configuring-azure-ad-for-safire/
---

> [Microsoft recommends](https://learn.microsoft.com/en-us/entra/architecture/multilateral-federation-introduction) integrating Entra ID into SAFIRE via a [SAML Proxy such as Shibboleth](https://wiki.shibboleth.net/confluence/display/KB/Using+SAML+Proxying+in+the+Shibboleth+IdP+to+connect+with+Azure+AD), which mirror's the R&E federation communty's guidence. While it is possible to connect Microsoft Entra ID directly into SAFIRE, this has several caveats and cannot be guaranteed as a long-term solution.
{.message-box .warning}

This documentation assumes that you already have an Microsoft Entra ID tenant correctly configured and provisioned with your institution's user accounts.

To configure Microsoft Entra ID as an identity provider for SAFIRE, you need to configure [SAML-based SSO](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-saml-single-sign-on). Doing so requires you do three things:

 1. Create a new *Enterprise Application*
 2. Set up single sign-on
 3. Configure Attribute claims rules

# 1. Create an Enterprise Application

In identity federation terminology, Identity Providers take on SAFIRE's metadata and configure SAFIRE as a service provider. In Microsoft Entra ID, however, you need to change your thinking slightly, in that you need to think of SAFIRE as an *Enterprise application* that you need to create.

You will need to create a new *Enterprise Application* in your organisation's Microsoft Entra ID Service. You can do so by adding a *New application* and then *Create your own application* under the *Enterprise Applications* Management item.

You can name the application whatever makes sense to you and your users. Your new SAFIRE application is integrating with other applications that are not in the Microsoft Entra Application gallery.

# 2. Set up single sign-on

Now that you have created your application, you need to enable *SAML* based single sign-on and *Upload* SAFIRE's [Federation Hub metadata]({{< ref "/technical/metadata.md#safire-federation-hub" >}}) *file*. Microsoft Entra ID's metadata Upload utility should pre-populate the *Basic SAML Configuration* from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the information was correctly imported by the Upload utility and that you understand what each of the fields is doing.

> TIP Your Enterprise application can use a [long-lived certificate]({{< ref "/technical/resources/generating-certificates-for-safire.md" >}}) if you *import* your own long-lived certificate into the *SAML Certificates* section of your *Enterprise Application.*
{.message-box}

> SAFIRE's metadata changes periodically, and can do so without warning. The [IdP Requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) put **the onus on you to keep this up-to-date** and expects this process to be automated. Unfortunately Microsoft Entra ID cannot currently update metadata automatically which is partly why it remains only partially supported in SAFIRE. However, SAFIRE's metadata is stable enough that you can probably get away with this if you create a manual process to periodically ensure you re-upload the metadata or merge any changes.
{.message-box}

> Entra ID generates an entity ID for your application using the well-known format *https://sts.windows.net/your-enterprise-application-id/*, and this **cannot be changed**. The entity ID uniquely identifies your provider to other service providers, and changing the entity ID can break existing trust relationships (for example [eduPersonTargetId]({{< ref "/technical/attributes/edupersontargetedid.md" >}}) will change, potentially unlinking user accounts). This limitation means you cannot migrate between a directly-integrated Entra ID identity provider and any other software (e.g. on-prem AD FS). This is one of the main reasons a [proxy is recommended](https://learn.microsoft.com/en-us/entra/architecture/multilateral-federation-introduction).
{.message-box .warning}


# 3. Configure Attribute claims rules

You now need to configure your application's *User Attributes & Claims*. Entra ID sets up a few default User Attributes & Claims rules. However, you need to ensure these release the at least the [Minimum attributes required for participation]({{< ref "/technical/attributes/_index.md" >}}) for SAFIRE. This requires altering what has been pre-defined or *Add new claim*. Depending on your exact use case, you may also need to release some additional attributes.

e.g.

| *Claim name* | *Value* |
|----------|----------|
| http\://schemas.xmlsoap.org/claims/CommonName  | user.displayname |
| http\://schemas.xmlsoap.org/claims/UPN  | user.userprincipalname  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress | user.mail  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname | user.givenname  |
| http\://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname | user.surname |

### eduPersonPrincipalName

You need to map the UPN claim to a username-like user attribute that is scoped to a realm you are [eligible to use]({{< ref "/safire/policy/mrps/_index.md#scope-format" >}}). The `user.userprincipalname` attribute exists by default and meets the definition of [eduPersonPrincipalName]({{< ref "/technical/attributes/edupersonprincipalname.md" >}}) for most organisations. However, you need to be careful it is not reassigned (see the link for more details).

eduPersonPrincipalName is perhaps the most important attribute you release, and it is up to you to determine which attribute in your Microsoft Entra ID best meets the required definition. See our [notes on generating eduPersonPrincipalName]({{< ref "generating-edupersonprincipalname.md" >}}) for more detail.

### eduPersonScopedAffiliation

[eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) provides a controlled vocabulary for asserting a users role in the institution. You will need to use what user attributes you have in your Microsoft Entra ID to create a *transform* rule to assert a users role at your institution correctly.

e.g. pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'member@example.ac.za'

```

**NOTE:**  eduPersonScopedAffiliation is a multi-valued attribute with a controlled vocabulary and, importantly, where an the [vocabulary definition]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) says "implies…" the implied values must also be included in the returned set.

> Microsoft Entra ID currently does not support multi-valued user extension attributes
{.message-box}

As many institutions use user extension attributes to store affiliation information, you can work around this problem by (re-)configuring the Attribute claims *transform* rule for eduPersonScopedAffiliation to release an attribute *Named* `scopedAffiliationSingleton` in SAFIRE's custom *Namespace* of [`https://safire.ac.za/namespace/claims`]({{< ref "/namespace/claims.md" >}}) with attribute values that are separated by a space, and meet the format rules described in eduPersonAffiliation, scoped to your realm. If your Entra ID IdP asserts `scopedAffiliationSingleton` correctly, the SAFIRE federation hub will reformat it into a multi-valued eduPersonScopedAffiliation attribute for you.

e.g. pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'staff@example.ac.za member@example.ac.za employee@example.ac.za'
ELSE IF 'user.extensionattribute4' CONTAINS 'student' THEN
  OUTPUT 'student@example.ac.za member@example.ac.za'

```

If you do not have a single attribute to use as in the above examples and you distinguish users based on group membership, you can look at creating *Claim conditions Transformations*.

e.g.

| *User type* | *Scoped Groups* | *Source* | *Value* |
|----------|----------|----------|----------|
| Members | *Select groups e.g. **students*** | Transformation | IF 'user.userprincipalname' NOT EMPTY THEN OUTPUT 'student@example.ac.za member@example.ac.za' |
| **OR**|
| Members | *Select groups e.g. **alumni*** | Transformation | IF 'user.userprincipalname' NOT EMPTY THEN OUTPUT 'alum@example.ac.za' |

See our [notes on generating eduPerson{Scoped}Affiliation]({{< ref "generating-edupersonaffiliation.md" >}}) for more ideas.

### eduPersonAffiliation

eduPersonAffiliation has the same semantics as eduPersonScopedAffiliation, but lacks the scope (the '@' sign and what follows, e.g. '@example.ac.za'). Thus you can re-use the claim rules you created for eduPersonScopedAffiliation to generate eduPersonAffiliation as well, and simply omit your scope from the attribute you output.

e.g. pseudocode

```lang-none

IF 'user.extensionattribute4' CONTAINS 'staff' THEN
  OUTPUT 'staff member employee'

```

As with eduPersonScopedAffiliation, you can work around Entra ID's multi-valued attribute problem, you can release eduPersonAffiliation as an attribute named `unscopedAffiliationSingleton` in SAFIRE's [claims namespace]({{< ref "/namespace/claims.md" >}}).

### Other attributes

What's shown here is only a subset of SAFIRE's [attribute set]({{< ref "/technical/attributes/_index.md" >}}). You're strongly encouraged to release others where you have the data available.

In particular, your library or researchers may require you to assert [eduPersonEntitlement]({{< ref "/technical/attributes/edupersonentitlement.md" >}}). This suffers similar multi-valued limitations, and can be mapped using the `entitlementSingleton` claim in SAFIRE's [claims namespace]({{< ref "/namespace/claims.md" >}}). See our [notes on generating eduPersonEntitlement]({{< ref "generating-edupersonentitlement.md" >}}).

# Other technical requirements
There is an additional [technical requirement]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) that you should ensure your Microsoft Entra ID tenant complies with which is not part of the above documentation, that you nevertheless need to meet.

## Logging requirements
By default Microsoft Entra ID stores audit, and sign-in logs for [30 days](https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/reference-reports-data-retention#how-long-does-azure-ad-store-the-data). You need to ensure that you configure Microsoft Entra ID to [archive it's logs](https://docs.microsoft.com/en-us/azure/active-directory/reports-monitoring/quickstart-azure-monitor-route-logs-to-storage-account) to meet the minimum retention period specified in the technical requirements.

## Tenant Validation
In order to meet the requirements of SAFIRE's [metadata registration practice statement]({{< ref "/safire/policy/mrps/_index.md#entity-eligibility-and-validation" >}}), we need to validate your right-to-use a particular tenant in Microsoft Entra ID.  This typically involves a live video call during which the person responsible demonstrates active control of a particular tenant. Depending on the scopes in use, it may further require domain control validation of those scopes.

## Multi-factor authentication

To enable support multi-factor authentication for your users, you will need to explicitly confirm that the authentication methods you've enabled are compatible with academic federation. See [authnmethodsreferences]({{< ref "/technical/attributes/authnmethodsreferences.md" >}}) for details.

# Improving generated metadata

By default, Microsoft Entra ID publishes its generated metadata at a well-known URL of:

* https://login.microsoftonline.com/*your-azure-ad-tenant-id*/federationmetadata/2007-06/federationmetadata.xml?appid=*your-enterprise-application-id*

This URL is displayed in the SAML Signing Certificate block of the Single sign-on properties of your Enterprise Application, along with a download link. You can use this to obtain the copy of metadata you need to supply to SAFIRE.

However, but default the auto-generated metadata does not include many of the [required elements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) and will need to be hand-edited to include your organisation information, contacts and some of the MDUI elements (such as your logo URL and privacy statement) by before sending your metadata to SAFIRE.

