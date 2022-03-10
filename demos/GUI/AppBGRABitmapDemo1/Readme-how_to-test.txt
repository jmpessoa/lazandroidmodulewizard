Instructions how to test the AppBGRABitmapDemo1
by neuro

Ref: 
https://forum.lazarus.freepascal.org/index.php/topic,58624.msg436733/

1) Install BGRABitmap package to Lazarus IDE.


2) Original BGRABitmap package does not compile in Android, thus you need to use patched source code files.
From project subdirectory "!BGRABitmap_fixed_files" take 3 files

bgrafreetype.pas
bgranoguibitmap.pas
bgraopengl.pas

and replace these 3 files in TBGRABitmap package, which are located in directory:
"C:\fpcupdeluxe\ccr\bgrabitmap\bgrabitmap"


3) Add "BGRABitmapPack4NoGUI" to the project "Required Packages".
Go to the menu:
Project -> Project Inspector -> Required Packages -> Add -> BGRABitmapPack4NoGUI -> Ok


4) Run project and press button "Draw BGRABitmap".



February 10, 2022
