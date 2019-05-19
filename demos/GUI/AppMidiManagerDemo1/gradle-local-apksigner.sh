export PATH=/Android/android-sdk/platform-tools:$PATH
export PATH=/Android/android-sdk/build-tools/28.0.3:$PATH
export GRADLE_HOME=/Android/gradle-4.10/
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /SVN/micrologus/Client/Apps/AppMidiManagerDemo1/build/outputs/apk/release/AppMidiManagerDemo1-release-unsigned.apk C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1/build/outputs/apk/release/AppMidiManagerDemo1-release-unsigned-aligned.apk
apksigner sign --ks appmidimanagerdemo1-release.keystore --out /SVN/micrologus/Client/Apps/AppMidiManagerDemo1/build/outputs/apk/release/AppMidiManagerDemo1-release.apk C:\SVN\micrologus\Client\Apps\AppMidiManagerDemo1/build/outputs/apk/release/AppMidiManagerDemo1-release-unsigned-aligned.apk
