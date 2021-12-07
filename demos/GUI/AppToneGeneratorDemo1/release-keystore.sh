export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppToneGeneratorDemo1
LC_ALL=C keytool -genkey -v -keystore apptonegeneratordemo1-release.keystore -alias apptonegeneratordemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppToneGeneratorDemo1/keytool_input.txt
