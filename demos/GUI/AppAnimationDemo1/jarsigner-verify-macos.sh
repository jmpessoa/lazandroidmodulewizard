export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppAnimationDemo1
jarsigner -verify -verbose -certs /android/workspace/AppAnimationDemo1/bin/AppAnimationDemo1-release.apk
