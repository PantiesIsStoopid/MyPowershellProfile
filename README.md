# PowerShell Profile

## Overview

This PowerShell profile script includes various functions and settings to enhance your PowerShell experience. It features terminal identification, system updates, aliases for common commands, and more.

## Requirements

To use this PowerShell profile script effectively, you need to have the following tools installed:

1. **Python**: Ensure Python is installed and added to your system's PATH. This is required for upgrading `pip`.

2. **winget**: The Windows Package Manager (`winget`) must be installed to manage application updates. It comes pre-installed with Windows 10 (build 1809 or later) and Windows 11.

3. **neofetch**: This utility is used for displaying system information. You can install it via `winget` using the following command:
    ```powershell
    winget install neofetch
    ```

## Installation

1. **Python**: Download and install Python from [python.org](https://www.python.org/downloads/).

2. **winget**: Ensure that `winget` is installed. If it is not, you can install it via the [App Installer](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) from the Microsoft Store.

3. **neofetch**: Install `neofetch` using:
    ```powershell
    winget install neofetch
    ```

## Usage

Follow the instructions in the script to use various functions and aliases provided.

## Help

For a detailed list of functions and their usage, run:
```powershell
Show-Help
