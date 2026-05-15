#/usr/bin/env bash

LOG_ENABLED=${LOG_ENABLED:-true}
toRun=
mode=
cookie=
[[ -e .conf ]] && source .conf
varia=
init=false
runFina=true

source .results

while [[ ! -z $1 ]]; do # {{{
  case $1 in
  -a | --all) # {{{
    [[ -z $LOG_ENABLED ]] && export LOG_ENABLED=false
    err=0
    for i in d*.py; do
      progress --mark --msg "$i -> A"
      $0 $i -vA 2>/dev/null
      [[ $? == 0 ]] || err=1
      progress --unmark --err=$err
      progress --mark --msg "$i -> B"
      $0 $i -vB 2>/dev/null
      [[ $? == 0 ]] || err=1
      progress --unmark --err=$err
    done
    exit $err;; # }}}
  ab) # {{{
    shift
    err=0
    $0 $toRun -vA ${mode:0:1} $@
    [[ $? == 0 ]] || err=1
    $0 $toRun -vB ${mode:0:1} $@
    [[ $? == 0 ]] || err=1
    exit $err;; # }}}
  tf) # {{{
    shift
    err=0
    $0 $toRun $varia -t $@
    [[ $? == 0 ]] || err=1
    $0 $toRun $varia -f $@
    [[ $? == 0 ]] || err=1
    shift
    exit $err;; # }}}
  -i | --init) init=true;;
  -l | --log) export LOG_ENABLED=true;;
  a | -vA)   varia="a";;
  b | -vB)   varia="b";;
  t | -t | --test) mode='test'; runFina=false;;
  f | -f | --fina) mode='fina';;
  *) # {{{
    toRun=$(basename ${1%.py})
    [[ $toRun == d* ]] || toRun="$(printf "d%02d" $(( 10#$toRun )))";; # }}}
  esac; shift
done # }}}

if $init; then # {{{
  [[ -z $toRun ]] && toRun="$(printf "d%02d" $(( $(ls d*.py 2>/dev/null | wc -l) + 1 )))"
  if [[ ! -e $toRun.py ]]; then
    echor "Setting up $toRun"
    cp .skel.py $toRun.py
  fi
  inFina=in-$toRun-fina.txt
  touch in-$toRun-{test,fina}.txt
  if [[ ! -z $cookie && ! -s $inFina ]]; then
    curl -s -H "cookie: session=$cookie" https://adventofcode.com/2024/day/$((10#${toRun#d}))/input -o $inFina
    if [[ ! -s $inFina ]]; then
      echor "Final data not received"
      exit 1
    elif [[ $(head -n 1 $inFina) == "Please don't"* ]]; then
      echor "Final data not yet available"
      echo -n >$inFina
    fi
  fi
  exit 0
fi # }}}

[[ -z $toRun ]] && toRun=$(ls -r d*.py 2>/dev/null | head -n1)
toRun=${toRun%.py}
[[ -z $toRun ]] && die "Cannot find what to run"

[[ -e $toRun.py ]] || { $0 $toRun --init; exit; }

if [[ -z $varia ]]; then
  varia="a"
  [[ ! -z ${expectedMap[$toRun-a-f]} ]] && varia="b"
fi
[[ -z $mode ]] && mode='test'
expected=${expectedMap[$toRun-$varia-${mode:0:1}]}

dataFile="in-$toRun-$mode.txt"
[[ -e ${dataFile%.txt}-$varia.txt ]] && dataFile=${dataFile%.txt}-$varia.txt
[[ -s $dataFile ]] || die "No data file: $dataFile"

echo -n >res.tmp
python $toRun.py $varia $dataFile > res.tmp || die $? "Execution failed"

if [[ -z $expected ]]; then # {{{
  echorc $LOG_ENABLED "??: No expected, [\"$toRun-$varia-${mode:0:1}\"]=$(cat res.tmp)"
  if [[ $mode == 'fina' ]]; then
    cat res.tmp | xc
    echorc $LOG_ENABLED "OK: Copied"
  fi # }}}
elif [[ $expected == $(cat res.tmp) ]]; then # {{{
  echorc $LOG_ENABLED "OK: $expected == $(cat res.tmp)"
  if [[ $mode == 'test' ]] && $runFina; then
    echorc $LOG_ENABLED "OK: Trying final"
    $0 $toRun -v${varia^^} --fina || die $? "Execution failed"
  fi # }}}
else # {{{
  die 5 "NO: $expected != '$(cat res.tmp)'"
fi # }}}

