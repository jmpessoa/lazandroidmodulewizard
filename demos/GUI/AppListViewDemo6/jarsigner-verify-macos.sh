export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppListViewDemo6
jarsigner -verify -verbose -certs /android/workspace/AppListViewDemo6/bin/AppListViewDemo6-release.apk
