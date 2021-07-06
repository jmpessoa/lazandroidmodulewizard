export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatBasicDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatBasicDemo1/bin/AppCompatBasicDemo1-release.apk
