export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/28.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.10
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppAjustScreen/build/outputs/apk/release/AppAjustScreen-release-unsigned.apk C:\Temp\AppAjustScreen/build/outputs/apk/release/AppAjustScreen-release-unsigned-aligned.apk
apksigner sign --ks appajustscreen-release.keystore --out /Temp/AppAjustScreen/build/outputs/apk/release/AppAjustScreen-release.apk C:\Temp\AppAjustScreen/build/outputs/apk/release/AppAjustScreen-release-unsigned-aligned.apk
