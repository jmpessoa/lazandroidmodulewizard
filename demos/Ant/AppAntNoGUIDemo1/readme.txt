Tutorial: How to get your Android Application [Apk]:
 
1. Double click "build.bat" to build Apk
 
2. If Android Virtual Device[AVD]/Emulator is running then:
   2.1 double click "install.bat" to install the Apk on the Emulator
   2.2 look for the App AppAntNoGUIDemo1 on the Emulator and click it!
 
3. If AVD/Emulator target Api[17] is NOT running:
   3.1 If AVD/Emulator target Api[17] NOT exist:
        3.1.1 double click "paused_create_avd*.bat" to create the AVD [\utils folder]
   3.2 double click "launch_avd*.bat" to launch the Emulator [\utils  folder]
   3.3 look for the App AppAntNoGUIDemo1 on  the Emulator and click it!
 
4. Log/Debug
   4.1 double click "logcat*.bat" to read Emulator logs and bugs! [\utils folder]
 
5. Uninstall Apk
   5.1 double click "uninstall.bat" to remove Apk from the Emulator!
 
6. Look for the Android AppAntNoGUIDemo1-debug.apk in \bin folder!
 
7. Android Asset Packaging Tool: to know which files were packed in AppAntNoGUIDemo1-debug.apk
   7.1 double click "aapt.bat" [\utils folder]
 
8. To see all available Android targets Api [\utils folder]
   8.1 double click "paused_list_target.bat" 
 
9. Hint: you can edit "*.bat" to extend/modify some command or to fix some incorrect path!
 
10. Warning: After Lazarus run->build do not forget to run again: "build.bat" and "install.bat" !
 
....  Thank you!
 
....  by jmpessoa_hotmail_com
