export PATH=/android/sdkr25/platform-tools:$PATH
export PATH=/android/sdkr25/build-tools/29.0.3:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-armeabi-v7a-release-unsigned.apk /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppHelloWord/apphelloword-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-release.apk /android/workspace/AppHelloWord/build/outputs/apk/release/AppHelloWord-armeabi-v7a-release-unsigned-aligned.apk
