export PATH=/Users/user/AppData/Local/Android/Sdk/platform-tools:$PATH
export PATH=/Users/user/AppData/Local/Android/Sdk/build-tools/33.0.0:$PATH
export GRADLE_HOME=/fpcupdeluxe/ccr/lamw-gradle/gradle-6.8.3
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/build/outputs/apk/release/AppColorPickerDemo1-universal-release-unsigned.apk fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/build/outputs/apk/release/AppColorPickerDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/appcolorpickerdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/build/outputs/apk/release/AppColorPickerDemo1-release.apk fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/build/outputs/apk/release/AppColorPickerDemo1-universal-release-unsigned-aligned.apk
