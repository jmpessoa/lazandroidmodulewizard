set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\android\workspace\AppDrawingInBitmap
keytool -genkey -v -keystore appdrawinginbitmap-release.keystore -alias appdrawinginbitmap.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\android\workspace\AppDrawingInBitmap\keytool_input.txt
