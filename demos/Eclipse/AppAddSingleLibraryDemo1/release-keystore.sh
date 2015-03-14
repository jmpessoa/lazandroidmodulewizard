export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppAddSingleLibraryDemo1
keytool -genkey -v -keystore AppAddSingleLibraryDemo1-release.keystore -alias appaddsinglelibrarydemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppAddSingleLibraryDemo1/appaddsinglelibrarydemo1keytool_input.txt
