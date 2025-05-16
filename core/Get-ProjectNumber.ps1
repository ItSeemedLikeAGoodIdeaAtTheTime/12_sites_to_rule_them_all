# Function to get next project number
function Get-NextProjectNumber {
    $config = Get-ErinConfig
    $projectsDir = Join-Path $PSScriptRoot ".." $config.directories.projects
    $existingProjects = Get-ChildItem $projectsDir -Directory | Where-Object { $_.Name -match '^\d+' }
    if ($existingProjects) {
        $maxNumber = ($existingProjects | ForEach-Object { [int]($_.Name -split '-')[0] } | Measure-Object -Maximum).Maximum
        return ($maxNumber + 1).ToString("000")
    }
    return "001"
} 