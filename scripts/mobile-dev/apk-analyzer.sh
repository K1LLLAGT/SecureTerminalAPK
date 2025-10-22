#!/bin/bash
# APK Analysis Tool

source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"
init_logging

APK_FILE="$1"

if [ -z "$APK_FILE" ]; then
    echo "Usage: apk-analyzer.sh <apk-file>"
    exit 1
fi

log_info "Analyzing APK: $APK_FILE"

# Check if APK exists
if [ ! -f "$APK_FILE" ]; then
    log_error "APK file not found: $APK_FILE"
    exit 1
fi

# Basic info
log_info "Getting APK information..."
aapt dump badging "$APK_FILE" 2>/dev/null || log_warn "aapt not available"

# Size analysis
SIZE=$(du -h "$APK_FILE" | cut -f1)
log_info "APK Size: $SIZE"

# Extract and analyze
TEMP_DIR=$(mktemp -d)
log_debug "Extracting to: $TEMP_DIR"

unzip -q "$APK_FILE" -d "$TEMP_DIR"

# Count files
TOTAL_FILES=$(find "$TEMP_DIR" -type f | wc -l)
log_info "Total files: $TOTAL_FILES"

# Find DEX files
DEX_COUNT=$(find "$TEMP_DIR" -name "*.dex" | wc -l)
log_info "DEX files: $DEX_COUNT"

# Find native libraries
NATIVE_LIBS=$(find "$TEMP_DIR" -name "*.so" | wc -l)
log_info "Native libraries: $NATIVE_LIBS"

# Cleanup
rm -rf "$TEMP_DIR"

log_info "Analysis complete!"
finish_logging
