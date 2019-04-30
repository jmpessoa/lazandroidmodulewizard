export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/28.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.10
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /laztoapk/projects/project1/AppListViewDemo2/build/outputs/apk/release/AppListViewDemo2-release-unsigned.apk C:\laztoapk\projects\project1\AppListViewDemo2/build/outputs/apk/release/AppListViewDemo2-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo2-release.keystore --out /laztoapk/projects/project1/AppListViewDemo2/build/outputs/apk/release/AppListViewDemo2-release.apk C:\laztoapk\projects\project1\AppListViewDemo2/build/outputs/apk/release/AppListViewDemo2-release-unsigned-aligned.apk
