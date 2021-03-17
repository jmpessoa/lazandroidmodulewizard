set Path=%PATH%;c:\laztoapk\downloads\android-sdk-windows\platform-tools;c:\laztoapk\downloads\android-sdk-windows\build-tools\29.0.3
set GRADLE_HOME=c:\laztoapk\downloads\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Temp\AppJNIException\build\outputs\apk\release\AppJNIException-universal-release-unsigned.apk C:\Temp\AppJNIException\build\outputs\apk\release\AppJNIException-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\Temp\AppJNIException\appjniexception-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\Temp\AppJNIException\build\outputs\apk\release\AppJNIException-release.apk C:\Temp\AppJNIException\build\outputs\apk\release\AppJNIException-universal-release-unsigned-aligned.apk
