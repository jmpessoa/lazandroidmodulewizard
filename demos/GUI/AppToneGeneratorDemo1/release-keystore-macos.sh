export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppToneGeneratorDemo1
keytool -genkey -v -keystore apptonegeneratordemo1-release.keystore -alias apptonegeneratordemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppToneGeneratorDemo1/keytool_input.txt
