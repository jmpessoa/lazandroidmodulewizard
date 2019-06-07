export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMenuDemo2
jarsigner -verify -verbose -certs /android/workspace/AppMenuDemo2/bin/AppMenuDemo2-release.apk
