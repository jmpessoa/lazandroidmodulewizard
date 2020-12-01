export PATH=/adt32/sdk/platform-tools:$PATH
export PATH=/adt32/sdk/build-tools/27.0.3:$PATH
export GRADLE_HOME=/adt32/gradle-4.4.1
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /lamw/workspace/AppCompatRecyclerViewDemo1/build/outputs/apk/release/AppCompatRecyclerViewDemo1-release-unsigned.apk C:\lamw\workspace\AppCompatRecyclerViewDemo1/build/outputs/apk/release/AppCompatRecyclerViewDemo1-release-unsigned-aligned.apk
apksigner sign --ks appcompatrecyclerviewdemo1-release.keystore --out /lamw/workspace/AppCompatRecyclerViewDemo1/build/outputs/apk/release/AppCompatRecyclerViewDemo1-release.apk C:\lamw\workspace\AppCompatRecyclerViewDemo1/build/outputs/apk/release/AppCompatRecyclerViewDemo1-release-unsigned-aligned.apk
