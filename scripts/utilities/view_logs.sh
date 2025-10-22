#!/bin/bash
################################################################################
# Interactive Log Viewer
################################################################################

LOG_BASE="$HOME/SecureTerminalAPK/logs"

show_menu() {
    clear
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Log Viewer                                ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    echo "1) View Error Logs"
    echo "2) View Bug Reports"
    echo "3) View Session Logs"
    echo "4) View Security Logs"
    echo "5) View Consolidated Logs"
    echo "6) Search Logs"
    echo "7) Show Log Statistics"
    echo "8) Exit"
    echo ""
    read -p "Choose option: " choice
}

while true; do
    show_menu
    
    case $choice in
        1)
            echo -e "\n=== Recent Errors ==="
            tail -n 50 "$LOG_BASE/error_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -e "\n=== Bug Reports ==="
            ls -lt "$LOG_BASE/bug_reports"/*.md 2>/dev/null | head -n 10
            read -p "View a report? (filename or Enter): " report
            [ -n "$report" ] && cat "$LOG_BASE/bug_reports/$report" | less
            ;;
        3)
            echo -e "\n=== Recent Sessions ==="
            tail -n 100 "$LOG_BASE/session_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        4)
            echo -e "\n=== Security Logs ==="
            tail -n 50 "$LOG_BASE/security_logs"/*.log 2>/dev/null | less
            read -p "Press Enter to continue..."
            ;;
        5)
            latest=$(ls -t "$LOG_BASE/consolidated"/all_logs_*.log 2>/dev/null | head -n 1)
            if [ -n "$latest" ]; then
                less "$latest"
            else
                echo "No consolidated logs found"
                read -p "Press Enter to continue..."
            fi
            ;;
        6)
            read -p "Search term: " term
            grep -r "$term" "$LOG_BASE" 2>/dev/null | less
            ;;
        7)
            latest=$(ls -t "$LOG_BASE/consolidated"/log_statistics_*.txt 2>/dev/null | head -n 1)
            if [ -n "$latest" ]; then
                cat "$latest"
            else
                echo "No statistics found. Run consolidate_logs.sh first."
            fi
            read -p "Press Enter to continue..."
            ;;
        8)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac
done
