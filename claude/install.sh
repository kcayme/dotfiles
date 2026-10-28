#!/bin/bash
# Links this status line into ~/.claude and enables it in settings.json. Safe to re-run.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)"
link="$HOME/.claude/statusline"
settings="$HOME/.claude/settings.json"

command -v jq >/dev/null || { echo "jq is required: brew install jq" >&2; exit 1; }

mkdir -p "$HOME/.claude"
if [ -L "$link" ]; then
    ln -sfn "$src" "$link"
elif [ -e "$link" ]; then
    echo "$link exists and is not a symlink; move it aside and re-run" >&2
    exit 1
else
    ln -s "$src" "$link"
fi

[ -f "$settings" ] || echo '{}' > "$settings"
tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": "~/.claude/statusline/statusline.sh"}' "$settings" > "$tmp"
mv "$tmp" "$settings"

echo "Status line installed: $link -> $src"
