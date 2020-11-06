export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/29.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppCompactFileprovider/build/outputs/apk/release/AppCompactFileprovider-release-unsigned.apk C:\Temp\AppCompactFileprovider/build/outputs/apk/release/AppCompactFileprovider-release-unsigned-aligned.apk
apksigner sign --ks appcompactfileprovider-release.keystore --out /Temp/AppCompactFileprovider/build/outputs/apk/release/AppCompactFileprovider-release.apk C:\Temp\AppCompactFileprovider/build/outputs/apk/release/AppCompactFileprovider-release-unsigned-aligned.apk
