#!/usr/bin/env bash
# vim: fdl=0

parse-extra-args() {  # {{{
  case $1 in
  -d2) dbg=true; dbg2=true;;
  *)   return 1;;
  esac
} # }}}
p1() { # {{{
  inP2=false d="" s=0 sep=
  [[ $1 == p2 ]] && inP2=true
  declare -A dd
  while read l; do # {{{
    [[ -z $l ]] && continue
    case $l in
    '$ cd ..') # {{{
      $dbg && echor "${sep}changing UP ($d)+=$s : '$l'"
      sep=${sep% }
      dd[$d]=$s
      d=${d%/*/}/; [[ -z $d ]] && d="/"
      dd[$d]=$(( ${dd[$d]} + s ))
      s=${dd[$d]};; # }}}
    '$ cd '*) # {{{
      $dbg && echor "${sep}changing DOWN ($d):$s : '$l'"
      sep+=" "
      [[ ! -z $d ]] && dd[$d]=$s
      d+="${l##* }/" s=0
      [[ $d == '//' ]] && d='/';; # }}}
    [0-9]*) # {{{
      t=$((s + ${l%% *}))
      $dbg && echor "${sep}summing($d): $s += ${l%% *} = $t : '$l'"
      s=$t;; # }}}
    esac
  done # }}}
  if [[ $s != 0 ]]; then # {{{
    while [[ ! -z $d ]]; do
      $dbg && echor "${sep}adding to($d): ${dd[$d]:-0} + $s = $((${dd[$d]:-0} + s))"
      dd[$d]=$(( ${dd[$d]} + s ))
      s=${dd[$d]}
      [[ $d == '/' ]] && break
      d=${d%/*/}/
      sep=${sep% }
    done
  fi # }}}
  if $dbg2; then # {{{
    echor
    for i in ${!dd[*]}; do
      printf "%-20s : %s\n" $i ${dd[$i]}
    done | sort | while read l; do echor "$l"; done
    echor
  fi # }}}
  if ! $inP2; then # {{{
    max=100000 ret=0
    # }}}
  else # {{{
    mSpace=70000000 rSpace=30000000
    left=$((mSpace - ${dd['/']}))
    req=$((rSpace - left))
    if $dbg; then
      echor "root:${dd['/']}"
      echorv mSpace rSpace left
    fi
  fi # }}}
  while read l; do # {{{
    $dbg2 && echorv l
    if ! $inP2; then # {{{
      [[ $l -gt $max ]] && break
      ret=$((ret + l)) # }}}
    else # {{{
      if [[ $left -lt $rSpace ]]; then
        $dbg && echorv req
        [[ $l -gt $req ]] && ret=$l && break
      else
        echor ok
        break
      fi
    fi # }}}
  done < <(printf "%s\n" ${dd[*]} | sort -n) # }}}
  # }}}
} # }}}
p2() { # {{{
  p1 p2
} # }}}
dbg2=false
source utils.sh
parse-args -e p1 "95437 1517599" -e p2 "24933642 2481982" "$@"
$cmd < <(cat -; echo)
verify-res

