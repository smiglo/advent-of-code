#!/usr/bin/env bash
# vim: fdl=0

p1() { # {{{
  while read -a r; do
    $dbg && echor "in      : $(echorv --1 r)"
    if [[ ${r[0]} -gt ${r[2]} ]]; then
      r=( ${r[2]} ${r[3]} ${r[0]} ${r[1]})
      $dbg && echor -C "%imp:swap    : $(echorv --1 r)"
    fi
    if [[ ${r[1]} -ge ${r[3]} || ( ${r[0]} == ${r[2]} && ${r[3]} -ge ${r[1]} ) ]]; then
      cnt=$((cnt + 1))
      $dbg && echor -C "%green:overlap : $(echorv --1 r)"
    fi
  done
} # }}}
p2() { # {{{
  while read -a r; do
    $dbg && echor "in      : $(echorv --1 r)"
    if [[ ${r[0]} -gt ${r[2]} ]]; then
      r=( ${r[2]} ${r[3]} ${r[0]} ${r[1]})
      $dbg && echor -C "%imp:swap    : $(echorv --1 r)"
    fi
    if [[ ${r[1]} -ge ${r[2]} ]]; then
      cnt=$((cnt + 1))
      $dbg && echor -C "%green:overlap : $(echorv --1 r)"
    fi
  done
} # }}}
source utils.sh
cnt=0
parse-args -e p1 "2 459" -e p2 "4 779" --ret "cnt" "$@"
$cmd < <(cat - | tr '[,\-]' ' '; echo)
verify-res

