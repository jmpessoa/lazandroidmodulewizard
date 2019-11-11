export JAVA_HOME=/Program Files/Java/jdk1.8.0_151
cd /android/workspace/AppScrollingImages
keytool -genkey -v -keystore appscrollingimages-release.keystore -alias appscrollingimages.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /android/workspace/AppScrollingImages/keytool_input.txt
