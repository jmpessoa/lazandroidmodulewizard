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


Hint: Cross compile/linking [arm-android] project fail .... NO PANIC!

PANIC I: Compiling Fail! ... [please, read:
					"lazarus" <==> "laz4android" and 
					"...\fpc\2.7.1" <==> "...\fpc\3.1.1" ]

	"(FTFont.PPU and freetype.PPU) units NOT FOUND in "...\lazarus\fpc\2.7.1\units\arm-android\fcl-image" ???

	Solution:

	1. Goto "...\lazarus\fpc\2.7.1\source\packages\fcl-image\src" and copy

		ftfont.pp 
		freetype.pp 
		freetypeh.pp 

		to "...\tfpnoguigraphicsbridge" package folder and build AGAIN your project!

		Yes, now you got ftfont.ppu, ftfont.o, freetype.ppu etc... to "arm-android" !

	2. Copy THEM to folder  "...\lazarus\fpc\2.7.1\units\arm-android\fcl-image"
		So, others [future] projects will find its there!  [solved to "arm-android" !!!]

PANIC II: Linking Fail !! [building a Lamw project cross-arm]::

	".... : cannot find -lfreetype"

	Solution:

		Copy "libfreetype.so" 
					FROM: project folder "..\libs\armeabi" 
					TO: NDK location "....\platforms\android-XX\arch-arm\usr\lib" 

		where XX = 14 or 15 or 16... or 21 .. etc

		For "Lamw"  demo projects you can look for "XX" value here: 
		"Project" --->> "Project Options" ---> "Compile Options" -->> "Paths" --->> Libraries [-Fl]
		example: put "libfreetype.so" here: "..\ndkplatforms\android-15\arch-arm\usr\lib" 

		For "Lamw"  demo project you can look for "XX" value in menu: 
		"Project" --->> "Project Options" ---> "Compile Options" -->> "Paths" --->> Libraries [-Fl]

PANIC III. Where can I find a "libfreetype.so" for arm-android ?

	Go to "..\demos\Eclipse\AppTFPNoGUIGraphicsBridgeDemo6\libs\armeabi"

	You will find a "libfreetype.so" there! 

PANIC IV.  Where "libfreetype.so" will be load in java code?

	Go to "Controls.java" [\src\...\..] and uncomment this lines:

        try {
    	  System.loadLibrary("freetype");  // <<-------------------
        } catch (UnsatisfiedLinkError e) {
          Log.e("JNI_Load_LibFreetype", "exception", e);
       }


Thank You!