#!/usr/bin/env bash
# waybar clock — same format as the starship prompt: W26 Wed 24 23:08+02
#   W%V    ISO week number        %a  abbreviated weekday
#   %d     day of month           %H:%M  24h time
#   %:::z  UTC offset, minimal     -> "+02" (GNU date; %z gives +0200)
# Emits one line per minute, sleeping to the next minute boundary (no 1s busy-tick).
while true; do
  date +'W%V %a %d %H:%M%:::z'
  # 10# forces base-10: bare "08"/"09" would be read as invalid octal.
  sleep "$((60 - 10#$(date +%S)))"
done
