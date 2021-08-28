export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppWebViewDemo1
jarsigner -verify -verbose -certs /android/workspace/AppWebViewDemo1/bin/AppWebViewDemo1-release.apk
