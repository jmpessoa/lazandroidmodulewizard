export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppDownloadServiceDemo1
keytool -genkey -v -keystore AppDownloadServiceDemo1-release.keystore -alias appdownloadservicedemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppDownloadServiceDemo1/appdownloadservicedemo1keytool_input.txt
