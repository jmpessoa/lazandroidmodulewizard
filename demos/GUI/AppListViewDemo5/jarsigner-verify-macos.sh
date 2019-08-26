export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppListViewDemo5
jarsigner -verify -verbose -certs /android/workspace/AppListViewDemo5/bin/AppListViewDemo5-release.apk
