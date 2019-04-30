export JAVA_HOME=/Program Files/Java/jdk1.8.0_151/
cd /laztoapk/projects/project1/AppListViewDemo2
keytool -genkey -v -keystore applistviewdemo2-release.keystore -alias applistviewdemo2.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /laztoapk/projects/project1/AppListViewDemo2/keytool_input.txt
