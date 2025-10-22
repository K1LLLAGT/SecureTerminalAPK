#!/bin/bash
################################################################################
# Logging Library
# Provides standardized logging functions for all scripts
################################################################################

# Source configuration
[ -f "$HOME/SecureTerminalAPK/config/logging_config.env" ] && \
    source "$HOME/SecureTerminalAPK/config/logging_config.env"

# Initialize logging
init_logging() {
    local script_name=$(basename "$0" .sh)
    export CURRENT_LOG_FILE="$SCRIPT_LOGS/${script_name}_$(date +%Y%m%d_%H%M%S).log"
    
    # Create log file
    touch "$CURRENT_LOG_FILE"
    
    # Log script start
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    echo "Script: $script_name" >> "$CURRENT_LOG_FILE"
    echo "Started: $(date +"$LOG_TIMESTAMP_FORMAT")" >> "$CURRENT_LOG_FILE"
    echo "PID: $$" >> "$CURRENT_LOG_FILE"
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
}

# Log functions
log_error() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [ERROR] $message"
    
    # Console output
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_ERROR}[ERROR]${LOG_COLOR_RESET} $message"
    fi
    
    # File output
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
        echo "$log_entry" >> "$ERROR_LOGS/errors_$(date +%Y%m%d).log"
    fi
    
    # Consolidated log
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_warn() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [WARN] $message"
    
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_WARN}[WARN]${LOG_COLOR_RESET} $message"
    fi
    
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
    fi
    
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_info() {
    local message="$1"
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    local log_entry="[$timestamp] [INFO] $message"
    
    if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
        echo -e "${LOG_COLOR_INFO}[INFO]${LOG_COLOR_RESET} $message"
    fi
    
    if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
        echo "$log_entry" >> "$CURRENT_LOG_FILE"
    fi
    
    if [ "$ENABLE_CONSOLIDATED" = "true" ]; then
        echo "$log_entry" >> "$CONSOLIDATED_LOG"
    fi
}

log_debug() {
    local message="$1"
    
    # Only log if debug level is enabled
    if [ "$LOG_LEVEL" = "DEBUG" ]; then
        local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
        local log_entry="[$timestamp] [DEBUG] $message"
        
        if [ "$ENABLE_CONSOLE_OUTPUT" = "true" ]; then
            echo -e "${LOG_COLOR_DEBUG}[DEBUG]${LOG_COLOR_RESET} $message"
        fi
        
        if [ "$ENABLE_FILE_OUTPUT" = "true" ]; then
            echo "$log_entry" >> "$CURRENT_LOG_FILE"
        fi
    fi
}

# Create bug report
create_bug_report() {
    local title="$1"
    local description="$2"
    local report_file="$BUG_REPORTS/bug_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << BUGREPORT
# Bug Report

**Date:** $(date)
**Title:** $title

## Description
$description

## Environment
- Script: $(basename "$0")
- User: $USER
- Shell: $SHELL
- PWD: $PWD

## Recent Logs
\`\`\`
$(tail -n 50 "$CURRENT_LOG_FILE" 2>/dev/null || echo "No recent logs")
\`\`\`

## System Info
$(uname -a)

## Error Context
$(tail -n 20 "$ERROR_LOGS/errors_$(date +%Y%m%d).log" 2>/dev/null || echo "No recent errors")
BUGREPORT

    echo "Bug report created: $report_file"
    log_info "Bug report created: $report_file"
}

# Finish logging
finish_logging() {
    local exit_code=$?
    local timestamp=$(date +"$LOG_TIMESTAMP_FORMAT")
    
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    echo "Finished: $timestamp" >> "$CURRENT_LOG_FILE"
    echo "Exit code: $exit_code" >> "$CURRENT_LOG_FILE"
    echo "==================================================================" >> "$CURRENT_LOG_FILE"
    
    # Copy to storage if available
    if [ -d "$STORAGE_LOGS" ]; then
        cp "$CURRENT_LOG_FILE" "$STORAGE_LOGS/" 2>/dev/null || true
    fi
    
    if [ -d "$SDCARD_LOGS" ]; then
        cp "$CURRENT_LOG_FILE" "$SDCARD_LOGS/" 2>/dev/null || true
    fi
    
    return $exit_code
}

# Trap errors
trap_errors() {
    set -E
    trap 'log_error "Error on line $LINENO: $BASH_COMMAND"' ERR
}
