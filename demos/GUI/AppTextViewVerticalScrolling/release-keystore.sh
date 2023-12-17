export JAVA_HOME=/Program Files/Eclipse Adoptium/jdk-11.0.21.9
cd /android/workspace/AppTextViewVerticalScrolling
LC_ALL=C keytool -genkey -v -keystore apptextviewverticalscrolling-release.keystore -alias apptextviewverticalscrolling.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppTextViewVerticalScrolling/keytool_input.txt
