#!/bin/bash

for DIR in $(find . -maxdepth 2 -type d -name '.git')
do
  D=${DIR%/.git}
  echo
  echo Updating $D
  cd $D ; git fetch --prune && git pull --rebase ; cd ..
  echo
done
