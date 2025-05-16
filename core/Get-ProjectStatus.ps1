# Function to get project status
function Get-ProjectStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectNumber
    )
    
    # Get project path and configuration
    $projectPath = Get-ProjectPath -ProjectName $ProjectName -ProjectNumber $ProjectNumber
    $config = Get-ProjectConfig -ProjectName $ProjectName -ProjectNumber $ProjectNumber
    if ($null -eq $projectPath -or $null -eq $config) { return $null }
    
    # Build project status object
    $status = @{
        # Basic project information
        Name = $config.Name
        Description = $config.Description
        Status = $config.Status
        Created = $config.Created
        LastModified = $config.LastModified
        
        # Task statistics
        Tasks = @{
            Total = $config.Tasks.Count
            Completed = ($config.Tasks | Where-Object { $_.Status -eq "Completed" }).Count
            InProgress = ($config.Tasks | Where-Object { $_.Status -eq "In Progress" }).Count
            Pending = ($config.Tasks | Where-Object { $_.Status -eq "Pending" }).Count
        }
        
        # File statistics
        Files = @{
            Total = (Get-ChildItem $projectPath -Recurse -File).Count
            Scripts = (Get-ChildItem $projectPath -Recurse -Include "*.ps1").Count
            Documentation = (Get-ChildItem $projectPath -Recurse -Include "*.md").Count
            Config = (Get-ChildItem $projectPath -Recurse -Include "*.json").Count
        }
    }
    
    return $status
} 