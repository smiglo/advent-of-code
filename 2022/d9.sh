#!/usr/bin/env bash
# vim: fdl=0

parse-extra-args() {  # {{{
  case $1 in
  -i=*)  iters=${1#-i=};;
  *)     return 1;;
  esac
} # }}}
new-col() {
  echor "n-r at $y"
  line=$(printf "%${s}s" " ")
  map[$y]="$line"
}
new-row() { # {{{
  local x=$1 i= toAdd= a=' '
  if [[ $x -lt 1 ]]; then
    toAdd="$(printf "%$((-x))%s" " ")"
  elif [[ $x -gt $((${#map[0]} + 1)) ]]; then
    toAdd="$(printf "%$((${#map[0]} - x))%s" " ")"
  fi
  echor "n-r at $x [$a]"
  for i in ${!map[*]}; do
    if [[ $x -lt 0 ]]; then
      map[$i]="$a${map[$i]}"
    else
      map[$i]="${map[$i]}$a"
    fi
  done
  [[ $x -lt 0 ]] && x=0
} # }}}
show-map() { # {{{
  local i=
  if $dbg; then
    for ((i=0; i<s; i++)); do
      echor "|${map[$i]}|"
    done
  fi
} # }}}
visit() {
  local c=${1:-1} l="${map[$y]}" m="#"
  local px=$x
  if [[ $c -lt 1 ]]; then
    c=$((-c))
    px=$((x-c+1))
  fi
  [[ $c == 1 ]] || m="$(printf "%${c}s" ' ')"
  # echor "visit $x:$px $y $c [$m]"
  # [[ -z ${map[$y]} ]] && new-col
  # [[ ${#map[$y]} -lt $((x + c)) ]] && new-row $((x + c - ${#map[$y]}))
  local nl="${l:0:$((px-1))}"
  nl+="${m// /\#}"
  # [[ $px == 0 ]] && i=0
  nl+="${l:$((px+c-1))}"
  map[$y]="$nl"
}
draw-line() {
  local distX= distY=
  case $ld-$d in
  [RL]-[UD] | [UD]-[RL])
    distX=$((xH - x)) distY=$((yH - y))
    [[ $distX -lt 0 ]] && distX=$((-distX))
    [[ $distY -lt 0 ]] && distY=$((-distY))
    visit
    if [[ $distX == 1 && $distY == 1 ]]; then
      x=$xH y=$yH
      visit
      return
    fi
  *)
    distX=$((xH - x)) distY=$((yH - y))
    if [[ $distY == 0 ]]; then
      if [[ $distX == 0 ]]; then
        visit
      else
        visit $distX
      fi
    fi
    ;;
  esac
}
p1() { # {{{
  s=10
  line=$(printf "%${s}s" " ")
  declare -A map
  for ((i=0; i<s; i++)); do
    map[$i]="$line"
  done
  x=$((1)) y=$((s-1)) dl= iter=0
  visit
  show-map
  while read d c; do
    echorv d c
    case $d in
    R) xH=$((x + c));;
    L) xH=$((x - c));;
    U) yH=$((y - c));;
    D) yH=$((y + c));;
    esac
    echorv x y xH yH
    draw-line

      y=$((y-1))
      case $dl in
      R) x=$((x+1));;
      L) x=$((x-1));;
      esac
      visit 1 && c=$((c-1)) && y=$((y-1))
      for ((; c>0; c--, y--)); do
        visit
      done
      y=$((y+1))
      ;;
    L)
      x=$((x-1))
      case $dl in
      U) y=$((y-1));;
      D) y=$((y+1));;
      esac
      echorv x y
      visit && c=$((c-1)) && x=$((x-1))
      show-map
      echorv x y
      visit -$c
      x=$((x-1))
      ;;
    D)
      y=$((y+1))
      case $dl in
      R) x=$((x+1));;
      L) x=$((x-1));;
      esac
      visit 1 && c=$((c-1)) && y=$((y+1))
      for ((; c>0; c--, y++)); do
        visit
      done
      y=$((y+1))
      ;;
    esac
    [[ $x -lt 0 || $x -ge $s || $y -lt 0 || $y -ge $s ]] && echor "Out of range [$x,$y]vs[$s]" && return 1
    dl=$d
    if $dbg; then
      echorv x y dl
      show-map
      echor
    fi
    iter=$((iter+1))
    [[ ! -z $iters && $iter == $iters ]] && break
  done
} # }}}
p2() { # {{{
  while read l; do
    :
  done
} # }}}
source utils.sh
iters=
parse-args -e p1 "" -e p2 "" "$@"
$cmd < <(cat -)
verify-res

