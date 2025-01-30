FROM ubuntu:jammy
RUN apt update && apt install curl vim jq -y && curl -L https://github.com/xenago/libnss_shim/releases/download/1.2.1/libnss_shim_1.2.1-1_amd64.deb -o libnss_shim_1.2.1-1_amd64.deb
RUN apt install ./libnss_shim_1.2.1-1_amd64.deb

COPY config.json /etc/libnss_shim/config.json
COPY passwd_get_all_entries.sh /usr/local/bin/passwd_get_all_entries.sh
COPY group_get_all_entries.sh /usr/local/bin/group_get_all_entries.sh

RUN chmod +x /usr/local/bin/passwd_get_all_entries.sh /usr/local/bin/group_get_all_entries.sh
RUN mkdir /home/random
