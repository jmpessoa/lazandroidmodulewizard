export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppOracleJDBCConnectionDemo1
jarsigner -verify -verbose -certs /android/workspace/AppOracleJDBCConnectionDemo1/bin/AppOracleJDBCConnectionDemo1-release.apk
