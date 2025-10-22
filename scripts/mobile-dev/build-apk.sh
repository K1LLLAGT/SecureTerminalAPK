#!/bin/bash
# APK Build Helper

source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"
init_logging

PROJECT_DIR="$1"
OUTPUT_DIR="${2:-$HOME/SecureTerminalAPK/build}"

if [ -z "$PROJECT_DIR" ]; then
    echo "Usage: build-apk.sh <project-dir> [output-dir]"
    exit 1
fi

log_info "Building APK from: $PROJECT_DIR"

mkdir -p "$OUTPUT_DIR"

cd "$PROJECT_DIR"

# Check for build.gradle
if [ ! -f "build.gradle" ]; then
    log_error "No build.gradle found!"
    exit 1
fi

# Run Gradle build
log_info "Running Gradle build..."
.gradlew assembleDebug 2>&1 | tee -a "$CURRENT_LOG_FILE"

# Find generated APK
APK=$(find . -name "*.apk" | head -n 1)

if [ -n "$APK" ]; then
    cp "$APK" "$OUTPUT_DIR/"
    log_info "APK built: $OUTPUT_DIR/$(basename $APK)"
else
    log_error "Build failed - no APK generated"
fi

finish_logging
