#!/usr/bin/env bash
# vim: fdl=0

p1() { # {{{
  declare -A choices=([AX]=D [AY]=W [AZ]=L [BX]=L [BY]=D [BZ]=W [CX]=W [CY]=L [CZ]=D)
  while read p1 p2; do
    $dbg && echor "$p1$p2 s:${choices[$p1$p2]} ${scoreShape[$p2]} ${scoreWin[${choices[$p1$p2]}]}"
    score=$((score + ${scoreShape[$p2]} + ${scoreWin[${choices[$p1$p2]}]}))
    $dbg && echorv score
  done
} # }}}
p2() { # {{{
  declare -A choices=([AX]=Z [AY]=X [AZ]=Y [BX]=X [BY]=Y [BZ]=Z [CX]=Y [CY]=Z [CZ]=X)
  declare -A mapWin=([X]=L [Y]=D [Z]=W)
  while read p1 p2; do
    $dbg && echor "$p1$p2 s:${choices[$p1$p2]}: $p1${choices[$p1$p2]} ${scoreShape[${choices[$p1$p2]}]} ${scoreWin[${mapWin[$p2]}]}"
    score=$((score + ${scoreShape[${choices[$p1$p2]}]} + ${scoreWin[${mapWin[$p2]}]}))
    $dbg && echorv score
  done
} # }}}
source utils.sh
score=0
parse-args -e p1 "15 14827" -e p2 "12 13889" --ret score "$@"
declare -A scoreWin=([L]=0 [D]=3 [W]=6)
declare -A scoreShape=([X]=1 [Y]=2 [Z]=3)
$cmd < <(cat -)
verify-res

