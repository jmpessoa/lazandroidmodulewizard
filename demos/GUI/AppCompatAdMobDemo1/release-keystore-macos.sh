export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCompatAdMobDemo1
keytool -genkey -v -keystore AppCompatAdMobDemo1-release.keystore -alias appcompatadmobdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppCompatAdMobDemo1/appcompatadmobdemo1keytool_input.txt
