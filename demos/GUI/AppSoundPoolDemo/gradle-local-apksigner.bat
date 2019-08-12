set Path=%PATH%;C:\laztoapk\downloads\android-sdk-windows\platform-tools;C:\laztoapk\downloads\android-sdk-windows\build-tools\28.0.3
set GRADLE_HOME=C:\laztoapk\downloads\gradle-4.10
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppSoundPoolDemo\build\outputs\apk\release\AppSoundPoolDemo-release-unsigned.apk C:\Temp\AppSoundPoolDemo\build\outputs\apk\release\AppSoundPoolDemo-release-unsigned-aligned.apk
apksigner sign --ks appsoundpooldemo-release.keystore --out C:\Temp\AppSoundPoolDemo\build\outputs\apk\release\AppSoundPoolDemo-release.apk C:\Temp\AppSoundPoolDemo\build\outputs\apk\release\AppSoundPoolDemo-release-unsigned-aligned.apk
