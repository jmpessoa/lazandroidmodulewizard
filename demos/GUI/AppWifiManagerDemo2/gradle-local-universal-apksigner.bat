set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
set GRADLE_HOME=C:\android\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppWifiManagerDemo2\build\outputs\apk\release\AppWifiManagerDemo2-universal-release-unsigned.apk C:\android\workspace\AppWifiManagerDemo2\build\outputs\apk\release\AppWifiManagerDemo2-universal-release-unsigned-aligned.apk
apksigner sign --ks appwifimanagerdemo2-release.keystore --out C:\android\workspace\AppWifiManagerDemo2\build\outputs\apk\release\AppWifiManagerDemo2-release.apk C:\android\workspace\AppWifiManagerDemo2\build\outputs\apk\release\AppWifiManagerDemo2-universal-release-unsigned-aligned.apk
