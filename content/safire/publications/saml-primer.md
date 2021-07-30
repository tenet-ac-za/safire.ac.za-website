---
title: SAML 101 - An intro to SAML for sysadmin
date: 2018-03-22 09:06:00+02:00
tags:
  - technical
  - saml2
keywords:
  - SAML2
  - SAML primer
  - introduction
  - lesson
---

This document intends to be a quick primer on SAML for those who want to get on with the rest of their todo list.

SAML seems big and scary, because it has a lot of decisions and moving parts. But the reality is that many of these decisions have already been made for you, and you don't need to know about the moving parts to make it work for you. Thus this primer attempts to distill out the most important bits in a way that's easy to skim.
<!--more-->

Purists will probably tell you it massively over-simplifies things. That's exactly what it sets out to do ;-).

## 1. SAML?

SAML is the **Security Assertion Markup Language**[^saml-oasis]. As a framework, there are many ways to deploy SAML --- but the only one that matters here is the [web browser single sign-on profile](https://en.wikipedia.org/wiki/SAML_2.0#Web_Browser_SSO_Profile) (**WebSSO**). Within WebSSO, there are many options one can choose. However the research & education community has pre-defined many of them in the [interoperable SAML2 profile](https://saml2int.org/) (**SAML2int**). This is the subset of SAML most universities need to worry about, and that this document refers to.

## 2. SAML vs Shibboleth

These days the terms "SAML" and "Shibboleth" are used interchangeably and mean the same thing. The former is more correct, because people are typically referring to SAML 2.0. Confusingly Shibboleth is both a precursor to the first version of SAML[^shib] and also a [vendor of SAML software](http://shibboleth.net/). Use "SAML2" to avoid ambiguity and to keep the purists happy. Use "Shibboleth" when you talk to library information providers, since they're still catching up.

## 3. What SAML does

Stripped to the bare essentials, a SAML transaction consists of three parts:

 1. An authentication (AuthN) request
 2. An authentication response
 3. Some [assertions](https://www.collinsdictionary.com/dictionary/english/assertion) about the subject of the authentication, usually expressed as [attributes]({{< ref "/technical/attributes/_index.md" >}}).

Importantly SAML does **not** perform authorisation (AuthZ), although the information gleaned from the assertions may provide entitlement information that assists with this.

## 4. How SAML works

### Information flow

[{{< figure src="/wp-content/uploads/2017/11/WebSSO-Flows.svg" caption="WebSSO Information Flow" >}}](/wp-content/uploads/2017/11/WebSSO-Flows.svg)

A flow typically starts when a user clicks the "login" button on a service provider's web page[^idp-init].

An AuthN request flows from the service provider via the user's web browser and zero-or-more intermediaries to the identity provider's `SingleSignOnService`.

An AuthN response and any assertions are typically contained in the same message and flow from the identity provider to the service provider's `AssertionConsumerService` in the reverse direction to the request.

### Discovery

Sometimes, particularly in a federation, a service provider does not know which identity provider a user wishes to log into. It therefore allows the user to select which IdP they'd like to use, a process called **discovery**. (In older versions this was known as **WAYF**, standing for "where are you from".)

Depending on the architecture, the discovery service may or may not act as an intermediary in the SAML conversation. If it does, you can think of it as a form of proxy server.

### Transport protocol (bindings)

There are many ways to transport a SAML request or response, and these are known as **bindings**.

Early implementations used a dedicated back channel with mutual certificate authentication for assertions. This was very secure, but also complicated to understand and difficult to debug. For this reason, current implementations prefer to hide this information in plain sight --- they use the user's browser as a transport, meaning that the entire protocol conversation is visible to the user.

This is typically done in one of two ways, known as the **HTTP-Redirect** and **HTTP-POST** bindings. You can probably safely ignore any other bindings.

Both these bindings work in essentially the same way, by passing information the same way web forms do. HTTP-Redirect does this as a query string in an HTTP GET request; as it's name suggests, HTTP-POST does this with an HTTP POST request. Sometimes both are implemented simultaneously.

Authentication responses and assertions passed via a user's browser must be [cryptographically signed](https://en.wikipedia.org/wiki/Digital_signature) to prevent them from being altered en-route. This is done in a standards-based way with [xmldsig](https://www.w3.org/TR/xmldsig-core/), using information from [metadata]({{< ref "#5-saml-metadata" >}}).

The SAML protocol also allows for the messages to be encrypted, but most deployments prefer to rely on the underlying HTTP encryption (https://). There's no loss of security in transit but it makes debugging much easier because messages are available in-the-clear in the user's browser.

### Messages

Messages in the SAML protocol are structured as XML. However, just as you don't need to know how DNS or LDAP is encoded on the wire, most people typically don't need to understand the structure of SAML messages :-). It suffices to know how to capture them.

There are browser plugins available for both [FireFox](https://addons.mozilla.org/en-US/firefox/addon/saml-tracer/) and [Chrome](https://chrome.google.com/webstore/detail/saml-message-decoder/mpabchoaimgbdbbjjieoaeiibojelbhm) that will allow you to easily capture and view SAML messages. Both also allow the conversations to be exported as JSON, to allow you to easily share them with others who may be helping you. Think of them as [tcpdump](http://www.tcpdump.org/) for SAML.

The rest of this section is provided for interest or future reference, and you can probably skip to the [section on metadata]({{< ref "#5-saml-metadata" >}}) if you want.

If you do ever delve in, [samltools.com](https://www.samltool.com/) have a number of useful [online tools for decoding, validating and debugging](https://www.samltool.com/online_tools.php) SAML conversations. Think of these tools as [Wireshark](https://www.wireshark.org/) for SAML.

#### A brief look at a SAML message

A typical authentication (**AuthN**) requests looks like this:
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
Arguably the most important thing to note in the above message is the `IssueInstant` (see [time]({{< ref "#8-time" >}})).

The `ID` uniquely identifies this message, and is used like an email Message-Id to link transactions together. The `saml:Issuer` tells you who sent the request, and the `Destination` tells you where it is going. The `AssertionConsumerServiceURL` tells the IdP where the SP would like the response to go (whether it honours that depends on its configuration).

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

One of SAML's weaknesses is poor support for single logout (**SLO**) --- that is for a logout at one service provider to be able to initiate a logout at every other one for the same SSO session. Whilst the protocol supports it, its implementation varies considerably and is sometimes non-existent. [Much has been written about this subject](https://www.google.co.za/search?q=saml+single+logout).

## 5. SAML metadata

In order for the protocol to work, both parties need to know stuff about each other. The service provider needs to know where to send an AuthN request, and the identity provider needs to know where to send a response and any assertions. In addition, in order for signing and encryption to work, the **[relying parties](https://en.wikipedia.org/wiki/Relying_party)** need to share public keys. This is achieved by means of SAML metadata.

Like the messages, SAML metadata is XML and has lots of options. Fortunately we only need to care about the subset defined in the [metadata interoperablity profile](https://wiki.oasis-open.org/security/SAML2MetadataIOP) (**MetaIOP**) and a very small set of metadata extensions.

Unlike the messages, it does pay to have some understanding of the basic structure of metadata. Fortunately, however, many federations provide [documentation]({{< ref "/technical/saml2/_index.md" >}}) on their metadata requirements and often a [metadata template](/wp-content/uploads/2016/12/metadata.xml) too.

In a federated environment, you supply your metadata to the federation and get metadata for other participants from the federation.

### Generation and editing

Most SAML software can automatically generate metadata. However, unless this is done with a template, the auto-generated metadata tends to contain extraneous elements (for instance, AD FS inserts many [RoleDescriptors]({{< ref "#roledescriptors" >}}) that are not relevant under SAML2int and MetaIOP; Shibboleth includes old SAML1 elements).

Unsigned metadata can (and probably should) be edited to ensure it only contains those elements that are relevant. Metadata is just UTF-8 encoded text, and can be edited with any modern text editor.

One thing that characterises SAML federations is that they have high-quality, hand curated metadata. Most federations will have specific normalization and [validation](https://validator.safire.ac.za/) requirements, and may do some of the heavy lifting for you.

Federation metadata is typically cryptographically signed using xmldsig so that you can be sure it is trustworthy. This means you *cannot edit it without breaking the signature*. However, once you've validated the signature, your SAML software can do whatever transformations you need to make the metadata useful to you.

### General structure

SAML metadata consists of one or more **EntityDescriptor**s. Each EntityDescriptor is identified by an [`EntityID`]({{< ref "#entityid" >}}), and contains some information about the federation that registered it followed by one or more [`RoleDescriptor`s]({{< ref "#roledescriptors" >}}). Towards the end of the metadata is information about the Organization it refers to and some Contact information. Both the EntityDescriptor and individual RoleDescriptors can include Extensions.

#### EntityID

Every entity in metadata must have a unique identifier, known as an **EntityID**. In the SAML spec, these are free-form. However [convention](https://wiki.shibboleth.net/confluence/display/CONCEPT/EntityNaming) says we structure them in the form of a URL as a well-known location. Typically the host portion of the URL should be the FQDN of the server hosting the entity.

You normally refer to a specific identity- or service provider by its EntityID, and this information is useful to others trying to debug a problem.

You should not change an EntityID without carefully considering the consequences.

#### RoleDescriptors

SAML metadata contains `RoleDescriptor`s that explain what the entity being described does. The two that are most relevant are `IDPSSODescriptor` for an identity provider and `SPSSODescriptor` for a service providers.

Your metadata may contain other RoleDescriptors (particularly if it is from AD FS), but you can probably ignore and/or delete these.

Some parts of a RoleDescriptor share information (like an service name or an X.509 certificate) whereas others act like access control lists (e.g. the AssertionConsumerService list in an IdP's copy of an SP's metadata). Your SAML software's documentation will provide guidance on this.

#### Scope

An `IDPSSODescriptor` can (and should) contain one or more `<shibmd:Scope>` elements in Extensions. These are much the same as realms in RADIUS, and often directly match. They are structured as FQDNs but, like realms, they do not need to exist in DNS. The Scope elements in metadata are used by federation participants to validate any attributes that contain a realm/domain/scope (e.g. [eduPersonPrincipalName]({{<ref "/technical/attributes/edupersonprincipalname.md" >}})).

The specification for the Scope element allows for these to be defined by regular expressions, however in practice few service providers support these. Rather include multiple Scope elements defining all possible scopes for your users.

#### MDUI

A widely used extension to the basic SAML metadata is the Metadata Extensions for Login and Discovery User Interface (**MDUI**). These provide additional elements such as service descriptions and logos to make the login and discovery processes simpler and more user-friendly. Federations typically have specific recommendations around MDUI, and there are also some [federation non-specific recommendations](https://wiki.refeds.org/display/FBP/MDUI+Advice) available.

#### EntityCategories

Another widely used extension are [EntityCategories](https://wiki.refeds.org/display/ENT/Entity-Categories+Home), a subset of the Metadata Extension for Entity Attributes. As their name suggests, they're used to group and categories different entities that share common criteria.

Arguably the most important EntityCategory, and the only one you really need to concern yourself with, is the [Research & Scholarship](https://wiki.refeds.org/display/ENT/Research+and+Scholarship+FAQ) one. This groups entities who's main purpose is supporting or furthering the aims of the research & education community, and has a [specific definition](https://refeds.org/category/research-and-scholarship) available. It is used to manipulate attribute release.

## 6. Security --- signing and encryption

Both SAML signing and encryption use [public key cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography), and transport a public key encoded as a [certificate](https://en.wikipedia.org/wiki/Public_key_certificate).

There are two ways to validate such a certificate: using [public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) (PKI) or by pre-sharing a public key to create "explicit key trust". The later is done by means of including the certificate in metadata, and is the preferred method for our purposes. Because it is defined in the metadata the explicit key trust model is sometime erroneously known as **MetaIOP**. In general, when presented with a choice you should choose explicit trust/metadata/MetaIOP.

Because it does not rely on PKI, certificates for SAML [do not need to be signed by a certificate authority]({{< ref "/technical/resources/generating-certificates-for-safire.md#saml-signing-certificate" >}}) (and in fact, should not). Likewise, in this configuration, the expiry date of a certificate is technically irrelevant --- but poor software implementations mean you should make sure your certificate is always valid!

(The certificates you use to [secure the public facing parts of your web server]({{< ref "/technical/resources/generating-certificates-for-safire.md#web-server-certificate" >}}), however, do require PKI and *must* be signed by a trusted certificate authority and *must* be valid. The requirements for these are the same as any other secure website.)

## 7. Attributes

Arguably the most useful part of SAML is its ability to transport rich information about a data subject (user). This is done by means of attributes, and both parties need to [agree on what these mean]({{< ref "/technical/attributes/_index.md" >}}) before they're useful.

The SAML metadata defines what attributes a service provider would like, and where the identity provider should send them. An identity provider is free to send whatever attributes it wants, although federations typically have [standards that identity providers must comply with]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}).

### Attribute naming

SAML supports different name formats, but for these purposes the only one that matters is [Object Identifiers](https://en.wikipedia.org/wiki/Object_identifier) (OIDs) represented in [URN](https://en.wikipedia.org/wiki/Uniform_Resource_Name) space. Whilst that may sound complicated, its the same representation used internally by many protocols, including RADIUS and LDAP.  Most SAML software will automatically map attributes into to more friendly and familiar names so that you never need to deal with the OID form directly (just as you don't deal with OIDs in LDAP).

In a SAML response on the wire, a SAML assertion for an attribute looks like this:
```xml
<saml:Attribute Name="urn:oid:2.5.4.42"
                FriendlyName="givenName"
                NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">
    <saml:AttributeValue xsi:type="xs:string">Vuyo</saml:AttributeValue>
</saml:Attribute>
```
You can see the attribute's name is the URN-encoded OID `urn:oid:2.5.4.42` which corresponds to the attribute more familiarly known as [givenName]({{<ref "/technical/attributes/givenname.md">}}).

By convention we use the same OIDs that are defined in various LDAP schemas such as [inetOrgPerson](https://tools.ietf.org/html/rfc2798) and [eduPerson](https://www.internet2.edu/products-services/trust-identity/eduperson-eduorg/), and the `FriendlyName` matches the LDAP attribute name.

Note that the naming format used in the R&E space is different from the standard AD FS claims, and so AD FS users need to [specifically add support for OIDs]({{< ref "/technical/resources/configuring-adfs-for-safire.md" >}}).

### Attribute values

The structure of an attribute's values depends on the specific definition of the attribute, and may vary from provider to provider. Some are well defined and can be easily validated whereas others, like the *givenName* above, are free-form. Likewise, some attributes can only contain a single value whereas others may contain many related values.

Most federations [provide strict guidelines]({{< ref "/technical/attributes/_index.md" >}}) on both attribute naming and their corresponding values. This ensures a common understanding and interoperability.

### NameIDs

Subject name identifiers or **NameID**s are special SAML2 attributes that are specifically intended to act as a primary key or username to identify the data subject (user).

There are several forms for these, but the important ones are **transient** and **persistent** NameIDs.

 * A transient NameID is intended to be [ephemeral](https://www.collinsdictionary.com/dictionary/english/ephemeral), and doesn't last beyond the current session. It is the most common form of NameID.

 * A persistent NameID is intended to persist between sessions, but is not necessarily portable between service providers. In its most common form, the persistent NameID contains the same value as the deprecated [eduPersonTargetedId]({{< ref "/technical/attributes/edupersontargetedid.md" >}}) attribute.

You should use a NameID in preference to an attribute wherever a "username" is required.

#### Identifier terminology

Documentation comparing various types of usernames, distinguished names, or name identifiers often uses specific terminology that may be unfamiliar to a layman. Below is an attempt to summarize the most important terms you may encounter:

 * "**opaque**" identifiers do not reveal any personal information about a user. Opaque identifiers are typically generated as [cryptographic hashes](https://en.wikipedia.org/wiki/Cryptographic_hash_function) (e.g. SHA-256).

 * "**persistent**" means that the same identifier is used between different sessions over a long period of time, so you can retrieve the same user profile each time you log in. "**transient**" is the opposite of persistent.

 * "**pseudonym**" refers to a generated identifier that replaces the real identifier, so opaque identifiers are usually pseudonyms based on a real username. Its use is analogous to authors using pseudonyms when publishing books.

 * "**targeted**" means that the identifier is service-specific and different identifiers are used for different services. This helps prevent service providers from sharing information about their users. Targeted identifiers are usually opaque.

 * "**transferable**" refers to whether or not the same identifier can be shared between different people (sometimes referred to as "**reassignment**"). Ideally identifiers used in federation should not be re-used for other people.

 * "**unique**" means that the identifier only identifies a single person. Uniqueness is often ensured by [scoping]({{< ref "#scope" >}}) an identifier.

A South African identity number is a persistent pseudonym that is not supposed to be reassigned, but it is not opaque (it reveals your birth date and citizenship) nor is it targeted; your full name is neither persistent (e.g. it can change when you get married), unique (there can be more than one "Vuyo Smith"), opaque, nor targeted.

## 8. Time

Time and clocks get a special mention here because, like many authentication protocols, SAML is heavily reliant on accurate time. SAML responses typically indicate a validity period:
```xml
<saml:Conditions NotBefore="2017-11-09T19:07:17Z"
                 NotOnOrAfter="2017-11-09T19:12:47Z">
```
The difference between `NotBefore` and `NotOnOrAfter` is usually about five minutes. This means that a clock difference of even a few minutes between an identity provider and a service provider will cause authentication to fail.


[^saml-oasis]: SAML is a security framework and open standard defined by [OASIS](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=security) in a series of technical documents and XML schemas.
[^shib]: Shibboleth evolved SAML 1.0 → SAML 1.1 → SAML 2.0 (see <http://saml.xml.org/history>)
[^idp-init]: It is also possible for an identity provider to initiate the flow, but service-provider initiated is the most common case.
