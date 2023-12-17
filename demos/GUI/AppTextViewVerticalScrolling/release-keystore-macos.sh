export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppTextViewVerticalScrolling
keytool -genkey -v -keystore apptextviewverticalscrolling-release.keystore -alias apptextviewverticalscrolling.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppTextViewVerticalScrolling/keytool_input.txt
