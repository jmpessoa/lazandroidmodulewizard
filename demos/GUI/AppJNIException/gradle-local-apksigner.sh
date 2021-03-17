export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/29.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppJNIException/build/outputs/apk/release/AppJNIException-armeabi-v7a-release-unsigned.apk /Temp/AppJNIException/build/outputs/apk/release/AppJNIException-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /Temp/AppJNIException/appjniexception-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /Temp/AppJNIException/build/outputs/apk/release/AppJNIException-release.apk /Temp/AppJNIException/build/outputs/apk/release/AppJNIException-armeabi-v7a-release-unsigned-aligned.apk
