export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppToneGeneratorDemo1
jarsigner -verify -verbose -certs /android/workspace/AppToneGeneratorDemo1/bin/AppToneGeneratorDemo1-release.apk
