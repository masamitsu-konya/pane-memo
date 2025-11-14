#!/usr/bin/env bash

# Get detailed information about a specific tmux pane
# Usage: get_pane_info.sh <pane_index> <current_path> <current_command> <pane_pid> <pane_tty>

PANE_INDEX=$1
CURRENT_PATH=$2
CURRENT_COMMAND=$3
PANE_PID=$4
PANE_TTY=$5

# Get the real command running in the pane (more accurate than current_command)
get_running_command() {
    local pid=$1
    local tty=$2

    # Try to get the most recent process in the pane
    if [ -n "$tty" ]; then
        # Get processes running on this TTY
        local cmd=$(ps -t "$tty" -o comm= | tail -1)
        if [ -n "$cmd" ]; then
            echo "$cmd"
            return
        fi
    fi

    # Fallback to current command
    echo "$CURRENT_COMMAND"
}

# Shorten long paths
shorten_path() {
    local path=$1
    local max_length=50

    if [ ${#path} -gt $max_length ]; then
        echo "...${path: -$max_length}"
    else
        echo "$path"
    fi
}

# Get Claude Code recent prompts
get_claude_prompts() {
    local project_path=$1
    local history_file="$HOME/.claude/history.jsonl"

    # Check if history file exists
    if [ ! -f "$history_file" ]; then
        echo "PROMPTS_NONE"
        return
    fi

    # Extract last 5 prompts for this project
    # Use grep to filter by project, then take last 5, extract display field
    # Reverse order so newest is first (portable: tac on Linux, tail -r on macOS, awk fallback)
    local prompts=$(grep -F "\"project\":\"$project_path\"" "$history_file" 2>/dev/null | \
        tail -5 | \
        if command -v tac >/dev/null 2>&1; then
            tac
        elif tail -r /dev/null >/dev/null 2>&1; then
            tail -r
        else
            awk '{a[i++]=$0} END {for (j=i-1; j>=0;) print a[j--]}'
        fi | \
        while IFS= read -r line; do
            # Extract display field - use jq if available, fallback to sed
            local prompt=""
            if command -v jq >/dev/null 2>&1; then
                prompt=$(echo "$line" | jq -r '.display // empty' 2>/dev/null | sed 's/\\n/ /g')
            fi

            # Fallback to sed if jq failed or not available
            if [ -z "$prompt" ]; then
                # Only extract if line looks like valid JSON with display field
                if echo "$line" | grep -q '"display"'; then
                    prompt=$(echo "$line" | sed 's/.*"display":"\([^"]*\)".*/\1/' | sed 's/\\n/ /g')
                fi
            fi

            # If longer than 40 chars, truncate to 39 and add ...
            if [ -n "$prompt" ] && [ ${#prompt} -gt 40 ]; then
                echo "${prompt:0:39}..."
            elif [ -n "$prompt" ]; then
                echo "$prompt"
            fi
        done)

    if [ -z "$prompts" ]; then
        echo "PROMPTS_NONE"
    else
        echo "PROMPTS_START"
        echo "$prompts"
        echo "PROMPTS_END"
    fi
}

# Main function to get all pane info
get_pane_info() {
    local running_cmd=$(get_running_command "$PANE_PID" "$PANE_TTY")
    local short_path=$(shorten_path "$CURRENT_PATH")

    # Output in a structured format (one line per field)
    echo "PANE_INDEX:$PANE_INDEX"
    echo "DIRECTORY:$short_path"
    echo "COMMAND:$running_cmd"

    # If running Claude Code, get recent prompts (check more accurately)
    local is_claude_code=false

    # Method 1: Check if command is literally "claude"
    if [[ "$running_cmd" == "claude" ]]; then
        is_claude_code=true
    # Method 2: Check if .claude directory exists (Claude Code project marker)
    elif [ -d "${CURRENT_PATH}/.claude" ]; then
        is_claude_code=true
    # Method 3: For node processes, verify it's actually Claude Code by checking full command
    elif [[ "$running_cmd" == "node" ]]; then
        if ps -p "$PANE_PID" -o args= 2>/dev/null | grep -qi "claude"; then
            is_claude_code=true
        fi
    fi

    # Only show prompts if privacy setting allows it (default: off)
    if [ "$is_claude_code" = true ] && [ "${PANE_MEMO_SHOW_PROMPTS:-off}" = "on" ]; then
        get_claude_prompts "$CURRENT_PATH"
    fi
}

# Execute
get_pane_info
