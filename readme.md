[![N|Solid](https://i.imgur.com/eAIuo9U.png)](https://www.lazarus-ide.org/)

# LAMW: Lazarus Android Module Wizard
##### RAD Android! Form Designer and Components Development Model!
- LAMW is a wizard to create JNI Android loadable module (.so) and Android Apk using Lazarus/Free Pascal.

[![Version](https://img.shields.io/badge/Version-0.8.6.4-blue)](https://github.com/jmpessoa/lazandroidmodulewizard/archive/master.zip)

##### Features
- Native Android GUI
  - AppCompat and Material Design supported!
- RAD! Form designer and drag&drop component development model!
  - More than 150 components! 

# [Getting Started](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_Getting_Started.txt)

### 1. Get Lazarus for Android
- Option a) [Laz4Android 2.2.2](http://sourceforge.net/projects/laz4android/files/?source=navba) (Windows) 
   - All cross-android compilers already installed!
      - arm-android/aarch64-android/i386-android/x86_64-android/jvm-android
     - hint: Install here: "C:\laz4android2.2.2"   (not "Program Files" !!!)
   - How to:
      - Install [Laz4Android2.2.2](http://sourceforge.net/projects/laz4android/files/?source=navbar)
      - Install [LAMW](https://github.com/jmpessoa/lazandroidmodulewizard/archive/master.zip)
         - Download LAMW and unzip it in some folder 
            - recommended folder: "C:\laz4android2.2.2\components"
         - Packages installations order/sequence:
            - tfpandroidbridge_pack.lpk	(in "..../android_bridges" folder)
            - lazandroidwizardpack.lpk	(in ""..../android_wizard" folder)
            - amw_ide_tools.lpk		(in "..../ide_tools" folder)
      - Go to "2. Infrastructure Setup".  

- Option b) [LAMW Manager](https://forum.lazarus.freepascal.org/index.php/topic,45361.0.html) 
   - All in One! LAMW Manage produces a complete Lazarus for Android environment by automating the step "2. Infrastructure Setup"!   
      - [LAMW Manager Installer for Linux](https://github.com/dosza/LAMWManager-linux)
      - [LAMW Manager Installer for Windows](https://github.com/dosza/LAMWManager-win)

- Option c) [Fpcupdeluxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe/releases) (Linux and Windows) 
  - [Linux + Fpcupdeluxe + LAMW](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/docs/linux/tutorial_by_waynesherman)
- Option d) How to: Do It Yourself! 
    - d.1) Get [Lazarus2.x.y](https://sourceforge.net/projects/lazarus/files/)
    - d.2) Install [LAMW](https://github.com/jmpessoa/lazandroidmodulewizard/archive/master.zip)
         - Download LAMW and unzip it in some folder 
            - recommended folder "C:\lazarus2.x.y\components"
         - Packages installations order/sequence:
            - tfpandroidbridge_pack.lpk	(in "..../android_bridges" folder)
            - lazandroidwizardpack.lpk	(in ""..../android_wizard" folder)
            - amw_ide_tools.lpk		(in "..../ide_tools" folder)
    - d.3) Get [FPC source code](https://gitlab.com/freepascal.org/fpc/source/-/archive/main/source-main.zip) (trunk):
      - Unzip it in some folder and point up the source path in step "d.4"
    - d.4) Go to Lazarus menu "Tools" --> "[LAMW] Android Module Wizard" --> "Build FPC Cross Android" and repeat the "Build and install" process  once for each architecture.
      - (x) Armv7a + Soft (android 32 bits	<<-- tested!)
         - Build
        - Install
      - (x) Aarch64 (android 64 bits	<<-- tested!)
        - Build
        - Install

      - hint: After "build" and "install" the cross-compilers and after to do  all "2. Infrastructure" go to "3. Using LAMW" and try to create your first [New] LAMW project!
      - If you get an error "Fatal: Cannot find unit system used by fcllaz of package FCL." when trying "Run" --> "Build"  your project then go to "fpc.cfg"  (ex. "C:\lazarus2.x.y\fpc\3.2.2\bin") and:
         - change:
            ```cfg
                    #searchpath for units and other system dependent things
                    -FuC:\lazarus2.x.y\fpc\$FPCVERSION/units/$fpctarget 
                    -FuC:\lazarus2.x.y\fpc\$FPCVERSION/units/$fpctarget/*  
                    -FuC:\lazarus2.x.y\fpc\$FPCVERSION/units/$fpctarget/rtl
            ```
         - to:        
            ```cfg
                   #searchpath for units and other system dependent things
                   -FuC:\lazarus2.x.y\fpc\3.2.2/units/$fpctarget 
                   -FuC:\lazarus2.x.y\fpc\3.2.2/units/$fpctarget/*  
                   -FuC:\lazarus2.x.y\fpc\3.2.2/units/$fpctarget/rtl
           ```
         - and go to Lazarus IDE menu "Tools" -> "Options" -> "Environment"
           - "FPC Source"
             - change:
               ```cfg
                       $(LazarusDir)fpc\$(FPCVer)\source 
               ```
             - to:
               ```cfg             
                       $(LazarusDir)fpc\3.2.2\source
               ```

### 2. Infrastructure Setup  :: only for non-users of  "LAMW Manager" !!

##### 2.1 Get [Java JDK](https://adoptium.net/temurin/releases/) and [Gradle](https://gradle.org/releases/) system Apk builder
- recommended:  Java JDK 21 + Gradle version >=  8.5
- recommended:  Java JDK 17 + Gradle version >=  8.1.1
- deprecated:  Java JDK 11 + Gradle version >=  6.7.1
- minimalist alternative:  Java JDK 1.8  + Gradle version <=  6.7
  - JDK 1.8 support the limited but light [Ant](http://ant.apache.org/bindownload.cgi) system Apk build

##### 2.2 Get Android SDK
- recommended: supporting JDK 21 + Gradle version >= 8.5
  - download [commandlinetools-win-11076708_latest](https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip)
   - download [commandlinetools-linux-11076708_latest](https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip)
   - download [commandlinetools-mac-11076708_latest](https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip)
 - how To:
    - unpacked command line tools ".zip" to a "temporary" folder
    - create a directory tree like: C:\android\sdkJ21\cmdline-tools\latest
    - Copy all content from "temporary" folder to exactly "...\sdkJ21\cmdline-tools\latest"
    - Open a terminal or cmd and go to "...\sdkJ21\cmdline-tools\latest\bin"
       - run the command  >> sdkmanager "build-tools;34.0.0" "platforms;android-34" "platform-tools"
       - hint: you can get others android components by sdkmanager...
- recommended: supporting JDK 17 + Gradle version >= 8.1.1
  - download [commandlinetools-win-11076708_latest](https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip)
   - download [commandlinetools-linux-11076708_latest](https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip)
   - download [commandlinetools-mac-11076708_latest](https://dl.google.com/android/repository/commandlinetools-mac-11076708_latest.zip)
 - how To:
    - unpacked command line tools ".zip" to a "temporary" folder
    - create a directory tree like: C:\android\sdkJ17\cmdline-tools\latest
    - Copy all content from "temporary" folder to exactly "...\sdkJ17\cmdline-tools\latest"
    - Open a terminal or cmd and go to "...\sdkJ17\cmdline-tools\latest\bin"
       - run the command  >> sdkmanager "build-tools;33.0.2" "platforms;android-34" "platform-tools"
       - hint: you can get others android components by sdkmanager...
- deprecated: supporting JDK 11 + Gradle version >= 6.7.1
  - download [commandlinetools-win-9123335_latest](https://dl.google.com/android/repository/commandlinetools-win-9123335_latest.zip)
  - download [commandlinetools-linux-9123335_latest](https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip)
  - download [commandlinetools-mac-9123335_latest](https://dl.google.com/android/repository/commandlinetools-mac-9123335_latest.zip)
 - how To:
    - unpacked command line tools ".zip" to a "temporary" folder
    - create a directory tree like: C:\android\sdkJ11\cmdline-tools\latest
    - Copy all content from "temporary" folder to exactly "...\sdkJ11\cmdline-tools\latest"
    - Open a terminal or cmd and go to "...\sdkJ11\cmdline-tools\latest\bin"
       - run the command  >> sdkmanager "build-tools;33.0.2" "platforms;android-33" "platform-tools"
       - hint: you can get others android components by sdkmanager...

- minimalist alternative: supporting JDK 1.8 + limited but light [Ant](http://ant.apache.org/bindownload.cgi) system Apk build + Gradle <= 6.7
   - download  [r25.2.5-windows](https://dl.google.com/android/repository/tools_r25.2.5-windows.zip)
   - download [r25.2.5-linux](https://dl.google.com/android/repository/tools_r25.2.5-linux.zip)
   - download [r25.2.5-macosx](https://dl.google.com/android/repository/tools_r25.2.5-macosx.zip)
- how to:
    - unpacked/install the ".zip" file to a folder like "sdkJ1.8"
    - open a command line terminal or cmd and go to folder the "sdkJ1.8\tools"
    - run the command  >>android update sdk    //to open a GUI [SDK Manager](https://i.imgur.com/UbdoENt.png) 
       - go to [Tools](https://i.imgur.com/UbdoENt.png) and keep as is
          - Android SDK Tools  (installed)
          - (x) Android SDK Platform-Tools
          - (x) Android SDK Build-Tools 29.0.3 (and others more recent)
       - go to [Android R](https://i.imgur.com/JvtPqpq.png) and uncheck all! 
       - go to [Android 10 API 29](https://i.imgur.com/JvtPqpq.png) uncheck all and check only 
         - (x)SDK Platform
       - go to [Extras](https://i.imgur.com/pTpG3JO.png) and check:
          - (x)Android Support Repository
          - (x)Google USB Drive	(Windows only...)
          - (x)Google Repository
          - (x)Google Play Services
       - Install 7 or up package!
    - IMPORTANT: on command line terminal or cmd go to folder "sdkJ1.8\tools\bin"
       - run the command  >>sdkmanager --update
       - run the command  >>sdkmanager "build-tools;30.0.2" "platforms;android-33"
    - IMPORTANT: build-tools = 30.0.3 is the maximum supported in this setup!
       
##### 2.3 Get [Android NDK](https://developer.android.com/ndk/downloads/index.html)
- recommended version
   - [r21e](https://github.com/android/ndk/wiki/Unsupported-Downloads)

##### 2.4 Get [Ant](http://ant.apache.org/bindownload.cgi) builder 
- Simply extract the zip file to a convenient location...

##### 2.5 Get [Gradle](https://gradle.org/releases/) builder
- recommended versions
  - Java JDK 21: [Gradle 8.5](https://gradle.org/next-steps/?version=8.5&format=bin) or up
  - Java JDK 17: [Gradle 8.2.1](https://gradle.org/next-steps/?version=8.2.1&format=bin) or up
  - Java JDK 11: [Gradle 7.6.3](https://gradle.org/next-steps/?version=7.6.3&format=bin) or up
  - Java JDK 1.8: [Gradle 6.7](https://gradle.org/next-steps/?version=6.7&format=bin) or down
    - Use the option "extract here" to produce the folder "gradle-x.y.z" in a convenient location...
    - warning: Gradle build process need internet connection!!!

### 3. Using LAMW

- 3.1) Configure Paths:
  - Lazarus IDE menu "Tools" -> "[LAMW] Android Module Wizard" ->  ["Paths Settings ...](https://imgur.com/a/zgBCVOC)"
    - hint: [MacOs >= 10.5] Path to Java JDK auto setting as: ${/usr/libexec/java_home}
- 3.2) How to: Create and Run your first Android Apk!
    - 3.2.1) From Lazarus IDE select "Project" -> "New Project" 
    - 3.2.2) From [displayed dialog](https://imgur.com/a/spEaHsE) select "[LAMW] GUI Android Module" and "Ok"
    - 3.2.3) Fill the [displayed form](https://imgur.com/a/Q72KstF) fields and "Ok" and "Save"
      - hint: "Path to Workspace" is your projects folder!
      - hint: Accept "default" options! (but pay attention to the * signage)
      - hint: search your project folder... you will find many treasures there! (look for lazarus project in ".../jni" folder)    
  - 3.2.4) From Lazarus IDE select "Run" -> "Build"
     - Success! Your sistem is up to produce your first Android Apk!
  - 3.2.5) Configure you phone device to [debug mode/developer options](https://developer.android.com/studio/debug/dev-options) and plug it to the computer usb port
  - 3.2.6) From Lazarus IDE select "Run" -> "[LAMW] Build Apk and Run"
     - Congratulations! You are now an Android Developer!

### 4. Others References
###### [Tutorial: My First "Hello Word" App](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/AppHelloWorld.md)
###### ["Getting Started" doc](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_Getting_Started.txt)
###### ["History and Change Log" doc](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_History_and_Change_Log.txt)
###### [Getting Help: Lazarus Forum](https://forum.lazarus.freepascal.org/index.php/board,43.0.html)

[![N|Solid](https://i.imgur.com/xlfiR4A.png)](https://www.lazarus-ide.org/)
