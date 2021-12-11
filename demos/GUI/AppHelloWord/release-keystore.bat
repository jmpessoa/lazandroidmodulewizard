set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\android\workspace\AppHelloWord
LC_ALL=C keytool -genkey -v -keystore apphelloword-release.keystore -alias apphelloword.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\android\workspace\AppHelloWord\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
