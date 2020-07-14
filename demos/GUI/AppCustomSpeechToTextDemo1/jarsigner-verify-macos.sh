export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppCustomSpeechToTextDemo1
jarsigner -verify -verbose -certs /android/workspace/AppCustomSpeechToTextDemo1/bin/AppCustomSpeechToTextDemo1-release.apk
