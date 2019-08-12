export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/28.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.10
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Temp/AppSoundPoolDemo/build/outputs/apk/release/AppSoundPoolDemo-release-unsigned.apk C:\Temp\AppSoundPoolDemo/build/outputs/apk/release/AppSoundPoolDemo-release-unsigned-aligned.apk
apksigner sign --ks appsoundpooldemo-release.keystore --out /Temp/AppSoundPoolDemo/build/outputs/apk/release/AppSoundPoolDemo-release.apk C:\Temp\AppSoundPoolDemo/build/outputs/apk/release/AppSoundPoolDemo-release-unsigned-aligned.apk
