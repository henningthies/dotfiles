#!/bin/sh
# vim-tmux-navigator equivalent for herdr.
#
# Bound to ctrl+h/j/k/l in config.toml. Herdr intercepts the chord before the
# pane sees it, so this decides what to do with it:
#   - focused pane runs (n)vim -> forward the chord, nvim moves its own window
#     and calls `herdr pane focus` itself when it is already at the edge
#     (see nvim lua/multiplexer.lua)
#   - anything else -> move herdr's pane focus directly
#
# usage: herdr-nav.sh <left|down|up|right> <key>

dir=$1
key=$2
pane=${HERDR_ACTIVE_PANE_ID:-$HERDR_PANE_ID}

[ -n "$pane" ] || exit 0

case $(herdr pane process-info --pane "$pane" 2>/dev/null) in
  *'"name":"nvim"'* | *'"name":"vim"'*)
    exec herdr pane send-keys "$pane" "$key" >/dev/null
    ;;
esac

exec herdr pane focus --pane "$pane" --direction "$dir" >/dev/null
