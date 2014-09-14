# Lazarus Android Module Wizard 

> "A wizard for create JNI Android loadable module (.so) in Lazarus/Free Pascal using DataModules" 

## Author

Jose Marques Pessoa : jmpessoa@hotmail.com

## Links

* https://github.com/jmpessoa/lazandroidmodulewizard
* http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

## Acknowledgements: 
              
* Eny and Phil for the [Project wizard hints](http://forum.lazarus.freepascal.org/index.php/topic,20763.msg120823.html#msg120823)
* Felipe for the Android support
* TrueTom for the [Laz4Android Package](https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149)\*
* Simonsayz for the great work on [Android [GUI] Controls](http://forum.lazarus.freepascal.org/index.php/topic,22079.0.html)\**
* Lazarus forum community!

\* **Warning**:

* laz4android1.1-41139 work just for win32 and  Android NDK-7c and ARM
* [Newer version](https://sourceforge.net/projects/laz4android/files/?source=navbar) works for win32/Android NDK-9/{ARM and x86 !} :: Thanks again to TrueTom!

\** **Warning**:

* We use a modified and expanded version of Simonsayz's "Controls.java" 
* We use a modified and expanded version of Simonsayz's "App.java" 

## Version History

Version 0.5 - rev. 03 - 17 august 2014:

* New jLocation Component: Add Partial Support for Location Object //<<---- A suggestion and request by Fatih KILIÇ
* New jPreference Component: Add Partial Support for Preferences Object //<<---- A suggestion and request by Fatih KILIÇ
* NEW AppLocationDemo [Eclipse Project] 

Version 0.5 - rev. 02 - 14 june 2014:

* New Add Partial Support for Spinner Object //<<---- A suggestion and request by Leledumbo
* NEW AppSpinerDemo [Eclipse Project] 
* NEW AppSListViewDemo [Eclipse Project] :: fix RadioButton behavior...//<<---- A suggestion and request by Leledumbo

  **Warning**: Bluetooth support yet unfinished! [BUG?]!

Version 0.5 - rev. 01 - 06 May 2014:

* NEW Add Partial Support for Menu Object [Option Menu/SubMenu and Context Menu]! 
* NEW jMenu Component [Android Bridges EXtra]
* NEW AppMenuDemo [Eclipse Project]

Version 0.5 - 05 May 2014:

* NEW Add Component Create Wizard!

  It Now offers two new aid/assistance to increase the productivity of coding.

  1. You can now produce a almost complete pascal component code from a java wrapper class!
  2. You can now get assistance for produce the java warapper class!
      
      Please, read "fast_tutorial_jni_bridges_component_create.txt"

* New Components[Android Bridges Extra] and Demos [Eclipse Projects]: 

  * jMyHello [AppTryCode1] 
  * jMediaPlayer [AppTryCode2]
  * jTextFileManager, jDumpJavaMethods [AppTryCode3]

version 0.4 - revision: 05 - 02 March - 2014:

* Added NEW method GetText to jListView [and minor bug fix]
* Update [Eclipse] AppDemo1 [List View Demo]

version 0.4 - revision: 04 - 01 March - 2014:

* New Add Custom Row Support to jListView
* Update [Eclipse] AppDemo1 [List View Demo]

version 0.4 - revision: 03 - 19 February - 2014:

* New Add Image/BLOB Support to SQLite: jSqliteDataAccess, jSqliteCursor

version 0.4 - revision: 02 - 17 February - 2014:

* Minor update...

version 0.4 - revision: 01 - 16 February - 2014:

* New Add [Partial] Support to SQLite: jSqliteDataAccess, jSqliteCursor

  Supported FIELD_TYPE: [INTEGER, STRING, FLOAT] 

* New Eclipse project demo:  AppSqliteDemo1

version 0.4 - 08 February - 2014 -
 
* NEW! Add Support for Android API > 13

  1. A new code architecture! 
  2. A lot of code lines was fix/changed/Add!

* Fix BackButton issue. Now all Forms close correctly. [See AppDemo1]   

  **Warning**: compatibility issue:

  1. jForm:
      
      * no more has the property "BackButton".       
      * no more has the property "MainActivity".
      * Indeed, now there is property "ActivityMode": (actMain, actSplash, actDisposable, actRecyclable). Please,  edit/modify you *.lfm before loading your old project 
  2. jEditText:

      * no more has the property "SingleLine". Please,  edit/modify you *.lfm before loading your old project 
        
  3. jView:

      * the Canvas property  now is a component property. Please, drop the new jCanvas component and set/configure it.[See AppDemo1]

      * known issues: 
        
          jEditText1: the "InputTypeEx" property at the moment is just "dummy". Indeed, it is hard coded as "itxMultiLine", others values crash app! Why? 
            
* The [Projects] Demos were updated. 

  * known issues:

      AppDemo1: jCanvasES2 demo: [2D an 3D]: the draw disappear on the [second] button click after the BackButton pressed...

version 0.3 - revision 0.3 - 30 December 2013:

* New! Add Option to Select Android Platform 

version 0.3 - revision 0.2 - 29 December 2013 -

* New! Support for Linux! Thanks to Leledumbo!
  
  by Leledumbo for Linux users:

  1. Build all libraries in the  ../LazAndroidWizard/linux/dummylibs
  2. Put it somewhere ldconfig can find (or just run ldconfig with their directories as arguments)

  http://forum.lazarus.freepascal.org/index.php/topic,21919.msg137216/topicseen.html:

  >  "The idea of this is just to make the package installable in the [Lazarus for Linux] IDE, applications will still use the android version of the libraries."

version 0.3 - revision 0.1 - 28 December 2013 -
 
* New! Introduces Support for multi build modes [ArmV6, ArmV7a, x86]

version 0.3 - 22 December 2013 -

* NEW! Introduces Support to Ant Project  

version 0.2 - 14 December 2013 -

* NEW! Introduces Android [GUI] Android Components Bridges - Based on Simonsayz's controls 

version 0.1 - revision 0.1 - 09 September - 2013 -   

* Bugs fixs!

version 0.1 - August 2013 -

* Warning: at the moment this code is just a *proof-of-concept*

## Installation

I. INSTALL [Laz4Android](https://skydrive.live.com/?cid=89ae6b50650182c6&id=89AE6B50650182C6%21149)

**Warning**: original laz4android1.1-41139 win32/Android NDK-7c/ARM

NEW! [win32/Android NDK-9/{ARM and x86 !}](https://sourceforge.net/projects/laz4android/files/?source=navbar) :: Thanks to TrueTom!

HINT: to compile/install/reinstall a package in Laz4Android, please, open a "dummy" windows project.... you always MUST close the cross compile project!  

  1. From Laz4Android IDE - Install Wizard Packages
    
    1. Package -> Open Package -> "tfpandroidbridge_pack.lpk"  [Android Components Bridges!]

        Ref. image: https://www.opendrive.com/files?Ml8zNjMwNDQ3NF83SzhsZg

      1. From Package Wizard

          * Compile
          * Use -> Install
 
    2. Package -> Open Package -> "lazandroidwizardpack.lpk"
   
        1. From Package Wizard

            * Compile
            * Use -> Install
               
II.  Ant Projec Development: please, read "fast_tutorial_ant_users.txt"

III. Eclipse Project Development: please, read "fast_tutorial_eclipse_users.txt"

IV. Technical Notes: dependencies on laz4android [win32] IDE cross compiler: 

--> About Package, Components, LCL  and NDK libs: *.so 

1. About Package creation: just LCLBase is permitted! not "LCL"! 
   
    * You will nedd  LCLBase Required Package for register procedure.
    * yes, other No GUI stuff is permitted.

2. About Component creation
   
  1. If you will use custom icon then you will need two files: the first to compoment(s) code and the second for Register procedure code.

      example:

      1. File 1 - foo.pas - component code - here no LCL dependency at all!

        ```pascal
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
        ```

      2. File 2 - regtfoo.pas - register component code -  here you will nedd LCLBase for LResources unit

        ```pascal
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
        ```

[Edited 04-May-2014] :: WARNING:  Please, read the  NEW "fast_tutorial_jni_bridges_component_create.txt" - 

3. About NDK libs (.so) dependency on laz4android [win32] IDE cross compiler

  1.  You will need two files: the first to NDK *.so lib interface and the second for you component/unit code.

      Example:

      1. File 1 - "And_log_h.pas" - the header interface file

        ```pascal
unit And_log_h;

{$mode delphi}

interface

const 
  libname='liblog.so';
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
        ```

      2. File 2 - "And_log.pas" - component/unit code

        ```pascal
unit And_log;

interface

uses
  And_log_h;  // <-- here is the link/bind to NDK lib

type

  jLog = class(jControls)  
  end;

  jLog  = class(jControl)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
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
        ```

V. Ref. Lazarus forum: http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

* Help and Hints
* Bugs : {known bug: fail on Api > 13. Temporary solution: a workaround to prevent Api > 13 - 02 jan 2014}
* Suggestions 
* Colaborations 
* Critics
* Roadmap
* etc..

VI. The work is just beginning!

VII. Thank you!

jmpessoa@hotmail.com