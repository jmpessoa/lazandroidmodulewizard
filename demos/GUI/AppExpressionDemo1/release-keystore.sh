export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppExpressionDemo1
keytool -genkey -v -keystore appexpressiondemo1-release.keystore -alias appexpressiondemo1.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppExpressionDemo1/keytool_input.txt
