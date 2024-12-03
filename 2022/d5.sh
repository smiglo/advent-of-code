#!/usr/bin/env bash
# vim: fdl=0

parse-extra-args() { # {{{
  case $1 in
  -d2) dbg=true; dbg2=true;;
  *)   return 1;;
  esac
} # }}}
p1() {  # {{{
  local stack=() len=9 reverse=true dbgAlign=7
  [[ $mode == 'full' ]] && dbgAlign=40
  [[ $1 == --all ]] && reverse=false
  while IFS=$ read l; do # {{{
    [[ $l =~ ^\ *[0-9] ]] && break
    $dbg2 && echor && echor "    1   2   3   4   5   6   7   8   9" && echorv l
    for ((j=0; j<len; j++)); do
      idx=$((1+j*4))
      c=${l:$idx:1}
      if [[ ! -z $c && $c != ' ' ]]; then
        stack[$((j+1))]+="$c"
        $dbg2 && echor "stack-$((j+1)) +: $c"
      fi
    done
  done # }}}
  $dbg && echor && for i in ${!stack[*]}; do echor "$i: $(printf "%${dbgAlign}s" ${stack[i]})"; done && echor
  $dbg && declare -A colors=([src]='cyan' [dst]='imp' [oth]='gray')
  while read tmp cnt tmp src tmp dst; do # {{{
    [[ -z $cnt ]] && continue
    s=${stack[src]}
    p=${s:0:$cnt}
    $dbg && echorv cnt src dst s p
    stack[src]="${s#$p}"
    if $reverse; then
      pt=
      for ((j=0; j<${#p}; j++)); do pt="${p:$j:1}$pt"; done
      p=$pt
    fi
    stack[dst]="$p${stack[dst]}"
    if $dbg; then # {{{
      for i in ${!stack[*]}; do
        c="oth" ii=$i s=${stack[i]}
        [[ $dbgAlign -ge ${#s} ]] && len=$((dbgAlign-${#s}))
        if [[ $i == $src ]]; then
          c=src ii=S s="$(cl src "$s")"
        elif [[ $i == $dst ]]; then
          c=dst ii=D s="$(cl dst "$p" oth "${s#$p}")"
        else
          s="$(cl oth "$s")"
        fi
        echor -C "%$c:{$ii}: $(printf "%${len}s" " ") $s"
      done
    fi # }}}
  done
  for i in ${stack[*]}; do top+="${i:0:1}"; done
} # }}}
p2() { # {{{
  p1 --all
} # }}}
source utils.sh
top= dbg2=false
parse-args -e p1 "CMZ CWMTGHBDW" -e p2 "MCD SSCGWJCRB" --ret "top" "$@"
$cmd < <(cat -)
verify-res

