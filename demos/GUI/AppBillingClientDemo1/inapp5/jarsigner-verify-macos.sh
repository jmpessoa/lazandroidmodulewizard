export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /svn/apps/inapp5
jarsigner -verify -verbose -certs /svn/apps/inapp5/bin/inapp5-release.apk
