set Path=%PATH%;C:\android\sdkr25\platform-tools;C:\android\sdkr25\build-tools\30.0.2
set GRADLE_HOME=C:\android\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppImageViewRippleEffectDemo1\build\outputs\apk\release\AppImageViewRippleEffectDemo1-universal-release-unsigned.apk C:\android\workspace\AppImageViewRippleEffectDemo1\build\outputs\apk\release\AppImageViewRippleEffectDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\android\workspace\AppImageViewRippleEffectDemo1\appimageviewrippleeffectdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppImageViewRippleEffectDemo1\build\outputs\apk\release\AppImageViewRippleEffectDemo1-release.apk C:\android\workspace\AppImageViewRippleEffectDemo1\build\outputs\apk\release\AppImageViewRippleEffectDemo1-universal-release-unsigned-aligned.apk
