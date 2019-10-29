set Path=%PATH%;c:\laztoapk\downloads\android-sdk-windows\platform-tools;c:\laztoapk\downloads\android-sdk-windows\build-tools\28.0.3
set GRADLE_HOME=c:\laztoapk\downloads\gradle-4.10
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppAjustScreen\build\outputs\apk\release\AppAjustScreen-release-unsigned.apk C:\Temp\AppAjustScreen\build\outputs\apk\release\AppAjustScreen-release-unsigned-aligned.apk
apksigner sign --ks appajustscreen-release.keystore --out C:\Temp\AppAjustScreen\build\outputs\apk\release\AppAjustScreen-release.apk C:\Temp\AppAjustScreen\build\outputs\apk\release\AppAjustScreen-release-unsigned-aligned.apk
