export PATH=/Android_SDK_NDK/sdk-tools-windows/platform-tools:$PATH
export PATH=/Android_SDK_NDK/sdk-tools-windows/build-tools/29.0.1:$PATH
export GRADLE_HOME=/FPC_Luxe/gradle-5.5.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo/build/outputs/apk/release/AppSpriteDemo-release-unsigned.apk J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo/build/outputs/apk/release/AppSpriteDemo-release-unsigned-aligned.apk
apksigner sign --ks appspritedemo-release.keystore --out /!work/FPC/demos/GUI/AppSpriteDemo/AppSpriteDemo/build/outputs/apk/release/AppSpriteDemo-release.apk J:\!work\FPC\demos\GUI\AppSpriteDemo\AppSpriteDemo/build/outputs/apk/release/AppSpriteDemo-release-unsigned-aligned.apk
