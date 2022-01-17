export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppPublicFoldersAccessDemo1
keytool -genkey -v -keystore apppublicfoldersaccessdemo1-release.keystore -alias apppublicfoldersaccessdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppPublicFoldersAccessDemo1/keytool_input.txt
