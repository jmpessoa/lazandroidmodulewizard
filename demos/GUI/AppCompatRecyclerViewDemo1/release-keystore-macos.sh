export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/workspace/AppCompatRecyclerViewDemo1
keytool -genkey -v -keystore appcompatrecyclerviewdemo1-release.keystore -alias appcompatrecyclerviewdemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /lamw/workspace/AppCompatRecyclerViewDemo1/keytool_input.txt
