export PATH=/adt32/sdk/platform-tools:$PATH
export PATH=/adt32/sdk/build-tools/28.0.3:$PATH
export GRADLE_HOME=/android/gradle-4.10.2
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /android/workspace/AppMSSQLJDBCConnectionDemo1/build/outputs/apk/release/AppMSSQLJDBCConnectionDemo1-release-unsigned.apk C:\android\workspace\AppMSSQLJDBCConnectionDemo1/build/outputs/apk/release/AppMSSQLJDBCConnectionDemo1-release-unsigned-aligned.apk
apksigner sign --ks appmssqljdbcconnectiondemo1-release.keystore --out /android/workspace/AppMSSQLJDBCConnectionDemo1/build/outputs/apk/release/AppMSSQLJDBCConnectionDemo1-release.apk C:\android\workspace\AppMSSQLJDBCConnectionDemo1/build/outputs/apk/release/AppMSSQLJDBCConnectionDemo1-release-unsigned-aligned.apk
