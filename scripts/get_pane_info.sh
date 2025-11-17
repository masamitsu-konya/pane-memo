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
        # Get all processes running on this TTY, excluding shells
        # Prioritize non-shell processes
        local cmd=$(ps -t "$tty" -o comm= | grep -v -E "^-?(bash|zsh|sh)$" | head -1)

        # If no non-shell process found, get the shell
        if [ -z "$cmd" ]; then
            cmd=$(ps -t "$tty" -o comm= | tail -1)
        fi

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

# Get git branch name if the directory is a git repository
get_git_branch() {
    local dir=$1

    # Check if directory is inside a git repository
    if git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
        # Get current branch name
        local branch=$(git -C "$dir" branch --show-current 2>/dev/null)
        if [ -n "$branch" ]; then
            echo "$branch"
        else
            # If in detached HEAD state, show short commit hash
            local commit=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
            echo "detached@$commit"
        fi
    else
        echo ""
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
    # Reverse order so newest is first (using tail -r on macOS)
    local prompts=$(grep -F "\"project\":\"$project_path\"" "$history_file" 2>/dev/null | \
        tail -5 | \
        tail -r | \
        while IFS= read -r line; do
            # Extract display field using basic string manipulation
            local prompt=$(echo "$line" | sed 's/.*"display":"\([^"]*\)".*/\1/' | sed 's/\\n/ /g')
            # If longer than 40 chars, truncate to 39 and add ...
            if [ ${#prompt} -gt 40 ]; then
                echo "${prompt:0:39}..."
            else
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
    local git_branch=$(get_git_branch "$CURRENT_PATH")

    # Output in a structured format (one line per field)
    echo "PANE_INDEX:$PANE_INDEX"
    echo "DIRECTORY:$short_path"

    # Output git branch if available
    if [ -n "$git_branch" ]; then
        echo "GIT_BRANCH:$git_branch"
    else
        echo "GIT_BRANCH_NONE"
    fi

    echo "COMMAND:$running_cmd"

    # If running Claude Code, get recent prompts
    if [[ "$running_cmd" == "claude" ]] || [[ "$running_cmd" == "node" ]]; then
        get_claude_prompts "$CURRENT_PATH"
    fi
}

# Execute
get_pane_info
