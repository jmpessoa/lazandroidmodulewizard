[![N|Solid](https://i.imgur.com/eAIuo9U.png)](https://github.com/jmpessoa/lazandroidmodulewizard)

# Hello World App!

[![Build Status](https://img.shields.io/badge/version-0.1-green)](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI)

### _How to: Create and Run your first "Hello World!" Android App_
[![N|Solid](https://i.imgur.com/iSbNNtB.jpg)](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI)

1.0) From Lazarus IDE select "Project" -> "New Project" 

1.1) From [displayed dialog]([Imgur](https://i.imgur.com/34lqo0N.png)) select "[LAMW] GUI Android Module" and "Ok"

1.2) Fill the [form/dialog]([Imgur](https://i.imgur.com/6pn9cyP.png)) fields and "Ok" and "Save" to path that is showed ...
   - hint: "Path to Workspace" is your projects folder
   - hint: Accept "default" options! (but pay attention to the * signage)
   - hint: search your project folder... you will find many treasures there! (look for lazarus project in ".../jni" folder)    
   
1.3) From Lazarus IDE select "Run" -> "Build" 
   - Success! Your sistem is up to produce your first Android Apk!

1.4) From "Android Bridge" component tab select a [jImageView](https://i.imgur.com/UHbcuBQ.png) and drop it on Form designer 
   - set property: PosRelativeToParent  = [rpTop, rpCenterHorizontal]  
   - set property: ImageIndentifier = ic_launcher

1.5) From "Android Bridge" component tab select a [jTextView](https://i.imgur.com/UHbcuBQ.png) and drop it on Form designer 
   - set property: PosRelativeToParent  = [rpCenterInParent]  
   - set property: Text = My First "Hello World!" App

1.6) From "Android Bridge" component tab select a [jButton](https://i.imgur.com/UHbcuBQ.png) and drop it on Form designer 
   - set property: Anchor = jTextView1
   - set property: PosRelativeToAnchor = [raBelow]
   - set property: PosRelativeToParent = [rpCenterHorizontal]
   - set property: LayoutParamWidth = lpTwoThirdOfParent
   - set property: Text = Say Hello!
   - fire event property [OnClick](https://i.imgur.com/pXAqloK.png) and write some code: SowMessage('Hello Android World!')

1.7) From Lazarus IDE select "Run" -> "Build" 
   - Success! No bugs in the code!
   
1.8) Configure you phone device to [debug mode](https://developer.android.com/studio/debug/dev-options) and plug it to the computer usb port 
   - Go to phone Settings ->  more/aditional -> Developer options and check:
     - (x) stay awake
     - (x) usb debugging
     - (x) verify apps via usb
     
1.9) Go to Lazarus IDE menu "Run" -> "[LAMW] Build Apk and Run"  
   - Congratulations!

2.0) How to get more/others ".so" chipset builds
- Google Play require APKs to include both 32 and 64 bits version of LAMW "*.so" libraries
    - From LazarusIDE menu:
       - Project -> Project Options -> Project Options -> [LAMW] Android Project Options -> "Build" -> Chipset [select!] -> [OK]
       
    - From LazarusIDE menu:
       - Run -> Clean up and Build...
       
    - From LazarusIDE menu:
       - [LAMW] Build Android Apk and Run

2.1) About LAMW components palettes:
- [Android Bridges] and [Android Bridges Extra] need only "Ant" builder
- [Android Bridges AppCompat] and [Android Bridges jCenter] are online libraries and need "Gradle" builder and Internet connection


### Others references...
##### [GUI Design WYSIWYG](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/docs/GUIDesignWYSIWYG.md)
##### [Multi-Form demo](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI/AppTest1)
##### [All GUI demos](https://github.com/jmpessoa/lazandroidmodulewizard/tree/master/demos/GUI)

