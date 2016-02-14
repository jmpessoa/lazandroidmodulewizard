How to run your native console app in "Real Device" [ref. http://kevinboone.net/android_native.html] 
 
		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"
 
		NOTE 2: Project settings: Targeg Api = 18 and PIE  not enabled!
 
		NOTE 3: To run in AVD/Emulator, please, "readme_How_To_Run_AVD_Emulator.txt"
 
		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables] enabled: 
 
			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking"
			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below
 
		NOTE 5: Handle the form OnCreate event to start the program's tasks!
 
1. Go to Google Play Store and get "Terminal Emulador" by Jack Palevich [thanks to jack!]
 
2. Connect PC <---> Device via an USB cable  and  copy your program file  "lamwconsoleappdemo1" from project folder "...\libs\armeabi\" to Device folder "Download"
 
3. Go to your Device and run  the app "Terminal Emulador"  and go to internal "Terminal Emulador" storage folder
 
$ cd /data/data/jackpal.androidterm/shared_prefs
 
5. Copy [cat] your program file  "lamwconsoleappdemo1" from Device folder "Download" to internal "Terminal Emulador" storage folder
 
$ cat /sdcard/Download/lamwconsoleappdemo1 > lamwconsoleappdemo1
 
6. Change your program file  "lamwconsoleappdemo1" permission to "executable" mode
 
$ chmod 755 lamwconsoleappdemo1
 
7. Execute your program!
 
$ ./lamwconsoleappdemo1
 
Hello Lamw's World!
 
8. Congratulations !!!!
 
    by jmpessoa_hotmail_com
 
    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation]
