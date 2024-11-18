export PATH=/Android/android-sdk/platform-tools:$PATH
export PATH=/Android/android-sdk/build-tools/29.0.0:$PATH
export GRADLE_HOME=/Android/gradle-4.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Projects/Karat/Xnix/AppWebDAVDemo1/build/outputs/apk/release/AppWebDAVDemo1-armeabi-v7a-release-unsigned.apk /Projects/Karat/Xnix/AppWebDAVDemo1/build/outputs/apk/release/AppWebDAVDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /Projects/Karat/Xnix/AppWebDAVDemo1/appwebdavdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /Projects/Karat/Xnix/AppWebDAVDemo1/build/outputs/apk/release/AppWebDAVDemo1-release.apk /Projects/Karat/Xnix/AppWebDAVDemo1/build/outputs/apk/release/AppWebDAVDemo1-armeabi-v7a-release-unsigned-aligned.apk
