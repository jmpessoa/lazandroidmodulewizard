export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppEditTextActionIconDemo1
keytool -genkey -v -keystore appedittextactionicondemo1-release.keystore -alias appedittextactionicondemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppEditTextActionIconDemo1/keytool_input.txt
