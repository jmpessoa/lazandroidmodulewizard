export PATH=/android/sdkr25/platform-tools:$PATH
export PATH=/android/sdkr25/build-tools/29.0.3:$PATH
export GRADLE_HOME=/android/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppPublicFoldersAccessDemo1/build/outputs/apk/release/AppPublicFoldersAccessDemo1-armeabi-v7a-release-unsigned.apk /android/workspace/AppPublicFoldersAccessDemo1/build/outputs/apk/release/AppPublicFoldersAccessDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /android/workspace/AppPublicFoldersAccessDemo1/apppublicfoldersaccessdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppPublicFoldersAccessDemo1/build/outputs/apk/release/AppPublicFoldersAccessDemo1-release.apk /android/workspace/AppPublicFoldersAccessDemo1/build/outputs/apk/release/AppPublicFoldersAccessDemo1-armeabi-v7a-release-unsigned-aligned.apk
