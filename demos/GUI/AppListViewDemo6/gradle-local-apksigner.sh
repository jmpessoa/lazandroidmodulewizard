export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-5.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppListViewDemo6/build/outputs/apk/release/AppListViewDemo6-release-unsigned.apk C:\android\workspace\AppListViewDemo6/build/outputs/apk/release/AppListViewDemo6-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo6-release.keystore --out /android/workspace/AppListViewDemo6/build/outputs/apk/release/AppListViewDemo6-release.apk C:\android\workspace\AppListViewDemo6/build/outputs/apk/release/AppListViewDemo6-release-unsigned-aligned.apk
