#!/usr/bin/env bash
# vim: fdl=0

echorm --name -$(basename ${0%.sh})
no-stdin() { # {{{
  f=$(basename $0) && f=${f%.*}; p=${1:--t}
  if [[ $1 == -f ]]; then
    f=$(ls in/$f-full.in*); shift
  else
    [[ $1 == '-t' ]] && shift || p='-t'
    f=$(ls in/$f.in*)
  fi 2>/dev/null
  [[ -e $f ]] || return 10
  { [[ $f == *.gz ]] && gunzip -c $f || cat $f; } | $0 $p $@
} # }}}
parse-args() { # {{{
  local e_p1= e_p2= lret=
  while [[ ! -z $1 ]]; do
    case $1 in
    -d)          dbg=true;;
    -t)          mode=test;;
    -f)          mode=full;;
    --ret)       lret=$2; shift;;
    -e)          local -n rE=e_$2; rE="$3"; shift; shift;;
    *) # {{{
      if ! declare -F parse-extra-args >/dev/null 2>&1 || ! parse-extra-args "$1"; then
        cmd=$1; break
      fi;; # }}}
    esac; shift
  done
  expected=expected_$mode
  local -n rE=e_$cmd
  if [[ ! -z $lret ]]; then
    _ret=$lret
  else
    _ret=ret
  fi
  if [[ ! -z $rE ]]; then
    set -- $rE
    expected_test=$1 expected_full=$2
    [[ $expected_test == '-' ]] && expected_test=
    [[ $expected_full == '-' ]] && expected_full=
  fi
  ! $dbg || declare -F echor >/dev/null 2>&1 || { echo "No echor*, debugs disabled" >/dev/stderr; dbg=false; }
  if $dbg; then
    echorm --name -$(basename ${0%.sh}):$cmd:$mode
    echor "cmd:$cmd, expected-from:$mode"
    echorv expected_test expected_full
  fi
} # }}}
verify-res() { # {{{
  [[ -z $_ret ]] && echor "No result" && return 1
  if [[ -z $expected ]]; then
    echor -C "%wrn:%s" "No expected value provided"
  elif [[ $_ret != $expected ]]; then
    echor -C "Result differs: %err:$ret vs %blue:$expected" && return 2
  fi
  $use_xclip && declare -F xclip >/dev/null 2>&1 && [[ -t 1 ]] && echo "$_ret" | xclip
  echo $_ret
} # }}}

[[ -t 0 ]] && { no-stdin "$@"; exit; }

dbg=false use_xclip=${USE_XCLIP:-true} expected_test= expected_full= mode=test cmd=p1 ret=
declare -n expected _ret

