#!/usr/bin/env bash
# vim: fdl=0

p1() { # {{{
  ba=$(printf "%d" "'a") bA=$(printf "%d" "'A")
  while read l; do
    lenH=$((${#l} / 2))
    p2=${l:$lenH}
    $dbg && echorv p2 lenH
    for ((i=0; i<$lenH; i++)); do
      c=${l:$i:1}
      [[ $p2 == *$c* ]] && break || c=
    done
    [[ -z $c ]] && continue
    case $c in
    [a-z]) b=$ba a=1;;
    *)     b=$bA a=27;;
    esac
    v=$(($(printf "%d" "'$c") - b + a))
    sum=$((sum + v))
    $dbg && echorv c v sum
  done
} # }}}
p2() { # {{{
  ba=$(printf "%d" "'a") bA=$(printf "%d" "'A") i=0
  while read l; do
    [[ $i == 0 ]] && lines=()
    lines[i]="$l"
    i=$((i + 1))
    [[ $i -lt 3 ]] && continue
    $dbg && echorv lines
    for ((i=0; i<${#l}; i++)); do
      c=${l:$i:1}
      [[ ${lines[0]} == *$c* && ${lines[1]} == *$c* ]] && break || c=
    done
    case $c in
    '')    continue;;
    [a-z]) b=$ba a=1;;
    *)     b=$bA a=27;;
    esac
    v=$(($(printf "%d" "'$c") - b + a))
    sum=$((sum + v))
    $dbg && echorv c v sum
    i=0
  done
} # }}}
source utils.sh
parse-args -e p1 "157 7990" -e p2 "70 2602" --ret sum "$@"
sum=0
$cmd < <(cat -; echo)
verify-res

