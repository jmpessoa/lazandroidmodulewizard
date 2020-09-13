export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-5.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppListviewDemo7/build/outputs/apk/release/AppListviewDemo7-universal-release-unsigned.apk C:\android\workspace\AppListviewDemo7/build/outputs/apk/release/AppListviewDemo7-universal-release-unsigned-aligned.apk
apksigner sign --ks applistviewdemo7-release.keystore --out /android/workspace/AppListviewDemo7/build/outputs/apk/release/AppListviewDemo7-release.apk C:\android\workspace\AppListviewDemo7/build/outputs/apk/release/AppListviewDemo7-universal-release-unsigned-aligned.apk
