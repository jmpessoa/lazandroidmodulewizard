export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppChronometerDemo1
keytool -genkey -v -keystore AppChronometerDemo1-release.keystore -alias appchronometerdemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppChronometerDemo1/appchronometerdemo1keytool_input.txt
