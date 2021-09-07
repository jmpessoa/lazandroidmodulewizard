export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppLinearLayoutDemo1
jarsigner -verify -verbose -certs /android/workspace/AppLinearLayoutDemo1/bin/AppLinearLayoutDemo1-release.apk
