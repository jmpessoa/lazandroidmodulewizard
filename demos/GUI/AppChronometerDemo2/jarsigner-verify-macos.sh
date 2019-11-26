export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppChronometerDemo2
jarsigner -verify -verbose -certs /Temp/AppChronometerDemo2/bin/AppChronometerDemo2-release.apk
