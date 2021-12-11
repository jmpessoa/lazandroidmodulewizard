export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppHelloWord
jarsigner -verify -verbose -certs /android/workspace/AppHelloWord/bin/AppHelloWord-release.apk
