export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppScrollingImages
jarsigner -verify -verbose -certs /android/workspace/AppScrollingImages/bin/AppScrollingImages-release.apk
