#!/bin/bash

exec > >(tee -i /tmp/fetch_pull_all.log)
exec 2>&1

for DIR in $(find . -maxdepth 2 -type d -name '.git')
do
  D=${DIR%/.git}
  echo
  echo Updating $D
  cd $D ; git fetch --prune && git pull --rebase ; cd ..
  echo
done
