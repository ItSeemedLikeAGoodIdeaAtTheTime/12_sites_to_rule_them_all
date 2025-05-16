# Test for 001_KingPage
# Created: 2025-05-15 17:08:01

$scriptPath = Join-Path $PSScriptRoot "..\contract\001_KingPage.ps1"
$output = & $scriptPath
if ($output -match "Script executed") { 
    Write-Output "Test passed!"
    exit 0 
} else { 
    Write-Output "Test failed!"
    exit 1 
}
