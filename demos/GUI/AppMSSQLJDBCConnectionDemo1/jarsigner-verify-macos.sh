export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMSSQLJDBCConnectionDemo1
jarsigner -verify -verbose -certs /android/workspace/AppMSSQLJDBCConnectionDemo1/bin/AppMSSQLJDBCConnectionDemo1-release.apk
