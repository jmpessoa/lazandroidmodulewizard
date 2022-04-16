export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppTableLayoutDemo1
jarsigner -verify -verbose -certs /android/workspace/AppTableLayoutDemo1/bin/AppTableLayoutDemo1-release.apk
