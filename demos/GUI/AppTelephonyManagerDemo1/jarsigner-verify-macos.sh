export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppTelephonyManagerDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppTelephonyManagerDemo1/bin/AppTelephonyManagerDemo1-release.apk
