# Function to load Erin configuration
function Get-ErinConfig {
    $configPath = Join-Path $PSScriptRoot "..\config\erin_config.json"
    if (Test-Path $configPath) {
        return Get-Content $configPath | ConvertFrom-Json
    }
    throw "Erin configuration not found at: $configPath"
} 