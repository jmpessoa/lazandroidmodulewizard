export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppSMSManagerDemo1
keytool -genkey -v -keystore AppSMSManagerDemo1-release.keystore -alias appsmsmanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppSMSManagerDemo1/appsmsmanagerdemo1keytool_input.txt
