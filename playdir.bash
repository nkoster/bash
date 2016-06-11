#!/bin/bash

# Play whatever playable in the current directory
# and break the loop when ctrl-c is pressed.

echo
echo "Press q to skip and play the next file."
echo "Press Ctrl-c to quit."
echo

for n in $(pwd)/*
do
  echo $n
  sleep 1
  mplayer --quiet --novideo "$n" >/dev/null 2>&1 || break
done
