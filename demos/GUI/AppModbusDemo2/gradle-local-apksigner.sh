export PATH=/lamw/android-sdk-windows/platform-tools:$PATH
export PATH=/lamw/android-sdk-windows/build-tools/31.0.0:$PATH
export GRADLE_HOME=/fpcupdeluxe/ccr/lamw-gradle/gradle-6.8.3
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /lamw/latihan/modbus/build/outputs/apk/release/modbus-armeabi-v7a-release-unsigned.apk /lamw/latihan/modbus/build/outputs/apk/release/modbus-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /lamw/latihan/modbus/modbus-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /lamw/latihan/modbus/build/outputs/apk/release/modbus-release.apk /lamw/latihan/modbus/build/outputs/apk/release/modbus-armeabi-v7a-release-unsigned-aligned.apk
