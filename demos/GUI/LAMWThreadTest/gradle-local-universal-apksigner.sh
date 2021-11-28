export PATH=/sdk/platform-tools:$PATH
export PATH=/sdk/build-tools/30.0.2:$PATH
export GRADLE_HOME=/gradle-6.9
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /Core/Projs/Android/LAMW/LAMWThreadTest/build/outputs/apk/release/LAMWThreadTest-universal-release-unsigned.apk /Core/Projs/Android/LAMW/LAMWThreadTest/build/outputs/apk/release/LAMWThreadTest-universal-release-unsigned-aligned.apk
apksigner sign --ks /Core/Projs/Android/LAMW/LAMWThreadTest/lamwthreadtest-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /Core/Projs/Android/LAMW/LAMWThreadTest/build/outputs/apk/release/LAMWThreadTest-release.apk /Core/Projs/Android/LAMW/LAMWThreadTest/build/outputs/apk/release/LAMWThreadTest-universal-release-unsigned-aligned.apk
