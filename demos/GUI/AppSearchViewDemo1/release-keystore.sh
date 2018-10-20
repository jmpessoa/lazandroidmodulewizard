export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppSearchViewDemo1
keytool -genkey -v -keystore AppSearchViewDemo1-release.keystore -alias appsearchviewdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppSearchViewDemo1/appsearchviewdemo1keytool_input.txt
