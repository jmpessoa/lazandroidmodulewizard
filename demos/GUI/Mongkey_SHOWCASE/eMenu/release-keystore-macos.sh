export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/latihan/eMenu
keytool -genkey -v -keystore emenu-release.keystore -alias emenu.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/latihan/eMenu/keytool_input.txt
