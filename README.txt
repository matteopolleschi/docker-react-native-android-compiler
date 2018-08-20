==========================
DocKer-React-Native (DKRN)
==========================


CONFIGURATION
=============

1) You need to change IMAGE_NAME variable value in each script to make your own docker image name.
2) You may need to change ANDROID_SDK_VERSION


Optional project configurations
===============================
In case your <app_repository>/android/app/build.gradle have config value like that:

    storeFile file('some-app-specific.keystore')

You will need to change it to that one:

    storeFile file(MYAPP_RELEASE_STORE_FILE)


Utilities
=========

dkrn-setup.sh
-------------
Setup docker image, you need to keep Dockerfile in the same directory with this utility.
Usage:
    dkrn-setup.sh
    dkrn-setup.sh ANDROID_SDK_VERSION=<sdk_version> ANDROID_BUILD_TOOLS_VERSION=<build_tools_version>


dkrn-addkey.sh
--------------
Adds key to keystore file.
Usage:
    dkrn-addkey.sh <keystore_file_pathname> <key_alias>


dkrn-keytool.sh
---------------
Runs android keytool command in current directory.
Usage:
    dkrn-keytool.sh <any> <keytool> <options> <are> <going> <here> ...


dkrn-build.sh
-------------
Builds a unsigned and signed .apk files for project.
Usage:
    dkrn-build.sh <keystore_file_pathname> <keystore_password> <key_alias> <key_password> <application_repository_path>


