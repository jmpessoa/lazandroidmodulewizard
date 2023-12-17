set Path=%PATH%;C:\android\sdkJ11\platform-tools;C:\android\sdkJ11\build-tools\33.0.2
set GRADLE_HOME=C:\android\gradle-7.6.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppTextViewVerticalScrolling\build\outputs\apk\release\AppTextViewVerticalScrolling-universal-release-unsigned.apk C:\android\workspace\AppTextViewVerticalScrolling\build\outputs\apk\release\AppTextViewVerticalScrolling-universal-release-unsigned-aligned.apk
apksigner sign --ks C:\android\workspace\AppTextViewVerticalScrolling\apptextviewverticalscrolling-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppTextViewVerticalScrolling\build\outputs\apk\release\AppTextViewVerticalScrolling-release.apk C:\android\workspace\AppTextViewVerticalScrolling\build\outputs\apk\release\AppTextViewVerticalScrolling-universal-release-unsigned-aligned.apk
