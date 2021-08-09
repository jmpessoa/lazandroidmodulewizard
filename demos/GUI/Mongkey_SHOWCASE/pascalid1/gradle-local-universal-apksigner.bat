set Path=%PATH%;F:\lamw\android-sdk-windows\platform-tools;F:\lamw\android-sdk-windows\build-tools\30.0.0
set GRADLE_HOME=F:\lamw\gradle-6.9
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 F:\fpcupdeluxe\projects\LAMWProjects\pascalid1\build\outputs\apk\release\pascalid1-universal-release-unsigned.apk F:\fpcupdeluxe\projects\LAMWProjects\pascalid1\build\outputs\apk\release\pascalid1-universal-release-unsigned-aligned.apk
apksigner sign --ks F:\fpcupdeluxe\projects\LAMWProjects\pascalid1\pascalid1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out F:\fpcupdeluxe\projects\LAMWProjects\pascalid1\build\outputs\apk\release\pascalid1-release.apk F:\fpcupdeluxe\projects\LAMWProjects\pascalid1\build\outputs\apk\release\pascalid1-universal-release-unsigned-aligned.apk
