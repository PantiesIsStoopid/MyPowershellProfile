# Clear the console
Clear

# Function to identify the terminal
function Get-TerminalType {
    if ($env:TERM_PROGRAM -eq "vscode") {
        return "Visual Studio Code Terminal"
    }
    elseif ($env:TERM_PROGRAM -eq "Apple_Terminal") {
        return "Apple Terminal"
    }
    elseif ($env:TERM_PROGRAM -eq "iTerm.app") {
        return "iTerm"
    }
    elseif ($env:ConEmuANSI) {
        return "ConEmu"
    }
    elseif ($env:TERMINAL_EMULATOR -eq "Hyper") {
        return "Hyper"
    }
    elseif ($Host.Name -eq "ConsoleHost") {
        return "Windows PowerShell"
    }
    else {
        return "Unknown Terminal"
    }
}

# Get terminal type and print it
$terminalType = Get-TerminalType
Write-Host "$terminalType" -ForegroundColor Blue

# Initialize Oh My Posh config
if ($PSCmdlet.MyInvocation.PSCommandPath -notmatch 'oh-my-posh') {
    oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
}

# Run neofetch if not in Visual Studio Code Terminal
if ($terminalType -ne "Visual Studio Code Terminal") {
    neofetch
}

# Aliases

# Flush DNS Server
function FlushDNS {
    Clear-DnsClientCache
    Write-Host "DNS has been flushed" -ForegroundColor Magenta
}

# Print Detailed System Information
function SysInfo {
    Get-ComputerInfo
}

# List all files
function LA {
    Get-ChildItem -Path . -Force | Format-Table -AutoSize
}

# List all files including hidden
function LL {
    Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize
}

# Set directory to Documents
function Docs {
    Set-Location -Path "$HOME\onedrive\Documents"
}

# Set directory to Desktop
function Dtop {
    Set-Location -Path "$HOME\onedrive\Desktop"
}

# Print the IP of the PC
function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip).Content
}

# Open current directory in File Explorer
function FE {
    ii (Get-Location)
}

# Change directories
function Home {
    cd ~
}

function Root {
    cd c:\
}

# Update function
function Update {
    # Upgrade pip
    python -m pip install --upgrade pip

    # Update all known apps
    winget upgrade --all
}

# Help Function
function Show-Help {
    @"
PowerShell Profile Help
=======================

Edit-Profile - Opens the current user's profile for editing using the configured editor.
Get-PubIP - Retrieves the public IP address of the machine.
Docs - Changes the current directory to the user's Documents folder.
Dtop - Changes the current directory to the user's Desktop folder.
LA - Lists all files in the current directory with detailed formatting.
LL - Lists all files, including hidden, in the current directory with detailed formatting.
SysInfo - Displays detailed system information.
FlushDNS - Clears the DNS cache.
FE - Opens File Explorer in your current directory.
Home - Change directories to user.
Root - Change directories to C drive.
Update - Updates all known apps.

Use 'Show-Help' to display this help message.

"@
}
