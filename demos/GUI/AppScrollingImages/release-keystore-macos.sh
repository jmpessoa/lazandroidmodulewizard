export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppScrollingImages
keytool -genkey -v -keystore appscrollingimages-release.keystore -alias appscrollingimages.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppScrollingImages/keytool_input.txt
