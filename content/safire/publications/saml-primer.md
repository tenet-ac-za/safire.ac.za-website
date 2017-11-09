---
title: SAML 101 - An intro to SAML for sysadmin
date: 2017-11-09 23:23:00+02:00
tags:
  - technical
  - saml2
---

This document intends to be a quick primer on SAML for those who want to get on with the rest of their todo list.

SAML seems big and scary, because it has a lot of decisions and moving parts. But the reality is that many of these decisions have already been made for you, and you don't need to know about the moving parts to make it work for you. Thus this document attempts to distill out the most important bits. Purists will probably tell you it massively over-simplifies things :-).
<!--more-->
## SAML?

SAML is the **Security Assertion Markup Language**, a security framework and open standard defined by [OASIS](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=security).

As a framework, there are many ways to deploy SAML --- but the only one that matters here is the [web browser single sign-on profile](https://en.wikipedia.org/wiki/SAML_2.0#Web_Browser_SSO_Profile) (**WebSSO**). Within WebSSO, there are many options one can choose. However the research & education community has pre-defined many of them in the [inter-operable SAML2 profile](https://saml2int.org/) (**SAML2int**). This is the subset of SAML most universities need to worry about, and that this document refers to.

## SAML vs Shibboleth

These days the terms "SAML" and "Shibboleth" are used interchangeably and mean the same thing. The former is more correct, because people are typically referring to SAML 2.0. Confusingly Shibboleth is both a precursor to the first version of SAML and also a [vendor of SAML software](http://shibboleth.net/). Use "SAML2" to avoid ambiguity and to keep the purists happy. Use "Shibboleth" when you talk to library information providers, since they're still catching up.

## What SAML does

Stripped to the bare essentials, a SAML transaction consists of three parts:

 1. An authentication (AuthN) request
 2. An authentication response
 3. Some [assertions](https://en.wiktionary.org/wiki/assertion) about the subject of the authentication, usually expressed as [attributes](/technical/attributes/).

Importantly SAML does **not** perform authorisation (AuthZ), although the information gleaned from the assertions may provide entitlement information that assists with this.

## How SAML works

### Information flow

[[todo:figure]]

An AuthN request flows from the service provider via the user's web browser and zero-or-more intermediaries to the identity provider's `SingleSignOnService`.

An AuthN response and any assertions are typically contained in the same message and flow from the identity provider to the service provider's `AssertionConsumerService` in the reverse direction to the request.

### Discovery

Sometimes, particularly in a federation, a service provider does not know which identity provider a user wishes to log into. It therefore allows the user to select which IdP they'd like to use, a process called **discovery**. (In older versions this was known as **WAYF**, standing for "where are you from".)

Depending on the architecture, the discovery service may or may not act as an intermediary in the SAML conversation. If it does, you can think of it as a form of proxy server.

### Transport protocol

There are many ways to transport a SAML request or response, and these are known as *bindings*.

Early implementations used a dedicated back channel with mutual certificate authentication for assertions. This was very secure, but also complicated to understand and difficult to debug. For this reason, current implementations prefer to hide this information in plain sight --- they use the user's browser as a transport, meaning that the entire protocol conversation is visible to the user.

This is typically done in one of two ways, known as the **HTTP-Redirect** and **HTTP-POST** bindings. You can probably safely ignore any other bindings.

Both these bindings work in essentially the same way, by passing information the same way web forms do. HTTP-Redirect does this as a query string in an HTTP GET request; as it's name suggests, HTTP-POST does this with an HTTP POST request. Sometimes both are implemented simultaneously.

Authentication responses and assertions passed via a user's browser must be [cryptographically signed](https://en.wikipedia.org/wiki/Digital_signature) to prevent them from being altered en-route. This is done in a standards-based way with [xmldsig](https://www.w3.org/TR/xmldsig-core/), using information from [metadata](#saml-metadata).

The SAML protocol also allows for the messages to be encrypted, but most deployments prefer to rely on the underlying HTTP encryption (https://). There's no loss of security in transit but it makes debugging much easier because messages are available in-the-clear in the user's browser.

### Messages

SAML messages are structured as XML. However, just as you don't need to know how DNS or LDAP is encoded on the wire, most people typically don't need to understand the structure of SAML messages :-). It suffices to know how to capture them.

There are browser plugins available for both [FireFox](https://addons.mozilla.org/en-US/firefox/addon/saml-tracer/) and [Chrome](https://chrome.google.com/webstore/detail/saml-message-decoder/mpabchoaimgbdbbjjieoaeiibojelbhm) that will allow you to easily capture and view SAML messages. Both also allow the conversations to be exported as JSON, to allow you to easily share them with others who may be helping you.

The rest of this section is provided for interest, and you can probably skip to the [section on metadata](#saml-metadata) if you want.

If you do ever delve in, [samltools.com](https://www.samltool.com/) have a number of useful [online tools for decoding and debugging](https://www.samltool.com/online_tools.php) SAML conversations.

#### A brief look at a SAML message

A typical authentication (AuthN) requests looks like this:
```xml
<samlp:AuthnRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                    AssertionConsumerServiceURL="https://testsp.safire.ac.za/Shibboleth.sso/SAML2/POST"
                    Destination="https://idp.example.ac.za/simplesaml/saml2/idp/SSOService.php"
                    ID="_d6cdaadc224fa7ef1b2867bcf06cbe72"
                    IssueInstant="2017-11-09T19:07:41Z"
                    ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
                    Version="2.0">
  <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">https://testsp.safire.ac.za/Shibboleth.sso/Metadata</saml:Issuer>
  <samlp:NameIDPolicy AllowCreate="1" /></samlp:AuthnRequest>
```
Arguably the most important thing to note in the above message is the `IssueInstant` (see [time](#time)).

The `saml:Issuer` tells you who sent the request, and the `Destination` tells you where it is going. The `AssertionConsumerServiceURL` tells the IdP where the SP would like the response to go (whether it honours that depends on its configuration).

A SAML response is typically more complicated (and therefore longer), because it contains both assertions about the subject and a cryptographic signature. A stripped down version looks like this:
```xml
<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                ID="z6ea3a28b872a4208b5d949f63d1def38fa4a536e"
                Version="2.0"
                IssueInstant="2017-11-09T19:07:48Z"
                InResponseTo="_d6cdaadc224fa7ef1b2867bcf06cbe72"
                Destination="https://testsp.safire.ac.za/Shibboleth.sso/SAML2/POST">
  <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">https://idp.example.ac.za/idp/shibboleth</saml:Issuer>
  <samlp:Status>
    <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success" /></samlp:Status>
  <saml:Assertion>
    …
  </saml:Assertion>
</samlp:Response>
```
with the ellipsis replacing the full assertion and all the attributes.

Note the `samlp:Status` showing the AuthN was successful, and the `InResponseTo` showing this was a response to the previous AuthnRequest.

#### Encoding of SAML messages

In order to make the XML messages suitable for transporting in an HTML form, the XML messages are first compressed using the [DEFLATE](https://en.wikipedia.org/wiki/DEFLATE) mechanism and then [Base64 encoded](https://en.wikipedia.org/wiki/Base64). Finally they are [URL-encoded](https://www.w3schools.com/tags/ref_urlencode.asp), and then sent as well-known parameters in a GET or POST request.

For the HTTP-Redirect binding, this encoding results in a long and complicated URL that looks a bit like this:
```
https://idp.example.ac.za/saml2/idp/SSOService.php?SAMLRequest=lZJLb8IwEIT%2FSuQ7cWxABYtESkFVkaBEJO2hl8pJTGM1sVOv0we%2FvnlQFS5Ive6Ov9kZeQG8KmsWNrZQe%2FHeCLDOV1UqYP3CR41RTHOQwBSvBDCbsTjcbhh1PVYbbXWmS%2BSEAMJYqdVSK2gqYWJhPmQmHvcbHxXW1sAwti0cahf4QRrh8sw9chwXMk11KWzhAmjcoSmOdnGCnFUrl4p31D%2BGPMo3fYnoDqVY5jWO493J162LGjl32mSij%2BYjgpz1ykcvZDqejD3iZd445yn1%2BHROSTsUM3KYUj5pZQCNWCuwXFkfUY%2FcjAgZefOEzBmdMDJ7Rk50Sn4rVS7V6%2FWa0kEE7D5JotEQ7kkY6IO1AhQsugysNzZn9V%2FH8t%2FOUfCPhrfC8pxbvsBnnsMBNXtoTdarSJcy%2B3bCstSfSyO4FV19OBieXH6W4Ac%3D&RelayState=ss%3Amem%3A28c66a83dc351b96150b6b3fe0c1211680a975b2eafa56f674960611d4853944&SigAlg=http%3A%2F%2Fwww.w3.org%2F2001%2F04%2Fxmldsig-more%23rsa-sha256&Signature=S8Rua5hRBqbxDRYr%2FpzZqZrZltG41q8ySC0AHrNmmUboVb8S0Vk2pCKPgiO568pQCZzhymU49irpJQtLxLiG2539V66f0uPMD1U04h%2Bp0eSi3amf%2BqNoxvy3UxFlZlonGuTlX2fo68rVlU1L%2BWfTcTTVC2tXlzHxCjP9NVINIXHoMgqbhkTPM1FFonJwo51yMMv4%2Bsd4DAiTcyBfROPTrDVanXU37b92eaa5Gq2wPONuX2JQas%2FYT2WFkARWnmWPXsLXw%2FBhYj7r5cJ98fcgX1I%2FfkckSmsYwDh7gDrvA9gCnlAka0wNPPSqlf58hBPX%2Fb1yg9LWC%2FuaNAuHOqydcQ%3D%3D
```
The well-known parameters are `SAMLRequest` for a SAML request, `SAMLResponse` for a SAML response, `Signature` for the xmldsig signature, `SigAlg` for information about the signature algorithm, and `RelayState` as an opaque internal state variable used by the provider.

### Single logout

One of SAML's weaknesses is poor support for single logout --- that is for a logout at one service provider to be able to initiate a logout at every other one for the same SSO session. Whilst the protocol supports it, its implementation varies considerably and is sometimes non-existent. [Much has been written about this subject](https://www.google.co.za/search?q=saml+single+logout).

## SAML metadata

In order for the protocol to work, both parties need to know stuff about each other. The service provider needs to know where to send an AuthN request, and the identity provider needs to know where to send a response and any assertions. In addition, in order for signing and encryption to work, the two parties need to share public keys. This is achieved by means of SAML metadata.

Like the messages, SAML metadata is XML. In a federated environment, you supply your metadata to the federation and get metadata for other participants from the federation.

Federation metadata is typically cryptographically signed using xmldsig so that you can be sure it is trustworthy. However, once you've validated the signature, you can do whatever transformations you need to make the metadata useful to you.

### EntityID

Every entity in metadata must have a unique identifier, known as an **EntityID**. In the SAML spec, these are free-form. However convention says we structure them in the form of a URL as a well-known location. Typically the host portion of the URL should be the FQDN of the server hosting the entity.

You normally refer to a specific identity- or service provider by its EntityID, and this information is useful to others trying to debug a problem.

### RoleDescriptors

SAML metadata contains RoleDescriptors that explain what the entity being described does. The two that are most relevant are `IDPSSODescriptor` for an identity provider and `SPSSODescriptor` for a service providers.

Your metadata may contain other RoleDescriptors (particularly if it is from AD FS), but you can probably ignore these.

Some parts of a RoleDescriptor share information (like an service name or an X.509 certificate) whereas others act like access control lists (e.g. the AssertionConsumerService list in an IdP's copy of an SP's metadata). Understanding the structure of metadata is beyond the scope of this document, but is more useful than understanding protocol SAML messages.

## Security --- signing and encryption

Both SAML signing and encryption use [public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography), and transport a public key encoded as a [certificate](https://en.wikipedia.org/wiki/Public_key_certificate).

There are two ways to validate such a certificate: using [public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) (PKI) or by pre-sharing a public key to create "explicit key trust". The later is done by means of including the certificate in metadata, and is the preferred method for our purposes. Because it is defined in the [metadata inter-operablity profile](https://wiki.oasis-open.org/security/SAML2MetadataIOP) the explicit key trust model is sometime known as **MetaIOP**. In general, when presented with a choice you should choose MetaIOP.

Because it does not rely on PKI, certificates for SAML [do not need to be signed by a certificate authority]({{< ref "/technical/resources/generating-certificates-for-safire.md#saml-signing-certificate" >}}) (and in fact, should not). Likewise, in this configuration, the expiry date of a certificate is technically irrelevant --- but poor software implementations mean you should make sure your certificate is always valid.

(The certificates you use to [secure your web server]({{< ref "/technical/resources/generating-certificates-for-safire.md#web-server-certificate" >}}), however, do require PKI and *must* be signed by a trusted certificate authority and *must* be valid.)

## Attributes

Arguably the most useful part of SAML is its ability to transport rich information about a data subject (user). This is done by means of attributes, and both parties need to [agree on what these mean](/technical/attributes/) before they're useful.

The SAML metadata defines what attributes a service provider would like, and where the identity provider should send them. An identity provider is free to send whatever attributes it wants, although federations typically have [standards that identity providers must comply with](technical/saml2/idp-requirements/).

### Attribute naming

SAML supports different name formats, but for these purposes the only one that matters is [Object Identifiers](https://en.wikipedia.org/wiki/Object_identifier) (OIDs) represented in [URN](https://en.wikipedia.org/wiki/Uniform_Resource_Name) space. Whilst that may sound complicated, its the same representation used internally by many protocols, including RADIUS and LDAP.

In a SAML response on the wire, a SAML assertion for an attribute looks like this:
```xml
<saml:Attribute Name="urn:oid:1.3.6.1.4.1.5923.1.1.1.16"
                FriendlyName="eduPersonOrcid"
                NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">
    <saml:AttributeValue xsi:type="xs:string">https://orcid.org/0000-0002-1825-0097</saml:AttributeValue>
</saml:Attribute>
```
You can see the attribute's name is the URN-encoded OID `urn:oid:1.3.6.1.4.1.5923.1.1.1.16` which corresponds to the attribute more familiarly known as [eduPersonOrcid]({{<ref "/technical/attributes/edupersonorcid.md">}}).

### Attribute values

The structure of an attribute's values depends on the specific definition of the attribute, and may vary from provider to provider. Some, like the eduPersonOrcid above, are well defined and can be easily validated whereas others are free-form. Likewise, some attributes can only contain a single value whereas others may contain many related values.

Most federations [provide guidance](/technical/attributes/) on both attribute naming and their corresponding values.

### NameIDs

Subject name identifiers or **NameID**s are special SAML2 attributes that are specifically intended to act as a primary key or username to identify the data subject (user).

There are several forms for these, but the important ones are **transient** and **persistent** NameIDs.

 * A transient NameID is intended to be ephemeral, and doesn't last beyond the current session. It is the most common form of NameID.

 * A persistent NameID is intended to persist between sessions, but is not necessarily portable between service providers. In its most common form, the persistent NameID contains the same value as the deprecated [eduPersonTargetedId]({{< ref "/technical/attributes/edupersontargetedid.md" >}}) attribute.

You should use a NameID in preference to an attribute whereever a "username" is required.

## Time

Time and clocks get a special mention here because, like many authentication protocols, SAML is heavily reliant on accurate time. SAML responses typically indicate a validity period:
```xml
<saml:Conditions NotBefore="2017-11-09T19:07:17Z"
                 NotOnOrAfter="2017-11-09T19:12:47Z">
```
The difference between `NotBefore` and `NotOnOrAfter` is usually about five minutes. This means that a clock difference of even a few minutes between an identity provider and a service provider will cause authentication to fail.
