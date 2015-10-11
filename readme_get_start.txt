[readme_get_start.txt]

Here is a  rapid "get_start" for windows: "Laz4Android + Lazaru Azandroid Module Wizard"

Note 1:	for Linux:  go to " lazandroidmodulewizard folder  "...\linux" 
	and read: "new_how_to_install_by_renabor.txt"

I. Infrastructure

.Java  sdk_x86 [32 bits]

.Android sdk, NDK-r10c

.Laz4Android [All in one!] =

	FPC: 3.1.1 trunk svn 31903 
		-->> win32/arm-android/i386-android/jvm-android
		Note: Need Android NDK: r10e (arm-linux-androideabi-4.9 + x86-4.9)

	Lazarus:1.5 trunk svn 49903
		-->> http://sourceforge.net/projects/laz4android/files/?source=navbar
		:To Install [*.7z], execute "build.bat"

.Android sdk

.Android NDK-r10e   - 	this version is required by "Laz4Android"  [Last update:2015-10-02]
			http://dl.google.com/android/ndk/android-ndk-r10e-windows-x86.exe

.Ant [to build Apk]

	http://ant.apache.org/bindownload.cgi 
	Simply extract the zip file to a convenient location...

.Eclipse is not mandatory!  [but to  facility, all projects [and demos] are Eclipse compatible!]  


II. LAMW:  Lazarus Android Module Wizard

	ref. https://github.com/jmpessoa/lazandroidmodulewizard

	.Install ordem.

		tfpandroidbridge_pack.lpk
		lazandroidwizardpack.lpk
		amw_ide_tools.lpk     [../ide-tools]

III. USE

1. Configure Paths:

	Lazarus IDE menu "Tools" ---> "[Lamw] Android Module Wizard" -->  "Path Settings ..."

2. New Project [thanks to @Developing!]  	

	After install "LAMW" packages:

	2.1-From Lazarus IDE select "Project" -> "New Project" 

	ref. https://jmpessoa.opendrive.com/files?Ml85OTEwMDQ3OV9BRW45VA

	2.2-From displayed dialog  select "JNI Android Module [Lamw GUI]" 	


	2.3-Press OK Button.

	2.4. From form "Android Module wizard: Configure Project..." [Workspace Form]

		ref. https://jmpessoa.opendrive.com/files?Ml85OTEwMDU1Nl9YVE5qUg

	2.4-Fill/complete the field:
		"Path to workspace [project folder]"  
		example c:\LamwProjects

	2.5-Fill/complete the field:
		"New Project Name  [or Selec
		example: MyProject1
		[This is your Android App/Apk name]

	2.6-Select your Sdk [installed] Platform:
		example: Jelly Bean 4.1

	2.7-[MinSdk] Select the  min. Sdk Api to compile your project:
		example: 15

	2.8-[TagetApi] Select the target [api] device
		example: 19

	2.9-Select Instruction: 
		example: ARMv6
		
        2.10. If Arm then Select Fpu:
		example: Soft

	2.11-Save All [unit1.pas] in path that is showed ...

3. From "Android Bridge" component tab drag/drop a jTextView in jForm
		set property: PosRelativeToParent  = [rpTop,rpCenterHorizontal]

4. From "Android Bridge" component tab drag/drop a jButton     in jForm
     set property: Anchor = jTextView1
     set property: PosRelativeToAnchor : [raBelow]
     set property:PosRelativeToParent = [rpCenter]
     write code for event property "OnClick"  =  ShowMessage('Hello!')

5.  Lazarus IDE menu "Run" ---> "Buld"    

6. Connect your Device to Computer [usb] and configure it to "debug mode"     

	"App settings"  ---> more/aditional -- developer options [*]:  
	stay awake  [checked!]
	usb debugging [checked!]
	verify apps via usb [checked!]

	PANIC! Go to Google search with "android usb debugging <device name>" to get the operating mode adapted to your device...
	
	ex. Galaxy S3/S4 --> app settings --> about -->> Build number -->> [tap,tap,tap,...]
        ex. MI 2 --> app settings --> about -->> MIUI Version -->> [tap,tap,tap,...]


7.Lazarus IDE menu "Run" ---> "[Lamw] Build Apk and Run" [Congratulations!!!]

8.PANIC!!! Fail to buid "Apk"

	.Try change project  "AndroidManifest.xml" according your system installation....

		<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="17"/>

		hint: other target:   "android:targetSdkVersion" !!
		
	.Change your project "build.xml"  according your system installation...

		<property name="target"  value="android-17"/>


9. How to configure a Demo to Use/Test:

      .Lazarus IDE menu Open a [*.lpi] Demo Project   [...\jni]

      .Lazarus IDE menu "Tools" ---> "[Lamw] Android Module Wizard" -->  "Change Project [*.lpi] Ndk Path"

      .set your "NDK" path!

      .change/edit project "build.xml"   according your system..

		<property name="sdk.dir" location="C:\adt32\sdk"/>


10. There are some others docs:   

	"install_tutorial.txt" 
   		and
	"install_tutorial_eclipse_users.txt"

Thank you!

by jmpessoa at [josemarquespessoa_gmail_com]

[updated: 08 august 2015]


FAQ: [Thanks to @developing!]

#Question: How do we can design a custom layout that shown same in real device?

[Answer]: You should use: 
		"Anchor", 
		"PosRelativeToParent", 
		"PosRelativeToAnchor", 
		"LayoutParamHeight", 
		"LayoutParamWhidth" 
          
Example: 

1-Put a "jTextView" component on your AndroidModule form.
	Set "PosRelativeToParent"
		"rpCenterHorizontal" [True]
		"rpTop" [True]

2-Put a "jButton" component on AndroidModule form.
	Set "Anchor" to "jTextView" (Because you should set position relative with "jTextView")
	set "PosRelativeToAnchor"
		"raBelow" [True]

3-Put a "jEditText" component on form.
	Set "Anchor" to "jButton".
	Set "PosRelativeToAnchor"
		"raBelow" [True]

NOTE: 	Anchor setting is most important section of this design, 
	because your component position depends on this property.
	And for change width and/or height of each components you should 
	change/configure "LayoutParamWhidth" and/or "LayoutParamHeight".
