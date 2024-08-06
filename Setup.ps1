# Install Chocolatey (if not already installed)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install Python
choco install python -y

# Install Nile Shell
choco install nile -y

# Install Oh My Posh
Install-Module oh-my-posh -Scope CurrentUser -Force

# Install Cascadia Code font
$casCodeUrl = "https://github.com/microsoft/cascadia-code/releases/download/v2110.01/CascadiaCode-v2110.01.zip"
Invoke-WebRequest -Uri $casCodeUrl -OutFile "$env:TEMP\CascadiaCode.zip"
Expand-Archive -Path "$env:TEMP\CascadiaCode.zip" -DestinationPath "$env:TEMP\CascadiaCode"
$fonts = Get-ChildItem "$env:TEMP\CascadiaCode\CascadiaCode\ttf\*.ttf"
foreach ($font in $fonts) {
    Start-Process -FilePath $font.FullName -ArgumentList "/quiet" -Wait
}

# Install Nerd Fonts
$nerdFontsUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.0/nerd-fonts.zip"
Invoke-WebRequest -Uri $nerdFontsUrl -OutFile "$env:TEMP\nerd-fonts.zip"
Expand-Archive -Path "$env:TEMP\nerd-fonts.zip" -DestinationPath "$env:TEMP\nerd-fonts"
$fonts = Get-ChildItem "$env:TEMP\nerd-fonts\Windows\Fonts\*.ttf"
foreach ($font in $fonts) {
    Start-Process -FilePath $font.FullName -ArgumentList "/quiet" -Wait
}

# Set default font in PowerShell
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}
Add-Content -Path $profilePath -Value 'Set-PSReadLineOption -Font "Cascadia Code"'

# Install Neofetch
choco install neofetch -y

# Install Winget (if not already installed)
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00 -OutFile "$env:TEMP\vclibs.msi"
    Start-Process -FilePath "$env:TEMP\vclibs.msi" -ArgumentList "/quiet" -Wait
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.DesktopAppInstaller -OutFile "$env:TEMP\appinstaller.msi"
    Start-Process -FilePath "$env:TEMP\appinstaller.msi" -ArgumentList "/quiet" -Wait
}
