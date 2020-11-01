export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppWifiManagerDemo2/build/outputs/apk/release/AppWifiManagerDemo2-universal-release-unsigned.apk C:\android\workspace\AppWifiManagerDemo2/build/outputs/apk/release/AppWifiManagerDemo2-universal-release-unsigned-aligned.apk
apksigner sign --ks appwifimanagerdemo2-release.keystore --out /android/workspace/AppWifiManagerDemo2/build/outputs/apk/release/AppWifiManagerDemo2-release.apk C:\android\workspace\AppWifiManagerDemo2/build/outputs/apk/release/AppWifiManagerDemo2-universal-release-unsigned-aligned.apk
