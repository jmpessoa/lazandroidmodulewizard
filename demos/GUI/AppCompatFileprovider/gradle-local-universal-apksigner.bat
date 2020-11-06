set Path=%PATH%;c:\laztoapk\downloads\android-sdk-windows\platform-tools;c:\laztoapk\downloads\android-sdk-windows\build-tools\29.0.3
set GRADLE_HOME=c:\laztoapk\downloads\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppCompactFileprovider\build\outputs\apk\release\AppCompactFileprovider-universal-release-unsigned.apk C:\Temp\AppCompactFileprovider\build\outputs\apk\release\AppCompactFileprovider-universal-release-unsigned-aligned.apk
apksigner sign --ks appcompactfileprovider-release.keystore --out C:\Temp\AppCompactFileprovider\build\outputs\apk\release\AppCompactFileprovider-release.apk C:\Temp\AppCompactFileprovider\build\outputs\apk\release\AppCompactFileprovider-universal-release-unsigned-aligned.apk
