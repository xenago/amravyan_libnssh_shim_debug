#!/bin/bash

# https://serverfault.com/questions/1122226/user-account-auto-creation-using-ssh-certificate-authentication

if [ $# -eq 0 ]; then
  exit 0
fi

while getopts "u:n:" opt; do
  case $opt in
    u)
      uid=$OPTARG
      name=$(find /home -maxdepth 1 -type d -uid $uid | head -1 | cut -d "/" -f 3)
      echo "$name:x:$uid:1::/home/$name:/bin/bash"
      ;;
    n)
      name=$OPTARG
      uid=$(stat -c %u /home/$name 2>/dev/null)
      if [[ -z $uid ]]; then
          uid=$(stat -c %u /home/* | sort | tail -1 | awk '{print $1+1;}')
      fi
      sudo_gid=27
      echo "$name:x:$uid:$uid::/home/$name:/bin/bash"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
