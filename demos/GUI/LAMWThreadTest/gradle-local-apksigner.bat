set Path=%PATH%;C:\sdk\platform-tools;C:\sdk\build-tools\30.0.2
set GRADLE_HOME=C:\gradle-6.9
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Core\Projs\Android\LAMW\LAMWThreadTest\build\outputs\apk\release\LAMWThreadTest-armeabi-v7a-release-unsigned.apk C:\Core\Projs\Android\LAMW\LAMWThreadTest\build\outputs\apk\release\LAMWThreadTest-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks C:\Core\Projs\Android\LAMW\LAMWThreadTest\lamwthreadtest-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\Core\Projs\Android\LAMW\LAMWThreadTest\build\outputs\apk\release\LAMWThreadTest-release.apk C:\Core\Projs\Android\LAMW\LAMWThreadTest\build\outputs\apk\release\LAMWThreadTest-armeabi-v7a-release-unsigned-aligned.apk
