set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
set GRADLE_HOME=C:\android\gradle-5.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppListviewDemo7\build\outputs\apk\release\AppListviewDemo7-release-unsigned.apk C:\android\workspace\AppListviewDemo7\build\outputs\apk\release\AppListviewDemo7-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo7-release.keystore --out C:\android\workspace\AppListviewDemo7\build\outputs\apk\release\AppListviewDemo7-release.apk C:\android\workspace\AppListviewDemo7\build\outputs\apk\release\AppListviewDemo7-release-unsigned-aligned.apk
