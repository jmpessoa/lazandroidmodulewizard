export PATH=/lamw/android-sdk-windows/platform-tools:$PATH
export PATH=/lamw/android-sdk-windows/build-tools/30.0.0:$PATH
export GRADLE_HOME=/lamw/gradle-6.9
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /lamw/latihan/eMenu/build/outputs/apk/release/eMenu-universal-release-unsigned.apk /lamw/latihan/eMenu/build/outputs/apk/release/eMenu-universal-release-unsigned-aligned.apk
apksigner sign --ks /lamw/latihan/eMenu/emenu-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /lamw/latihan/eMenu/build/outputs/apk/release/eMenu-release.apk /lamw/latihan/eMenu/build/outputs/apk/release/eMenu-universal-release-unsigned-aligned.apk
