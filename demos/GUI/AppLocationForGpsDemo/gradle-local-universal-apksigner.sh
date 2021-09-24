export PATH=/lamw_manager/LAMW/sdk/platform-tools:$PATH
export PATH=/lamw_manager/LAMW/sdk/build-tools/30.0.3:$PATH
export GRADLE_HOME=/lamw_manager/LAMW/gradle-4.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/build/outputs/apk/release/AppLocationForGpsDemo-universal-release-unsigned.apk /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/build/outputs/apk/release/AppLocationForGpsDemo-universal-release-unsigned-aligned.apk
apksigner sign --ks /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/applocationforgpsdemo-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/build/outputs/apk/release/AppLocationForGpsDemo-release.apk /Users/mali.aydin/Desktop/Lazarus_Jni/AppLocationForGpsDemo/build/outputs/apk/release/AppLocationForGpsDemo-universal-release-unsigned-aligned.apk
