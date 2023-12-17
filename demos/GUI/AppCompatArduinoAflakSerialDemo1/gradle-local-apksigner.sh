export PATH=/android/sdkJ11/platform-tools:$PATH
export PATH=/android/sdkJ11/build-tools/33.0.2:$PATH
export GRADLE_HOME=/android/gradle-7.6.3
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppCompatArduinoAflakSerialDemo1/build/outputs/apk/release/AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned.apk /android/workspace/AppCompatArduinoAflakSerialDemo1/build/outputs/apk/release/AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppCompatArduinoAflakSerialDemo1/appcompatarduinoaflakserialdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppCompatArduinoAflakSerialDemo1/build/outputs/apk/release/AppCompatArduinoAflakSerialDemo1-release.apk /android/workspace/AppCompatArduinoAflakSerialDemo1/build/outputs/apk/release/AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned-aligned.apk
