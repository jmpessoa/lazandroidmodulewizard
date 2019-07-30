export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterSignaturePadDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterSignaturePadDemo1/bin/AppJCenterSignaturePadDemo1-release.apk
