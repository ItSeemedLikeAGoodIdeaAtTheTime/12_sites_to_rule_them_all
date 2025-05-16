# Function to get project tasks
function Get-ProjectTasks {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectNumber,
        
        [Parameter(Mandatory=$false)]
        [string]$Status
    )
    
    # Get project configuration
    $config = Get-ProjectConfig -ProjectName $ProjectName -ProjectNumber $ProjectNumber
    if ($null -eq $config) { return $null }
    
    # Return filtered tasks if status is specified, otherwise return all tasks
    if ($Status) {
        return $config.Tasks | Where-Object { $_.Status -eq $Status }
    }
    return $config.Tasks
} 