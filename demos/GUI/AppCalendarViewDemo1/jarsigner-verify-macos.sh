export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCalendarViewDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppCalendarViewDemo1/bin/AppCalendarViewDemo1-release.apk
