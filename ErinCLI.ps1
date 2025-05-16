# Erin CLI - Command Line Interface
param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$ProjectName,
    
    [Parameter(Position=2)]
    [string]$Description
)

# Get the directory where this script is located
$scriptDir = $PSScriptRoot

# Function to create a new project
function New-Project {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        
        [Parameter(Mandatory=$false)]
        [string]$Description = ""
    )
    
    # Validate project name format (XXX_ProjectName)
    if (-not ($Name -match '^\d{3}_[A-Za-z0-9]+$')) {
        Write-Error "Project name must follow format: XXX_ProjectName (e.g., 001_HelloWorld)"
        return
    }
    
    # Load configuration
    $configPath = Join-Path $scriptDir "erin_config.json"
    if (-not (Test-Path $configPath)) {
        Write-Error "Configuration file not found. Please run Initialize-Erin.ps1 first."
        return
    }
    $config = Get-Content $configPath | ConvertFrom-Json
    
    # Create project structure
    $projectPath = Join-Path (Join-Path $scriptDir "projects") $Name
    $contractPath = Join-Path $projectPath "contract"
    $testPath = Join-Path $projectPath "test"
    $bellaPath = Join-Path $projectPath "bella"
    $llmPath = Join-Path $projectPath "llm"
    
    # Create directories
    New-Item -ItemType Directory -Force -Path $projectPath | Out-Null
    New-Item -ItemType Directory -Force -Path $contractPath | Out-Null
    New-Item -ItemType Directory -Force -Path $testPath | Out-Null
    New-Item -ItemType Directory -Force -Path $bellaPath | Out-Null
    New-Item -ItemType Directory -Force -Path $llmPath | Out-Null
    
    Write-Output "Created project directories:"
    Write-Output "  Project: $projectPath"
    Write-Output "  Contract: $contractPath"
    Write-Output "  Test: $testPath"
    Write-Output "  Bella: $bellaPath"
    Write-Output "  LLM: $llmPath"
    
    # Create main script file
    $scriptContent = @"
# $Name
# $Description
# Created: $(Get-Date -Format $config.settings.timestampFormat)

`$timestamp = Get-Date -Format '$($config.settings.timestampFormat)'
Write-Output "`$timestamp - Script executed"
"@
    
    $scriptPath = Join-Path $contractPath "$Name.ps1"
    Set-Content -Path $scriptPath -Value $scriptContent
    Write-Output "Created main script: $scriptPath"
    
    # Create test file
    $testContent = @"
# Test for $Name
# Created: $(Get-Date -Format $config.settings.timestampFormat)

`$scriptPath = Join-Path `$PSScriptRoot "..\contract\$Name.ps1"
`$output = & `$scriptPath
if (`$output -match "Script executed") { 
    Write-Output "Test passed!"
    exit 0 
} else { 
    Write-Output "Test failed!"
    exit 1 
}
"@
    
    $testPath = Join-Path $testPath "test_$Name.ps1"
    Set-Content -Path $testPath -Value $testContent
    Write-Output "Created test script: $testPath"
    
    # Create LLM configuration file
    $llmConfigContent = @"
# LLM Configuration for $Name
# This file contains AI-related settings and prompts for this project

`$llmConfig = @{
    ProjectName = "$Name"
    Description = "$Description"
    Created = "$(Get-Date -Format $config.settings.timestampFormat)"
    Model = "gpt-4"
    Temperature = 0.7
    MaxTokens = 2000
    Prompts = @{
        Explain = "Explain this script's functionality"
        Improve = "Suggest improvements for this code"
        Debug = "Help debug this issue"
    }
}
"@
    
    $llmConfigPath = Join-Path $llmPath "llm_config.ps1"
    Set-Content -Path $llmConfigPath -Value $llmConfigContent
    Write-Output "Created LLM configuration: $llmConfigPath"
    
    # Create project configuration
    $projectConfig = @{
        Name = $Name
        Description = $Description
        Created = Get-Date -Format $config.settings.timestampFormat
        LastModified = Get-Date -Format $config.settings.timestampFormat
        Status = "Active"
        Tasks = @()
    }
    
    $projectConfigPath = Join-Path $projectPath "project_config.json"
    $projectConfig | ConvertTo-Json | Set-Content -Path $projectConfigPath
    Write-Output "Created project configuration: $projectConfigPath"
}

# Function to list all projects
function Get-Projects {
    $projectsPath = Join-Path $scriptDir "projects"
    if (Test-Path $projectsPath) {
        Get-ChildItem -Path $projectsPath -Directory | ForEach-Object {
            Write-Output $_.Name
        }
    } else {
        Write-Output "No projects found."
    }
}

# Main command handling
switch ($Command.ToLower()) {
    "new" {
        if (-not $ProjectName) {
            Write-Error "Project name is required"
            exit 1
        }
        New-Project -Name $ProjectName -Description $Description
    }
    "list" {
        Get-Projects
    }
    default {
        Write-Output "Erin - Project Management CLI"
        Write-Output "Usage:"
        Write-Output "  .\ErinCLI.ps1 new <project-name> [description]  - Create a new project"
        Write-Output "  .\ErinCLI.ps1 list                             - List all projects"
    }
} 