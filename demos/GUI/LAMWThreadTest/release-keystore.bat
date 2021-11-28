set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_25
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Core\Projs\Android\LAMW\LAMWThreadTest
keytool -genkey -v -keystore lamwthreadtest-release.keystore -alias lamwthreadtest.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Core\Projs\Android\LAMW\LAMWThreadTest\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
