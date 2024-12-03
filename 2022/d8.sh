#!/usr/bin/env bash
# vim: fdl=0

# parse-extra-args() {  # {{{
#   case $1 in
#   *)   return 1;;
#   esac
# } # }}}
p1() { # {{{
  trees=()
  readarray -t trees
  h=${#trees[*]} w=${#trees[0]}
  $dbg echorv h w trees
  vis=$(( w * 2 + ($h-2)*2))
  if $dbg; then
    for ((i=0;i<$h;i++)); do
      echor "${trees[$i]}"
    done
    echor
  fi
  for ((i=1; i<$(($h-1)); i++)); do
    l=${trees[$i]}
    for ((j=1; j<=$((${#l}-2)); j++)); do
      t=${l:$j:1}
      vL=true vR=true vU=true vD=true
      ii=0
      while [[ $ii -lt $w ]]; do
        if [[ $ii != $j ]]; then
          if [[ ${l:$ii:1} -ge $t ]]; then
            $dbg && echor "$t[$i,$j] : c-h by ${l:$ii:1} ($ii)"
            if [[ $ii -lt $j ]]; then
              vL=false; ii=$j
            else
              vR=false; break
            fi
          fi
        fi
        ii=$((ii+1))
      done
      ii=0
      while [[ $ii -lt $h ]]; do
        if [[ $ii != $i ]]; then
          l_ii=${trees[$ii]}
          if [[ ${l_ii:$j:1} -ge $t ]]; then
            $dbg && echor "$t[$i,$j] : r-h by ${l_ii:$j:1} ($j)"
            if [[ $ii -lt $i ]]; then
              vU=false; ii=$i
            else
              vD=false; break
            fi
          fi
        fi
        ii=$((ii+1))
      done
      if ( $vL || $vR || $vU || $vD ); then
        $dbg && echor -C "%cyan:{$t}[$i,$j] %red:VISIBLE"
        vis=$((vis + 1))
      else
        $dbg && echor -C "%cyan:{$t}[$i,$j] %yellow:HIDDEN"
      fi
      $dbg && echor
    done
  done
  ret=$vis
} # }}}
p2() { # {{{
  trees=()
  readarray -t trees
  h=${#trees[*]} w=${#trees[0]}
  $dbg echorv h w trees
  max=0
  if $dbg; then
    for ((i=0;i<$h;i++)); do
      echor "${trees[$i]}"
    done
    echor
  fi
  max_ii=$h
  [[ $w -gt $max_ii ]] && max_ii=$w
  for ((i=1; i<$(($h-1)); i++)); do
    l=${trees[$i]}
    for ((j=1; j<=$((${#l}-2)); j++)); do
      t=${l:$j:1}
      vL=true vR=true vU=true vD=true
      dL=0 dR=0 dU=0 dD=0
      for ((ii=1; ii<$max_ii; ii++)); do
        lU= lD=
        [[ $ii -le $i ]] && lU=${trees[$(($i-$ii))]}
        lD=${trees[$(($i+$ii))]}
        if $vL && [[ $ii -le $j && ${l:$((j - ii)):1} -lt $t ]]; then
          dL=$((dL + 1))
          $dbg && echor -C "$t[$i,$j] : L: %red:VISIBLE ${l:$((j - ii)):1}, $ii, $dL"
        else
          if $vL; then
            [[ $ii -le $j ]] && dL=$((dL + 1))
            $dbg && echor -C "$t[$i,$j] : L: %yellow:HIDDEN $dL"
            [[ $dL == 0 ]] && dL=1
          fi
          vL=false
        fi
        if $vR && [[ $((ii + j)) -lt $w && ${l:$((j + ii)):1} -lt $t ]]; then
          dR=$((dR + 1))
          $dbg && echor -C "$t[$i,$j] : R: %red:VISIBLE ${l:$((j + ii)):1}, $ii, $dR"
        else
          if $vR; then
            [[ $((ii + j)) -lt $w ]] && dR=$((dR + 1))
            $dbg && echor -C "$t[$i,$j] : R: %yellow:HIDDEN $dR"
            [[ $dR == 0 ]] && dR=1
          fi
          vR=false
        fi
        if $vU && [[ ! -z $lU && ${lU:$j:1} -lt $t ]]; then
          dU=$((dU + 1))
          $dbg && echor -C "$t[$i,$j] : U: %red:VISIBLE ${lU:$j:1}, $ii, $dU"
        else
          if $vU; then
            [[ ! -z $lU ]] && dU=$((dU + 1))
            $dbg && echor -C "$t[$i,$j] : U: %yellow:HIDDEN $dU"
            [[ $dU == 0 ]] && dU=1
          fi
          vU=false
        fi
        if $vD && [[ ! -z $lD && ${lD:$j:1} -lt $t ]]; then
          dD=$((dD + 1))
          $dbg && echor -C "$t[$i,$j] : D: %red:VISIBLE ${lD:$j:1}, $ii, $dD"
        else
          if $vD; then
            [[ ! -z $lD ]] && dD=$((dD + 1))
            $dbg && echor -C "$t[$i,$j] : D: %yellow:HIDDEN $dD"
            [[ $dD == 0 ]] && dD=1
          fi
          vD=false
        fi
        ( $vL || $vR || $vU || $vD ) || break
      done
      tRes=$((dL * dR * dU * dD))
      $dbg && echor -C "%cyan:{$t}[$i,$j] : %imp:%s : l:$dL, r:$dR, u:$dU, d:$dD; $max" "$(printf %2d $tRes)" && echor
      [[ $tRes -gt $max ]] && max=$tRes
    done
  done
  ret=$max
} # }}}
source utils.sh
parse-args -e p1 "21 1814" -e p2 "8 330786" "$@"
$cmd < <(cat -)
verify-res

