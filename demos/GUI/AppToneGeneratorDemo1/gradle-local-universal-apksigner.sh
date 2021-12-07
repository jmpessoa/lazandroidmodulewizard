export PATH=/android/sdkr25/platform-tools:$PATH
export PATH=/android/sdkr25/build-tools/29.0.3:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppToneGeneratorDemo1/build/outputs/apk/release/AppToneGeneratorDemo1-universal-release-unsigned.apk /android/workspace/AppToneGeneratorDemo1/build/outputs/apk/release/AppToneGeneratorDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppToneGeneratorDemo1/apptonegeneratordemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppToneGeneratorDemo1/build/outputs/apk/release/AppToneGeneratorDemo1-release.apk /android/workspace/AppToneGeneratorDemo1/build/outputs/apk/release/AppToneGeneratorDemo1-universal-release-unsigned-aligned.apk
