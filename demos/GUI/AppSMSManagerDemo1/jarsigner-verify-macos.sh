export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppSMSManagerDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppSMSManagerDemo1/bin/AppSMSManagerDemo1-release.apk
