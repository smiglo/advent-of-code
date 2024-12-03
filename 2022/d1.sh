#!/usr/bin/env bash
# vim: fdl=0

p1() { # {{{
  max=0
  while read l; do
    [[ ! -z $l ]] && sum=$((sum+l)) && continue
    $dbg && echorv sum max
    [[ $sum -gt $max ]] && max=$sum
    sum=0
  done
  ret=$max
} # }}}
p2() { # {{{
  max=() minI=0
  for i in 0 1 2; do max[i]=0; done
  while read l; do
    [[ ! -z $l ]] && sum=$((sum+l)) && continue
    $dbg && echorv sum max minI
    if [[ $sum -gt ${max[minI]} ]]; then
      max[minI]=$sum
      for i in ${!max[*]}; do [[ ${max[i]} -lt ${max[minI]} ]] && minI=$i; done
    fi
    sum=0
  done
  for i in ${max[*]}; do sum=$((sum+i)); done
  ret=$sum
} # }}}
source utils.sh
parse-args -e p1 "24000 68787" -e p2 "45000 198041" "$@"
sum=0
$cmd < <(cat -; echo; )
verify-res

