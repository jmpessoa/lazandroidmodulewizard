export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppQRGenDemo1
keytool -genkey -v -keystore appqrgendemo1-release.keystore -alias appqrgendemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppQRGenDemo1/keytool_input.txt
