Tutorial: How to get your Android Application [Apk] using "Ant":

1. Double click "build-debug.bat  [.sh]" to build Apk

2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:
   2.1 double click "install.bat" to install the Apk on the Emulator [or real device]
   2.2 look for the App "AppSMSDemo1" in the Emulator [or real device] and click it!

3. If AVD/Emulator is NOT running:
   3.1 If AVD/Emulator NOT exist:
        3.1.1 double click "paused_create_avd_default.bat" to create the AVD [\utils folder]
   3.2 double click "launch_avd_default.bat" to launch the Emulator [\utils  folder]
   3.3 look for the App "AppSMSDemo1" in the Emulator and click it!

4. Log/Debug
   4.1 double click "logcat*.bat" to read logs and bugs! [\utils folder]

5. Uninstall Apk
   5.1 double click "uninstall.bat" to remove Apk from the Emulator [or real device]!

6. To find your Apk look for the "AppSMSDemo1-debug.apk" in \bin folder!

7. Android Asset Packaging Tool: to know which files were packed in "AppSMSDemo1-debug.apk"
   7.1 double click "aapt.bat" [\utils folder]

8. To see all available Android targets in your system [\utils folder]
   8.1 double click "paused_list_target.bat" 

9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!

10.Hint 2: you can edit "build.xml" to set another Android target. ex. "android-18" or "android-19" etc.
   WARNING: Yes, if after run  "build.*" the folder "...\bin" is still empty then try another target!
   WARNING: If you changed the target in "build.xml" change it in "AndroidManifest.xml" too!

11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "build.bat" and "install.bat" !

12. Linux users: use "build.sh" , "install.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]
    WARNING: All demos Apps was generate on my windows system! So, please,  edit its to correct paths...!

13. WARNING, before to execute "build-release.bat [.sh]"  you need execute "release.keystore.bat [.sh]"!
    Please, read "readme-keytool-input.txt!"

14. Please, for more info, look for "How to use the Demos" in "Laz Android Module Wizard" readme.txt!!

....  Thank you!

....  by jmpessoa_hotmail_com

System Path to Android SDK=C:\adt32\sdk
System Path to Android NDK=C:\adt32\ndk10e
