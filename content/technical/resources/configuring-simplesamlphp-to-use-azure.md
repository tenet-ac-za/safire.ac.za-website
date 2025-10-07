---
date: 2025-08-07 09:22:00+02:00
slug: configuring-simplesamlphp-to-use-entra-id
tags:
  - azure
  - configuration
  - metadata
  - simplesamlphp
  - technical
title: Configuring SimpleSAMLphp to use Entra ID (Azure AD)
url: /technical/resources/configuring-simplesamlphp-to-use-entra-id
aliases:
  - /technical/resources/configuring-simplesamlphp-to-use-azure
---

This documentation will guide you through the Microsoft Entra ID (Azure AD) configuration process as an authentication source in SimpleSAMLphp. By integrating Entra ID in this way, you can retain your users' familiar login experience while leveraging SimpleSAMLphp's flexibility to fetch and/or manipulate attributes from Entra ID and other sources.

While SAFIRE can directly work with Entra ID or SimpleSAMLphp (as explained in our [Configuring Entra ID SAML-based SSO for SAFIRE]({{< ref "/technical/resources/configuring-azure-ad-for-safire.md" >}}) and [Configuring SimpleSAMLphp for SAFIRE]({{< ref "/technical/resources/configuring-simplesamlphp-for-safire.md" >}}) documentation), you may find yourself in a situation where this approach better fits your use case.

Below, you'll also find an example demonstrating how to configure SimpleSAMLphp to use the attributes received from Entra ID to search for and assert additional attributes for a user from an LDAP source of an on-prem Active Directory. Naturally, this concept can be ported to other data sources.

> This documentation assumes you already have an Entra ID tenant correctly configured and provisioned with your institution's user accounts. Further, SimpleSAMLphp has good documentation, so this is not a complete/worked example of how to configure it. Instead, this provides the specific snippets you may need when working through SimpleSAMLphp's documentation. Thus, this document also assumes you have SimpleSAMLphp installed and reachable with the basics configured.
{.message-box}

To configure SimpleSAMLphp to use your Entra ID IdP as an Authentication Source, you will need to complete the following:

 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider (SP)
 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider (IdP)
 3. Create a new Enterprise Application
 4. Set up single sign-on
 5. Configure Attribute claims rules.
 6. Configure SimpleSAMLphp to use the Entra ID IdP as an authentication source.
 7. [Optional] Add attributes from another source (in this case, LDAP)
 8. Other attribute manipulations
 9. Testing

To start, consider the following diagram on establishing a bilateral trust relationship between Entra ID and SimpleSAMLphp:

{{< figure
    src="/wp-content/uploads/2023/09/ssp-azure-bilateral.png"
    alt="Entra ID and SimpleSAMLphp bilateral trust"
    caption="Figure 1.1: Entra ID and SimpleSAMLphp bilateral trust"
    id="figure_1_1"
>}}

> Entra ID mandates metadata in XML format, while SimpleSAMLphp necessitates metadata to be converted into PHP (See SimpleSAMLphp's metadata converter).
{.message-box}

# 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider

To set up SimpleSAMLphp's Service Provider, configure a new Authentication Source in _config/authsources.php_.

Here's an example of a minimal configuration to publish SAML 2.0 SP metadata:

```php
$config = [
    /* ... */

    /* An authentication source that can authenticate against SAML 2.0 IdPs. */
    'entraid-sp' => [
        'saml:SP',

        // The entity ID of this SP.
        'entityID' => 'https://myapp.example.org/',

        // The entity ID of the IdP this SP should contact.
        'idp' => 'https://sts.windows.net/<your-entra-tenant-id>/'
        'name' => ['en' => 'Microsoft Entra ID'],

        // certificates
        'certificate' => 'server.crt',
        'privatekey' => 'server.key',
        'privatekey_pass' => 'YourPrivateKeyPassphrase', /* you encrypt your private key, right? */

        'authproc' => [
            /* authproc rules from steps 7 & 8 */
        ],

        // fine tuning the auth source for Entra ID
        'sign.authnrequest' => true,
        'sign.logout' => true,
        'proxymode.passAuthnContextClassRef' => true,
        /* https://learn.microsoft.com/en-us/answers/questions/69360/aadsts900236-the-saml-authentication-request-prope */
        'disable_scoping' => true,
        'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
    ],
],
```

The above will publish an elementary set of SAML 2.0 SP metadata values at the Federation tab of your SimpleSAMLphp webpage.

# 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider

Setting up the IdP side of SimpleSAMLphp will essentially be ‘*killing two birds with one stone'*. On the one hand, it will allow you to test the Authentication Processing Filters we will set up later in this document. On the other hand, setting this up will be useful so you can get your IdP Federation ready.

To set up the IdP, you need to edit the _metadata/saml20-idp-hosted.php_ file. We will use and slightly edit the default IdP configuration standard in the _metadata/saml20-idp-hosted.php.dist_ file for this documentation.

```php
$metadata['http://idp.example.ac.za/'] = [
    /*
     * The hostname of the server (VHOST) that will use this SAML entity.
     *
     * Can be '__DEFAULT__', to use this entry by default.
     */
    'host' => '__DEFAULT__',

    // X.509 key and certificate. Relative to the cert directory.
    'privatekey' => 'server.pem',
    'privatekey_pass' => 'YourPrivateKeyPassphrase',
    'certificate' => 'server.crt',

    /*
     * Authentication source to use. Must be one that is configured in
     * 'config/authsources.php'.
     */
    'auth' => 'entraid-sp', // proxy to Microsoft Entra ID

    /* convert the attributes to the format expected by SAFIRE */
    'attributes.NameFormat' => 'urn:oasis:names:tc:SAML:2.0:attrname-format:uri',
    'authproc' => [
        100 => ['class' => 'core:AttributeMap', 'name2oid',],
        /* subject identifier - separated to ensure it only ever processes after name2oid */
        101 => ['class' => 'core:AttributeMap', 'name2urn',],

        /*
         * Uncomment authproc filter 102 if you're migrating an *existing* IdP that previously did
         * local authentication via e.g. LDAP to one that fronts another SAML IdP (AD FS, Entra).
         * This ensures services that depend on <AuthenticatingAuthority> see your original
         * entityID as the authority that did the authentication rather than the one you proxy (you
         * hide the extra hop). This helps preserve persistent identifiers like eduPersonTargetedID
         * that use the last <AuthenticatingAuthority> to determine the authenticating IdP. For a
         * more detailed explanation see: https://github.com/simplesamlphp/simplesamlphp/issues/1431
         */
        /*
        102 => [
            'class' => 'core:PHP', 'code' => '
                if (isset($state["saml:AuthenticatingAuthority"])) {
                    unset($state["saml:AuthenticatingAuthority"]);
                }
            ',
        ],
        */
    ],
];
```

Note the _auth_ option is set to point at our _entraid-sp_ from [step 1 above]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}).

> This is not a complete configuration. You will need to produce well-formed metadata by configuring the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui). Properly formed metadata and these options are required when [configuring your IdP for SAFIRE]({{< ref "configuring-simplesamlphp-for-safire.md" >}}).
{.message-box}

# 3. Create a new Enterprise Application

You will need to create a new *Enterprise Application* in your organisation's Entra ID Directory Service. You can do so by adding a *New application* and then *Create your own application* under the *Enterprise Applications* Management item.

You can name the application whatever makes sense to you and your users (it will be displayed to users during login, so perhaps "SAFIRE Identity Provider"). Your new application will be integrated with other applications, not in the Entra ID Application Gallery.

# 4. Set up single sign-on

Now that you have created your application, you need to enable SAML-based single sign-on and establish the Entra ID side of the bilateral trust relationship between your App and SimpleSAMLphp. You start by uploading your SAML 2.0 SP metadata file (from [step 1]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}), in XML format). Entra ID's metadata Upload utility should pre-populate the Basic SAML Configuration from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the upload utility correctly imported the information and that you understand what each of the fields is doing.

# 5. Configure Attribute claims rules

You now need to configure your application's Attributes & Claims. There are two possibilities here: you can either release all the attributes from Entra ID directly (removing any other dependencies), or you can simply use Entra ID to identify the user and gather attributes from LDAP or another source.

## 5.1 Attributes from Entra ID

If your Entra ID directory contains sufficient information, it makes sense to gather all (or as many as possible) attributes from that source. In that case, you would need to set up all the claim rules required to release these attributes directly from Entra ID.

> See our [documentation on configuring Entra ID for SAFIRE]({{< ref "configuring-azure-ad-for-safire.md#3-configure-attribute-claims-rules" >}}) for details on how to set these claims up.
{.message-box}

If you are generating `eduPersonScopedAffiliation` in SimpleSAMLphp, you might want to release group information from Entra ID. To do that, you need to *Add a group claim*. The easiest solution is to return *All groups* with the claim. You can vary the *Source attribute* based on your needs: if your group names change or you have a complicated forest, you might want to use `Group ID` (a persistent UUID). If you'd prefer more friendly names, you might want to use `DNSDomain\sAMAccountName`.

## 5.2 User ID from Entra ID; attributes from elsewhere.

If you're going to get your attributes from another source, it is sufficient to release an attribute common in other sources you might use to search for user attributes. This requires altering what has been pre-defined or adding a new claim. In this example, we'll configure Entra ID to release ‘userPrincipalName' and ‘mail' as a minimal set of attributes.

| *Claim Name* | *Namespace* | *Name format* | *Source* | *Source attribute* |
|---|---|---|---|---|
| UPN | http\://schemas.xmlsoap.org/claims | Omited | Attribute | user.userprincipalname|
| emailaddress | http\://schemas.xmlsoap.org/ws/2005/05/identity/claims | Omitted | Attribute |user.mail|

We can then use this information to fetch other attributes from LDAP, as the [section 7]({{< ref "#7-add-attributes-from-another-source" >}}) of this document shows.

# 6. Configure SimpleSAMLphp to use the Entra ID IdP as an authentication source

With your _Enterprise Application_ now configured, you need to configure SimpleSAMLphp to use Entra ID's IdP as its Authentication Source.

This is done by replacing the following line in your entraid-sp configuration from [step 1 above]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}) with the Microsoft Entra Identifier from the Enterprise Application (on the Single sign-on page, see step 4 "Set up SAFIRE Identity Provider").

```php
// Your Entra ID Identifier (entityID)
'idp' => 'https://sts.windows.net/<your-entra-tenant-id>/',
```

This line tells the default SP to redirect authentication to the IdP specified. In this case, your Entra ID Identifier (i.e. your entity ID).

To finalise the SimpleSAMLphp side of the bilateral trust relationship between your Entra ID tenant and SimpleSAMLphp, copy your Enterprise Application's _App Federation Metadata_. Using SimpleSAMLphp's Metadata Converter (found on the _Federation_ tab of SimpleSAMLphp's admin portal), convert your App Federation Metadata to SimpleSAMLphp's native PHP format. Once you have the converted metadata, paste it into the _metadata/saml20-idp-remote.php_ file.

To verify that you imported the metadata correctly, you should now see your Entra ID's entityID listed under SAML 2.0 IdP metadata on the _Federation_ tab.

You should now also be able to go to the _Test_ tab in the admin portal, log in to your _entraid-sp_ authentication source, and be redirected to your Entra ID application's login page. Once logged in, it is worth verifying that SimpleSAMLphp is correctly receiving the attributes from Entra ID you configured in [step 5 above]({{< ref "#5-configure-attribute-claims-rules" >}}). See [testing]({{< ref "#9-testing" >}}) below for more info.

Note that the attributes received from Entra ID are claim-type identifier attributes. You will fix this in [step 8]({{< ref "#8-other-attribute-manipulations" >}}).

# 7. Add attributes from another source

> You can skip this step if you're getting all your attributes from Entra ID directly.
{.message-box .info}

You can retrieve attributes from any data source SimpleSAMLphp supports (e.g. SQL, LDAP). Since it's common for people to have a hybrid arrangement with an on-prem Active Directory, this example will assume retrieving attributes from AD via LDAP. That might also be more familiar scenario for people who are transitioning an existing SimpleSAMLphp from Active Directory to Entra ID (in which case you will already have an `ldap:Ldap` authsource).

Retrieving attributes from LDAP requires you to install SimpleSAMLphp's [LDAP module](https://github.com/simplesamlphp/simplesamlphp-module-ldap). Once you have installed this module, you need to configure an [LDAP authsource](https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html). This won't be used directly, but will instead be used by [Authentication Processing Filters](https://simplesamlphp.org/docs/2.0/simplesamlphp-authproc.html) (authproc) to search for additional attributes later.

An example of an LDAP authsource in _config/authsources.php_ can look like this:

```php
$config = [
    /* ... */
    'your-LDAP-authsource' => [
        'ldap:Ldap',
        'connection_string' => 'ldaps://your-ldap-host.example.ac.za',
        'encryption' => 'ssl',
        'version' => 3,
        'ldap.debug' => false,
        'options' => [
            'referrals' => 0x00,
            'network_timeout' => 3,
        ],
        'connector' => '\SimpleSAML\Module\ldap\Connector\Ldap',
        'attributes' => [
            'cn', 'sn', 'givenName', 'displayName','userPrincipalName'
        ],
        'dnpattern' => 'cn=%username%',
        'search.enable' => true,
        'search.base' => [
            'OU=Students,DC=ad,DC=example,DC=ac,DC=za',
            'OU=Staff,DC=ad,DC=example,DC=ac,DC=za',
        ],
        'search.scope' => 'sub',
        'search.attributes' => ['cn', 'userPrincipalName'],
        'search.filter' => '(&(objectClass=user)(objectCategory=person))',
        'search.username' => 'CN=searchuser,OU=services,DC=ad,DC=example,DC=ac,DC=za',
        'search.password' => 'searchuser_password',
    ],
    /* ... */
    'entraid-sp' => [
        /* ... */
    ],
],
```
Next, we will use SimpleSAMLphp's [ldap:AttributeAddFromLDAP][https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html] authentication processing (authproc) filter to reference this from within the _entraid-sp_ authsource we created earlier.

Example of an authproc filter:

```php
'authproc' => [
    /* ... */
    60  => [
        'class' => 'ldap:AttributeAddFromLDAP',
        'authsource' => 'your-LDAP-authsource',
        'attribute.policy' => 'add',
        'attributes' => ['givenName', 'sn', 'displayName', 'preferredLanguage'],
        'search.filter' => '(userPrincipalName=%http://schemas.xmlsoap.org/claims/UPN%)',
    ]
    /* ... */
],
```

The above example uses the claim-type version of the userPrincipalName (UPN) attribute value, obtained from Entra ID, to search through the Active Directory for a matching userPrincipalName attribute value. Once a match is found, the givenName, sn, and displayName attributes are returned. You can expand the list of returned attributes per your needs.

You can also use the [ldap:AttributeAddUsersGroups](https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html) authproc filter to retrieve a user's groups. This might be useful if you need group information to generate [eduPersonScopedAffiliation]({{< ref "generating-edupersonaffiliation.md" >}}).

```php
'authproc' => [
    /* ... */
    61 => [
        'class' => 'ldap:AttributeAddUsersGroups',
        'authsource' => 'your-LDAP-authsource',
        'attribute.groups' => 'groups',
        'ldap.product' => 'ActiveDirectory', // optimisation to reduce number of searches
    ],
    /* ... */
],
```

# 8. Other attribute manipulations

SimpleSAMLphp provides powerful options to manipulate attributes in the form of Authentication Processing filters. These can be configured in several places, but generally we'd recommend configuring them in your Entra ID `saml:SP` authsource.

You can map incoming attribute names to new names. For example, to map the claim-type version of the attributes received from Entra ID to the the more friendly versions typically used in SimpleSAMLphp, you can set up an AttributeMap like this:

```php
'authproc' => [
    /* ... */
    62 => [
        'class' => 'core:AttributeMap',
        /* there are several versions of the userprincipalname claim, you only need the one you use */
        'http://schemas.xmlsoap.org/claims/UPN' => 'eduPersonPrincipalName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn' => 'eduPersonPrincipalName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name' => 'eduPersonPrincipalName',
        /* other possible attributes */
        'http://schemas.xmlsoap.org/claims/CommonName' => 'displayName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'givenName',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'sn',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'mail',
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/groups' => 'memberOf',
    ],
    /* ... */
],
```

Another scenario is to use the group information we extracted in [step 7]({{< ref "#7-add-attributes-from-another-source-in-this-case-ldap" >}}) to generate [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) and [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}). The same logic could be used for a group claim directly from Entra ID.

```php
'authproc' => [
    /* ... */
    63 => [
        'class' => 'core:PHP',
        'code' => '
            if (isset($attributes["groups"]) && in_array("CN=staff,OU=Groups,DC=ad,DC=example,DC=ac,DC=za", $attributes["groups"])) {
                $attributes["eduPersonAffiliation"] = ["staff", "employee", "member"];
            }
        ',
    ],
    /* remap eduPersonAffiliation to eduPersonScopedAffiliation */
    64 => [
        'class' => 'core:ScopeAttribute',
        'scopeAttribute' => 'eduPersonPrincipalName', // set the scope to match the UPN suffix
        'sourceAttribute' => 'eduPersonAffiliation',
        'targetAttribute' => 'eduPersonScopedAffiliation',
    ],
    /* ... */
],
```

(The above looks if the user is a member of the staff group (in DN format) in the `groups` attribute, and if so, will assert an eduPersonAffiliation attribute.)

For the specific case of the SAML general purpose subject identifier ([subject-id]({{< ref "/technical/attributes/subject-id.md" >}})), you can either [take the approach documented for EntraID]({{< ref "configuring-azure-ad-for-safire.md#subject-id" >}}) or you can use SimpleSAMLphp's [saml:SubjectID authproc filter](https://simplesamlphp.org/docs/stable/saml/authproc_subjectid.html) to transform the default objectID claim:

```php
'authproc' => [
    /* ... */
    20 => [
        'class' => 'saml:SubjectID',
        'identifyingAttribute' => 'http://schemas.microsoft.com/identity/claims/objectidentifier',
        'scopeAttribute' => 'eduPersonPrincipalName',
    ],```
    /* ... */
],
```

For more information, refer to SimpleSAMLphp's documentation and our [guide to configuring SimpleSAMLphp]({{< ref "configuring-simplesamlphp-for-safire.md" >}}).

# 9. Testing

> The built-in test tools described here only execute the authproc filters configured on the SP side of a proxy. Any filters you've configured on the IdP side (i.e. in the `authproc.idp` section of _config/config.php_ or in _metadata/saml20-idp-hosted.php_) can only be tested by another SAML SP. You can configure one locally for this purpose, but doing so is outside the scope of this documentation.
{.message-box .warning}

If you've put all your attribute transformations in the _entraid-sp_ saml:SP authsource, then you can test them by using SimpleSAMLphp's built-in tests. From the SimpleSAMLphp admin portal, click the _Test_ tab and find the Test Authentication Sources. Then choose your _entraid-sp_ source to initiate a login. You should be redirected to Entra ID and log in from login.microsoftonline.com.

Once you have logged in, you will be redirected back to the test page and you'll see the attributes released. Importantly, what you see will be the attributes as they are *after* any transformations done by authproc filter rules in the authsource.

You can re-visit the test page to iteratively refine the attributes that are generated until they contain the correct information. Note that you will need to Logout or otherwise clear session cookies set by both SimpleSAMLphp and login.microsoftonline.com between tests. A good way to do this is to start each test in a clean incognito/private browsing session.

It is important to test with multiple users (particularly ones who match different scenarios [e.g. staff vs students]). If you have test accounts of each of those types, you can use those. However, you might want other people to test and you might not want to give them administrative access to your SimpleSAMLphp install.

## 9.1 Testing with other users

If you want to allow other users to test, you can use SimpleSAMLphp's debugsp module. To use this, enable it in your _config.php_ by adding it to modules.enable:

```php
'module.enable' => [
    'core' => true,
    'admin' => true,
    'saml' => true,
    /* ... */
    'debugsp' => true,
],
```

Once the debugsp module is enabled, any user can visit

> https://__your_simplesaml_host__/simplesaml/module.php/debugsp/test/entraid-sp

and they'll be able to log in and see the same attributes you see in the Test Authentication Sources (obviously for their own user).
