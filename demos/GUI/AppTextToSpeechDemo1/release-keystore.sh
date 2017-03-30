export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppTextToSpeechDemo1
keytool -genkey -v -keystore AppTextToSpeechDemo1-release.keystore -alias apptexttospeechdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppTextToSpeechDemo1/apptexttospeechdemo1keytool_input.txt
