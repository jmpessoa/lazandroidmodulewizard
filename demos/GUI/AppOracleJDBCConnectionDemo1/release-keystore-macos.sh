export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppOracleJDBCConnectionDemo1
keytool -genkey -v -keystore apporaclejdbcconnectiondemo1-release.keystore -alias apporaclejdbcconnectiondemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppOracleJDBCConnectionDemo1/keytool_input.txt
