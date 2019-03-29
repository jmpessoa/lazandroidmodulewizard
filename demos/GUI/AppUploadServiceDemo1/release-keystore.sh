export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /lamw/workspace/AppUploadServiceDemo1
keytool -genkey -v -keystore appuploadservicedemo1-release.keystore -alias appuploadservicedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppUploadServiceDemo1/keytool_input.txt
