#!/usr/bin/env bash

if [[ -z ${1} ]] ; then
    echo "
The $0 utility adds key to keystore file.
Usage:
    $0 <keystore_file_pathname> <key_alias>
"
    exit
fi

IMAGE_NAME=dipspb/react-native

KEY_STORE_FILE=$1
KEY_ALIAS=$2

[[ ${KEY_STORE_FILE} == /* ]] || KEY_STORE_FILE="${PWD}/${KEY_STORE_FILE}"

KEY_STORE_FILENAME=$(basename ${KEY_STORE_FILE})
KEY_STORE_FILEPATH=$(dirname ${KEY_STORE_FILE})

echo "KEY_STORE_FILE: ${KEY_STORE_FILE}"
echo "KEY_ALIAS: ${KEY_ALIAS}"

docker run -ti -v ${PWD}:/home/dev -v ${KEY_STORE_FILEPATH}:/tmp/keystores ${IMAGE_NAME} \
    keytool -genkey -v \
        -keystore /tmp/keystores/${KEY_STORE_FILENAME} \
        -alias ${KEY_ALIAS} -keyalg RSA \
        -keysize 2048 -validity 10000
