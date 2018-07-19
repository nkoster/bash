#!/bin/bash

[[ $# -lt 4 ]] && exit 1

user_remote="$1"
host="$2"
port_local="$3"
port_remote="$4"

keys=$(gpg --list-keys "$user_remote" | grep -c '^$')
if [ $keys -gt 1 ]; then
    echo "Too many keys for remote user"
    exit 1
fi

export GPG_TTY=$(tty)

echo "Starting listener at port $port"
while true ; do ncat -l $port_local | gpg -d --batch --passphrase "$(cat /home/niels/secure/hup3)" 2>/dev/null ; done &

echo "Initiating pgp chat to $user_remote at $host"
echo

while true
do
    read n
    echo "$n" | gpg -e -r "$user_remote" | ncat $host $port_remote
done

