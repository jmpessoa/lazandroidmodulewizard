export PATH=/Users/mantas/AppData/Local/Android/Sdk/platform-tools:$PATH
export PATH=/Users/mantas/AppData/Local/Android/Sdk/build-tools/30.0.3:$PATH
export GRADLE_HOME=/fpcupdeluxe/ccr/lamw-gradle/gradle-6.8.3
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/build/outputs/apk/release/AppBGRABitmapDemo1-armeabi-v7a-release-unsigned.apk /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/build/outputs/apk/release/AppBGRABitmapDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/appbgrabitmapdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/build/outputs/apk/release/AppBGRABitmapDemo1-release.apk /fpcupdeluxe/ccr/lamw/demos/GUI/AppBGRABitmapDemo1/build/outputs/apk/release/AppBGRABitmapDemo1-armeabi-v7a-release-unsigned-aligned.apk
