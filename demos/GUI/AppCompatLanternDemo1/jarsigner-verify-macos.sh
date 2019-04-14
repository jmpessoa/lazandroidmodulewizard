export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCompatLanternDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCompatLanternDemo1/bin/AppCompatLanternDemo1-release.apk
