# Function to get project configuration
function Get-ProjectConfig {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectNumber
    )
    
    # Get project path and configuration file path
    $projectPath = Get-ProjectPath -ProjectName $ProjectName -ProjectNumber $ProjectNumber
    $configPath = Join-Path $projectPath "project_config.json"
    
    # Check if configuration file exists
    if (-not (Test-Path $configPath)) {
        Write-Error "Project configuration not found: $configPath"
        return $null
    }
    
    # Read and return project configuration
    try {
        return Get-Content $configPath -Raw | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to read project configuration: $_"
        return $null
    }
} 