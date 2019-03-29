export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppUploadServiceDemo1
keytool -genkey -v -keystore appuploadservicedemo1-release.keystore -alias appuploadservicedemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppUploadServiceDemo1/keytool_input.txt
