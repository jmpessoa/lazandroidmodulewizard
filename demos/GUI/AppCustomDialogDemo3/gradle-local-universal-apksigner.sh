export PATH=/android/sdkr25/platform-tools:$PATH
export PATH=/android/sdkr25/build-tools/30.0.2:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppCustomDialogDemo3/build/outputs/apk/release/AppCustomDialogDemo3-universal-release-unsigned.apk /android/workspace/AppCustomDialogDemo3/build/outputs/apk/release/AppCustomDialogDemo3-universal-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppCustomDialogDemo3/appcustomdialogdemo3-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppCustomDialogDemo3/build/outputs/apk/release/AppCustomDialogDemo3-release.apk /android/workspace/AppCustomDialogDemo3/build/outputs/apk/release/AppCustomDialogDemo3-universal-release-unsigned-aligned.apk
