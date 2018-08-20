#!/usr/bin/env bash

if [[ -z ${1} ]] ; then
    echo "
The $0 utility builds a unsigned and signed .apk files for project.
Usage:
    $0 <keystore_file_pathname> <keystore_password> <key_alias> <key_password> <application_repository_path>
"
    exit
fi

IMAGE_NAME=dipspb/react-native

KEY_STORE_FILE=$1
KEY_STORE_PASSWORD=$2
KEY_ALIAS=$3
KEY_PASSWORD=$4
APP_DIR=$5

[[ ${KEY_STORE_FILE} == /* ]] || KEY_STORE_FILE="${PWD}/${KEY_STORE_FILE}"
[[ ${APP_DIR} == /* ]] || APP_DIR="${PWD}/${APP_DIR}"

KEY_STORE_FILENAME=$(basename ${KEY_STORE_FILE})
KEY_STORE_FILEPATH=$(dirname ${KEY_STORE_FILE})

INDEX_JS_FILENAME=index.js
[[ -f ${APP_DIR}/index.android.js ]] && INDEX_JS_FILENAME=index.android.js

echo "KEY_STORE_FILE: ${KEY_STORE_FILE}"
echo "KEY_ALIAS: ${KEY_ALIAS}"
echo "APP_DIR: ${APP_DIR}"
echo "INDEX_JS_FILENAME: ${INDEX_JS_FILENAME}"

docker run -ti \
    -v ${APP_DIR}:/root \
    -v ${KEY_STORE_FILEPATH}:/tmp/keystores \
    ${IMAGE_NAME} bash -c "\
        npm install && \
        mkdir -p ./android/app/build/intermediates/assets/debug && \
        mkdir -p ./android/app/build/intermediates/res/merged/debug && \
        react-native bundle \
            --dev false \
            --platform android \
            --entry-file ${INDEX_JS_FILENAME} \
            --bundle-output ./android/app/build/intermediates/assets/debug/index.android.bundle \
            --assets-dest ./android/app/build/intermediates/res/merged/debug \
        && \
        cd android && \
        chmod a+x ./gradlew && \
        ./gradlew assembleDebug assembleRelease \
            -PMYAPP_RELEASE_STORE_FILE=/tmp/keystores/${KEY_STORE_FILENAME} \
            -PMYAPP_RELEASE_STORE_PASSWORD=${KEY_PASSWORD} \
            -PMYAPP_RELEASE_KEY_ALIAS=${KEY_ALIAS} \
            -PMYAPP_RELEASE_KEY_PASSWORD=${KEY_PASSWORD}
    "

