export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo
jarsigner -verify -verbose -certs /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/bin/AppLocationForGpsDemo-release.apk
