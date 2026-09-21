---
date: 2026-09-21 09:00:00+02:00
slug: validating-metadata
tags:
  - technical
  - testing
title: Validating your SAML2 metadata for SAFIRE
url: /technical/resources/validating-metadata/
---

# Validating your SAML2 metadata for SAFIRE

SAFIRE publishes detailed technical requirements for metadata (detailed here: [idp]({{< ref "/technical/saml2/idp-requirements/_index.md" >}}); [sp]({{< ref "/technical/saml2/sp-requirements/_index.md" >}})). When on-boarding a new provider or making changes, it is helpful to be able to check your metadata against these requirements before sending them to the Federation Operator. The metadata validator allows you to do this, and provides useful insight into issues that might prevent your metadata from being imported into SAFIRE's registry.

> You can find our metadata validator at <https://validator.safire.ac.za/>.
{.message-box .info}

# Using the validator

The first step to using the validator is to load the candidate metadata from your SAML software. You do this by copy-pasting it into the text box, uploading it from a file, or fetching it from a URL. However you do it, your metadata should be loaded in the large text area on the validator.

The syntax highlighter parses the XML, and highlights the various elements to make it easier to read. It can detect some structural syntax issues, and those will be highlighted with a red cross against the appropriate line number. However, the syntax highlighter doesn't understand SAML specifically (it is just an XML highligher).

Once a metadata document is loaded, you three buttons will appear and allow you to perform various operations on the metadata. These are:

### Validate!

The **Validate!** button will run a series of syntactic and semantic checks on your metadata, including explictly checking a number of SAFIRE's technical requirements.

There are six phases to the checks, and a failure in an earlier phase will stop the validation and prevent later passes from being run. The phases are:

1. XML well-formedness
2. XML namespace validity
3. SAML metadata schema validity (Generic SAML schema)
4. SAML metadata schema validity (SAFIRE-specific namespaces and checks)
5. Metadata validation & testing (using a widely-accepted ruleset from the UK Access Management Federation)
6. Metadata validation & testing (using SAFIRE's own ruleset)

As it passes through each phase, any errors and warnings will be displayed below the . Errors are shown in red; warnings in yellow; and information in green.

All errors need to be corrected and a successful pass 6 run needs to be completed before we can proceed with registering metadata or making changes. (The display will indicate "COMPLETE" with only warnings and information.)

You can edit the metadata in the validator to test your changes and re-validate before porting them back to your application.

### Normalise

This will normalise your metadata into the form we use in SAFIRE's registry. This includes refactoring any namespaces into a well-known set of prefixes; stripping out unused namespaces and non-applicable elements (such as those inserted by ADFS); and pretty printing the XML.

It is not necessary to use the normalised form in your application (and indeed, doing so may break things). However, it makes the metadata easier to read and understand and is the preferred format for submitting to SAFIRE.

Double-clicking on the Normalise button switches the root element namespace format from implicit to explict or vice versa (i.e. from `<EntityDescriptor>` to `<md:EntityDescriptor>` and back).

### Domain control validation (DCV)

SAFIRE's [metadata registration practice statement]({{< ref "/safire/policy/mrps/_index.md" >}}) requires we validate the right to use any DNS domain names used in your entity ID or any `<shibmd:Scope>` elements. The DCV button will detect such elements that need validating, and provide appropriate values to complete the validation.

In the first step you will be asked for a reference, and SAFIRE's staff will provide this to you before they complete validation. It forms part of the validation value, so you **must** use the supplied version. However, you can test the DCV functionality by entering `TEST` as your reference. This will let you see what domain(s) might need to be validated.

Note that some shared providers, such as entra ID, use alternative mechanisms for control validation, and these are not supported by the metadata validator. See our MRPS for more details.


## Additional features

### Viewing certificates

The metadata validator has some understanding of X.509 certificates, and will allow you to view the details of the certificates in your metadata. Any detected certificate will be highlighted as black-on-grey, and double clicking on a certificate will allow you to view its details.
