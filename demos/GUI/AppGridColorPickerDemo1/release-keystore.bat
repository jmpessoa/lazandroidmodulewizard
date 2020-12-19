set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_181
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd D:\lamw\projects\AppGridColorPickerDemo1
if exist "appgridcolorpickerdemo1-release.keystore" goto Error
keytool -genkey -v -keystore appgridcolorpickerdemo1-release.keystore -alias appgridcolorpickerdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < D:\lamw\projects\AppGridColorPickerDemo1\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
