set Path=%PATH%;K:\Android_SDK_NDK\sdk-tools-windows\platform-tools;K:\Android_SDK_NDK\sdk-tools-windows\build-tools\29.0.1
set GRADLE_HOME=K:\FPC_Luxe\gradle-5.5.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\build\outputs\apk\release\AppSpriteDemo-release-unsigned.apk J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\build\outputs\apk\release\AppSpriteDemo-release-unsigned-aligned.apk
apksigner sign --ks appspritedemo-release.keystore --out J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\build\outputs\apk\release\AppSpriteDemo-release.apk J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo\build\outputs\apk\release\AppSpriteDemo-release-unsigned-aligned.apk
