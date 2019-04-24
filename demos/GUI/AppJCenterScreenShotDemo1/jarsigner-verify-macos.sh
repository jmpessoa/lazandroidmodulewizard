export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterScreenShotDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterScreenShotDemo1/bin/AppJCenterScreenShotDemo1-release.apk
