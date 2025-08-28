# MacOS Renaming Script  

**Author:** Ethan Blair  
**Date:** 10-31-24  

## Overview  
This script provides an interactive way to rename a MacBook based on department and asset tag. It uses AppleScript dialogs for input and updates the device’s **ComputerName**, **HostName**, and **LocalHostName** via `scutil`.  

## Features  
- Department selection from a predefined list  
- Asset tag input prompt  
- Device name automatically set as `<DEPARTMENT>-<ASSET_TAG>`  
- Secure password prompt for required root access  
- Confirmation dialogs on success or failure  

## Requirements  
- macOS with **zsh**  
- Admin/root privileges  
- Script must be run in a terminal with GUI access (for AppleScript dialogs)  

## Usage  
1. Open Terminal.  
2. Run the script:  
   ```bash
   ./rename_macbook.sh
