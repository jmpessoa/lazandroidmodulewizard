set Path=%PATH%;c:\laztoapk\downloads\android-sdk-windows\platform-tools;c:\laztoapk\downloads\android-sdk-windows\build-tools\28.0.3
set GRADLE_HOME=c:\laztoapk\downloads\gradle-4.10
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppBrightness\build\outputs\apk\release\AppBrightness-release-unsigned.apk C:\Temp\AppBrightness\build\outputs\apk\release\AppBrightness-release-unsigned-aligned.apk
apksigner sign --ks appbrightness-release.keystore --out C:\Temp\AppBrightness\build\outputs\apk\release\AppBrightness-release.apk C:\Temp\AppBrightness\build\outputs\apk\release\AppBrightness-release-unsigned-aligned.apk
