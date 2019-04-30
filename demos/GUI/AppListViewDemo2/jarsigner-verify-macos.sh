export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /laztoapk/projects/project1/AppListViewDemo2
jarsigner -verify -verbose -certs /laztoapk/projects/project1/AppListViewDemo2/bin/AppListViewDemo2-release.apk
