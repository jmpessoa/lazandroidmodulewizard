export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppDrawingInBitmap
jarsigner -verify -verbose -certs /android/workspace/AppDrawingInBitmap/bin/AppDrawingInBitmap-release.apk
