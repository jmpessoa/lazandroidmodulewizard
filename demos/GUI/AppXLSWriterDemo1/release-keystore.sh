export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppXLSWriterDemo1
keytool -genkey -v -keystore appxlswriterdemo1-release.keystore -alias appxlswriterdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppXLSWriterDemo1/keytool_input.txt
