set Path=%PATH%;C:\Android\android-sdk\platform-tools;C:\Android\android-sdk\build-tools\28.0.3
set GRADLE_HOME=c:\Android\gradle-4.10\
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 C:\SVN\micrologus\Client\Apps\Midi\build\outputs\apk\release\AppMidiManagerDemo1-release-unsigned.apk C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1\build\outputs\apk\release\Midi-release-unsigned-aligned.apk
apksigner sign --ks appmidimanagerdemo1-release.keystore --out C:\SVN\micrologus\Client\Apps\Midi\build\outputs\apk\release\AppMidiManagerDemo1-release.apk C:\SVN\micrologus\Client\Apps\Midi\build\outputs\apk\release\AppMidiManagerDemo1-release-unsigned-aligned.apk
