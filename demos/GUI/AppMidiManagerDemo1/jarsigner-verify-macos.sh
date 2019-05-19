export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /SVN/micrologus/Client/Apps/AppMidiManagerDemo1
jarsigner -verify -verbose -certs /SVN/micrologus/Client/Apps/AppMidiManagerDemo1/bin/AppMidiManagerDemo1-release.apk
