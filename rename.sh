#Ethan Blair | MacOS renaming | 10-31-24
#!/usr/bin/env zsh

# Function to show the department selection dialog
select_department() {
    osascript <<EOF
try
    tell application "System Events"
        set departmentList to {"ASA", "CETL", "ACCT", "ADM", "APNA", "ASAP", "ATH", "ASL", "BUSN", "CREC", "CARD", "CS", "CHE", "CIE", "CCCC", "CEBS", "HSS", "NHS", "OST", "PVA", "COMM", "CCES", "CNCT", "DS", "DNSV", "DSS", "EMSA", "ES", "FM", "FND", "GRAD", "HLTH", "HSL", "HR", "IA", "IMT", "MGCC", "MCN", "MCB", "NSO", "OBIA", "OFA", "OIEC", "OMA", "PARK", "PAY", "PLP", "POL", "PRES", "PFSV", "REG", "RESL", "OSP", "SAEI", "STAC", "TICK", "UCAD", "UA", "UL", "UR", "VET", "WRC"}
        set chosenDepartment to choose from list departmentList with prompt "Select your department:" without multiple selections allowed and empty selection allowed
        if chosenDepartment is false then
            return "cancel"
        else
            return item 1 of chosenDepartment
        end if
    end tell
on error
    return "cancel"
end try
EOF
}

# Function to rename the MacBook
rename_macbook() {
    sudo -S scutil --set ComputerName "$DEVICE_NAME" <<< "$PSK_INPUT" &&
    sudo -S scutil --set HostName "$DEVICE_NAME" <<< "$PSK_INPUT" &&
    sudo -S scutil --set LocalHostName "$DEVICE_NAME" <<< "$PSK_INPUT" &&
    sudo dscacheutil -flushcache
}

# Main loop
while true; do
    department=$(select_department)
    
    if [[ "$department" == "cancel" ]]; then
        osascript -e 'tell application "System Events" to display dialog "Exiting program." buttons {"OK"}'
        echo "Exiting program."
        exit 0
    fi

    assetTag=$(osascript -e 'text returned of (display dialog "Enter the asset tag:" default answer "" buttons {"Cancel", "OK"} default button "OK")')
    
    if [[ $? -ne 0 ]]; then
        osascript -e 'tell application "System Events" to display dialog "Exiting program." buttons {"OK"}'
        echo "Exiting program."
        exit 0
    fi

    if [[ -z "$assetTag" ]]; then
        echo "Operation cancelled."
        exit 1
    fi

    export DEVICE_NAME="${department}-${assetTag}"

    # Prompt for root password
    PSK_INPUT=$(osascript -e 'text returned of (display dialog "Input password:" default answer "" buttons {"Cancel", "OK"} default button "OK" with hidden answer)')
    
    if [[ $? -ne 0 || -z "$PSK_INPUT" ]]; then
        osascript -e 'tell application "System Events" to display dialog "Exiting program." buttons {"OK"}'
        echo "Operation cancelled."
        exit 1
    fi

    echo "Attempting to rename to: $DEVICE_NAME"

    osascript -e 'tell application "System Events" to display dialog "Renaming MacBook..." buttons {"Cancel"} giving up after 60' &

    if rename_macbook; then
        osascript -e 'tell application "System Events" to display dialog "Successfully renamed MacBook to '"$DEVICE_NAME"'" buttons {"OK"}'
        break  # Exit the loop after a successful rename
    else
        osascript -e 'tell application "System Events" to display dialog "Failed to rename MacBook. Please check your password and permissions." buttons {"OK"}'
    fi
done

unset DEVICE_NAME
unset PSK_INPUT
