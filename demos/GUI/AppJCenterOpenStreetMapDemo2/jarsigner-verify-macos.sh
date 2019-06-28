export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterOpenStreetMapDemo2
jarsigner -verify -verbose -certs /android/workspace/AppJCenterOpenStreetMapDemo2/bin/AppJCenterOpenStreetMapDemo2-release.apk
