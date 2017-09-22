Hi all,

If use LAMW to create APK file, output file be like projectName-debug.apk that mean your APK is in debug mode. 
For solve this problem (for me this is a problem) you must follow below article:

1- Open "build_apk.txt"

2- Change extension of this file from ".txt" to ".bat".

3- Change 2nd line of this file to your project name, in the below line:
      
SET APP_NAME=aProject
      change "aProject" to your project name.

4- Change 3rd line of file to your project path, in the below line:
      
SET ProjectPath=L:\Projects\LAMW\%APP_NAME%
      change "L:\Projects\LAMW" to path of your project folder.

5- Change 4th line of file to path of your Android SDK folder, in the below line:
      
SET ANDROID_HOME=L:\android-sdk
      change "L:\android-sdk" to Android SDK path on your OS.

6-Change 5th line of file to your JDK folder path, in the below line:
      
SET JAVA_HOME=C:\Program Files\Java\jdk1.8.0_31\bin
      change "C:\Program Files\Java\jdk1.8.0_31" to JDK folder path on your OS.

7- Change 6th line of file to target of android version, in the below line:
      
SET APK_SDK_PLATFORM=%ANDROID_HOME%\platforms\android-19
      change "android-19" to your custom version.

8- Change 7th line of file to your version that selected in previous step, in the below line:
      

SET SDK_BUILDTOOLS=19.0.0
      change "19.0.0" to your custom version that selected in previous step.

9- Change 8th line of file to password that you want use it, in the below line:
      
SET PASSWORD=123456
      change "123456" to your custom password.

10- Save this changes and run it.

Enjoy your released APK project. 

I'm Ahmad Bohloolbandi a student from Iran.

Thanks regards.