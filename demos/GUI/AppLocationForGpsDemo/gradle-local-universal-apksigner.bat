set Path=%PATH%;D:\lamw_manager\LAMW\sdk\platform-tools;D:\lamw_manager\LAMW\sdk\build-tools\30.0.3
set GRADLE_HOME=D:\lamw_manager\LAMW\gradle-4.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo\build\outputs\apk\release\AppLocationForGpsDemo-universal-release-unsigned.apk C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo\build\outputs\apk\release\AppLocationForGpsDemo-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo\applocationforgpsdemo-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo\build\outputs\apk\release\AppLocationForGpsDemo-release.apk C:\Users\mali.aydin\Desktop\Lazarus_Jni\AppLocationForGpsDemo\build\outputs\apk\release\AppLocationForGpsDemo-universal-release-unsigned-aligned.apk
