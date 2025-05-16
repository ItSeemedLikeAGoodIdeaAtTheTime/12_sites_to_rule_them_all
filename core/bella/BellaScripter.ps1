# Simple script executor for Bella's tools

param(
    [Parameter(Mandatory=$true)]
    [string]$toolName,
    [Parameter(Mandatory=$false)]
    [string]$executor = "internal"
)

# Function to execute the appropriate tool based on name
function Execute-Tool {
    param (
        [string]$tool,
        [string]$executorType
    )
    
    switch ($tool) {
        "Write" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\write_file_config.json" | ConvertFrom-Json
                Set-Content -Path $config.Write_File.filePath -Value $config.Write_File.content
                Write-Host "File written: $($config.Write_File.filePath)"
            }
            else {
                & .\WriteFileExecutor.ps1
            }
        }
        "Append" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\append_file_config.json" | ConvertFrom-Json
                Add-Content -Path $config.Append_File.filePath -Value $config.Append_File.content
                Write-Host "Content appended to: $($config.Append_File.filePath)"
            }
            else {
                & .\AppendFileExecutor.ps1
            }
        }
        "Read" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\read_file_config.json" | ConvertFrom-Json
                Get-Content -Path $config.Read_File.filePath
            }
            else {
                & .\ReadFileExecutor.ps1
            }
        }
        "ExecutePS" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\execute_ps_config.json" | ConvertFrom-Json
                & $config.Execute_PS.scriptPath $config.Execute_PS.parameters
            }
            else {
                & .\ExecutePSScriptExecutor.ps1
            }
        }
        "ExecutePY" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\execute_py_config.json" | ConvertFrom-Json
                python $config.Execute_PY.scriptPath $config.Execute_PY.parameters
            }
            else {
                & .\ExecutePythonScriptExecutor.ps1
            }
        }
        "AzureLLM" {
            if ($executorType -eq "internal") {
                $config = Get-Content -Path ".\azure_llm_config.json" | ConvertFrom-Json
                $headers = @{
                    "Authorization" = "Bearer $($config.Azure_LLM.apiKey)"
                    "Content-Type" = "application/json"
                }
                $body = @{
                    "model" = "gpt-4"
                    "messages" = @(
                        @{
                            "role" = "user"
                            "content" = $config.Azure_LLM.userMessage
                        }
                    )
                } | ConvertTo-Json -Depth 10
                $response = Invoke-RestMethod -Uri $config.Azure_LLM.endpointUrl -Method Post -Body $body -Headers $headers
                $response.choices[0].message.content | Set-Content -Path $config.Azure_LLM.outputFile
                Write-Host "Response saved to: $($config.Azure_LLM.outputFile)"
            }
            else {
                & .\AzureLLMExecutor.ps1
            }
        }
        default {
            Write-Host "Unknown tool: $tool. Available tools are: Write, Append, Read, ExecutePS, ExecutePY, AzureLLM"
        }
    }
}

# Execute the requested tool with the specified executor
Execute-Tool -tool $toolName -executorType $executor 