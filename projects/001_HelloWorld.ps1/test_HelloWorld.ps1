# Test script for Erin's Hello World
$output = & "$PSScriptRoot/contract_HelloWorld.ps1/HelloWorld.ps1"

# Verify the output contains expected content
if ($output -match "Hello from Erin") {
    Write-Output "Test passed!"
    exit 0
} else {
    Write-Output "Test failed!"
    exit 1
} 