export PATH=/adt32/sdk/platform-tools:$PATH
export PATH=/adt32/sdk/build-tools/28.0.3:$PATH
export GRADLE_HOME=/android/gradle-4.10.2
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppListViewDemo5/build/outputs/apk/release/AppListViewDemo5-release-unsigned.apk C:\android\workspace\AppListViewDemo5/build/outputs/apk/release/AppListViewDemo5-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo5-release.keystore --out /android/workspace/AppListViewDemo5/build/outputs/apk/release/AppListViewDemo5-release.apk C:\android\workspace\AppListViewDemo5/build/outputs/apk/release/AppListViewDemo5-release-unsigned-aligned.apk
