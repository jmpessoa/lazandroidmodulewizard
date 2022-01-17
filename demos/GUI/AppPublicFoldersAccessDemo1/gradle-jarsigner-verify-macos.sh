export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppPublicFoldersAccessDemo1
jarsigner -verify -verbose -certs /android/workspace/AppPublicFoldersAccessDemo1/build/outputs/apk/release/AppPublicFoldersAccessDemo1-release.apk
