set Path=%PATH%;C:\Users\user\AppData\Local\Android\Sdk\platform-tools;C:\Users\user\AppData\Local\Android\Sdk\build-tools\33.0.0
set GRADLE_HOME=C:\fpcupdeluxe\ccr\lamw-gradle\gradle-6.8.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppColorPickerDemo1\build\outputs\apk\release\AppColorPickerDemo1-universal-release-unsigned.apk C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppColorPickerDemo1\build\outputs\apk\release\AppColorPickerDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppColorPickerDemo1\appcolorpickerdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppColorPickerDemo1\build\outputs\apk\release\AppColorPickerDemo1-release.apk C:\fpcupdeluxe\ccr\lamw\demos\GUI\AppColorPickerDemo1\build\outputs\apk\release\AppColorPickerDemo1-universal-release-unsigned-aligned.apk
