if($PowerCLI_IsDiagnosticSession) {
    [VMware.VimAutomation.Sdk.Interop.V1.CoreServiceFactory]::CoreService.Diagnostics.IsDiagnosticSession = $true
}

$CustomInitScriptName = "Initialize-PowerCLIEnvironment_Custom.ps1"
$currentDir = Split-Path $MyInvocation.MyCommand.Path
$CustomInitScript = Join-Path $currentDir $CustomInitScriptName

#returns the version of Powershell
# Note: When using, make sure to surround Get-PSVersion with parentheses to force value comparison
function Get-PSVersion { 
    if (test-path variable:psversiontable) {
		$psversiontable.psversion
	} else {
		[version]"1.0.0.0"
	} 
}

# Error message to update to version 3.0 of PowerShell
# Note: Make sure to surround Get-PSVersion with parentheses to force value comparison
if((Get-PSVersion) -lt "3.0"){
    $psVersion = Get-PSVersion
    Write-Error "$productShortName requires Powershell 3.0! The version of Powershell installed on this computer is $psVersion." -Category NotInstalled
}

# Opens documentation file
function global:Get-PowerCLIHelp{
   $url = "https://www.vmware.com/support/developer/PowerCLI/"
   $docProcess = [System.Diagnostics.Process]::Start($url)
}

# Opens toolkit community url with default browser
function global:Get-PowerCLICommunity{
    $link = "http://communities.vmware.com/community/vmtn/vsphere/automationtools/windows_toolkit"
    $browserProcess = [System.Diagnostics.Process]::Start($link)
}

# Find and execute custom initialization file
$existsCustomInitScript = Test-Path $CustomInitScript
if($existsCustomInitScript) {
   & $CustomInitScript
}

# Returns the path (with trailing backslash) to the directory where PowerCLI is installed.
function Get-InstallPath {
   throw "Get-InstallPath cmdlet is no longer supported. Please use (get-module <Module_Name>).ModuleBase instead."
}

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol `
	-bor [System.Net.SecurityProtocolType]::Tls12;

# CEIP

if ([VMware.VimAutomation.ViCore.Util10.SettingsManager]::ParticipateInCEIP -eq $null) {
	$message = `
			"Please consider joining the VMware Customer Experience Improvement Program, so you can help " +
			"us make PowerCLI a better product. You can join using the following command:" +
			"`n`nSet-PowerCLIConfiguration -Scope User -ParticipateInCEIP `$true`n`n" + 
			"VMware's Customer Experience Improvement Program (`"CEIP`") provides VMware with information " +
			"that enables VMware to improve its products and services, to fix problems, and to advise you " +
			"on how best to deploy and use our products.  As part of the CEIP, VMware collects technical information " +
			"about your organizationís use of VMware products and services on a regular basis in association " +
			"with your organizationís VMware license key(s).  This information does not personally identify " +
			"any individual." +
			"`n`nFor more details: type `"help about_ceip`" to see the related help article." +
			"`n`nTo disable this warning and set your preference use the following command and restart PowerShell: " +
			"`nSet-PowerCLIConfiguration -Scope User -ParticipateInCEIP `$true or `$false."

	Write-Warning -Message $message
}

# end CEIP
# SIG # Begin signature block
# MIIhmQYJKoZIhvcNAQcCoIIhijCCIYYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC49bFtx3Y35180
# +vdFc4oirIDE5243VB8ViEC/3FqpiaCCD8swggTMMIIDtKADAgECAhBdqtQcwalQ
# C13tonk09GI7MA0GCSqGSIb3DQEBCwUAMH8xCzAJBgNVBAYTAlVTMR0wGwYDVQQK
# ExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3Qg
# TmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYgQ29kZSBT
# aWduaW5nIENBMB4XDTE4MDgxMzAwMDAwMFoXDTIxMDkxMTIzNTk1OVowZDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExEjAQBgNVBAcMCVBhbG8gQWx0
# bzEVMBMGA1UECgwMVk13YXJlLCBJbmMuMRUwEwYDVQQDDAxWTXdhcmUsIEluYy4w
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCuswYfqnKot0mNu9VhCCCR
# vVcCrxoSdB6G30MlukAVxgQ8qTyJwr7IVBJXEKJYpzv63/iDYiNAY3MOW+Pb4qGI
# bNpafqxc2WLW17vtQO3QZwscIVRapLV1xFpwuxJ4LYdsxHPZaGq9rOPBOKqTP7Jy
# KQxE/1ysjzacA4NXHORf2iars70VpZRksBzkniDmurvwCkjtof+5krxXd9XSDEFZ
# 9oxeUGUOBCvSLwOOuBkWPlvCnzEqMUeSoXJavl1QSJvUOOQeoKUHRycc54S6Lern
# 2ddmdUDPwjD2cQ3PL8cgVqTsjRGDrCgOT7GwShW3EsRsOwc7o5nsiqg/x7ZmFpSJ
# AgMBAAGjggFdMIIBWTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIHgDArBgNVHR8E
# JDAiMCCgHqAchhpodHRwOi8vc3Yuc3ltY2IuY29tL3N2LmNybDBhBgNVHSAEWjBY
# MFYGBmeBDAEEATBMMCMGCCsGAQUFBwIBFhdodHRwczovL2Quc3ltY2IuY29tL2Nw
# czAlBggrBgEFBQcCAjAZDBdodHRwczovL2Quc3ltY2IuY29tL3JwYTATBgNVHSUE
# DDAKBggrBgEFBQcDAzBXBggrBgEFBQcBAQRLMEkwHwYIKwYBBQUHMAGGE2h0dHA6
# Ly9zdi5zeW1jZC5jb20wJgYIKwYBBQUHMAKGGmh0dHA6Ly9zdi5zeW1jYi5jb20v
# c3YuY3J0MB8GA1UdIwQYMBaAFJY7U/B5M5evfYPvLivMyreGHnJmMB0GA1UdDgQW
# BBTVp9RQKpAUKYYLZ70Ta983qBUJ1TANBgkqhkiG9w0BAQsFAAOCAQEAlnsx3io+
# W/9i0QtDDhosvG+zTubTNCPtyYpv59Nhi81M0GbGOPNO3kVavCpBA11Enf0CZuEq
# f/ctbzYlMRONwQtGZ0GexfD/RhaORSKib/ACt70siKYBHyTL1jmHfIfi2yajKkMx
# UrPM9nHjKeagXTCGthD/kYW6o7YKKcD7kQUyBhofimeSgumQlm12KSmkW0cHwSSX
# TUNWtshVz+74EcnZtGFI6bwYmhvnTp05hWJ8EU2Y1LdBwgTaRTxlSDP9JK+e63vm
# SXElMqnn1DDXABT5RW8lNt6g9P09a2J8p63JGgwMBhmnatw7yrMm5EAo+K6gVliJ
# LUMlTW3O09MbDTCCBVkwggRBoAMCAQICED141/l2SWCyYX308B7KhiowDQYJKoZI
# hvcNAQELBQAwgcoxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5j
# LjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazE6MDgGA1UECxMxKGMp
# IDIwMDYgVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9yaXplZCB1c2Ugb25seTFF
# MEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMyBQdWJsaWMgUHJpbWFyeSBDZXJ0aWZp
# Y2F0aW9uIEF1dGhvcml0eSAtIEc1MB4XDTEzMTIxMDAwMDAwMFoXDTIzMTIwOTIz
# NTk1OVowfzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0
# aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTAwLgYDVQQDEydT
# eW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqG
# SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCXgx4AFq8ssdIIxNdok1FgHnH24ke021hN
# I2JqtL9aG1H3ow0Yd2i72DarLyFQ2p7z518nTgvCl8gJcJOp2lwNTqQNkaC07BTO
# kXJULs6j20TpUhs/QTzKSuSqwOg5q1PMIdDMz3+b5sLMWGqCFe49Ns8cxZcHJI7x
# e74xLT1u3LWZQp9LYZVfHHDuF33bi+VhiXjHaBuvEXgamK7EVUdT2bMy1qEORkDF
# l5KK0VOnmVuFNVfT6pNiYSAKxzB3JBFNYoO2untogjHuZcrf+dWNsjXcjCtvanJc
# YISc8gyUXsBWUgBIzNP4pX3eL9cT5DiohNVGuBOGwhud6lo43ZvbAgMBAAGjggGD
# MIIBfzAvBggrBgEFBQcBAQQjMCEwHwYIKwYBBQUHMAGGE2h0dHA6Ly9zMi5zeW1j
# Yi5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBsBgNVHSAEZTBjMGEGC2CGSAGG+EUB
# BxcDMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vY3BzMCgG
# CCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3ltYXV0aC5jb20vcnBhMDAGA1UdHwQp
# MCcwJaAjoCGGH2h0dHA6Ly9zMS5zeW1jYi5jb20vcGNhMy1nNS5jcmwwHQYDVR0l
# BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4GA1UdDwEB/wQEAwIBBjApBgNVHREE
# IjAgpB4wHDEaMBgGA1UEAxMRU3ltYW50ZWNQS0ktMS01NjcwHQYDVR0OBBYEFJY7
# U/B5M5evfYPvLivMyreGHnJmMB8GA1UdIwQYMBaAFH/TZafC3ey78DAJ80M5+gKv
# MzEzMA0GCSqGSIb3DQEBCwUAA4IBAQAThRoeaak396C9pK9+HWFT/p2MXgymdR54
# FyPd/ewaA1U5+3GVx2Vap44w0kRaYdtwb9ohBcIuc7pJ8dGT/l3JzV4D4ImeP3Qe
# 1/c4i6nWz7s1LzNYqJJW0chNO4LmeYQW/CiwsUfzHaI+7ofZpn+kVqU/rYQuKd58
# vKiqoz0EAeq6k6IOUCIpF0yH5DoRX9akJYmbBWsvtMkBTCd7C6wZBSKgYBU/2sn7
# TUyP+3Jnd/0nlMe6NQ6ISf6N/SivShK9DbOXBd5EDBX6NisD3MFQAfGhEV0U5eK9
# J0tUviuEXg+mw3QFCu+Xw4kisR93873NQ9TxTKk/tYuEr2Ty0BQhMIIFmjCCA4Kg
# AwIBAgIKYRmT5AAAAAAAHDANBgkqhkiG9w0BAQUFADB/MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSkwJwYDVQQDEyBNaWNyb3NvZnQgQ29kZSBW
# ZXJpZmljYXRpb24gUm9vdDAeFw0xMTAyMjIxOTI1MTdaFw0yMTAyMjIxOTM1MTda
# MIHKMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNV
# BAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAyMDA2IFZl
# cmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxRTBDBgNVBAMT
# PFZlcmlTaWduIENsYXNzIDMgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBB
# dXRob3JpdHkgLSBHNTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8k
# CAgpejWeYAyq50s7Ttx8vDxFHLsr4P4pAvlXCKNkhRUn9fGtyDGJXSLoKqqmQrOP
# +LlVt7G3S7P+j34HV+zvQ9tmYhVhz2ANpNje+ODDYgg9VBPrScpZVIUm5SuPG5/r
# 9aGRwjNJ2ENjalJL0o/ocFFN0Ylpe8dw9rPcEnTbe11LVtOWvxV3obD0oiXyrxyS
# Zxjl9AYE75C55ADk3Tq1Gf8CuvQ87uCL6zeL7PTXrPL28D2v3XWRMxkdHEDLdCQZ
# IZPZFP6sKlLHj9UESeSNY0eIPGmDy/5HvSt+T8WVrg6d1NFDwGdz4xQIfuU/n3O4
# MwrPXT80h5aK7lPoJRUCAwEAAaOByzCByDARBgNVHSAECjAIMAYGBFUdIAAwDwYD
# VR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAYYwHQYDVR0OBBYEFH/TZafC3ey78DAJ
# 80M5+gKvMzEzMB8GA1UdIwQYMBaAFGL7CiFbf0NuEdoJVFBr9dKWcfGeMFUGA1Ud
# HwROMEwwSqBIoEaGRGh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3By
# b2R1Y3RzL01pY3Jvc29mdENvZGVWZXJpZlJvb3QuY3JsMA0GCSqGSIb3DQEBBQUA
# A4ICAQCBKoIWjDRnK+UD6zR7jKKjUIr0VYbxHoyOrn3uAxnOcpUYSK1iEf0g/T9H
# BgFa4uBvjBUsTjxqUGwLNqPPeg2cQrxc+BnVYONp5uIjQWeMaIN2K4+Toyq1f75Z
# +6nJsiaPyqLzghuYPpGVJ5eGYe5bXQdrzYao4mWAqOIV4rK+IwVqugzzR5NNrKSM
# B3k5wGESOgUNiaPsn1eJhPvsynxHZhSR2LYPGV3muEqsvEfIcUOW5jIgpdx3hv08
# 44tx23ubA/y3HTJk6xZSoEOj+i6tWZJOfMfyM0JIOFE6fDjHGyQiKEAeGkYfF9sY
# 9/AnNWy4Y9nNuWRdK6Ve78YptPLH+CHMBLpX/QG2q8Zn+efTmX/09SL6cvX9/zoc
# Qjqh+YAYpe6NHNRmnkUB/qru//sXjzD38c0pxZ3stdVJAD2FuMu7kzonaknAMK5m
# yfcjKDJ2+aSDVshIzlqWqqDMDMR/tI6Xr23jVCfDn4bA1uRzCJcF29BUYl4DSMLV
# n3+nZozQnbBP1NOYX0t6yX+yKVLQEoDHD1S2HmfNxqBsEQOE00h15yr+sDtuCjqm
# a3aZBaPxd2hhMxRHBvxTf1K9khRcSiRqZ4yvjZCq0PZ5IRuTJnzDzh69iDiSrkXG
# GWpJULMF+K5ZN4pqJQOUsVmBUOi6g4C3IzX0drlnHVkYrSCNlDGCESQwghEgAgEB
# MIGTMH8xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlv
# bjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEwMC4GA1UEAxMnU3lt
# YW50ZWMgQ2xhc3MgMyBTSEEyNTYgQ29kZSBTaWduaW5nIENBAhBdqtQcwalQC13t
# onk09GI7MA0GCWCGSAFlAwQCAQUAoIGWMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCoGCisGAQQBgjcCAQwx
# HDAaoRiAFmh0dHA6Ly93d3cudm13YXJlLmNvbS8wLwYJKoZIhvcNAQkEMSIEIA9x
# uOxHGcbZJpR+c7XT3TTJwsVFXQCriqMjLuAoSaKzMA0GCSqGSIb3DQEBAQUABIIB
# ABYR2Edn39DvuIe4h8mpE+JwgXxR9/pLpGDg2zsIgcEBIu62WTYTAms5xHMVfKz3
# IWzj80QSTAZ+5ZKZ1rp4zPmWSuK9hn2/cgyot8unXy+TwtkujxNXypjzIS8B/GIf
# U1xYP0+dW0pTTwCx2fCtTQhjB7E6wDhda7PosgGHgiRRHcKcXjvZVSNeeycZS0QR
# +VC8esJMCA+pS0MEfO3nJj526+ylnmtS8Mf+p0w1fbSGNfR7380giVY3Znrc16BM
# JDJ7WEEL5Jzf1m9Us+P1lmm4F178xkLjTmlQ/1f+L4MiUama8HkJqIo2/itzKeu0
# N2L2VdfJMBUXDg+pt7fILBShgg7IMIIOxAYKKwYBBAGCNwMDATGCDrQwgg6wBgkq
# hkiG9w0BBwKggg6hMIIOnQIBAzEPMA0GCWCGSAFlAwQCAQUAMHcGCyqGSIb3DQEJ
# EAEEoGgEZjBkAgEBBglghkgBhv1sBwEwMTANBglghkgBZQMEAgEFAAQgrIurEVWS
# zokEnHd6RsQG80c2i7XnjHzV+BVgGSWA75ECECla1wsn0EHq3ZBnhU9I2vUYDzIw
# MjAwMzMwMTUzNTA3WqCCC7swggaCMIIFaqADAgECAhAEzT+FaK52xhuw/nFgzKdt
# MA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lD
# ZXJ0IFNIQTIgQXNzdXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwHhcNMTkxMDAxMDAw
# MDAwWhcNMzAxMDE3MDAwMDAwWjBMMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
# aUNlcnQsIEluYy4xJDAiBgNVBAMTG1RJTUVTVEFNUC1TSEEyNTYtMjAxOS0xMC0x
# NTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOlkNZz6qZhlZBvkF9y4
# KTbMZwlYhU0w4Mn/5Ts8EShQrwcx4l0JGML2iYxpCAQj4HctnRXluOihao7/1K7S
# ehbv+EG1HTl1wc8vp6xFfpRtrAMBmTxiPn56/UWXMbT6t9lCPqdVm99aT1gCqDJp
# IhO+i4Itxpira5u0yfJlEQx0DbLwCJZ0xOiySKKhFKX4+uGJcEQ7je/7pPTDub0U
# LOsMKCclgKsQSxYSYAtpIoxOzcbVsmVZIeB8LBKNcA6Pisrg09ezOXdQ0EIsLnrO
# nGd6OHdUQP9PlQQg1OvIzocUCP4dgN3Q5yt46r8fcMbuQhZTNkWbUxlJYp16ApuV
# FKMCAwEAAaOCAzgwggM0MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYG
# A1UdJQEB/wQMMAoGCCsGAQUFBwMIMIIBvwYDVR0gBIIBtjCCAbIwggGhBglghkgB
# hv1sBwEwggGSMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20v
# Q1BTMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAA
# dABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQA
# dQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQA
# aQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIA
# ZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcA
# aABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQA
# IABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4A
# IABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTAfBgNVHSME
# GDAWgBT0tuEgHf4prtLkYaWyoiWyyBc1bjAdBgNVHQ4EFgQUVlMPwcYHp03X2G5X
# coBQTOTsnsEwcQYDVR0fBGowaDAyoDCgLoYsaHR0cDovL2NybDMuZGlnaWNlcnQu
# Y29tL3NoYTItYXNzdXJlZC10cy5jcmwwMqAwoC6GLGh0dHA6Ly9jcmw0LmRpZ2lj
# ZXJ0LmNvbS9zaGEyLWFzc3VyZWQtdHMuY3JsMIGFBggrBgEFBQcBAQR5MHcwJAYI
# KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBPBggrBgEFBQcwAoZD
# aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJ
# RFRpbWVzdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOCAQEALoOhRAVKBOO5
# MlL62YHwGrv4CY0juT3YkqHmRhxKL256PGNuNxejGr9YI7JDnJSDTjkJsCzox+Hi
# zO3LeWvO3iMBR+2VVIHggHsSsa8Chqk6c2r++J/BjdEhjOQpgsOKC2AAAp0fR8Sf
# tApoU39aEKb4Iub4U5IxX9iCgy1tE0Kug8EQTqQk9Eec3g8icndcf0/pOZgrV5JE
# 1+9uk9lDxwQzY1E3Vp5HBBHDo1hUIdjijlbXST9X/AqfI1579JSN3Z0au996KqbS
# RaZVDI/2TIryls+JRtwxspGQo18zMGBV9fxrMKyh7eRHTjOeZ2ootU3C7VuXgvjL
# qQhsUwm09zCCBTEwggQZoAMCAQICEAqhJdbWMht+QeQF2jaXwhUwDQYJKoZIhvcN
# AQELBQAwZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
# A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJl
# ZCBJRCBSb290IENBMB4XDTE2MDEwNzEyMDAwMFoXDTMxMDEwNzEyMDAwMFowcjEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElE
# IFRpbWVzdGFtcGluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AL3QMu5LzY9/3am6gpnFOVQoV7YjSsQOB0UzURB90Pl9TWh+57ag9I2ziOSXv2Mh
# kJi/E7xX08PhfgjWahQAOPcuHjvuzKb2Mln+X2U/4Jvr40ZHBhpVfgsnfsCi9aDg
# 3iI/Dv9+lfvzo7oiPhisEeTwmQNtO4V8CdPuXciaC1TjqAlxa+DPIhAPdc9xck4K
# rd9AOly3UeGheRTGTSQjMF287DxgaqwvB8z98OpH2YhQXv1mblZhJymJhFHmgudG
# UP2UKiyn5HU+upgPhH+fMRTWrdXyZMt7HgXQhBlyF/EXBu89zdZN7wZC/aJTKk+F
# HcQdPK/P2qwQ9d2srOlW/5MCAwEAAaOCAc4wggHKMB0GA1UdDgQWBBT0tuEgHf4p
# rtLkYaWyoiWyyBc1bjAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAS
# BgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggr
# BgEFBQcDCDB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3Nw
# LmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6
# oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElE
# Um9vdENBLmNybDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0QXNzdXJlZElEUm9vdENBLmNybDBQBgNVHSAESTBHMDgGCmCGSAGG/WwAAgQw
# KjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzALBglg
# hkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggEBAHGVEulRh1Zpze/d2nyqY3qzeM8G
# N0CE70uEv8rPAwL9xafDDiBCLK938ysfDCFaKrcFNB1qrpn4J6JmvwmqYN92pDqT
# D/iy0dh8GWLoXoIlHsS6HHssIeLWWywUNUMEaLLbdQLgcseY1jxk5R9IEBhfiThh
# TWJGJIdjjJFSLK8pieV4H9YLFKWA1xJHcLN11ZOFk362kmf7U2GJqPVrlsD0WGkN
# fMgBsbkodbeZY4UijGHKeZR+WfyMD+NvtQEmtmyl7odRIeRYYJu6DC0rbaLEfrvE
# JStHAgh8Sa4TtuF8QkIoxhhWz0E0tmZdtnR79VYzIi8iNrJLokqV2PWmjlIxggJN
# MIICSQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBT
# SEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhAEzT+FaK52xhuw/nFgzKdt
# MA0GCWCGSAFlAwQCAQUAoIGYMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAc
# BgkqhkiG9w0BCQUxDxcNMjAwMzMwMTUzNTA3WjArBgsqhkiG9w0BCRACDDEcMBow
# GDAWBBQDJb1QXtqWMC3CL0+gHkwovig0xTAvBgkqhkiG9w0BCQQxIgQgNNotss64
# c17Dodsqr3yJwFb08GnK3MCUuA5G9o3IugowDQYJKoZIhvcNAQEBBQAEggEAS3sz
# 0H7JY4E12K5KD2PJ4Lk6yly8cYyaT7bAHtf/Y+4Fjr6LdLnA91Vw0qYWerHwbAHT
# 9vusge2qKULgSmWvgCRe7Vjup/SgM0Ak465dMSs3ITiL+eLrTr7zydLy9o+IcLF/
# lzxTN9LM/lxPd3oSHPMHPXRPH0SLSiv+alcEJrCA3sTlaofx2moyHkzoY1d0HAMX
# QqlN2Psmj56VRoOzpn/MAaVMTOI0KxsurUPXBwz9PssKn2J68CQe5y4O3/sw/Ch8
# R5KtngvtKI9YZj41XlzuIeNbY7phOF792/Z8IyxCt7/I3SskN2m2porX65gTgys7
# DhG5S7XxGKmWzwzG7g==
# SIG # End signature block
