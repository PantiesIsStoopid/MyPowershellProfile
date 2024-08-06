# PowerShell Profile Setup

## Overview

This project includes a PowerShell script for setting up a custom profile environment. It installs necessary dependencies, configures your PowerShell profile, and provides a cheatsheet for the newly added commands.

## Installation

### Prerequisites

- [PowerShell](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows) (version 7+ recommended)

### Setup

1. **Run the Setup Script**

    Execute the `Setup.ps1` script to install all dependencies required for your PowerShell profile:

    ```powershell
    powershell -ExecutionPolicy Bypass -File .\Setup.ps1
    ```

2. **Configure Your PowerShell Profile**

    Open a PowerShell terminal and type the following command to edit your PowerShell profile:

    ```powershell
    notepad $PROFILE
    ```

    Copy the code from the `Microsoft.PowerShell_profile.ps1` file and paste it into your profile file. Save and close Notepad.

3. **Restart Your Terminal**

    Close and reopen your PowerShell terminal to apply the new profile configuration.

4. **Verify Setup**

    To get a cheatsheet for all the commands added to your profile, type the following command in your terminal:

    ```powershell
    get-help
    ```

## Usage

After completing the setup, your PowerShell environment will be configured with custom commands and settings. Use the `get-help` command to explore the newly added commands and functionalities.

## Contributing

If you want to contribute to this setup:

1. Fork the repository.
2. Create a new branch for your changes (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push your changes to the branch (`git push origin feature-branch`).
5. Open a Pull Request for review.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [PowerShell Documentation](https://docs.microsoft.com/powershell/) - Official PowerShell documentation.
- [Notepad](https://support.microsoft.com/en-us/help/4468242/windows-10-notepad) - For editing the PowerShell profile.

---

Feel free to update the content as needed to reflect any specific details about your project or setup.
