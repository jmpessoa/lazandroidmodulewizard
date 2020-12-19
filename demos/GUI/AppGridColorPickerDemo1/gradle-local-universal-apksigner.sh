export PATH=/lamw/SDK/platform-tools:$PATH
export PATH=/lamw/SDK/build-tools/29.0.0:$PATH
export GRADLE_HOME=/lamw/gradle-6.6.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /lamw/projects/AppGridColorPickerDemo1/build/outputs/apk/release/AppGridColorPickerDemo1-universal-release-unsigned.apk D:\lamw\projects\AppGridColorPickerDemo1/build/outputs/apk/release/AppGridColorPickerDemo1-universal-release-unsigned-aligned.apk
apksigner sign --ks appgridcolorpickerdemo1-release.keystore --out /lamw/projects/AppGridColorPickerDemo1/build/outputs/apk/release/AppGridColorPickerDemo1-release.apk D:\lamw\projects\AppGridColorPickerDemo1/build/outputs/apk/release/AppGridColorPickerDemo1-universal-release-unsigned-aligned.apk
