#!/bin/powershell
<#
.SYNTAX       ./list-current-timezone.ps1 
.DESCRIPTION  lists the details of the current time zone 
.LINK         https://github.com/fleschutz/PowerShell
.NOTES        Author: Markus Fleschutz / License: CC0
#>

try {
	get-timezone 
	exit 0
} catch {
	write-error "ERROR: line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
