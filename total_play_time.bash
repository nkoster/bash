#!/bin/bash

if [ $# -eq 0 ]
then
  echo
  echo "Usage: $0 <directory>"
  echo "<directory> contains one or more mp3/mp4 files"
  echo
  exit 1
fi

cd $1
FILES=$(ls *mp[34] | wc -l)
S="s"
if [ $FILES = 1 ]
then
  S=""
fi

echo
echo -n "$FILES mp3/mp4 file$S total play time: "

TOTAL=$(
for mp in *mp[34]
do
  DUR=$( \
    avconv -i "$mp" -f metadata 2>&1 | \
    grep Duration | \
    awk '{print $2}' | \
    perl -pe 's/,//,s/\./:/')
  echo $DUR | \
  awk -F ':' '{
    t = $4 + ($3 * 100) + ($2 * 60 * 100) + ($1 * 3600 * 100);
    printf("%d\n", t);
  }'
done | while read meta
do
  time=$(echo $meta)
  (( TOTAL += time ))
  echo "$TOTAL"
done | tail -1
)

HOURS=$(echo "$TOTAL/3600/100" | bc)
SH="s"
if [ $HOURS = 1 ]
then
  SH=""
fi
MINUTES=$(echo "($TOTAL-($HOURS*3600*100))/60/100" | bc)
SM="s"
if [ $MINUTES = 1 ]
then
  SM=""
fi
SECONDS=$(echo "($TOTAL-($HOURS*3600*100)-($MINUTES*60*100))/100" | bc)
SS="s"
if [ $SECONDS = 1 ]
then
  SS=""
fi

echo "$HOURS hour$SH, $MINUTES minute$SM, $SECONDS second$SS"
echo
