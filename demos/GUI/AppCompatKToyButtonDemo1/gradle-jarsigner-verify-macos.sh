export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatKToyButtonDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatKToyButtonDemo1/build/outputs/apk/release/AppCompatKToyButtonDemo1-release.apk
