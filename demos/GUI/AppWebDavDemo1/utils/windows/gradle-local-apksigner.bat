set Path=%PATH%;C:\Android\android-sdk\platform-tools;C:\Android\android-sdk\build-tools\29.0.0
set GRADLE_HOME=C:\Android\gradle-4.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\Projects\Karat\Xnix\AppWebDAVDemo1\build\outputs\apk\release\AppWebDAVDemo1-armeabi-v7a-release-unsigned.apk C:\Projects\Karat\Xnix\AppWebDAVDemo1\build\outputs\apk\release\AppWebDAVDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks C:\Projects\Karat\Xnix\AppWebDAVDemo1\appwebdavdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\Projects\Karat\Xnix\AppWebDAVDemo1\build\outputs\apk\release\AppWebDAVDemo1-release.apk C:\Projects\Karat\Xnix\AppWebDAVDemo1\build\outputs\apk\release\AppWebDAVDemo1-armeabi-v7a-release-unsigned-aligned.apk
