export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppImageViewListDemo1
keytool -genkey -v -keystore appimageviewlistdemo1-release.keystore -alias appimageviewlistdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppImageViewListDemo1/keytool_input.txt
