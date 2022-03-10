set Path=%PATH%;C:\Users\mantas\AppData\Local\Android\Sdk\platform-tools;C:\Users\mantas\AppData\Local\Android\Sdk\build-tools\30.0.3
set GRADLE_HOME=C:\fpcupdeluxe\ccr\lamw-gradle\gradle-6.8.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1\build\outputs\apk\release\AppBGRABitmapDemo1-universal-release-unsigned.apk C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1\build\outputs\apk\release\AppBGRABitmapDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1\appbgrabitmapdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1\build\outputs\apk\release\AppBGRABitmapDemo1-release.apk C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppBGRABitmapDemo1\build\outputs\apk\release\AppBGRABitmapDemo1-universal-release-unsigned-aligned.apk
