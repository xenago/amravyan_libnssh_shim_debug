#!/bin/bash

# https://serverfault.com/questions/1122226/user-account-auto-creation-using-ssh-certificate-authentication

if [ $# -eq 0 ]; then
  exit 0
fi

while getopts "g:n:" opt; do
  case $opt in
    g)
      uid=$OPTARG
      name=$(find /home -maxdepth 1 -type d -uid $uid | head -1 | cut -d "/" -f 3)
      if [[ -z $name ]]; then
        exit 1
      fi
      echo "$name:x:$uid:"
      ;;
    n)
      name=$OPTARG
      if [ ! -e /home/$name ]; then
        exit 1
      fi
      uid=$(stat -c %u /home/$name 2>/dev/null)
      if [[ -z $uid ]]; then
          uid=$(stat -c %u /home/* | sort | tail -1 | awk '{print $1+1;}')
      fi
      echo "$name:x:$uid:"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
