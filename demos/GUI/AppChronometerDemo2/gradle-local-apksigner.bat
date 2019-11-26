set Path=%PATH%;C:\laztoapk\downloads\android-sdk-windows\platform-tools;C:\laztoapk\downloads\android-sdk-windows\build-tools\28.0.3
set GRADLE_HOME=C:\laztoapk\downloads\gradle-4.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppChronometerDemo2\build\outputs\apk\release\AppChronometerDemo2-release-unsigned.apk C:\Temp\AppChronometerDemo2\build\outputs\apk\release\AppChronometerDemo2-release-unsigned-aligned.apk
apksigner sign --ks appchronometerdemo2-release.keystore --out C:\Temp\AppChronometerDemo2\build\outputs\apk\release\AppChronometerDemo2-release.apk C:\Temp\AppChronometerDemo2\build\outputs\apk\release\AppChronometerDemo2-release-unsigned-aligned.apk
