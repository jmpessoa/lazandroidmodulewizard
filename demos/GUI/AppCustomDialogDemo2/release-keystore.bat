set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\android-neon\eclipse\workspace\AppCustomDialogDemo2
keytool -genkey -v -keystore AppCustomDialogDemo2-release.keystore -alias appcustomdialogdemo2aliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\android-neon\eclipse\workspace\AppCustomDialogDemo2\keytool_input.txt
