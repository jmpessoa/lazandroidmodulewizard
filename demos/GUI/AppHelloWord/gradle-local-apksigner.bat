set Path=%PATH%;C:\android\sdkr25\platform-tools;C:\android\sdkr25\build-tools\29.0.3
set GRADLE_HOME=C:\android\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppHelloWord\build\outputs\apk\release\AppHelloWord-armeabi-v7a-release-unsigned.apk C:\android\workspace\AppHelloWord\build\outputs\apk\release\AppHelloWord-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks C:\android\workspace\AppHelloWord\apphelloword-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppHelloWord\build\outputs\apk\release\AppHelloWord-release.apk C:\android\workspace\AppHelloWord\build\outputs\apk\release\AppHelloWord-armeabi-v7a-release-unsigned-aligned.apk
