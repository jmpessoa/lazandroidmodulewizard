export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppXLSWriterDemo1
jarsigner -verify -verbose -certs /lamw/workspace/AppXLSWriterDemo1/bin/AppXLSWriterDemo1-release.apk
