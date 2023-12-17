set Path=%PATH%;C:\android\sdkJ11\platform-tools;C:\android\sdkJ11\build-tools\33.0.2
set GRADLE_HOME=C:\android\gradle-7.6.3
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\android\workspace\AppCompatArduinoAflakSerialDemo1\build\outputs\apk\release\AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned.apk C:\android\workspace\AppCompatArduinoAflakSerialDemo1\build\outputs\apk\release\AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks C:\android\workspace\AppCompatArduinoAflakSerialDemo1\appcompatarduinoaflakserialdemo1-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppCompatArduinoAflakSerialDemo1\build\outputs\apk\release\AppCompatArduinoAflakSerialDemo1-release.apk C:\android\workspace\AppCompatArduinoAflakSerialDemo1\build\outputs\apk\release\AppCompatArduinoAflakSerialDemo1-armeabi-v7a-release-unsigned-aligned.apk
