#
# Add claim descriptions for SAFIRE attributes
#
# @author Guy Halse http://orcid.org/0000-0002-9388-8592
# @copyright Copyright (c) 2017, Tertiary Education and Research Network of South Africa
# @license https://opensource.org/licenses/MIT MIT License
#
# Derived from the work of Matthew Economou, NIH/NIAID

# eduPersonPrincipalName
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.6" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.6" `
	  -Name "eduPerson Principal Name (URN)" `
	  -ShortName "eduPersonPrincipalName" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "A scoped identifier for a person. It should be represented in the form 'user@scope' where 'user' is a name-based identifier for the person and where 'scope' defines a local security domain. Each value of 'scope' defines a namespace within which the assigned identifiers MUST be unique. Given this rule, if two eduPersonPrincipalName (ePPN) values are the same at a given point in time, they refer to the same person. There must be one and only one '@' sign in valid values of eduPersonPrincipalName."
}

# givenName
if ("urn:oid:2.5.4.42" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.5.4.42" `
	  -Name "Given Name (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "The 'givenName' attribute type contains name strings that are the part of a person's name that is not their surname. Each string is one value of this multi-valued attribute."
}

# sn
if ("urn:oid:2.5.4.4" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.5.4.4" `
	  -Name "Surname (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "The 'sn' ('surname' in X.500) attribute type contains name strings for the family names of a person. Each string is one value of this multi-valued attribute."
}

# displayName
if ("urn:oid:2.16.840.1.113730.3.1.241" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.16.840.1.113730.3.1.241" `
	  -Name "Display Name (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Preferred name of a person to be used when displaying entries."
}

# eduPersonAffiliation
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.1" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.1" `
	  -Name "eduPerson Affiliation (URN)" `
	  -ShortName "eduPersonAffiliation" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Specifies the person's relationship(s) to the institution in broad categories such as student, faculty, staff, alum, etc. (See controlled vocabulary)."
}

# mail
if ("urn:oid:0.9.2342.19200300.100.1.3" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:0.9.2342.19200300.100.1.3" `
	  -Name "E-Mail Address (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "The 'mail' (rfc822mailbox) attribute type holds Internet mail addresses in Mailbox [RFC2821] form (e.g., user@example.com)."
}

# eduPersonEntitlement
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.7" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.7" `
	  -Name "eduPerson Entitlement (URN)" `
	  -ShortName "eduPersonEntitlement" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "URI (either URL or URN) that indicates a set of rights to specific resources."
}

# eduPersonOrcid
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.16" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.16" `
	  -Name "eduPerson ORCID iD (URN)" `
	  -ShortName "eduPersonOrcid" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "ORCID iDs are persistent digital identifiers for individual researchers. Their primary purpose is to unambiguously and definitively link them with their scholarly work products. ORCID iDs are assigned, managed and maintained by the ORCID organization."
}

# eduPersonPrimaryAffiliation
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.5" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.5" `
	  -Name "eduPerson Primary Affiliation (URN)" `
	  -ShortName "eduPersonPrimaryAffiliation" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Specifies the person's primary relationship to the institution in broad categories such as student, faculty, staff, alum, etc. (See controlled vocabulary)."
}

# eduPersonScopedAffiliation
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.9" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.9" `
	  -Name "eduPerson Scoped Affiliation (URN)" `
	  -ShortName "eduPersonScopedAffiliation" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Specifies the person's affiliation within a particular security domain in broad categories such as student, faculty, staff, alum, etc. The values consist of a left and right component separated by an '@' sign. The left component is one of the values from the eduPersonAffiliation controlled vocabulary. This right-hand side syntax of eduPersonScopedAffiliation intentionally matches that used for the right-hand side values for eduPersonPrincipalName. The 'scope' portion MUST be the administrative domain to which the affiliation applies. Multiple '@' signs are not recommended, but in any case, the first occurrence of the '@' sign starting from the left is to be taken as the delimiter between components. Thus, user identifier is to the left, security domain to the right of the first '@'. This parsing rule conforms to the POSIX 'greedy' disambiguation method in regular expression processing."
}

# employeeNumber
if ("urn:oid:2.16.840.1.113730.3.1.3" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.16.840.1.113730.3.1.3" `
	  -Name "Employee Number (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Numeric or alphanumeric identifier assigned to a person, typically based on order of hire or association with an organization.  Single valued."
}

# preferredLanguage
if ("urn:oid:2.16.840.1.113730.3.1.39" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.16.840.1.113730.3.1.39" `
	  -Name "Preferred Language (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Preferred written or spoken language for a person. See RFC2068 and ISO 639 for allowable values in this field. Esperanto, for example is EO in ISO 639, and RFC2068 would allow a value of en-US for US English."
}

# schacHomeOrganization
if ("urn:oid:1.3.6.1.4.1.25178.1.2.9" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.25178.1.2.9" `
	  -Name "schac Home Organization (URN)" `
	  -ShortName "schacHomeOrganization" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Specifies a person's home organization using the domain name of the organization. Issuers of schacHomeOrganization attribute values via SAML are strongly encouraged to publish matching shibmd:Scope elements as part of their IDP's SAML metadata. Relaying Parties recieving schacHomeOrganization values via SAML are strongly encouraged to check attribute values against the Issuer's published shibmd:Scope elements in SAML metadata, and may discard any non-matching values."
}

# eduPersonTargetedID
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.10" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.10" `
	  -Name "eduPerson Targeted ID (URN)" `
	  -ShortName "eduPersonTargetedID" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "A persistent, non-reassigned, opaque identifier for a principal. eduPersonTargetedID is an abstracted version of the SAML V2.0 Name Identifier format of 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent' (see http://www.oasis-open.org/committees/download.php/35711). In SAML, this is an XML construct consisting of a string value inside a <saml:NameID> element along with a number of XML attributes, of most significance NameQualifier and SPNameQualifier, which identify the source and intended audience of the value. It is left to specific profiles to define alternate syntaxes, if any, to the standard XML representation used in SAML."
}

# o
if ("urn:oid:2.5.4.10" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:2.5.4.10" `
	  -Name "Organization Name (URN)" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Standard name of the top-level organization (institution) with which this person is associated. Meant to carry the TOP-LEVEL organization name. Do not use this attribute to carry school college names."
}

# schacHomeOrganizationType
if ("urn:oid:1.3.6.1.4.1.25178.1.2.10" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.25178.1.2.10" `
	  -Name "schac Home Organization Type (URN)" `
	  -ShortName "schacHomeOrganizationType" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Type of a Home Organization. (See controlled vocabulary)."
}

# eduPersonEntitlement
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.7" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.7" `
	  -Name "eduPerson Entitlement (URN)" `
	  -ShortName "eduPersonEntitlement" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "URI (either URN or URL) that indicates a set of rights to specific resources. A simple example would be a URL for a contract with a licensed resource provider. When a principal's home institutional directory is allowed to assert such entitlements, the business rules that evaluate a person's attributes to determine eligibility are evaluated there. The target resource provider does not learn characteristics of the person beyond their entitlement. The trust between the two parties must be established out of band. One check would be for the target resource provider to maintain a list of subscribing institutions. Assertions of entitlement from institutions not on this list would not be honored."
}

# eduPersonAssurance
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.11" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.11" `
	  -Name "eduPerson Assurance (URN)" `
	  -ShortName "eduPersonAssurance" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "Set of URIs that assert compliance with specific standards for identity assurance."
}

# eduPersonUniqueId
if ("urn:oid:1.3.6.1.4.1.5923.1.1.1.13" -notin @(Get-AdfsClaimDescription | foreach { $_.ClaimType }))
{
	Add-AdfsClaimDescription -ClaimType "urn:oid:1.3.6.1.4.1.5923.1.1.1.13" `
	  -Name "eduPerson Unique Id (URN)" `
	  -ShortName "eduPersonUniqueId" `
	  -IsAccepted:$true `
	  -IsOffered:$true `
	  -IsRequired:$false `
	  -Notes "A persistent, opaque, non-reassignable, omnidirectional identifier that uniquely identifies the subject."
}

# SIG # Begin signature block
# MIInSwYJKoZIhvcNAQcCoIInPDCCJzgCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCdwDZ8awI+AZMx
# sHf9rk5kReXufHCULjplPvZ/PjQ52aCCIDYwggVvMIIEV6ADAgECAhBI/JO0YFWU
# jTanyYqJ1pQWMA0GCSqGSIb3DQEBDAUAMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQI
# DBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoM
# EUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2Vy
# dmljZXMwHhcNMjEwNTI1MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjBWMQswCQYDVQQG
# EwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0wKwYDVQQDEyRTZWN0aWdv
# IFB1YmxpYyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQCN55QSIgQkdC7/FiMCkoq2rjaFrEfUI5ErPtx94jGgUW+s
# hJHjUoq14pbe0IdjJImK/+8Skzt9u7aKvb0Ffyeba2XTpQxpsbxJOZrxbW6q5KCD
# J9qaDStQ6Utbs7hkNqR+Sj2pcaths3OzPAsM79szV+W+NDfjlxtd/R8SPYIDdub7
# P2bSlDFp+m2zNKzBenjcklDyZMeqLQSrw2rq4C+np9xu1+j/2iGrQL+57g2extme
# me/G3h+pDHazJyCh1rr9gOcB0u/rgimVcI3/uxXP/tEPNqIuTzKQdEZrRzUTdwUz
# T2MuuC3hv2WnBGsY2HH6zAjybYmZELGt2z4s5KoYsMYHAXVn3m3pY2MeNn9pib6q
# RT5uWl+PoVvLnTCGMOgDs0DGDQ84zWeoU4j6uDBl+m/H5x2xg3RpPqzEaDux5mcz
# mrYI4IAFSEDu9oJkRqj1c7AGlfJsZZ+/VVscnFcax3hGfHCqlBuCF6yH6bbJDoEc
# QNYWFyn8XJwYK+pF9e+91WdPKF4F7pBMeufG9ND8+s0+MkYTIDaKBOq3qgdGnA2T
# OglmmVhcKaO5DKYwODzQRjY1fJy67sPV+Qp2+n4FG0DKkjXp1XrRtX8ArqmQqsV/
# AZwQsRb8zG4Y3G9i/qZQp7h7uJ0VP/4gDHXIIloTlRmQAOka1cKG8eOO7F/05QID
# AQABo4IBEjCCAQ4wHwYDVR0jBBgwFoAUoBEKIz6W8Qfs4q8p74Klf9AwpLQwHQYD
# VR0OBBYEFDLrkpr/NZZILyhAQnAgNpFcF4XmMA4GA1UdDwEB/wQEAwIBhjAPBgNV
# HRMBAf8EBTADAQH/MBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsGA1UdIAQUMBIwBgYE
# VR0gADAIBgZngQwBBAEwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC5jb21v
# ZG9jYS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNAYIKwYBBQUHAQEE
# KDAmMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZI
# hvcNAQEMBQADggEBABK/oe+LdJqYRLhpRrWrJAoMpIpnuDqBv0WKfVIHqI0fTiGF
# OaNrXi0ghr8QuK55O1PNtPvYRL4G2VxjZ9RAFodEhnIq1jIV9RKDwvnhXRFAZ/ZC
# J3LFI+ICOBpMIOLbAffNRk8monxmwFE2tokCVMf8WPtsAO7+mKYulaEMUykfb9gZ
# pk+e96wJ6l2CxouvgKe9gUhShDHaMuwV5KZMPWw5c9QLhTkg4IUaaOGnSDip0TYl
# d8GNGRbFiExmfS9jzpjoad+sPKhdnckcW67Y8y90z7h+9teDnRGWYpquRRPaf9xH
# +9/DUp/mBlXpnYzyOmJRvOwkDynUWICE5EV7WtgwggYaMIIEAqADAgECAhBiHW0M
# UgGeO5B5FSCJIRwKMA0GCSqGSIb3DQEBDAUAMFYxCzAJBgNVBAYTAkdCMRgwFgYD
# VQQKEw9TZWN0aWdvIExpbWl0ZWQxLTArBgNVBAMTJFNlY3RpZ28gUHVibGljIENv
# ZGUgU2lnbmluZyBSb290IFI0NjAeFw0yMTAzMjIwMDAwMDBaFw0zNjAzMjEyMzU5
# NTlaMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzAp
# BgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYwggGiMA0G
# CSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCbK51T+jU/jmAGQ2rAz/V/9shTUxjI
# ztNsfvxYB5UXeWUzCxEeAEZGbEN4QMgCsJLZUKhWThj/yPqy0iSZhXkZ6Pg2A2NV
# DgFigOMYzB2OKhdqfWGVoYW3haT29PSTahYkwmMv0b/83nbeECbiMXhSOtbam+/3
# 6F09fy1tsB8je/RV0mIk8XL/tfCK6cPuYHE215wzrK0h1SWHTxPbPuYkRdkP05Zw
# mRmTnAO5/arnY83jeNzhP06ShdnRqtZlV59+8yv+KIhE5ILMqgOZYAENHNX9SJDm
# +qxp4VqpB3MV/h53yl41aHU5pledi9lCBbH9JeIkNFICiVHNkRmq4TpxtwfvjsUe
# dyz8rNyfQJy/aOs5b4s+ac7IH60B+Ja7TVM+EKv1WuTGwcLmoU3FpOFMbmPj8pz4
# 4MPZ1f9+YEQIQty/NQd/2yGgW+ufflcZ/ZE9o1M7a5Jnqf2i2/uMSWymR8r2oQBM
# dlyh2n5HirY4jKnFH/9gRvd+QOfdRrJZb1sCAwEAAaOCAWQwggFgMB8GA1UdIwQY
# MBaAFDLrkpr/NZZILyhAQnAgNpFcF4XmMB0GA1UdDgQWBBQPKssghyi47G9IritU
# pimqF6TNDDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNV
# HSUEDDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEsG
# A1UdHwREMEIwQKA+oDyGOmh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGlnb1B1
# YmxpY0NvZGVTaWduaW5nUm9vdFI0Ni5jcmwwewYIKwYBBQUHAQEEbzBtMEYGCCsG
# AQUFBzAChjpodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2Rl
# U2lnbmluZ1Jvb3RSNDYucDdjMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0
# aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEABv+C4XdjNm57oRUgmxP/BP6YdURh
# w1aVcdGRP4Wh60BAscjW4HL9hcpkOTz5jUug2oeunbYAowbFC2AKK+cMcXIBD0Zd
# OaWTsyNyBBsMLHqafvIhrCymlaS98+QpoBCyKppP0OcxYEdU0hpsaqBBIZOtBajj
# cw5+w/KeFvPYfLF/ldYpmlG+vd0xqlqd099iChnyIMvY5HexjO2AmtsbpVn0OhNc
# WbWDRF/3sBp6fWXhz7DcML4iTAWS+MVXeNLj1lJziVKEoroGs9Mlizg0bUMbOalO
# hOfCipnx8CaLZeVme5yELg09Jlo8BMe80jO37PU8ejfkP9/uPak7VLwELKxAMcJs
# zkyeiaerlphwoKx1uHRzNyE6bxuSKcutisqmKL5OTunAvtONEoteSiabkPVSZ2z7
# 6mKnzAfZxCl/3dq3dUNw4rg3sTCggkHSRqTqlLMS7gjrhTqBmzu1L90Y1KWN/Y5J
# KdGvspbOrTfOXyXvmPL6E52z1NZJ6ctuMFBQZH3pwWvqURR8AgQdULUvrxjUYbHH
# j95Ejza63zdrEcxWLDX6xWls/GDnVNueKjWUH3fTv1Y8Wdho698YADR7TNx8X8z2
# Bev6SivBBOHY+uqiirZtg0y9ShQoPzmCcn63Syatatvx157YK9hlcPmVoa1oDE5/
# L9Uo2bC5a4CH2RwwggamMIIFDqADAgECAhEAhgkXPfTa6cpuclb43FIZnjANBgkq
# hkiG9w0BAQwFADBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1p
# dGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2
# MB4XDTIxMTExOTAwMDAwMFoXDTIyMTExOTIzNTk1OVowgagxCzAJBgNVBAYTAlpB
# MRUwEwYDVQQIDAxXZXN0ZXJuIENhcGUxQDA+BgNVBAoMN1RlcnRpYXJ5IEVkdWNh
# dGlvbiBhbmQgUmVzZWFyY2ggTmV0d29yayBvZiBTb3V0aCBBZnJpY2ExQDA+BgNV
# BAMMN1RlcnRpYXJ5IEVkdWNhdGlvbiBhbmQgUmVzZWFyY2ggTmV0d29yayBvZiBT
# b3V0aCBBZnJpY2EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDdKiEk
# AeVezG5kJMTAQd7d2d/7qjADkKbH07ecmPLawiQS9ypsnHLbHFHKu4LIrpCtYzoy
# PKsBzeMJUDt7jZAH/Fr5nJw58+rmHNkskR72k45LLzzD0pYE79Vm/RaWa24NBliL
# scMVHKWsy2z2DbF3ObC63D5u7XFNsqjbzer2jHfy7lqZ8qGZ4qTZD+yZG/Q+3zgK
# imAxCCJQbi3dfsejKdWNDDB7v5EL2exqPfa9YDeAf+fo5RMXyHq12dBS3QICSr9Y
# o1uRUOdpHUEC76RZQvPRWws5LVXkRYAD4Y+sS6R/C6j82o+qDhf+DpsZja/WFFzr
# TQvY8kIxawyJVGWy7ytCBMCtfOYEQRuGxtqZ9HCnBEHIK7i42Zm2Z7H5VKU237bJ
# 8TbMsB2EdqikCyomV3oU2BuYRwDlV2UblLOuFDGpX/p+3GaS5L8EDWWwaxiXc587
# PpIW+FLCrCtvjcnWTRVkwH4lETwAn5vo3ZJoOPG9UR7CcJYnVdLOm8hJbSY3upSt
# cEFPbDNIY5AYK/N4Ayy88SYzkikFkDDT8bHqHk2J14jNkz1/noaMpFiayROINFao
# QHVQol4SUQJh6uqw8TBjWo0dB4XXMrgKws2rt0fqAVTgflobbWw7l5yvmn5xq8xn
# yK9iNisGM5cQEnnZ+NgeEUPLDnxgUriPsY+dvwIDAQABo4IBnDCCAZgwHwYDVR0j
# BBgwFoAUDyrLIIcouOxvSK4rVKYpqhekzQwwHQYDVR0OBBYEFCsjX7/TLE++hCKz
# BqnJixqfa7S8MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMBEGCWCGSAGG+EIBAQQEAwIEEDBKBgNVHSAEQzBBMDUGDCsG
# AQQBsjEBAgEDAjAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQ
# UzAIBgZngQwBBAEwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5zZWN0aWdv
# LmNvbS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdDQVIzNi5jcmwweQYIKwYBBQUH
# AQEEbTBrMEQGCCsGAQUFBzAChjhodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3Rp
# Z29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNydDAjBggrBgEFBQcwAYYXaHR0cDov
# L29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQADggGBAHLjLE8JjbHTtX0+
# G1GZ782MaS4EttbQZ+/9EtT7Dt20xf/z0xM4tBUHGMdKY3AV2SpDVoQXsA5+wNn/
# fe79ZrtykizAUEh3T9dndVZ1lwYpB3L2sUZVrF+lb49UkbVt6UCs3eOi2BCCI4Op
# ar54NwFpe8SIZxJpdgBnzVQ8/3dDIG69swc+7rSQySw33WxTSAB9sB696VEABjZm
# voA8gDcxMTGEyMI0i6DEZb1gUnPGeNEJZj9S6+4EOaHYjw+NP/zpJRYce0TGXLew
# wc33RMgTy5hlD4Y2ULyVrXEvHAHASDoZbe+tlgOvI/jy3Ne3TU7456qBEk7B/my/
# y07mcSkzAfWBT2wVs/YxAnbsKKo8viRIENXBf6dMluwk1x+u8Amz7BS6WnD7gcXK
# 148xc1+sZ1ryETc/voQ5tcD8mOAVx8w1ZJOXgHQEiLF+YCo/sj1gx74gr5LSC+kU
# oVsTSLECemdw/c5PI49UyY3dFRYUDNKuZsC4p+WV0HYlB3jEZTCCBuwwggTUoAMC
# AQICEDAPb6zdZph0fKlGNqd4LbkwDQYJKoZIhvcNAQEMBQAwgYgxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEe
# MBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1
# c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE5MDUwMjAwMDAwMFoX
# DTM4MDExODIzNTk1OVowfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
# TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBM
# aW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBUaW1lIFN0YW1waW5nIENBMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyBsBr9ksfoiZfQGYPyCQvZyA
# IVSTuc+gPlPvs1rAdtYaBKXOR4O168TMSTTL80VlufmnZBYmCfvVMlJ5LsljwhOb
# toY/AQWSZm8hq9VxEHmH9EYqzcRaydvXXUlNclYP3MnjU5g6Kh78zlhJ07/zObu5
# pCNCrNAVw3+eolzXOPEWsnDTo8Tfs8VyrC4Kd/wNlFK3/B+VcyQ9ASi8Dw1Ps5EB
# jm6dJ3VV0Rc7NCF7lwGUr3+Az9ERCleEyX9W4L1GnIK+lJ2/tCCwYH64TfUNP9vQ
# 6oWMilZx0S2UTMiMPNMUopy9Jv/TUyDHYGmbWApU9AXn/TGs+ciFF8e4KRmkKS9G
# 493bkV+fPzY+DjBnK0a3Na+WvtpMYMyou58NFNQYxDCYdIIhz2JWtSFzEh79qsoI
# WId3pBXrGVX/0DlULSbuRRo6b83XhPDX8CjFT2SDAtT74t7xvAIo9G3aJ4oG0paH
# 3uhrDvBbfel2aZMgHEqXLHcZK5OVmJyXnuuOwXhWxkQl3wYSmgYtnwNe/YOiU2fK
# sfqNoWTJiJJZy6hGwMnypv99V9sSdvqKQSTUG/xypRSi1K1DHKRJi0E5FAMeKfob
# pSKupcNNgtCN2mu32/cYQFdz8HGj+0p9RTbB942C+rnJDVOAffq2OVgy728YUInX
# T50zvRq1naHelUF6p4MCAwEAAaOCAVowggFWMB8GA1UdIwQYMBaAFFN5v1qqK0rP
# VIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQaofhhGSAPw0F3RSiO0TVfBhIEVTAOBgNV
# HQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUEDDAKBggrBgEF
# BQcDCDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDov
# L2NybC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRo
# b3JpdHkuY3JsMHYGCCsGAQUFBwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2Ny
# dC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUFkZFRydXN0Q0EuY3J0MCUGCCsG
# AQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUA
# A4ICAQBtVIGlM10W4bVTgZF13wN6MgstJYQRsrDbKn0qBfW8Oyf0WqC5SVmQKWxh
# y7VQ2+J9+Z8A70DDrdPi5Fb5WEHP8ULlEH3/sHQfj8ZcCfkzXuqgHCZYXPO0EQ/V
# 1cPivNVYeL9IduFEZ22PsEMQD43k+ThivxMBxYWjTMXMslMwlaTW9JZWCLjNXH8B
# lr5yUmo7Qjd8Fng5k5OUm7Hcsm1BbWfNyW+QPX9FcsEbI9bCVYRm5LPFZgb289ZL
# Xq2jK0KKIZL+qG9aJXBigXNjXqC72NzXStM9r4MGOBIdJIct5PwC1j53BLwENrXn
# d8ucLo0jGLmjwkcd8F3WoXNXBWiap8k3ZR2+6rzYQoNDBaWLpgn/0aGUpk6qPQn1
# BWy30mRa2Coiwkud8TleTN5IPZs0lpoJX47997FSkc4/ifYcobWpdR9xv1tDXWU9
# UIFuq/DQ0/yysx+2mZYm9Dx5i1xkzM3uJ5rloMAMcofBbk1a0x7q8ETmMm8c6xdO
# lMN4ZSA7D0GqH+mhQZ3+sbigZSo04N6o+TzmwTC7wKBjLPxcFgCo0MR/6hGdHgbG
# pm0yXbQ4CStJB6r97DDa8acvz7f9+tCjhNknnvsBZne5VhDhIG7GrrH5trrINV0z
# do7xfCAMKneutaIChrop7rRaALGMq+P5CslUXdS5anSevUiumDCCBwcwggTvoAMC
# AQICEQCMd6AAj/TRsMY9nzpIg41rMA0GCSqGSIb3DQEBDAUAMH0xCzAJBgNVBAYT
# AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZv
# cmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBS
# U0EgVGltZSBTdGFtcGluZyBDQTAeFw0yMDEwMjMwMDAwMDBaFw0zMjAxMjIyMzU5
# NTlaMIGEMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxLDAq
# BgNVBAMMI1NlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgU2lnbmVyICMyMIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAkYdLLIvB8R6gntMHxgHKUrC+eXld
# CWYGLS81fbvA+yfaQmpZGyVM6u9A1pp+MshqgX20XD5WEIE1OiI2jPv4ICmHrHTQ
# G2K8P2SHAl/vxYDvBhzcXk6Th7ia3kwHToXMcMUNe+zD2eOX6csZ21ZFbO5LIGzJ
# Pmz98JvxKPiRmar8WsGagiA6t+/n1rglScI5G4eBOcvDtzrNn1AEHxqZpIACTR0F
# qFXTbVKAg+ZuSKVfwYlYYIrv8azNh2MYjnTLhIdBaWOBvPYfqnzXwUHOrat2iyCA
# 1C2VB43H9QsXHprl1plpUcdOpp0pb+d5kw0yY1OuzMYpiiDBYMbyAizE+cgi3/kn
# gqGDUcK8yYIaIYSyl7zUr0QcloIilSqFVK7x/T5JdHT8jq4/pXL0w1oBqlCli3aV
# G2br79rflC7ZGutMJ31MBff4I13EV8gmBXr8gSNfVAk4KmLVqsrf7c9Tqx/2RJzV
# mVnFVmRb945SD2b8mD9EBhNkbunhFWBQpbHsz7joyQu+xYT33Qqd2rwpbD1W7b94
# Z7ZbyF4UHLmvhC13ovc5lTdvTn8cxjwE1jHFfu896FF+ca0kdBss3Pl8qu/Cdklo
# YtWL9QPfvn2ODzZ1RluTdsSD7oK+LK43EvG8VsPkrUPDt2aWXpQy+qD2q4lQ+s6g
# 8wiBGtFEp8z3uDECAwEAAaOCAXgwggF0MB8GA1UdIwQYMBaAFBqh+GEZIA/DQXdF
# KI7RNV8GEgRVMB0GA1UdDgQWBBRpdTd7u501Qk6/V9Oa258B0a7e0DAOBgNVHQ8B
# Af8EBAMCBsAwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBA
# BgNVHSAEOTA3MDUGDCsGAQQBsjEBAgEDCDAlMCMGCCsGAQUFBwIBFhdodHRwczov
# L3NlY3RpZ28uY29tL0NQUzBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLnNl
# Y3RpZ28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5jcmwwdAYIKwYBBQUH
# AQEEaDBmMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3Rp
# Z29SU0FUaW1lU3RhbXBpbmdDQS5jcnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3Nw
# LnNlY3RpZ28uY29tMA0GCSqGSIb3DQEBDAUAA4ICAQBKA3iQQjPsexqDCTYzmFW7
# nUAGMGtFavGUDhlQ/1slXjvhOcRbuumVkDc3vd/7ZOzlgreVzFdVcEtO9KiH3SKF
# ple7uCEn1KAqMZSKByGeir2nGvUCFctEUJmM7D66A3emggKQwi6Tqb4hNHVjueAt
# D88BN8uNovq4WpquoXqeE5MZVY8JkC7f6ogXFutp1uElvUUIl4DXVCAoT8p7s7Ol
# 0gCwYDRlxOPFw6XkuoWqemnbdaQ+eWiaNotDrjbUYXI8DoViDaBecNtkLwHHwaHH
# JJSjsjxusl6i0Pqo0bglHBbmwNV/aBrEZSk1Ki2IvOqudNaC58CIuOFPePBcysBA
# XMKf1TIcLNo8rDb3BlKao0AwF7ApFpnJqreISffoCyUztT9tr59fClbfErHD7s6R
# d+ggE+lcJMfqRAtK5hOEHE3rDbW4hqAwp4uhn7QszMAWI8mR5UIDS4DO5E3mKgE+
# wF6FoCShF0DV29vnmBCk8eoZG4BU+keJ6JiBqXXADt/QaJR5oaCejra3QmbL2dlr
# L03Y3j4yHiDk7JxNQo2dxzOZgjdE1CYpJkCOeC+57vov8fGP/lC4eN0Ult4cDnCw
# KoVqsWxo6SrkECtuIf3TfJ035CoG1sPx12jjTwd5gQgT/rJkXumxPObQeCOyCSzi
# JmK/O6mXUczHRDKBsq/P3zGCBmswggZnAgEBMGkwVDELMAkGA1UEBhMCR0IxGDAW
# BgNVBAoTD1NlY3RpZ28gTGltaXRlZDErMCkGA1UEAxMiU2VjdGlnbyBQdWJsaWMg
# Q29kZSBTaWduaW5nIENBIFIzNgIRAIYJFz302unKbnJW+NxSGZ4wDQYJYIZIAWUD
# BAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkq
# hkiG9w0BCQQxIgQg2Nho6PE+DkKuHapt89eqiEO1JkPYfVFTcDFJ6xsh+OgwDQYJ
# KoZIhvcNAQEBBQAEggIAzqAXm9VIe0STpo0HxXm2fZoDDjtUqtk6coEhxeXtC1Tr
# /K7LNu+KIeuXUVvhywMBvwCMEtywWmOvsvu2tMLsjRjlDdnLt0FgXhxTKpEvwRtR
# NqmCw3jUGcN9jc+CpSw5yCutdduqqIL2/KQvTKZJt6eAOF3i5vJL6rDpUTvOmHXa
# tPlmL5n0WB8wASh+DGYCEzowfAk40bZHs/jgtgF1Dn8AUHfXwcjmLPHNcaqGdMqq
# FTUwDfJ3dSuEEPueZY+2ckgycfaUB2ylVcP1cMVkuv+H5HIl6Co/MMVjRlxVXrrf
# MK74eBalnOhmah+5qqr46si7eGJW5l/g4LisrPZ8HMQ5zVozgzZHokFzoAi0wmDm
# shyhBW19+qqEAa7C7HSG1MME87WF7LO2RuSRdGz1vO0FC5NpUvhe42Mkj0blKkF2
# jpdwPWMnaq0T0wG9Ld9XMbGiG6n/EiUUFI8xnp0uTaUSlTQ+0c/axddzhJID5R16
# IjScLE58O5RxHcqbFINjCTVB6rkFegmAVHrwxO2rZa4NOz9tv+71thhf6WW+dCzn
# lS6+4X4xrbkEcYQ2pgX5V0GyMeRoAVVZKkaDrAFWrniXnIinyrficlo0iOPw7/eK
# 33cer2YsXklw5wotBlWlKSz/lrnf4gr8+8oo6Q/JZmevQds7zftYdJJXmZdDNEmh
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDQwNzE4MDYxN1owPwYJKoZIhvcNAQkEMTIEMPE4KgLH2CfA0NcfaUw8e9LJlwWu
# hvYRrvdWze127Fs+RVGq5V7sF2nXRLEijwW6tTANBgkqhkiG9w0BAQEFAASCAgB2
# SxDXyIWi3ZWUgRP93XXzzwY6vHaSWA9mTiZJXYMQtOlD+sBQ1QqoiOiA2Y6jKnTp
# tSzyZtB9tCw8STwTg0tGypFKRn6AE+VCIp4EBTd/mJk0nY1319COn6Kzd342D0Gv
# jAe1ooOPILSl9rj1uCrllYe9NUHCqUCeCIaBF4gzVdcDIE4PkvBf4OTqTibzFHt6
# AF9aNaeO4iJ24QRjBxxjDF5GYzy/PhMDEPJfNbLV6sEc0iuHykqLKpLdKI0/eTvT
# XEMu/0b9BcFmMFbOhBucDj8IcRon1m00yrSePGvKwn73woiTyfgp1blKnau/XkZa
# 5Kfx4b+pto45Qx6NcpgyccY1RN4pVu3QpnIkuVrL4WWAIoP6Xc/CHopYsrwJN9tF
# 5B0KKH5WrJYXJwOu3SQ2Aoob9YG9G0Ypbc3fwHsbDnszJTSXYSF4sbdf9Fz4vhCu
# 6HlYdWCSezPYi/T2DHZXUt4hGjC/lBvI3M/yLFIn1HwRX3Y1UEwMiFQG2Dibp7Zc
# SvDYyvSE4oktrtGqciwPMzhto1+D8j0Pv1EjrgNmLmMk496rlZqu9A6XD3FuWpr9
# IlukbIo9kz1qH/iHzWfQhgWpkzULs2xhLUTSDjK8ea7ucZiyQtBXzFwcmIuDKEsj
# QmGcaLrtRT4gRqrKjN+4pr2WIONNwBvZgInLOBTkeg==
# SIG # End signature block
