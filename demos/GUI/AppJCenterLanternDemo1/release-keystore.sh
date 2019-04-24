export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppJCenterLanternDemo1
keytool -genkey -v -keystore appjcenterlanterndemo1-release.keystore -alias appjcenterlanterndemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterLanternDemo1/keytool_input.txt
