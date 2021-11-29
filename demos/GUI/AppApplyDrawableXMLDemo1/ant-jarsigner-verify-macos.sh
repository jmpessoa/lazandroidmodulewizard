export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppApplyDrawableXMLDemo1
jarsigner -verify -verbose -certs /android/workspace/AppApplyDrawableXMLDemo1/bin/AppApplyDrawableXMLDemo1-release.apk
