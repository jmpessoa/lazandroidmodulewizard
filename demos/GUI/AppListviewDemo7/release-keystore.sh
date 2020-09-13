export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppListviewDemo7
keytool -genkey -v -keystore applistviewdemo7-release.keystore -alias applistviewdemo7.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppListviewDemo7/keytool_input.txt
