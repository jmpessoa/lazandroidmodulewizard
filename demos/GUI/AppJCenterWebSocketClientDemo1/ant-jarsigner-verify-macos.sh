export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterWebSocketClientDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterWebSocketClientDemo1/bin/AppJCenterWebSocketClientDemo1-release.apk
