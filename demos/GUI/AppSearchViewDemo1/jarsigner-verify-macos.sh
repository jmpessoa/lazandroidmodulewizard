export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppSearchViewDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppSearchViewDemo1/bin/AppSearchViewDemo1-release.apk
