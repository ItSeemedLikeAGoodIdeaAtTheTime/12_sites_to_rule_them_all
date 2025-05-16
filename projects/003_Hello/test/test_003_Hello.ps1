# Test for 003_Hello
# Created: 2025-04-28 21:26:04

$scriptPath = Join-Path $PSScriptRoot "..\contract\003_Hello.ps1"
$output = & $scriptPath
if ($output -match "Script executed") { 
    Write-Output "Test passed!"
    exit 0 
} else { 
    Write-Output "Test failed!"
    exit 1 
}
