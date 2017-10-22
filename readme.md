
	Lamw: Lazarus Android Module Wizard: 
		:: RAD Android! Form Designer and Components Development Model! 
		
	"A wizard to create JNI Android loadable module (.so) and Android Apk
		widh Lazarus/Free Pascal using Form Designer and Components!" 

	Authors: 

		Jose Marques Pessoa
			jmpessoa@hotmail dot com
			https://github.com/jmpessoa/lazandroidmodulewizard
			http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

		Simon,Choi / Choi,Won-sik
			simonsayz@naver dot com
			http://blog.naver.com/simonsayz

		Anton A. Panferov [@A.S.]
			ast.a_s@mail dot ru
			https://github.com/odisey1245

	Acknowledgements: 
              
		-Eny and Phil for the Project Wizard hints...
		http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823

		-Felipemdc [Android support...]

		-TrueTom [Laz4Android Package]			

		-Simonsayz [great work on Android [GUI] Controls!]
			Simon,Choi / Choi,Won-sik
			simonsayz@naver.com
			http://blog.naver.com/simonsayz
			http://blog.naver.com/simonsayz/220216715675
			http://forum.lazarus.freepascal.org/index.php/topic,22079.0.html

			-warning:	
				.We use a modified and expanded version of Simonsayz's java templates.

		-Leledumbo - Many collaborations and suggestions!

		-Stephano  - Many collaborations and suggestions!

		-x2nie [Lazarus 1.3 patch to no LCL form designer!] 
			http://github.com/x2nie/LiteZarus

		-Fatih KILIÇ - How To Install!
			http://www.youtube.com/watch?v=sQnFYJyltwY&list=UUkQrLhaIXrKY4eq9zTymxpQ

		-Thierry Dijoux - Late: Apk Expert Tools [Build, Install, ...]

		-Anton [at github/odisey1245] - many many contributions!

		-JC99 - The Wiki-Page - Tutorial 
			Ref. http://wiki.freepascal.org/Talk:Android_tutorial

		-tintinux and Dieselnutjob - The Wiki-Page Tutorial
			ref. http://wiki.freepascal.org/LAMW

		-Dio Affriza - Tutorial  [https://afuriza.wordpress.com/]
			ref. https://afuriza.wordpress.com/2016/10/28/koding-pascal-untuk-android-menggunakan-lazarus/#more-705
			ref. https://www.youtube.com/watch?v=1BH460c9_Aw&feature=youtu.be

		-m4u_hoahoctro - Tutorial
			https://vozforums.com/showthread.php?p=77539041			

		-Cong Tuan Hoang - Tutorial
			https://www.youtube.com/watch?v=O7JO6HAfgZ4

		-Renabor  - Linux - Tutorial
			https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/docs/linux

		-xinyiman - Linux - Tutorial
			http://www.lazaruspascal.it/index.php?topic=1583.0

		-tendra tendra - Tutorial
			https://www.youtube.com/watch?v=Tqp7vU9vPVs

		-Ali Abidin - Tutorial
			http://xperia-mewah.blogspot.com.br/2017/02/lazarus-for-android-laz4android.html
			http://xperia-mewah.blogspot.com.br/2017/02/laz4android-lazandroidmodulewizard-lamw.html

				
		-Lazarus forum community!
		
	References:

		Laz4Android
			http://sourceforge.net/projects/laz4android/files/?source=navbar
			:To Install [*.7z], please, read the "Laz4Android_readme.txt"

		Android NDK-r10e
			http://dl.google.com/android/ndk/android-ndk-r10e-windows-x86.exe

		Ant	
			http://ant.apache.org/bindownload.cgi 
			Simply extract the zip file to a convenient location...

	***************************************************************************************************
	* To start:				
	*	
	*  "readme_getstart.txt"				
	* "install_tutorial.txt"	
	* "install_tutorial_eclipse_users.txt"	                                
	*					
	***************************************************************************************************


	****************************************************************************************************
	*Using [projects] demos :
	*
	*PANIC ? When prompt "Read error" [Unknown Property] just choice "Continue Loading" !
	*
	*PANIC ? Fail to build Apk. Change according your sdk system installation this properties:
	*
	*	"AndroidManifest.xml" 		
	*		<uses-sdk android:minSdkVersion="15" android:targetSdkVersion="17"/>
	*
	*	"build.xml"	
	*		<property name="target"  value="android-17"/>
	*
	*
	****************************************************************************************************

Version 0.7 - rev. 22 - 21 - October - 2017

	NEW! jExpandableListView component

	NEW! demo AppExpandableListViewDemo1 

	IMPROVED! jTextToSpeech 
			Added method "SpeakOnline"   [Thanks to  @Freris]
		
Version 0.7 - rev. 21 - 14 - October - 2017

	NEW! jToolbar component  [to use only with  "minSkd=21" and "targetSdk >= 21"] <<--- a request from @Tomash

	NEW! demo AppToolbarDemo1 [generic use of jToolbar as a specialized panel/visualContainer]

	NEW! demo AppToolbarDemo2 [use Toolbar as "Actionbar": configured theme/style as "android:Theme.Material.Light.NoActionBar" 
				   in "...res\values-21\style.xml"]

		HINT 1: Configure your project colors:

			Go to project folder "....res/values/colors.xml" <----- change [only content, NOT the file name] to configure colors 
				
				Reference is here:
				http://www.vogella.com/tutorials/AndroidStylesThemes/article.html#styling-the-color-palette

		HINT 2: if you change default ["colbrRoyalBlue"] jToolbar background color in design time,
			You should change "primary_dark" in "color.xml" according "material" guideline 
			[a little more darker than the toolbar color] 
			Reference is here: https://www.materialpalette.com/   
 
Version 0.7 - rev. 20 - 06 - October - 2017

	NEW! jIncomingCallWidgetProvider component

	NEW! demo AppIncomingCallWidgetProviderDemo1

		HINT 1: How to install widget:

			a)Run/Install the App
			b) Use BackButton to leave/close the App
			c) long press the home screen and select "widgets"
			d) loook for "AppIncomingCallWidgetProviderDemo1 4x1"
			f) long press "AppIncomingCallWidgetProviderDemo1 4x1" to install it
			g) keep waiting for an "Incoming Call" 
			h) has Incoming Call? click the widget to re-open and handle the caller number from your App!

		HINT 2: Configure your project:

		res/layout
			jincomingcallwidgetprovider_layout.xml    <<-- change [only content, NOT the file name] to configure
		res/drawable-xxxx
			jincomingcallwidgetprovider_image.jpg  <<-- change [only content, NOT the file name]  to configure
		res/xml
			jincomingcallwidgetprovider_info.xml	<<-- change [only content,  NOT the file name]  to configure

	NEW! demo AppBroadcastReceiverDemo2 [how to handle incoming call directly ...]

	NEW! Goodies!  by Ibragimov M. aka maxx  [Thanks!!]
		demo AppBluetoothClientSocketHC0506Terminal1
		demo Bluetooth_Arduino_GPIO_v1
		demo ColorPicker
 				
version 0.7 - rev. 19 - 16 June - 2017 

	NEW! jComboEditText component  ["ComboBox"]   

	NEW! demo AppComboEditTextDemo1

	Improved!
		jEditText
		jAutoTextView
		jListView
		jSpinner

	NEW!
		IDE Tools: Added new option "ADB Logcat"

version 0.7 - rev. 18 - 20 May - 2017 

	NEW! jModalDialog component   //<--- a suggestion by Anton (aka A.S.)!
			.ShowMessage
			.InputForActivityResult
			.QuestionForActivityResult

	NEW! demo AppModalDialogDemo1

	Improved!
		jListView 
			New event "OnScrollStateChanged"  //<--- a suggestion by Anton!

	Updated 
		jListViewDemo
 
version 0.7 - rev. 17 - 14 May - 2017 

	NEW! jSpeechToText component

	NEW! demo AppSpeechToTextDemo1

	Improved!
		jListView
			property "TextAlign" now works for "only text" items
		
		jSpinner: Added methods to support "hidden" tag by item			
			SetItem(_index: integer; _item: string; _strTag: string)
			Add(_item: string; _strTag: string);
			GetItemTagString(_index: integer): string
			SetItemTagString(_index: integer; _strTag: string);

	Fixed!
		jTextView/jEditText 
			property "Alignment" now works for "LParamWidth = lpMatchParent"

Version 0.7 - rev. 16 - 29 - April - 2017

	NEW! jSMSWidgetProvider component

	NEW! demo AppSMSWidgetProviderDemo1

		HINT 1: How to install widget:

			a)Run/Install the App
			b) Use BackButton to leave the App
			c) long press the home screen and select "widgets"
			d) loook for "AppSMSWidgetProviderDemo1 4x1"
			f) long press "AppSMSWidgetProviderDemo1 4x1" to install
			g) keep waiting for a "sms" 
			h) has sms arrived? click the widget to re-open and hanlde the message from your App!

		HINT 2: Configure your project:

		res/layout
			jsmswigetprovider_layout.xml    <<-- change [only content, NOT the file name] to configure
		res/drawable-xxxx
			jsmswigetprovider_image.jpg  <<-- change [only content, NOT the file name]  to configure
		res/xml
			jsmswigetprovider_info.xml	<<-- change [only content,  NOT the file name]  to configure
			

	IMPROVED! jSqliteDataAccess ["java" template all rewrited by Renabor!]
			NEW! support to pack [and automatic handle] database in "assets" folder
			NEW! support to database version-control

	NEW! demo AppSQliteDemo3  <<--- demo for "assets" support... [thanks to Renabor!]
			NOTE: how to store your pre-build database:
				..../assets   <<--- put your database file here [default]
					/databases  <<--- OR put your file here [default, too!]
					/myCustomFolderName  <<-- ????? OR put your file here [not default!]

					if you prefere "myCustomFolderName" as folder name then call: 
						jSqliteDataAccess1.SetAssetsSearchFolder("myCustomFolderName");
						in "OnJNIPrompt" event.						

	UPDATED! demo AppSQliteDemo1  
	UPDATED! demo AppSQliteDemo2	
					
Version 0.7.15 - 29 - March - 2017

	NEW! jTextToSpeech  component

	NEW! demo AppTextToSpeechDemo1

	UPDATED! demo AppCustomFontDemo1 --- Added Font Awesome Icons example

Version 0.7.14 - 24 - March - 2017

	NEW! jVideoView component

	NEW! demo AppVideoViewDemo1

	IMPROVED! 
		jNotificationManager   --- thanks to majid.ebru!

	NEW! demo AppNotificationManagerDemo2

	UPDATED! demo AppNotificationManagerDemo1 --- thanks to majid.ebru!

	IMPROVED! 
		jTextView: news methods
			SetFontFromAssets  --- thanks to majid.ebru!
			SetTextIsSelectable
			SetScrollingText
			SetTextAsLink	
			
		jEditText:: new method
			SetFontFromAssets  

		jButton: new method  
			SetFontFromAssets

		jCheckBox: new method  
			SetFontFromAssets

		jRadioButton: new method 
			SetFontFromAssets

	NEW! demo AppCustomFontDemo1   --- thanks to majid.ebru!

Version 0.7.13 - 27 - Feb - 2017

	NEW! jMaps component  [A wrapper to run google app "Maps"]

	NEW! demo AppMapsDemo1

	REFACTORING!
		All java tamplates are now in compliance with @DonAlfredo's "jCommons.java"
		and [try] SDK API >= 13 compatible [thanks to @tk]

Version 0.7.12 - 22 - Feb - 2017

	IMPROVED! 
		jTextView: news methods
				SetShadowLayer
				SetShaderLinearGradient
				SetShaderRadialGradient
				SetShaderSweepGradient
				SetTextDirection //thanks to  @majid.ebru

			new event
				OnLayouting   

		jEditText: new method
				SetTextDirection //thanks to  @majid.ebru
				[warning: added android:supportsRtl="true" to the <application> element in manifest file.				]

			new event
				OnLayouting
			
	NEW! demo AppTextViewShaderAndShadowDemo1
	NEW! demo AppEditTextSetTextDirectionRTLDemo1  //thanks to  @majid.ebru

Version 0.7.11 - 17 - Feb - 2017

	NEW! jWindowManager component

	NEW! demo AppWindowManagerDemo1
		[floating and draggable View!]

	IMPROVED! 
		jForm: news methods:
			Minimize
			Restart

		jButton: news methods
			SetCompoundDrawables
			SetRoundCorner
			SetRadiusRoundCorner

		jTextView: news methods
			SetCompoundDrawables
			SetRoundCorner
			SetRadiusRoundCorner

		jRadioGroup: news methods
			SetRoundCorner
			SetRadiusRoundCorner
			
		jPanel:: news methods
			SetRoundCorner
			SetRadiusRoundCorner

		jImageView: news methods		
			SetRoundCorner
			SetRadiusRoundCorner

		jEditText: news method
			SetCompoundDrawables

		jCheckBox: news method
			SetCompoundDrawables

		jRadioButton: news method
			SetCompoundDrawables				

Version 0.7.10 - 02 - Feb - 2017

	NEW! jViewFlipper component

	NEW! demo AppViewFlipperDemo1

	IMPROVED! jForm: added news methods:
		FileExists
		DirectoryExists

	IMPROVED! jSqliteDataAccess: added new method:
		DatabaseExists

Version 0.7.9 - 28 - January - 2017

	NEW! jOpenDialog component   [thanks to @majid.ebru's suggestion!]

	NEW! demo AppOpenFileDialogDemo1

	IMPROVED! jForm: added news methods:  [thanks to @Fatih !]
		GetAssetContentList
		GetDriverList
		GetFolderList
		GetFileList

Version 0.7.8 - 25 - January - 2017

	NEW! jFileProvider component 

	NEW! demo AppFileProviderDemo1   <-- Run First!!
	NEW! demo AppFileProviderClientDemo1

Version 0.7.7 - 13 November - 2016

	Added support to load custom lubrary

Version 0.7.6 - 31 October - 2016

	New! LoadFromAssetsTextContent [jForm]
	Fixed! [removed "import android.R" from jControls.java]

Version 0.7.5 - 04 October - 2016

	Minor Changed: jControls.java [Added "import android.R']

Version 0.7.4 - 28 September - 2016

	NEW! jUDPSocket component   // <<---  rime's suggestion!

	IMPROVED! jForm: added news methods:
			GetNetworkStatus
			GetDeviceWifiIPAddress
			GetDeviceDataMobileIPAddress
			GetWifiBroadcastIPAddress

	NEW! demo AppUDPSocketDemo1
	NEW! demo AppNumberPickerDemo1


Version 0.7.3 - 21 September - 2016

	NEW! jComponent jNumberPickerDialog

        IMPROVED!  jVisualControl: added events "OnBeforeDispatchDraw" and "OnAfterDispatchDraw"
			Implemented in:
				jListView
				jTextView
				jEditText
				jButton 

Version 0.7.2 - 12 September - 2016

	IMPROVED! jListView 

		Expanded Property WidgetItem: Added "wgEditText"

		Added event property [not plublished] "OnWidgeItemLostFocus"
		
		use:

		procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
		begin
			jListView2.OnWidgeItemLostFocus:= MyWidgeItemLostFocus; //handle by AndroidModule1's method  
		end;

	IMPROVED! jScrollView
		Added method SetFillViewport  // <--- thanks to DonAlfredo

	IMPROVED! jEditText
		Added event "OnLostFocus"

Version 0.7.1 - 03 September - 2016

	NEW! Added Support to java code/stuff reuse [ide_tools]
		IDE menu "Tools" --> "[Lamw] Android Module Wizard" --> "Use/Import Java Stuff..."

	NEW! jActivityLauncher component  [support to native android "Activity" code reuse]

	NEW! AppActivityLauncherDemo1
	    Note/hint:  "AndroidManifest.xml" requires:

			<activity
				android:name="com.example.appactivitylauncherdemo1.MyActivity1"
				android:label="@string/app_name"
				android:launchMode="standard" android:enabled="true">
			</activity>
			<activity
				android:name="com.example.appactivitylauncherdemo1.MyActivity2"
				android:label="@string/app_name"
				android:launchMode="standard" android:enabled="true">
			</activity>

			
Version 0.7 - 11 July 2016

	WARNING!
		.Uninstall all LAMW package before install the new version 0.7
			.uninstall [amw_ide_tools.lpk]
			.uninstall [lazandroidwizardpack.lpk]
			.uninstall [tfpandroidbridge_pack.lpk]   // <--- uninstall at last!
	
	IMPROVEMENTS!
		.Smart code composition/generation
		.Smart "Demos" perception/detection and [ndk/sdk] paths auto-fixed
		.Automatic java templates update/synchronization

	CLEANUP! [new folders organization]
		.android_bridges	[tfpandroidbridge_pack.lpk] // <<-- install first
		.android_wizard		[lazandroidwizardpack.lpk]
		.ide_tools		[amw_ide_tools.lpk]
		.java
			.lamwdesigner
		.docs
			.linux

	CLEANUP!
		.Component tabs organization


	WARNING!
		.Please, whenever a dialog prompt, select "Reload from disk"


	NEW!	jChronometer component
	NEW!	jMediaRecorder component	//thanks to  Mario H. D. suggestion!

	NEW!	AppChronometerDemo1
	NEW!	AppMediaRecorderDemo1		//thanks to  Mario H. D. suggestion!


Version 0.6 - rev. 47 - 11 June 2016 - 

	NEW!	jDownloadService component
	NEW!	jDownloadManager component

	NEW!	AppDownloadServiceDemo1
	NEW!	AppDownloadManagerDemo1

	IMPROVED!
		jGridView	// <<---- thanks to tintinux suggestions
			New methods:
				SetHorizontalSpacing
				SetVerticalSpacing
				SetSelection
				SetStretchMode

		jDrawingView	// <<---- thanks to tintinux suggestions
			New events:
				OnFlingGesture
				OnPinchZoomGesture
			Changed:
				OnDraw signature

	UPDATE:
		AppGridViewDemo1
		AppDrawingViewDemo1	
			
Version 0.6 - rev. 46 - 24 May 2016 - 

	NEW!	jAlarmManager component
	NEW!	AppAlarmManagerDemo1

Version 0.6 - rev. 45 - 21 May 2016 - 

	NEW!	jForm methods:
			SetKeepScreenOn   //thanks to noyse
			SetTurnScreenOn
			SetAllowLockWhileScreenOn
			SetShowWhenLocked

Version 0.6 - rev. 44 - 21 May 2016 - 

	NEW!	jNotificationManager methods: 
				SetLightsColorAndTime,
				SetLightsEnable	//	<<--- thanks to freris

	NEW!	jDrawingView component		//	<<---- thanks to tintinux

	NEW!	AppDrawingViewDemo1 

	UPDATED!	AppDemo1  
	UPDATED!	AppNotificationManagerDemo1  

	FIXED! jForm property set "ActivityMode:= actRecyclable" as from the second form... //<<---- thanks to tintinux

Version 0.6 - rev. 43 - 13 May 2016 - 

	NEW!	jForm methods: 
				GetDeviceModel,   
				GetDeviceManufacturer // <<--- thanks to Mladen

	NEW!	AppTFPNoGUIGraphicsBridgeDemo8   // <<--- thanks to Profo Welligton Pinheiro Santos!

Version 0.6 - rev. 42 - 10 May 2016 - 
	
	UPDATE!	AppMenuDemo  // <<--- thanks to Freris!
	FIXED!	OnKyDown [App.java] // <<--- thanks to Freris!

Version 0.6 - rev. 41 - 07 May 2016 - 

	IMPROVED! jBitmap: added method GetByteBufferFromBitmap

	NEW!	AppTFPNoGUIGraphicsBridgeDemo7

Version 0.6 - rev. 40 - 01 May 2016 - 

	FIXED!  AppCameraDemo   //thanks to tintinux!

Version 0.6 - rev. 38.9 - 30 April 2016 - 

	NEW! Component jAutoTextView 

	NEW! jForm propertie and Event:
		ActionBarTitle = (abtDefault, 
                                  abtTextAsTitle,      // Get Text property content as Title!
                                  abtTextAsTitleHideLogo, 
                                  abtHideLogo, 
                                  abtHide)          //<<-- Thanks to Handoko's bug

		OnSpecialKeyDown  // <<---- Thanks to Handoko's suggestion [but, not for Home and Overview, yet. Sorry...] 

	NEW! Demo AppAutoCompleteTextViewDemo1

Version 0.6 - rev. 38.8 - 17 April 2016 - 

	IMPROVEMENT jSqliteDataAccess

Version 0.6 - rev. 38.7 - 13 April 2016 - 

	FIXED jListView1.FontFace

Version 0.6 - rev. 38.6 - 12 April 2016 - 

	UPDATED! jHttpClient has been updated to use HttpURLConnection [We can Target API >= 21 !!] // <<-----Thanks to @Renabor!

	NEW! Added demo AppHttpClientDemo2

	NEW! jListView property "FontFace" // <<---@Mladen suggestion 

Version 0.6 - rev. 38.5 - 02 April 2016 - 

	FIXED! jDialogProgress SetCancelable [Controls.java] // <--- thanks to @Mladen

	NEW! 

Version 0.6 - rev. 38.4 - 24 March 2016 - 

	NEW! Added jEditText methods:  
			SetSelectAllOnFocus	// <<---@Mladen suggestion 
			SelectAll		// <<---@Mladen suggestion 

	NEW! Tools --> [Lamw] Android Module Wizard --> Build FPC Cross Android


Version 0.6 - rev. 38.3 - 07 January 2016 - 

	NEW! Added jForm method  ToggleSoftInput  
		Show/Hide Soft Keyboard ...

Version 0.6 - rev. 38.2 - 06 January 2016 - 

	IMPROVEMENT! Better support for device screen rotation!

	CHANGED! Changed OnRotate event signature  [sorry...]  //@Euller and @Leledumbo suggestion ...

	NEW! AppTFPNoGUIGraphicsBridgeDemo6  [ref. https://github.com/jmpessoa/tfpnoguigraphicsbridge]

		Projectile Motion Graphicis Demo [parameterized function] and device screen rotation!

		Screenshots Ref:
			https://app.box.com/s/kpeuxb8p33m6rkg42bg1d0g2p2i7pkhd
			https://app.box.com/s/l2ncravxk1mvlahvoyoup4lxyk0sh2ro
			https://app.box.com/s/2e6xpm0wwhaus0xdw7x7ufc08atlewh4

		Please, read the "readme.txt" in project folder "../jni"  

Version 0.6 - rev. 38.1 - 30 December 2015 - 

	NEW! Executable native console application support.

	NEW! LamwConsoleAppDemo1  [../demos/Console]
		please, read:
		 "readme_How_To_Run_AVD_Emulator.txt"  
		 "readme_How_To_Run_AVD_Emulator.txt"

Version 0.6 - rev. 38 - 26 December 2015 - 

	NEW! jRadioGroup component 

	NEW! AppRadioGroupDemo1   

Version 0.6 - rev. 37 - 23 December 2015 - 

	NEW! jRatingBar component 

	NEW! AppRatingBar Demo1   

Version 0.6 - rev. 36 - 03 August 2015 - 

	IMPROVEMENT!   

		Wizard forms usability [and code] redesigned! 
			Eclipe/Ant project [finally] unified!
			Fixed [Lamw NoGUI] project //<<----Thanks to @leledumbo! 			
					
	IMPROVEMENT!   

		jBluetooth
			News methods: 
				PairDeviceByAddress
				UnpairDeviceByAddress
		
	FIXED!  

		jImageBtn //<<----Thanks to @renabor!			

		jSqliteDataAccess.Select //<<----Thanks to @renabor!

	NEW! 
		"GET START" The Wiki-Page //<<----Thanks to @jc99!
			Ref. http://wiki.freepascal.org/Talk:Android_tutorial

				
	HINT 1: Old Projects: Please, upgrade your project code templates !
			Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"! 
			[After any form/component/property  changed and saved.... Problem solved!]

Version 0.6 - rev. 35 - 28 July 2015 - 

	IMPROVEMENT/FIXED!   

	       jBluetoothClientSocket component <<--- @Euller and @osvaldotcf request! 
               jBluetoothServerSocket component <<--- @Euller and @osvaldotcf request! 				
					

	NEW Demos!
 
                AppBluetoothServerSocketDemo1 <---> AppBluetoothClientSocketDemo1 //<<--- No header

                AppBluetoothServerSocketDemo2 <---> AppBluetoothClientSocketDemo2 //<<--- header support

			Technical Notes [header support]: 
				.Set property "DataHeaderReceiveEnable = True" for both [client/server]
				.Internal Format [yes, you can use without knowing this information!]: 
					first two bytes: size of "header"
					following four bytes: size of "content"
					following bytes "dataHeader"
					following bytes "dataContent"
						

	FIXED!  Target x86 [AndroidWizard_intf.pas]//<---- thanks to Takeda Matsuki.


	HINT 1: Old Projects: Please, upgrade your project code templates !
			Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"! 
			[After any form/component/property  changed and saved.... Problem solved!]

Version 0.6 - rev. 34 - 14 July 2015 - 

	IMPROVEMENTS!   

	       jHttpClient component:	
		
			New! Added Cookie Support [need tests !!]: // <<--- @Leledumbo's request and suggestion! 	

	NEW! 
		AppHttpClientCookiesDemo1

	LOST! [sorry ..]  

		FontSizeByComplexUnitPixel component property was lost!   //<<--many problems caused to @rx3.fireproof!
	
	NEW!
		FontSizeUnit component property [ unitDefault  <--> unitScaledPixel ]

		Hint:  try FontSizeUnit=unitPixel  [jListView and jSpinner more responsive] and better developer experience! 

	HINT 1: Old Projects: upgrade your projects code templates !
			Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"! 
			[After any form/component/property  changed and saved the problem gets solved!]
		
Version 0.6 - rev. 33 - 09 July 2015 - 

	NEW! jSeekBar component 

	IMPROVEMENTS!   
			
		jForm 
			New! 
				properties: // <<--- @rx3.fireproof's request and suggestion! 
					PromptOnBackKey [default=True]

					TryBacktrackOnClose [default=False]

						The form now know your [own] base... so, 
						if you close it, you will return to the form where it was created 
						[or "showed"!].  But you can try return to "main form" form using the new 
						property "TryBacktrackOnClose:= True" in all [forms] chains ...
						[warnig]the process will stop [before main from] if some form [in the way] 
						was not set "TryBacktrackOnClose:= True"

	NEW! AppSeekBarDemo1   [multiples forms demos, too]
			
	UPDATED: Demo AppTest1  [multiples forms demos]

	HINT 1: Old Projects: upgrade your projects code templates !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"!

Version 0.6 - rev. 32 - 05 July 2015 - 

	IMPROVEMENTS!   

	       jListView component:			
			New! event/properties:	
				OnDrawItemBitmap 
				OnDrawItemTextColor
				OnLongClick <<--- @renabor's request and suggestion! 

			warning/changed: "OnClickItemCaption" was lost [sorry ...], please, copy your code to "new" OnClickItem

	       jGridView component:			
			New! Event/properties:	
				OnDrawItemBitmap 
				OnDrawItemTextColor		
				OnLongClick

	       jDigitalClock component:			
			New! properties:
				FontColor
				FontSize
		jSqliteCursor
			New! method:
				GetValueAsString(rowPosition, columnName) <<--- @renabor's suggestion [GetLastID]! 
							rowPosition = -1 --> move to last!
		
		jHttpClient 
			New! synchronous methods:  // <<---- by Fatih KILIÇ 
				Get(url): string				

				AddNameValueData(name,value)
				Post(url)  

			warning/changed: asynchronous "Get" methods was renamed to "GetAsync"
			warning/changed: asynchronous "PostNameValueData" methods was renamed to "PostNameValueDataAsync"

			New! 
				AddNameValueData(name,value)
				PostNameValueDataAsync(url)  
			
		jShellcommand 
			warning/changed: asynchronous "Execute" method was renamed to "ExecuteAsync"

		jContactManager
			warning/changed: asynchronous "GetContact" method was renamed to "GetContactAsync"

	UPDATED: ALL Demos !!!

	HINT 1: Old Projects: upgrade your projects code templates !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"!

Version 0.6 - rev. 31 - 30 June 2015 - 

	NEW! jContactManager component [Partial support] // <<--- @renabor's request and suggestion! 
		
		warning [need]:
		<uses-permission android:name="android.permission.READ_CONTACTS"/>
		<uses-permission android:name="android.permission.WRITE_CONTACTS"/>

	NEW! AppContactManagerDemo1 
	NEW! AppContactManagerDemo2 

	IMPROVEMENTS!   

	       jCustomDialog component:			
			New! OnBackKeyPressed property event// <<--- @renabor's request and suggestion!

			UPDATED: Demo AppCustomDialogDemo1

	       jEditText component:			
			New! OnClick property event // <<--- @renabor's request and suggestion!
			New! itxCurrency mask // <<--- @renabor's request and suggestion! 

			UPDATED: AppEditTextDemo1
			
		jForm 
			New! OnJNIPrompt event now fires when a form is reactivated trough a Backkeypressed!
			// <<--- @renabor's request and suggestion! 	

			Fixed! jForms stack behaviour

			UPDATED: Demo AppTest1  

	HINT 1: Old Projects: upgrade your projects code templates !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"!

Version 0.6 - rev. 30 - 14 June 2015 - 

	IMPROVEMENTS!   

		jMenu component:			
			New! Add support to different menu in each form! // <<--- @renabor's request and suggestion!
			New! Methods, Propery and Events
		jForm 
			News! Events/Properties to handler the news from jMenu 

	UPDATED: Demo AppMenuDemo 

	FIXs	
		jForm		:fixed form close callback 
		jHttpClient	:fixed "basic authentication" //<--- Thanks to @renabor !!!	

	HINT 1: Old Projects: upgrade your projects code templates !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"!

Version 0.6 - rev. 29 - 08 June 2015 - 

	NEW! jSurfaceView component 

	IMPROVEMENTS!   

		jMediaPlayer component:			
			New! Add support to video play! // <<------ @m4u_hoahoctro's request and suggestion!
	NEW!  
		Demo AppMediaPlayerDemo1 [Eclipse Compatible Project] 			
		Demo AppSurfaceViewDemo1 [Eclipse Compatible Project] 

	UPDATED: All Demos was "upgrade"!			

	HINT 1: Old Projects: upgrade your projects code templates !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]

	HINT 2:	When prompt "Read error" [Unknown Property] just choice "Continue Loading"!

Version 0.6 - rev. 28 - 02 June 2015 - 

	NEW!
		jForm "TakeScreenshot" method
		jForm "Vibrate" method
			:"AndroidManifest.xml" add on:  
				"<uses-permission android:name="android.permission.VIBRATE"/>"

	IMPROVEMENTS!   

		jAsyncTask component:   
			New! component design/behaviour changed!
			News events properties: 
    				OnDoInBackground
				OnProgressUpdate
				OnPreExecute
				OnPostExecute

			::Redesigned DEMO : AppAsyncTaskDemo1 		
		
		jHttpClient
			New! Added build in "asynctask" support!
			News events properties: 
				OnContentResult
				OnCodeResult

			::Redesigned DEMO: AppHttpClientDemo1					
	
		jDialogProgress component //<--- Euller's suggestion!
			New! Added "custom view" support!
			News methods:								
				Show
				Close
				SetMessage
				SetTitle
				SetCancelable

	NEW!  
		Demo AppDialogProgressDemo1 [Eclipse Compatible Project] 			

	-----------------------------------------------------------------------
	Ok. We did dramatic changes, sorry! 

	Please, you can learn the new components design/behaviour in the Demos:  AppAsyncTaskDemo1 and AppHttpClientDemo1  !!!

	1. jAsyncTask lost property "OnAsyncEvent" but no panic!
		when prompt "Read error" [Unknown Property] just choice "Continue Loading"!

		Now copy the old code to matching/equivalent news events:
			OnPreExecute			
			OnDoInBackground			
			OnProgressUpdate
			OnPostExecute

	2. jHttpClient: now "runInBackground/asynctask" have build in  support! 
			You do not  need more use jAsyncTask component to run it "in background" !

		Ok, you will need handle the new event "ContentResult" to get content result and
		"get" now is a procedure [not a function] ... so, no more result!

	3. Old Projects: upgrade your project [or demo] code templates!] !
		Lazarus IDE --> menu Tools --> [Lamw] Android Module Wizard --> Upgrade code Templates [*.lpr, *.java]
	--------------------------------------------------------------------

but, the changes was for more elegance and effective solution!  

Thanks to All!

Version 0.6 - rev. 27 - 25 May 2015 - 

	FIXED! 	
		jShellCommand component
	FIXED!   
		IDE Tools: New jComponent [Create]

Version 0.6 - rev. 26 - 21 May 2015 - 

	NEW!  
		jTCPSocketClient component

	FIXED! 	
		jHorizontalScrollView component
	NEW!  
		Demo AppHorizontalScrollViewDemo1 [Eclipse Compatible Project] 
		Demo AppTCPClientDemo1 [Eclipse Compatible Project] 

Version 0.6 - rev. 25 - 14 May 2015 - 

	NEW!  
		jForm "ShowCustomMessage" method

	NEW! 	
		Demo AppCustomShowMessageDemo1 [Eclipse Compatible Project] 
	
	NEW!	New Menu entry: added support to configure project demos
		Lazarus IDE --> Tools --> [Lamw] Android Module Wizard --> Change Project [*.lpi] Ndk Path [Demos]

Version 0.6 - rev. 24 - 10 May 2015 - 

	NEWS!  
		jAnalogClock component
		jDigitalClock component

	IMPROVED! 
		jSMS Added new "Read" method // <<--- A suggestion and request by @m4u_hoahoctro 
		jEditText Added new "AppendLn" method 
		jTextView Added new "AppendLn" method 

	NEWS! 
		Demo AppClockDemo1 [Eclipse Compatible Project] 
		Demo AppSMSDemo1 [Eclipse Compatible Project] 
	
Version 0.6 - rev. 23 - 09 May 2015 - 

	NEW!  
		jShellCommand component <<---A suggestion and request by @greenzyzyzy 

	NEW! Demo AppExecuteShellCommandDemo1 [Eclipse Compatible Project] 

	NEW! Android Manifest Editor: 
		Lazarus IDE: "Project' --> "Project Option" --> "[Lamw] Android Manifest" [Thanks to  @A.S.]

	IMPROVEMENTS! components visual design 	[Thanks to @A.S.]

Version 0.6 - rev. 22 - 18 April 2015 - 

	NEWS!  
		jBitmap added methods: 
				GetByteBuffer
				GetBitmapFromByteBuffer
				GetBitmapFromByteArray	


	NEW! Demo AppTFPNoGUIGraphicsBridgeDemo1 [Eclipse Compatible Project] 
		warning: Need Packages:
				"tfpdxfwritebridge_pack.lpk"		ref. https://github.com/jmpessoa/tfpdxfwritebridge
				"tfpnoguigraphicsbridge_pack.lpk"	ref. https://github.com/jmpessoa/tfpnoguigraphicsbridge

	Hint: TFPNoGuiGraphicsBridge on Android

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

		For Lamw project you can look for "XX" value in menu: 
		"Project" --->> "Project Options" ---> "Compile Options" -->> "Paths" --->> Libraries [-Fl]


	PANIC III. Where I find a "libfreetype.so" for arm-android ?
	
		Go to demo "...\AppTFPNoGUIGraphicsBridgeDemo1\libs\armeabi" [Eclipse compatible Project]

		You will find an "all ready" there! 

	PANIC IV.  Where "libfreetype.so" will be load in java code?

		Go to "Controls.java" [\src\...\..] and uncomment this line:

		--->> System.loadLibrary("freetype");

		The code now will be:

		//Load Pascal Library
		static {   		
      			System.loadLibrary("freetype");  // <<---uncommented here!
      			System.loadLibrary("controls");    		
		}

Version 0.6 - rev. 21 - 16 April 2015 - 

	NEWS!  
		jForm added method: IsPackageInstalled
		jIntentManager added method: IsCallable 

	NEW! Demo AppIntentDemoZXing1 [Eclipse Compatible Project] <<---A suggestion and request by  Liuzg2


Version 0.6 - rev. 20 - 07 April 2015 - 

	NEWS: 
		IDE menu entry "Run --> [Lamw] Build Apk and Run" ::by Anton


			Note: for old projecs, please change "controls.lpi":

			after:

			<VersionInfo>
		    		<StringTable ProductVersion=""/>
			</VersionInfo>

			Add this new entry:

			<CustomData Count="1">
		    		<Item0 Name="LAMW" Value="GUI"/>
			</CustomData>

		IDE "New project" now has two entries [thanks to Anton!]:

			1. JNI Android Module [Lamw NoGUI]
				A [NoGUI] JNI Android loadable module (.so)
				using DataModule (NO Form Designer/Android Components Bridges)!

			2. JNI Android Module [Lamw GUI]
				A [GUI] JNI Android loadable module (.so)
				based on Simonsayz's templates
				with Form Designer and Android Components Bridges!
				
		New native method java Parse ::by Anton
		New property color editor ::by Anton

	NEW! Demo AppBluetoothDemo1 [Eclipse Compatible Project] <<---A suggestion and request by m4u_hoahoctro

		Note: to transfer via Bluetooth,
		you need to do some common user's tasks: 
		activate bluetooth, detect neighbors devices and pair neighbors devices.... 	


Version 0.6 - rev. 19 - 09 March 2015 -
	
	NEWS
		jControl: Added Method AttachCurrentThread
		jHttpClient: Added Methods: PostNameValueData	
		jEditText: Added Methods:	
				SetAcceptSuggestion 
				CopyToClipboard
				PasteFromClipboard
				Clear
		
	NEW! Demo AppAsyncTaskDemo1	[Eclipse Compatible Project]	
	NEW! Demo AppHttpClientDemo1	[Eclipse Compatible Project]	

	FIXs:	jAsyncTaskDemo
			jHttpClient
		
Version 0.6 - rev. 18 - 22 February 2015 -

	::Tutorial to Stephano Questions: 

		ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.msg169783/topicseen.html#new

		1. Create a new "Lamw" project as usual [save all to ../jni] 

		2. Add to ../src the new java class code [ex. jhelloadder.java]

		3. Go to [again] IDE->Project->New Project select [again] "JNI Android Module" Project
                   and [again] Select the same project [form workspace]

		4. But, NOW double click the added java class code [jhelloadder.java] 

		5. Ok

		6. Save all new project to ../jni [warning: keep the project name [jhelloadder.lpr],
		   but change the unit name :: ex. "unithelloadder.pas"]


		7. Yes, the new "jhelloadder.lpr" have the "drafts" code for all native methods!

			function Add(PEnv: PJNIEnv; this: JObject; _a: JInt; _b: JInt): JInt; cdecl;
			begin
  			  {your code....}
  			  {Result:= ;}
			end;

			function StringUpperCase(PEnv: PJNIEnv; this: JObject; _str: JString): JString; cdecl;
			begin
  			  {your code....}
  			  {Result:= ;}
			end;

		8. Yes, you have a new form [datamodule]: You can put there any "pure/fcl" TComponent descendant 
			[not LCL component, not Lamw component] --->> TODO: need more test

		8. Go to [again] IDE->Tools->Android Module Wizard->New jComponent [Create]

		9. Paste the "jhelloadder.java" into Tab "java" ...			

                        WARNING: after paste, remove de word "public" from class definition!
                        [TODO: need fix the parse ...]

		10. Read the content of Tab "help" ... [follow the instructions!]
			Do not forget:

			//Please, you need insert:
				public java.lang.Object jHelloAdder_jCreate(long _Self) {
      				  return (java.lang.Object)(new jHelloAdder(this,_Self));
   				}
			//to end of "public class Controls" in "Controls.java"

		11. Open "tfpandroidbridge_pack.lpk --> More -> Recompile Clean -> Use -> Install !!
		12. Use Case 1: Pascal call Java :: drop the new component to jForm [main app] and use it!
		13. Use case 2. Java call Java   :: declare and use it! ex.:

			jHelloAdder helloadder;
			helloadder = new jHelloAdder(controls, 1010); //controsl=reference to main "controls" object :: 1010 = dummy
			Log.i("jHelloAdder_Add","Add(7,11)="+ helloadder.Add(7,11));

		14. Please,  see the new project demo ...	
		
	NEW! Demo AppAddSingleLibraryDemo1     [Eclipse Compatible Project]	

Version 0.6 - rev. 17 - 19 February 2015 -

	MINOR IMPROVEMENT:

	jEditText:
		Change property behavior : 
			MaxTextLength = -1 {default/reset: no limited!}
				in fact:  "MaxTextLength < 0" --->  "default/reset"

Version 0.6 - rev. 16 - 18 February 2015 -

	MINOR IMPROVEMENT:

	jEditText:
		NEW property: 
			HintTextColor; <<-A suggestion and request by Ps

Version 0.6 - rev. 15 - 17 February 2015 -

	MINOR IMPROVEMENTS:

	jApp:
		LOST properties: // <<--A suggestion and request by rx3.fireproof	
			Device.PhoneNumber
			Device.ID;
	jForm: 
		NEWS methods:	
			.GetDevicePhoneNumber;
			.GetDeviceID;
			.[warning] "must have" [AndroidManifest.xml]: 
				<uses-permission android:name="android.permission.READ_PHONE_STATE"/>			
	jTextView:
		NEW property: // <<--- Thanks to Fatih!		
			FontFace;

	jEditText:
		NEWS properties: // <<--- Thanks to Fatih!		
			TextTypeFace;
			FontFace;
			Editable; <<-A suggestion and request by rx3.fireproof
	jSpinner:
		NEW properties:	<<-A suggestion and request by rx3.fireproof
			FontSize; 
 			Count;
	jHttpClient:
		NEWS methods: <<-A suggestion and request by Ps
			.SetAuthenticationUser(...); 	 	
			.SetAuthenticationHost(...); 
		NEW property:	
			AuthenticationMode [just basic... yet] 

	jWebView:
		NEW property: // <<--- Thanks to Fatih!	
			ZoomControl;	
		NEW method: <<-A suggestion and request by Ps
			SetHttpAuthUsernamePassword(...); 
		
	jListView: FIXs [radio group mode]
		LOST property:	
			HighLightSelectedItem;
			::Please, no panic! When prompt "Read error" [Unknown Property] just choice "Continue Loading"
	
Version 0.6 - rev. 14 - 13 February 2015 -

	NEW! Added support to Touch Gesture: Pinch/Zoom and Fling[Swipe]!
		:: [jPanel] Added/News events support:  OnFlingGesture and OnPinchZoomGesture

	NEW! Demo AppPinchZoomGestureDemo1 [Eclipse Compatible Project]
	NEW! Demo AppFlingGestureDemo1     [Eclipse Compatible Project]

	UPDATED! Demo AppActionBarTabDemo1 [Eclipse Compatible Project] 
		:: Added support to gesture OnFlingGesture [swipe] //<<-A suggestion and request by Derit Agustin

	NEW! Added component jNotificationManager[Android Bridges Extras]
	NEW! Demo AppNotificationManagerDemo1[Eclipse Compatible Project]

	NEW! Added component jDatePicker[Android Bridges Extras]
	NEW! Added component jTimePicker[Android Bridges Extras]
	NEW! Demo AppDateTimePicker[Eclipse Compatible Project]

	IMPROVEMENTS:	jEditText :: Added/New method: SetImeOptions   //Thanks to @Ps 
			All jVisualControl: Added Custom Color Support //Thanks to @Ps 					
	UPDATED! Demo AppEditTextDemo1[Eclipse Compatible Project] 

	
	UPDATED! All Demos updated!


Version 0.6 - rev. 13 - 29 January 2015 -

	NEW! Added support to "core" Android!

	NEW! Added component jBroadcatReceiver [Android Bridges Extras]
	NEW! Demo AppBroadcatReceiverDemo1 [Eclipse Compatible Project]

	NEW! Added component jSensorManager [Android Bridges Extras]
	NEW! Demo AppSensorManagerDemo1 [Eclipse Compatible Project]
	NEW! Demo AppSensorManagerDemo2 [Eclipse Compatible Project]

	NEW! Added component jIntentManager [Android Bridges Extras]
	NEW! Demo AppIntentManagerDemo1 [Eclipse Compatible Project]
	NEW! Demo AppIntentManagerDemo2 [Eclipse Compatible Project]
	NEW! Demo AppIntentManagerDemo3 [Eclipse Compatible Project]

	NEW! New jComponent [Create] Expert 
		IDE "tools" -> "Android Module Wizard" -> "New jComponent [Create]"
			Please, read the Tab "Help" ....

	UPDATED! All Demos updated!
	
Version 0.6 - rev. 12 - 10 January 2015 -

	NEW! Added component jToggleButton [Android Bridges Extras]
	NEW! Demo AppToggleButtonDemo1 [Eclipse project]

	NEW! Added component jSwitchButton [Android Bridges Extras]
	NEW! Demo AppSwitchButtonDemo1 [Eclipse project]

	NEW! Added component jGridView [Android Bridges Extras] //<<-A suggestion and request by Valmadson
	NEW! Demo AppGridViewDemo1 [Eclipse project]

	FIXs : Some component lost needless published property "Text"
		.Please, no panic! When prompt "Read error" [Unknown Property] just choice "Continue Loading"
		(simulates just one component property change e save it!)

	UPDATED! All Demos updated!
	

Version 0.6 - rev. 11 - 03 January 2015 -

	.Major Code Reorganization/Cleanup [Pascal and Java sides]: 
	
	.WARNIG! you need [must] upgrade your existing code/application!
		Please, use the IDE "tools" -> "Android Module Wizard" -> "Upgrade Code Templates"

	.Reducing the final size of "controls.so"  [now less than half!!]
		
	Typical example:

	TAndroidModule1 = class(jForm)
		jButton1: jButton;
		jEditText1: jEditText;
		jListView1: jListView;
		jSpinner1: jSpinner;
		jTextView1: jTextView;
      		procedure jButton1Click(Sender: TObject);
	private
	      	{private declarations}
	public
      		{public declarations}
	end;
	..............................

	Before [Typical example]:
		controls.so  --------- 2768 KB 

	After first code reorganization [Typical example]:
		controls.so ---------- 1371 KB 

	Now [Typical example]:
		controls.so ---------- 1206 KB  [!!]

	How it scale? The "AppDemo1" uses 14 forms and many, many components and code: 
		controls.so ---------- 1379 KB  [Added only 14% !!]

	FIX/NEW! jEditText
		:: New! Added event property "OnChanged"			
		:: FIX/NEW! Event handles now is OK with help of the news methods 
			"DispatchOnChangeEvent" and "DispatchOnChangedEvent"!
		:: FIX! InputTypeEx property now is ok!

	NEW! Demo AppEditTextDemo1 [Eclipse Project...]  		
		                          
	WARNIG! jEditText property name "LineMaxLength" changed to the correct "MaxTextLength" !
		.Please, no panic! When prompt "Read error" [Unknown Property] just choice "Continue Loading"!
		(simulates some component property change e save it!)
	
	WARNIG! jImageView lost the property "IsBackgroundImage" 
		.Please, no panic! When prompt "Read error" [Unknown Property] just choice "Continue Loading"!
		(Simulates some component property change e save it!)
		.Just puts the jImageView "first" on jForm and set LayoutParams [H/W] to lpMatchParent
			(Form Background Image is done!) 

Version 0.6 - rev. 10 - 21 December 2014 - 

	Important Code Reorganization: A suggestion by Leledumbo [Thank you very much Leledumbo!]

	Significantly reducing the final size of "controls.so"  [just about half!]

	.....................................
	Typical example:

	TAndroidModule1 = class(jForm)
		jButton1: jButton;
		jEditText1: jEditText;
		jListView1: jListView;
		jSpinner1: jSpinner;
		jTextView1: jTextView;
      		procedure jButton1Click(Sender: TObject);
	private
	      	{private declarations}
	public
      		{public declarations}
	end;
	..............................

	Before:
		controls.so  --------- 2768 KB 

	After code reorganization:
		controls.so ---------- 1371 KB


Version 0.6 - rev. 09 - 20 December 2014 -

	NEW! Improve/Add support to ../res/drawable to [many] components:

					.jListView [method]
						ex. jListView1.SetImageByIndex('ic_launcher',0);

					.jImageFileManager [method] 
						ex. jImageFileManager1.LoadFromResources('ic_launcher');

					.jBitmap [property]
						ex. jBitmap1.ImageIdentifier:= 'ic_launcher';

					.jImageView [property]
						ex. jImageView1.ImageIdentifier:= 'ic_launcher';

					.jImageBtn [properties]
						ex. jImageBtn1.ImageDownIdentifier:= 'ic_down';
						ex. jImageBtn1.ImageUpIdentifier:= 'ic_up';

					.jCustomDialog [property]
						ex. jCustomDialog1.IconIdentifier:='ic_launcher';	

					.jActionBarTab1 [property: TStrings]	
						ex. jActionBarTab1.IconIdentifiers

					.jMenu [property: TStrings]	
						ex. jMenu1.IconIdentifiers

					.jContextMenu [property]
						ex. jContextMenu1.HeaderIconIdentifier:= 'ic_launcher';

Version 0.6 - rev. 08 - 15 December 2014 -

	NEW! Add Support to build release Apk! 
		[win  -->> build-release.bat]
		[linux ->> build-release.sh]

		Please, look for:
			readme.txt [Project Folder]
			readme-keytool-input.txt [Project Folder]

	IMPROVEMENTS: 

	Component "jSqliteDataAccess" [.pas]
		
		News Methods:

			SetForeignKeyConstraintsEnabled;
			SetDefaultLocale;

			DeleteDatabase;    		
			CheckDataBaseExistsByName

			InsertIntoTableBatch
			UpdateTableBatch	
			UpdateImageBatch

	Class "jSqliteDataAccess" [java wrapper]

	Added Safe operation:

 		beginTransaction();
			....
		setTransactionSuccessful()
			....
		endTransaction();

	NEW!	App Demo: AppSqliteDemo2

	FIXs	Some minor fixs!
		
Version 0.6 - rev. 07 - 07 December 2014 -

		
	NEW!	.jCustomDialog component [Android Bridges Extra]  <<---- A suggestion and request by Leledumbo

			NEW! Demo: AppCustomDialogDemo1
			ref. image: 
				https://jmpessoa.opendrive.com/files?Ml83MDgwNTQxMl9jTEJkcA
				

Version 0.6 - rev. 06 - 03 December 2014 -
		
	NEW!
		.Add sub entry "Resource Editor" ["Android Module Wizard" to Lazarus IDE "Tools" menu] <<---- by Thierry Dijoux 
		.LATE [IDE Tools]: Improve logcat support:
			--> "TAG Filter" log
			--> "Run Time Error" log
		
	NEW!	.jContextMenu component [Android Bridges Extra]  -->> Improve the support to Android Menus....
		.jMenu - Improve support --> Icons and ActionBar support!

			UPDATE Demo: AppMenuDemo 
			ref. images: 
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjAzNV9VekM1dA
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjE2MF9QS1dTaQ
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjI2OF9jU3ZwSg

		.jActionBarTab component [Android Bridges Extra] - ActionBar TAB Support!

			NEW! Demo: AppActionBarTabDemo1 - 
			ref. Images:
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjM4OV9jRklmaw
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjQ3Ml96N1ZTMg
				https://jmpessoa.opendrive.com/files?Ml82OTk0MjU5MF82VlRrNA

		.Add new methods to jForm  [ActionBar Support!]:
		
			GetActionBar;    
			HideActionBar;
			ShowActionBar;
			ShowTitleActionBar;
			HideLogoActionBar;
			SetTitleActionBar;
			SetSubTitleActionBar;
			SetIconActionBar;
			RemoveAllTabsActionBar();

			SetTabNavigationModeActionBar;  --- Need for ActionBar TAB Support!


		WARNING: Action bar was introduced in Android 3.0 (API level 11)
		[Set targetSdkVersion to >= 14, then test your app on Android 4.0]

		.Others improvements and fixs by Leledumbo!


Version 0.6 - rev. 05 - 13 November 2014 -

	NEW! Lazarus Package "amw_ide_tools.lpk" (*) [..\LazAndroidWizard\ide_tools]

		.Add entry  <<--- by Thierry Dijoux! 
		ref. image: https://jmpessoa.opendrive.com/files?Ml82Nzg4MzAyNF9leGVIVg

		.Add sub entry "Late: Apk Expert Tools [Build, Install, ...]" <<---- by Thierry Dijoux! 
		ref. image: https://jmpessoa.opendrive.com/files?Ml82Nzg4MzA2N184VWZaWg

			:: Improves and automates the "Ant" support!

			:: WARNING: [Build Android Apk]: If you got "[echo] Resolving Build Target for..."
				ref image https://jmpessoa.opendrive.com/files?Ml82Nzk0NzM1N19taU1QUg

				.Please, Open ["build.xml"] {notepad like editor...}

				.Change this line:
					"<property name="target"  value="android-14"/>"
					to another [target] supported by your SDK installation.
					 ex: value="android-17"
				

		.Add sub entry "Upgrade Code Templates [*.lpr, *.java]" 
		ref. image: https://jmpessoa.opendrive.com/files?Ml82Nzg4MzA3Ml80MFVjSQ

			:: Yes, Now became easy to keep the [olds] projects in sync with the new AMW version-revision!	

		.Add sub entry "Path Settings [JDK, SDK, NDK, ...]" <<--- Stephano's suggestion! (**)
		ref. image: https://jmpessoa.opendrive.com/files?Ml82Nzg4MzA1OF9yVVU3RA

			:: WARNING: I recommend that "new" User start here: Set Paths to JDK, SDK, NDK, ...
		
		(*)Please, look for [and install it!] "amw_ide_tools.lpk" in folder ..\LazAndroidWizard\ide_tools 

		(**) Yes, this paths configuration was removed from prompt dialog of "Android Module Wizard"
		ref. image: https://jmpessoa.opendrive.com/files?Ml82Nzg4MzE0Nl9LczBuTQ
		
		WARNING! Windows Users: Please, update to [new] TrueTom Laz4Android [or some more advanced!]
		 ref. http://sourceforge.net/projects/laz4android/files/?source=navbar
		:To Install, please, read the "Laz4Android_readme.txt"

	NEW!	.jShareFile component [Android Bridges Extra]
		.jImageFileManager component [Android Bridges Extra]

		.Add new methods to jForm:
									
			CopyFile;
			DeleteFile;
			CreateDir;
			LoadFromAssets; //<-- result the full path to app internal storage
			
			GetEnvironmentDirectoryPath;
			GetInternalAppStoragePath;
							
			IsSdCardMounted;								
			IsExternalStorageEmulated;
			IsExternalStorageRemovable;

			IsWifiEnabled;
			SetWifiEnabled;

	NEW! DEMO AppShareFileDemo1 [Eclipse Project] 
		-->> jShareFile, jTexFileManager and jImageFileManager
																									
	FIX! Improves/fix the support to Project Compiler Options ... Thanks to Stephano! 

Version 0.6 - rev. 04 - 23 October 2014 -

	NEW! Add support to [jApp] plurals and locale. [thanks to Thierrydijoux]
	NEW! Add support to string resource. [thanks to Thierrydijoux]

	NEW! Add Api [jApp] GetControlsVersionFeatures ...
	NEW! Add Api [jApp] GetControlsVersionInfo ...

	Fix! Enable default android's theme. [thanks to Thierrydijoux]
	Fix! fix formWorkspace tab order and added android target 19.[thanks to Thierrydijoux]

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

		WARNING! Windows Users: Please, update to [new] TrueTom Laz4Android [or some more advanced!]
			ref. http://sourceforge.net/projects/laz4android/files/?source=navbar
			:To Install, please, read the "Laz4Android_readme.txt"

			1. From Laz4Android IDE - Install Wizard Packages

			1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"  [Android Components Bridges!]
				Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

			1.1.1 From Package Wizard
				- Compile
				- Use -> Install
 			1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
   			1.2.1 From Package Wizard
				- Compile
				- Use -> Install  
  
 			1.3 Package -> Open Package -> "amw_ide_tools.lpk"  [folder: ..\LazAndroidWizard\ide_tools]
   			1.3.1 From Package Wizard
				- Compile
				- Use -> Install    
				- ref. https://jmpessoa.opendrive.com/files?Ml82NzAyMTYwMl9pUDV3RQ 

			HINT: to compile/install/reinstall a package in Laz4Android,
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

		-->> Add new "AndroidWidget" unit to uses clauses [*.lpr/*.pas]

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
		:: Please, read "how_to_create_new_components.txt"

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

		ref. http://ant.apache.org/bindownload.cgi 
			Then simply extract the zip file to a convenient location...

version 0.2 - 14 December 2013 -

	:: NEW! Introduces Android [GUI] Android Components Bridges - Based on Simonsayz's controls 

version 0.1 - revision 0.1 - 09 September - 2013 -	 

	:: Bugs fixs!

version 0.1 - August 2013 -

	:: Warning: at the moment this code is just a *proof-of-concept*
     

------------x-----------------------------x------------------------------x-------------   
      
II.  Ant Projec Development: please, read "install_tutorial_ant_users.txt"


III. Eclipse Project Development: please, read "install_tutorial_eclipse_users.txt"

-----------x------------------------------x------------------------------x--------------

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

	:: [Edited 04-May-2014] :: WARNING:  Please, read the  NEW ""how_to_create_new_components.txt" - 

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
     -Bugs : [SOLVED!] {known bug: fail on Api > 13. Temporary solution: a workaround to prevent Api > 13 - 02 jan 2014} 
     -suggestions 
     -Colaborations	
     -Critics
     -Roadmap
     -etc..

VI. The work is just beginning!

VII. Thank you!

    _____jmpessoa_hotmail_com_____
