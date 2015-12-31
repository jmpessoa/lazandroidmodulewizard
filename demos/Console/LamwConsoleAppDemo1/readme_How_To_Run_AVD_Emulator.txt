How to Run your native console App in "AVD/Emulator"
 
		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"
 
		NOTE 2: Project settings: Targeg Api = 18 and PIE  not enabled!
 
		NOTE 3: To run in a real device, please, "readme_How_To_Run_Real_Device.txt" [ref. http://kevinboone.net/android_native.html] 
 
		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables]: 
 
			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking" 
			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below 
 
		NOTE 5: Handle the form OnCreate event to start the program's tasks!
 
1. Execute the AVD/Emulator 
 
2. Execute the  "cmd"  terminal [windows] 
 
3. Go to folder  ".../skd/platform-tools"  and run the adb shell  [note: "-e" ---> emulator ... and "-d" ---> device] 
 
adb -e shell 
 
4. Create a new dir/folder "tmp" in  "/sdcard" 
 
cd /sdcard 
 
mkdir tmp 
 
exit 
 
5. Copy your program file  "lamwconsoleappdemo1" from project folder "...\libs\armeabi\" to Emulator "/sdcard/tmp" 
 
adb push C:\adt32\workspace\LamwConsoleAppDemo1\libs\armeabi\lamwconsoleappdemo1  /sdcard/tmp/lamwconsoleappdemo1
 
6. go to "adb shell" again 
 
adb -e shell. 
 
7. Go to folder "/sdcard/tmp" 
 
root@android:/ # cd /sdcard/tmp 
 
8. Now copy your programa file "lamwconsoleappdemo1" to an executable place 
 
root@android:/sdcard/tmp # cp lamwconsoleappdemo1 /data/local/tmp/lamwconsoleappdemo1
 
9. Go to folder /data/local/tmp and Change permission to run executable 
 
root@android:/ # cd /data/local/tmp
root@android:/data/local/tmp # chmod 755 lamwconsoleappdemo1
 
10. Execute your program! 
 
root@android:/data/local/tmp # ./lamwconsoleappdemo1
 
Hello Lamw's World!
 
11. Congratulations !!!! 
 
    by jmpessoa_hotmail_com
 
    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation] 
