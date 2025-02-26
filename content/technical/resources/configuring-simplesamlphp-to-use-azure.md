---
date: 2023-09-06 13:00:00+02:00
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

Below, you'll find an example demonstrating how to configure SimpleSAMLphp to use the attributes received from Entra ID to search for and assert additional attributes for a user from an LDAP source of an on-prem Active Directory. Naturally, this concept can be ported to other LDAP sources.

> This documentation assumes you already have an Entra ID tenant correctly configured and provisioned with your institution's user accounts. Further, SimpleSAMLphp has good documentation, so this is not a complete/worked example of how to configure it. Instead, this provides the specific snippets you may need when working through SimpleSAMLphp's documentation. Thus, this document also assumes you have SimpleSAMLphp installed and reachable with the basics configured.
{.message-box}

To configure SimpleSAMLphp to use your Entra ID IdP as an Authentication Source, you will need to complete the following:

 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider (SP)
 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider (IdP)
 3. Create a new Enterprise Application
 4. Set up single sign-on
 5. Configure Attribute claims rules.
 6. Configure SimpleSAMLphp to use the Entra ID IdP as an authentication source.
 7. Add attributes from another source (in this case, LDAP)
 8. Configure SimpleSAMLphp internal SP to test

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

To set up SimpleSAMLphp's Service Provider, configure a new Authentication Source in the authsources config file.

Here's an example of a minimal configuration to publish SAML 2.0 SP metadata:

```php
// An authentication source that can authenticate against SAML 2.0 IdPs.
'default-sp' => [
    'saml:SP',
    // The entity ID of this SP.
    'entityID' => 'https://myapp.example.org/',
    //certificates
    'privatekey' => 'server.key',
    'privatekey_pass' => 'YourPrivateKeyPassphrase',
    'certificate' => 'server.crt',
    ],
```

The above will publish an elementary set of SAML 2.0 SP metadata values at the Federation tab of your SimpleSAMLphp webpage.

> To produce more complete SAML 2.0 SP metadata, you should also consider configuring the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui).
{.message-box}

# 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider

Setting up the IdP side of SimpleSAMLphp will essentially be ‘*killing two birds with one stone'*. On the one hand, it will allow you to test the Authentication Processing Filters we will set up later in this document. On the other hand, setting this up will be useful so you can get your IdP Federation ready.

To set up the IdP, you need to edit the _saml20-idp-hosted.php_ file. We will use and slightly edit the default IdP configuration standard in the _saml20-idp-hosted.php.dist_ file for this documentation.

```php
$metadata['http://idp.example.ac.za/'] = [
    //The hostname of the server (VHOST) that will use this SAML entity.
    //Can be '__DEFAULT__', to use this entry by default.
    'host' => '__DEFAULT__',
    // X.509 key and certificate. Relative to the cert directory.
    'privatekey' => 'idp.key',
    'privatekey_pass' => 'YourPrivateKeyPassphrase',
    'certificate' => 'idp.pem',
    //Authentication source to use. It must be one that is configured in
    //'config/authsources.php'.
    'auth' => 'default-sp',
];
```

This will then publish basic SAML 2.0 IdP metadata, available on SimpleSAMLphp's *Federation tab*, which we will use later in this document. note, the _auth_ option is set to point at our _default-sp_ from [step 1 above]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}).

> As with Configuring a SimpleSAMLphp SAML 2.0 Service Provider, you will need to produce well-formed metadata by configuring the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui). Properly formed metadata and these options are required when [configuring your IdP for SAFIRE](https://safire.ac.za/technical/resources/configuring-simplesamlphp-for-safire/).
{.message-box}

# 3. Create a new Enterprise Application

You will need to create a new *Enterprise Application* in your organisation's Entra ID Directory Service. You can do so by adding a *New application* and then *Create your own application* under the *Enterprise Applications* Management item.

You can name the application whatever makes sense to you. Your new application will be integrated with other applications, not in the Entra ID Application Gallery.

# 4. Set up single sign-on

Now that you have created your application, you need to enable SAML-based single sign-on and establish the Entra ID side of the bilateral trust relationship between your App and SimpleSAMLphp. You start by uploading your SAML 2.0 SP metadata file (from [step 1]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}), in XML format). Entra ID's metadata Upload utility should pre-populate the Basic SAML Configuration from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the upload utility correctly imported the information and that you understand what each of the fields is doing.

# 5. Configure Attribute claims rules

You now need to configure your application's Attributes & Claims. Entra ID sets up a few default Attributes & Claims rules. However, For this document, it is sufficient to release an attribute common in other sources you might use to search for user attributes. This requires altering what has been pre-defined or adding a new claim. In this example, we'll configure Entra ID to release ‘userPrincipalName' and ‘mail' as a minimal set of attributes.

| *Claim Name* | *Namespace* | *Name format* | *Source* | *Source attribute* |
|---|---|---|---|---|
| UPN | http\://schemas.xmlsoap.org/claims | Omited | Attribute | user.userprincipalname|
| emailaddress | http\://schemas.xmlsoap.org/ws/2005/05/identity/claims | Omitted | Attribute |user.mail|

We can then use this information to fetch other attributes from LDAP, as the remainder of this document shows.

> You could also consider getting other attributes directly from Entra ID. For example, you can send group information by adding a group claim of http\://schemas.microsoft.com/ws/2008/06/identity/claims/groups. That may be sufficient for your needs, but this document assumes a more complete example with an LDAP backend.
{.message-box}

# 6. Configure SimpleSAMLphp to use the Entra ID IdP as an authentication source

With your _Enterprise Application_ now configured, you need to configure SimpleSAMLphp to use Entra ID's IdP as its Authentication Source.

This is done by adding the following to your default-sp configuration from [step 1 above]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}).

```php
// Your Entra ID Identifier (entityID)
'idp' => 'https://sts.windows.net/<your-entra-tenant-id/',
```

This line tells the default SP to redirect authentication to the IdP specified. In this case, your Entra ID Identifier (i.e. your entity ID).

To finalise the SimpleSAMLphp side of the bilateral trust relationship between your Entra ID tenant and SimpleSAMLphp, copy your Enterprise Application's _App Federation Metadata_. Using SimpleSAMLphp's Metadata Converter (found on SimpleSAMLphp's _Federation tab_), convert your App Federation Metadata to SimpleSAMLphp. Once you have the converted metadata, paste it into the _saml20-idp-remote.php_ file.

To verify that you imported the metadata correctly, you should now see your Entra ID's entityID listed under SAML 2.0 IdP metadata on SimpleSAMLphp's _Federation tab_.

You should now also be able to go to SimpleSAMLphp's Test page, log in to your _default-sp_, and be redirected to your Entra ID application's login page. Once logged in, it is worth verifying that SimpleSAMLphp is correctly receiving the attributes from Entra ID you configured in [step 5 above]({{< ref "#5-configure-attribute-claims-rules" >}}).

> The attributes received from Entra ID are claim-type identifier attributes. You can establish a custom[ attribute mapping](https://simplesamlphp.org/docs/stable/core/authproc_attributemap.html) policy in which SimpleSAMLphp will rewrite the attributes received from Entra ID into different Identifier namespaces. These namespaces could include Object Identifiers (OIDs) or named identifiers like 'userPrincipalName'. SimpleSAMLphp includes some pre-defined mapping policies, which can be found in the attributemap folder.
{.message-box}

# 7. Add attributes from another source (in this case, LDAP)

Retrieving attributes from LDAP requires you to install SimpleSAMLphp's [LDAP module](https://github.com/simplesamlphp/simplesamlphp-module-ldap). Once you have installed this module, you need to configure your [LDAP authsource](https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html), which will be used by [Authentication Processing Filters](https://simplesamlphp.org/docs/2.0/simplesamlphp-authproc.html) (authproc) to search for additional attributes later.

An example of an LDAP authsource can look like this:

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
],
```
Next, we will use SimpleSAMLphp's [ldap:AttributeAddFromLDAP][https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html] authentication processing (authproc) filter. You can configure your filters globally in the _config.php_ or the _sam20-idp-hosted.php_ metadata file; This choice is use-case specific.

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

You can also used the [ldap:AttributeAddUsersGroups](https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html) authproc filter to retrieve a user's groups. This might be useful if you need group information to generate [eduPersonScopedAffiliation]({{< ref "generating-edupersonaffiliation.md" >}}).

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

> _An authproc filter is not functional in the "Test authentication sources" option within the web UI of a SimpleSAMLphp IdP. It will only be activated when used alongside an actual SP (Service Provider). Therefore, when testing your filter, it is necessary to establish both an IdP and an SP._
{.message-box}

With the above warning in mind, you can set up your SimpleSAMLphp deployment as a Service Provider internal to its own Identity Provider to facilitate testing.

# 8. Configure SimpleSAMLphp internal SP to test

A bilateral trust relationship needs to be established with the following considerations:

{{< figure
    src="/wp-content/uploads/2023/09/ssp-internal-bilateral.png"
    alt="SimpleSAMLphp internatl bilateral trust"
    caption="Figure 1.2 SimpleSAMLphp internatl bilateral trust"
    id="figure_1_2"
>}}

> This SP is set up as a separate SP authsource from the default-sp configured in [step 1]({{< ref "#1-configure-a-simplesamlphp-saml-20-service-provider" >}}); Also remember that SimpleSAMLphp wants metadata converted to PHP.
{.message-box}

An example of your internal SP configuration could look like this:

```php
$config = [
    /* ... */
    'internal-sp' => [
        'saml:SP',
       // The entity ID of this SP.
       'entityID' => 'https://myapp.example.org/internal-sp',
       'privatekey' => 'sp.key',
       'privatekey_pass' => 'YourPrivateKeyPassphrase',
       'certificate' => 'sp.pem',
       // The entity ID of your hosted SAML 2.0 IdP metadata this SP should contact (configured above)
       'idp' => 'https://idp.example.ac.za/',
    ],
    /* ... */
],
```

Per [figure 1.2]({{< ref "#figure_1_2" >}}), to finalise the set-up of the internal SP's bilateral trust relationship, you will need to copy the SAML 2.0 IdP Metadata you set up in [step 2 above]({{< ref "#2-configure-simplesamlphp-saml-20-identity-provider" >}}) from your SimpleSAMLphp's _Federation tab_ into the _saml20-idp-remote.php_ file. You will also need to copy your SAML 2.0 SP metadata for your internal-sp into the _saml20-sp-remote.php_ file.

With the above correctly configured, you can now go to SimpleSAMLphp's Test page and use your ‘internal-sp' to authenticate to your Entra ID IdP.

You should now see attributes returned from both Entra ID, and the Auth Proc filters you configured in [step 7]({{< ref "#7-add-attributes-from-another-source-in-this-case-ldap" >}}).

# Other examples

You can map incoming attribute names to new names. For example, to map he claim-type version of the UPN attribute claim it received from Entra ID to the [eduPersonPrincipalName]({{< ref "/technical/attributes/edupersonprincipalname.md" >}}) attribute.

```php
'authproc' => [
    /* ... */
    62 => [
        'class' => 'core:AttributeMap',
        'http://schemas.xmlsoap.org/claims/UPN' => 'eduPersonPrincipalName',
    ],
    /* ... */
],
```

Although this might be more efficiently done with the built-in `claim2name` attribute map. See [core:AttributeMap](https://simplesamlphp.org/docs/stable/core/authproc_attributemap.html).

Another scenario is to use the group information we extracted in [step 7]({{< ref "#7-add-attributes-from-another-source-in-this-case-ldap" >}}) to generate [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) and [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}).

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

For more information, refer to SimpleSAMLphp's documentation and our [guide to configuring SimpleSAMLphp]({{< ref "configuring-simplesamlphp-for-safire.md" >}}).
