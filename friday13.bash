#!/bin/bash
echo -e "\nFriday the 13th for the coming ten year:\n"
epoch_today=$(date +%s)
ten_year=315360000
one_day=86400
for n in `seq $epoch_today $one_day $(($epoch_today+$ten_year))`
do
  date --date @$n | \
  grep ^Fri | \
  awk '{
    if ($3==13) printf("%s %s\n",$2,$6)
  }'
done
echo
