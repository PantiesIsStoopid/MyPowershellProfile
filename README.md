# PowerShell Profile Script

## Overview

This PowerShell profile script enhances your terminal experience by providing various utilities and customizations. It includes functionalities for terminal identification, directory navigation, system maintenance, and more.

## Features

### Terminal Identification
- **`TerminalType`**: Identifies and displays the type of terminal in use.

### Directory Navigation
- **`Docs`**: Navigates to the Documents directory.
- **`Dtop`**: Navigates to the Desktop directory.
- **`DLoads`**: Navigates to the Downloads directory.
- **`CodeDIR`**: Navigates to the Code directory and opens it in VS Code.
- **`Home`**: Changes the directory to the user's home.
- **`Root`**: Changes the directory to the C: drive.

### File and System Information
- **`LA`**: Lists all files in the current directory.
- **`LL`**: Lists all files including hidden files in the current directory.
- **`SysInfo`**: Displays detailed system information.
- **`GetPrivIP`**: Retrieves the private IP address of the machine.
- **`GetPubIP`**: Retrieves the public IP address of the machine (use `-IncIPv6` to include IPv6 addresses).
- **`Speedtest`**: Runs an internet speed test.

### System Maintenance
- **`FlushDNS`**: Clears the DNS cache.
- **`SystemScan`**: Runs a DISM and SFC scan to check and repair system files.
- **`Update`**: Updates PowerShell, pip, all known apps, and performs Windows Updates.
- **`EmptyBin`**: Empties the Recycle Bin.
- **`ClearCache`**: Clears various system caches, including temporary files, system cache, Internet Explorer, and Microsoft Edge caches.

### Utility Functions
- **`FE`**: Opens File Explorer in the current directory.
- **`WinUtil`**: Opens the Chris Titus Tech Windows utility.
- **`RPassword`**: Generates a random secure password (use `-Length` to specify the password length).
- **`CalcPi`**: Displays an approximation of Pi to 7 decimal places.
- **`Calc`**: Opens the Calculator application.
- **`Shutdown`**: Shuts down the PC (use `-Force` for a forced shutdown).
- **`ReinstallWinget`**: Uninstalls and reinstalls the Winget package manager.
- **`Hack`**: Runs a simulated hacking scenario for entertainment.
- **`ClearRAM`**: Clears system memory by forcing garbage collection and flushing memory.

### Setup
- **`Setup`**: Installs dependencies such as Oh My Posh, Nerd Fonts, and Chocolatey. Checks for internet connectivity before proceeding and performs necessary installations.

### Help
- **`ShowHelp`**: Displays a help message with descriptions of all available functions and their usage.

## Installation

1. Copy and paste the script into your PowerShell profile file (`$PROFILE`).
2. Run `Setup` to install the necessary dependencies and configurations.

## Usage

To use any function, simply type its name in the PowerShell terminal. For example, type `Docs` to navigate to the Documents directory or `Speedtest` to run an internet speed test.

## Note

- Ensure you run the script with appropriate permissions, especially for the `Setup` function which requires administrative privileges.
- Use `ShowHelp` to get a quick reference for all available functions.

## Troubleshooting

If you encounter issues or errors, refer to the error messages provided by the script. Ensure you have a stable internet connection and appropriate permissions to execute the functions.

Feel free to customize the script as needed to better fit your workflow and environment.
