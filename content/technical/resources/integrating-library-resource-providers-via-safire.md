---
date: 2017-07-24 13:47:06+00:00
slug: integrating-library-resource-providers-via-safire
tags:
  - collaboration
  - library
  - publishers
  - technical
title: Integrating library resource providers via SAFIRE
url: /technical/resources/integrating-library-resource-providers-via-safire/
---

There is considerable interest in leveraging SAFIRE and eduGAIN to integrate with the various library resource providers, such as journal and database publishers.  Resource providers variously term this "Shibboleth", "SAML" or "Institutional" logins, and in most cases are already integrated with other federations around the world.

The following documents the integration status of various providers.

{{< raw >}}
<table class="tablepress">
<thead>
<tr class="row-1 odd">
<th>Provider</th>
<th>Login link terminology</th>
<th>Status</th>
<th>Notes</th>
<th></th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td>{{< /raw >}}
ACM Digital Library
{{< raw >}}</td>
<td>{{< /raw >}}
Sign in via your Institution
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
[docs](http://libraries.acm.org/subscriptions-access/authentication)
{{< raw >}}</td>
</tr>
<tr class="row-3 odd">
<td>{{< /raw >}}
BioOne
{{< raw >}}</td>
<td>{{< /raw >}}
Login via your Institution (Shibboleth)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
[docs](http://www.bioone.org/page/help/RemoteAccess)
{{< raw >}}</td>
</tr>
<tr class="row-4 even">
<td>{{< /raw >}}
Cambridge Core
{{< raw >}}</td>
<td>{{< /raw >}}
[Institutional login](https://shibboleth.cambridge.org/CJOShibb2/index?app=https://www.cambridge.org/core/shibboleth?ref=/core)
{{< raw >}}</td>
<td>{{< /raw >}}

Tested, working
{{< raw >}}</td>
<td>{{< /raw >}}
Libraries need to set an appropriate value for eduPersonScopedAffiliation within the Cambridge admin portal.
{{< raw >}}</td>
<td>{{< /raw >}}
[docs](https://vimeo.com/178305091/ac7ed284ae)
{{< raw >}}</td>
</tr>
<tr class="row-5 odd">
<td>{{< /raw >}}
Dawsonera
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth login](https://www.dawsonera.com/wayf/wayf.html?entityID=https%3A%2F%2Fwww.dawsonera.com%2Fshibboleth&return=https%3A%2F%2Fwww.dawsonera.com%2FShibboleth.sso%2FLogin%3FSAMLDS%3D1%26target%3Dcookie%253A1501229600_249b)
{{< raw >}}</td>
<td>{{< /raw >}}

Tested,
 working
{{< raw >}}</td>
<td>{{< /raw >}}
Libraries need to generate a WAYFless URL of the form https://www.dawsonera.com/Shibboleth.sso/Login?entityID=_idp_proxy_entityid_&target=https://www.dawsonera.com/depp/shibboleth/ShibbolethLogin.html?dest= using their [proxied entity id](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC) and send it to Dawson support to get themselves listed.
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-6 even">
<td>{{< /raw >}}
De Gruyter
{{< raw >}}</td>
<td>{{< /raw >}}
Connect via Institution
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
[docs](https://www.degruyter.com/page/286#Shibboleth)
{{< raw >}}</td>
</tr>
<tr class="row-7 odd">
<td>{{< /raw >}}
EBSCO
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth Login](http://search.ebscohost.com/login.aspx?profile=ehost)
{{< raw >}}</td>
<td>{{< /raw >}}

Tested, working, discovery problem, contacted
{{< raw >}}</td>
<td>{{< /raw >}}
Libraries need to set an appropriate value for eduPersonScopedAfilliation within the EBSCOadmin portal. However, the discovery service is confusing for end users: all of SAFIRE appears under "UK Higher Education", and institution names are not always in English (e.g. UCT is listed as "IYunivesithi yaseKapa"). EBSCO has been contacted to try and resolve this.
{{< raw >}}</td>
<td>{{< /raw >}}
[docs](https://help.ebsco.com/interfaces/EBSCOadmin/Admin_User_Guide/set_up_Shibboleth_SAML_Authentication)
{{< raw >}}</td>
</tr>
<tr class="row-8 even">
<td>{{< /raw >}}
Elsevier ScienceDirect/Scopus
{{< raw >}}</td>
<td>{{< /raw >}}
[Other institution](http://www.sciencedirect.com/science?_ob=FederationURL&_method=display&md5=e2d806d1e8c4953bc9f57621cb18fbd2&prevURL=https%3A%2F%2Fwww.sciencedirect.com%2Fuser%2Frouter%2Fshib)
{{< raw >}}</td>
<td>{{< /raw >}}

Contacted
{{< raw >}}</td>
<td>{{< /raw >}}
A WAYFless URL allows login; not sure what else needs doing.
{{< raw >}}</td>
<td>{{< /raw >}}
[wayfless](https://www.elsevier.com/solutions/scopus/support/federated-authentication-through-saml)
{{< raw >}}</td>
</tr>
<tr class="row-9 odd">
<td>{{< /raw >}}
Emerald Insight
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth login](https://www.emeraldinsight.com/action/ssostart?redirectUri=%2F)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
[docs](http://www.emeraldgrouppublishing.com/support/librarian/shibboleth_access.htm)
{{< raw >}}</td>
</tr>
<tr class="row-10 even">
<td>{{< /raw >}}
Gale Cengage
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
Not tested
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
[docs](http://admin.galegroup.com/galeadmin/help/help/GADMAuthenticationShibbolethHelp.html)
{{< raw >}}</td>
</tr>
<tr class="row-11 odd">
<td>{{< /raw >}}
IEEE Xplore
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth](http://ieeexplore.ieee.org/servlet/wayf.jsp)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}
Institutions need to register
{{< raw >}}</td>
<td>{{< /raw >}}
[docs](https://supportcenter.ieee.org/app/answers/detail/a_id/162/~/does-ieee-support-shibboleth-or-athens-authentication-in-xplore%3F)
{{< raw >}}</td>
</tr>
<tr class="row-12 even">
<td>{{< /raw >}}
JSTOR
{{< raw >}}</td>
<td>{{< /raw >}}
[Login via an institution](https://www.jstor.org/institutionSearch?redirectUri=%2F)
{{< raw >}}</td>
<td>{{< /raw >}}

Tested, working
{{< raw >}}</td>
<td>{{< /raw >}}
Libraries need to generate a [WAYFless URL](https://shibboleth2sp.jstor.org/wayfless_url_generator.html) using their [proxied entity id](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC) and send it to JSTOR support to get themselves listed. Can negotiate specific values of eduPersonScopedAffiliation.
{{< raw >}}</td>
<td>{{< /raw >}}
[docs](http://support.jstor.org/access-management/2016/10/6/jstor-saml-information), [wayfless](https://shibboleth2sp.jstor.org/wayfless_url_generator.html)
{{< raw >}}</td>
</tr>
<tr class="row-13 odd">
<td>{{< /raw >}}
LexisNexus Academic
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
Not tested/can't find
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-14 even">
<td>{{< /raw >}}
LexisNexus SA
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

Not tested/can't find. Contacted customer support.
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-15 odd">
<td>{{< /raw >}}
ORCID
{{< raw >}}</td>
<td>{{< /raw >}}
[Institutional account](https://orcid.org/signin)
{{< raw >}}</td>
<td>{{< /raw >}}

Tested, working
{{< raw >}}</td>
<td>{{< /raw >}}
Individuals need to link their institutional account with an existing ORCID identifier.
{{< raw >}}</td>
<td>{{< /raw >}}
[docs](https://members.orcid.org/api/integrate/institution-sign-in)
{{< raw >}}</td>
</tr>
<tr class="row-16 even">
<td>{{< /raw >}}
Ovid SP
{{< raw >}}</td>
<td>{{< /raw >}}
[Institutional Login](https://shibboleth.ovid.com/)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-17 odd">
<td>{{< /raw >}}
Oxford University Press
{{< raw >}}</td>
<td>{{< /raw >}}
Access Management Federation login
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-18 even">
<td>{{< /raw >}}
ProQuest  (RefWorks)
{{< raw >}}</td>
<td>{{< /raw >}}
My Institutions Credentials (Shibboleth)
{{< raw >}}</td>
<td>{{< /raw >}}
Not tested
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-19 odd">
<td>{{< /raw >}}
Sabinet
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

Not supported
{{< raw >}}</td>
<td>{{< /raw >}}
Sabinet is investigating joining SAFIRE.
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-20 even">
<td>{{< /raw >}}
SAGE
{{< raw >}}</td>
<td>{{< /raw >}}
[Institutional access: Shibboleth](http://journals.sagepub.com/action/ssostart?redirectUri=/)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-21 odd">
<td>{{< /raw >}}
SpringerLink
{{< raw >}}</td>
<td>{{< /raw >}}
[Log in via Shibboleth or Athens](https://link.springer.com/athens-shibboleth-login?previousUrl=https%3A%2F%2Flink.springer.com%2F)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}
A WAYFless URL allows login; not sure what else needs doing.
{{< raw >}}</td>
<td>{{< /raw >}}
[wayfless](https://springeronlineservice.freshdesk.com/support/solutions/articles/6000079268-construct-a-wayfless-url-in-athens-openathens-)
{{< raw >}}</td>
</tr>
<tr class="row-22 even">
<td>{{< /raw >}}
Taylor & Francis Online
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth](http://www.tandfonline.com/action/ssostart?redirectUri=%2F)
{{< raw >}}</td>
<td>{{< /raw >}}

Testing in progress
{{< raw >}}</td>
<td>{{< /raw >}}
Institutions will need to have their unique organisation ID/scope registered to their account to permit access to their users.  Institutional administrators can enter their Shibboleth credentials themselves, or provide T&F with the details and they can add this to their account on their behalf.
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-23 odd">
<td>{{< /raw >}}
Thieme Connect
{{< raw >}}</td>
<td>{{< /raw >}}
[Shibboleth Login](https://profile.thieme.de/HTML/sso/ejournals/shibboleth.htm?hook_url=https://www.thieme-connect.de/products/all/home.html&rdeLocaleAttr=en)
{{< raw >}}</td>
<td>{{< /raw >}}
No SA institutions listed by default
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-24 even">
<td>{{< /raw >}}
Thomson-Reuters Web of Science
{{< raw >}}</td>
<td>{{< /raw >}}
Institutional users sign in
{{< raw >}}</td>
<td>{{< /raw >}}

Tested, discovery problem
{{< raw >}}</td>
<td>{{< /raw >}}
Appears under UK Federation
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-25 odd">
<td>{{< /raw >}}
Westlaw
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}
Not tested/can't find
{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
<td>{{< /raw >}}

{{< raw >}}</td>
</tr>
<tr class="row-26 even">
<td>{{< /raw >}}
Wiley
{{< raw >}}</td>
<td>{{< /raw >}}
[Institutional Login](https://onlinelibrary.wiley.com/login-options)
{{< raw >}}</td>
<td>{{< /raw >}}

Contacted
{{< raw >}}</td>
<td>{{< /raw >}}
Libraries need to contact Wiley support and complete a Shibboleth (Federated Access) Request Form.
{{< raw >}}</td>
<td>{{< /raw >}}
[wayfless](http://media.wiley.com/assets/2265/11/Wiley_Online_Library_Federated_Access_Dec_2013.pdf)
{{< raw >}}</td>
</tr>
</tbody>
</table>{{< /raw >}}

# Values needed by publishers

Publishers may ask for an entity ID or IdP identity. If they're accessing your identity provider via eduGAIN, the value they will need is your institution's [proxied entity ID](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC). You can get this by clicking on your institution in [our list](https://phph.safire.ac.za/mdfileview?type=published&fed=SAFIRE-BIRK-PUBLIC), and then copying the entity ID field. (Note that the version displayed in the list is sometimes truncated.)

You may also be asked for a WAYFless URL. Different publishers have different mechanisms for constructing these, so you will need to refer to the publisher's documentation. However, they will always involve a [URL encoded](https://www.urlencoder.org/) version of the entity ID described in the preceding paragraph.

Finally, you may be asked for affiliation or scoped affiliation values. These are the values your institution sets for [_eduPersonScopedAffiliation_]({{< ref "/technical/attributes/edupersonscopedaffiliation.md" >}}) and will be a value like member@example.ac.za. You may be able to figure out the correct ones by logging into our [test service provider](https://testsp.safire.ac.za/), but generally you should confirm them with your own identity provider administrator or IT support staff.

# Hints from other federations

Other federations have links to providers' documentation that may prove useful to those trying to get this to work:

  * [Edugate (Ireland)](https://edugate.heanet.ie/rr3/p/page/LibraryAccess)
  * [UK Federation](https://www.ukfederation.org.uk/content/Documents/WAYFlessServices)

