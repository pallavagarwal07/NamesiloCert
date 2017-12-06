#!/usr/bin/env bash

set -e

# https://stackoverflow.com/questions/59895
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE"  ]; do
            DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
            SOURCE="$(readlink "$SOURCE")"
            [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"

mkdir -p ${DIR}/gen/{conf,work,logs}

certbot     --config-dir ${DIR}/gen/conf      \
            --work-dir ${DIR}/gen/work        \
            --logs-dir ${DIR}/gen/logs        \
            --agree-tos                       \
            -m pallavagarwal07@gmail.com      \
            -d pallav.xyz                     \
            -d www.pallav.xyz                 \
            -d alexa.pallav.xyz               \
            -d varstack.com                   \
            -d www.varstack.com               \
            --manual                          \
            --manual-public-ip-logging-ok     \
            --preferred-challenges dns        \
            --noninteractive                  \
            --manual-auth-hook ${DIR}/hook.sh \
            certonly

associations=(
"pallavagarwal07%2Fshort%2Dlinks pallav.xyz www.pallav.xyz"
"pallavagarwal07%2Fpallavagarwal07%2Egitlab%2Eio varstack.com www.varstack.com"
)
key_dir="${DIR}/gen/conf/live/pallav.xyz"
for str in "${associations[@]}"; do
            arr=(${str})
            project="https://gitlab.com/api/v4/projects/${arr[0]}"
            domains=("${arr[@]:1}")
            for d in "${domains[@]}"; do
                        curl -vvv --header "Private-Token: ${GITLAB}"              \
                                    --request PUT                                  \
                                    --form "certificate=@${key_dir}/fullchain.pem" \
                                    --form "key=@${key_dir}/privkey.pem"           \
                                    "${project}/pages/domains/${d}" >> ${DIR}/gen/log 2>&1
            done
done

