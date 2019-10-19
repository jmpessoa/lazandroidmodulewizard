export PATH=/adt32/sdk/platform-tools:$PATH
export PATH=/adt32/sdk/build-tools/28.0.3:$PATH
export GRADLE_HOME=/android/gradle-4.10.2
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppDrawingInBitmap/build/outputs/apk/release/AppDrawingInBitmap-release-unsigned.apk C:\android\workspace\AppDrawingInBitmap/build/outputs/apk/release/AppDrawingInBitmap-release-unsigned-aligned.apk
apksigner sign --ks appdrawinginbitmap-release.keystore --out /android/workspace/AppDrawingInBitmap/build/outputs/apk/release/AppDrawingInBitmap-release.apk C:\android\workspace\AppDrawingInBitmap/build/outputs/apk/release/AppDrawingInBitmap-release-unsigned-aligned.apk
