export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppHelloWord
jarsigner -verify -verbose -certs /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-release.apk
