export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppXLSWriterDemo1
keytool -genkey -v -keystore appxlswriterdemo1-release.keystore -alias appxlswriterdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppXLSWriterDemo1/keytool_input.txt
