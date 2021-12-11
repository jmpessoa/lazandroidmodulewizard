export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppHelloWord
LC_ALL=C keytool -genkey -v -keystore apphelloword-release.keystore -alias apphelloword.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppHelloWord/keytool_input.txt
