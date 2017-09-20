---
date: 2017-02-27 07:32:25+00:00
slug: generating-edupersonprincipalname
tags:
  - eduPersonPrincipalName
  - idp-requirements
  - simplesamlphp
  - technical
title: Generating eduPersonPrincipalName from your internal directory
url: /technical/resources/generating-edupersonprincipalname/
---

This page is intended to give you some ideas about how to generate an [eduPersonPrincipal]({{< ref "/technical/attributes/edupersonprincipalname.md" >}}) attribute that is useful to SAFIRE by reusing existing unique user identifiers from your internal directory services.

What's shown below are [SimpleSAMLphp](https://simplesamlphp.org/) config snippets, but the ideas translate to pretty much all identity provider software. If you're not using SimpleSAMLphp, hopefully the comments help you understand what is going on. All the authproc filters shown here are documented in [SimpleSAMLphp's docs](https://simplesamlphp.org/docs/stable/simplesamlphp-authproc).

# eduPersonPrincipalName

The goal is, first and foremost, to create an attribute that is:-

  1. properly scoped (has your domain name after it);
  2. uniquely represents a single user; and
  3. **NEVER** reassigned (re-used for another person).

It also helps if it's meaningful to your users and looks similar to what they think of as their username.

Note that whilst the [eduPerson schema](https://www.internet2.edu/media/medialibrary/2013/09/04/internet2-mace-dir-eduperson-201203.html#eduPersonPrincipalName) allows eduPersonPrincipalName to be reassigned "after a locally-defined period of dormancy", [SAFIRE does not](http://lists.tenet.ac.za/mailman/private/safire-discuss/2016-September/000019.html). This was a simplification to allow SAFIRE to generate a [persistent identifier]({{< ref "/technical/attributes/edupersontargetedid.md" >}}) from an attribute most providers already have, rather than requiring all identity providers carry an additional non-reassignable attribute. This makes the third property above (non-reassignment) critical from a security perspective since you cannot assume that just because you've updated your systems, that change has propagated through to all other service providers that might be using the eduPersonPrincipalName attribute or NameID as a UID.

# Case 1: You already have a properly scoped user identifier

If you've already got an attribute that meets the above requirements, use it! There's no point in trying to reinvent the wheel.

## userPrinicpalName

Active Directory users have an attribute called [userPrinicpalName](https://msdn.microsoft.com/en-us/library/ms680857(v=vs.85).aspx). If your AD domain name matches your DNS domain name then you may be able to use this attribute as-is (which has the additional example of being a valid username for your users).

To use a properly scoped userPrinicpalName, simply rename the attribute.

```php
/* rename userPrinicpalName to eduPersonPrincipalName */
10 => array(
 'class' => 'core:AttributeMap',
 'userPrinicpalName' => 'eduPersonPrincipalName',
),
```

## mail

A common example of this is an email address, particularly with applications like Google Apps making email address = username a common paradigm. However, make sure you are **not reassigning** email address. (It does not matter if they change --- for example when someone gets married --- so long as old ones are never reused.)

If you use the mail attribute, you should _copy_ the attribute so that mail itself is still available to applications that need an email address (SPs are not allowed to assume that eduPersonPrincipalName is a valid email address).

```php
/* copy mail to eduPersonPrincipalName */
10 => array(
 'class' => 'core:AttributeCopy',
 'mail' => 'eduPersonPrincipalName',
),
```

# Case 2: You have an incorrectly scoped user identifier

A problem that commonly afflicts Active Directory users is that their AD domain name does not match their DNS name. In these cases, you can make use of the userPrinicpalName attribute, but you need to apply some fix-ups to the realm/scope. (The same, of course, applies to any other incorrectly scoped userid attribute.)

```php
/* rename userPrinicpalName to eduPersonPrincipalName */
10 => array(
 'class' => 'core:AttributeMap',
 'userPrinicpalName' => 'eduPersonPrincipalName',
),
/* fix the scope to match DNS domain */
11 => array(
  'class' => 'core:AttributeAlter',
  'subject' => 'eduPersonPrincipalName',
  'pattern' => '/\@example\.local/',
  'replacement' => '@example.ac.za',
),
```

Note that if your AD name is a valid subdomain within your DNS domain, you do not necessarily have to do this --- it is okay to use subdomains provided they are properly reflected in the [<md:Scope> elements](/technical/saml2/idp-requirements/) within your metadata. (Or you could do the above if you'd prefer not to reflect your domain name outwards.)

# Case 3: You have an unscoped user identifier

Pretty much all POSIX systems have a unique user identifier available in the uid attribute; some systems (notably eDirectory) also use cn for this purpose. On older Windows systems, you may be able to use sAMAccountName. The problem is that all these attributes are unscoped, so to use them with SAML you will need to add your DNS domain as a scope.

There are a number of ways to scope an attribute. One is to use regex with core:AttributeAlter as above. However, perphaps a cleaner method is to add a [schacHomeOrganization]({{< ref "/technical/attributes/schachomeorganization.md" >}}) attribute and to use this whereever scoping is required.

```php
/* add a static schacHomeOrganization attribute */
10 => array(
  'class' => 'core:AttributeAdd',
  'schacHomeOrganization' => array('example.ac.za'),
),
/* scope uid as eduPersonPrincipalName */
11 => array(
  'class' => 'core:ScopeAttribute',
  'scopeAttribute' => 'schacHomeOrganization',
  'sourceAttribute' => 'uid',
  'targetAttribute' => 'eduPersonPrincipalName',
),

```

You can then use the same method (and the existing schacHomeOrganization) to scope any other attributes you may need to generate, for example [eduPersonScopedAffiliation]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}).

# Case 4: You have nothing

For completeness, we mention a fourth case --- you have no existing attribute containing a unique identifer. This should be an unlikely scenario, since it would imply your directory is neither POSIX compliant nor [properly normalised](https://en.wikipedia.org/wiki/Database_normalization). However, it will most commonly occur when people are re-assigning usernames.

In this situation, you have several choices:

  * stop re-assigning usernames (there are many other good reasons for this);
  * hash something like a national identity number, if you have it; or
  * extend your schema to include a separate unique, non-reassigned identifier.

These are all beyond the scope of this document.

