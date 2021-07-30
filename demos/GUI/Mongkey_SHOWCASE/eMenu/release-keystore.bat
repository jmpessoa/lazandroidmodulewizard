set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_251
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd F:\lamw\latihan\eMenu
keytool -genkey -v -keystore emenu-release.keystore -alias emenu.keyalias -keyalg RSA -keysize 2048 -validity 10000 < F:\lamw\latihan\eMenu\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
