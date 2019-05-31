export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterOpenStreetMapDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterOpenStreetMapDemo1/bin/AppJCenterOpenStreetMapDemo1-release.apk
