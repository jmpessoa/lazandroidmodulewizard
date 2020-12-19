export JAVA_HOME=/Program Files/Java/jdk1.8.0_181
cd /lamw/projects/AppGridColorPickerDemo1
keytool -genkey -v -keystore appgridcolorpickerdemo1-release.keystore -alias appgridcolorpickerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/projects/AppGridColorPickerDemo1/keytool_input.txt
