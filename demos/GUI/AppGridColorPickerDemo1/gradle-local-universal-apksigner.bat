set Path=%PATH%;D:\lamw\SDK\platform-tools;D:\lamw\SDK\build-tools\29.0.0
set GRADLE_HOME=D:\lamw\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 D:\lamw\projects\AppGridColorPickerDemo1\build\outputs\apk\release\AppGridColorPickerDemo1-universal-release-unsigned.apk D:\lamw\projects\AppGridColorPickerDemo1\build\outputs\apk\release\AppGridColorPickerDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks appgridcolorpickerdemo1-release.keystore --out D:\lamw\projects\AppGridColorPickerDemo1\build\outputs\apk\release\AppGridColorPickerDemo1-release.apk D:\lamw\projects\AppGridColorPickerDemo1\build\outputs\apk\release\AppGridColorPickerDemo1-universal-release-unsigned-aligned.apk
