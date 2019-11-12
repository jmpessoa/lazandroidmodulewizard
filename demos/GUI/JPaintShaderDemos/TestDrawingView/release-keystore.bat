set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_221
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd J:\!work\FPC\TestDrawingView
keytool -genkey -v -keystore testdrawingview-release.keystore -alias testdrawingview.keyalias -keyalg RSA -keysize 2048 -validity 10000 < J:\!work\FPC\TestDrawingView\keytool_input.txt
