export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterToyTimerServiceDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterToyTimerServiceDemo1/bin/AppJCenterToyTimerServiceDemo1-release.apk
