#!/bin/bash

# Exit on first failure
set -e

# https://serverfault.com/questions/1122226/user-account-auto-creation-using-ssh-certificate-authentication

if [ $# -eq 0 ]; then
  exit 0
fi

while getopts "u:n:" opt; do
  case $opt in
    u)
      uid=$OPTARG
      name=$(find /home -maxdepth 1 -type d -uid $uid | head -1 | cut -d "/" -f 3)
      if [[ -z $name ]]; then
        exit 1
      fi
      echo "$name:x:$uid:1::/home/$name:/bin/bash"
      ;;
    n)
      name=$OPTARG
      # If the homedir does not exist, create it on-demand
      if [[ ! -e /home/$name ]]; then
        # We need to either run useradd, or assume we are responding to a query from useradd
        if [[ -e /etc/libnss_shim/creating/$name ]]; then
            exit 0
        else
            touch "/etc/libnss_shim/creating/$name"
            if [[ ! $? -eq 0 ]]; then
                exit 1
            fi
            useradd -s /bin/bash -m "$name"
            if [[ ! $? -eq 0 ]]; then
                bad_creation=1
            fi
            rm "/etc/libnss_shim/creating/$name"
            if [[ $bad_creation ]]; then
                exit 1
            fi
        fi
      fi
      uid=$(stat -c %u "/home/$name" 2>/dev/null)
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
