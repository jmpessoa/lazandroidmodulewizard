export PATH=/laztoapk/downloads/android-sdk-windows/platform-tools:$PATH
export PATH=/laztoapk/downloads/android-sdk-windows/build-tools/25.0.3:$PATH
export GRADLE_HOME=/laztoapk/downloads/gradle-4.10
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo/build/outputs/apk/release/AppLAMWUnzipDemo-release-unsigned.apk D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo/build/outputs/apk/release/AppLAMWUnzipDemo-release-unsigned-aligned.apk
apksigner sign --ks applamwunzipdemo-release.keystore --out /dev/dev/lazarus/Unzipper/AppLAMWUnzipDemo/build/outputs/apk/release/AppLAMWUnzipDemo-release.apk D:\dev\dev\lazarus\Unzipper\AppLAMWUnzipDemo/build/outputs/apk/release/AppLAMWUnzipDemo-release-unsigned-aligned.apk
