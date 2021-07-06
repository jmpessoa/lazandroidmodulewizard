export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppCompatBasicDemo1/build/outputs/apk/release/AppCompatBasicDemo1-armeabi-v7a-release-unsigned.apk /android/workspace/AppCompatBasicDemo1/build/outputs/apk/release/AppCompatBasicDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppCompatBasicDemo1/appcompatbasicdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppCompatBasicDemo1/build/outputs/apk/release/AppCompatBasicDemo1-release.apk /android/workspace/AppCompatBasicDemo1/build/outputs/apk/release/AppCompatBasicDemo1-armeabi-v7a-release-unsigned-aligned.apk
