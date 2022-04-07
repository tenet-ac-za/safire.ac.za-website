#
# Automate the addition of SAFIRE's metadata to ADFS
#
# @author Guy Halse http://orcid.org/0000-0002-9388-8592
# @copyright Copyright (c) 2017, Tertiary Education and Research Network of South Africa
# @license https://opensource.org/licenses/MIT MIT License
#
param(
    [string]$idpScope = ( Read-Host "What is your default DNS domain name? " )
)

$sp_entityid = "https://iziko.safire.ac.za"

Write-Host "Adding SAFIRE Relying Party Trust"
Add-AdfsRelyingPartyTrust -Name "SAFIRE - South African Identity Federation" `
    -MetadataUrl "https://metadata.safire.ac.za/safire-hub-metadata.xml" `
    -MonitoringEnabled $true `
    -AutoUpdateEnabled $true `
    -Enabled $true `
    -SignatureAlgorithm "http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" `
    -EncryptClaims $false `
    -EncryptedNameIdRequired $false `
    -SignedSamlRequestsRequired $false `
    -Notes "South African Identity Federation hub, autoconfigured from PowerShell script at https://safire.ac.za/technical/resources/configuring-adfs-for-safire/"

Write-Host "Setting Access Control Policy for SAFIRE Relying Party"
Set-AdfsRelyingPartyTrust -TargetIdentifier $sp_entityid -AccessControlPolicyName "Permit everyone"

# This portion is derived from the work of Matthew Economou, NIH/NIAID

# The Transform UPN to eduPersonPrincipalName rule below takes the left-hand
# side of the userPrincipalName and appends the scope that we were given at
# the beginning of the script. This allows us to handle UPNs of the form
# user@example.local and rewrite them to user@example.ac.za. We have done
# this because the example.local form is fairly common, and this gives us
# a "safe" default. Note that if your AD already uses UPNs with a correct
# FQDN as the scope, you do not need this transform -- rather just map your
# UPN directly to eduPersonPrincipalName as part of the previous "Get LDAP
# Attributes from AD" claim rule.

$issuance_transform_rules_template = '
@RuleTemplate = "LdapClaims"
@RuleName = "Get LDAP Attributes from AD"
c:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname", Issuer == "AD AUTHORITY"] => issue(store = "Active Directory", types = ("http://schemas.xmlsoap.org/claims/Group", "urn:oid:0.9.2342.19200300.100.1.3", "urn:oid:2.5.4.42", "urn:oid:2.5.4.4", "urn:oid:2.16.840.1.113730.3.1.241", "urn:oid:2.16.840.1.113730.3.1.3"), query = ";tokenGroups,mail,givenName,sn,displayName,employeeNumber;{0}", param = c.Value);

@RuleName = "Transform UPN to eduPersonPrincipalName"
c:[Type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn", Value =~ "^(?<user>[^@]+)@(.+)$"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.6", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = regexreplace(c.Value, "^(?<user>[^@]+)@(.+)$", "${user}@IDP_SCOPE"), ValueType = c.ValueType, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonScopedAffiliation (member) for Domain Users"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "Domain Users"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.9", Value = "member@IDP_SCOPE", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonAffiliation (member) for Domain Users"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "Domain Users"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.1", Value = "member", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonScopedAffiliation (employee) for MyStaffGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStaffGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.9", Value = "employee@IDP_SCOPE", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonAffiliation (employee) for MyStaffGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStaffGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.1", Value = "employee", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonScopedAffiliation (staff) for MyStaffGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStaffGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.9", Value = "staff@IDP_SCOPE", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonAffiliation (staff) for MyStaffGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStaffGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.1", Value = "staff", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonScopedAffiliation (student) for MyStudentGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStudentGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.9", Value = "student@IDP_SCOPE", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonAffiliation (student) for MyStudentGroup"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "MyStudentGroup"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.1", Value = "student", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleTemplate = "EmitGroupClaims"
@RuleName = "eduPersonEntitlement (common-lib-terms) for Domain Users"
c:[Type == "http://schemas.xmlsoap.org/claims/Group", Value == "Domain Users"] => issue(Type = "urn:oid:1.3.6.1.4.1.5923.1.1.1.7", Value = "urn:mace:dir:entitlement:common-lib-terms", Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/attributename"] = "urn:oasis:names:tc:SAML:2.0:attrname-format:uri");

@RuleName = "Create Per-Session Identifier"
c1:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname"] && c2:[Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/authenticationinstant"] => add(store = "_OpaqueIdStore", types = ("https://federation.IDP_SCOPE/internal/sessionid"), query = "{0};{1};{2};{3};{4}", param = "useEntropy", param = c1.Value, param = c1.OriginalIssuer, param = "", param = c2.Value);

@RuleTemplate = "MapClaims"
@RuleName = "Transform Per-Session ID into Name ID"
c:[Type == "https://federation.IDP_SCOPE/internal/sessionid"] => issue(Type = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, Value = c.Value, ValueType = c.ValueType, Properties["http://schemas.xmlsoap.org/ws/2005/05/identity/claimproperties/format"] = "urn:oasis:names:tc:SAML:2.0:nameid-format:transient");

@RuleTemplate = "PassThroughClaims"
@RuleName = "Pass Authentication Methods References"
c:[Type == "http://schemas.microsoft.com/claims/authnmethodsreferences"] => issue(claim = c);
'

Write-Host "Using $idpScope as scoping value for ePPN and ePA"
$issuance_transform_rules = $issuance_transform_rules_template -replace 'IDP_SCOPE', $idpScope

Write-Host "Creating Claim Issuance Policy for SAFIRE Relying Party"
Set-AdfsRelyingPartyTrust -TargetIdentifier $sp_entityid -IssuanceTransformRules $issuance_transform_rules

Write-Host "Disable unnecessary claim encryption for SAFIRE Relying Party"
Set-AdfsRelyingPartyTrust -TargetIdentifier $sp_entityid -EncryptClaims $false

# 4.3.2 The Service Provider claims to refresh federation metadata at least daily
$MonitoringInterval = Get-AdfsProperties | select -ExpandProperty MonitoringInterval
if ($MonitoringInterval -gt 1440 -or $MonitoringInterval -lt 5) {
    Write-Host "Setting MonitoringInterval to 1440 (1 day) for R&S compliance"
    Set-AdfsProperties -MonitoringInterval 1440
} else {
    Write-Host "MonitoringInterval of $MonitoringInterval complies with R&S requirements"
}


# SIG # Begin signature block
# MIInSwYJKoZIhvcNAQcCoIInPDCCJzgCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC/VREFrSAfyUl/
# l3B/1bgdkzYkx0wQgPeyl2XViaTNyKCCIDYwggVvMIIEV6ADAgECAhBI/JO0YFWU
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
# hkiG9w0BCQQxIgQgYxPdUijW1ESoVyjg089tFmuw46oPPzjigzdVf61evHwwDQYJ
# KoZIhvcNAQEBBQAEggIAcBuDgnvPJiOGr2avPUqNfC+cTmWzb59bSMrBi5cAX2dS
# mU+sSr3SXKYajXMORfwwrouLV7Li9KYielytjBawes0l4fFlBoibiefWeL5p2Ybh
# LKTd5enn2PaqGQjXv80xtuGcwnBTcITEzndyDoAN/l/IWEOBPDeTL6Dac7f9B/PN
# AtSFyHyp7L7XarBrv/9+UTafhOisLOsx3r00axSyG7xQdcpas5Jt5lKK8TVDKQaZ
# ucM3PmKAEIdQdugA6/z+rMPhmlBPNIM+58OuDLFIW7QmZbR8u/e/6AQidJHg+pqL
# aOZQXxFx1uxAug1rtWVRY3ShVSNIgOSvXEoDrSzUKMEWF5fj7hWk+jtQwNzIvrs1
# mibSiBQCM9VuZYrhanadZO0QHQKecpu6kengC4cwJKg7Ln0xw+FnK3R0cXy+qNYk
# s8Bx6XkMDd8As243/n+scnI8OHFv6IksFidiwk+rpkqGJz8yK1ou2IvRb77eByDM
# I5FclMbpWbAv9OKzGL9CxjDCnVQYzPP4YLZA9gspPTvamRm3CNynKo3JC439FLIE
# W/SgQkJ8UTzbzvDlMdemDUVgCv5q5uXdNDbyK9rg/KS7k5DXC/snfLMkFG5FFhqY
# ey3sde2FEohmKId43vS+zcBYeSzv3LRIiGdZm67zMWnzJUvC9mrM0bvG/Zjzad2h
# ggNMMIIDSAYJKoZIhvcNAQkGMYIDOTCCAzUCAQEwgZIwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBAhEAjHegAI/00bDGPZ86SIONazANBglghkgBZQMEAgIF
# AKB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDQwNzE4MDQyNlowPwYJKoZIhvcNAQkEMTIEMLK3rh3PilGMuAUnUdbJVkn2lNpp
# pk+J8TN/2nXqvNmY6OXPKKN6vB6M4XTcXVPYhTANBgkqhkiG9w0BAQEFAASCAgAl
# oEVIIMY2WrKjmABdHYcf/a2e8BpcGELD8mgoSz1Geb1x+/X0MflsQimeOEwJ7yzG
# EUIrPigaGeYTknY685ZwlaJErniYhZxM1+gpf+hESTFTkU4OxAwIE7LTQCLKnawm
# D9E3ExWD/6h16KRq9jg/+XZRVXIGcU1Vj0R/iQRYZ9c9LmFyLwBwwCajKLyG+rFA
# oDbZZhJvzsj2ka4NzjVuKfdCqxtEnhQhFqK18ZbMTDcaUgmW3JkD97oS1ap3HQ9f
# 8ZhNZyaJyJ8jdFPx9eSQJh3pxSgE/++J/nHGURdKeKGnhHTepM7iY9V+vKljtCwk
# zcDhjrsqbJ2sDorYPgNISrBUKhfheZUV9YCT9Rz35iN0IjSXOuFCgNugc2h/r28Z
# OD5iih5dETRKSL2kP1WqNrJciQzs7xYjFIlfvwNIOVfURSRUX2b/6AplivQJKJ1y
# qEq589OWpNC+Rjb7Xv1Vj54r+kxsjB0I8iUUqSMDmZQzXI/3hUXCwVAGqPhT9cSt
# PYP7BJDU/Ge7MBH29fKdmoVA8dd4cQFE2HBx4Ozxl9vtMxICphECsgJm4tsoZTfX
# N39QT6rbS08u57DGuGHhxUtf1cyvzr7ZNV806T8RS1+y91Yu3jbp76GxKWGUfTIn
# 58jhm4Q3NRwReYhamGyclOd7NTzwfNeVKTj83+c73w==
# SIG # End signature block
