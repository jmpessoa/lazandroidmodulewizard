export JAVA_HOME=/Program Files (x86)/Java/jdk1.7.0_21
cd /adt32/eclipse/workspace/AppRatingBarDemo1
keytool -genkey -v -keystore AppRatingBarDemo1-release.keystore -alias appratingbardemo1aliaskey -keyalg RSA -keysize 2048 -validity 10000 < /adt32/eclipse/workspace/AppRatingBarDemo1/appratingbardemo1keytool_input.txt
