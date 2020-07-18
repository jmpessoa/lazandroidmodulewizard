export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppUSSDServiceDemo1
jarsigner -verify -verbose -certs /android/workspace/AppUSSDServiceDemo1/bin/AppUSSDServiceDemo1-release.apk
