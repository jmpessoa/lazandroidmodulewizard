export PATH=/lamw/android-sdk-windows/platform-tools:$PATH
export PATH=/lamw/android-sdk-windows/build-tools/30.0.0:$PATH
export GRADLE_HOME=/lamw/gradle-6.9
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /fpcupdeluxe/projects/LAMWProjects/pascalid1/build/outputs/apk/release/pascalid1-armeabi-v7a-release-unsigned.apk /fpcupdeluxe/projects/LAMWProjects/pascalid1/build/outputs/apk/release/pascalid1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /fpcupdeluxe/projects/LAMWProjects/pascalid1/pascalid1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /fpcupdeluxe/projects/LAMWProjects/pascalid1/build/outputs/apk/release/pascalid1-release.apk /fpcupdeluxe/projects/LAMWProjects/pascalid1/build/outputs/apk/release/pascalid1-armeabi-v7a-release-unsigned-aligned.apk
