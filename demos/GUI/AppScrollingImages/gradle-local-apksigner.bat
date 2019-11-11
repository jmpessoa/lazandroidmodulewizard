set Path=%PATH%;C:\adt32\sdk\platform-tools;C:\adt32\sdk\build-tools\28.0.3
set GRADLE_HOME=C:\android\gradle-4.10.2
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppScrollingImages\build\outputs\apk\release\AppScrollingImages-release-unsigned.apk C:\android\workspace\AppScrollingImages\build\outputs\apk\release\AppScrollingImages-release-unsigned-aligned.apk
apksigner sign --ks appscrollingimages-release.keystore --out C:\android\workspace\AppScrollingImages\build\outputs\apk\release\AppScrollingImages-release.apk C:\android\workspace\AppScrollingImages\build\outputs\apk\release\AppScrollingImages-release-unsigned-aligned.apk
