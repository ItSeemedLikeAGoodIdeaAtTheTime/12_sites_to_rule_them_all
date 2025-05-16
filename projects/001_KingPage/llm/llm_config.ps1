# LLM Configuration for 001_KingPage
# This file contains AI-related settings and prompts for this project

$llmConfig = @{
    ProjectName = "001_KingPage"
    Description = "Main king page for project management and overview"
    Created = "2025-05-15 17:08:01"
    Model = "gpt-4"
    Temperature = 0.7
    MaxTokens = 2000
    Prompts = @{
        Explain = "Explain this script's functionality"
        Improve = "Suggest improvements for this code"
        Debug = "Help debug this issue"
    }
}
