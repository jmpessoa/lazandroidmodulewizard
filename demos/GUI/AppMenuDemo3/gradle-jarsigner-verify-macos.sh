export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMenuDemo3
jarsigner -verify -verbose -certs /android/workspace/AppMenuDemo3/build/outputs/apk/release/AppMenuDemo3-release.apk
