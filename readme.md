[![N|Solid](https://i.imgur.com/eAIuo9U.png)](https://www.lazarus-ide.org/)
# LAMW: Lazarus Android Module Wizard
##### RAD Android! Form Designer and Components Development Model!
- LAMW is a wizard to create JNI Android loadable module (.so) and Android Apk using Lazarus/Free Pascal.

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

##### Features
- Native Android GUI
- RAD! Form designer and drag&drop component development model!

# [Getting Started](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_Getting_Started.txt)

### 1. Get Lazarus for Android

- Option a) [Laz4Android 2.0.12](http://sourceforge.net/projects/laz4android/files/?source=navbar) (Windows) 
- - all cross-android compilers already installed!
- - - arm-android/aarch64-android/i386-android/x86_64-android/jvm-android
- - hint: Install here: "C:\laz4android2.0.12"   (not "Program Files" !!!)

- - How to:
- - - Install [Laz4Android2.0.12](http://sourceforge.net/projects/laz4android/files/?source=navbar)
- - - Install [LAMW](https://github.com/jmpessoa/lazandroidmodulewizard/archive/master.zip)
- - - - Download LAMW and unzip it in some folder 
- - - - - recommended folder: "C:\laz4android2.0.12\components"
- - - - Packages Installations order:
- - - - - tfpandroidbridge_pack.lpk	(in "..../android_bridges" folder)
- - - - - lazandroidwizardpack.lpk	(in ""..../android_wizard" folder)
- - - - - amw_ide_tools.lpk		(in "..../ide_tools" folder)
- - - Go to "2. Infrastructure".  

- Option b) [LAMW Manager](https://forum.lazarus.freepascal.org/index.php/topic,45361.0.html) 
- - All in One! LAMW Manage produces a complete Lazarus for Android environment by automating the step "2. Infrastructure"!   
- - - [LAMW Manager Installer for Windows](https://github.com/DanielOliveiraSouza/LAMW4Linux-installer)
- - - [LAMW Manager Installer for Linux](https://github.com/DanielOliveiraSouza/LAMW4Windows-installer)

- Option c) [Fpcupdeluxe](https://github.com/LongDirtyAnimAlf/fpcupdeluxe/releases) (Linux and Windows)
- Option d) Do It Yourself!

- - How to:
- - - d.1 Get [Lazarus 2.0.12](https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2064%20bits/Lazarus%202.0.12/lazarus-2.0.12-fpc-3.2.0-win64.exe/download)

- - - d.2 Install [LAMW](https://github.com/jmpessoa/lazandroidmodulewizard/archive/master.zip)
- - - - Download LAMW and unzip it in some folder 
- - - - - recommended folder "C:\laz4android2.0.12\components"
- - - - Packages Installations order:
- - - - - tfpandroidbridge_pack.lpk	(in "..../android_bridges" folder)
- - - - - lazandroidwizardpack.lpk	(in ""..../android_wizard" folder)
- - - - - amw_ide_tools.lpk		(in "..../ide_tools" folder)

- - - d.3 Get [FPC source code](https://gitlab.com/freepascal.org/fpc/source/-/archive/main/source-main.zip) (trunk):
- - - - Unzip it in some folder and point up the source path in step "d.4"
- - - d.4 Go to Lazarus menu "Tools" --> "[LAMW] Android Module Wizard" --> "Build FPC Cross Android" and repeat the "Build and install" process  once for each architecture.

- - - - (x) Armv7a + Soft (android 32 bits	<<---- tested!)
- - - - - Build
- - - - - Install
- - - - (x) aarch64 (android 64 bits	<<---- tested!)
- - - - - Build
- - - - - Install

- - - - hint: After "build" and "install" the cross-compilers and to do  all "II. Infrastructure" go to "3. Using LAMW" and try to create your first [New] LAMW project!
- - - - - If you get an error "Fatal: Cannot find unit system used by fcllaz of package FCL." when trying "Run" --> "Build"  your project try fix the "fpc.cfg" file:Go to "fpc.cfg"  (ex. "lazarus\fpc\3.2.0\bin")
- - - - - - change:
- - - - - - - '# searchpath for units and other system dependent things
- - - - - - - -FuC:\laz4android2.0.12\fpc\$FPCVERSION/units/$fpctarget 
- - - - - - - -FuC:\laz4android2.0.12\fpc\$FPCVERSION/units/$fpctarget/*  
- - - - - - - -FuC:\laz4android2.0.12\fpc\$FPCVERSION/units/$fpctarget/rtl
- - - - - - to:
- - - - - - - '# searchpath for units and other system dependent things
- - - - - - - -FuC:\laz4android2.0.12\fpc\3.2.0/units/$fpctarget 
- - - - - - - -FuC:\laz4android2.0.12\fpc\3.2.0/units/$fpctarget/*  
- - - - - - - -FuC:\laz4android2.0.12\fpc\3.2.0/units/$fpctarget/rtl
- - - - - - and Go to Lazarus IDE menu "Tools" -> "Options" -> "Environment"
- - - - - - - "FPC Source"
- - - - - - - - Change:
- - - - - - - - - $(LazarusDir)fpc\$(FPCVer)\source 
- - - - - - - - To:
- - - - - - - - - $(LazarusDir)fpc\3.2.0\source

### 2. Infrastructure  :: only for non-users of  "LAMW Manager" !!

##### 2.2 Get [Java JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Warning:  Java JDK > 8 don't support [anymore] "ant" apk builder!

##### 2.2 Get Android SDK (recommended version!)
- recommended version for supporting "ant" and "gradle" system builders
- - [r25.2.5-windows](https://dl.google.com/android/repository/tools_r25.2.5-windows.zip)
- - [r25.2.5-linux](https://dl.google.com/android/repository/tools_r25.2.5-linux.zip)
- - [r25.2.5-macosx](https://dl.google.com/android/repository/tools_r25.2.5-macosx.zip)

##### 2.3 Get [Android NDK](https://developer.android.com/ndk/downloads/index.html)
- recommended version
- - [r19c](https://github.com/android/ndk/wiki/Unsupported-Downloads)

##### 2.3 Get [Ant](http://ant.apache.org/bindownload.cgi) buider system 
- Simply extract the zip file to a convenient location...

##### 2.3 Get [Gradle](https://gradle.org/releases/) buider system
- recommended version
- - [6.6.1](https://gradle.org/next-steps/?version=6.6.1&format=bin)
- - - Use the option "extract here" to produce the folder "gradle-6.6.1" in a convenient location...
- - - - warning: Gradle >= 7  don't supported by LAMW, yet! 
- - - - warning: Gradle 6.x.y  don't support Java > 13!
- - - - warning: Gradle build process need internet connection!!!

### 3. Using LAMW

- 3.1 Configure Paths:
- - Lazarus IDE menu "Tools" -> "[LAMW] Android Module Wizard" ->  "Paths Settings ..."
- - - hint: [MacOs >= 10.5] Path to Java JDK auto setting as: ${/usr/libexec/java_home}
- 3.2 How to: Create and Run your first Android Apk!
- - 3.2.1 From Lazarus IDE select "Project" -> "New Project" 
- - 3.2.2 From displayed dialog select "[LAMW] GUI Android Module" and "Ok"
- - 3.2.3 Fill the form/dialog fields and "Ok" and "Save"
- - - hint: "Path to Workspace" is your projects folder!
- - - hint: Accept "default" options!
- - 3.2.4 From Lazarus IDE select "Run" -> "Build"
- - - Success! Your sistem is up to produce your first Android Apk!
- - 3.2.5 Configure you phone device to "debug mode" and plug it to computer usb port
- - 3.2.6 From Lazarus IDE select "Run" -> "[LAMW] Build Apk and Run"
- - - Congratulations! You are now an Android Developer!

### 4. Others References

###### [Getting_Started "doc"](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_Getting_Started.txt)
###### [History and Change Log "doc"](https://github.com/jmpessoa/lazandroidmodulewizard/blob/master/docs/LAMW_History_and_Change_Log.txt)
###### [Lazarus Forum](https://forum.lazarus.freepascal.org/index.php/board,43.0.html)
