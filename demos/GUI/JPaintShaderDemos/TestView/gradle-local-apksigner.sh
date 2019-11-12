export PATH=/Android_SDK_NDK/sdk-tools-windows/platform-tools:$PATH
export PATH=/Android_SDK_NDK/sdk-tools-windows/build-tools/29.0.1:$PATH
export GRADLE_HOME=/FPC_Luxe/gradle-5.5.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /!work/FPC/TestView/build/outputs/apk/release/TestView-release-unsigned.apk J:\!work\FPC\TestView/build/outputs/apk/release/TestView-release-unsigned-aligned.apk
apksigner sign --ks testview-release.keystore --out /!work/FPC/TestView/build/outputs/apk/release/TestView-release.apk J:\!work\FPC\TestView/build/outputs/apk/release/TestView-release-unsigned-aligned.apk
