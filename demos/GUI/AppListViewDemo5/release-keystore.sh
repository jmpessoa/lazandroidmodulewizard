export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppListViewDemo5
keytool -genkey -v -keystore applistviewdemo5-release.keystore -alias applistviewdemo5.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppListViewDemo5/keytool_input.txt
