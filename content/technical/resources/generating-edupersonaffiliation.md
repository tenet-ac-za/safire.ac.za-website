---
date: 2018-10-31 14:44:32+02:00
slug: generating-edupersonaffiliation
tags:
  - eduPersonAffiliation
  - eduPersonScopedAffiliation
  - idp-requirements
  - simplesamlphp
  - technical
title: Generating eduPersonAffiliation from your internal directory
url: /technical/resources/generating-edupersonaffiliation/
---

This page is intended to give you some ideas about how to generate an [eduPersonAffiliation]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) attribute that is useful to SAFIRE by reusing existing information you may already have in your internal directory services.

What’s shown below are [SimpleSAMLphp](https://simplesamlphp.org/) config snippets, but the ideas translate to pretty much all identity provider software. If you’re not using SimpleSAMLphp, hopefully the comments help you understand what is going on. All the authproc filters shown here are documented in [SimpleSAMLphp’s docs](https://simplesamlphp.org/docs/stable/simplesamlphp-authproc).

# eduPersonAffiliation

The goal is to generate an attribute containing a series (array) of values that represent how a particular end-user is affiliated with your institution. eduPersonAffiliation uses a [controlled language]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}) that likely does not reflect how you refer to these people within your institution, but most organisations have some form of identity management that allows them to group different types of users together.

However, it is important to note that you do not need to be able to produce all these categories to be able to assert eduPersonAffiliation. If you only have some of the information, you should **release as much as you have** as accurately as possible. At the very least, every IdP should be able to assert "_member_" for its members.

The [REFEDs ePSA usage comparison](https://www.terena.org/activities/refeds/docs/ePSAcomparison_0_13.pdf) provides guidance for mapping the controlled language. In South Africa, we've tied this language to the [data elements used in HEMIS]({{< ref "/technical/attributes/edupersonaffiliation.md" >}}). The table below summarises some common South Africa situations.

<table class="tablepress">

<thead>
<tr class="row-1 odd">
<th>Role</th>
<th>Value(s)</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">Undergraduate student</td>
<td class="column-2">member; student</td>
</tr>
<tr class="row-3 odd">
<td class="column-1">Postgraduate student who did undergrad at same institution</td>
<td class="column-2">member; student; alum</td>
</tr>
<tr class="row-4 even">
<td class="column-1">Convocation/alumni</td>
<td class="column-2">alum</td>
</tr>
<tr class="row-5 odd">
<td class="column-1">Staff member (academic, lecturer or researcher)</td>
<td class="column-2">member; employee; facility</td>
</tr>
<tr class="row-6 even">
<td class="column-1">Staff member (academic, unpaid)</td>
<td class="column-2">member; facility</td>
</tr>
<tr class="row-7 odd">
<td class="column-1">Staff member (administrative, professional or management)</td>
<td class="column-2">member; employee; staff</td>
</tr>
<tr class="row-8 even">
<td class="column-1">Staff member (unskilled, trade or craft)</td>
<td class="column-2">member; employee</td>
</tr>
<tr class="row-9 odd">
<td class="column-1">Staff member at affiliated institute</td>
<td class="column-2">affiliate (possibly also "member", depending on how close the ties are)</td>
</tr>
<tr class="row-10 even">
<td class="column-1">Any other member of the institution in good standing</td>
<td class="column-2">member</td>
</tr>
</tbody>

</table>

### Nesting of eduPersonAffiliation values

The following figure shows how the most commonly used values nest together, allowing a check for an outer box to include all people covered by an inner one.
[{{< figure src="/wp-content/uploads/2017/10/Nesting-of-eduPersonAffiliation-values.svg" caption="Nesting of eduPersonAffiliation values in SAFIRE" >}}](/wp-content/uploads/2017/10/Nesting-of-eduPersonAffiliation-values.svg)
It should be apparent that this means that the vast majority of users are expected to have more than one value for eduPersonAffiliation.

# Case 1: Containers / distinguished name

If you've organised your directory into containers that reflect the above roles, you may be able to use the distinguishedName (or entryDN in some LDAP directories) attribute to derive eduPersonAffiliation. The example below also sets [eduPersonPrimaryAffiliation]({{< ref "/technical/attributes/edupersonprimaryaffiliation.md" >}}).

```php
20 => [
  'class' => 'core:PHP',
  'code' => '
    $dnou = preg_replace("/^.*,ou=(\w+),dc=example,dc=local/", "$1", $attributes["distinguishedName"][0]);
    switch (strtoupper($dnou)) {
      case "STAFF":
        $a = ["member","staff"]; $p = "staff";
        break;
      case "STUDENTS":
        $a = ["member","student"]; $p = "student";
        break;
      case "GUESTS":
        $a = ["affiliate"]; $p = "affiliate";
        break;
      default:
        $a = ["library-walk-in"]; $p = "library-walk-in";
    }
    $attributes["eduPersonAffiliation"] = $a;
    $attributes["eduPersonPrimaryAffiliation"][0] = $p;
  ',
],
```

# Case 2: Group membership

Many organisations use groups to record roles and affiliations. These are usually exposed in LDAP as the groupMembership or memberOf attributes, which typically contain the distinguished name(s) of group object(s).

```php
20 => [
  'class' => 'core:PHP',
  'code' => '
    $a = [];
    /* loop through group DNs */
    foreach ($attributes["groupMembership"] as $group) {
      /* simple pattern matching */
      if (preg_match("/cn=(under|post)grads/", $group)) {
        $a[] = "member"; $a[] = "student"
      } elseif (preg_match("/cn=staff/", $group)) {
        a[] = "member"; $a[] = "employee";
      } elseif (preg_match("/cn=teaching/", $group)) {
        $a[] = "faculty";
      }
    }
    /* combinations of groups */
    if (in_array("employee", $a) and !in_array("faculty", $a)) {
      $a[] = "staff"
    }
    /* default */
    if (empty($a)) {
      $a[] = "library-walk-in";
    }
    $attributes["eduPersonAffiliation"] = $a;
  ',
],
```

# Case 3: Single attribute

You may have an attribute that reflects a user's role(s) in a single delimited string, in which case you could use [core:PHP](https://simplesamlphp.org/docs/stable/core:authproc_php) to split that string and set appropriate affiliation(s):

```php
/*
 * assumes a ms-Exch-Extension-Attribute15 attribute
 * containing a comma separated list.
 * e.g. ms-Exch-Extension-Attribute15 = student,convocation
 */
20 => [
  'class' => 'core:PHP',
  'code' => '
    $ourroles = preg_split("/\s*,\s*", $attributes["ms-Exch-Extension-Attribute15"][0]);
    $a = [];
    foreach ($ourroles as $role) {
       switch (strtoupper($role)) {
         case "STUDENT":
            $a[] = "student"; $a[] = "member"; break;
         case "ADMIN":
            $a[] = "staff"; $a[] = "employee"; $a[] = "member"; break;
         case "ACADEMIC":
            $a[] = "faculty"; $a[] = "employee"; $a[] = "member"; break;
         case "CONVOCATION":
            $a[] = "alum"; break;
         case "3RDPARTY":
            $a[] = "affiliate"; break;
       }
    }
    $attributes["eduPersonAffiliation"] = array_unique($a);
  ',
],
```

# Case 4: External source

You may store your roles in a separate database. How to deal with this is beyond the scope of this document. However, the two examples below may give you some ideas of what is possible.

### 4.1: LDAP directory

The [ldap:AttributeAddFromLDAP](https://simplesamlphp.org/docs/stable/ldap:ldap#section_2) filter may assist if you need to get additional attributes from a separate LDAP directory. For example, to add an attribute from an AD global catalog, you may do something like this:

```php
20 => [
  'class' => 'ldap:AttributeAddFromLDAP',
  'ldap.hostname' => 'ldaps://ldap.example.ac.za:3269',
  'ldap.username' => 'simplesamlphp@example.ac.za',
  'ldap.password' => 'your password',
  'ldap.basedn' => 'ou=Users,dc=example,dc=ac,dc=za',
  'attributes' => ['eduPersonAffiliation' => 'sourceAttribute'],
  'search.filter' => '(userPrincipalName =%eduPersonPrincipalName%)',
],
```

### 4.2: SQL database

SAFIRE has developed a [sqlattribs:AttributeFromSQL](https://github.com/safire-ac-za/simplesamlphp-module-sqlattribs) module that may help, either as a code example for how to develop your own module or directly as an attribute source.

```php
20 => [
  'class' => 'sqlattribs:AttributeFromSQL',
  'attribute' => 'eduPersonPrincipalName',
  'limit' => ['eduPersonAffiliation',],
  'replace' => false,
  'database' => [
    'dsn' => 'mysql:host=localhost;dbname=simplesamlphp',
    'username' => 'yourDbUsername',
    'password' => 'yourDbPassword',
    'table' => 'AttributeFromSQL',
  ],
],
```

Which would allow you to store eduPersonAffiliation in an external SQL database, something like this:

```sql
INSERT INTO AttributeFromSQL (uid, sp, attribute, value) VALUES ('user@example.org', '%', 'eduPersonAffiliation', 'faculty');
INSERT INTO AttributeFromSQL (uid, sp, attribute, value) VALUES ('user@example.org', '%', 'eduPersonAffiliation', 'member');
INSERT INTO AttributeFromSQL (uid, sp, attribute, value) VALUES ('other@example.org', '%', 'eduPersonAffiliation', 'alum');
```

# Case 5: Everyone is a member

As noted above, even if you have _no_ information in your directory, you can probably still assert that everyone is a member. This, of course, assumes you only provide accounts to people who're in good standing with your institution ;-).

```php
20 => [
  'class' => 'core:AttributeAdd',
  'eduPersonAffiliation' => ['member'],
],
```

Small organisations may be able to go further than that. For example, research agencies may be able to assert that all their members are also employees:

```php
20 => [
  'class' => 'core:AttributeAdd',
  'eduPersonAffiliation' => ['member', 'employee'],
],
```

# Generating eduPersonScopedAffiliation

Once you have a valid eduPersonAffiliation, it should be fairly straightforward to generate a scoped version of this. The cleanest method is to add a [schacHomeOrganization]({{< ref "/technical/attributes/schachomeorganization.md" >}}) attribute and to use this wherever scoping is required.

```php
/* add a static schacHomeOrganization attribute */
10 => [
  'class' => 'core:AttributeAdd',
  'schacHomeOrganization' => ['example.ac.za'],
],
/* scope uid as eduPersonPrincipalName */
11 => [
  'class' => 'core:ScopeAttribute',
  'scopeAttribute' => 'schacHomeOrganization',
  'sourceAttribute' => 'eduPersonAffiliation',
  'targetAttribute' => 'eduPersonScopedAffiliation',
],

```

The SAFIRE federation hub will automatically do the above if you don't supply eduPersonScopedAffiliation. However, doing it yourself gives you much greater control over the interpretation of the scope. This can be useful if you need to provide more [granular access control]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}).

