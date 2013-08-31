
Lazarus Android Module Wizard 

"A wizard for create JNI Android loadable module (.so) in Free Pascal using DataModules" 


Author: Jose Marques Pessoa : jmpessoa__hotmail_com

Acknowledgements: Eny and Phil for the Project wizard hints...
                  http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823

                  Felipe for Android support

                  TrueTom for Laz4Android Package (laz4android1.1-41139)
                  https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149

                  Lazarus forum community! 


version 0.1 - August 2013

[1]Warning: at the moment this code is just a *proof-of-concept*
      

(*....................................................................*)


I. INSTALL LAZARUS PACKAGE (laz4android1.1-41139)

   1. From lazarus IDE

      1.1 Package -> Open Package -> "lazandroidwizardpack.lpk"
   
      1.2 From Package Wizard
          1.2.1 Compile
          1.2.2 Use -> Install


(*....................................................................*)


II. USE

1. From Eclipse IDE

  1.1. File -> New -> Android Application Project

  1.2. From Package Explore -> src
    
       Right click your recent created package -> new -> class  
    
       Enter new class name... (ex. JNIHello) 
   
       Edit class code for wrapper native methods (ex...)
   
	public class JNIHello {

	   public native String getString(int flag); 
	   public native int getSum(int x, int y);

           static {
		try {
     		    System.loadLibrary("jnihello");  	     	   
		} catch(UnsatisfiedLinkError ule) {
		    ule.printStackTrace();
		}
           }

	}  


  1.3. warning: System.loadLibrary("...") must match class Name lower case...
       ex. JNIHello -> "jnihello"


2. From lazarus IDE (laz4android1.1-41139) 

   2.1 Project -> New Project
   2.2 JNI Android Module

2.1. From JNI Android Module set Paths
   2.1.1 Path to Eclipse Workspace
       ex. C:\adt32\eclipse\workspace
           
   2.1.2 Path to Ndk Plataforms
       ex. C:\adt32\ndk7\platforms\android-8\arch-arm\usr\lib
 
   2.1.3 Path to Ndk Toolchain  
       ex. C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3 

2.2. From JNI Android Module select Java wrapper class for native methods.... (ex JNIHello)

2.3. OK!  

2.4. follow the code hint: "save all files to location....."

2.5. From Lazarus IDE (laz4android1.1-41139)
     Run -> Build 


(*....................................................................*)


III. RUN APPLICATION


     1.  From Eclipse IDE

     1.1 right click your recent created project -> Run as -> Android Application


IV. Have Fun!