# Upgrade pip
python -m pip install --upgrade pip

# Clear the console
Clear

# Update Oh My Posh and Nilesoft Shell
winget upgrade JanDeDobbeleer.OhMyPosh -s winget
winget upgrade nilesoft.shell

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
Write-Output "$terminalType"

# Initialize Oh My Posh config
if ($PSCmdlet.MyInvocation.PSCommandPath -notmatch 'oh-my-posh') {
    oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
}

# Run neofetch if not in Visual Studio Code Terminal
if ($terminalType -ne "Visual Studio Code Terminal") {
    neofetch
}

# Aliases

#Flush DNS Server
function flushdns {
    Clear-DnsClientCache
    Write-Host "DNS has been flushed"
}

#Print Detailed System Infomation
function sysinfo { Get-ComputerInfo }

#List all files 
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }

#Lists all files including hidden
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

#Set directory to desktop
function docs { Set-Location -Path $HOME\Documents }

##Set directory to documents
function dtop { Set-Location -Path $HOME\Desktop }

#Print the IP of the PC
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

#Open current directory in file explorer
function fe { ii (Get-Location) }

function Show-Help {
    @"
PowerShell Profile Help
=======================

Edit-Profile - Opens the current user's profile for editing using the configured editor.

Get-PubIP - Retrieves the public IP address of the machine.

docs - Changes the current directory to the user's Documents folder.

dtop - Changes the current directory to the user's Desktop folder.

la - Lists all files in the current directory with detailed formatting.

ll - Lists all files, including hidden, in the current directory with detailed formatting.

sysinfo - Displays detailed system information.

flushdns - Clears the DNS cache.

fe - opens file explorer in you current directory.

Use 'Show-Help' to display this help message.
"@
