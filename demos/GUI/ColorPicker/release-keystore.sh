export JAVA_HOME=/Program Files/Java/jdk1.8.0_91
cd /lamw/projects//ColorPicker
keytool -genkey -v -keystore ColorPicker-release.keystore -alias colorpickeraliaskey -keyalg RSA -keysize 2048 -validity 10000 < /lamw/projects//ColorPicker/colorpickerkeytool_input.txt
