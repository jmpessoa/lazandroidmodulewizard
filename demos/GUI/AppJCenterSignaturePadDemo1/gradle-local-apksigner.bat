set Path=%PATH%;C:\adt32\sdk\platform-tools;C:\adt32\sdk\build-tools\28.0.3
set GRADLE_HOME=C:\android\gradle-4.10.2
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppJCenterSignaturePadDemo1\build\outputs\apk\release\AppJCenterSignaturePadDemo1-release-unsigned.apk C:\android\workspace\AppJCenterSignaturePadDemo1\build\outputs\apk\release\AppJCenterSignaturePadDemo1-release-unsigned-aligned.apk
apksigner sign --ks appjcentersignaturepaddemo1-release.keystore --out C:\android\workspace\AppJCenterSignaturePadDemo1\build\outputs\apk\release\AppJCenterSignaturePadDemo1-release.apk C:\android\workspace\AppJCenterSignaturePadDemo1\build\outputs\apk\release\AppJCenterSignaturePadDemo1-release-unsigned-aligned.apk
