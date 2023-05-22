export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCustomDialogDemo3
jarsigner -verify -verbose -certs /android/workspace/AppCustomDialogDemo3/build/outputs/apk/release/AppCustomDialogDemo3-release.apk
