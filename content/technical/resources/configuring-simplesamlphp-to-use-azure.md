---
date: 2023-09-06 13:00:00+02:00
slug: configuring-simplesamlphp-to-use-azure 
tags:
  - azure
  - configuration
  - metadata
  - simplesamlphp
  - technical
title: Configuring SimpleSAMLphp to use Azure-AD
url: /technical/resources/configuring-simplesamlphp-to-use-azure
---

This documentation will guide you through the Azure Active Directory (Azure AD) configuration process as an authentication source in SimpleSAMLphp. By integrating Azure AD in this way, you can retain your users' familiar login experience while leveraging SimpleSAMLphp's flexibility to fetch and/or manipulate attributes from Azure AD and other sources.

While SAFIRE can directly work with Azure AD or SimpleSAMLphp (as explained in our [Configuring Azure AD SAML-based SSO for SAFIRE]({{< ref "/technical/resources/configuring-azure-ad-for-safire.md" >}}) and [Configuring SimpleSAMLphp for SAFIRE]({{< ref "/technical/resources/configuring-simplesamlphp-for-safire.md" >}}) documentation), you may find yourself in a situation where this approach better fits your use case.

Below, you'll find an example demonstrating how to configure SimpleSAMLphp to use the attributes received from Azure AD to search for and assert additional attributes for a user from an LDAP source of an on-prem Active Directory.
 
**NOTE:**
This documentation assumes you already have an Azure AD tenant correctly configured and provisioned with your institution’s user accounts. Further, SimpleSAMLphp has good documentation, so this is not a complete/worked example of how to configure it. Instead, this provides the specific snippets you may need when working through SimpleSAMLphp’s documentation. Thus, this document also assumes you have SimpleSAMLphp installed and reachable with the basics configured.

To configure SimpleSAMLphp to use your Azure AD IdP as an Authentication Source, you will need to complete the following:

 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider (SP)
 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider (IdP)
 3. Create a new Enterprise Application
 4. Set up single sign-on
 5. Configure Attribute claims rules.
 6. Configure SimpleSAMLphp to use the Azure AD IdP as an authentication source.
 7. Add attributes from another source (in this case, LDAP)
 8. Configure SimpleSAMLphp internal SP to test

To start, consider the following diagram on establishing a bilateral trust relationship between Azure AD and SimpleSAMLphp: 

![Azure AD and SimpleSAMLphp bilateral trust](/wp-content/uploads/2023/09/ssp-azure-bilateral.png)
                           
_fig 1.1_

**NOTE:**
Azure AD mandates metadata in XML format, while SimpleSAMLphp necessitates metadata to be converted into PHP (See SimpleSAMLphp’s metadata converter).

# 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider

To set up SimpleSAMLphp's Service Provider, configure a new Authentication Source in the authsources config file.

Here's an example of a minimal configuration to publish SAML 2.0 SP metadata:

```php
// An authentication source that can authenticate against SAML 2.0 IdPs.
'default-sp' => [
    'saml:SP',
    // The entity ID of this SP.
    'entityID' => 'https://<your_host>/default-sp',
    //certificates
    'privatekey' => 'server.key',
    'privatekey_pass' => 'YourPrivateKeyPassphrase',
    'certificate' => 'server.crt',
    ],
```

The above will publish an elementary set of SAML 2.0 SP metadata values at the Federation tab of your SimpleSAMLphp webpage.

**NOTE:** To produce more complete SAML 2.0 SP metadata, you should also consider configuring the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui). 

# 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider

Setting up the IdP side of SimpleSAMLphp will essentially be ‘*killing two birds with one stone’*. On the one hand, it will allow you to test the Authentication Processing Filters we will set up later in this document. On the other hand, setting this up will be useful so you can get your IdP Federation ready. 

To set up the IdP, you need to edit the _saml20-idp-hosted.php_ file. We will use and slightly edit the default IdP configuration standard in the _saml20-idp-hosted.php.dist_ file for this documentation.

```php
$metadata['https://your-simplesamlphp-hosted-idp-entityid'] = [
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

This will then publish basic SAML 2.0 IdP metadata, available on SimpleSAMLphp’s *Federation tab*, which we will use later in this document.

**NOTE:** As with Configuring a SimpleSAMLphp SAML 2.0 Service Provider, you will need to produce well-formed metadata by configuring the [MDUI options](https://simplesamlphp.org/docs/stable/simplesamlphp-metadata-extensions-ui). Properly formed metadata and these options are required when [configuring your IdP for SAFIRE](https://safire.ac.za/technical/resources/configuring-simplesamlphp-for-safire/).

# 3. Create a new Enterprise Application

You will need to create a new *Enterprise Application* in your organisation’s Azure Active Directory Service. You can do so by adding a *New application* and then *Create your own application* under the *Enterprise Applications* Management item.

You can name the application whatever makes sense to you. Your new application will be integrated with other applications, not in the Azure Application Gallery.

# 4. Set up single sign-on

Now that you have created your application, you need to enable SAML-based single sign-on and establish the Azure side of the bilateral trust relationship between your App and SimpleSAMLphp. You start by uploading your SAML 2.0 SP metadata file (from step 1, in XML format). Azure AD’s metadata Upload utility should pre-populate the Basic SAML Configuration from what it finds in the uploaded metadata file.

Once saved, it is worthwhile double-checking that the upload utility correctly imported the information and that you understand what each of the fields is doing.

# 5. Configure Attribute claims rules

You now need to configure your application’s User Attributes & Claims. Azure sets up a few default User Attributes & Claims rules. However, For this document, it is sufficient to release an attribute common in other sources you might use to search for user attributes. This requires altering what has been pre-defined or adding a new claim. In this example, we’ll configure Azure AD to release ‘userPrincipalName’ and ‘mail’ as a minimal set of attributes; We’ll fetch other attributes from LDAP.

e.g. of the above claims from Azure.

|***CLAIM NAME***|***VALUE***|
| :- | :- |
|http://schemas.xmlsoap.org/claims/UPN|user.userprincipalname|
|http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress|user.mail|

# 6. Configure SimpleSAMLphp to use the Azure AD IdP as an authentication source

With Your _Enterprise Application_ now configured, you need to configure SimpleSAMLphp to use Azure AD’s IdP as its Authentication Source.

This is done by adding the following to your default-sp configuration from step 1 above.

```php
// Your Azure Azure AD Identifier (entityID)
'idp' => 'https://sts.windows.net/<your-azure-tenant-id/',
```

This line tells the default SP to redirect authentication to the 'idp' specified. In this case, your Azure AD Identifier, or rather, 'entityID'.

To finalise the SimpleSAMLphp side of the bilateral trust relationship between your Azure AD and SimpleSAMLphp, copy your Enterprise Application's _App Federation Metadata_. Using SimpleSAMLphp’s Metadata Converter (found on SimpleSAMLphp's _Federation tab_), convert your App Federation Metadata to SimpleSAMLphp. Once you have the converted metadata, paste it into the _saml20-idp-remote.php_ file.

To verify that you imported the metadata correctly, you should now see your Azure AD's entityID listed under SAML 2.0 IdP metadata on SimpleSAMLphp’s _Federation tab_.

You should now also be able to go to SimpleSAMLphp's Test page, log in to your _default-sp_, and be redirected to your Azure AD login page. Once logged in, it is worth verifying that SimpleSAMLphp is correctly receiving the attributes from Azure AD you configured in step 5 above.

Note: The attributes received from Azure are claim-type identifier attributes. You can establish a custom[ attribute mapping](https://simplesamlphp.org/docs/stable/core/authproc_attributemap.html) policy in which SimpleSAMLphp will rewrite the attributes received from Azure into different Identifier namespaces. These namespaces could include Object Identifiers (OIDs) or named identifiers like 'userPrincipalName'. SimpleSAMLphp includes some pre-defined mapping policies, which can be found in the attributemap folder.

# 7. Add attributes from another source (in this case, LDAP)

Retrieving attributes from LDAP requires you to install SimpleSAMLphp’s [LDAP module](https://github.com/simplesamlphp/simplesamlphp-module-ldap). Once you have installed this module, you need to configure your [LDAP authsource](https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html), which will be used by [Authentication Processing Filters](https://simplesamlphp.org/docs/2.0/simplesamlphp-authproc.html) (authproc) to search for additional attributes later. 

An example of an LDAP authsource can look like this:

```php
'your-LDAP-authsource' => [
    'ldap:Ldap',
    'connection_string' => 'ldaps://your-ldap-host',
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
        'OU=Your,DC=base,DC=dn,DC=ac,DC=za',
    ],
    'search.scope' => 'sub',
    'search.attributes' => ['cn', 'userPrincipalName'],
    'search.filter' => '(&(objectClass=user)(objectCategory=person))',
    'search.username' => 'CN=searchuser, OU=services,DC=ad,DC=ac,DC=za',
    'search.password' => 'searchuser_password',
 ],
```
Next, we will use SimpleSAMLphp's ldap:AttributeAddFromLDAP Auth Proc filter. You can configure your filters globally in the _config.php_ or the _sam20-idp-hosted.php_ metadata file; This choice is use-case specific.

Example of an authproc filter:

```php
'authproc' => [
60  => [
     'class' => 'ldap:AttributeAddFromLDAP',
     'authsource' => 'your-LDAP-authsource',
     'attribute.policy' => 'add',
     'attributes' => ['givenName','sn',’displayName',],
     'search.filter' => '(userPrincipalName=%http://schemas.xmlsoap.org/claims/UPN%)',
     ]
],
```

The above example uses the claim-type version of the userPrincipalName (UPN) attribute value, obtained from Azure, to search through the Active Directory for a matching userPrincipalName attribute value. Once a match is found, the givenName, sn, and displayName attributes are returned; You can expand the list of returned attributes per your needs. 

> _An Auth Proc Filter is not functional in the "Test authentication sources" option within the web UI of a SimpleSAMLphp IdP. It will only be activated when used alongside an actual SP (Service Provider). Therefore, when testing your filter, it is necessary to establish both an IdP and an SP._
{.message-box .warning}

With the above warning in mind, you can set up your SimpleSAMLphp deployment as a Service Provider internal to its own Identity Provider;

# 8. Configure SimpleSAMLphp internal SP to test

A bilateral trust relationship needs to be established with the following considerations:

![SimpleSAMLphp internatl bilateral trust](/wp-content/uploads/2023/09/ssp-internal-bilateral.png)

_fig 1.2_

Note: This SP is set up as a separate SP authsource from the default-sp configured in step 1; Also remember that SimpleSAMLphp wants metadata converted to PHP.

An example of your internal SP configuration could look like this:

```php
'internal-sp' => [
    'saml:SP',
   // The entity ID of this SP.
   'entityID' => 'https://tmp-dsk-01.desk.local/internal-sp',
   'privatekey' => 'sp.key',
   'privatekey_pass' => 'YourPrivateKeyPassphrase',
   'certificate' => 'sp.pem',
   // The entity ID of your hosted SAML 2.0 IdP metadata this SP should contact
   'idp' => 'https://your-simplesamlphp-hosted-idp-entityid',
   'discoURL' => null,
   // Can be NULL/unset, in which case the user will be shown a list of available IdPs.
],
```

Per _fig 1.2_, To finalise the set-up of the internal SP’s bilateral trust relationship, you will need to copy the SAML 2.0 IdP Metadata you set up in step 2 above from your SimpleSAMLphp’s _Federation tab_ into the _saml20-idp-remote.php_ file. You will also need to copy your SAML 2.0 SP metadata for your internal-sp into the _saml20-sp-remote.php_ file.

With the above correctly configured, you can now go to SimpleSAMLphp’s Test page and use your ‘internal-sp’ to authenticate to your Azure AD IdP. 

You should now see attributes returned from both Azure, and the Auth Proc filters you configured in step 7.

# Other examples


Another scenario is that we can also extract group memberships from Active Directory. We can search through the users memberships to assert other attributes. For example:

```php
61 => [
'class' => 'core:PHP',
    'code' => '
    if (isset($attributes["memberOf"]) &&     in\_array("CN=staff,OU=My,OU=AD,DC=ac,DC=za", $attributes["memberOf"])) {
       $attributes["eduPersonAffiliation"] = ["staff", "employee", "member"];}',
],
```

(The above looks if the user is a member of the staff group (in DN format) in the memberOf attribute, and if so, will assert an eduPersonAffiliation attribute.)

you can, also map attributes to others:

```php
62 =>  ['class' => 'core:AttributeMap',
       'http://schemas.xmlsoap.org/claims/UPN' => 'eduPersonPrincipalName'],
],
```
(The above maps the claim-type version of the UPN attribute it received from Azure, to the eduPersonPrincipalName attribute)

For more information, refer to SimpleSAMLphp’s documentation.




