set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\Temp\AppJNIException
keytool -genkey -v -keystore appjniexception-release.keystore -alias appjniexception.keyalias -keyalg RSA -keysize 2048 -validity 10000 < C:\Temp\AppJNIException\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
