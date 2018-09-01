export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppHttpClientDemo3
jarsigner -verify -verbose -certs /lamw/workspace/AppHttpClientDemo3/bin/AppHttpClientDemo3-release.apk
