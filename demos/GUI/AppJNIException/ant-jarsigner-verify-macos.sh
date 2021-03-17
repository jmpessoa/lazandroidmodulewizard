export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppJNIException
jarsigner -verify -verbose -certs /Temp/AppJNIException/bin/AppJNIException-release.apk
