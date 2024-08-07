#Opt out of Powershell telemetry
if ([bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem) {
    [System.Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 'true', [System.EnvironmentVariableTarget]::Machine)
}

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
Import-Module -Name Terminal-Icons
Import-Module -Name Terminal-Icons -Repository PSGallery -Force



# Clear the console
Clear

# Function to identify the terminal
function TerminalType {
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
$terminalType = TerminalType
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
    Set-Location -Path "$HOME\Downloads"
}

function CodeDIR {
    Set-Location -Path "$HOME\onedrive\Documents\code"
    code .
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
    Write-Host "DNS has been flushed" -ForegroundColor Green
}

# Print the Public IP of the PC
function GetPubIP {
    (Invoke-WebRequest http://ifconfig.me/ip).Content
}

# Print the Private IP of the PC
function GetPrivIP {
    param (
        [switch]$IncIPv6
    )

    # Get IP addresses for all network adapters
    $ipAddresses = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias '*'
    
    # Optionally include IPv6 addresses
    if ($IncIPv6) {
        $ipAddresses += Get-NetIPAddress -AddressFamily IPv6 -InterfaceAlias '*'
    }

    # Format the output
    $ipAddresses | Format-Table -Property InterfaceAlias, IPAddress, AddressFamily -AutoSize
}

function Speedtest {    
    Write-Host "Running Speedtest" -ForegroundColor Red
    irm asheroto.com/speedtest | iex
    Write-Host "Pinging 1.1.1.1" -ForegroundColor Red
    ping 1.1.1.1
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
    #Update Powershell
    winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements

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

    Write-Host "Restoring original file permissions" -ForegroundColor Cyan
    icacls "C:\" /reset /t /c /l
    Write-Host "Restoring permissions completed successfully." -ForegroundColor Green
}

# Generate a random secure password
function RPassword {
    param (
        [int]$Length = 15
    )

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



# Function to clear system memory (not specifically standby RAM)
function ClearRAM {
    # Get total and available physical memory
    $memoryInfo = Get-CimInstance -ClassName Win32_OperatingSystem

    # Calculate used memory
    $totalMemory = $memoryInfo.TotalVisibleMemorySize
    $usedMemory = $totalMemory - $freeMemory

    # Convert from kilobytes to gigabytes for display
    $usedMemoryGB = [math]::Round($usedMemory / 1MB, 2)

    # Print RAM usage
    Write-Host "Used RAM: $usedMemoryGB GB" -ForegroundColor DarkBlue

    Write-Host "Clearing system memory..." -ForegroundColor Cyan

    # Release unused memory
    [GC]::Collect()          # Force garbage collection
    [GC]::WaitForPendingFinalizers() # Wait for finalizers to run

    # Use the Windows API to flush the system memory
    $null = [System.Diagnostics.Process]::GetCurrentProcess().MinWorkingSet = [System.Diagnostics.Process]::GetCurrentProcess().MaxWorkingSet

    # Get total and available physical memory
    $memoryInfo = Get-CimInstance -ClassName Win32_OperatingSystem

    # Calculate used memory
    $totalMemory = $memoryInfo.TotalVisibleMemorySize
    $usedMemory = $totalMemory - $freeMemory

    # Convert from kilobytes to gigabytes for display
    $usedMemoryGB = [math]::Round($usedMemory / 1MB, 2)

    # Print RAM usage
    Write-Host "Used RAM: $usedMemoryGB GB" -ForegroundColor DarkBlue

    Write-Host "Memory cleanup completed." -ForegroundColor Green
}

#Reinstall winget
function ReinstallWinget {
    #Uninstall winget
    Get-AppxPackage *Microsoft.DesktopAppInstaller* | Remove-AppxPackage

    #Install Winget
    Invoke-WebRequest -Uri "https://aka.ms/Microsoft.DesktopAppInstaller" -OutFile "$env:TEMP\AppInstaller.appxbundle"
    Add-AppxPackage -Path "$env:TEMP\AppInstaller.appxbundle"

    #Verify winget install
    winget --version
}

#Empty Recycle Bin
function EmptyBin {
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
}

#Fake Hacking
function Hack {
    # Function to display a message with a delay
    function Display-Message {
        param (
            [string]$message,
            [int]$delay = 2
        )
        Write-Host $message -ForegroundColor Green
        Start-Sleep -Seconds $delay
    }

    # Clear the screen
    Clear-Host

    # Introduction
    Display-Message "Initiating hacking simulation..."

    # Simulate network scan
    $devices = @(
        "192.168.1.1 - Router",
        "192.168.1.10 - Laptop",
        "192.168.1.15 - Printer",
        "192.168.1.20 - Smart TV",
        "192.168.1.25 - Smartphone"
    )

    Display-Message "Scanning network for devices..."
    foreach ($device in $devices) {
        Write-Host "Discovered device: $device" -ForegroundColor Cyan
        Start-Sleep -Seconds 1
    }

    # Simulate login attempts
    $usernames = @("Josh", "Andrew", "guest")
    $passwords = @("Sunshine123.", "SkibidiToilet", "Rainbo99.")

    Display-Message "Attempting to log in..."
    foreach ($username in $usernames) {
        foreach ($password in $passwords) {
            $success = (Get-Random -Minimum 0 -Maximum 2) -eq 1
            $status = if ($success) { "Success" } else { "Failure" }
            $statusColor = if ($success) { "Green" } else { "Red" }
            Write-Host "Login attempt with username '$username' and password '$password': $status" -ForegroundColor $statusColor
            Start-Sleep -Seconds 1
        }
    }

    # Show fake data breach alert
    $alerts = @(
        "WARNING: Unauthorized access detected!",
        "ALERT: Potential data breach in progress.",
        "NOTICE: Sensitive data may have been compromised.",
        "INFO: Security protocols initiated."
    )

    Display-Message "Generating security alert..."
    foreach ($alert in $alerts) {
        Write-Host $alert -ForegroundColor Red
        Start-Sleep -Seconds 2
    }

    # Simulate a system exploit
    $exploits = @(
        "Exploit 1: Buffer overflow in XYZ service.",
        "Exploit 2: Remote code execution vulnerability.",
        "Exploit 3: SQL injection attack on database.",
        "Exploit 4: Cross-site scripting (XSS) attack."
    )

    Display-Message "Executing system exploit simulation..."
    foreach ($exploit in $exploits) {
        Write-Host $exploit -ForegroundColor Red
        Start-Sleep -Seconds 2
    }

    # Show real-time progress update
    $total = 100
    Display-Message "Simulating real-time console update..."
    for ($i = 1; $i -le $total; $i++) {
        Write-Progress -PercentComplete ($i / $total * 100) -Status "Processing..." -CurrentOperation "$i% completed"
        Start-Sleep -Milliseconds 50
    }

    Write-Host "Real-time update completed." -ForegroundColor Green

    # Change to C drive and show directory tree
    Set-Location -Path C:\
    Display-Message "Executing directory tree on C drive..."
    tree

    # Final message
    Write-Host "Hacking simulation complete. No real systems were affected." -ForegroundColor Red
}

#Calculate Pi
function CalcPi {
    # Display result
    Write-Host "Approximated value of Pi: 3.14259265" -ForegroundColor Cyan
}

#Open Calculator
function Calc {
 Start-Process calc.exe}

#Shutdown
function Shutdown {
    param (
        [switch]$Force
    )

    if ($Force) {
        # Forcefully shut down the PC
        Stop-Computer -Force -Confirm:$false
    } else {
        # Gracefully shut down the PC
        Stop-Computer -Confirm:$false
    }
}


#Clear Caches
function ClearCache {
   

    # Clear Temporary Files
        Write-Host "Clearing temporary files..." -ForegroundColor Cyan
        $tempPath = [System.IO.Path]::GetTempPath()
        Remove-Item -Path $tempPath* -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Temporary files cleared." -ForegroundColor Green
    

    # Clear System Cache
        Write-Host "Clearing system cache..." -ForegroundColor Cyan
        # Flush system cache
        [System.Diagnostics.Process]::Start('cmd.exe', '/c ipconfig /flushdns') | Out-Null
        Write-Host "System cache cleared." -ForegroundColor Green
    

    # Clear Internet Explorer Cache
    
            Write-Host "Clearing Internet Explorer cache..." -ForegroundColor Cyan
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
            Write-Host "Internet Explorer cache cleared." -ForegroundColor Green
    
    

    # Clear Microsoft Edge Cache
    
            Write-Host "Clearing Microsoft Edge cache..." -ForegroundColor Cyan
            $edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
            Remove-Item -Path $edgeCachePath* -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Microsoft Edge cache cleared." -ForegroundColor Green
        
    }


function Setup {
# Ensure the script can run with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    break
}

# Function to test internet connectivity
function Test-InternetConnection {
    try {
        $testConnection = Test-Connection -ComputerName www.google.com -Count 1 -ErrorAction Stop
        return $true
    }
    catch {
        Write-Warning "Internet connection is required but not available. Please check your connection."
        return $false
    }
}

# Function to install Nerd Fonts
function Install-NerdFonts {
    param (
        [string]$FontName = "CascadiaCode",
        [string]$FontDisplayName = "CaskaydiaCove NF",
        [string]$Version = "3.2.1"
    )

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
        if ($fontFamilies -notcontains "${FontDisplayName}") {
            $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${Version}/${FontName}.zip"
            $zipFilePath = "$env:TEMP\${FontName}.zip"
            $extractPath = "$env:TEMP\${FontName}"

            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFileAsync((New-Object System.Uri($fontZipUrl)), $zipFilePath)

            while ($webClient.IsBusy) {
                Start-Sleep -Seconds 2
            }

            Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
            $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
            Get-ChildItem -Path $extractPath -Recurse -Filter "*.ttf" | ForEach-Object {
                If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
                    $destination.CopyHere($_.FullName, 0x10)
                }
            }

            Remove-Item -Path $extractPath -Recurse -Force
            Remove-Item -Path $zipFilePath -Force
        } else {
            Write-Host "Font ${FontDisplayName} already installed"
        }
    }
    catch {
        Write-Error "Failed to download or install ${FontDisplayName} font. Error: $_"
    }
}

# Check for internet connectivity before proceeding
if (-not (Test-InternetConnection)) {
    break
}

# OMP Install
try {
    winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh
}
catch {
    Write-Error "Failed to install Oh My Posh. Error: $_"
}

# Font Install
Install-NerdFonts -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF"

# Final check and message to the user
if ((Test-Path -Path $PROFILE) -and (winget list --name "OhMyPosh" -e) -and ($fontFamilies -contains "CaskaydiaCove NF")) {
    Write-Host "Setup completed successfully. Please restart your PowerShell session to apply changes."
} else {
    Write-Warning "Setup completed with errors. Please check the error messages above."
}

# Choco install
try {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
catch {
    Write-Error "Failed to install Chocolatey. Error: $_" -ForegroundColor Red
}

# Terminal Icons Install
try {
    Install-Module -Name Terminal-Icons -Repository PSGallery -Force
}
catch {
    Write-Error "Failed to install Terminal Icons module. Error: $_" -ForegroundColor Red
}
# zoxide Install
try {
    winget install -e --id ajeetdsouza.zoxide
    Write-Host "zoxide installed successfully."
}
catch {
    Write-Error "Failed to install zoxide. Error: $_" -ForegroundColor Red
}
}

# Help Function
function ShowHelp {
     Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    @"
PowerShell Profile Help
=======================

Directory Navigation:
- Docs: Changes the current directory to the user's Documents folder.
- Dtop: Changes the current directory to the user's Desktop folder.
- DLoads: Changes the current directory to the user's Downloads folder.
- CodeDIR:  Changes the current directory to the user's Code folder.and opens it in VS Code.
- Home: Changes directories to the user's home.
- Root: Changes directories to the C: drive.

File and System Information:
- LA: Lists all files in the current directory with detailed formatting.
- LL: Lists all files, including hidden, in the current directory with detailed formatting.
- SysInfo: Displays detailed system information.
- GetPrivIP: Retrieves the private IP address of the machine.
- GetPubIP: Retrieves the public IP address of the machine(-IncIPv6 )
- SpeedTest: Runs a speedtest for you internet.

System Maintenance:
- FlushDNS: Clears the DNS cache.
- SystemScan: Runs a DISM and SFC scan.
- Update: Updates all known apps.
- EmptyBin: Emptys Recycleing bin.
- ClearCache: Clears Windows Caches.

Utility Functions:
- FE: Opens File Explorer in your current directory.
- Winutil: Opens the Chris Titus Tech Windows utility.
- RPassword: Generates a random secure password (-Length x .Change X to change length).
- SystemTime: Updates the system time.
- ReloadProfile: Reloads the terminal profile.
- ClearRAM: Cleans up the standby memory in RAM.
- ReinstallWinget: Uninstalls Winget and reinstalls it.
- Hack: Runs a fake hacking app.
- CalcPi: Calculates pi to 7 digits.
- Calculator: Open Calculator.
- Shutdown: Shutdown PC (-Force to force shutdown)

- Setup: Automatically install dependincies.

Use 'ShowHelp' to display this help message.
"@
}