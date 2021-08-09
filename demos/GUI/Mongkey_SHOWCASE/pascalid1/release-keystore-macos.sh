export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /fpcupdeluxe/projects/LAMWProjects/pascalid1
keytool -genkey -v -keystore pascalid1-release.keystore -alias pascalid1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /fpcupdeluxe/projects/LAMWProjects/pascalid1/keytool_input.txt
