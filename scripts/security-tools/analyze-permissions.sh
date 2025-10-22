#!/bin/bash
# APK Permission Analyzer

source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"
init_logging

APK="$1"

if [ -z "$APK" ]; then
    echo "Usage: analyze-permissions.sh <apk-file>"
    exit 1
fi

log_info "Analyzing permissions: $APK"

echo "=== PERMISSIONS ANALYSIS ===" | tee -a "$CURRENT_LOG_FILE"

# Extract permissions
aapt dump permissions "$APK" 2>/dev/null | while read line; do
    if [[ "$line" =~ "permission:" ]]; then
        PERM=$(echo "$line" | sed 's/.*permission: //')
        
        # Flag dangerous permissions
        if [[ "$PERM" =~ (CAMERA|LOCATION|CONTACTS|SMS|STORAGE|PHONE) ]]; then
            echo "⚠️  SENSITIVE: $PERM" | tee -a "$CURRENT_LOG_FILE"
        else
            echo "   $PERM" | tee -a "$CURRENT_LOG_FILE"
        fi
    fi
done

log_info "Permission analysis complete"
finish_logging
