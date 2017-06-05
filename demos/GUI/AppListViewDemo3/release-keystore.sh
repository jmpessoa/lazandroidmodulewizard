export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /android-neon/eclipse/workspace/AppListViewDemo3
keytool -genkey -v -keystore AppListViewDemo3-release.keystore -alias applistviewdemo3aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /android-neon/eclipse/workspace/AppListViewDemo3/applistviewdemo3keytool_input.txt
