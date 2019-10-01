---
attributeExample: |2
    * member
    * employee
    * staff
    * alum

  _The above example would represent a person who is currently an administrative staff member and who is also an alumnus of the institution._
attributeFormat: |2
  Multi-valued with a controlled vocabulary --- only the following affiliations are accepted:

    * alum
    * affiliate
    * employee _(implies member)_
    * faculty _(implies employee, member)_
    * library-walk-in
    * member
    * staff _(implies employee, member)_
    * student _(implies member)_

   The semantics of various affiliations is described in bold in the [ePSA usage comparison](https://www.terena.org/activities/refeds/docs/ePSAcomparison_0_13.pdf). For universities, these should be interpreted so as to align with the Higher Education Management Information System (HEMIS) data elements. Thus the _eduPersonAffiliation_ definitions of "student", "faculty" &amp; "staff" should be aligned with the HEMIS definitions for "enrolled student" (both undergraduate and postgraduate) and the "instruction/research professional (academic)", and "executive/administrative/managerial professional + specialised/support professional + technical + non-professional administration (senior management, administrative & support staff)" personnel categories respectively. Staff in the "trade/craft + service" HEMIS personnel categories would typically only be an _eduPersonAffilliation_ "employee" (however depending on institutional policy they may additionally classify as "staff".

   Note that where an affiliation value above says "implies&hellip;" the implied values **must** also be included in the returned set. The most significant/primary one from the set can then be returned separately as [_eduPersonPrimaryAffiliation_](/technical/attributes/edupersonprimaryaffiliation/).
attributeOid: urn:oid:1.3.6.1.4.1.5923.1.1.1.1
attributeReferences:
  - Name: eduPerson
    URL: https://wiki.refeds.org/display/STAN/eduPerson
  - Name: ePSA usage comparison
    URL: https://www.terena.org/activities/refeds/docs/ePSAcomparison_0_13.pdf
  - Name: HEMIS Data Elements
    URL: http://www.heda.co.za/Valpac_Help/DED_031_040.htm#E039
date: 2016-09-12 12:27:45+00:00
layout: attributelist
slug: edupersonaffiliation
title: eduPersonAffiliation
url: /technical/attributes/edupersonaffiliation/
---

Subject's role at their home organisation in broad categories such as staff, student.
