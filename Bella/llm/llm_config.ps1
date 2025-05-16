# LLM Configuration
$llmConfig = @{
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
