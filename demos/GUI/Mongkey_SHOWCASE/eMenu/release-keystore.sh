export JAVA_HOME=/Program Files/Java/jdk1.8.0_251
cd /lamw/latihan/eMenu
keytool -genkey -v -keystore emenu-release.keystore -alias emenu.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/latihan/eMenu/keytool_input.txt
