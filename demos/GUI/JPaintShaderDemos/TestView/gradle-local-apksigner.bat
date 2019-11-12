set Path=%PATH%;K:\Android_SDK_NDK\sdk-tools-windows\platform-tools;K:\Android_SDK_NDK\sdk-tools-windows\build-tools\29.0.1
set GRADLE_HOME=K:\FPC_Luxe\gradle-5.5.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 J:\!work\FPC\TestView\build\outputs\apk\release\TestView-release-unsigned.apk J:\!work\FPC\TestView\build\outputs\apk\release\TestView-release-unsigned-aligned.apk
apksigner sign --ks testview-release.keystore --out J:\!work\FPC\TestView\build\outputs\apk\release\TestView-release.apk J:\!work\FPC\TestView\build\outputs\apk\release\TestView-release-unsigned-aligned.apk
