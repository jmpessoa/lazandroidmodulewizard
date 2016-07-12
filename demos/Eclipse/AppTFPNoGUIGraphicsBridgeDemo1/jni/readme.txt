TFPNoGuiGraphicsBridge

	"A wrapper over Free Pascal fcl-image ref. http://wiki.freepascal.org/fcl-image"

	"FPImage (fcl-image) draw images which won't be displayed in the screen [NoGUI !!!]. 
	A program, for example, running on a webserver without X11 could benefit from 
	not having a visual library as a dependency." ref. http://wiki.freepascal.org/Developing_with_Graphics

version: 0.1 - 18 April - 2015

Author:

	Jose Marques Pessoa

	jmpessoa_hotmail.com

	ref. https://github.com/jmpessoa/tfpnoguigraphicsbridge


Hint: TFPNoGuiGraphicsBridge on Android [Lamw/Lazarus Android Module Wizard project!]

	--->>> Cross compile [Lamw/arm-android] project fail .... NO PANIC!

PANIC I: Compiling ... [please, read lazarus or/as laz4android and ...\fpc\2.7.1 or/as ...\fpc\3.1.1 etc..]

	"(FTFont.PPU and freetype.PPU) units NOT FOUND in "...\lazarus\fpc\2.7.1\units\arm-android\fcl-image" ???

	Solution:

	1. Goto "...\lazarus\fpc\2.7.1\source\packages\fcl-image\src" and copy

		ftfont.pp (if need change to .pas)
		freetype.pp (if need change to .pas)
		freetypeh.pp (if need change to .pas)

		to folder "...\tfpnoguigraphicsbridge" package folder and build AGAIN your project!

		Yes, now you got ftfont.ppu, ftfont.o, freetype.ppu etc... to "arm-android" !

	2. Copy THEM to folder  "...\lazarus\fpc\2.7.1\units\arm-android\fcl-image"
		So, others [future] projects will find its there!  [solved to "arm-android" !!!]

PANIC II: [building Lamw project cross-arm]::

	".... : cannot find -lfreetype"

	Solution:

		Copy "libfreetype.so" to NDK location    "....\platforms\android-XX\arch-arm\usr\lib" 
		where XX = 14 or 15 or 16... or 21 .. etc
		example: put "libfreetype.so" here: "..\ndkplatforms\android-15\arch-arm\usr\lib" 

		For Lamw project you can look for "XX" value in menu: 
		"Project" --->> "Project Options" ---> "Compile Options" -->> "Paths" --->> Libraries [-Fl]

PANIC III. Where I find a "libfreetype.so" for arm-android ?

	Go to demo "...\AppTFPNoGUIGraphicsBridgeDemo1\libs\armeabi" [Eclipse compatible Project]

	You will find an "all ready" there! 

PANIC IV.  Where "libfreetype.so" will be load in java code?

	Go to "Controls.java" [\src\...\..] and uncomment this line:

		--->> System.loadLibrary("freetype");

	The code now will stay that way:

	//Load Pascal Library
	static {   		
      		System.loadLibrary("freetype");  // <<---uncommented here!
      		System.loadLibrary("controls");    		
	}



Thank You!









