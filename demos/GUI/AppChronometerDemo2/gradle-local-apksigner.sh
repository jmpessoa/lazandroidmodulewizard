export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/28.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppChronometerDemo2/build/outputs/apk/release/AppChronometerDemo2-release-unsigned.apk C:\Temp\AppChronometerDemo2/build/outputs/apk/release/AppChronometerDemo2-release-unsigned-aligned.apk
apksigner sign --ks appchronometerdemo2-release.keystore --out /Temp/AppChronometerDemo2/build/outputs/apk/release/AppChronometerDemo2-release.apk C:\Temp\AppChronometerDemo2/build/outputs/apk/release/AppChronometerDemo2-release-unsigned-aligned.apk
