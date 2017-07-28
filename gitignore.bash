#!/bin/bash
[[ $# -ne 1 ]] && exit 1
if [ -d "$1" ]
then
  IGNORE="${1%/}/**"
  [[ ! -f .gitignore ]] && touch .gitignore
  if ! grep -Fxq "$IGNORE" .gitignore
  then
    echo "$IGNORE" >>.gitignore
    echo "'$IGNORE' added to '.gitignore' file."
  fi
else
  echo "Directory '$1' does not exist."
fi
