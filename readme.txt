
Lazarus Android Module Wizard 
				

"A wizard for create JNI Android loadable module (.so) in Lazarus/Free Pascal using DataModules" 


      Author: Jose Marques Pessoa : jmpessoa__hotmail_com

		 https://github.com/jmpessoa/lazandroidmodulewizard

	         http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

 	      
              Acknowledgements: 
              
              
              Eny and Phil for the Project wizard hints...

                 http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823

              Felipe for the Android support...

              TrueTom for the Laz4Android Package (laz4android1.1-41139)
                  	
		https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149
              
             Simonsayz for the great work on Android [GUI] Controls

                http://forum.lazarus.freepascal.org/index.php/topic,22079.0.html


             Lazarus forum community! 


version 0.3 - 22 December 2013 -

	:: NEW! Introduces Support to Ant Project  


version 0.2 - 14 December 2013 -

	:: NEW! Introduces Android [GUI] Components Bridges - Based on Simonsayz's controls 
	 

	:: revision 0.1 - 09 September - 2013 - Bugs fixs!


version 0.1 - August 2013 -


	[1] Warning: at the moment this code is just a *proof-of-concept*
      

I. INSTALL Laz4Android (https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149)

      
      warning: the original laz4android1.1-41139 is win32 and just for Android NDK-7c 

      HINT: To install/reinstall a package open a "dummy" windows project.... you always MUST close the cross compile project! 
  

   1. From Laz4Android IDE (laz4android1.1-41139)  - Install Wizard Packages

      1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"

	  Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

      1.1.1 From Package Wizard

            - Compile
            - Use -> Install
 
      1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
   
      1.2.1 From Package Wizard

            - Compile
            - Use -> Install


II. GENERIC USE [No GUI support]

    
1. ::Use your favorite editor: edit a class code for wrapper native methods 
     and save in your project folder as ex. "JNIHello.java"

        ex code:

	public class JNIHello {

	   public native String getString(int flag); 
	   public native int getSum(int x, int y);

           static {
		try {
     		    System.loadLibrary("jnihello");  //*	     	   
		} catch(UnsatisfiedLinkError ule) {
		    ule.printStackTrace();
		}
           }

        }  

   
       * warning: System.loadLibrary("...") must match class Name "lowercase"...
         ex. JNIHello -> "jnihello"
  

   ::IF Eclipse IDE:

      - File -> New -> Android Application Project ...[Next], [Next]...[Finish]!

      - From Package Explore -> src
    
       :Right click your recent created package -> new -> class  
    
       :Enter new class name... (ex. JNIHello) 
   
       :Edit your class code for wrapper native methods....
   
      
2. From Laz4Android IDE 

   2.1. On "Create a new project" Dialog select: <JNI Android Module> 

	     ref. Image: https://www.opendrive.com/files?Ml8zNjg3MDU0MV9nTXZsdA


   2.2. From "Android Module Wizard: Configure Paths"

             ref. Image: https://www.opendrive.com/files?Ml8zNjg3MDU0MV9nTXZsdA
                         

     -Path to Java JDK
     
         ex. C:\Program Files (x86)\Java\jdk1.7.0_21

     -Path to Android SDK

         ex. C:\adt32\sdk

     -Path to Ant bin  (download: http://ant.apache.org/bindownload.cgi)

         ex. C:\adt32\ant\bin

     -Path to Ndk Plataforms

         ex. C:\adt32\ndk7\platforms\android-8\arch-arm\usr\lib
 

     -Path to Ndk Toolchain  
        
	ex. C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3 
     

     -Path to  Simonsayz's  code  templates (App.java + Controls.java):   //**
     
	ex. C:\laz4android\components\LazAndroidWizard\java


    -Path to Workspace

         ex. C:\adt32\eclipse\workspace

         ex. C:\adt32\ant\workspace


    -[Select] Eclipse Project or [Enter] Ant Project Name:		                                             
 
	ex.[eclipse] C:\adt32\eclipse\workspace\AppDemo1	  

                                                  
	ex.[ant] AppAntDemo1             Ant Package Preface::
  			
		                         ex. "org.jmpessoa" --> warning: final will be "org.jmpessoa.appdemo1"      

     -Select other Options [Instructions; FPU; Project; GUI Controls; Target Api] 

     -Select Exclusive Ant Options [Debug, Touchtest]      


      ** needed only for Android Components Bridges [GUI Controls support]...       

   2.3. OK!


   2.4. From "Android Module Wizard: Select Java Source for JNI..."

     -From left panel/tree Select "your recent created project" -> src
 
     -From top panel/View double Click the Java wrapper class for native methods....
 
      ex. "JNIHello.java" 

   2.5. OK!  

      - Pascal JNI Interface was created! 	

   2.6. follow the code hint: "save all files to location....." {save all in \jni folder ...}

     
   2.7. Implement the Pascal JNI Interface methods.....


   2.8. From Lazarus4Android IDE

     -Run -> Build         

   2.9. Yes! You got it! ".so" was created! see \libs folder...



III. SPECIAL GUIDE FOR ANDROID BRIDGES COMPONENTS USE - NEW! Simon's Controls remake with many extensions!
        
     
  1A. IF Project Model = Eclipse: 

        1.1. File -> New -> Android Application Project
        
	1.2. [Next]
	1.3. [Next]
	1.4. [Next]
	
	1.5. On "Create Activity" Dialog select: <Blank Activity>   [Next]
             
             ref. Image: https://www.opendrive.com/files?Ml8zNjMwMDUwOF9pZm4xMQ

        1.6. On "Activity Name" Dialog enter: App  [Finish] //"App" name is mandatory!
                 
             ref. Image: https://www.opendrive.com/files?Ml8zNjMwMDE0M19aZ2dkeA
        
       	1.7  Right click your recent created project -> Close  
    
 
  1B. IF Project Model = Ant
      
        :: Nothing to do!

  
  2. From Lazarus IDE
	
	2.1. Project -> New Project 
        
	2.2. On "Create a new project" Dialog select: <JNI Android Module> 

	     ref. Image: https://www.opendrive.com/files?Ml8zNjMwMTY4MF9HMVRHRg

                         
        2.3. From "Android Module Wizard: Select Java Source for JNI..."

		-From left panel/tree Select "your recent created project" -> src

                -From top panel/View right click "App.java" file 

		-On Popup menu select/click <Get Simonsayz's Templates> 
            
		 	ref. Image: https://www.opendrive.com/files?Ml8zNjMwMjI1Ml9kOXNRag 

                -Double Click "Control.java" file...
 
		 	ref. Image: https://www.opendrive.com/files?Ml8zNjMwMjkyM183ZVd2MA

	2.4. OK  

	      - Pascal JNI Interface was created! 	


	2.5. follow the hint on code: "save all files to location....."  { \jni folder }


	2.6. From Component Palette select page <Android Bridges>

        
        	 ref. Image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg
                            
		-Put e configure some component on DataModule form... etc...


	2.7. From Lazarus IDE

		-Run -> Build
	  

IV. BUILD and RUN Android Application


    1A.  Eclipse Project

        -double click your project //that is: open the project...

        -right click your  project: -> Refresh
	
	-right click your  project: -> Run as -> Android Application


    1B. Ant Project
         
	1B.1. How to get your Android Application [Apk]: 
 
                 ref. Application Project "readme.txt"

              	 1. Double click "build.bat" to build Apk
  
  		 2. If Android Virtual Device[AVD]/Emulator target Api is running then:

        		2.1 double click "install.bat" to install the Apk on the Emulator
        		2.2 look for the Apk on the Emulator and click it!
     
        	 3. If AVD/Emulator target Api is NOT running:

        		3.1 If AVD/Emulator target Api NOT exist:
        		     3.1.1 double click "paused_create_avd*.bat" to create the AVD [\utils folder]

        		3.2 double click "launch_avd*.bat" to launch the Emulator
        		3.3 look for you Apk on the Emulator and click it!

                Hint: you can edit "*.bat" to extend/modify some command or to fix some incorrect path!
                
		Warning: After Lazarus run->build do not forget to run again: 
                         "build.bat" and "install.bat"
		
                        	
V. Yes! Lazarus/Free Pascal does RAD on Android!


VI. Download Demos 


    [Eclipse Projects]

      AppDemo1 - ref1. https://www.opendrive.com/files?Ml8zNjMwNTE0N18xVUZ2ag  
      AppDemo2 - ref2. https://www.opendrive.com/files?Ml8zNjMwNTMxN19YTHgxWg

    [Ant Projects]
      
      AppAntDemo1 - ref3. https://www.opendrive.com/files?Ml8zNjk2NDU4NF94ck5Fdw


VII. About Package, Components, LCL  and NDK libs(.so) dependency on laz4android1.1-41139 IDE cross compiler


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
            Classes, SysUtils, LResources {nedded for custom icon load...}; 

	Procedure Register;

	implementation

	Procedure Register;
	begin

	  {$I tfoo_icon.lrs}  //you custom icon

	  RegisterComponents('Android Bridges',[TFoo);

	end;

	initialization

	end.   


3. About NDK libs (.so) dependency on laz4android1.1-41139 IDE cross compiler
     

3.1.  You will two files: the first to NDK *.so lib interface and the second for you component/unit code.

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

	uses
	   And_log_h;  // <-- here is the link to NDK lib

        jLog = class(jControls)
        
        end;

	jLog  = class(jControl)
  	private
	{ Private declarations }
	protected
	{ Protected declarations }

	public
	{Public declarations }

          procedures wLog(msg: pchar);  // << -----------

	published
	{ Published declarations }
	end;

	implementation

	procedure jLog.WLog(msg: pchar);
	begin
     	    __android_log_write(ANDROID_LOG_FATAL,'crap',msg);
	end;

	end.

VIII. Ref. Lazarus forum: http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

     -Help and Hints
     -Bugs
     -Sugestions 
     -Colaborations	
     -Critics
     -Roadmap
     -etc..

IX. The work is just beginning!

X. Thank you!

    _____jmpessoa_hotmail_com_____
