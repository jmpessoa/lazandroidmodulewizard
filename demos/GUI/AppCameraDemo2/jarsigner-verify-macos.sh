export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCameraDemo2
jarsigner -verify -verbose -certs /android/workspace/AppCameraDemo2/bin/AppCameraDemo2-release.apk
