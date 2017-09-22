[readme_get_start.txt]


					
	LAMW: Lazarus Android Module Wizard:

		RAD Android!

	"Get Start" for Windows

Note 1:	Linux:  please, go to lazandroidmodulewizard folder  "...docs\linux" 
	and read: "new_how_to_install_by_renabor.txt"


.Github
	ref. https://github.com/jmpessoa/lazandroidmodulewizard

.Forum
	ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

I. Infrastructure

.Java  sdk_x86 [32 bits]

.Android sdk  
	[Win 32]
	https://dl.google.com/android/repository/sdk-tools-windows-3859397.zip

	[Linux]
	https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

	[Mac]
	https://dl.google.com/android/repository/sdk-tools-darwin-3859397.zip

.Android NDK-r10e

	[win 32] 
	https://dl.google.com/android/repository/android-ndk-r10e-windows-x86.zip
	https://dl.google.com/android/repository/android-ndk-r11c-windows-x86.zip

	[Linux]
	https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip
	https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip

	[Mac]
	https://dl.google.com/android/repository/android-ndk-r10e-darwin-x86_64.zip
	https://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip	

.Laz4Android [Win] [cross Android compiler installed!] 
			http://sourceforge.net/projects/laz4android/files/?source=navbar

	:: OR Lazarus: get canonical/trunk:

		Do It Yourself cross Android compile! [windows]: 			

			After install the LAMW go to:
			1. IDE "Tools" --> "[Lamw] Android Module Wizard" --> "Get FPC Source [Trunk]"
			2. IDE "Tools" --> "[Lamw] Android Module Wizard" --> "Build FPC Cross Android"

.Ant [to build Apk]

	http://ant.apache.org/bindownload.cgi 
	Simply extract the zip file to a convenient location...

.Hint [Lazarus Docked Desktop. Nice!]
	https://github.com/FlKo/LazarusDockedDesktops


II. LAMW:  Lazarus Android Module Wizard

	.Install order.

		tfpandroidbridge_pack.lpk	[..../android_bridges]
		lazandroidwizardpack.lpk	[..../android_wizard]
		amw_ide_tools.lpk		[..../ide_tools]

III. USE

1. Configure Paths:

	Lazarus IDE menu "Tools" ---> "[Lamw] Android Module Wizard" -->  "Path Settings ..."

		ref. http://i.imgur.com/XnTE7Qv.png

2. New Project [thanks to @Developing!]  	

	After install "LAMW" packages and Configured the paths:

	2.1-From Lazarus IDE select "Project" -> "New Project" 
	
		ref. http://i.imgur.com/pESC8py.png

	2.2-From displayed dialog select "Android [GUI] JNI Module [Lamw]" 	

	2.3-Press OK Button.

	2.4. From Form "Android Module wizard: Configure Project..." [Workspace Form]

		ref. http://i.imgur.com/TIhVckB.png

	2.4-Fill/complete the fields:

		"Path to workspace [projects folder]"  

			example: C:\MyLamwProjects

	2.5-Fill/complete the field:

		"New Project Name  [or Selec one]

			example: LamwGUIProject1

			[This is your Android App/Apk name]

	2.6-[MinSdk] Select the  min. Sdk Api to compile your project:

		example: 15

	2.7-[TagetApi] Select the target [api] device

		example: 19

	2.8-Select Architecture/Instruction: 

		example: ARMv6
		
        2.9.Select Android Theme

		example: [DefaultDevice]

	2.9.Click "OK"

	2.10-Save All [unit1.pas] to path that is showed ...

3. From "Android Bridge" component tab drag/drop a jTextView in the "Android Module Form" designer

	set property: 
		PosRelativeToParent  = [rpTop,rpCenterHorizontal]

	WARNING!
		.Please, whenever a dialog prompt, select "Reload from disk"

4. From "Android Bridge" component tab drag/drop a jButton the "Android Module Form" designer

	set property: 
		Anchor = jTextView1
	set property: 
		PosRelativeToAnchor : [raBelow]
	set property:
		PosRelativeToParent = [rpCenter]

	write code for event property "OnClick":
		example: ShowMessage('Hello!')

5.  Lazarus IDE menu "Run" ---> "Build"    

	PANIC? Please, go to:
		III.1. "Configure Paths" and fix its!

6. Connect your Device to Computer [usb] and configure it to "debug mode"     

	"App settings"  ---> more/aditional -- developer options [*]:  

		stay awake  [checked!]
		usb debugging [checked!]
		verify apps via usb [checked!]

	PANIC? Go to Google search with "android usb debugging <device name>" to get the operating mode adapted to your device...
	
		ex. Galaxy S3/S4 --> app settings --> about -->> Build number -->> [tap,tap,tap,...]
        	ex. MI 2 --> app settings --> about -->> MIUI Version -->> [tap,tap,tap,...]

7.Lazarus IDE menu "Run" ---> "[Lamw] Build Apk and Run" [Congratulations!!!]

8.PANIC? Fail to buid "Apk"...

	.Try change project "AndroidManifest.xml" according your Android SDK system installation....

			.<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="17"/>

		.Change your project "build.xml"  according your  Android SDK system installation and "AndroidManifest.xml"

			.<property name="target"  value="android-17"/>			


9. Using/Testing "Demos":  [Please, before try a demo, "do your self" a first "hello" apk!]

	.Lazarus IDE menu --> Open the project *.lpi   [....\jni]
	.Lazarus IDE menu --> Project -->  Project Inspector --> "Unit1.pas"  [etc...]
	.Lazarus IDE menu "Run" ---> "Build"    
	.Lazarus IDE menu "Run" ---> "[Lamw] Build Apk and Run" 

	[Congratulations!!!]

10. NOTE: All LAMW projects [and demos] are Eclipse compatible!

		Thank you!

	by jmpessoa hotmail com


FAQ: [Thanks to Ahmad Bohloolbandi (a.k.a. @developing) ]

#Question: How do we can design a layout that shown same in real device?

[Answer]: You should use the component properties: 

		"Anchor", 
		"PosRelativeToParent", 
		"PosRelativeToAnchor", 
		"LayoutParamHeight", 
		"LayoutParamWhidth" 
          
Example: 

1-Put a "jTextView" component on your AndroidModule form:

	Set "PosRelativeToParent"
		"rpCenterHorizontal" [True]
		"rpTop" [True]

2-Put a "jButton" component on AndroidModule form:

	Set "Anchor" to "jTextView" (Because you should set position relative with "jTextView")
	set "PosRelativeToAnchor"
		"raBelow" [True]

3-Put a "jEditText" component on form:

	Set "Anchor" to "jButton".
	Set "PosRelativeToAnchor"
		"raBelow" [True]

NOTE: 	Anchor setting is most important section of this design, 
	because your component position depends on this property.
	And for change width and/or height of each components you should 
	change/configure "LayoutParamWhidth" and/or "LayoutParamHeight".
