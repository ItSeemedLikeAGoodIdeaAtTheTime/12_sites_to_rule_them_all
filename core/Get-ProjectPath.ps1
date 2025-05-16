# Function to get project path
function Get-ProjectPath {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectNumber
    )
    
    # Get Erin configuration
    $config = Get-ErinConfig
    if ($null -eq $config) {
        return $null
    }
    
    # Get projects directory
    $projectsDir = $config.projects_directory
    if (-not (Test-Path $projectsDir)) {
        Write-Error "Projects directory not found: $projectsDir"
        return $null
    }
    
    # If project number is provided, use it to find the project
    if ($ProjectNumber) {
        $projectPath = Join-Path $projectsDir $ProjectNumber
        if (Test-Path $projectPath) {
            return $projectPath
        }
    }
    
    # Otherwise, search for project by name
    $projectDirs = Get-ChildItem -Path $projectsDir -Directory
    foreach ($dir in $projectDirs) {
        $configPath = Join-Path $dir.FullName "project_config.json"
        if (Test-Path $configPath) {
            $projectConfig = Get-Content $configPath -Raw | ConvertFrom-Json
            if ($projectConfig.name -eq $ProjectName) {
                return $dir.FullName
            }
        }
    }
    
    Write-Error "Project not found: $ProjectName"
    return $null
} 