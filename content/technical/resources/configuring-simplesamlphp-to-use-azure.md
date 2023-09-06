---
date: 2023-09-06 13:00:00+02:00
slug: configuring-simplesamlphp-to-use-azure 
tags:
  - azure
  - configuration
  - metadata
  - simplesamlphp
  - technical
title: Configuring SimpleSAMLphp to use Azure-AD as an Authentication source
url: /technical/resources/configuring-simplesamlphp-to-use-azure
---

This documentation will guide you through the Azure Active Directory (Azure AD) configuration process as an authentication source in SimpleSAMLphp. By integrating Azure AD in this way, you can retain your users' familiar login experience while leveraging SimpleSAMLphp's flexibility to fetch and/or manipulate attributes from Azure AD and other sources.

While SAFIRE can directly work with Azure AD or SimpleSAMLphp (as explained in our [Configuring Azure AD SAML-based SSO for SAFIRE]({{< ref "/technical/resources/configuring-azure-ad-for-safire.md" >}}) and [Configuring SimpleSAMLphp for SAFIRE]({{< ref "/technical/resources/configuring-simplesamlphp-for-safire.md" >}}) documentation), you may find yourself in a situation where this approach better fits your use case.

Below, you'll find an example demonstrating how to configure SimpleSAMLphp to use the attributes received from Azure AD to search for and assert additional attributes for a user from an LDAP source of an on-prem Active Directory.
 
NOTE: This documentation assumes you already have an Azure AD tenant correctly configured and provisioned with your institution’s user accounts. Further, SimpleSAMLphp has good documentation, so this is not a complete/worked example of how to configure it. Instead, this provides the specific snippets you may need when working through SimpleSAMLphp’s documentation. Thus, this document also assumes you have SimpleSAMLphp installed and reachable with the basics configured.

To configure SimpleSAMLphp to use your Azure AD IdP as an Authentication Source, you will need to complete the following:

 1. Configure a SimpleSAMLphp SAML 2.0 Service Provider (SP)
 2. Configure SimpleSAMLphp SAML 2.0 Identity Provider (IdP)
 3. Create a new Enterprise Application
 4. Set up single sign-on
 5. Configure Attribute claims rules.
 6. Configure SimpleSAMLphp to use the Azure AD IdP as an authentication source.
 7. Add attributes from another source (in this case, LDAP).
 8. Configure SimpleSAMLphp internal SP to test.

To start, consider the following diagram on establishing a bilateral trust relationship between Azure AD and SimpleSAMLphp: 

![Azure AD and SimpleSAMLphp bilateral trust](/wp-content/uploads/2023/09/azure-ssp-bilateral.png)
                           
_fig 1.1_
