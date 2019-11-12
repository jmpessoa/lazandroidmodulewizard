export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /!work/FPC/TestView
jarsigner -verify -verbose -certs /!work/FPC/TestView/bin/TestView-release.apk
