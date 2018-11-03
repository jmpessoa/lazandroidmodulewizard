export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppIntentDemoPrinting1
jarsigner -verify -verbose -certs /lamw/workspace/AppIntentDemoPrinting1/bin/AppIntentDemoPrinting1-release.apk
