
	Lazarus Android Module Wizard 
		
	"A wizard for create JNI Android loadable module (.so) in Lazarus/Free Pascal using DataModule like form" 

	Author: Jose Marques Pessoa : jmpessoa__hotmail_com

		https://github.com/jmpessoa/lazandroidmodulewizard
		http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

	Acknowledgements: 
              
		-Eny and Phil for the Project wizard hints...
		http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823
		-Felipe for the Android support...
		-TrueTom for the Laz4Android Package
			https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149
			Warning: laz4android1.1-41139 work just for win32 and  Android NDK-7c and ARM
 			NEW! win32/Android NDK-9/{ARM and x86 !} :: Thanks again to TrueTom!
			https://sourceforge.net/projects/laz4android/files/?source=navbar 
      		-Simonsayz for the great work on Android [GUI] Controls
			http://forum.lazarus.freepascal.org/index.php/topic,22079.0.html

			-warning:	
				.We use a modified and expanded version of Simonsayz's "Controls.java" 
				.We use a modified and expanded version of Simonsayz's "App.java" 

		-x2nie for Lazarus 1.3 patch [No LCL form design!] 
			http://github.com/x2nie/LiteZarus


		NEW! LiteZarus4Android [just for Windows, sorry] :: win32/Android NDK-9/{ARM and x86 !}
			https://onedrive.live.com/redir?resid=78D6F726E8F0C522%21236 [right to download!]

		NEW! Laz4Android [by TrueTom]
			Date:2014-10-18
			FPC: 2.7.1 SVN 28863  win32/arm-android/i386-android/jvm-android
			Lazarus:1.3 trunk svn 46592
			Android NDK: r10c (arm-linux-androideabi-4.6 + x86-4.6)
			http://sourceforge.net/projects/laz4android/files/?source=navbar
                                
		-Lazarus forum community!

Version 0.6 - rev. 03 - 22 October 2014 -

UNDOES rev. 02: a new approach/solution for missing ".so" in Lazarus rev < 46598 [just windows!] 
FIX the [absolut] output file paths! [Thanks to Stephano!]

NEW! Simplifies navigation in dialog 2: "select java source"


Version 0.6 - rev. 02 - 20 October 2014 -

NEW! [Dialog config paths ...] Add Checkbox to configure output files path 
NEW! [Dialog config paths ...] Add Checkbox to add ".so" suffix

Version 0.6 - rev. 01 - 20 October 2014 -

NEW! Added Support to Laz4Android [by TrueTom]: 
		Lazarus:1.3 trunk svn 46592 +  
		FPC: 2.7.1 SVN 28863  win32/arm-android/i386-android/jvm-android
		http://sourceforge.net/projects/laz4android/files/?source=navbar

Version 0.6 - 15 October 2014 -

	1. NEW !!

		-->> Android Widgets Fom Designer! //<<--- thanks to LiteZarus by x2nie! 

                      form1 design : https://jmpessoa.opendrive.com/files?Ml82NTQ0NDMxNl9CV292dg
                      form1 Screen : https://jmpessoa.opendrive.com/files?Ml82NTQ0NDM2OV9SUVJ1NA

                      form2 design : https://jmpessoa.opendrive.com/files?Ml82NTQ0Nzk5N19RbXFjVw
                      form2 Screen : https://jmpessoa.opendrive.com/files?Ml82NTQ0NzQ3NF9wMGhHcQ

		-->> Windows Users: Get LiteZarus4Android [Lazarus 1.3 + x2nie patch [No LCLform design] + TrueTom fpc 2.7.1 cross Arm/x86/android/]

			:DOWNLOAD from: https://onedrive.live.com/redir?resid=78D6F726E8F0C522%21236 [right to download!]
			:To Install, please, read the "LiteZarus4Android_readme.txt"


			1. From LiteZarus4Android IDE - Install Wizard Packages

			1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"  [Android Components Bridges!]
				Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

			1.1.1 From Package Wizard
				- Compile
				- Use -> Install
 			1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
   			1.2.1 From Package Wizard
				- Compile
				- Use -> Install     

			HINT: to compile/install/reinstall a package in LiteZarus4Android,
				please, open a "dummy" windows project.... you always MUST close the cross compile project!  
			
		-->> Linux Users: Get Lazarus 1.3 rev >= 45216,45217 ... and fpc 2.7.1 cross /arm/x86/android ... etc.
     

	2. NEW !! 

		-->> AppTest1 [eclipse project] :: jPanel and form close/callback demo...

		-->> AppTest2 [eclipse project]::Present direct/hack JNI access and a new component implementation
						model "laz_and_jni_controls.pas" [not java wrapper at all!] 
						[--->> A suggestion and request by Stephano]
                    
		-->> AppAntDemo1 [Ant project] was adjusted/updated !  
		-->> All Apps Demos [Eclipse projects] was adjusted/updated !  
		-->> All project now support Ant "build.*" "intall.*" etc..
			:warning: if needed change this files according to your system! 	

	3. Guide line for "Old" Projects [Collateral Effects]

		-->> Some TAndroidModule Form properties was supressed!
                -->> Some jComponents properties was supressed!

			Please, no panic! When prompt "Read error" [Unknown Property] just choice "Continue Loading" !

		-->> Components conteiners behavior [jPanel e jScrollView] :  remove and put [again] yours controls into them!
                 
		-->> Now adjust yours widgets, the concept continue the same: 

			.LayoutParamWidth/LayoutParamHeight
			.Anchor
			.PosRelativeToAnchor
			.PosRelativeToParent

			WARNING: android's "wildcards" [WrapContent and lpMatchParent] overlaps the design vision!
					and more: if this properties values are achieved the "Object Inspector" will "freeze"
					this value! To "unfreeze" not just change by design, you will need
					change the value in OI by hand to any other value, so it will adjust correctly! 

		-->> Add new "AndroidWidget" unit to uses clauses [*.dpr/*.pas]

	4. How to use the Demos:

		Change this information to correct one!

		"C:\adt32\ndk7"   -- just my system NDK path
		"C:\adt32\eclipse\workspace"  -- just my system eclipse workspace 

		1. Go to Lazarus IDE

			->Project

			->Project -> Option

			->Path

			change/modify paths according to your system ..

			-->Others

			change/modify paths according to your system ..

		2. If needed: open/edit the "controls.lpi" [...\jni],  you can use Notepad like editor....

		Modify some [piece] of path information like:

		[C:\adt32\eclipse\workspace] 
		[C:\adt32\ndk7]

		according to your system ..
	                                
	5.FIXs [BUGS]    

		-->> The form *.lfm parse now is OK !!!

		---> jListView bug fix[check/not checkd] 
			and new added properties: "HighLightSelectedItem" [True/False] and "HighLightSelectedItemColor" 
			                          
Version 0.5 - rev. 03 - 17 august 2014 -
	:: New jLocation Component: Add Partial Support for Location Object //<<---- A suggestion and request by Fatih KILIÇ
	:: New jPreference Component: Add Partial Support for Preferences Object //<<---- A suggestion and request by Fatih KILIÇ
	:: NEW AppLocationDemo [Eclipse Project] 

Version 0.5 - rev. 02 - 14 june 2014 -

	:: New Add Partial Support for Spinner Object //<<---- A suggestion and request by Leledumbo
	:: NEW AppSpinerDemo [Eclipse Project] 
	:: NEW AppSListViewDemo [Eclipse Project] :: fix RadioButton behavior...//<<---- A suggestion and request by Leledumbo
	:: Warning: Bluetooth support yet unfinished! [BUG?]!

Version 0.5 - rev. 01 - 06 May 2014 -
	:: NEW Add Partial Support for Menu Object [Option Menu/SubMenu and Context Menu]! 
	:: NEW jMenu Component [Android Bridges EXtra]
	:: NEW AppMenuDemo [Eclipse Project]

Version 0.5 - 05 May 2014 -
	:: NEW Add Component Create Wizard!
		:: It Now offers two new aid/assistance to increase the productivity of coding.

		1.You can now produce a almost complete pascal component code from a java wrapper class!
		2.You can now get assistance for produce the java warapper class!
		:: Please, read "fast_tutorial_jni_bridges_component_create.txt"

	:: New Components[Android Bridges Extra] and Demos [Eclipse Projects]: 

		jMyHello	[AppTryCode1] 
		jMediaPlayer	[AppTryCode2]
 
		jTextFileManager, jDumpJavaMethods [AppTryCode3]
 

version 0.4 - revision: 05 - 02 March - 2014 -
	:: Added NEW method GetText to jListView [and minor bug fix]
	:: Update [Eclipse] AppDemo1 [List View Demo]

version 0.4 - revision: 04 - 01 March - 2014 -
	:: New Add Custom Row Support to jListView
	:: Update [Eclipse] AppDemo1 [List View Demo]

version 0.4 - revision: 03 - 19 February - 2014 -
	:: New Add Image/BLOB Support to SQLite: jSqliteDataAccess, jSqliteCursor

version 0.4 - revision: 02 - 17 February - 2014 - Minor update...

version 0.4 - revision: 01 - 16 February - 2014 -
	:: New Add [Partial] Support to SQLite: jSqliteDataAccess, jSqliteCursor
		Supported FIELD_TYPE: [INTEGER, STRING, FLOAT] 
        ::New Eclipse project demo:  AppSqliteDemo1

version 0.4 - 08 February - 2014 -
 	:: NEW! Add Support for Android API > 13. 
         	1.A new code architecture! 
		2.A lot of code lines was fix/changed/Add!
	:: Fix BackButton issue. Now all Forms close correctly. [See AppDemo1]  	
	
	:: warning: compatibility issue:  
       		1. jForm: 
			no more has the property "BackButton". 
			no more has the property "MainActivity".

                  	[Indeed, now there is property "ActivityMode": (actMain, actSplash, actDisposable, actRecyclable)]
			Please,  edit/modify you *.lfm before loading your old project 

                                        
		2. jEditText: no more has the property "SingleLine". 
			Please,  edit/modify you *.lfm before loading your old project 
		3. jView: the Canvas property  now is a component property. 
			Please, drop the new jCanvas component and set/configure it.[See AppDemo1]
	:: known issues: 
		jEditText1: the "InputTypeEx" property at the moment is just "dummy". 
			Indeed, it is hard coded as "itxMultiLine", others values crash app! Why? 
            
	:: The [Projects] Demos were updated. 

	:: known issues: 
		AppDemo1: jCanvasES2 demo: [2D an 3D]: the draw disappear on the [second] button click after the BackButton pressed...
                                            

version 0.3 - revision 0.3 - 30 December 2013 -
	:: New! Add Option to Select Android Platform 

version 0.3 - revision 0.2 - 29 December 2013 -
	:: New! Support for Linux! Thanks to Leledumbo! 
		by Leledumbo for Linux users:
		1. Build all libraries in the  ../LazAndroidWizard/linux/dummylibs
		2. Put it somewhere ldconfig can find (or just run ldconfig with their directories as arguments)

		"The idea of this is just to make the package installable in the [Lazarus for Linux] IDE,
			applications will still use the android version of the libraries."
  
		ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.msg137216/topicseen.html
       

version 0.3 - revision 0.1 - 28 December 2013 -
 	:: New! Introduces Support for multi build modes [ArmV6, ArmV7a, x86]
                
version 0.3 - 22 December 2013 
	:: NEW! Introduces Support to Ant Project  

version 0.2 - 14 December 2013 -
	:: NEW! Introduces Android [GUI] Android Components Bridges - Based on Simonsayz's controls 

version 0.1 - revision 0.1 - 09 September - 2013 -	 
	:: Bugs fixs!

version 0.1 - August 2013 -
	:: Warning: at the moment this code is just a *proof-of-concept*
      
I. INSTALL LiteZarus4Android 

	-->> Windows Users: Get LiteZarus4Android [Lazarus 1.3 + x2nie patch [No LCLform design] + TrueTom fpc 2.7.1 cross Arm/x86/android/]

		:DOWNLOAD from: https://onedrive.live.com/redir?resid=78D6F726E8F0C522%21236 [right to download!]
		:To Install, please, read the "LiteZarus4Android_readme.txt"
			
	-->> Linux Users: Get Lazarus 1.3 rev >= 45216,45217 ... and fpc 2.7.1 cross /arm/x86/android ... etc.

		
	1. From LiteZarus4Android IDE - Install Wizard Packages

	1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"  [Android Components Bridges!]
		Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

	1.1.1 From Package Wizard
		- Compile
		- Use -> Install
 	1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
   	1.2.1 From Package Wizard
		- Compile
		- Use -> Install               
II.  Ant Projec Development: please, read "fast_tutorial_ant_users.txt"

III. Eclipse Project Development: please, read "fast_tutorial_eclipse_users.txt"

IV. Technical Notes: dependencies on laz4android [win32] IDE cross compiler: 
    
	--> About Package, Components, LCL  and NDK libs: *.so 

1. About Package creation: just LCLBase is permitted! not "LCL"! 
	- You will nedd  LCLBase Required Package for register procedure.
	- yes, other No GUI stuff is permitted.

2. Abou Component creation
   
	2.1. If you will use custom icon then you will need two files: the first to compoment(s) code
		and the second for Register procedure code.

        example:

	2.1.1. File 1 - foo.pas - component code - here no LCL dependency at all!

	unit foo;

	{$mode objfpc}{$H+}

	interface	

	uses
	  Classes, SysUtils;

	type

	TFoo = class(TComponent)
  	private
	{ Private declarations }
	protected
	{ Protected declarations }
	public
	{ Public declarations }
	published
	{ Published declarations }
	end;


	implementation

  
	end.
        
	2.1.2. File 2 - regtfoo.pas - register component code -  here you will nedd LCLBase for LResources unit

	unit regtfoo;

	{$mode objfpc}{$H+}

	interface

	uses
		Classes, SysUtils, LResources {nedded for custom icon loading...}; 

	Procedure Register;

	implementation

	Procedure Register;
	begin
		{$I tfoo_icon.lrs}  //you custom icon
		RegisterComponents('Android Bridges',[TFoo);
	end;

	initialization

	end.   

	:: [Edited 04-May-2014] :: WARNING:  Please, read the  NEW "fast_tutorial_jni_bridges_component_create.txt" - 

3. About NDK libs (.so) dependency on laz4android [win32] IDE cross compiler
     
3.1.  You will need two files: the first to NDK *.so lib interface and the second for you component/unit code.

	Example:
	
	3.1.1. File 1 - "And_log_h.pas" - the header interface file
 	
	unit And_log_h;
	{$mode delphi}

	interface

	const libname='liblog.so';

  	ANDROID_LOG_UNKNOWN=0;
      	ANDROID_LOG_DEFAULT=1;
      	ANDROID_LOG_VERBOSE=2;
      	ANDROID_LOG_DEBUG=3;
      	ANDROID_LOG_INFO=4;
      	ANDROID_LOG_WARN=5;
      	ANDROID_LOG_ERROR=6;
      	ANDROID_LOG_FATAL=7;
      	ANDROID_LOG_SILENT=8;

	type
	android_LogPriority=integer;
  
	function __android_log_write(prio:longint; tag,text: pchar):longint; cdecl; external libname name '__android_log_write';

	implementation

	end.

	3.1.2. File 2 - "And_log.pas" - component/unit code

	unit And_log;

	interface

	uses	And_log_h;  // <-- here is the link/bind to NDK lib

	jLog = class(jControls)
        
        end;

	jLog  = class(jControl)
  	private
	{ Private declarations }
	protected
	{ Protected declarations }

	public
	{Public declarations }

          procedures wLog(msg: pchar);  // << ----------- dependency!

	published
	{ Published declarations }
	end;

	implementation

	procedure jLog.WLog(msg: pchar);
	begin
     	    __android_log_write(ANDROID_LOG_FATAL,'crap',msg);  // << ---------- dependency!
	end;

	end.

V. Ref. Lazarus forum: http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

     -Help and Hints
     -Bugs : {known bug: fail on Api > 13. Temporary solution: a workaround to prevent Api > 13 - 02 jan 2014}
     -Sugestions 
     -Colaborations	
     -Critics
     -Roadmap
     -etc..

VI. The work is just beginning!

VII. Thank you!

    _____jmpessoa_hotmail_com_____
