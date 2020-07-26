set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
set GRADLE_HOME=C:\android\gradle-5.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppBarcodeGenDemo1\build\outputs\apk\release\AppBarcodeGenDemo1-release-unsigned.apk C:\android\workspace\AppBarcodeGenDemo1\build\outputs\apk\release\AppBarcodeGenDemo1-release-unsigned-aligned.apk
apksigner sign --ks appbarcodegendemo1-release.keystore --out C:\android\workspace\AppBarcodeGenDemo1\build\outputs\apk\release\AppBarcodeGenDemo1-release.apk C:\android\workspace\AppBarcodeGenDemo1\build\outputs\apk\release\AppBarcodeGenDemo1-release-unsigned-aligned.apk
