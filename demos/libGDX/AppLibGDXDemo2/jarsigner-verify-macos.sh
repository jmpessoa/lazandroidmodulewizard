export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppLibGDXDemo2
jarsigner -verify -verbose -certs /android/workspace/AppLibGDXDemo2/bin/AppLibGDXDemo2-release.apk
