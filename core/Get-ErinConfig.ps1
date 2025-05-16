# Function to get Erin configuration
function Get-ErinConfig {
    $configPath = Join-Path $PSScriptRoot ".." "config" "config.json"
    if (Test-Path $configPath) {
        $config = Get-Content $configPath | ConvertFrom-Json
        return $config
    }
    return $null
} 