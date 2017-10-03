set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_91
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\lamw\projects\\ColorPicker
keytool -genkey -v -keystore ColorPicker-release.keystore -alias colorpickeraliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\lamw\projects\\ColorPicker\keytool_input.txt
