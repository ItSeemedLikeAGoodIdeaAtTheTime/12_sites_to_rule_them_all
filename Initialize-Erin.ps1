# Initialize-Erin.ps1
# Sets up the complete Erin environment

# Configuration
$config = @{
    ErinDir = "Erin"
    ProjectsDir = "projects"
    ScriptsDir = "scripts"
    BellaTemplateDir = "Bella"
    ConfigFile = "erin_config.json"
    TimestampFormat = "yyyy-MM-dd HH:mm:ss"
}

# Create directory structure
$directories = @(
    $config.ErinDir,
    (Join-Path $config.ErinDir $config.ProjectsDir),
    (Join-Path $config.ErinDir $config.ScriptsDir),
    (Join-Path $config.ErinDir $config.BellaTemplateDir)
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Write-Output "Created directory: $dir"
    }
}

# Create configuration file
$configContent = @{
    version = "1.0.0"
    lastInitialized = Get-Date -Format $config.TimestampFormat
    directories = @{
        projects = $config.ProjectsDir
        scripts = $config.ScriptsDir
        bellaTemplate = $config.BellaTemplateDir
    }
    settings = @{
        timestampFormat = $config.TimestampFormat
        projectNumberFormat = "000"
    }
}

$configPath = Join-Path $config.ErinDir $config.ConfigFile
$configContent | ConvertTo-Json | Set-Content -Path $configPath
Write-Output "Created configuration file: $configPath"

# Create Bella template structure
$bellaPath = Join-Path $config.ErinDir $config.BellaTemplateDir
$bellaDirs = @(
    "contract",
    "test",
    "docs",
    "llm"
)

foreach ($dir in $bellaDirs) {
    $dirPath = Join-Path $bellaPath $dir
    if (-not (Test-Path $dirPath)) {
        New-Item -ItemType Directory -Force -Path $dirPath | Out-Null
        Write-Output "Created Bella template directory: $dirPath"
    }
}

# Create Bella template files
$bellaFiles = @{
    "README.md" = @"
# Bella Template Project
This is a template project created using the Bella template.

## Structure
- contract/ - Contains the main project files
- test/ - Contains test files
- docs/ - Contains documentation
- llm/ - Contains AI-related configurations and files

## Usage
1. Copy this template to create a new project
2. Update the project files as needed
3. Run tests to verify functionality
"@
    "llm/llm_config.ps1" = @"
# LLM Configuration
`$llmConfig = @{
    ProjectName = "Template"
    Description = "A template project using Bella"
    Created = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
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
}

foreach ($file in $bellaFiles.Keys) {
    $filePath = Join-Path $bellaPath $file
    if (-not (Test-Path $filePath)) {
        Set-Content -Path $filePath -Value $bellaFiles[$file]
        Write-Output "Created Bella template file: $filePath"
    }
}

Write-Output "`nErin initialization complete! You can now start using Erin by running:"
Write-Output "  .\Erin\ErinCLI.ps1 list"