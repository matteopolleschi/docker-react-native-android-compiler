#!/bin/bash
cp $1 ../android

cd ../android

# cp gradle.properties ../android
echo "android.useDeprecatedNdk=true" > gradle.properties
echo "" >> gradle.properties
echo "MYAPP_RELEASE_STORE_FILE=$1" >> gradle.properties
echo "MYAPP_RELEASE_KEY_ALIAS=$2" >> gradle.properties 
echo "MYAPP_RELEASE_STORE_PASSWORD=$3" >> gradle.properties
echo "MYAPP_RELEASE_KEY_PASSWORD=$4" >> gradle.properties

# keytool -genkey -v -keystore $1 -keyalg RSA -keysize 2048 -validity 10000 -alias $2
# keytool -importkeystore -srckeystore $1 -destkeystore $1 -deststoretype pkcs12

rm -rf ./app/build/outputs/apk/*.apk

./gradlew assembleRelease

zipalign -v -p 4 ./app/build/outputs/apk/app-release-unsigned.apk ./app/build/outputs/apk/app-release-unsigned-aligned.apk

mv ./app/build/outputs/apk/app-release-unsigned.apk ./app/build/outputs/apk/$5-release-unsigned.apk 
mv ./app/build/outputs/apk/app-release-unsigned-aligned.apk ./app/build/outputs/apk/$5-release-unsigned-aligned.apk

apksigner sign --ks $1 --out ./app/build/outputs/apk/$5-release.apk ./app/build/outputs/apk/$5-release-unsigned-aligned.apk

apksigner verify ./app/build/outputs/apk/$5-release.apk