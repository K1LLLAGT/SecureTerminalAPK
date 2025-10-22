#!/bin/bash
# Educational Port Scanner

source "$HOME/SecureTerminalAPK/scripts/utilities/logging_lib.sh"
init_logging

HOST="${1:-127.0.0.1}"
START_PORT="${2:-1}"
END_PORT="${3:-1000}"

log_info "Scanning $HOST ports $START_PORT-$END_PORT (Educational)"

for port in $(seq $START_PORT $END_PORT); do
    timeout 1 bash -c "echo >/dev/tcp/$HOST/$port" 2>/dev/null && \
        echo "Port $port: OPEN" | tee -a "$CURRENT_LOG_FILE"
done

log_info "Scan complete"
finish_logging
