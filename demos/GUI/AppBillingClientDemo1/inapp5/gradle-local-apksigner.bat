set Path=%PATH%;C:\Android\android-sdk\platform-tools;C:\Android\android-sdk\build-tools\29.0.2
set GRADLE_HOME=C:\Android\gradle-4.10.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 c:\svn\apps\inapp5\build\outputs\apk\release\inapp5-release-unsigned.apk c:\svn\apps\inapp5\build\outputs\apk\release\inapp5-release-unsigned-aligned.apk
apksigner sign --ks inapp5-release.keystore --out c:\svn\apps\inapp5\build\outputs\apk\release\inapp5-release.apk c:\svn\apps\inapp5\build\outputs\apk\release\inapp5-release-unsigned-aligned.apk
