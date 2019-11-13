export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppZoomableImageViewDemo1
jarsigner -verify -verbose -certs /android/workspace/AppZoomableImageViewDemo1/bin/AppZoomableImageViewDemo1-release.apk
