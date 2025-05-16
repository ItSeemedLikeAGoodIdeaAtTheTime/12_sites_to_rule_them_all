# BellaCLI.ps1 - Command Line Interface for Bella
param(
    [Parameter(Mandatory=$true)]
    [string]$CodePurpose,
    
    [Parameter(Mandatory=$true)]
    [string]$FileName,
    
    [Parameter(Mandatory=$false)]
    [string]$Executor = "writefile"
)

# Function to ensure file has the correct extension
function Ensure-FileExtension {
    param (
        [string]$fileName,
        [string]$codePurpose
    )
    
    # Check if the file already has an extension
    if ($fileName -match '\.[^.]+$') {
        return $fileName
    }
    
    # Determine the appropriate extension based on the code purpose
    if ($codePurpose -match 'python|py') {
        return "$fileName.py"
    }
    else {
        return "$fileName.ps1"
    }
}

# Function to save the generated file
function Save-GeneratedFile {
    param (
        [string]$sourceFolder,
        [string]$fileName,
        [string]$destinationFolder
    )
    
    $sourcePath = Join-Path $sourceFolder $fileName
    $destinationPath = Join-Path $destinationFolder $fileName
    
    if (Test-Path $sourcePath) {
        Write-Host "`nSaving generated file to: $destinationPath" -ForegroundColor Green
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force
        return $true
    }
    return $false
}

# Function to execute the generated script
function Execute-GeneratedScript {
    param (
        [string]$folderPath,
        [string]$fileName,
        [string]$executor
    )
    
    $scriptPath = Join-Path $folderPath $fileName
    
    if (-not (Test-Path -Path $scriptPath)) {
        Write-Host "Generated script not found: $scriptPath" -ForegroundColor Yellow
        return
    }
    
    Write-Host "`nExecuting generated script: $fileName" -ForegroundColor Green
    
    # Check file extension to determine how to run it
    if ($fileName -match '\.py$') {
        # Run Python script
        if ($executor -eq "internal") {
            python $scriptPath
        }
        else {
            # Update the Python executor config
            $pyConfig = Get-Content -Path "$PSScriptRoot\execute_py_config.json" | ConvertFrom-Json
            $pyConfig.Execute_PY.scriptPath = $scriptPath
            $pyConfig.Execute_PY.parameters = ""
            $pyConfig | ConvertTo-Json -Depth 10 | Set-Content -Path "$PSScriptRoot\execute_py_config.json"
            
            # Run the Python executor
            & "$PSScriptRoot\ExecutePythonScriptExecutor.ps1"
        }
    }
    elseif ($fileName -match '\.ps1$') {
        # Run PowerShell script
        if ($executor -eq "internal") {
            & $scriptPath
        }
        else {
            # Update the PowerShell executor config
            $psConfig = Get-Content -Path "$PSScriptRoot\execute_ps_config.json" | ConvertFrom-Json
            $psConfig.Execute_PS.scriptPath = $scriptPath
            $psConfig.Execute_PS.parameters = ""
            $psConfig | ConvertTo-Json -Depth 10 | Set-Content -Path "$PSScriptRoot\execute_ps_config.json"
            
            # Run the PowerShell executor
            & "$PSScriptRoot\ExecutePSScriptExecutor.ps1"
        }
    }
    else {
        Write-Host "Unknown script type. Cannot execute: $fileName" -ForegroundColor Yellow
    }
}

try {
    # Create a temporary directory for this request
    $tempDir = Join-Path $PSScriptRoot "temp"
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    }
    
    # Create a unique folder for this request
    $requestFolder = Join-Path $tempDir ([System.Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $requestFolder -Force | Out-Null
    
    # Ensure the file has the correct extension
    $FileName = Ensure-FileExtension -fileName $FileName -codePurpose $CodePurpose
    
    # Create the config file with absolute path
    $configFile = Join-Path $requestFolder "$FileName`_user_inputs.json"
    $config = @{
        codePurpose = $CodePurpose
        fileName = $FileName
        executor = $Executor
    }
    $config | ConvertTo-Json | Set-Content -Path $configFile
    
    # Call BellaWrapper with the config file
    $wrapperPath = Join-Path $PSScriptRoot "BellaWrapper.ps1"
    if (-not (Test-Path $wrapperPath)) {
        throw "BellaWrapper.ps1 not found at: $wrapperPath"
    }
    
    Write-Host "Processing request..."
    & $wrapperPath -configFile $configFile
    
    # Wait a moment for files to be written
    Start-Sleep -Seconds 2
    
    # Save the generated file before execution
    Save-GeneratedFile -sourceFolder $requestFolder -fileName $FileName -destinationFolder $PSScriptRoot
    
    # Execute the generated script
    Write-Host "`nExecuting generated script..."
    Execute-GeneratedScript -folderPath $requestFolder -fileName $FileName -executor $Executor
    
    # Clean up the temporary directory
    Write-Host "`nCleaning up temporary files..."
    Remove-Item -Path $requestFolder -Recurse -Force
}
catch {
    Write-Error "An error occurred: $_"
    exit 1
} 