export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppTextViewVerticalScrolling
jarsigner -verify -verbose -certs /android/workspace/AppTextViewVerticalScrolling/build/outputs/apk/release/AppTextViewVerticalScrolling-release.apk
