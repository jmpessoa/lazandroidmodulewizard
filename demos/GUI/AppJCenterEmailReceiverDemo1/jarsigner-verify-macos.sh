export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterEmailReceiverDemo1
jarsigner -verify -verbose -certs /android/workspace/AppJCenterEmailReceiverDemo1/bin/AppJCenterEmailReceiverDemo1-release.apk
