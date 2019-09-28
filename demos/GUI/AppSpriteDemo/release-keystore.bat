set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo
keytool -genkey -v -keystore appspritedemo-release.keystore -alias appspritedemo.keyalias -keyalg RSA -keysize 2048 -validity 10000 < J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\keytool_input.txt
