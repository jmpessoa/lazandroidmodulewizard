export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-5.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppQRGenDemo1/build/outputs/apk/release/AppQRGenDemo1-universal-release-unsigned.apk C:\android\workspace\AppQRGenDemo1/build/outputs/apk/release/AppQRGenDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks appqrgendemo1-release.keystore --out /android/workspace/AppQRGenDemo1/build/outputs/apk/release/AppQRGenDemo1-release.apk C:\android\workspace\AppQRGenDemo1/build/outputs/apk/release/AppQRGenDemo1-universal-release-unsigned-aligned.apk
