export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppTableLayoutDemo1
LC_ALL=C keytool -genkey -v -keystore apptablelayoutdemo1-release.keystore -alias apptablelayoutdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppTableLayoutDemo1/keytool_input.txt
