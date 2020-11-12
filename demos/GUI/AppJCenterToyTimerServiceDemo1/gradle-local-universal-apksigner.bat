set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
set GRADLE_HOME=C:\android\gradle-6.6.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppJCenterToyTimerServiceDemo1\build\outputs\apk\release\AppJCenterToyTimerServiceDemo1-universal-release-unsigned.apk C:\android\workspace\AppJCenterToyTimerServiceDemo1\build\outputs\apk\release\AppJCenterToyTimerServiceDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks appjcentertoytimerservicedemo1-release.keystore --out C:\android\workspace\AppJCenterToyTimerServiceDemo1\build\outputs\apk\release\AppJCenterToyTimerServiceDemo1-release.apk C:\android\workspace\AppJCenterToyTimerServiceDemo1\build\outputs\apk\release\AppJCenterToyTimerServiceDemo1-universal-release-unsigned-aligned.apk
