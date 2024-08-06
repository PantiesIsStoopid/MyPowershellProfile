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

#Alias

# Set directory to Documents
function Docs {
    Set-Location -Path "$HOME\onedrive\Documents"
}

# Set directory to Desktop
function Dtop {
    Set-Location -Path "$HOME\onedrive\Desktop"
}

# Move to the Downloads directory
function DLoads {
    Set-Location -Path "$HOME\onedrive\Downloads"
}

# List all files
function LA {
    Get-ChildItem -Path . -Force | Format-Table -AutoSize
}

# List all files including hidden
function LL {
    Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize
}

# Print Detailed System Information
function SysInfo {
    Get-ComputerInfo
}

# Flush DNS Server
function FlushDNS {
    Clear-DnsClientCache
    Write-Host "DNS has been flushed" -ForegroundColor Magenta
}

# Print the Public IP of the PC
function GetPubIP {
    (Invoke-WebRequest http://ifconfig.me/ip).Content
}

# Print the Private IP of the PC
function GetPrivIP {
    param (
        [switch]$IncludeIPv6
    )

    # Get IP addresses for all network adapters
    $ipAddresses = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias '*'
    
    # Optionally include IPv6 addresses
    if ($IncludeIPv6) {
        $ipAddresses += Get-NetIPAddress -AddressFamily IPv6 -InterfaceAlias '*'
    }

    # Format the output
    $ipAddresses | Format-Table -Property InterfaceAlias, IPAddress, AddressFamily -AutoSize
}

# Open current directory in File Explorer
function FE {
    ii (Get-Location)
}

# Change directories to user's home
function Home {
    Set-Location -Path "$HOME"
}

# Change directories to C drive
function Root {
    cd c:\
}

# Update function
function Update {
    # Upgrade pip
    python -m pip install --upgrade pip

    # Update all known apps
    winget upgrade --all

    # Windows Updates
    Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
    Get-WindowsUpdate
}

# Open the Chris Titus Tech Windows utility
function WinUtil {
    iwr -useb https://christitus.com/win | iex
}

# Reload Terminal profile
function ReloadProfile {
    & $profile
}

# Check for corrupt files 
function SystemScan {
    # Run DISM scan
    Write-Host "Starting DISM scan..." -ForegroundColor Cyan
    try {
        dism /online /cleanup-image /checkhealth
        dism /online /cleanup-image /scanhealth
        dism /online /cleanup-image /restorehealth
        Write-Host "DISM scan completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "DISM scan failed: $_" -ForegroundColor Red
    }

    # Run SFC scan
    Write-Host "Starting SFC scan..." -ForegroundColor Cyan
    try {
        sfc /scannow
        Write-Host "SFC scan completed successfully." -ForegroundColor Green
    } catch {
        Write-Host "SFC scan failed: $_" -ForegroundColor Red
    }
}

# Generate a random secure password
function RPassword {
    $Length = 15

    # Define Character Sets
    $UpperCase = @('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
    $LowerCase = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
    $Numbers = @('1', '2', '3', '4', '5', '6', '7', '8', '9', '0')
    $Symbols = @('!', '@', '$', '?', '<', '>', '*', '&')
    $FullSet = $UpperCase + $LowerCase + $Numbers + $Symbols

    # Check to see if all character sets are used
    $HasUpperCase = 0
    $HasLowerCase = 0
    $HasNumbers = 0
    $HasSymbols = 0

    While ($HasUpperCase -eq 0 -or $HasLowerCase -eq 0 -or $HasNumbers -eq 0 -or $HasSymbols -eq 0) {
        # Generate New Password
        $Password = -join ((0..($Length - 1)) | ForEach-Object { $FullSet | Get-Random })
        
        # Test the password that has been created
        $HasUpperCase = ($Password -match '[A-Z]') ? 1 : 0
        $HasLowerCase = ($Password -match '[a-z]') ? 1 : 0
        $HasNumbers = ($Password -match '[0-9]') ? 1 : 0
        $HasSymbols = ($Password -match '[!@#$%^&*()_+]') ? 1 : 0
    }

    # Display Password
    Write-Host "The new password is: $Password" -ForegroundColor Cyan
    Set-Clipboard -Value $Password
}

# Help Function
function ShowHelp {
    @"
PowerShell Profile Help
=======================

Directory Navigation:
- Docs: Changes the current directory to the user's Documents folder.
- Dtop: Changes the current directory to the user's Desktop folder.
- DLoads: Changes the current directory to the user's Downloads folder.
- Home: Changes directories to the user's home.
- Root: Changes directories to the C: drive.

File and System Information:
- LA: Lists all files in the current directory with detailed formatting.
- LL: Lists all files, including hidden, in the current directory with detailed formatting.
- SysInfo: Displays detailed system information.
- GetPrivIP: Retrieves the private IP address of the machine.
- GetPubIP: Retrieves the public IP address of the machine.

System Maintenance
- FlushDNS: Clears the DNS cache.
- SystemScan: Runs a DISM and SFC scan.
- Update: Updates all known apps.

Utility Functions
- FE: Opens File Explorer in your current directory.
- Winutil: Opens the Chris Titus Tech Windows utility.
- RPassword: Generates a random secure password.
- SystemTime: Updates the system time.
- ReloadProfile: Reloads the terminal profile.

Use 'ShowHelp' to display this help message.
"@
}
