export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppFTPClientDemo1
jarsigner -verify -verbose -certs /android/workspace/AppFTPClientDemo1/bin/AppFTPClientDemo1-release.apk
