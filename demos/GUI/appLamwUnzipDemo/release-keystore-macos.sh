export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo
keytool -genkey -v -keystore applamwunzipdemo-release.keystore -alias applamwunzipdemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo/keytool_input.txt
