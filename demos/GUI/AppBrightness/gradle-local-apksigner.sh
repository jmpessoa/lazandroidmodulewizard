export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/28.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.10
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppBrightness/build/outputs/apk/release/AppBrightness-release-unsigned.apk C:\Temp\AppBrightness/build/outputs/apk/release/AppBrightness-release-unsigned-aligned.apk
apksigner sign --ks appbrightness-release.keystore --out /Temp/AppBrightness/build/outputs/apk/release/AppBrightness-release.apk C:\Temp\AppBrightness/build/outputs/apk/release/AppBrightness-release-unsigned-aligned.apk
