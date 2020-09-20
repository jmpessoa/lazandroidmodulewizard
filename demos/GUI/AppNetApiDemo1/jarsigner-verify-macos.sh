export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppNetApiDemo1
jarsigner -verify -verbose -certs /android/workspace/AppNetApiDemo1/bin/AppNetApiDemo1-release.apk
