export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppEditTextActionIconDemo1
jarsigner -verify -verbose -certs /android/workspace/AppEditTextActionIconDemo1/build/outputs/apk/release/AppEditTextActionIconDemo1-release.apk
