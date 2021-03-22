#!/bin/powershell
<#
.SYNTAX       ./switch-branch.ps1 [<branch>] [<repo-dir>]
.DESCRIPTION  switches the branch in the current/given Git repository (including submodules)
.LINK         https://github.com/fleschutz/PowerShell
.NOTES        Author: Markus Fleschutz / License: CC0
#>

param($Branch = "", $RepoDir = "$PWD")

if ($Branch -eq "") {
	$Branch = read-host "Enter branch to switch to"
}

try {
	& git --version
} catch {
	write-error "ERROR: can't execute 'git' - make sure Git is installed and available"
	exit 1
}

try {
	if (-not(test-path "$RepoDir" -pathType container)) { throw "Can't access directory: $RepoDir" }
	set-location "$RepoDir"

	& git fetch --all --recurse-submodules
	if ($lastExitCode -ne "0") { throw "'git fetch' failed" }

	& git switch --recurse-submodules $Branch
	if ($lastExitCode -ne "0") { throw "'git switch $Branch' failed" }

	& git submodule update --init --recursive
	if ($lastExitCode -ne "0") { throw "'git submodule update' failed" }

	& git pull --recurse-submodules 
	if ($lastExitCode -ne "0") { throw "'git pull' failed" }

	exit 0
} catch {
	write-error "ERROR: line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
