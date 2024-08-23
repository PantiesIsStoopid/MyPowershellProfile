#* Opt out of Powershell telemetry
if ([bool]([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsSystem) {
  [System.Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 'true', [System.EnvironmentVariableTarget]::Machine)
}

#* Import Modules and External Profiles
#* Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#* Clear the console
Clear-Host

#* Function to identify the terminal
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

#* Get terminal type and print it
$terminalType = TerminalType
Write-Host "$terminalType" -ForegroundColor Yellow

#* Initialize Oh My Posh config
if ($PSCmdlet.MyInvocation.PSCommandPath -notmatch 'oh-my-posh') {
  oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
}

#* Run neofetch if not in Visual Studio Code Terminal
if ($terminalType -ne "Visual Studio Code Terminal") {
  neofetch
}

#* Alias
# Set directory to Documents
function Docs {
  Set-Location -Path "$HOME\onedrive\Documents"
}

#* Set directory to Desktop
function Dtop {
  Set-Location -Path "$HOME\onedrive\Desktop"
}

#* Move to the Downloads directory
function DLoads {
  Set-Location -Path "$HOME\Downloads"
}

function CodeDIR {
  Set-Location -Path "$HOME\onedrive\Documents\code"
  code .
}

#* List all files
function LA {
  Get-ChildItem -Path . -Force | Format-Table -AutoSize
}

#* List all files including hidden
function LL {
  Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize
}

#* Print Detailed System Information
function SysInfo {
  Get-ComputerInfo
}

#* Flush DNS Server
function FlushDNS {
  Clear-DnsClientCache
  Write-Host "DNS has been flushed" -ForegroundColor Green
}

#* Print the Public IP of the PC
function GetPubIP {
  (Invoke-WebRequest http://ifconfig.me/ip).Content
}

#* Print the Private IP of the PC
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

#* Run speedtest for internet
function Speedtest {  
  Write-Host "Running Speedtest" -ForegroundColor Cyan
  Invoke-RestMethod asheroto.com/speedtest | Invoke-Expression
  Write-Host "Pinging 1.1.1.1" -ForegroundColor Cyan
  ping 1.1.1.1
}

#* Open current directory in File Explorer
function FE {
  Invoke-Item (Get-Location)
}

#* Change directories to user's home
function Home {
  Set-Location -Path "$HOME"
}

#* Change directories to C drive
function Root {
  Set-Location c:\
}

#* Update function
function Update {
  #Update Powershell
  winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements

  # Upgrade pip
  python -m pip install --upgrade pip

  # Update all known apps
  choco upgrade chocolatey
  choco upgrade all

  # Windows Updates
  Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
  Get-WindowsUpdate
}

#* Open the Chris Titus Tech Windows utility
function WinUtil {
  Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression
}

#* Reload Terminal profile
function ReloadProfile {
  & $profile
}

#* Check for corrupt files 
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

#* Generate a random secure password
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
    $HasSymbols = ($Password -match '[!@#*$%^&*()_+]') ? 1 : 0
  }

  # Display Password
  Write-Host "The Password :$Password is now in clipboard" -ForegroundColor Green
  Set-Clipboard -Value $Password
}



#* Function to clear system memory (not specifically standby RAM)
function ClearRAM {
  # Define URL and paths
  $url = "https://download.sysinternals.com/files/RAMMap.zip"
  $zipPath = "C:\RAMMap.zip"
  $extractPath = "C:\RAMMap"

  # Download RAMMap
  Invoke-WebRequest -Uri $url -OutFile $zipPath

  # Create extraction directory
  if (-Not (Test-Path $extractPath)) {
    New-Item -Path $extractPath -ItemType Directory | Out-Null
  }

  # Extract the ZIP file
  Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

  # Define the path to the executable
  $exePath = "C:\RAMMap\RAMMap.exe"

  # Run the executable and wait until it is closed
  Write-Host "Please open the app click 'Empty' then 'Empty Standby List' Then close the app."
  Start-Process -FilePath $exePath -Wait

  # Clean up by deleting RAMMap files
  Remove-Item -Path $zipPath -Force
  Remove-Item -Path $extractPath -Recurse -Force
  
}

#*Reinstall winget
function ReinstallWinget {
  #Uninstall winget
  Get-AppxPackage *Microsoft.DesktopAppInstaller* | Remove-AppxPackage

  #Install Winget
  Invoke-WebRequest -Uri "https://aka.ms/Microsoft.DesktopAppInstaller" -OutFile "$env:TEMP\AppInstaller.appxbundle"
  Add-AppxPackage -Path "$env:TEMP\AppInstaller.appxbundle"

  #Verify winget install
  winget --version
}

#*Empty Recycle Bin
function EmptyBin {
  Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
}

#*Fake Hacking
function Hack {
  # Function to display a message with a delay
  function DisplayMessage {
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
  DisplayMessage "Initiating hacking ..." -ForegroundColor Cyan

  # Simulate network scan
  $devices = @(
    "192.168.1.1 - Router",
    "192.168.1.10 - Laptop",
    "192.168.1.15 - Printer",
    "192.168.1.20 - Smart TV",
    "192.168.1.25 - Smartphone"
  )

  DisplayMessage "Scanning network for devices..." -ForegroundColor Cyan
  foreach ($device in $devices) {
    Write-Host "Discovered device: $device" -ForegroundColor Green
    Start-Sleep -Seconds 1
  }

  # Fake Hacking Simulation Script

# Function to simulate typing
function Typing {
  param (
      [string]$Text,
      [int]$Delay = 1  # Reduced delay for faster typing
  )
  $Text.ToCharArray() | ForEach-Object {
      Write-Host -NoNewline $_
      Start-Sleep -Milliseconds $Delay
  }
  Write-Host ""
}

# Function to print dummy C++ code
function FakeCode {
  $cppCode = @"
#include <iostream>
using namespace std;

int main() {
  cout << "Hacking started." << endl;
  for (int i = 0; i < 10; i++) {
      cout << "Executing operation " << i << endl;
  }
  return 0;
}
"@
  Typing -Text $cppCode
}

# List of 100 common names
$commonNames = @(
  "James", "John", "Robert", "Michael", "William", "David", "Richard", "Charles", "Joseph", "Thomas",
  "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", "Andrew", "Kenneth", "Joshua",
  "George", "Kevin", "Brian", "Edward", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan", "Jacob",
  "Gary", "Nicholas", "Eric", "Stephen", "Larry", "Justin", "Scott", "Brandon", "Benjamin", "Adam",
  "Samuel", "Gregory", "Alexander", "Patrick", "Jack", "Dennis", "Jerry", "Tyler", "Aaron", "Henry",
  "Douglas", "Zachary", "Peter", "Walter", "Nathan", "Harold", "Kyle", "Carl", "Arthur", "Gerald",
  "Roger", "Joe", "Juan", "Jackie", "Albert", "Lawrence", "Nicholas", "Willie", "Jesse", "Bobby",
  "Eugene", "Ralph", "Roy", "Bennett", "Mark", "Henry", "George", "Terry", "Troy", "Brady",
  "Russell", "Bradley", "Albert", "Andre", "Derrick", "Lee", "Eddie", "Micheal", "Nathaniel", "Rodney"
)

# List of 100 common passwords
$commonPasswords = @(
  "password123", "123456", "123456789", "qwerty", "abc123", "password", "12345678", "12345", "1234567", "admin",
  "letmein", "welcome", "password1", "123123", "qwerty123", "password12", "1234567", "qwerty1", "123321", "qwertyuiop",
  "password1234", "1q2w3e4r", "123qwe", "password1", "123456a", "123123123", "qwe123", "1q2w3e", "1234567890", "letmein1",
  "abc123456", "123456q", "pass123", "admin123", "admin1", "iloveyou", "welcome1", "welcome123", "123qwe123", "passw0rd",
  "qwerty12", "1234567a", "qwerty1234", "letmein123", "1q2w3e4r5t", "qwerty!@#", "password01", "123abc", "admin2021",
  "admin2020", "password12345", "password12", "pass123456", "password1", "1q2w3e", "123456789a", "qwerty12345", "abc1234",
  "123qwe123", "123qwe", "qwerty123456", "1q2w3e4r5t6y", "1q2w3e4r5t", "password2021", "password2020", "1234561", "123456abc",
  "123456789q", "welcome2021", "admin2022", "1234567a", "qwerty!@#", "abc12345", "password2022", "admin1234", "1q2w3e4r5t6y7u",
  "password123456", "letmein1234", "1234567890q", "qwerty789", "password2023", "password!@#", "qwerty1234567", "1234abcd"
)

# Function to print random usernames and attempt logins
function LoginAttempts {
  $Username = Get-Random -InputObject $commonNames
  $Password = Get-Random -InputObject $commonPasswords
  
  Typing -Text "Attempting login: $Username , $Password"
}

# Main script
Write-Host "Starting hacking" -ForegroundColor Green
Start-Sleep -Seconds 1

# Print dummy C++ code
FakeCode

# Print random login attempts
for ($i = 0; $i -lt 10; $i++) {
  LoginAttempts
  Start-Sleep -Seconds 0.5
}


  # Show fake data breach alert
  $alerts = @(
    "WARNING: Unauthorized access detected!",
    "ALERT: Potential data breach in progress.",
    "NOTICE: Sensitive data may have been compromised.",
    "INFO: Security protocols initiated."
  )

  DisplayMessage "Generating security alert..."
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

  DisplayMessage "Executing system exploit simulation..."
  foreach ($exploit in $exploits) {
    Write-Host $exploit -ForegroundColor Red
    Start-Sleep -Seconds 2
  }

  Write-Host "Real-time update completed." -ForegroundColor Green

  # Change to C drive and show directory tree
  Set-Location -Path C:\
  DisplayMessage "Executing directory tree on C drive..."
  tree

  # Final message
  Write-Host "Hacking complete, £917,197,856,86 has been deposited into your account." -ForegroundColor Green
}

#* Calculate Pi
function CalcPi {
  # Display result
  $Pi = "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665223576580719180188"
  Write-Host "Calculating complete result in clipboard." -ForegroundColor Green
  Set-Clipboard -Value $Pi

}

#*Open Calculator
function Calc {
  Start-Process calc.exe
}

#*Shutdown
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

#* RandomFact
function RandomFact {
  $url = "https://uselessfacts.jsph.pl/random.json?language=en"
  $response = Invoke-RestMethod -Uri $url
  Write-Host "Did you know? $($response.text)" 
}

#*Clear Caches
function ClearCache {


  # Clear Temporary Files
    Write-Host "Clearing temporary files..." -ForegroundColor Cyan
    $tempPath = [System.IO.Path]::GetTempPath()
    Remove-Item -Path $tempPath* -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleared." -ForegroundColor Green
  

  # Clear System Cache
    Write-Host "Clearing system cache..." -ForegroundColor Cyan
    #* Flush system cache
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

#*Setup all dependincies for the script
function Setup {
# Ensure the script can run with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Warning "Please run this script as an Administrator!" -ForegroundColor Red
  break
}

# Function to test internet connectivity
function Test-InternetConnection {
  try {
    Test-Connection -ComputerName google.com -Count 1 -Quiet
    return $true
  }
  catch {
    Write-Warning "Internet connection is required but not available. Please check your connection." -ForegroundColor Red
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
      Write-Host "Font ${FontDisplayName} already installed" -ForegroundColor Yellow
    }
  }
  catch {
    Write-Error "Failed to download or install ${FontDisplayName} font. Error: $_" -ForegroundColor Red
  }
}

# OMP Install
try {
  winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh
}
catch {
  Write-Error "Failed to install Oh My Posh. Error: $_" -ForegroundColor Red
}

# Font Install
Install-NerdFonts -FontName "CascadiaCode" -FontDisplayName "CaskaydiaCove NF"

# Final check and message to the user
if ((Test-Path -Path $PROFILE) -and (winget list --name "OhMyPosh" -e) -and ($fontFamilies -contains "CaskaydiaCove NF")) {
  Write-Host "Setup completed successfully. Please restart your PowerShell session to apply changes." -ForegroundColor Green
} else {
  Write-Error "Setup completed with errors. Please check the error messages above."
}

# Choco install
try {
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
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

# Zoxide Install
try {
  winget install -e --id ajeetdsouza.zoxide
  Write-Host "zoxide installed successfully."
}
catch {
  Write-Error "Failed to install zoxide. Error: $_" -ForegroundColor Red
}

try {
  choco install python --pre 
  Write-Host "Python installed successfully."
}
catch {
  Write-Error "Failed to install Python." -ForegroundColor Red
}
}

function RShutdown {
  # Function to check if a computer is reachable
  function Test-ComputerReachability {
      param (
          [string]$ComputerName
      )
      return Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
  }

  # Function to get the subnet of the local machine
  function Get-LocalSubnet {
      $ipInfo = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixOrigin -eq "Dhcp" -or $_.PrefixOrigin -eq "Manual" }
      if ($ipInfo) {
          $ipAddress = $ipInfo.IPAddress
          $subnet = $ipAddress.Substring(0, $ipAddress.LastIndexOf("."))
          return $subnet
      } else {
          throw "Unable to determine local subnet."
      }
  }

  # Scan the network for active computers
  function Get-NetworkComputers {
      $subnet = Get-LocalSubnet
      $activeComputers = @()

      for ($i = 1; $i -le 254; $i++) {
          $ip = "$subnet.$i"
          if (Test-ComputerReachability -ComputerName $ip) {
              $activeComputers += $ip
          }
      }
      return $activeComputers
  }

  # Function to shut down a computer without warning
  function ShutDownComputer {
      param (
          [string]$ComputerName
      )
      Start-Process -FilePath "shutdown.exe" -ArgumentList "/s /f /t 0 /m \\$ComputerName" -NoNewWindow
  }

  # Scan the network
  $computers = Get-NetworkComputers
  if ($computers.Count -eq 0) {
      Write-Output "No active computers found."
  } else {
      Write-Output "Active computers found:"
      $computers | ForEach-Object { Write-Output $_ }

      # Example: shutting down the first computer in the list
      if ($computers.Count -gt 0) {
          $targetComputer = $computers[0]
          Write-Output "Shutting down $targetComputer..."
          ShutDownComputer -ComputerName $targetComputer
      }
  }
}


function CheatSheet {
@"
PowerShell Cheatsheet
=====================

Basic Commands:
- Get-Command: Lists all cmdlets, functions, workflows, aliases installed.
- Get-Process: Retrieves a list of running processes.
- Start-Process: Starts a process.
- Stop-Process: Stops a process.
- Get-Service: Lists all services.
- Start-Service: Starts a service.
- Stop-Service: Stops a service.
- Restart-Service: Restarts a service.

File and Directory Management:
- Get-ChildItem: Lists items in a directory (alias: ls, dir).
- Set-Location: Changes the current directory (alias: cd).
- Copy-Item: Copies an item from one location to another.
- Move-Item: Moves an item from one location to another.
- Remove-Item: Deletes an item.
- New-Item: Creates a new item (file, directory, etc.).
- Get-Content: Reads content of a file.
- Set-Content: Writes or replaces content in a file.
- Add-Content: Appends content to a file.

System Information:
- Get-Location: Displays the current directory.
"@
}


#* Help Function
function ShowHelp {
@"
PowerShell Profile Help
=======================

Directory Navigation:
- Docs: Changes the current directory to the user's Documents folder.
- Dtop: Changes the current directory to the user's Desktop folder.
- DLoads: Changes the current directory to the user's Downloads folder.
- CodeDIR: Changes the current directory to the user's Code folder and opens it in VS Code.
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
- ReloadProfile: Reloads the terminal profile.
- ClearRAM: Cleans up the standby memory in RAM.
- ReinstallWinget: Uninstalls Winget and reinstalls it.
- Hack: Runs a fake hacking app.
- CalcPi: Calculates pi to 100 digits.
- Calc: Open Calculator.
- Shutdown: Shutdown PC (-Force to force shutdown)
- RShutdown: Attempt shutdown on all vunerable computer on network.
- RandomFact: Prints a random fun fact.

- Setup: Automatically install requirments.
- CheatSheet: Displays a list of all the most common commands.

Use 'ShowHelp' to display this help message.
"@
}
