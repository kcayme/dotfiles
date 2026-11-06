#!/bin/bash
# Originally based on https://github.com/daniel3303/ClaudeCodeStatusLine (MIT); now maintained here.
# Single line: Model | tokens | %used | %remain | think | 5h bar @reset | 7d bar @reset | extra

set -f  # disable globbing

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# Colours from the nvim bearded-arc palette, laid out like the nvim lualine config
nvim_palette="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/bearded-arc.nvim/lua/bearded-arc/palette.lua"
# "r;g;b" for a palette key, or <fallback> when the palette or key is missing
nv_rgb() {
    local hex=""
    [ -f "$nvim_palette" ] && hex=$(sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"#\([0-9a-fA-F]\{6\}\)\".*/\1/p" "$nvim_palette" | head -1)
    if [ -n "$hex" ]; then printf '%d;%d;%d' "$((16#${hex:0:2}))" "$((16#${hex:2:2}))" "$((16#${hex:4:2}))"; else printf '%s' "$2"; fi
}
blue="\033[38;2;$(nv_rgb blue 105\;195\;255)m"
orange="\033[38;2;$(nv_rgb orange 255\;149\;92)m"
green="\033[38;2;$(nv_rgb green 60\;236\;133)m"
cyan="\033[38;2;$(nv_rgb cyan 34\;236\;219)m"
red="\033[38;2;$(nv_rgb red 227\;85\;53)m"
yellow="\033[38;2;$(nv_rgb yellow 234\;205\;97)m"
purple="\033[38;2;$(nv_rgb purple 183\;138\;255)m"
white="\033[38;2;$(nv_rgb white 208\;215\;228)m"
black="\033[38;2;$(nv_rgb bg_darker 18\;24\;34)m"   # text on the blue sections
grey="\033[38;2;$(nv_rgb bg_visual 43\;55\;75)m"   # empty part of the bars: a faint track
bg_a="\033[48;2;$(nv_rgb blue 105\;195\;255)m"   # lualine a: blue
shade_b=$(nv_rgb statusline_bg 33\;42\;58)
bg_b="\033[48;2;${shade_b}m"   # lualine b: statusline_bg; needs CLAUDE_CODE_TMUX_TRUECOLOR in tmux
bg_c='\033[49m'                  # section c and the middle fill use the terminal's own background
fg_a="$blue"                     # section bg colours as fg, for the rounded caps
fg_b="\033[38;2;${shade_b}m"
cap_r=$'\xee\x82\xb4'            # U+E0B4, ends a left section
cap_l=$'\xee\x82\xb6'            # U+E0B6, starts a right section
branch_icon=$'\xee\xa9\xa8'      # U+EA68, same icon as lualine's branch
model_icon=$'\xf3\xb0\x9a\xa9'   # U+F06A9 nf-md-robot
effort_icon=$'\xf3\xb0\x93\x85'  # U+F04C5 nf-md-speedometer
session_icon=$'\xf3\xb0\xad\xb9'   # U+F0B79 nf-md-chat
ctx_icon=$'\xf3\xb0\xa7\x91'     # U+F09D1 nf-md-brain
usage_icon=$'\xf3\xb0\x8a\x9a'   # U+F029A nf-md-gauge
bold='\033[1m'
dim='\033[2m'
fgreset='\033[22;39m'            # reset fg/bold/dim but keep the section background
reset='\033[0m'

# Format token counts (e.g., 50k / 200k)
format_tokens() {
    local num=$1
    if [ "$num" -ge 1000000 ]; then
        awk "BEGIN {v=sprintf(\"%.1f\",$num/1000000)+0; if(v==int(v)) printf \"%dm\",v; else printf \"%.1fm\",v}"
    elif [ "$num" -ge 1000 ]; then
        awk "BEGIN {printf \"%.0fk\", $num / 1000}"
    else
        printf "%d" "$num"
    fi
}

# Format number with commas (e.g., 134,938)
format_commas() {
    printf "%'d" "$1"
}

# Return color escape based on usage percentage
# Usage: usage_color <pct>
usage_color() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then echo "$red"
    elif [ "$pct" -ge 70 ]; then echo "$orange"
    elif [ "$pct" -ge 50 ]; then echo "$yellow"
    else echo "$green"
    fi
}

# Bar coloured by usage; width in blocks, default 5
bar() {
    local pct=$1 width=${2:-8}
    local filled=$(( (pct * width + 99) / 100 ))
    [ "$filled" -gt "$width" ] && filled=$width
    local color full empty
    color=$(usage_color "$pct")
    full=$(printf '%*s' "$filled" '' | sed 's/ /━/g')
    empty=$(printf '%*s' $(( width - filled )) '' | sed 's/ /━/g')
    printf '%s' "${color}${full}${fgreset}${grey}${empty}${fgreset}"
}

usage_bar() {
    local pct=$1
    [ -z "$pct" ] && { printf '%s' "${dim}-${fgreset}"; return; }
    printf '%s' "$(bar "$pct") $(usage_color "$pct")${pct}%${fgreset}"
}

# Resolve config directory: CLAUDE_CONFIG_DIR (set by alias) or default ~/.claude
claude_config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

# ===== Extract data from JSON =====
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
model_name=$(echo "$model_name" | sed 's/ *(\([0-9.]*[kKmM]*\) context)/ \1/')  # "(1M context)" → "1M"

# Context window
size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
[ "$size" -eq 0 ] 2>/dev/null && size=200000

# Token usage
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
current=$(( input_tokens + cache_create + cache_read ))

used_tokens=$(format_tokens $current)
total_tokens=$(format_tokens $size)

if [ "$size" -gt 0 ]; then
    pct_used=$(( current * 100 / size ))
else
    pct_used=0
fi
pct_remain=$(( 100 - pct_used ))

used_comma=$(format_commas $current)
remain_comma=$(format_commas $(( size - current )))

settings_path="$claude_config_dir/settings.json"
effort_level=""
stdin_effort=$(echo "$input" | jq -r '.effort.level // empty' 2>/dev/null)
if [ -n "$stdin_effort" ]; then
    effort_level="$stdin_effort"
elif [ -n "$CLAUDE_CODE_EFFORT_LEVEL" ]; then
    effort_level="$CLAUDE_CODE_EFFORT_LEVEL"
elif [ -f "$settings_path" ]; then
    effort_val=$(jq -r '.effortLevel // empty' "$settings_path" 2>/dev/null)
    [ -n "$effort_val" ] && effort_level="$effort_val"
fi
[ -z "$effort_level" ] && effort_level="medium"

# ===== Claude CLI version (cached, 1h TTL) =====
cli_version_cache="/tmp/claude/statusline-cli-version"
cli_version=""
cli_version_max_age=3600

if [ -f "$cli_version_cache" ]; then
    cv_mtime=$(stat -c %Y "$cli_version_cache" 2>/dev/null || stat -f %m "$cli_version_cache" 2>/dev/null)
    cv_now=$(date +%s)
    cv_age=$(( cv_now - cv_mtime ))
    if [ "$cv_age" -lt "$cli_version_max_age" ]; then
        cli_version=$(cat "$cli_version_cache" 2>/dev/null)
    fi
fi

if [ -z "$cli_version" ]; then
    cli_version=$(claude --version 2>/dev/null | awk '{print $1}')
    if [ -n "$cli_version" ]; then
        mkdir -p /tmp/claude 2>/dev/null
        echo "$cli_version" > "$cli_version_cache"
    fi
fi

# ===== Build single-line output =====
# Left sections a → b → c, each closed by a rounded cap in its own colour
left=""
prev_fg=""
add_left() {  # <bg> <bg as fg> <content>
    [ -n "$prev_fg" ] && left+="${1}${prev_fg}${cap_r}"
    left+="${1}${3}"
    prev_fg=$2
}

# Session name: the peer name from the session registry (e.g. carcloud-platform-c4), else the /rename name
session_id=$(echo "$input" | jq -r '.session_id // empty')
session_name=""
[ -n "$session_id" ] && session_name=$(find "$HOME/.claude/sessions" -maxdepth 1 -name '*.json' -exec jq -r --arg id "$session_id" 'select(.sessionId == $id) | .name // empty' {} + 2>/dev/null | head -1)
[ -z "$session_name" ] && session_name=$(echo "$input" | jq -r '.session_name // empty')
[ "${#session_name}" -gt 20 ] && session_name="${session_name:0:19}…"

# Current working directory
cwd=$(echo "$input" | jq -r '.cwd // empty')
if [ -n "$cwd" ]; then
    display_dir="${cwd##*/}"
    git_branch=$(git -C "${cwd}" rev-parse --abbrev-ref HEAD 2>/dev/null)
    add_left "$bg_a" "$fg_a" "${black}${bold} ${display_dir} ${fgreset}"
    if [ -n "$git_branch" ]; then
        seg_b="${white} ${branch_icon} ${git_branch}${fgreset}"
        git_stat=$(git -C "${cwd}" diff --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {if (a+d>0) printf "+%d -%d", a, d}')
        [ -n "$git_stat" ] && seg_b+=" ${green}${git_stat%% *}${fgreset} ${red}${git_stat##* }${fgreset}"
        # Linked worktrees have a git-dir separate from the shared common dir
        git_dirs=$(git -C "${cwd}" rev-parse --path-format=absolute --git-dir --git-common-dir 2>/dev/null)
        if [ "$(echo "$git_dirs" | sed -n 1p)" != "$(echo "$git_dirs" | sed -n 2p)" ]; then
            wt_root=$(git -C "${cwd}" rev-parse --show-toplevel 2>/dev/null)
            wt_name="${wt_root##*/}"
            [ "${#wt_name}" -gt 20 ] && wt_name="${wt_name:0:19}…"
            seg_b+=" ${white}wt: ${purple}${wt_name}${fgreset}"
        fi
        add_left "$bg_b" "$fg_b" "${seg_b} "
    fi
fi

add_left "$bg_c" "" "${white} ${ctx_icon} $(bar "$pct_used" 15) ${orange}${used_tokens}/${total_tokens}${fgreset} "

# Right section x (on the c background): model, effort, session name
right="${bg_c}${blue}${bold}${model_icon} ${model_name}${fgreset}  ${white}${effort_icon} "
case "$effort_level" in
    low)    right+="${dim}${effort_level}${fgreset}" ;;
    medium) right+="${orange}med${fgreset}" ;;
    high)   right+="${green}${effort_level}${fgreset}" ;;
    xhigh)  right+="${purple}${effort_level}${fgreset}" ;;
    max)    right+="${red}${effort_level}${fgreset}" ;;
    *)      right+="${green}${effort_level}${fgreset}" ;;
esac
[ -n "$session_name" ] && right+="  ${purple}${session_icon} ${session_name}${fgreset}"
right+=" "

# ===== Cross-platform OAuth token resolution (from statusline.sh) =====
# Tries credential sources in order: env var → macOS Keychain → Linux creds file → GNOME Keyring
get_oauth_token() {
    local token=""

    # 1. Explicit env var override
    if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
        echo "$CLAUDE_CODE_OAUTH_TOKEN"
        return 0
    fi

    # 2. macOS Keychain (Claude Code appends a SHA256 hash of CLAUDE_CONFIG_DIR to the service name)
    if command -v security >/dev/null 2>&1; then
        local keychain_svc="Claude Code-credentials"
        if [ -n "$CLAUDE_CONFIG_DIR" ]; then
            local dir_hash
            dir_hash=$(echo -n "$CLAUDE_CONFIG_DIR" | shasum -a 256 | cut -c1-8)
            keychain_svc="Claude Code-credentials-${dir_hash}"
        fi
        local blob
        blob=$(security find-generic-password -s "$keychain_svc" -w 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    # 3. Linux credentials file
    local creds_file="${claude_config_dir}/.credentials.json"
    if [ -f "$creds_file" ]; then
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        if [ -n "$token" ] && [ "$token" != "null" ]; then
            echo "$token"
            return 0
        fi
    fi

    # 4. GNOME Keyring via secret-tool
    if command -v secret-tool >/dev/null 2>&1; then
        local blob
        blob=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            if [ -n "$token" ] && [ "$token" != "null" ]; then
                echo "$token"
                return 0
            fi
        fi
    fi

    echo ""
}

# ===== LINE 2 & 3: Usage limits with progress bars =====
# First, try to use rate_limits data provided directly by Claude Code in the JSON input.
# This is the most reliable source — no OAuth token or API call required.
builtin_five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
builtin_five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
builtin_seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
builtin_seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

use_builtin=false
if [ -n "$builtin_five_hour_pct" ] || [ -n "$builtin_seven_day_pct" ]; then
    use_builtin=true
fi

# Cache setup — shared across all Claude Code instances to avoid rate limits
claude_config_dir_hash=$(echo -n "$claude_config_dir" | shasum -a 256 2>/dev/null || echo -n "$claude_config_dir" | sha256sum 2>/dev/null)
claude_config_dir_hash=$(echo "$claude_config_dir_hash" | cut -c1-8)
cache_file="/tmp/claude/statusline-usage-cache-${claude_config_dir_hash}.json"
cache_max_age=60  # seconds between API calls
mkdir -p /tmp/claude

needs_refresh=true
usage_data=""

# Always load cache — used as primary source for API path, and as fallback when builtin reports zero
if [ -f "$cache_file" ] && [ -s "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    if [ "$cache_age" -lt "$cache_max_age" ]; then
        needs_refresh=false
    fi
    usage_data=$(cat "$cache_file" 2>/dev/null)
fi

# When builtin values are all zero AND reset timestamps are missing, it likely indicates
# an API failure on Claude's side — fall through to cached data instead of displaying
# misleading 0%. Genuine zero responses (after a billing reset) still include valid
# resets_at timestamps, so we trust those.
effective_builtin=false
if $use_builtin; then
    # Trust builtin if any percentage is non-zero
    if { [ -n "$builtin_five_hour_pct" ] && [ "$(printf '%.0f' "$builtin_five_hour_pct" 2>/dev/null)" != "0" ]; } || \
       { [ -n "$builtin_seven_day_pct" ] && [ "$(printf '%.0f' "$builtin_seven_day_pct" 2>/dev/null)" != "0" ]; }; then
        effective_builtin=true
    fi
    # Also trust if reset timestamps are present — genuine zero responses include valid reset times
    if ! $effective_builtin; then
        if { [ -n "$builtin_five_hour_reset" ] && [ "$builtin_five_hour_reset" != "null" ] && [ "$builtin_five_hour_reset" != "0" ]; } || \
           { [ -n "$builtin_seven_day_reset" ] && [ "$builtin_seven_day_reset" != "null" ] && [ "$builtin_seven_day_reset" != "0" ]; }; then
            effective_builtin=true
        fi
    fi
fi

# Refresh API cache when stale — runs regardless of builtin rate_limits because
# extra_usage is only exposed through the OAuth usage endpoint (not stdin JSON).
# Throttled to cache_max_age and stampede-locked via touch for shared panes.
if $needs_refresh; then
    touch "$cache_file"  # stampede lock: prevent parallel panes from fetching simultaneously
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 10 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            -H "User-Agent: claude-code/2.1.34" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        # Only cache valid usage responses (not error/rate-limit JSON)
        if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    # Remove the stampede sentinel if the fetch failed to produce valid JSON —
    # otherwise an empty cache file would suppress retries for a full cache_max_age window.
    [ -f "$cache_file" ] && [ ! -s "$cache_file" ] && rm -f "$cache_file"
fi

# Cross-platform ISO to epoch conversion
# Converts ISO 8601 timestamp (e.g. "2025-06-15T12:30:00Z" or "2025-06-15T12:30:00.123+00:00") to epoch seconds.
# Properly handles UTC timestamps and converts to local time.
iso_to_epoch() {
    local iso_str="$1"

    # Try GNU date first (Linux) — handles ISO 8601 format automatically
    local epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    # BSD date (macOS) - handle various ISO 8601 formats
    local stripped="${iso_str%%.*}"          # Remove fractional seconds (.123456)
    stripped="${stripped%%Z}"                 # Remove trailing Z
    stripped="${stripped%%+*}"               # Remove timezone offset (+00:00)
    stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"  # Remove negative timezone offset

    # Check if timestamp is UTC (has Z or +00:00 or -00:00)
    if [[ "$iso_str" == *"Z"* ]] || [[ "$iso_str" == *"+00:00"* ]] || [[ "$iso_str" == *"-00:00"* ]]; then
        # For UTC timestamps, parse with timezone set to UTC
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    fi

    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    return 1
}

# Format ISO reset time to compact local time
# Usage: format_reset_time <iso_string> <style: time|datetime|date>
format_reset_time() {
    local iso_str="$1"
    local style="$2"
    { [ -z "$iso_str" ] || [ "$iso_str" = "null" ]; } && return

    # Parse ISO datetime and convert to local time (cross-platform)
    local epoch
    epoch=$(iso_to_epoch "$iso_str")
    [ -z "$epoch" ] && return

    # Format based on style
    # Try GNU date first (Linux), then BSD date (macOS)
    # Previous implementation piped BSD date through sed/tr, which always returned
    # exit code 0 from the last pipe stage, preventing the GNU date fallback from
    # ever executing on Linux.
    local formatted=""
    case "$style" in
        time)
            formatted=$(date -d "@$epoch" +"%H:%M" 2>/dev/null) || \
            formatted=$(date -j -r "$epoch" +"%H:%M" 2>/dev/null)
            ;;
        datetime)
            formatted=$(date -d "@$epoch" +"%a %b %-d, %H:%M" 2>/dev/null) || \
            formatted=$(date -j -r "$epoch" +"%a %b %-d, %H:%M" 2>/dev/null)
            ;;
        *)
            formatted=$(date -d "@$epoch" +"%b %-d" 2>/dev/null) || \
            formatted=$(date -j -r "$epoch" +"%b %-d" 2>/dev/null)
            ;;
    esac
    [ -n "$formatted" ] && echo "$formatted"
}

sep=" ${dim}|${reset} "

if $effective_builtin; then
    # ---- Use rate_limits data provided directly by Claude Code in JSON input ----
    # resets_at values are Unix epoch integers in this source
    if [ -n "$builtin_five_hour_pct" ]; then
        five_hour_pct=$(printf "%.0f" "$builtin_five_hour_pct")
        if [ -n "$builtin_five_hour_reset" ] && [ "$builtin_five_hour_reset" != "null" ]; then
            five_hour_reset=$(date -j -r "$builtin_five_hour_reset" +"%H:%M" 2>/dev/null || date -d "@$builtin_five_hour_reset" +"%H:%M" 2>/dev/null)
        fi
    fi

    if [ -n "$builtin_seven_day_pct" ]; then
        seven_day_pct=$(printf "%.0f" "$builtin_seven_day_pct")
    fi

    # Cache builtin values so they're available as fallback when API is unavailable.
    # Convert epoch resets_at to ISO 8601 for compatibility with the API-format cache parser.
    # Preserve extra_usage from prior API response so we don't clobber it.
    _fh_reset_json="null"
    if [ -n "$builtin_five_hour_reset" ] && [ "$builtin_five_hour_reset" != "null" ] && [ "$builtin_five_hour_reset" != "0" ]; then
        _fh_iso=$(date -u -r "$builtin_five_hour_reset" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || \
                  date -u -d "@$builtin_five_hour_reset" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null)
        [ -n "$_fh_iso" ] && _fh_reset_json="\"$_fh_iso\""
    fi
    _sd_reset_json="null"
    if [ -n "$builtin_seven_day_reset" ] && [ "$builtin_seven_day_reset" != "null" ] && [ "$builtin_seven_day_reset" != "0" ]; then
        _sd_iso=$(date -u -r "$builtin_seven_day_reset" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || \
                  date -u -d "@$builtin_seven_day_reset" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null)
        [ -n "$_sd_iso" ] && _sd_reset_json="\"$_sd_iso\""
    fi
    _extra_json=$(echo "$usage_data" | jq -c '.extra_usage // null' 2>/dev/null)
    [ -z "$_extra_json" ] && _extra_json="null"
    printf '{"five_hour":{"utilization":%s,"resets_at":%s},"seven_day":{"utilization":%s,"resets_at":%s},"extra_usage":%s}' \
        "${builtin_five_hour_pct:-0}" "$_fh_reset_json" \
        "${builtin_seven_day_pct:-0}" "$_sd_reset_json" \
        "$_extra_json" > "$cache_file" 2>/dev/null
elif [ -n "$usage_data" ] && echo "$usage_data" | jq -e '.five_hour' >/dev/null 2>&1; then
    # ---- Fall back: API-fetched usage data ----
    # ---- 5-hour (current) ----
    five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    five_hour_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
    five_hour_reset=$(format_reset_time "$five_hour_reset_iso" "time")

    # ---- 7-day (weekly) ----
    seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
fi

# Right section y: 5-cell bars plus percentage; "-" when the window has no data
right+="${bg_c}${fg_b}${cap_l}${bg_b}${white} ${usage_icon} 5h $(usage_bar "$five_hour_pct")  ${white}7d $(usage_bar "$seven_day_pct") "

# Right section z: CLI version
[ -n "$cli_version" ] && right+="${bg_b}${fg_a}${cap_l}${bg_a}${black}${bold} ${cli_version} "
right+="${reset}"

# Output
# Fill between the halves with the c background, like lualine's middle; reserve covers Claude Code's own margins
strip() { printf '%b' "$1" | sed $'s/\x1b\[[0-9;]*m//g'; }
visible_len=$(printf '%s%s' "$(strip "$left")" "$(strip "$right")" | LC_ALL=en_US.UTF-8 wc -m | tr -d ' ')
pad=$(( ${COLUMNS:-0} - 4 - visible_len ))
[ "$pad" -lt 1 ] && pad=1
gap="${bg_c}$(printf '%*s' "$pad" '')"
printf "%b" "$left$gap$right"

exit 0
