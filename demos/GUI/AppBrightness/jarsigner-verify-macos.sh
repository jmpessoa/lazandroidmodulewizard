export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppBrightness
jarsigner -verify -verbose -certs /Temp/AppBrightness/bin/AppBrightness-release.apk
