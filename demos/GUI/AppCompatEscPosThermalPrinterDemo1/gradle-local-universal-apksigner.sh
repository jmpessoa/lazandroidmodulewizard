export PATH=/android/sdkr25/platform-tools:$PATH
export PATH=/android/sdkr25/build-tools/30.0.2:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppCompatEscPosThermalPrinterDemo1/build/outputs/apk/release/AppCompatEscPosThermalPrinterDemo1-universal-release-unsigned.apk /android/workspace/AppCompatEscPosThermalPrinterDemo1/build/outputs/apk/release/AppCompatEscPosThermalPrinterDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppCompatEscPosThermalPrinterDemo1/appcompatescposthermalprinterdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppCompatEscPosThermalPrinterDemo1/build/outputs/apk/release/AppCompatEscPosThermalPrinterDemo1-release.apk /android/workspace/AppCompatEscPosThermalPrinterDemo1/build/outputs/apk/release/AppCompatEscPosThermalPrinterDemo1-universal-release-unsigned-aligned.apk
