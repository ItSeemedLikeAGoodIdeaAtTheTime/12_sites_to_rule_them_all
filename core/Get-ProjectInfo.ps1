# Function to get project information
function Get-ProjectInfo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectNumber
    )
    
    $config = Get-ErinConfig
    $projectPath = Get-ProjectPath -ProjectName $ProjectName -ProjectNumber $ProjectNumber
    $projectInfoPath = Join-Path $projectPath "project_info.json"
    
    if (Test-Path $projectInfoPath) {
        return Get-Content $projectInfoPath | ConvertFrom-Json
    }
    
    return $null
} 