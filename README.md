# WSL2 Proxy Script

## Description

This script is used to configure proxy from wsl2 to windows.

## Getting Started

### Dependencies

* Windows 10
* WSL2 installed
* A linux distro installed in the WSL2

### Installing

* Put the script in the folder you want
* Create an windows scheduler:
  * Trigger: run this script on login
  * Actions:
    - Run using powershell: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
    - Args: put the full path of script

### Executing program

You can run this script ...
* using powershell (manually)
* using the Windows Scheduler (automatic)


## Help

If you find any problem, create an issue to help improve this project.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details