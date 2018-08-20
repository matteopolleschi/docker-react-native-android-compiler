#!/usr/bin/env bash

# NOTE: You need to keep Dockerfile in the same directory with this utility.

IMAGE_NAME="dipspb/react-native"

if [[ -z ${1} ]] ; then
    docker build --tag ${IMAGE_NAME} $(dirname $0)
else
    docker build --tag ${IMAGE_NAME} --build-arg ${1} --build-arg ${2} $(dirname $0)
fi
