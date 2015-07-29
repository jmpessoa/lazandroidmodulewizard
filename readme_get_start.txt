

Here is a  rapid "get_start" for windows: "Laz4Android + lazandroidmodulewizard"

Note 1:	for Linux:  go to " lazandroidmodulewizard folder  "...\linux" 
	and read: "new_how_to_install_by_renabor.txt"

I. Infrastructure

.Java  sdk_x86 [32 bits]

.Android sdk, NDK-r10c

.Laz4Android [All in one!] =
	FPC: 3.1.1 trunk svn 29987 
		--->>win32/arm-android/i386-android/jvm-android 
			Note: required: NDK: r10c (arm-linux-androideabi-4.6 + x86-4.6)                               

	Lazarus:1.5  trunk svn 47987 
		http://sourceforge.net/projects/laz4android/files/?source=navbar :
		To Install [*.7z], please, read the "Laz4Android_readme.txt"

.Android sdk

.Android ndk-r10c   -  this version is required by "Laz4Android"  
		http://dl.google.com/android/ndk/android-ndk-r10c-windows-x86.exe

.Ant [to build Apk]
	http://ant.apache.org/bindownload.cgi 
	Simply extract the zip file to a convenient location...

.Eclipse is not mandatory!  [but to  facility, the Demos projects are Eclipse compatible!]  

II. LAMW:  Lazarus Android Module Wizard

	ref. https://github.com/jmpessoa/lazandroidmodulewizard

	.Install ordem.

		tfpandroidbridge_pack.lpk
		lazandroidwizardpack.lpk
		amw_ide_tools.lpk     [../ide-tools]

	.USE.

	1. Configure Paths:

	Lazarus IDE menu "Tools" ---> "[Lamw] Android Module Wizard" -->  "Path Settings ..."

	2. New Project

	Lazarus IDE menu "Project" ---> New Project ---> JNI Android Module [Lamw GUI]

	Projects workspace [yours main projecs folder or eclipse workspace]:  ____________   
   	Project Name: _____________ 
   	etc....

	OK!

	save all!

	3. From "Android Bridge" component tab drag/drop a jTextView in jForm
		set property: PosRelativeToParent  = [rpTop,rpCenterHorizontal]

4. From "Android Bridge" component tab drag/drop a jButton     in jForm
     set property: Anchor = jTextView1
     set property: PosRelativeToAnchor : [raBelow]
     set property:PosRelativeToParent = [rpCenter]
     write code for event property "OnClick"  =  ShowMessage('Hello!')

5.  Lazarus IDE menu "Run" ---> "Buld"    

6. Connect your Device to Computer [usb] and configure it to "debug mode"     

     "App settings"  ---> more -- developer options:  
      stay awake  [checked!]
       usb debugging [checked!]
       verify apps via usb [checked!]

7.Lazarus IDE menu "Run" ---> "[Lamw] Build Apk and Run" [Congratulations!!!]

8.PANIC!!! Fail to buid "Apk"

	.Try change project  "AndroidManifest.xml" according your system installation....

		<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="17"/>

		hint: other target:   "android:targetSdkVersion" !!
		
	.Change your project "build.xml"  according your system installation...

		<property name="target"  value="android-17"/>


8. How to configure a Demo to Use/Test:

      .Lazarus IDE menu Open a [*.lpi] Demo Project   [...\jni]

      .Lazarus IDE menu "Tools" ---> "[Lamw] Android Module Wizard" -->  "Change Project [*.lpi] Ndk Path"

      .set your "NDK" path!

      .change/edit project "build.xml"   according your system..

		<property name="sdk.dir" location="C:\adt32\sdk"/>


9 There are some [olds] docs:   

	"install_tutorial_ant_users.txt" 
   		and
	"install_tutorial_eclipse_users.txt"

Thank you!

J. M. Pessoa   [jmpessoa_hotmail_com]
