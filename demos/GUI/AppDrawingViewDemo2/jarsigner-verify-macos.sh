export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppDrawingViewDemo2
jarsigner -verify -verbose -certs /android/workspace/AppDrawingViewDemo2/bin/AppDrawingViewDemo2-release.apk
