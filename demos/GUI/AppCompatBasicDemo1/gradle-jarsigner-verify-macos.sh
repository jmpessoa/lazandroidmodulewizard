export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatBasicDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatBasicDemo1/build/outputs/apk/release/AppCompatBasicDemo1-release.apk
