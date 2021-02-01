export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppNoGUIDemo1
jarsigner -verify -verbose -certs /android/workspace/AppNoGUIDemo1/bin/AppNoGUIDemo1-release.apk
