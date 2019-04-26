export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterLanternDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterLanternDemo1/bin/AppJCenterLanternDemo1-release.apk
