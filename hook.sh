#!/bin/bash

# https://stackoverflow.com/questions/59895
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE"  ]; do
  DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

echo "Recieved request for" "${CERTBOT_DOMAIN}"
cd ${DIR}
go run *.go "_acme-challenge.${CERTBOT_DOMAIN}" "${CERTBOT_VALIDATION}"

# www.varstack.com is the last domain. Records are published
# every 15 minutes. Wait for 16 minutes, and then proceed.
if [ "${CERTBOT_DOMAIN}" = "www.varstack.com" ]; then
  for (( i=0; i<16; i++ )); do
    echo "Minute" ${i}
    sleep 60s
  done
fi
