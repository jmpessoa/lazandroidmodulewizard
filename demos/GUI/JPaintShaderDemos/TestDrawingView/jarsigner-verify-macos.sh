export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/TestDrawingView
jarsigner -verify -verbose -certs /!work/FPC/TestDrawingView/bin/TestDrawingView-release.apk
