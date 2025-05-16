# Erin - PowerShell Scripting Assistant

Erin is a PowerShell-based scripting assistant designed to help manage and execute PowerShell scripts in a structured and organized manner.

## Project Structure

```
Erin/
├── projects/                 # Contains all script projects
│   └── XXX_ProjectName/     # Individual project folders
│       ├── contract_XXX/    # Contains the main script
│       └── test_XXX/        # Contains test scripts
├── Erin.ps1                 # Main Erin script
├── ErinCLI.ps1             # Command-line interface
├── TestProjectCLI.ps1      # Test project creation tool
└── erin_llm_config.json    # Configuration file
```

## Usage

1. Initialize a new project:
```powershell
. .\Erin.ps1
Initialize-Erin -ProjectName "001_MyProject" -Description "My first project"
```

2. List all projects:
```powershell
Get-ErinProjects
```

## Project Naming Convention

Projects follow the naming convention: `XXX_ProjectName` where:
- XXX is a three-digit number (001, 002, etc.)
- ProjectName describes the project's purpose

## Testing

Each project includes a test script that verifies the functionality of the main script. Test scripts are located in the `test_XXX` directory.

# Project Pages

This repository contains various project pages including memecoins, game coins, and value sites.

## Pages

### Memecoins
- [TradeWarCoin](https://[your-github-username].github.io/[repo-name]/005_TradeWarCoin/contract/index.html)
- [TrumpPegSelonCoin](https://[your-github-username].github.io/[repo-name]/006_TrumpPegSelonCoin/contract/index.html)
- [DumpAndDumperCoin](https://[your-github-username].github.io/[repo-name]/007_DumpAndDumperCoin/contract/index.html)
- [Saccine](https://[your-github-username].github.io/[repo-name]/008_Saccine/contract/index.html)

### Game Coins
- [RedCoin](https://[your-github-username].github.io/[repo-name]/009_RedCoin/contract/index.html)
- [BlueCoin](https://[your-github-username].github.io/[repo-name]/010_BlueCoin/contract/index.html)
- [Diplomacy](https://[your-github-username].github.io/[repo-name]/011_Diplomacy/contract/index.html)
- [FlipStacks](https://[your-github-username].github.io/[repo-name]/012_FlipStacks/contract/index.html)

### Value Sites
- [Slots Trainer](https://[your-github-username].github.io/[repo-name]/013_SlotsTrainer/contract/index.html)
- [AI Spec Reader](https://[your-github-username].github.io/[repo-name]/014_AISpecReader/contract/index.html)
- [P=/=MP Poof](https://[your-github-username].github.io/[repo-name]/015_PMPPoof/contract/index.html)

## Deployment

These pages are deployed using GitHub Pages. To deploy:

1. Create a new GitHub repository
2. Push this code to the repository
3. Go to repository Settings > Pages
4. Select the main branch as source
5. Save the settings

The pages will be available at `https://[your-github-username].github.io/[repo-name]/` 