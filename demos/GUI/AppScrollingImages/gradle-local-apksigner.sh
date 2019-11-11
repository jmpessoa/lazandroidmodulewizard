export PATH=/adt32/sdk/platform-tools:$PATH
export PATH=/adt32/sdk/build-tools/28.0.3:$PATH
export GRADLE_HOME=/android/gradle-4.10.2
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppScrollingImages/build/outputs/apk/release/AppScrollingImages-release-unsigned.apk C:\android\workspace\AppScrollingImages/build/outputs/apk/release/AppScrollingImages-release-unsigned-aligned.apk
apksigner sign --ks appscrollingimages-release.keystore --out /android/workspace/AppScrollingImages/build/outputs/apk/release/AppScrollingImages-release.apk C:\android\workspace\AppScrollingImages/build/outputs/apk/release/AppScrollingImages-release-unsigned-aligned.apk
