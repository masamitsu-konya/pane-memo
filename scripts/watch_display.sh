#!/usr/bin/env bash

# Watch script that continuously displays pane information
# This runs in the target pane to avoid polluting shell history

DISPLAY_FILE="/tmp/pane-memo-display"

# Clear screen on startup
clear

# Main loop
while true; do
    if [ -f "$DISPLAY_FILE" ]; then
        clear
        cat "$DISPLAY_FILE"
    else
        clear
        echo ""
        echo "┌──────────────────────────────────────────────────────────┐"
        echo "│ Waiting for pane information...                          │"
        echo "└──────────────────────────────────────────────────────────┘"
        echo ""
    fi

    # Wait for file changes or timeout after 1 second
    sleep 0.5
done
