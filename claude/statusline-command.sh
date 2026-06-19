#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '$%.4f' "$COST")

RATE_5H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | awk '{printf "%.0f", $1}')
RATE_7D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | awk '{printf "%.0f", $1}')
RESET_5H=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
RESET_7D=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')

# Unix timestamp → 사람이 읽기 쉬운 시간 (로컬 시간대)
fmt_reset() {
  local ts=$1
  if [ "$ts" -eq 0 ]; then echo "?"; return; fi
  local now=$(date +%s)
  local diff=$((ts - now))
  if [ "$diff" -le 0 ]; then
    echo "곧"
  elif [ "$diff" -lt 3600 ]; then
    echo "$((diff / 60))분후"
  elif [ "$diff" -lt 86400 ]; then
    echo "$(date -d @"$ts" +"%H:%M")까지"
  else
    echo "$(date -d @"$ts" +"%-m/%-d %H:%M")까지"
  fi
}

T5H=$(fmt_reset "$RESET_5H")
T7D=$(fmt_reset "$RESET_7D")

RESET='\033[0m'
RED='\033[31m'; YELLOW='\033[33m'; GREEN='\033[32m'; CYAN='\033[36m'; BOLD='\033[1m'; DIM='\033[2m'

color_for_pct() {
  local p=$1
  if [ "$p" -ge 90 ]; then printf "$RED"
  elif [ "$p" -ge 70 ]; then printf "$YELLOW"
  else printf "$GREEN"
  fi
}

R5H_C=$(color_for_pct "$RATE_5H")
R7D_C=$(color_for_pct "$RATE_7D")
CTX_C=$(color_for_pct "$PCT")

printf "${BOLD}${CYAN}[%s]${RESET}" "$MODEL"
printf " 세션:${R5H_C}%s%%${RESET}${DIM}(%s)${RESET}" "$RATE_5H" "$T5H"
printf " | 주간:${R7D_C}%s%%${RESET}${DIM}(%s)${RESET}" "$RATE_7D" "$T7D"
printf " | ctx:${CTX_C}%s%%${RESET}" "$PCT"
printf " | ${YELLOW}%s${RESET}\n" "$COST_FMT"
