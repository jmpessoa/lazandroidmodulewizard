export PATH=/Android/android-sdk/platform-tools:$PATH
export PATH=/Android/android-sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/Android/gradle-4.10.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /svn/apps/inapp5/build/outputs/apk/release/inapp5-release-unsigned.apk c:\svn\apps\inapp5/build/outputs/apk/release/inapp5-release-unsigned-aligned.apk
apksigner sign --ks inapp5-release.keystore --out /svn/apps/inapp5/build/outputs/apk/release/inapp5-release.apk c:\svn\apps\inapp5/build/outputs/apk/release/inapp5-release-unsigned-aligned.apk
