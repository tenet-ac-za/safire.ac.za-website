---
date: 2021-05-07 13:00:00+02:00
slug: configuring-g-suite-idp-for-safire
tags:
  - configuration
  - google
  - gsuite
  - metadata
  - technical
title: Configuring Google Workspace (G Suite) as an IdP for SAFIRE
url: /technical/resources/configuring-g-suite-idp-for-safire/
---

> As a result of the [baseline changes that occured in march 2021]({{< ref "/safire/news/20210331-baseline-changes.md" >}}), it is no longer possible to directly integrate Google Workspace (G Suite) with SAFIRE without making [schema changes](https://support.google.com/a/answer/6327792). In particular, you would need to add support for the [displayName]({{< ref "/technical/attributes/displayname.md" >}}) and [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) attributes. As no current providers use Google Workspace, his document has not been updated to incorporate information on how to do that, nor has it been tested. It remains **theoretically** possible to integrate Google Workspace.

[Google Workspace for Education](https://edu.google.com/products/productivity-tools/) (formally G Suite formerly Google Apps) includes a limited [SAML identity provider](https://support.google.com/a/answer/6087519). Because SAFIRE is a hub-and-spoke federation, this can potentially be configured to work as an identity provider within SAFIRE --- the federation will do the work of integrating service providers, avoiding the need to add each one individually.

Note that we use G Suite's Primary Email for eduPersonPrincipalName (and Name ID) because it corresponds to the username people log in with. G Suite allows this to be reassigned after a delay. However, [to meet SAFIRE's requirements]({{< ref "/technical/resources/generating-edupersonprincipalname.md" >}}), please make sure ensure you never reassigned email addresses.

# Add a SAML app to G Suite

Log into the G Suite Admin console at [admin.google.com ](https://admin.google.com/)and click on Apps > SAML apps. Then select "Add a service/App to your domain" (or click the + button).

## Step 1

G Suite will offer you the choice of a number of service providers, but you should select "Setup my own custom app" to add SAFIRE's details.

{{< figure src="/wp-content/uploads/2017/03/gapps_sso_step1.png" caption="Step 1" >}}

## Step 2

Download G Suite's IdP metadata (Option 2) and save this for later. You'll need to hand-edit the XML in order to comply with SAFIRE's [metadata requirements](/technical/saml2/idp-requirements/) and pass [validation](https://validator.safire.ac.za/). However what you get from this stage is a useful starting point.

{{< figure src="/wp-content/uploads/2017/03/gapps_sso_step2.png" caption="Step 2" >}}

### Step 3

Configure the basic information for the Custom App. You want to add information that tells your users that they're connected to the SAFIRE federation, but feel free to customise this in a way that makes sense to you. If you need a logo, you can use [this one](https://static.safire.ac.za/logos/safire-logo-300x300.png).

{{< figure src="/wp-content/uploads/2017/03/gapps_sso_step3.png" caption="Step 3" >}}

## Step 4

Add the federation hub's details, as derived from [metadata]({{< ref "/technical/metadata.md" >}}). The values you need to complete this step are:

| Field | Value |
|:----------------|:-|
| ACS URL         | https://iziko.safire.ac.za/module.php/saml/sp/saml2-acs.php/safire-sp |
| Entity ID       | https://iziko.safire.ac.za/ |
| Start URL       | *leave empty* |
| Signed Response | *unchecked* |
| Name ID         | Basic information / Primary Email |
| Name ID Format  | Persistent |

Which should then look something like this:
{{< figure src="/wp-content/uploads/2017/03/gapps_sso_step4.png" caption="Step 4" >}}

## Step 5

Add attribute mappings to map the G Suite directory attributes into SAML attributes [SAFIRE understands](/technical/attributes/). The mappings available are quite limited, but you should be able to map at least the required attributes.

{{< figure src="/wp-content/uploads/2017/03/gapps_sso_step5.png" caption="Step 5" >}}

Note that we've specified the mapping using urn:oid format, rather than the friendly names that get displayed. The four mappings shown above are as follows:

| Application attribute (OID)       | Category          | G Suite User Field | SAFIRE Name |
|:----------------------------------|:------------------|:-------------------|:------------|
| urn:oid:1.3.6.1.4.1.5923.1.1.1.6  | Basic information | Primary Email      | [eduPersonPrincipalName]({{< ref "/technical/attributes/edupersonprincipalname.md" >}}) |
| urn:oid:2.5.4.42                  | Basic information | First Name         | [givenName]({{< ref "/technical/attributes/givenname.md" >}}) |
| urn:oid:2.5.4.4                   | Basic information | Last Name          | [sn]({{< ref "/technical/attributes/sn.md" >}}) |
| urn:oid:0.9.2342.19200300.100.1.3 | Basic information | Primary Email      | [mail]({{< ref "/technical/attributes/mail.md" >}}) |

If you've [extended the schema](https://support.google.com/a/answer/6327792) in G Suite to store custom attributes, you may be able to make more mappings. (In particular, [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) would be desirable)

## Finishing up & turning on

If all worked successfully, you should get a confirmation message telling you the details were saved and reminding you to upload your metadata.

{{< figure src="/wp-content/uploads/2017/03/gapps_sso_fin.png" caption="Finished" >}}

After which you should have a new "SAFIRE" application listed. Note that by default this application is turned OFF. You will need to turn it on for those users or organisations you wish to authenticate.

# Edit the G Suite IdP metadata

Open the IdP metadata you saved in step 2 in your favourite text editor, and customise it for SAFIRE.

You'll need to add scoping and user interface details towards the top (just inside `<md:IDPSSODescriptor>`, before `<md:KeyDescriptor>`).

```xml
<md:Extensions>
  <mdui:UIInfo xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui">
    <mdui:DisplayName xml:lang="en">Example University</mdui:DisplayName>
    <mdui:Description xml:lang="en">Example University G Suite SSO</mdui:Description>
    <mdui:InformationURL xml:lang="en">https://example.ac.za/</mdui:InformationURL>
  </mdui:UIInfo>
  <shibmd:Scope xmlns:shibmd="urn:mace:shibboleth:metadata:1.0" regexp="false">example.ac.za</shibmd:Scope>
  <shibmd:Scope xmlns:shibmd="urn:mace:shibboleth:metadata:1.0" regexp="false">example.ac.za.test-google-a.com</shibmd:Scope>
</md:Extensions>
```

The `<shibmd:Scope>` elements should list all the domains and domain aliases you have configured in G Suite. You can, of course, add [other MDUI information](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-metadata-ui/v1.0/cs01/sstc-saml-metadata-ui-v1.0-cs01.html#__RefHeading__10385_1021935550) (such as a logo) too if you wish.

Next add another `<md:NameIDFormat>` stanza immediately under the existing one

```xml
<md:NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</md:NameIDFormat>
```

Finally, you will also need to add your organisation details and contact addresses towards the end (between the closing `</md:IDPSSODescriptor>` and the final `</md:EntityDescriptor>`)

```xml
<md:Organization>
  <md:OrganizationName xml:lang="en">Example University</md:OrganizationName>
  <md:OrganizationDisplayName xml:lang="en">Example University</md:OrganizationDisplayName>
  <md:OrganizationURL xml:lang="en">https://example.ac.za/</md:OrganizationURL>
</md:Organization>
<md:ContactPerson contactType="support">
  <md:GivenName>Example University Help Desk</md:GivenName>
  <md:EmailAddress>support@example.ac.za</md:EmailAddress>
  <md:TelephoneNumber>+27.21.763.0000</md:TelephoneNumber>
</md:ContactPerson>
<md:ContactPerson contactType="technical">
  <md:GivenName>Example University IdM</md:GivenName>
  <md:EmailAddress>idm@example.ac.za</md:EmailAddress>
</md:ContactPerson>
```

The resulting metadata should [validate correctly](https://validator.safire.ac.za/) and can be [submitted to the federation]({{< ref "/participants/idp/join.md" >}}).

