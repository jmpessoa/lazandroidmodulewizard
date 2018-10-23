export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppTelephonyManagerDemo1
keytool -genkey -v -keystore AppTelephonyManagerDemo1-release.keystore -alias apptelephonymanagerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppTelephonyManagerDemo1/apptelephonymanagerdemo1keytool_input.txt
