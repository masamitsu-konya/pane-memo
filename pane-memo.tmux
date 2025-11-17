#!/usr/bin/env bash

# pane-memo - Display current pane information in pane 0
# Main plugin entry point for TPM (Tmux Plugin Manager)

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get user configuration or use defaults
get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# Configuration options
TARGET_PANE=$(get_tmux_option "@pane-memo-target-pane" "0")
ENABLED=$(get_tmux_option "@pane-memo-enabled" "on")

# Only set up if enabled
if [ "$ENABLED" = "on" ]; then
    # Enable focus events (required for pane-focus-in hook)
    tmux set-option -g focus-events on > /dev/null 2>&1

    # Set up the pane-focus-in hook to update display when switching panes
    tmux set-hook -g pane-focus-in "run-shell '$CURRENT_DIR/scripts/update_display.sh #{pane_index} #{pane_current_path} #{pane_current_command} #{pane_pid} #{pane_tty}'" > /dev/null 2>&1

    # Also trigger on window pane change
    tmux set-hook -g window-pane-changed "run-shell '$CURRENT_DIR/scripts/update_display.sh #{pane_index} #{pane_current_path} #{pane_current_command} #{pane_pid} #{pane_tty}'" > /dev/null 2>&1

    # Auto-start watch_display.sh when new session is created
    tmux set-hook -g after-new-session "run-shell 'sleep 0.5 && $CURRENT_DIR/scripts/start_watch.sh'" > /dev/null 2>&1

    # Auto-start watch_display.sh when new window is created
    tmux set-hook -g after-new-window "run-shell 'sleep 0.5 && $CURRENT_DIR/scripts/start_watch.sh'" > /dev/null 2>&1

    # Auto-start watch_display.sh when pane is split
    tmux set-hook -g after-split-window "run-shell 'sleep 0.5 && $CURRENT_DIR/scripts/start_watch.sh'" > /dev/null 2>&1

    # Start immediately on plugin load (for existing sessions)
    "$CURRENT_DIR/scripts/start_watch.sh" &
fi
