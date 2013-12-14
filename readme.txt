
Lazarus Android Module Wizard 
				

"A wizard for create JNI Android loadable module (.so) in Lazarus/Free Pascal using DataModules" 


      Author: Jose Marques Pessoa : jmpessoa__hotmail_com

		 https://github.com/jmpessoa/lazandroidmodulewizard

	         http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

 	      Acknowledgements: Eny and Phil for the Project wizard hints...

                 http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823

              Felipe for the Android support...

              TrueTom for the Laz4Android Package (laz4android1.1-41139)
                  	
		https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149
              
             Simonsayz for the great work on Android [GUI] Controls

                http://forum.lazarus.freepascal.org/index.php/topic,22079.0.html

             Lazarus forum community! 


version 0.2 - December 2013 -

	:: NEW! Introduces Android GUI Components - Based on Simonsayz's controls [item IV] 
	 

	:: revision 0.1 - 09 September - 2013 - Bugs fixs!


version 0.1 - August 2013 -


	[1] Warning: at the moment this code is just a *proof-of-concept*
      

I. INSTALL Laz4Android (https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149)

      warning: the original laz4android1.1-41139 is win32 and just for Android NDK-7c 

   1. From lazarus IDE - Install Wizard Packages

      1.1 Package -> Open Package -> "tfpandroidbridge_pack.lpk"

	  Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

      1.1.1 From Package Wizard

            - Compile
            - Use -> Install
 
      1.2 Package -> Open Package -> "lazandroidwizardpack.lpk"
   
      1.2.1 From Package Wizard

            - Compile
            - Use -> Install


II. GENERIC USE

1. From Eclipse IDE - Create Android Project

  1.1. File -> New -> Android Application Project ...[Next], [Next]...[Finish]!

  1.2. From Package Explore -> src
    
       :Right click your recent created package -> new -> class  
    
       :Enter new class name... (ex. JNIHello) 
   
       :Edit class code for wrapper native methods
   
        ex:

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

   
  1.3. * warning: System.loadLibrary("...") must match class Name "lowercase"...
       ex. JNIHello -> "jnihello"
       
   
2. From lazarus IDE (laz4android1.1-41139) 

   2.1. On "Create a new project" Dialog select: <JNI Android Module> 

	     ref. Image: https://www.opendrive.com/files?Ml8zNjMwMTY4MF9HMVRHRg

   2.2. From "Android Module Wizard: Configure Paths"

	Ref. Image: https://www.opendrive.com/files?Ml8zNjMwMTk0Nl9hNEtBUw

     -Path to Eclipse Workspace

         ex. C:\adt32\eclipse\workspace
           
     -Path to Ndk Plataforms

         ex. C:\adt32\ndk7\platforms\android-8\arch-arm\usr\lib
 
     -Path to Ndk Toolchain  
        
	ex. C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3 
     
     -Path to  Simonsayz's  code  templates (App.java + Controls.java):   //**
     
	ex. C:\laz4android\components\LazAndroidWizard\java
 
     -Select [Eclipse] Project Name:                                     //**
 
	ex. C:\adt32\eclipse\workspace\AppDemo  


      ** needed only for Android Components Bridges...       

   2.3. OK


   2.4. From "Android Module Wizard: Select Java Source for JNI..."

      -Select the Java wrapper class for native methods....
 
        ex. "JNIHello.java" 

   2.5. OK  

      - Pascal JNI Interface was created! 	

   2.6. follow the code hint: "save all files to location....." {save all in \jni folder ...}

     
   2.7. Implement the Pascal JNI Interface methods.....

   2.8. From Lazarus_FOR_ANDROID IDE

     Run -> Build         {.so was created! see \libs folders....}

   2.9. Yes! You got it!


III. BUILD and RUN ANDROID APPLICATION

	1.  From Eclipse IDE

        1.1.  double click your recent created project //that is: open project...

	1.1.  right click your recent created project -> Refresh
	
	1.2.  right click your recent created project -> Run as -> Android Application


IV. SPECIAL GUIDE FOR ANDROID BRIDGES COMPONENTS USE   - NEW! Simon Controls remake and plus!

	1. From Eclipse IDE: 

        1.1. File -> New -> Android Application Project
        
	1.2. [Next]
	1.3. [Next]
	1.4. [Next]
	
	1.5. On "Create Activity" Dialog select: <Blank Activity>   [Next]
             
             ref. Image: https://www.opendrive.com/files?Ml8zNjMwMDUwOF9pZm4xMQ

        1.6. On "Activity Name" Dialog enter: App  [Finish] //"App" name is mandatory!
                 
             ref. Image: https://www.opendrive.com/files?Ml8zNjMwMDE0M19aZ2dkeA
        
       	1.7  Right click your recent created project -> Close  

	2. From Lazarus IDE
	
	2.1. Project -> New Project 
        
	2.2. On "Create a new project" Dialog select: <JNI Android Module> 

	     ref. Image: https://www.opendrive.com/files?Ml8zNjMwMTY4MF9HMVRHRg

	2.3. From "Android Module Wizard: Configure Paths"

		-Path to Eclipse Workspace

		 	ex. C:\adt32\eclipse\workspace
           
     		-Path to Ndk Plataforms

         	 	ex. C:\adt32\ndk7\platforms\android-8\arch-arm\usr\lib
 
     		-Path to Ndk Toolchain  

        	 	ex. C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3 
     
     		-Path to  Simonsayz's  code  templates (App.java + Controls.java):  

        	 	ex. C:\laz4android\components\LazAndroidWizard\java
 
     		-Select [Eclipse] Project Name:                                   

        	 	ex. C:\adt32\eclipse\workspace\AppDemo1  

		 	ref. Image: https://www.opendrive.com/files?Ml8zNjMwMTk0Nl9hNEtBUw

         2.4. From "Android Module Wizard: Select Java Source for JNI..."

		-From left panel/tree Select src-> ...-> "your recent created project"

                -From top panel/View right click "App.java" file 

		-On Popup menu select/click <Get Simonsayz's Templates> 
            
		 	ref. Image: https://www.opendrive.com/files?Ml8zNjMwMjI1Ml9kOXNRag 

                -Double Click "Control.java" file...
 
		 	ref. Image: https://www.opendrive.com/files?Ml8zNjMwMjkyM183ZVd2MA

	2.5. OK  

	      - Pascal JNI Interface was created! 	

	2.6. follow the code hint: "save all files to location....."  { \jni folder }


	2.7. From Component Palete select page <Android Bridges>

			ref. Image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg
                            
		-Put e configure some component on DataModule form... etc...

	2.8. From Lazarus IDE

		-Run -> Build
	  

        2.9.  From Eclipse IDE

	    	-Double click recent created project     {Open project ...}

	    	-Right click your recent created project -> Refresh
     	     
		-Right click your recent created project -> Run as -> Android Application
        
	
V. Yes! Lazarus/Free Pascal does RAD on Android!


VI. Download Demos [Eclipse Projects]

    AppDemo1 - ref1. https://www.opendrive.com/files?Ml8zNjMwNTE0N18xVUZ2ag
    AppDemo2 - ref2. https://www.opendrive.com/files?Ml8zNjMwNTMxN19YTHgxWg


VII. About Package, Components and LCL  and NDK libs(.so) dependency on laz4android1.1-41139 IDE cross compiler


1. Package creation: just LCLBase is permitted! not "LCL"! 
   
   - You will nedd  LCLBase Required Package for register procedure.
   - yes, other No GUI stuff is permitted.

2. Component creation
   
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

        
  2.1.2.//file 2 regtfoo.pas - register code -  here you will nedd LCLBase for LResources unit

        unit regtfoo;

	{$mode objfpc}{$H+}

	interface

	uses
  		Classes, SysUtils, LResources{ here is the LCLBase dependency!}; 

	Procedure Register;

	implementation

	Procedure Register;
	begin

	  {$I tfoo_icon.lrs}  //you custom icon

	  RegisterComponents('Android Bridges',[TFoo);

	end;

	initialization

	end.   


3. NDK libs (.so) dependency on laz4android1.1-41139 IDE cross compiler
     

3.1.  You will two files: the first to NDK *.so lib interface and the second for you component/unit code.

	Example:


	3.1.1. File 1 - "And_log_h.pas" the header interface file
 
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

	  function LOGI(prio:longint;tag,text:pchar):longint; cdecl; varargs; external libname name '__android_log_print';


	implementation

	end.

	3.1.2. File 2 - "And_log.pas" component/unit code

	unit And_log;

	interface

	uses
	   And_log_h;  // <-- here is the link to NDK lib

	procedure log(msg: pchar); 

	implementation

	procedure log(msg: pchar);
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
