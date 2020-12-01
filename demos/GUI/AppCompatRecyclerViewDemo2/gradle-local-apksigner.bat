set Path=%PATH%;C:\adt32\sdk\platform-tools;C:\adt32\sdk\build-tools\27.0.3
set GRADLE_HOME=C:\adt32\gradle-4.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\lamw\workspace\AppCompatRecyclerViewDemo1\build\outputs\apk\release\AppCompatRecyclerViewDemo1-release-unsigned.apk C:\lamw\workspace\AppCompatRecyclerViewDemo1\build\outputs\apk\release\AppCompatRecyclerViewDemo1-release-unsigned-aligned.apk
apksigner sign --ks appcompatrecyclerviewdemo1-release.keystore --out C:\lamw\workspace\AppCompatRecyclerViewDemo1\build\outputs\apk\release\AppCompatRecyclerViewDemo1-release.apk C:\lamw\workspace\AppCompatRecyclerViewDemo1\build\outputs\apk\release\AppCompatRecyclerViewDemo1-release-unsigned-aligned.apk
