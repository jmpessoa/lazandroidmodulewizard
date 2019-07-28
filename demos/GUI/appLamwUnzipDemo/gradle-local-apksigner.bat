set Path=%PATH%;d:\laztoapk\downloads\android-sdk-windows\platform-tools;d:\laztoapk\downloads\android-sdk-windows\build-tools\25.0.3
set GRADLE_HOME=d:\laztoapk\downloads\gradle-4.10
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\build\outputs\apk\release\AppLAMWUnzipDemo-release-unsigned.apk D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\build\outputs\apk\release\AppLAMWUnzipDemo-release-unsigned-aligned.apk
apksigner sign --ks applamwunzipdemo-release.keystore --out D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\build\outputs\apk\release\AppLAMWUnzipDemo-release.apk D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo\build\outputs\apk\release\AppLAMWUnzipDemo-release-unsigned-aligned.apk
