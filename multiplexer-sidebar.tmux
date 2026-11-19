#!/bin/sh
# The entry point for tmux plugin managers such as tpm, which run every
# *.tmux file at the top of a plugin's directory when tmux loads its
# configuration. It binds keys that run the dashboard from this directory.
#
# Each key is a tmux option. An option that is not set gets the default
# below, and an option set to the empty string binds no key:
#
#   @multiplexer-sidebar-key          prefix key for the dashboard, Tab
#   @multiplexer-sidebar-sidebar-key  prefix key for the sidebar, b
#   @multiplexer-sidebar-compact-key  prefix key for the compact sidebar, none

dir=$(cd "$(dirname "$0")" && pwd)
# Single quotes keep a directory with spaces in one word when tmux passes
# the command to the shell.
script="'$dir/multiplexer-dashboard'"

# Prints the value of a tmux option, or $2 when the option is not set.
option() {
    if [ -n "$(tmux show-options -gq "$1")" ]; then
        tmux show-options -gqv "$1"
    else
        printf '%s\n' "$2"
    fi
}

key=$(option @multiplexer-sidebar-key Tab)
sidebar_key=$(option @multiplexer-sidebar-sidebar-key b)
compact_key=$(option @multiplexer-sidebar-compact-key '')

# tmux 3.8 added floating panes. Older versions get a popup, which has no
# pane of its own, so the dashboard is told which client to switch.
# display-popup does not expand formats in its command, so run-shell -C
# expands the whole command first.
if [ -n "$key" ]; then
    if tmux list-commands new-pane >/dev/null 2>&1; then
        tmux bind-key "$key" new-pane -O -x80% -y80% -X10% -Y10% \
            -c '#{pane_current_path}' "$script"
    else
        tmux bind-key "$key" run-shell -C "display-popup -E -w80% -h80% \
            -d '#{pane_current_path}' \"$script --client '#{client_name}'\""
    fi
fi

# The sidebar notices when its pane gains focus through focus events.
if [ -n "$sidebar_key" ] || [ -n "$compact_key" ]; then
    tmux set-option -g focus-events on
fi
if [ -n "$sidebar_key" ]; then
    tmux bind-key "$sidebar_key" run-shell "$script --tmux-toggle-sidebar '#{pane_id}' '#{socket_path}'"
fi
if [ -n "$compact_key" ]; then
    tmux bind-key "$compact_key" run-shell "$script --tmux-toggle-sidebar '#{pane_id}' '#{socket_path}' --compact"
fi
