export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /Temp/AppSoundPoolDemo
jarsigner -verify -verbose -certs /Temp/AppSoundPoolDemo/bin/AppSoundPoolDemo-release.apk
