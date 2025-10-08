#!/bin/sh
# Utility for Helix: pretty-print blame info for the line under the cursor.
# Quite basic.
# 
# usage: blame_line_pretty <file> <line>
# Helix mapping example:
# b = ":run-shell-command ~/.config/helix/utils/blame_line_pretty.sh %{buffer_name} %{cursor_line}"
file="$1"; line="$2"
out="$(git blame -L "$line",+1 --porcelain -- "$file")" || return 1

sha="$(printf '%s\n' "$out" | awk 'NR==1{print $1}')"
author="$(printf '%s\n' "$out" | awk -F'author ' '/^author /{print $2; exit}')"
author_mail="$(printf '%s\n' "$out" | awk -F'author-mail ' '/^author-mail /{print $2; exit}')"
epoch="$(printf '%s\n' "$out" | awk '/^author-time /{print $2; exit}')"
date="$( (date -d @$epoch +%d-%m-%Y\ %H:%M 2>/dev/null) || (gdate -d "@$epoch" +%d-%m-%Y\ %H:%M 2>/dev/null) || printf '%s' "$epoch")"
summary="$(printf '%s\n' "$out" | awk -F'summary ' '/^summary /{print $2; exit}')"
change="$(printf '%s\n' "$out" | tail -n 1)"

printf "%s\n%s %s\n%s\n%s" "$sha" "$author" "$author_mail" "$date" "$summary"
