set Path=%PATH%;E:\lamw\android-sdk-windows\platform-tools;E:\lamw\android-sdk-windows\build-tools\31.0.0
set GRADLE_HOME=E:\fpcupdeluxe\ccr\lamw-gradle\gradle-6.8.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 E:\lamw\latihan\modbus\build\outputs\apk\release\modbus-armeabi-v7a-release-unsigned.apk E:\lamw\latihan\modbus\build\outputs\apk\release\modbus-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks E:\lamw\latihan\modbus\modbus-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out E:\lamw\latihan\modbus\build\outputs\apk\release\modbus-release.apk E:\lamw\latihan\modbus\build\outputs\apk\release\modbus-armeabi-v7a-release-unsigned-aligned.apk
