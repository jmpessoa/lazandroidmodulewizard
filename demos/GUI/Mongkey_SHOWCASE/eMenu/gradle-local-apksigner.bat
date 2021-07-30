set Path=%PATH%;F:\lamw\android-sdk-windows\platform-tools;F:\lamw\android-sdk-windows\build-tools\30.0.0
set GRADLE_HOME=F:\lamw\gradle-6.9
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 F:\lamw\latihan\eMenu\build\outputs\apk\release\eMenu-armeabi-v7a-release-unsigned.apk F:\lamw\latihan\eMenu\build\outputs\apk\release\eMenu-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks F:\lamw\latihan\eMenu\emenu-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out F:\lamw\latihan\eMenu\build\outputs\apk\release\eMenu-release.apk F:\lamw\latihan\eMenu\build\outputs\apk\release\eMenu-armeabi-v7a-release-unsigned-aligned.apk
