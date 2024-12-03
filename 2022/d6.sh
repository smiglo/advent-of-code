#!/usr/bin/env bash
# vim: fdl=0

# parse-extra-args() {  # {{{
#   case $1 in
#   *)   return 1;;
#   esac
# } # }}}
p1() { # {{{
  max=4
  [[ ! -z $1 ]] && max=$1
  c=
  while read l; do
    [[ -z $l ]] && continue
    $dbg && echorv l
    c=
    for ((n=0; n<${#l}; n++)); do
      cc=${l:$n:1}
      $dbg && echor "up-to:[${l:0:$n}] c[$c] cc[$cc]"
      if [[ $c == *$cc* ]]; then
        i=1 c=${c##*$cc}$cc
        $dbg && echorv "c"
        continue
      fi
      c+=$cc
      [[ ${#c} == $max ]] && break
    done
    $dbg && echorv n
    $dbg && echor
    ret+="-$((n+1))"
  done
  ret=${ret#-}
} # }}}
p2() { # {{{
  p1 14
} # }}}
source utils.sh
parse-args -e p1 "7-5-6-10-11 1623" -e p2 "19-23-23-29-26 3774" "$@"
$cmd < <(cat -; echo)
verify-res

