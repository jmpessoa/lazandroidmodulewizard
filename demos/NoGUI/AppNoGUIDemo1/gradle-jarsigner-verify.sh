export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppNoGUIDemo1
jarsigner -verify -verbose -certs /android/workspace/AppNoGUIDemo1/build/outputs/apk/release/AppNoGUIDemo1-release.apk
