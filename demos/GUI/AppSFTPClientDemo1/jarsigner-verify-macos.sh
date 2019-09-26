export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppSFTPClientDemo1
jarsigner -verify -verbose -certs /android/workspace/AppSFTPClientDemo1/bin/AppSFTPClientDemo1-release.apk
