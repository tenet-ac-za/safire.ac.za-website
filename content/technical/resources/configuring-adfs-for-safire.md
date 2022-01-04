---
date: 2022-01-04 15:18:00+02:00
slug: configuring-adfs-for-safire
tags:
  - adfs
  - configuration
  - metadata
  - technical
title: Configuring ADFS for SAFIRE
url: /technical/resources/configuring-adfs-for-safire/
---

*Note: While it is possible to use ADFS with SAFIRE, it has known interoperatability problems with the [sort of multi-party federation used in the R&E world]({{< ref "/technical/saml2/deployment-profiles.md" >}}). SAFIRE's architecture shields you from some of these effects, but you do sacrifice some flexibility and control.*

In order to configure Active Directory Federation Services (ADFS) as an identity provider for SAFIRE, you need to do four things:

  1. Create a Relying Party Trust that fetches the [federation hub's metadata](https://metadata.safire.ac.za/safire-hub-metadata.xml) from https://metadata.safire.ac.za/safire-hub-metadata.xml
  2. Configure claim rules to map AD LDAP attributes to [SAFIRE's attributes]({{< ref "/technical/attributes/_index.md" >}})
  3. Configure a claim rule to [generate eduPersonAffiliation]({{< ref "/technical/resources/generating-edupersonaffiliation.md" >}}) from some internal role mapping
  4. Configure a claim rule to generate a transient NameID and then map this internal claim as a Name ID of type urn:oasis:names:tc:SAML:2.0:nameid-format:transient

## Scripted configuration

> Ensure you [make adequate backups](https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/operations/ad-fs-rapid-restore-tool) before executing any script from this site

You can use PowerShell to configure ADFS, and there is a sample [add-safire-relyingparty.ps1](/wp-content/uploads/2016/12/add-safire-relyingparty.ps1.txt) script to automatically add SAFIRE as a relying party.

This script needs one piece of information from you --- your primary DNS domain name, which will be used to configure scopes on those attributes that require it. It can be specified as -idpScope or you will be prompted for it.

The script creates a Claim Issuance Policy that generates as many of SAFIRE's attributes as possible from the default AD schema, including all the [recommended attributes]({{< ref "/technical/attributes/_index.md" >}}). If you have other values in your AD that map to other SAFIRE attributes, you should consider adding those mappings to.

Without knowing about your internal structure, it is impossible for the script to [generate a complete eduPersonAffiliation]({{< ref "/technical/resources/generating-edupersonaffiliation.md" >}}). If you look through the script, you will find a  "Transform Group to eduPersonAffiliation" rule that adds all members of the Domain Users group as members of your organisation ([case 5]({{< ref "/technical/resources/generating-edupersonaffiliation.md#case-5-everyone-is-a-member" >}})). This rule can be expanded or adapted to better fit your situation (cf [case 2]({{< ref "/technical/resources/generating-edupersonaffiliation.md#case-2-group-membership" >}})). For instance, the "Domain Users" group can be changed to one that better fits your environment. Likewise, you may have groups that reflect the other values in the [eduPersonAffiliation vocabulary]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}).

Note the script does not handle the [certificate considerations]({{< relref "#certificate-considerations" >}})


## Claim Descriptions

Whilst not strictly necessary, you can also add user-friendly claim descriptions to the new claims we've created. This makes them display better in the AD FS Management interface.

The following PowerShell snippet adds a claim description for the [eduPersonPrincipalName]({{< ref "/technical/attributes/edupersonprincipalname.md" >}}) attribute:

```powershell
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.6" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
    Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.6" `
      -Name "eduPerson Principal Name" `
      -IsAccepted:$true `
      -IsOffered:$true `
      -IsRequired:$false `
      -Notes "A scoped identifier for a person. It should be represented in the form 'user@scope' where 'user' is a name-based identifier for the person and where 'scope' defines a local security domain. Each value of 'scope' defines a namespace within which the assigned identifiers MUST be unique. Given this rule, if two eduPersonPrincipalName (ePPN) values are the same at a given point in time, they refer to the same person. There must be one and only one '@' sign in valid values of eduPersonPrincipalName."
}

```

An example [claim-descriptions.ps1](/wp-content/uploads/2016/12/claim-descriptions.ps1.txt) PowerShell script that adds descriptions for all of SAFIRE's attributes is available to help you with this.

# Certificate considerations

Microsoft refers to the [certificates used in SAML]({{< relref "generating-certificates-for-safire.md#saml-signing-certificate" >}}) as "token signing certificates". By default AD FS is configured to generate token signing certificates automatically, and to renew them annually.

Unfortunately certificate roll-over in an multi-party federation is non-trivial (it doesn't work like a web server), and we generally [recommend]({{< relref "generating-certificates-for-safire.md#saml-signing-certificate" >}}) that long-lived certificates are used. This can be achieved in AD FS by [changing the CertificateDuration parameter](https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/operations/configure-ts-td-certs-ad-fs).

The [supplied PowerShell]({{< relref "#scripted-configuration" >}}) does not do this for you, since that may affect other trust relationships you have in AD FS. However, you can do this from an elevated PowerShell session as follows:

```powershell
# Set certificate validty to ten years to match SAFIRE recommendations
Set-AdfsProperties -CertificateDuration "3652"
# Issue a new certificate
# NB: this will immediately roll over your existing certificate - do not do this if your certificate is in production
Update-AdfsCertificate -CertificateType Token-Signing –Urgent
```

AD FS also uses a second "token encryption" certificate to encrypt assertions. Doing this is **not recommended** as the attributes are already protected by the HTTPS transport, and additional encryption makes debugging harder. The [supplied PowerShell]({{< relref "#scripted-configuration" >}}) disables this, and you can disable encryption manually by looking on the Encryption tab of the SAFIRE Relying Party in ADFS and removing the certificate for encryption.

# Improving generated metadata

By default, ADFS publishes its generated metadata at a well-known URL of:

* https://*your-adfs-server.example.ac.za*/FederationMetadata/2007-06/FederationMetadata.xml

You can use this to obtain the copy of metadata you need to supply to SAFIRE. However, but default the auto-generated metadata does not include many of the [required elements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}).

You can improve the generated metadata (and thus require less editing) by providing ADFS with some information about your organisation. To do this, open AD FS Management, select the service and then click on _Edit Federation Service…_. In the resulting properties dialogue, complete the organisational information on the _Organization_ tab and check the _Publish organization information in federation metadata_ checkbox.

Note that you'll still need to add your contacts and some of the MDUI elements (such as your logo URL and privacy statement) by hand before sending your metadata to SAFIRE. We're not aware of any way to get ADFS to add these automatically.

# Other technical requirements

There are two additional [technical requirements]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}) that the [supplied PowerShell]({{< relref "#scripted-configuration" >}}) script does not configure.

## Logging requirements

By default, Windows rotates the event log based on size whereas the technical requirements specify a minimum retention period. Thus it is possible that you will delete logs earlier than you're supposed to. You will need to adjust the event logging properties for your server to ensure you retain logs as specified in the technical requirements.

You should change your Log retention policy to "Archive the log when full, do not overwrite events." and set a suitable maximum log size to ensure you retain the full period required. You may need to make sure you've allocated sufficient disk space for logging to store this.

## Time synchronisation

Modern versions of Windows server do syncronise time, but this may be changed by your local group policy. Please ensure your server is set to synchronise time against a reliable timesource (such as [za.pool.ntp.org](https://www.ntppool.org/zone/za)).

## Multi-factor authentication

To enable support multi-factor authentication for your users, you will need to explicitly confirm that the authentication methods you've enabled are compatible with academic federation. See [authnmethodsreferences]({{< ref "/technical/attributes/authnmethodsreferences.md" >}}) for details.
