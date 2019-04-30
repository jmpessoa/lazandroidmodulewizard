set Path=%PATH%;c:\laztoapk\downloads\android-sdk-windows\platform-tools;c:\laztoapk\downloads\android-sdk-windows\build-tools\28.0.3
set GRADLE_HOME=C:\laztoapk\downloads\gradle-4.10
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\laztoapk\projects\project1\AppListViewDemo2\build\outputs\apk\release\AppListViewDemo2-release-unsigned.apk C:\laztoapk\projects\project1\AppListViewDemo2\build\outputs\apk\release\AppListViewDemo2-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo2-release.keystore --out C:\laztoapk\projects\project1\AppListViewDemo2\build\outputs\apk\release\AppListViewDemo2-release.apk C:\laztoapk\projects\project1\AppListViewDemo2\build\outputs\apk\release\AppListViewDemo2-release-unsigned-aligned.apk
