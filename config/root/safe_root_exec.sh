#!/bin/bash
################################################################################
# Safe Root Execution Wrapper - Educational
# Logs all commands and requires confirmation
################################################################################

source "$HOME/SecureTerminalAPK/config/root/root_config.env"

COMMAND="$@"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Log the command
echo "[$TIMESTAMP] Command requested: $COMMAND" >> "$ROOT_ACCESS_LOG"

# In educational mode, show what would be executed
if [ "$ROOT_EDUCATION_MODE" = "true" ]; then
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           EDUCATIONAL MODE - COMMAND PREVIEW                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Command that would be executed with root:"
    echo "  $COMMAND"
    echo ""
    echo "In production, this would require root access."
    echo "For educational purposes, we'll simulate or run unprivileged."
    echo ""
    
    if [ "$ROOT_REQUIRE_CONFIRMATION" = "true" ]; then
        read -p "Continue with simulation? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            echo "Cancelled."
            exit 1
        fi
    fi
fi

# Execute the command (educational - without actual root)
echo "Executing (educational mode)..."
eval "$COMMAND" 2>&1 | tee -a "$ROOT_LOG_DIR/command_output.log"

EXIT_CODE=$?
echo "[$TIMESTAMP] Exit code: $EXIT_CODE" >> "$ROOT_ACCESS_LOG"

exit $EXIT_CODE
