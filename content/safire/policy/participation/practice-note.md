---
aliases:
  - /safire/policy/practice-note-participation-agreement/
date: 2017-09-20 14:24:56+00:00
slug: practice-note-participation-agreement
tags:
  - participation
  - policy
title: "Practice Note: Participation Agreement"
url: /safire/policy/participation/practice-note/
---

Federation is a complex space, and South Africa is grappling with the implication of new privacy legislation. Whilst we've tried to make SAFIRE's Participation Agreement easy for the likely signatory --- a federation layman --- to understand, experience has shown that there are sometimes misunderstandings of the technology and gaps in interpretation. This document is intended to consolidate that experience into a practice note for legal departments and other people trying to make sense of the [SAFIRE Participation Agreement](/safire/policy/participation/).<!--more-->

# Preamble section

Some people have raised the concern that the preamble section (§1) is somewhat vague or too broad. This is deliberate, as it is meant as an introduction to identity federation in the general case. In some senses, the agreement could be read without it, as many of the SAFIRE-specific requirements are detailed later on. For instance, §1.2 describes the federation trust model; §6 codifies this as specific responsibilities for the various actors in SAFIRE.

Thus if you have concerns with §1, please make sure that they're not already addressed later on in the document.

# Tripartite relationship

The phrase "tripartite trust relationship" in §1.2.1 has caused confusion among people who rightly point out that there are only two signatories to the Participation Agreement. However, this phrase doesn't directly refer to the Participation Agreement but rather the implicit relationships that are created by the multiplicity of bipartite agreements between participants and the Federation. Every participant knows and understands that other participants are bound by the same agreement they are, and this transparency fosters trust between parties who have not entered into an explicit agreement between themselves.

# Loss of control

All forms of federation involve trade-offs. At the end of the day, your own institution needs to decide whether the benefits of participation outweigh the potential loss of control.

Having said that, the reason we use the term "participant" is that we encourage participation in [all aspects of the federation]({{< ref "/safire/governance.md" >}}). This includes the development of policy and operational practices. As a community-driven initiative, you will have an opportunity to have your say and influence SAFIRE's direction (perhaps more than you might with commercial providers).

Universities and statutory research councils are in an even better position: TENET is a non-profit company with members, and its public universities and statutory research innovation councils are entitled to be members. Thus SAFIRE is ultimately accountable back to these participants, as members of the company.

# Binding obligations on Service Providers

Some people would like SAFIRE to impose various binding obligations on _all_ Service Providers, particularly regarding the privacy of personal information.

It is impossible for a South African federation to impose binding obligations on service providers who are members of another federation and subject to other jurisdictions. Quite simply, no signatory to the Participation Agreement has any form of lien over them.

This is taken into consideration when applying [attribute release policies](/safire/policy/arp/). The default policy is necessarily very conservative, and variations must be explicitly motivated for.

# Default attribute release policy releases too much personal information

Both the [default attribute release policy](/safire/policy/arp/#default) and the [Research & Scholarship one](/safire/policy/arp/#research-scholarship) release no more information than an average email. If your organisation is happy for an outgoing email to include both an email address and the name of the sender, you should be happy for this information to be released via other technologies. Alternatively, you should consider applying similar prohibitions to email.

# Consent for personal information release

SAFIRE's understanding of consent is that it must be given by a data subject (end user), and it must be informed, freely given, and for a specific purpose. It must also be [withdrawable at any point](https://consentadmin.safire.ac.za/). These principles are applied throughout. Likewise, the principle of minimality is observed when negotiating [attribute release policies](/safire/policy/arp/).

Our understanding of consent will continue to evolve as regulation is gazetted in South Africa. In the mean time, we follow the developments relating to the European GDPR with interest.

# Display of policy documents

SAFIRE's consent page for SAML transactions provides links to both [SAFIRE's Privacy Statement](/safire/policy/privacy/) and to the privacy policy or statement of the specific service provider that's being visited. Moreover, the consent page displays the post-processed attributes, exactly as they will be onward released. No further processing is done after consent. All of this is important to allow people to make an informed decision about consent.

Should individual SAML identity- or service providers wish to display other policies or terms, they may build those into their own systems.

Other technologies (particularly RADIUS/EAP/eduroam) may not allow for this.

# Technologies

The Participation Agreement is supposed to be technology agnostic and allow for specific technology profiles. At the moment the only profile that has been defined is for a SAML federation.

However, it is likely that a RADIUS/EAP one will be developed to subsume the current [eduroam national policy](http://www.eduroam.ac.za/). Thus participants in eduroam will not be asked to sign the Participation Agreement again.

# Costs

Signing the Participation Agreement does not in and of itself imply that a Participant will pay fees. The clauses in §3 only kick in when a Participant further registers an identity- or service-provider in one of the technology profiles (this requires explicit action --- submitting a [registration request form]({{< ref "/technical/saml2/forms.md" >}})).

## Identity Providers

Section 3 notes that the cost structure is unknown, but provides an opt-out for identity providers later on. Something that is implicit, but seems to cause confusion is that this means that any identity provider who currently participates in SAFIRE is by definition a paid-up member (no fees have been levied) and is entitled to the benefits of membership. One of the [benefits of membership]({{< ref "/safire/governance.md" >}}) is being involved in the approval process of any future cost structure.

## Service Providers

Participants who only wish to (or are only able to) register service providers still need to sign the Participation Agreement, but --- per §3.1.1 --- are not charged and will not be invoiced. (§3.2 only applies once a Participant further submits an [IdP Registration Request form]({{< ref "/technical/saml2/forms.md" >}}) and is accepted as an identity provider.)

# Sanctions

Section 8 provides for "sanctions", a term borrowed from earlier related agreements. However, what §8 doesn't explicitly state is that there is only one possible remedy available to the parties — withdrawal/removal from the Federation. This defeats the objectives of federation and is thus in nobody's interests. It will only be exercised by the Federation once **all** other avenues have been exhausted. Moreover, it does not carry any form of direct financial penalty.

# Sole provider/alternatives

SAFIRE is an _academic_ identity federation. Whilst there certainly are other providers of federated identity solutions, there is typically only one _academic_ identity federation per country. This concept is reflected in the way the global academic inter-federation community works: for example, both the [REFEDS community](https://refeds.org/federations) and GÉANT's [eduGAIN service](https://technical.edugain.org/status) arrange federations by country and neither currently acknowledge the existence of more than one academic federation within a given country.

The defining feature is that, unlike commercial ventures, SAFIRE exists solely to serve the needs of its beneficiary community and provides for a [high level of input]({{< ref "/safire/governance.md" >}}) from that community. The service provided by SAFIRE is tailored to the specific needs of the research and education community and is intended to allow South Africa to more effectively participate in global academic research endeavours.

Moreover, SAFIRE is operated by a non-profit company (TENET) who's [memorandum of incorporation espouses these ideals](http://www.tenet.ac.za/about/about-tenet-1). As an NPC, TENET does not charge for its services in amounts exceeding what is required to recover the costs of delivering services.

# REN Service Agreement

Section 11.3 makes reference to TENET's REN Services Agreement as containing the processes for dispute resolution. In the case where a Participant in SAFIRE is also a signatory of the REN Services Agreement (most universities, for instance), the prevailing version is the one most recently concluded between TENET and the Participant (we can supply a copy of this if necessary).

In cases where the Participant is not also a signatory, the prevailing version is the one [published on TENET's website](http://www.tenet.ac.za/doc/tenet-ren-service-agreement-redistributable/view) and updated from time to time. However, if necessary to allay concerns about this, we can annexure the relevant sections from the REN Service Agreement to the Participation Agreement at the time of signature.

# Variations

Some legal departments have asked for organisation-specific variations to the Participation Agreement. Unfortunately, we're not able to do this, for two reasons:-

Firstly (and most importantly), the trust model of a federation is based on transparency and ensuring that every Participant (including those participating via inter-federation) knows and understands the roles of other participants. This is why the Participation Agreement and all associated policies [are public documents on our website](/safire/policy/). Individualising the agreements would break this model --- and would thus further imply that SAFIRE was unable to publish that organisation's metadata to inter-federation partners like eduGAIN.

Secondly, as a small non-profit, TENET simply doesn't have the resources to manage individualised versions of contracts.

# Changes

Potential identity providers (mostly universities) were given an opportunity to provide input into and comment on drafts of the Participation Agreement before it was approved, and the current version incorporates all feedback we received during that process.

Changes to the Participation Agreement need to undergo [community review]({{< ref "/safire/governance.md" >}}) and legal oversight before being presented to TENET's Board for approval. Then, depending on the nature of the changes, we may have to ask existing Participants to re-sign the agreement per §10.2. This process is likely to take several months, and so is not something we will undertake lightly.

Of course, if there is good cause to amend the Participation Agreement, we will obviously consider this.  However, any proposed changes need to be viewed in a holistic manner that considers the impact on all participants rather than just one.
