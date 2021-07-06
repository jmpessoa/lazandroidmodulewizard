export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppCompatBasicDemo1
keytool -genkey -v -keystore appcompatbasicdemo1-release.keystore -alias appcompatbasicdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppCompatBasicDemo1/keytool_input.txt
