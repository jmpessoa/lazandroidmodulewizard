export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppMSSQLJDBCConnectionDemo1
keytool -genkey -v -keystore appmssqljdbcconnectiondemo1-release.keystore -alias appmssqljdbcconnectiondemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppMSSQLJDBCConnectionDemo1/keytool_input.txt
