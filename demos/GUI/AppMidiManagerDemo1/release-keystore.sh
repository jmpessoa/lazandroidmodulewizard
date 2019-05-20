export JAVA_HOME=/Android/jdk1.8.0_201
cd /SVN/micrologus/Client/Apps/AppMidiManagerDemo1
keytool -genkey -v -keystore appmidimanagerdemo1-release.keystore -alias appmidimanagerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /SVN/micrologus/Client/Apps/AppMidiManagerDemo1/keytool_input.txt
