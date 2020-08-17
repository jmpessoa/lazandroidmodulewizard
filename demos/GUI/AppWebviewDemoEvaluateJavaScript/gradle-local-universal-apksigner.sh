export PATH=/android/sdk/platform-tools:$PATH
export PATH=/android/sdk/build-tools/29.0.2:$PATH
export GRADLE_HOME=/android/gradle-5.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppWebviewDemoEvaluateJavaScript/build/outputs/apk/release/AppWebviewDemoEvaluateJavaScript-universal-release-unsigned.apk C:\android\workspace\AppWebviewDemoEvaluateJavaScript/build/outputs/apk/release/AppWebviewDemoEvaluateJavaScript-universal-release-unsigned-aligned.apk
apksigner sign --ks appwebviewdemoevaluatejavascript-release.keystore --out /android/workspace/AppWebviewDemoEvaluateJavaScript/build/outputs/apk/release/AppWebviewDemoEvaluateJavaScript-release.apk C:\android\workspace\AppWebviewDemoEvaluateJavaScript/build/outputs/apk/release/AppWebviewDemoEvaluateJavaScript-universal-release-unsigned-aligned.apk
