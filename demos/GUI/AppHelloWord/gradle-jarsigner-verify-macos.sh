export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppHelloWord
jarsigner -verify -verbose -certs /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-release.apk
