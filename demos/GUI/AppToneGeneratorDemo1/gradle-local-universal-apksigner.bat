set Path=%PATH%;C:\android\sdkr25\platform-tools;C:\android\sdkr25\build-tools\29.0.3
set GRADLE_HOME=C:\android\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppToneGeneratorDemo1\build\outputs\apk\release\AppToneGeneratorDemo1-universal-release-unsigned.apk C:\android\workspace\AppToneGeneratorDemo1\build\outputs\apk\release\AppToneGeneratorDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\android\workspace\AppToneGeneratorDemo1\apptonegeneratordemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppToneGeneratorDemo1\build\outputs\apk\release\AppToneGeneratorDemo1-release.apk C:\android\workspace\AppToneGeneratorDemo1\build\outputs\apk\release\AppToneGeneratorDemo1-universal-release-unsigned-aligned.apk
