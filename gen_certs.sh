#!/usr/bin/env bash

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
