# Import the Azure LLM configuration
$llmConfig = Get-Content -Path ".\azure_llm_config.json" | ConvertFrom-Json

# Function to format the prompt template
function Format-Prompt {
    param (
        [string]$template,
        [string]$purpose,
        [string]$filename
    )
    return $template.Replace("{purpose}", $purpose).Replace("{filename}", $filename)
}

# Headers for the API request
$headers = @{
    "Authorization" = "Bearer $($llmConfig.Azure_LLM.apiKey)"
    "Content-Type" = "application/json"
}

# Create the request body with the formatted prompt
$prompt = Format-Prompt -template $llmConfig.Azure_LLM.promptTemplate.Write_File.template `
                        -purpose $llmConfig.Azure_LLM.promptTemplate.Write_File.purpose `
                        -filename $llmConfig.Azure_LLM.promptTemplate.Write_File.filename

$body = @{
    "model" = "gpt-4"
    "messages" = @(
        @{
            "role" = "user"
            "content" = $prompt
        }
    )
} | ConvertTo-Json -Depth 10

# Make the API call and save response to file
$response = Invoke-RestMethod -Uri $llmConfig.Azure_LLM.endpointUrl -Method Post -Body $body -Headers $headers
$response.choices[0].message.content | Set-Content -Path $llmConfig.Azure_LLM.outputFile
Write-Host "Response saved to: $($llmConfig.Azure_LLM.outputFile)" 