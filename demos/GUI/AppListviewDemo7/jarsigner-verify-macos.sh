export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppListviewDemo7
jarsigner -verify -verbose -certs /android/workspace/AppListviewDemo7/bin/AppListviewDemo7-release.apk
