export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1
keytool -genkey -v -keystore appcolorpickerdemo1-release.keystore -alias appcolorpickerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/keytool_input.txt
