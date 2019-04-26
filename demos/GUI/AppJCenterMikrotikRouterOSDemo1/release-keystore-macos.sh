export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /android/workspace/AppJCenterMikrotikRouterOSDemo1
keytool -genkey -v -keystore appjcentermikrotikrouterosdemo1-release.keystore -alias appjcentermikrotikrouterosdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppJCenterMikrotikRouterOSDemo1/keytool_input.txt
