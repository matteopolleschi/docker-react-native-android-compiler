#!/usr/bin/env bash

IMAGE_NAME=dipspb/react-native

docker run -ti -v ${PWD}:/home/dev ${IMAGE_NAME} keytool $@
