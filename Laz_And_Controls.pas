//------------------------------------------------------------------------------
//
//   Native Android Controls for Pascal
//
//   Compiler   Free Pascal Compiler FPC 2.7.1, ( XE5 in near future )
//   [and Lazarus by jmpessoa@hotmail.com - december 2013]
//
//   Developer
//              Simon,Choi / Choi,Won-sik , 최원식옹
//                           simonsayz@naver.com   
//                           http://blog.naver.com/simonsayz
//
//              LoadMan    / Jang,Yang-Ho , 장양호
//                           wkddidgh@naver.com    
//                           http://blog.naver.com/wkddidgh 
//
//   Controls
//               2012.02.26         TextView
//               2013.02.28         Button
//               2013.03.01         ImageView
//               2013.03.02         Timer
//               2013.03.03         GLSurfaceView
//               2013.03.07         ScrollView
//               2013.07.13         Form
//               2013.07.14         WebView,CheckBox
//               2013.07.15         RadioButton
//               2013.07.15         ProgressBar Horizontal, Circular (spinner)
//               2013.07.22         Toast
//               2013.07.22         Dialog
//               2013.07.26         ListView
//               2013.08.11         Canvas
//               2013.08.18         OpenGL 2D
//
//   Reserved for Delphi Compatibility
//               TBevel        TBitBtn    TCalendar     TComboBox
//               TListBox      TMemo      TPageControl  TPanel
//               Tshape        TTabSheet  TStringGrid
//
//   History
//               2013.02.24 ver0.01 Started
//               2013.02.28 ver0.02 added Delphi Style
//               2013.03.01 ver0.03 added sysInfo
//                                  added ImageView
//                                  create Lazarus Project
//               2013.03.02         added Timer
//                                  fixed compiler options ( 1.6MB -> 0.7MB )
//               2013.03.03         added GLSurfaceView
//               2013.03.04         added Native Loading Jpeg,Png (NanoJpeg,BeroPng)
//                                  added GL Texture
//               2013.03.05 ver0.04 added Java Loading Png
//                                  added jIntArray example
//                                  Info. lib size ( fpc 2.6.0 800K -> fpc 2.7.1 280K )
//                                  Restructuring (Iteration #01) -----------
//               2013.03.08 ver0.05 Restructuring (Iteration #02)
//                                  added ScrollView
//                                  added Image WH,Resampler,Save
//               2013.07.13 ver0.06 added TForm
//                                  Restructuring (Iteration #03) -----------
//               2013.07.22 ver0.07 added Back Event for Close
//                                  Restructuring (Itelation #04) -----------
//                                  fixed lower form's event firing
//                                  added Custom View
//                                  added Toast
//                                  added Dialog
//               2013.07.26 ver0.08 Class,Method Cache (Single Thread,Class)
//                                  added ListView
//               2013.07.27         added Object, Class Free
//                                  rename source code
//                                  added Global Variable : App,Class
//                                  fixed close,free
//               2013.07.30 ver0.09 added TEditText Keyboard,Focus
//                                  fixed TEditText Prevent Scroll when 1-Line
//               2013.08.02 ver0.10 added TextView - Enabled
//                                  added ListView - Font Color,Size
//                                  added Control - Color
//                                  added Form - OnClick
//               2013.08.03         added WebView - JavaScript, Event
//               2013.08.05 ver0.11 added Form Object
//                                  Restructuring (Iteration #05) -----------
//                                  jDialogProgress
//               2013.08.11 ver0.12 added Canvas
//                                  added Direct Bitmap access
//               2013.08.14 ver0.13 Fixed Memory Leak
//               2013.08.18 ver0.14 added OpenGL ES1 2D (Stencil)
//               2013.08.21 ver0.15 Fixed jImageBtn Memory Leak
//                                  Fixed Socket Buffer
//               2013.08.23 ver0.16 Fixed Memory Leak for Form,Control
//                                  added Form Stack
//               2013.08.24 ver0.17 added Thread
//               2013.08.26 ver0.18 added OpenGL ES2 2D/3D
//                                  added Button Font Color/Height
//               2013.08.31 ver0.19 added Unified OpenGL Canvas
//                                  added OpenGL ES1,ES2 Simulator
//               2013.09.01 ver0.20 added GLThread on Canvas
//                                  fixed OpenGL Crash
//                                  rename example Name
//               2013.09.06 ver0.21 added Camera Activity
//               2013.09.08 ver0.22 added OpenGL Basic Drawing API
//                                  fixed jImageBtn's Enabled
//
//   
//   Reference Sites
//               http://wiki.freepascal.org/Android_Programming
//               http://wiki.freepascal.org/Android4Pascal
//               http://wiki.freepascal.org/Android_Interface/Native_Android_GUI
//               http://zengl.org/
//
//   Known Bugs
//               2013.03.01 Fixed : Asset 
//               2013.07.15 Fixed : Destroy Mechanism
//               2013.07.28 Screen Rotate Event (App -> Form individual )
//
//   To do list
//               - Custom Control : List ( Horizontal, Vertical )
//               - Network : Http Get/Post , File Up/Down
//               - Jpeg Loading 1/2, 1/4, 1/8
//
//------------------------------------------------------------------------------
unit Laz_And_Controls; {A modified (DataModule based) version of the simonsayz's "And_Controls.pas"}
                       {for Lazarus Android Module Wizard}
                       {Author: jmpessoa@hotmail.com}
                       {Start: 2013-10-26}
                       {Ver_0.1 - 08-december-2013}
                       {Ver_0.2 - 08-february-2014: Add support to API > 13}
{$mode delphi}

interface

uses
  SysUtils, Classes, Math,
  And_jni, And_jni_Bridge,
  And_lib_Unzip, And_bitmap_h, CustApp {by jmpessoa};

const

  //by jmpessoa
  TARGBColorBridgeArray: array[0..143] of DWord = (
    $FF000000,$FF98FB98,$FF9932CC,$FF9ACD32,$FFA0522D,
    $FFA52A2A,$FFA9A9A9,$FFADD8E6,$FFADFF2F,$FFAFEEEE,
    $FFB0C4DE,$FFB0E0E6,$FFB22222,$FFB8860B,$FFBA55D3,
    $FFBC8F8F,$FFBDB76B,$FFC0C0C0,$FF000080,$FFC71585,
    $FFCD5C5C,$FFCD853F,$FFD02090,$FFD19275,$FFD2691E,
    $FFD2B48C,$FFD3D3D3,$FF00008B,$FFD87093,$FFD8BFD8,
    $FFDA70D6,$FFDAA520,$FFDC143C,$FFDCDCDC,$FFDDA0DD,
    $FFDEB887,$FFE0FFFF,$FFE6E6FA,$FFE9967A,$FFEE82EE,
    $FFEEE8AA,$FFF08080,$FFF0E68C,$FFF0F8FF,$FFF0FFF0,
    $FFF0FFFF,$FFF4A460,$FFF5DEB3,$FFF5F5DC,$FFF5F5F5,
    $FFF5FFFA,$FFF8F8FF,$FFFA8072,$FFFAEBD7,$FFFAF0E6,
    $FFFAFAD2,$FF191970,$FFFDF5E6,$FFFF0000,$FFFF00FF,
    $FFFF00FF,$FFFF1493,$FFFF4500,$FFFF6347,$FFFF69B4,
    $FFFF7F50,$FFFF8C00,$FFFFA07A,$FFFFA500,$FFFFB6C1,
    $FFFFC0CB,$FFFFD700,$FFFFDAB9,$FFFFDEAD,$FFFFE4B5,
    $FFFFE4C4,$FFFFE4E1,$FFFFEBCD,$FFFFEFD5,$FFFFF0F5,
    $FFFFF5EE,$FFFFF8DC,$FFFFFACD,$FFFFFAF0,$FFFFFAFA,
    $FFFFFF00,$FFFFFFE0,$FFFFFFF0,$FFFFFFFF,$FF1E90FF,
    $FF0000CD,$FF20B2AA,$FF228B22,$FF0000FF,$FF006400,
    $FF2E8B57,$FF2F4F4F,$FF008000,$FF008080,$FF32CD32,
    $FF008B8B,$FF3CB371,$FF40E0D0,$FF4169E1,$FF4682B4,
    $FF483D8B,$FF48D1CC,$FF00BFFF,$FF4B0082,$FF00CED1,
    $FF556B2F,$FF5F9EA0,$FF00FA9A,$FF00FF00,$FF00FF7F,
    $FF00FFFF,$FF00FFFF,$FF6495ED,$FF66CDAA,$FF696969,
    $FF6A5ACD,$FF6B8E23,$FF708090,$FF778899,$FF7B68EE,
    $FF7CFC00,$FF7FFF00,$FF7FFFD4,$FF800000,$FF800080,
    $FF808000,$FF808080,$FF8470FF,$FF87CEEB,$FF87CEFA,
    $FF8A2BE2,$FF8B0000,$FF8B008B,$FF8B4513,$FF8FBC8F,
    $FF90EE90,$FF9370D8,$FF9400D3,$00000000);

  //by jmpessoa
  TProgressBarStyleArray: array[0..7] of DWord = ($01010077,
                                                  $01010078,
                                                  $01010287,
                                                  $0101007a,
                                                  $01010289,
                                                  $01010079,
                                                  $0101020f,
                                                  $0101013c);
  //by jmpessoa
  TInputTypeExArray: array[0..31] of DWord=($00000000,
                                            $00000001,
                                            $00001001,
                                            $00002001,
                                            $00004001,
                                            $00008001,
                                            $00010001,
                                            $00020001,
                                            $00040001,
                                            $00080001,
                                            $00000011,
                                            $00000021,
                                            $00000031,
                                            $00000041,
                                            $00000051,
                                            $00000061,
                                            $00000071,
                                            $00000081,
                                            $00000091,
                                            $000000a1,
                                            $000000b1,
                                            $000000c1,
                                            $000000d1,
                                            $000000e1,
                                            $00000002,
                                            $00001002,
                                            $00002002,
                                            $00000012,
                                            $00000003,
                                            $00000004,
                                            $00000014,
                                            $00000024);
  //by jmpessoa
  TScrollBarStyleArray: array[0..5] of DWord = ($00000000,
                                                $01000000,
                                                $02000000,
                                                $03000000,
                                                $00000001,
                                                $00000002);
  //by jmpessoa
  TPositionRelativeToAnchorIDArray: array[0..12] of DWord =($00000002,
                                                            $00000003,
                                                            $00000010,
                                                            $00000011,
                                                            $00000000,
                                                            $00000001,
                                                            $00000004,
                                                            $00000006,
                                                            $00000008,
                                                            $00000012,
                                                            $00000013,
                                                            $00000005,
                                                            $00000007);
   //by jmpessoa
   TPositionRelativeToParentArray: array[0..8] of DWord = ($0000000c,
                                                            $0000000a,
                                                            $00000009,
                                                            $0000000b,
                                                            $00000014,
                                                            $00000015,
                                                            $0000000e,
                                                            $0000000d,
                                                            $0000000f
                                                            {ffffffff});

   TLayoutParamsArray: array[0..1] of  DWord = ($ffffffff, $fffffffe);

   TGravityArray: array[0..11] of  DWord = ($00000050,
                                            $00000011,
                                            $00000001,
                                            $00000010,
                                            $00000003,
                                            $00000000,
                                            $00000005,
                                            $00800003,
                                            $00000030,
                                            $00800005,
                                            $00000007,
                                            $00000070);


// ----------------------------------------------------------------------------
//  Main
// ----------------------------------------------------------------------------
//const

  //
  cjActivity_RESULT_OK                   = -1;
  cjActivity_RESULT_CANCELED             =  0;
  //

  //commented by jmpessoa
  {
  cjProgressBarStyleHorizontal           = $01010078;
  cjProgressBarStyleLarge                = $0101007a;
  }

  //
  cjORIENTATION_LANDSCAPE                =  2;
  cjORIENTATION_PORTRAIT                 =  1;
  cjORIENTATION_SQUARE                   =  3; // Deprecated API 16
  cjORIENTATION_UNDEFINED                =  0; //
  //
  cjSCREEN_ORIENTATION_UNSPECIFIED       = -1;
  cjSCREEN_ORIENTATION_LANDSCAPE         =  0;
  cjSCREEN_ORIENTATION_PORTRAIT          =  1;
  cjSCREEN_ORIENTATION_USER              =  2;
  cjSCREEN_ORIENTATION_BEHIND            =  3;
  cjSCREEN_ORIENTATION_SENSOR            =  4;
  cjSCREEN_ORIENTATION_NOSENSOR          =  5;
  cjSCREEN_ORIENTATION_SENSOR_LANDSCAPE  =  6;
  cjSCREEN_ORIENTATION_SENSOR_PORTRAIT   =  7;
  cjSCREEN_ORIENTATION_REVERSE_LANDSCAPE =  8;
  cjSCREEN_ORIENTATION_REVERSE_PORTRAIT  =  9;
  cjSCREEN_ORIENTATION_FULL_SENSOR       = 10;
  cjSCREEN_ORIENTATION_USER_LANDSCAPE    = 11;
  cjSCREEN_ORIENTATION_USER_PORTRAIT     = 12;
  cjSCREEN_ORIENTATION_FULL_USER         = 13;
  cjSCREEN_ORIENTATION_LOCKED            = 14;
  //
  cjClick_Default                        =  0;
  cjClick_Yes                            = -1;
  cjClick_No                             = -2;
  //
  cjWebView_Act_Continue                 =  0;
  cjWebView_Act_Break                    =  1;
  //
  cjWebView_OnUnknown                    =  0;
  cjWebView_OnBefore                     =  1;
  cjWebView_OnFinish                     =  2;
  cjWebView_OnError                      =  3;
  //
  cjEft_None                             = $00000000;
  cjEft_iR2L                             = $00000001;
  cjEft_oR2L                             = $00000002;
  cjEft_iL2R                             = $00000004;
  cjEft_oL2R                             = $00000008;
  cjEft_FadeIn                           = $00000010;
  cjEft_FadeOut                          = $00000020;
  //
  cjPaint_Style_Fill                     =  0;
  cjPaint_Style_Fill_And_Stroke          =  1;
  cjPaint_Style_Stroke                   =  2;
  //
  cjTask_Before                          =  0;
  cjTask_Progress                        =  1;
  cjTask_Post                            =  2;
  cjTask_BackGround                      =  3;
  //
  cjFormsMax                             = 40; // Max Form Stack Count
  //
  cjOpenGLESv1                           =  1;
  cjOpenGLESv2                           =  2;
  //
  cjMouchMax                             =  10; // Max Touch

type

  //by jmpessoa
  // ref. http://www.abpsoft.com/criacaoweb/tabcores.html
  TARGBColorBridge = (
  colbrBlack,colbrPaleGreen,colbrDarkOrchid,colbrYellowGreen,colbrSienna,
  colbrBrown,colbrDarkGray,colbrLightBlue,colbrHoneyDew,colbrPaleTurquoise,
  colbrLightSteelBlue,colbrPowderBlue,colbrFireBrick,colbrDarkGoldenRod,
  colbrMediumOrchid,colbrRosyBrown,colbrDarkKhaki,colbrSilver,colbrNavy,
  colbrMediumVioletRed,colbrIndianRed,colbrPeru,colbrVioletRed,colbrFeldspar,
  colbrChocolate,colbrTan,colbrLightGrey,colbrDarkBlue,colbrPaleVioletRed,
  colbrThistle,colbrOrchid,colbrGoldenRod,colbrCrimson,colbrGainsboro,
  colbrPlum,colbrBurlyWood,colbrLightCyan,colbrLavender,colbrDarkSalmon,
  colbrViolet,colbrPaleGoldenRod,colbrLightCoral,colbrKhaki,colbrAliceBlue,
  colbrGreenYellow,colbrAzure,colbrSandyBrown,colbrWheat,colbrBeige,
  colbrWhiteSmoke,colbrMintCream,colbrGhostWhite,colbrSalmon,colbrAntiqueWhite,
  colbrLinen,colbrLightGoldenRodYellow,colbrMidnightBlue,colbrOldLace,colbrRed,
  colbrFuchsia,colbrMagenta,colbrDeepPink,colbrOrangeRed,colbrTomato,
  colbrHotPink,colbrCoral,colbrDarkOrange,colbrLightSalmon,colbrOrange,
  colbrLightPink,colbrPink,colbrGold,colbrPeachPuff,colbrNavajoWhite,
  colbrMoccasin,colbrBisque,colbrMistyRose,colbrBlanchedAlmond,colbrPapayaWhip,
  colbrLavenderBlush,colbrSeaShell,colbrCornsilk,colbrLemonChiffon,colbrFloralWhite,
  colbrSnow,colbrYellow,colbrLightYellow,colbrIvory,colbrWhite,colbrDodgerBlue,
  colbrMediumBlue,colbrLightSeaGreen,colbrForestGreen,colbrBlue,colbrDarkGreen,
  colbrSeaGreen,colbrDarkSlateGray,colbrGreen,colbrTeal,colbrLimeGreen,
  colbrDarkCyan,colbrMediumSeaGreen,colbrTurquoise,colbrRoyalBlue,colbrSteelBlue,
  colbrDarkSlateBlue,colbrMediumTurquoise,colbrDeepSkyBlue,colbrIndigo,colbrDarkTurquoise,
  colbrDarkOliveGreen,colbrCadetBlue,colbrMediumSpringGreen,colbrLime,colbrSpringGreen,
  colbrAqua,colbrCyan,colbrCornflowerBlue,colbrMediumAquaMarine,colbrDimGray,
  colbrSlateBlue,colbrOliveDrab,colbrSlateGray,colbrLightSlateGray,colbrMediumSlateBlue,
  colbrLawnGreen,colbrChartreuse,colbrAquamarine,colbrMaroon,colbrPurple,
  colbrOlive,colbrGray,colbrLightSlateBlue,colbrSkyBlue,colbrLightSkyBlue,
  colbrBlueViolet,colbrDarkRed,colbrDarkMagenta,colbrSaddleBrown,colbrDarkSeaGreen,
  colbrLightGreen,colbrMediumPurple,colbrDarkViolet,colbrNone, colbrDefault);

  //by jmpessoa
  TProgressBarStyle = (cjProgressBarStyle,
                       cjProgressBarStyleHorizontal,
                       cjProgressBarStyleInverse,
                       cjProgressBarStyleLarge,
                       cjProgressBarStyleLargeInverse,
                       cjProgressBarStyleSmall,
                       cjProgressBarStyleSmallTitle,
                       cjProgressDrawable);


  TScrollBarStyle =  (scrlInsideOverlay,
                      scrlInsideInset,
                      scrlOutsideOverlay,
                      scrlOutsideInset,
                      scrlPositionLeft,
                      scrlPositionRight, scrNone);
  //by jmpessoa
  TTextAlignment  = (taLeft, taRight, taTop, taBottom, taCenter, taCenterHorizontal, taCenterVertica);

  TGravity = (gvBottom, gvCenter, gvCenterHorizontal, gvCenterVertical, gvLeft, gvNoGravity,
              gvRight, gvStart, gvTop, gvEnd, gvFillHorizontal, gvFillVertical);

  TGravitySet = set of TGravity;

  TLanguage      = (tPascal,
                    tJava);
  TXY            = Record
                    X,Y : Integer;
                   end;
  TXYWH          = Record
                    X, Y, W, H: Integer;
                   end;
  TfXY           = Record
                    X,Y : Single;
                   end;
  TClickYN       = (ClickYes,
                    ClickNo);

  TInputType     = (itText,
                    itNumber,
                    itPhone,
                    itPassNumber,
                    itPassText,
                    itMultiLine);
  //by jmpessoa
  TInputTypeEx  =(  itxText,
                    itxNumber,
                    itxPhone,
                    itxPassNumber,
                    itxPassText,
                    itxMultiLine);

  //by jmpessoa
  //http://www.semurjengkol.com/android-relative-layout-example/#sthash.JdHGbyti.dpuf
  TPositionRelativeToAnchorID = ( raAbove,
                                  raBelow,
                                  raToStartOf,
                                  raToEndOf,
                                  raToLeftOf,
                                  raToRightOf,
                                  raAlignBaseline,
                                  raAlignTop,
                                  raAlignBottom,
                                  raAlignStart,
                                  raAlignEnd,
                                  raAlignLeft,
                                  raAlignRight);
  //by jmpessoa
  TPositionRelativeToAnchorIDSet = set of TPositionRelativeToAnchorID;

  //by jmpessoa
  //http://knowledge.lapasa.net/?p=334
  TPositionRelativeToParent = (rpBottom,
                               rpTop,
                               rpLeft,
                               rpRight,
                               rpStart,
                               rpEnd,
                               rpCenterHorizontal,
                               rpCenterInParent,
                               rpCenterVertical
                               {rpTrue});
  //by jmpessoa
  TPositionRelativeToParentSet = set of TPositionRelativeToParent;

  //by jmpessoa
  TLayoutParams = (lpMatchParent, lpWrapContent, lpHalfOfParent, lpOneQuarterOfParent,
                   lpTwoThirdOfParent ,lpOneThirdOfParent, lpOneEighthOfParent,
                   lpOneFifthOfParent, lpTwoFifthOfParent, lpThreeFifthOfParent, lpFourFifthOfParent,
                   lp16px, lp24px, lp32px, lp40px, lp48px, lp72px, lp96px);

  TSide = (sdW, sdH);

  TScreenStyle   = (ssSensor,       // by Device Status
                    ssPortrait,     // Force Portrait
                    ssLandScape);   // Force LandScape

  TWebViewStatus = (wvOnUnknown,    // WebView
                    wvOnBefore,
                    wvOnFinish,
                    wvOnError);

  TEffect        = DWord;
  TAnimation     = Record
                    In_  : TEffect;
                    Out_ : TEffect;
                   end;

  TChangeType    = (ctChangeBefore,
                    ctChange,
                    ctChangeAfter);
  // Multitouch
  TMouch         = Record  // Ref. iOS_Controls.pas TiOSMTouch
                    // Result
                    Active  : Boolean;
                    Pt      : TfXY;
                    Zoom    : Single;
                    Angle   : Single;
                    Start   : Boolean; // Multi Touch start Event
                   End;
  TMouches       = Record
                    // Input
                    Cnt     : Integer;
                    XYs     : Array[0..cjMouchMax-1] of TfXY;
                    // Status Save
                    sLen    : Single;
                    sAngle  : Single;
                    sPt     : TfXY;
                    sPt1    : TfXY;
                    sPt2    : TfXY;
                    sCount  : Integer; // Total Event Count
                    Mouch   : TMouch;  // MultiTouch Result (Pt,Zoom,Angle)
                   End;

  TLayoutRelativeTo = (lrParent, lrAnchor);

  TPaintStyle = (psFill , psFillAndStroke, psStroke); //by jmpessoa

  //
  jCanvas    = class; // Forward Declaration
  jForm      = class; // Forward Declaration

  //
  TOnNotify          = Procedure(Sender: TObject) of object;
  TOnClickEx         = Procedure(Sender: TObject; Value: integer) of object;
  TOnChange          = Procedure(Sender: TObject; EventType : TChangeType) of object;
  TOnDraw            = Procedure(Sender: TObject; Canvas: jCanvas) of object;
  TOnTouch           = Procedure(Sender: TObject; ID: integer; X, Y: single) of object;
  TOnTouchEvent      = Procedure(Sender: TObject; Touch : TMouch ) of Object;
  TOnCloseQuery      = Procedure(Sender: TObject; var CanClose: boolean) of object;
  //TOnBackButtonQuery = Procedure(Sender: TObject; var MustFree: boolean) of object;
  TOnRotate          = Procedure(Sender: TObject; rotate : integer; Var rstRotate : integer) of Object;
  TOnActivityRst     = Procedure(Sender: TObject; requestCode,resultCode : Integer; jData : jObject) of Object;
  TOnGLChange        = Procedure(Sender: TObject; W, H: integer) of object;

  TOnClickYN         = Procedure(Sender: TObject; YN  : TClickYN) of object;
  TOnClickItem       = Procedure(Sender: TObject; Item: Integer) of object;

  TOnClickWidgetItem = Procedure(Sender: TObject; Item: integer; checked: boolean) of object;

  //
  TOnWebViewStatus   = Procedure(Sender: TObject; Status : TWebViewStatus;
                                 URL : String; Var CanNavi : Boolean) of object;
  TOnAsyncEvent      = Procedure(Sender: TObject; EventType,Progress : Integer) of object;
  // App
  TEnvJni     = record
                 jEnv        : PJNIEnv;  //  a pointer reference to the JNI environment,
                 jThis       : jObject;  // JNI: a reference to the object making this call (or class if static).
                 jActivity   : jObject;  // Java Activity / android.content.Context
                 jRLayout    : jObject;  // Java Base Layout
                end;
 {
 The first parameter is the JNI environment, frequently used with helper functions.
 The second parameter is the Java object that this function is a part of.
 }

 {
   The folder "Digital Camera Image"-DCIM- store photographs from digital camera
 }

  //by jmpessoa
  TEnvPath    = record
                 App         : string;    // /data/app/com.kredix-1.apk
                 Dat         : string;    // /data/data/com.kredix/files
                 Ext         : string;    // /storage/emulated/0
                 DCIM        : string;    // /storage/emulated/0/DCIM
                 DataBase    : string;
  end;

  //by jmpessoa
  TFilePath = (fpathNone, fpathApp, fpathData, fpathExt, fpathDCIM, fpathDataBase);

  TEnvScreen =  record
                 Style       : TScreenStyle;
                 WH          : TWH;
                end;

  TEnvDevice =  record
                 PhoneNumber : string;
                 ID          : string;
                end;

  TjCallBack =  record
                 Event       : TOnNotify;
                 Sender      : TObject;
                end;

  TjFormStack=  record
                 Form        : jForm;
                 CloseCB     : TjCallBack; //Close Call Back Event
                end;

  TjForms    =  record
                 Index       : integer;
                 Stack       : array[0..cjFormsMax-1] of TjFormStack;
                end;

  TjFormState = (fsFormCreate,  // Initializing
                 fsFormWork,    // Working
                 fsFormClose);  // Closing

  //by jmpessoa
  TSqliteFieldType = (ftNull,ftInteger,ftFloat,ftString,ftBlob);
  TWidgetItem = (wgNone,wgCheckBox,wgRadioButton,wgButton,wgTextView);

  jApp = class(TCustomApplication)
  private
    FInitialized : boolean;
    FAppName     : string;
    FClassName   : string;
    FForm        : jForm;       // Main/Initial Form
    //
    Procedure SetAppName  (Value : String);
    Procedure SetClassName(Value : String);
  protected
    //
  public
    Jni           : TEnvJni;
    Path          : TEnvPath;
    Screen        : TEnvScreen;
    Device        : TEnvDevice;
    Forms         : TjForms;     // Form Stack
    Lock          : Boolean;     //
    Orientation   : integer;   //orientation on app start....

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; out Reference);
    procedure Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject);

    procedure Finish;

    function GetCurrentFormsIndex: integer;

    function GetNewFormsIndex: integer;
    function GetPreviousFormsIndex: integer;

    procedure IncFormsIndex;
    procedure DecFormsIndex;

    //properties
    property Initialized : boolean read FInitialized;
    property Form: jForm read FForm write FForm; // Main Form
    property AppName    : string     read FAppName    write SetAppName;
    property ClassName  : string     read FClassName  write SetClassName;
  end;

  TActivityMode = (actMain, actRecyclable, actDisposable, actSplash);

  jForm = class(TDataModule)
  private
    FInitialized : boolean;
    // Java
    FjObject       : jObject;      // Java : Java Object
    FjRLayout{View}: jObject;      // Java Relative Layout View
    FOrientation   : integer;
    FApp           : jApp;
    //
    FFormName      : String;       // Form name
    FScreenWH      : TWH;
    FScreenStyle   : TScreenStyle;
    FAnimation     : TAnimation;

    FEnabled       : Boolean;
    FVisible       : Boolean;
    FColor         : TARGBColorBridge;        // Background Color

    FCloseCallback : TjCallBack;   // Close Call Back Event

    FActivityMode  : TActivityMode;
    //FMainActivity  : boolean;

    FOnActive     : TOnNotify;
    FOnClose      :   TOnNotify;
    FOnCloseQuery  : TOnCloseQuery;
    FOnRotate      : TOnRotate;
    FOnClick       : TOnNotify;
    FOnActivityRst : TOnActivityRst;
    FOnJNIPrompt   : TOnNotify;
    FOnBackButton  : TOnNotify;

    Procedure setEnabled (Value : Boolean);
    Procedure setVisible (Value : Boolean);
    Procedure setColor   (Value : TARGBColorBridge);
    procedure SetOrientation(Value: integer);
    function GetView: jObject;
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    FormState     : TjFormState;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(refApp: jApp);
    procedure Finish;
    Procedure Show;
    Procedure Close;
    Procedure Refresh;
    procedure UpdateJNI(refApp: jApp);
    procedure ShowMessage(msg: string);
    function GetDateTime: String;

    Procedure SetCloseCallBack(Func : TOnNotify; Sender : TObject);
    //by jmpessoa
    Procedure UpdateLayout;
    // Property
    property View         : jObject        read FjRLayout {GetView } write FjRLayout;
    property ScreenStyle  : TScreenStyle   read FScreenStyle    write FScreenStyle;
    property Animation    : TAnimation     read FAnimation      write FAnimation;
    property Initialized  : boolean read FInitialized;
    property Orientation   : integer read FOrientation write SetOrientation;
    property Visible      : Boolean        read FVisible        write SetVisible;
    property App: jApp read FApp write FApp;

  published
    //procedure SetOnJNIPrompt(Value: TOnNotify);
    property ActivityMode  : TActivityMode read FActivityMode write FActivityMode;
    property Title: string  read FFormName write FFormName;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;
    // Event
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityRst: TOnActivityRst read FOnActivityRst write FOnActivityRst;
    property OnJNIPrompt  : TOnNotify read FOnJNIPrompt write {SetOnJNIPrompt;}FOnJNIPrompt;
    property OnBackButton : TOnNotify read FOnBackButton write FOnBackButton;
    property OnActive     : TOnNotify read FOnActive write FOnActive;
    property OnClose      : TOnNotify read FOnClose write FOnClose;
  end;

  {jControl - NEW by jmpessoa}

  jControl = class(TComponent)
  protected
    FjObject     : jObject; //Self
    FEnabled     : boolean;
    FInitialized : boolean;
  public
    property Initialized : boolean read FInitialized write FInitialized;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;  virtual;
  end;

   //NEW by jmpessoa
  jImageList = class(jControl)
  private
    FImages : TStrings;
    FFilePath: TFilePath;
    function GetCount: integer;
    procedure SetImages(Value: TStrings);
    procedure ListImagesChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function GetImageByIndex(index: integer): string;
    function GetImageExByIndex(index: integer): string;
    // Property
    property Count: integer read  GetCount;
  published
    property Images: TStrings read FImages write SetImages;
  end;

  //NEW by jmpessoa
  jHttpClient = class(jControl)
  private
   FUrl : string;
   FUrls: TStrings;
   FIndexUrl: integer;
   procedure SetIndexUrl(Value: integer);
   procedure SetUrlByIndex(Value: integer);
   procedure SetUrls(Value: TStrings);
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init; override;
   function Get: string; overload;
   function Get(location: string): string; overload;
   // Property
   property Url: string read FUrl;
  published
    property IndexUrl: integer read  FIndexUrl write SetIndexUrl;
    property Urls: TStrings read FUrls write SetUrls;
  end;

  //NEW by jmpessoa
  //warning: not for emualtor!
  jSMTPClient = class(jControl)
  private
   FMails: TStrings;
   FMailTo: string;
   FMailCc: string;
   FMailBcc: string;
   FMailSubject: string;
   FMailMessage: TStrings;
   procedure SetMails(Value: TStrings);
   procedure SetMailMessage(Value: TStrings);
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init; override;
   procedure Send; overload;
   procedure Send(mTo: string; subject: string; msg: string); overload;
   // Property
  published
   property MailTo: string read FMailTo write FMailTo;
   property MailCc: string read FMailCc write FMailCc;
   property MailBcc: string read FMailBcc write FMailBcc;
   property MailSubject: string read FMailSubject write FMailSubject;

   property Mails: TStrings read FMails write SetMails;
   property MailMessage: TStrings read FMailMessage write SetMailMessage;
  end;

  //NEW by jmpessoa
  //warning: not for emualtor!
  jSMS = class(jControl)
  private
   FMobileNumber: string;
   FContactName: string;
   FSMSMessage: TStrings;
   FContactListDelimiter: char;
   FLoadMobileContacts: boolean;
   FContactList: TStringList;
   procedure SetSMSMessage(Value: TStrings);
   function GetContactList: string;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init; override;
   procedure Send; overload;
   procedure Send(toNumber: string;  msg: string); overload;
   procedure Send(toName: string); overload;
   // Property
  published
   property MobileNumber: string read FMobileNumber write FMobileNumber;
   property ContactName: string read FContactName write FContactName;
   property SMSMessage: TStrings read FSMSMessage write SetSMSMessage;
   property LoadMobileContacts: boolean read FLoadMobileContacts write FLoadMobileContacts;
   property ContactListDelimiter: char read FContactListDelimiter write FContactListDelimiter;
  end;

  //NEW by jmpessoa
  jCamera = class(jControl)
  private
   FFilename : string;
   FFilePath: TFilePath;
  public
   FullPathToBitmapFile: string;
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init; override;
   procedure TakePhoto;
   // Property
  published
    property Filename: string read FFilename write FFilename;
    property FilePath: TFilePath read FFilePath write FFilePath;
  end;

  jTimer = class(jControl)
  private
    // Java
    FParent   : jForm;
    FInterval : integer;
    FOnTimer  : TOnNotify;

    Procedure SetEnabled(Value: boolean);
    Procedure SetInterval(Value: integer);
    //Procedure SetOnTimer(Value: TOnNotify);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init; override;
    //Property
    property Parent   : jForm     read FParent   write FParent;
  published
    property Enabled  : boolean   read FEnabled  write SetEnabled;
    property Interval : integer   read FInterval write SetInterval;
    //Event
    property OnTimer: TOnNotify read FOnTimer write FOnTimer;//SetOnTimer;
  end;

  jBitmap = class(jControl)
  private
    FWidth  : Cardinal;  //uint32_t;; //
    FHeight : Cardinal; ////uint32_t;
    FStride : Cardinal; //uint32_t
    FFormat : Integer;  //int32_t
    FFlags  : Cardinal; //uint32_t      // 0 for now

    FImageName: string;
    FImageIndex: integer;
    FImageList : jImageList;  //by jmpessoa

    { TFilePath = (fpathApp, fpathData, fpathExt, fpathDCIM); }
    FFilePath: TFilePath;

    FBitmapInfo : AndroidBitmapInfo;
    procedure SetImages(Value: jImageList);   //by jmpessoa

    procedure SetImageIndex(Value: integer);
    procedure SetImageName(Value: string);

    procedure SetImageByIndex(Value: integer);
    procedure SetImageByName(Value: string);
    function TryPath(path: string; fileName: string): boolean;

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;

    Procedure LoadFromFile(fileName : String);
    Procedure CreateJavaBitmap(w,h : Integer);
    Function  GetJavaBitmap: jObject;

    function BitmapToByte(var bufferImage: TArrayOfByte): integer;  //local/self

    function GetByteArrayFromBitmap(var bufferImage: TArrayOfByte): integer;
    procedure SetByteArrayToBitmap(var bufferImage: TArrayOfByte; size: integer);

    procedure LockPixels(var PDWordPixel: PScanLine); overload;
    procedure LockPixels(var PBytePixel: PScanByte {delphi mode} ); overload;
    procedure LockPixels(var PSJByte: PJByte{fpc mode}); overload;
    procedure UnlockPixels;

    procedure ScanPixel(PBytePixel: PScanByte; notByteIndex: integer); overload;   //TODO - just draft
    procedure ScanPixel(PDWordPixel: PScanLine);  overload; //TODO - just draft
    function GetInfo: boolean;
    function  GetRatio: Single;

    property  JavaObj : jObject           read FjObject;
    property ImageName: string read FImageName write SetImageName;
  published
    property FilePath: TFilePath read FFilePath write FFilePath;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    property  Width   : Cardinal           read FWidth      write FWidth;
    property  Height  : Cardinal           read FHeight     write FHeight;
  end;

  jDialogYN = class(jControl)
  private
    FTitle: string;
    FMsg: string;
    FYes: string;
    FNo: string;
    FParent     : jForm;
    FOnDialogYN : TOnClickYN;
  protected
    Procedure GenEvent_OnClick(Obj: TObject; Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init;  override;
    Procedure Show;
    property Parent   : jForm     read FParent   write FParent;
  published
    property Title: string read FTitle write FTitle;
    property Msg: string read FMsg write FMsg;
    property Yes: string read FYes write FYes;
    property No: string  read FNo write FNo;
    //event
    property OnClickYN: TOnClickYN read FOnDialogYN write FOnDialogYN;
  end;

  jDialogProgress = class(jControl)
  private
    FTitle: string;
    FMsg: string;
    // Java
    FjObject    : jObject; //Self
    FParent     : jForm;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init; override;
    procedure Start;
    procedure Stop;
    property Parent: jForm read FParent write FParent;
  published
    property Title: string read FTitle write FTitle;
    property Msg: string read FMsg write FMsg;
  end;

  jAsyncTask = class(jControl)
  private
    FRunning: boolean;
    FOnAsyncEvent : TOnAsyncEvent;
    FAutoPublishProgress: boolean;
    procedure SetAutoPublishProgress(Value: boolean);
  protected
    Procedure GenEvent_OnAsyncEvent(Obj: TObject;EventType,Progress : Integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    procedure Done;    //by jmpessoa
    Procedure Execute;
    Procedure UpdateUI(Progress : Integer);
    property Running: boolean read FRunning  write FRunning;
  published
    // Event
    property  OnAsyncEvent : TOnAsyncEvent read FOnAsyncEvent write FOnAsyncEvent;
    property  AutoPublishProgress: boolean read FAutoPublishProgress write SetAutoPublishProgress;
  end;

  //NEW by jmpessoa
  jSqliteCursor = class(jControl)
   private
      //FInitialized: boolean;
      //FjObject: jObject;
   protected
   public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     procedure Init; override;

     procedure MoveToFirst;
     procedure MoveToNext;
     procedure MoveToLast;
     procedure MoveToPosition(position: integer);
     function GetRowCount: integer;

     function GetColumnCount: integer;
     function GetColumnIndex(colName: string): integer;
     function GetColumName(columnIndex: integer): string;
     function GetColType(columnIndex: integer): TSqliteFieldType;
     function GetValueAsString(columnIndex: integer): string;
     function GetValueAsBitmap(columnIndex: integer): jObject;
     function GetValueAsInteger(columnIndex: integer): integer;
     function GetValueAsDouble(columnIndex: integer): double;
     function GetValueAsFloat(columnIndex: integer): real;

     procedure SetCursor(Value: jObject);
   published
   end;

  //NEW by jmpessoa
  jSqliteDataAccess = class(jControl)
  private
    FjSqliteCursor    : jSqliteCursor;
    FColDelimiter: char;
    FRowDelimiter: char;
    FDataBaseName: string;
    FCreateTableQuery: TStrings;
    FTableName: TStrings;
    procedure SetjSqliteCursor(Value: jSqliteCursor);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    Procedure ExecSQL(execQuery: string);
    function CheckDataBaseExists(dataBaseName: string): boolean;
    procedure OpenOrCreate(dataBaseName: string);
    procedure AddTable(tableName: string; createTableQuery: string);
    procedure CreateAllTables;

    function Select(selectQuery: string): string;  overload; //set cursor and return selected rows
    procedure Select(selectQuery: string); overload;  //just set  java Cursor

    procedure SetSelectDelimiters(coldelim: char; rowdelim: char);
    procedure CreateTable(createQuery: string);
    procedure DropTable(tableName: string);
    procedure InsertIntoTable(insertQuery: string);
    procedure DeleteFromTable(deleteQuery: string);
    procedure UpdateTable(updateQuery: string);
    procedure UpdateImage(tableName: string;imageFieldName: string;keyFieldName: string; imageValue: jObject;keyValue: integer);
    procedure Close;
    function  GetCursor: jObject;    overload;
  published
    property Cursor    : jSqliteCursor read FjSqliteCursor write SetjSqliteCursor;     //by jmpessoa
    property ColDelimiter: char read FColDelimiter write FColDelimiter;
    property RowDelimiter: char read FRowDelimiter write FRowDelimiter;
    property DataBaseName: string read FDataBaseName write FDataBaseName;
    property CreateTableQuery: TStrings read FCreateTableQuery write FCreateTableQuery;
    property TableName: TStrings read FTableName write FTableName;
  end;

  (*
  jMediaPlayer = class(jControl)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    procedure SetVolume(leftVolume: JFloat; rightVolume: JFloat);
    function GetDuration(): JInt;
    function GetCurrentPosition(): JInt;
    procedure SelectTrack(index: JInt);
    function IsLooping(): boolean;
    procedure SetLooping(looping: boolean);
    procedure SeekTo(millis: JInt);
    function IsPlaying(): boolean;
    procedure Pause();
    procedure Stop();
    procedure Start();
    procedure Prepare();
    procedure SetDataSource(path: string);

   published
  end;
    *)

  jVisualControl = class;
  jPanel = class;

  {jVisualControl - NEW by jmpessoa}
  jVisualControl = class(jControl)
  protected
    // Java
    FjPRLayout : jObject; // Java : Parent Relative Layout
    FParentPanel:  jPanel;
    FOrientation: integer;

    FVisible   : Boolean;
    FColor     : TARGBColorBridge;
    FFontColor : TARGBColorBridge;
    FText      : string;
    FTextAlignment: TTextAlignment;

    FFontSize  : DWord;
    FId           : DWord;
    FAnchorId     : integer;
    FAnchor       : jVisualControl;  //http://www.semurjengkol.com/android-relative-layout-example/
    FPositionRelativeToAnchor: TPositionRelativeToAnchorIDSet;
    FPositionRelativeToParent: TPositionRelativeToParentSet;

    //FGravity      : TGravitySet;    TODO: by jmpessoa  - java "setGravity"

    FLParamWidth: TLayoutParams;
    FLParamHeight: TLayoutParams;
    FMarginLeft: DWord;
    FMarginTop: DWord;
    FMarginRight: DWord;
    FMarginBottom: DWord;

    FOnClick: TOnNotify;
    procedure SetAnchor(Value: jVisualControl);
    procedure SetId(Value: DWord);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateLayout; virtual;
    function GetWidth: integer; virtual;
    function GetHeight: integer;  virtual;
    procedure SetParentPanel(Value: jPanel);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;  override;
    property AnchorId: integer read FAnchorId write FAnchorId;
    property Width: integer Read GetWidth;
    property Height: integer Read GetHeight;
    property Orientation: integer read FOrientation write FOrientation;
  published
    property Id: DWord read FId write SetId;
    property Anchor  : jVisualControl read FAnchor write SetAnchor;
    //property Gravity      : TGravitySet read FGravity write FGravity;   TODO: by jmpessoa
    property PosRelativeToAnchor: TPositionRelativeToAnchorIDSet read FPositionRelativeToAnchor
                                                                       write FPositionRelativeToAnchor;
    property PosRelativeToParent: TPositionRelativeToParentSet read FPositionRelativeToParent
                                                                 write FPositionRelativeToParent;
    property LayoutParamWidth: TLayoutParams read FLParamWidth write FLParamWidth;
    property LayoutParamHeight: TLayoutParams read FLParamHeight write FLParamHeight;
    property MarginLeft: DWord read FMarginLeft write FMarginLeft;
    property MarginTop: DWord read FMarginTop write FMarginTop;
    property MarginRight: DWord read FMarginRight write FMarginRight;
    property MarginBottom: DWord read FMarginBottom write FMarginBottom;
    property ParentPanel: jPanel read FParentPanel write SetParentPanel;
  end;

  jPanel = class(jVisualControl)
  private
    FjRLayout: jObject; // Java : Self Layout
    Procedure SetVisible    (Value : Boolean);
    Procedure SetColor      (Value : TARGBColorBridge);
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    function GetWidth: integer; override;
    function GetHeight: integer;  override;
    procedure ResetRules;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init;  override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View: jObject read FjRLayout write FjRLayout;
  published
    property Visible   : Boolean read FVisible    write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
  end;


  //http://startandroid.ru/en/lessons/complete-list/
  //http://startandroid.ru/en/lessons/complete-list/224-lesson-18-changing-layoutparams-in-a-running-application.html
  //http://stackoverflow.com/questions/13557387/align-radiobuttons-with-text-at-right-and-button-at-left-programmatically?rq=1

  jTextView = class(jVisualControl)
  private
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetEnabled  (Value : Boolean);
    Function  GetText            : string;
    Procedure SetText     (Value : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Procedure SetTextAlignment(Value: TTextAlignment);
    procedure SetParent(Value: jObject);
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Alignment : TTextAlignment read FTextAlignment write SetTextAlignment;
    property Visible   : Boolean read FVisible   write SetVisible;
    property Enabled   : Boolean read FEnabled   write SetEnabled;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property FontSize  : DWord   read FFontSize  write SetFontSize;
    property Text      : string  read FText    write SetText;
    // Event - if enabled!
    property OnClick : TOnNotify read FOnClick   write FOnClick;
  end;

  jEditText = class(jVisualControl)
  private
    FInputTypeEx: TInputTypeEx;
    FHint     : string;
    FLineMaxLength : DWord;
    FSingleLine: boolean;
    FMaxLines:  DWord;

    FScrollBarStyle: TScrollBarStyle;
    FHorizontalScrollBar: boolean;
    FVerticalScrollBar: boolean;
    FWrappingLine: boolean;

    FOnEnter  : TOnNotify;
    FOnChange : TOnChange;

    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Function  GetText            : string;
    Procedure SetText     (Value   : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Procedure SetHint     (Value : String );

    Procedure SetInputTypeEx(Value : TInputTypeEx);
    Procedure SetLineMaxLength(Value     : DWord     );
    Function  GetCursorPos           : TXY;
    Procedure SetCursorPos(Value     : TXY       );
    Procedure SetTextAlignment(Value: TTextAlignment);
    procedure SetParent(Value: jObject);
    procedure SetSingleLine(Value: boolean);
    procedure SetScrollBarStyle(Value: TScrollBarStyle);

    Procedure SetMaxLines(Value : DWord);
    procedure SetVerticalScrollBar(Value: boolean);
    procedure SetHorizontalScrollBar(Value: boolean);

  protected
    Procedure GenEvent_OnEnter (Obj: TObject);
    Procedure GenEvent_OnChange(Obj: TObject; EventType : Integer);
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    Procedure Refresh;

    procedure SetMovementMethod;
    procedure SetScrollBarFadingEnabled(Value: boolean);
    //
    Procedure SetFocus;
    Procedure immShow;
    Procedure immHide;
    Procedure UpdateLayout; override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property CursorPos : TXY        read GetCursorPos  write SetCursorPos;
    //property Scroller: boolean  read FScroller write SetScroller;
  published
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;
    property InputTypeEx : TInputTypeEx read FInputTypeEx write SetInputTypeEx;
    property LineMaxLength : DWord read FLineMaxLength write SetLineMaxLength;
    property Text      : string     read GetText       write SetText;
    property Visible   : Boolean    read FVisible      write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor        write SetColor;
    property FontColor : TARGBColorBridge      read FFontColor    write SetFontColor;
    property FontSize  : DWord      read FFontSize     write SetFontSize;
    property Hint      : string     read FHint         write SetHint;
    //property SingleLine: boolean read FSingleLine write SetSingleLine;
    property ScrollBarStyle: TScrollBarStyle read FScrollBarStyle write SetScrollBarStyle;
    property MaxLines: DWord read FMaxLines write SetMaxLines;
    property HorScrollBar: boolean read FHorizontalScrollBar write SetHorizontalScrollBar;
    property VerScrollBar: boolean read FVerticalScrollBar write SetVerticalScrollBar;
    property WrappingLine: boolean read FWrappingLine write FWrappingLine;
    // Event
    property OnEnter   : TOnNotify  read FOnEnter      write FOnEnter;
    property OnChange  : TOnChange  read FOnChange     write FOnChange;
  end;

  jButton = class(jVisualControl)
  private
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Function  GetText            : string;
    Procedure SetText     (Value   : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    procedure SetParent(Value: jObject);
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    //Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property Text      : string    read GetText    write SetText;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jCheckBox = class(jVisualControl)
  private
    FChecked   : boolean;
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Function  GetText            : string;
    Procedure SetText     (Value   : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Function  GetChecked         : boolean;
    Procedure SetChecked  (Value : boolean);
    procedure SetParent(Value: jObject);
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;

    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    property Text      : string    read GetText    write SetText;
    property Checked   : boolean   read GetChecked write SetChecked;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jRadioButton = class(jVisualControl)
  private
    //FText      : string;
    FChecked   : Boolean;
    //FOnClick   : TOnNotify;
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Function  GetText            : string;
    Procedure SetText     (Value : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Function  GetChecked         : boolean;
    Procedure SetChecked  (Value : boolean);
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;
    Procedure UpdateLayout; override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    property Text      : string    read GetText    write SetText;
    property Checked   : boolean   read GetChecked write SetChecked;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jProgressBar = class(jVisualControl)
  private
    FProgress  : integer;
    FMax       : integer;
    FStyle     : TProgressBarStyle;

    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);

    function  GetProgress: integer;
    Procedure SetProgress (Value : integer);
    function  GetMax: integer;   //by jmpessoa
    procedure SetMax (Value : integer);  //by jmpessoa

    Procedure SetStyle(Value : TProgressBarStyle);
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init; override;
    procedure Stop;
    procedure Start;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Style     : TProgressBarStyle read FStyle write SetStyle;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
    property Progress  : integer read GetProgress write SetProgress;
    property Max       : integer read GetMax write SetMax;
    property Visible   : Boolean read FVisible    write SetVisible;
  end;

  jImageView = class(jVisualControl)
  private
    //FOnClick   : TOnNotify;
    FImageName : string;
    FImageIndex: integer;
    FImageList : jImageList;  //by jmpessoa
    //FCount: integer;
    FIsBackgroundImage     : boolean;
    FFilePath: TFilePath;

    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    procedure SetParent(Value: jObject);
    procedure SetImages(Value: jImageList);   //by jmpessoa
    function GetCount: integer;
    procedure SetImageName(Value: string);
    procedure SetImageIndex(Value: integer);
    function  GetImageName       : string;
    function  GetImageIndex      : integer;
  protected
    function GetHeight: integer; override;
    function GetWidth: integer;  override;
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

      //by jmpessoa
    Procedure UpdateLayout; override;
    procedure Init; override;
    Procedure SetImageByName(Value : string);
    Procedure SetImageByIndex(Value : integer);
    procedure SetImageBitmap(bitmap: jObject);
    // Property
    property Width: integer Read GetWidth;
    property Height: integer Read GetHeight;

    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property Count: integer read GetCount;
    property ImageName : string read GetImageName write SetImageName;
  published
    property ImageIndex: integer read GetImageIndex write SetImageIndex;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    property Visible   : Boolean   read FVisible     write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor       write SetColor;
    property IsBackgroundImage   : boolean read FIsBackgroundImage    write FIsBackgroundImage;
     // Event
     property OnClick: TOnNotify read FOnClick write FOnClick;
  end;


  TTextDecorated = (txtNormal,
                    txtNormalAndItalic,
                    txtNormalAndBold,
                    txtBold,
                    txtBoldAndNormal,
                    txtBoldAndItalic,
                    txtItalic,
                    txtItalicAndNormal,
                    txtItalicAndBold);

  TItemLayout = (layImageTextWidget, layWidgetTextImage);

  TTextAlign= (alLeft, alCenter, alRight);

  TTextSizeDecorated = (sdNone, sdDecreasing, sdIncreasing);

  jListView = class(jVisualControl)
  private
    FjRLayout     : jObject; // Java : Self Layout
    FOnClickItem  : TOnClickItem;
    FOnClickWidgetItem: TOnClickWidgetItem;
    FItems        : TStrings;
    FWidgetItem   : TWidgetItem;
    FWidgetText   : string;
    FDelimiter    : string;
    FImageItem    : jBitmap;
    FTextDecorated: TTextDecorated;
    FTextSizeDecorated: TTextSizeDecorated;
    FItemLayout   : TItemLayout;
    FTextAlign     : TTextAlign;
    Procedure SetVisible      (Value : Boolean);
    Procedure SetColor        (Value : TARGBColorBridge);
    Procedure SetItemPosition (Value : TXY);
    procedure ListViewChange  (Sender: TObject);

    procedure SetItems(Value: TStrings);

    procedure SetParent(Value: jObject);
    Procedure SetFontColor    (Value : TARGBColorBridge);
    Procedure SetFontSize     (Value : DWord);
    procedure SetWidget(Value: TWidgetItem);
    procedure SetImage(Value: jBitmap);
    function GetCount: integer;
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    Procedure GenEvent_OnClick(Obj: TObject; Value: integer);
    procedure GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure Init;  override;
    function IsItemChecked(index: integer): boolean;
    procedure Add(item: string); overload;
    procedure Add(item: string; delim: string); overload;
    procedure Add(item: string; delim: string; fColor: TARGBColorBridge;
                  fSize: integer; hasWidget: TWidgetItem; widgetText: string; image: jObject); overload;
    Procedure Delete(index: Integer);
    function GetText(index: integer): string;
    Procedure Clear;
    Procedure SetFontColorByIndex(Value : TARGBColorBridge; index: integer);
    Procedure SetFontSizeByIndex(Value : DWord; index: integer  );

    procedure SetWidgetByIndex(Value: TWidgetItem; index: integer); overload;
    procedure SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer); overload;
    procedure SetWidgetTextByIndex(txt: string; index: integer);

    procedure SetImageByIndex(Value: jObject; index: integer);

    procedure SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
    procedure SetTextSizeDecoratedByIndex(value: TTextSizeDecorated; index: integer);
    procedure SetTextAlignByIndex(Value: TTextAlign; index: integer);

    procedure SetLayoutByIndex(Value: TItemLayout; index: integer);

    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java: Parent Relative Layout
    property View      : jObject   read FjRLayout  write FjRLayout; //self View
    property setItemIndex: TXY write SetItemPosition;
    property Count: integer read GetCount;
  published
    property Items: TStrings read FItems write SetItems;
    property Visible: Boolean   read FVisible   write SetVisible;
    property BackgroundColor: TARGBColorBridge read FColor     write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize  write SetFontSize;
    property WidgetItem: TWidgetItem read FWidgetItem write SetWidget;
    property WidgetText: string read FWidgetText write FWidgetText;
    property ImageItem: jBitmap read FImageItem write SetImage;
    property Delimiter: string read FDelimiter write FDelimiter;
    property TextDecorated: TTextDecorated read FTextDecorated write FTextDecorated;
    property ItemLayout: TItemLayout read FItemLayout write FItemLayout;
    property TextSizeDecorated: TTextSizeDecorated read FTextSizeDecorated write FTextSizeDecorated;
    property TextAlign: TTextAlign read FTextAlign write FTextAlign;
    // Event
    property OnClickItem : TOnClickItem read FOnClickItem write FOnClickItem;
    property OnClickWidgetItem: TOnClickWidgetItem read FOnClickWidgetItem write FOnClickWidgetItem;
  end;

  jScrollView = class(jVisualControl)
  private
    FjRLayout    : jObject; // Java : Self Layout
    FScrollSize : integer;
    Procedure SetVisible    (Value : Boolean);
    Procedure SetColor      (Value : TARGBColorBridge);
    Procedure SetScrollSize (Value : integer);
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init;  override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View      : jObject read FjRLayout   write FjRLayout;
  published
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property Visible   : Boolean read FVisible    write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
  end;

  //----------

  jHorizontalScrollView = class(jVisualControl)
  private
    FjRLayout    : jObject; // Java : Self Layout
    FScrollSize : integer;
    Procedure SetVisible    (Value : Boolean);
    Procedure SetColor      (Value : TARGBColorBridge);
    Procedure SetScrollSize (Value : integer);
    procedure SetParent(Value: jObject);
  protected
  public
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init;  override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View      : jObject read FjRLayout   write FjRLayout;
  published
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property Visible   : Boolean read FVisible    write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
  end;

  // ------------------------------------------------------------------
  jViewFlipper = class(jVisualControl)
  private
    //FOnClick  : TOnNotify;
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    procedure SetParent(Value: jObject);
  protected
  public
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init;  override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Visible   : Boolean read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
  end;

  jWebView = class(jVisualControl)
  private
    FJavaScript : Boolean;
    //
    FOnStatus   : TOnWebViewStatus;

    Procedure SetVisible   (Value : Boolean);
    Procedure SetColor     (Value : TARGBColorBridge);
    Procedure SetJavaScript(Value : Boolean);
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;

    Procedure Navigate(url: string);
    //Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property JavaScript: Boolean          read FJavaScript write SetJavaScript;
    property Visible   : Boolean          read FVisible    write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
    // Event
    property OnStatus  : TOnWebViewStatus read FOnStatus   write FOnStatus;
  end;

  jView = class(jVisualControl)
  private
    FjCanvas     : jCanvas; // Java : jCanvas
    FMouches     : TMouches;
    //
    FOnDraw      : TOnDraw;
    //
    FOnTouchDown : TOnTouchEvent;
    FOnTouchMove : TOnTouchEvent;
    FOnTouchUp   : TOnTouchEvent;
    FFilePath: TFilePath;
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    procedure SetParent(Value: jObject);
    procedure SetjCanvas(Value: jCanvas);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    function GetWidth: integer ; override;
    function GetHeight: integer;  override;
    Procedure GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnDraw (Obj: TObject; jCanvas: jObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init; override;
    Procedure SaveToFile(fileName:String);
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Canvas      : jCanvas read FjCanvas write SetjCanvas; // Java : jCanvas
    property Visible     : Boolean read FVisible write SetVisible;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    // Event - Drawing
    property OnDraw      : TOnDraw read FOnDraw write FOnDraw;
    // Event - Touch
    property OnTouchDown : TOnTouchEvent read FOnTouchDown write FOnTouchDown;
    property OnTouchMove : TOnTouchEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchUp   : TOnTouchEvent read FOnTouchUp   write FOnTouchUp;
  end;

  jImageBtn = class(jVisualControl)
  private
    FImageUpName: string;
    FImageDownName: string;
    FImageUpIndex: integer;
    FImageDownIndex: integer;

    FImageList : jImageList;  //by jmpessoa
    FFilePath: TFilePath;

    procedure SetImages(Value: jImageList);   //by jmpessoa
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetEnabled  (Value : Boolean);
    procedure SetImageDownByIndex(Value: integer);
    procedure SetImageUpByIndex(Value: integer);

    procedure SetParent(Value: jObject);
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init; override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Visible : Boolean   read FVisible   write SetVisible;
    property BackgroundColor   : TARGBColorBridge read FColor     write SetColor;
    property Enabled : Boolean   read FEnabled   write SetEnabled;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    property IndexImageUp: integer read FImageUpIndex write FImageUpIndex;
    property IndexImageDown: integer read FImageDownIndex write FImageDownIndex;
    // Event
    property OnClick : TOnNotify read FOnClick   write FOnClick;
  end;

  jCanvas = class(jControl)
  private
    FInitialized : boolean;
    //FApp         : jApp;
    // Java
    FjObject     : jObject; // Java : View

    FPaintStrokeWidth: single;
    FPaintStyle: TPaintStyle;
    FPaintTextSize: single;
    FPaintColor: TARGBColorBridge;

    Procedure setStrokeWidth       (Value : single );
    Procedure setStyle             (Value : TPaintStyle{integer});
    Procedure setColor             (Value : TARGBColorBridge);
    Procedure setTextSize          (Value : single );

  protected
  public
    //constructor Create;
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;

    procedure Init; override;
    //
    Procedure drawLine             (x1,y1,x2,y2 : single);
    // LORDMAN 2013-08-13
    Procedure drawPoint            (x1,y1 : single);
    Procedure drawText             (Text : String; x,y : single);

    Procedure drawBitmap(bmp: jObject; b,l,r,t: integer); overload;

    Procedure drawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single); overload;

    Procedure drawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single); overload;

    Procedure drawBitmap(bmp: jBitmap; b,l,r,t: integer); overload;

    // Property
    property  JavaObj : jObject read FjObject;
  published
    property PaintStrokeWidth: single read FPaintStrokeWidth write setStrokeWidth;
    property PaintStyle: TPaintStyle read FPaintStyle write SetStyle;
    property PaintTextSize: single read FPaintTextSize write SetTextSize;
    property PaintColor: TARGBColorBridge read FPaintColor write SetColor;
  end;

  jGLViewEvent = class(jVisualControl)
  private
    FInitialized : boolean;
    //
    FOnGLCreate  : TOnNotify;
    FOnGLChange  : TOnGLChange;
    FOnGLDraw    : TOnNotify;
    FOnGLDestroy : TOnNotify;
    FOnGLThread  : TOnNotify;
    //
    FMouches     : TMouches;
    //
    FOnGLDown : TOnTouchEvent;
    FOnGLMove : TOnTouchEvent;
    FOnGLUp   : TOnTouchEvent;
  protected
    //
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init; override;
    //
    Procedure GenEvent_OnTouch (Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
    property Initialized : boolean read FInitialized;
  published
    // Event - Drawing
    property OnGLCreate  : TOnNotify     read FOnGLCreate  write FOnGLCreate;
    property OnGLChange  : TOnGLChange   read FOnGLChange  write FOnGLChange;
    property OnGLDraw    : TOnNotify     read FOnGLDraw    write FOnGLDraw;
    property OnGLDestroy : TOnNotify     read FOnGLDestroy write FOnGLDestroy;
    property OnGLThread  : TOnNotify     read FOnGLThread  write FOnGLThread;
    // Event - Touch
    property OnGLDown : TOnTouchEvent read FOnGLDown write FOnGLDown;
    property OnGLMove : TOnTouchEvent read FOnGLMove write FOnGLMove;
    property OnGLUp   : TOnTouchEvent read FOnGLUp   write FOnGLUp;
  end;

  // ----------------------------------------------------------------------------
  //  Event Handler  : Java -> Pascal
  // ----------------------------------------------------------------------------

  // Activity Event
  Function  Java_Event_pAppOnScreenStyle         (env: PJNIEnv; this: jobject): integer;
  Procedure Java_Event_pAppOnNewIntent           (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnDestroy             (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnPause               (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnRestart             (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnResume              (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnStart              (env: PJNIEnv; this: jobject); //old OnActive
  Procedure Java_Event_pAppOnStop                (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnBackPressed         (env: PJNIEnv; this: jobject);
  Function  Java_Event_pAppOnRotate              (env: PJNIEnv; this: jobject; rotate : Integer) : integer;
  Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnActivityResult      (env: PJNIEnv; this: jobject; requestCode,resultCode : Integer; jData : jObject);

  // Control Event
  Procedure Java_Event_pOnDraw                   (env: PJNIEnv; this: jobject; Obj: TObject; jCanvas: jObject);
  Procedure Java_Event_pOnClick                  (env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);

  Procedure Java_Event_pOnClickWidgetItem     (env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);

  Procedure Java_Event_pOnChange                 (env: PJNIEnv; this: jobject; Obj: TObject; EventType : integer);
  Procedure Java_Event_pOnEnter                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTimer                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTouch                  (env: PJNIEnv; this: jobject; Obj: TObject;act,cnt: integer; x1,y1,x2,y2: single);

  // Control GLSurfaceView.Renderer Event
  Procedure Java_Event_pOnGLRenderer             (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);

  // Form Event
  Procedure Java_Event_pOnClose                  (env: PJNIEnv; this: jobject; Form : TObject);

  //new by jmpessoa - form Active - after form show....
  Procedure Java_Event_pOnActive                  (env: PJNIEnv; this: jobject; Form : TObject);

  // WebView Event
  Function  Java_Event_pOnWebViewStatus          (env: PJNIEnv; this: jobject; WebView : TObject; EventType : integer; URL : jString) : Integer;

  // AsyncTask Event & Task
  Procedure Java_Event_pOnAsyncEvent             (env: PJNIEnv; this: jobject; Obj : TObject; EventType,Progress : integer);

// Helper Function
Function  xy  (x, y: integer): TXY;
Function  xyWH(x, y, w, h: integer): TXYWH;
Function  fxy (x, y: Single ): TfXY;
Function  stringLen   (str: String): Integer;
//Function  getDateTime: String;
//Procedure ShowMessage(msg: string);   {the ShowMessage is a jForm member....}

Function  getAnimation(i,o : TEffect ): TAnimation;
// Asset Function (P : Pascal Native)
Function  Asset_SaveToFile (srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;
Function  Asset_SaveToFileP(srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;

// App
Procedure App_Lock; {just for Object Orientad model!}
Procedure App_UnLock;
Function  App_IsLock: Boolean;

// Touch
Procedure VHandler_touchesBegan_withEvent(Sender        : TObject;
                                          TouchCnt      : Integer;
                                          Touch1        : TfXY;
                                          Touch2        : TfXY;
                                          Var TouchDown : TOnTouchEvent;
                                          Var Mouches   : TMouches);

Procedure VHandler_touchesMoved_withEvent(Sender        : TObject;
                                          TouchCnt      : Integer;
                                          Touch1        : TfXY;
                                          Touch2        : TfXY;
                                          Var TouchMove : TOnTouchEvent;
                                          Var Mouches   : TMouches);

Procedure VHandler_touchesEnded_withEvent(Sender         : TObject;
                                          TouchCnt       : Integer;
                                          Touch1         : TfXY;
                                          Touch2         : TfXY;
                                          Var TouchUp    : TOnTouchEvent;
                                          Var Mouches    : TMouches);


//by jmpessoa
Function InputTypeToStrEx ( InputType : TInputTypeEx ) : String;
function SplitStr(var theString: string; delimiter: string): string;
function GetARGB(colbrColor: TARGBColorBridge): DWord;
function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle ): DWord;
//function GetInputTypeEx(itxType: TInputTypeEx): DWord;
function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle ): integer;
function GetPositionRelativeToAnchor(posRelativeToAnchorID: TPositionRelativeToAnchorID): DWord;
function GetPositionRelativeToParent(posRelativeToParent: TPositionRelativeToParent): DWord;

function GetLayoutParams(App: jApp; lpParam: TLayoutParams;  side: TSide): DWord;
function GetParamBySide(App: jApp; side: TSide): DWord;
function GetFilePath(filePath: TFilePath): string;

function GetGravity(gvValue: TGravity): DWord;  //TODO

var
  gApp: jApp; //global App !

implementation

// Event id for Pascal & Java
const
  cTouchDown            = 0;
  cTouchMove            = 1;
  cTouchUp              = 2;

  cRenderer_onGLCreate  = 0;
  cRenderer_onGLChange  = 1;
  cRenderer_onGLDraw    = 2;
  cRenderer_onGLDestroy = 3;
  cRenderer_onGLThread  = 4;

//------------------------------------------------------------------------------
//  Helper Function
//------------------------------------------------------------------------------

//by jmpessoa
function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;


//by jmpessoa
function GetARGB(colbrColor: TARGBColorBridge):  DWord;
var
  index: integer;
begin
  index:= (Ord(colbrColor));
  Result:= TARGBColorBridgeArray[index];
end;

//by jmpessoa
function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle): DWord;
var
  index: integer;
begin
  index:= (Ord(cjProgressBarStyle));
  Result:= TProgressBarStyleArray[index];
end;

//by jmpessoa
function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle): integer;
var
  index: integer;
begin
  if  scrlBarStyle <> scrNone then
  begin
    index:= (Ord(scrlBarStyle));
    Result:= TScrollBarStyleArray[index];
  end
  else Result:= -1;
end;

function GetPositionRelativeToAnchor(posRelativeToAnchorID: TPositionRelativeToAnchorID): DWord;
var
  index: integer;
begin
  index:= (Ord(posRelativeToAnchorID));
  Result:= TPositionRelativeToAnchorIDArray[index];
end;

function GetPositionRelativeToParent(posRelativeToParent: TPositionRelativeToParent): DWord;
var
  index: integer;
begin
  index:= (Ord(posRelativeToParent));
  Result:= TPositionRelativeToParentArray[index];
end;

function GetParamBySide(App:jApp; side: TSide): DWord;
begin
   case side of
     sdW: Result:= App.Screen.WH.Width;
     sdH: Result:= App.Screen.WH.Height;
   end;
end;

function GetLayoutParams(App:jApp; lpParam: TLayoutParams; side: TSide): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[0];
     lpWrapContent:          Result:= TLayoutParamsArray[1];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamBySide(App, side));
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamBySide(App, side));
     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamBySide(App, side));
     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamBySide(App, side));
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamBySide(App, side));
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamBySide(App, side));
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamBySide(App, side));
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamBySide(App, side));
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamBySide(App, side));
     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
  end;
end;

{
function GetInputTypeEx(itxType: TInputTypeEx ): DWord;
var
  index: integer;
begin
  index:= (Ord(itxType));
  if index = 0 then index:= 1;
  Result:= TInputTypeExArray[index];
end;
}

function GetFilePath(filePath: TFilePath): string;
begin
  Result:='';
  case filePath of
      fpathNone: Result:='';
      fpathExt: Result:= gApp.Path.Ext;
      fpathData: Result:= gApp.Path.Dat;
      fpathDCIM: Result:= gApp.Path.DCIM;
      fpathApp: Result:= gApp.Path.App;
      fpathDataBase: Result:= gApp.Path.DataBase;
  end;
end;

function GetGravity(gvValue: TGravity): DWord;
var
  index: integer;
begin
  index:= (Ord(gvValue));
  Result:= TGravityArray[index];
end;


Function  xy(x, y: integer): TXY;
 begin
  Result.x := x;
  Result.y := y;
 end;

Function XYWH(x, y, w, h: integer): TXYWH;
 begin
  Result.x := x;
  Result.y := y;
  Result.w := w;
  Result.h := h;
 end;

Function  fxy(x, y: single): TfXY;
 begin
  Result.x := x;
  Result.y := y;
 end;

// LORDMAN - 2013-07-28
Function stringLen(str: String): Integer;
 begin
  result := jStr_GetLength(gApp.Jni.jEnv, gApp.Jni.jThis, str);
 end;

{jmpessoa: see jForm
// LORDMAN - 2013-07-30
Function getDateTime: String;
begin
  result := jStr_GetDateTime(gApp.Jni.jEnv, gApp.Jni.jThis);
end;
}

{ jmpessoa: see jForm...
Procedure ShowMessage(msg: string);
begin
  if gApp = nil then Exit;
  if not gApp.Initialized then Exit;
  jToast2(gApp.Jni.jEnv, gApp.Jni.jThis, gApp.Jni.jActivity, msg);
end;
}

Function  getAnimation(i,o : TEffect ): TAnimation;
 begin
  Result.In_  := i;
  Result.Out_ := o;
 end;


Function InputTypeToStr ( InputType : TInputType ) : String;
 begin
  Result := 'TEXT';
  Case InputType of
   itText       : Result := 'TEXT';
   itNumber     : Result := 'NUMBER';
   itPhone      : Result := 'PHONE';
   itPassNumber : Result := 'PASSNUMBER';
   itPassText   : Result := 'PASSTEXT';
   itMultiLine  : Result:= 'TEXTMULTILINE';
  end;
 end;

Function InputTypeToStrEx ( InputType : TInputTypeEx ) : String;
 begin
  Result := 'TEXT';
  Case InputType of
   itxText       : Result := 'TEXT';
   itxNumber     : Result := 'NUMBER';
   itxPhone      : Result := 'PHONE';
   itxPassNumber : Result := 'PASSNUMBER';
   itxPassText   : Result := 'PASSTEXT';
   itxMultiLine  : Result := 'TEXTMULTILINE';
  end;
 end;


Function IntToWebViewStatus( EventType : Integer ) : TWebViewStatus;
 begin
  Case EventType of
   cjWebView_OnBefore : Result := wvOnBefore;
   cjWebView_OnFinish : Result := wvOnFinish;
   cjWebView_OnError  : Result := wvOnError;
   else                 Result := wvOnUnknown;
  end;
 end;

//-----------------------------------------------------------------------------
// Asset
//-----------------------------------------------------------------------------

// srcFile  'test.txt'
// outFile  '/data/data/com/kredix/files/test.txt'


Function  Asset_SaveToFile(srcFile, outFile : String; SkipExists : Boolean = False) : Boolean;
 begin
  Result := True;
  //If SkipExists = True then
  // If FileExists(outFile) then Exit;
  jAsset_SaveToFile(gApp.Jni.jEnv,gApp.Jni.jThis,srcFile,outFile);
  Result := FileExists(outFile);
 end;

// PkgName  '/data/app/com/kredix-1.apk'
// srcFile  'assets/test.txt'
// outFile  '/data/data/com/kredix/files/test.txt'
Function  Asset_SaveToFileP(srcFile, outFile : string; SkipExists : Boolean = False) : Boolean;
 Var
  Stream : TMemoryStream;
 begin
  If SkipExists = True then
   If FileExists(outFile) then Exit;
  Stream := TMemoryStream.Create;
  If ZipExtract(gApp.Path.App,srcFile,Stream) then
   Stream.SaveToFile(outFile);
  Stream.free;
  Result := FileExists(outFile);
 end;


//------------------------------------------------------------------------------
//  App Lock
//------------------------------------------------------------------------------

Procedure App_Lock;
 begin
  gApp.Lock := True;
 end;

Procedure App_UnLock;
 begin
  gApp.Lock := False;
 end;

Function  App_IsLock: Boolean;
 begin
  Result := gApp.Lock;
 end;

//----------------------------------------------------------------------------
// Multi Touch
//----------------------------------------------------------------------------

//
function  csAvg(const A,B : TfXY) : TfXY;
begin
  Result.X := (A.X + B.X) / 2;
  Result.Y := (A.Y + B.Y) / 2;
end;

//
function  csLen(const A,B : TfXY) : Single;
begin
  Result := Sqrt( (A.X - B.X)*(A.X - B.X) +
                  (A.Y - B.Y)*(A.Y - B.Y) );
end;

//
function  csAngle(const A,B : TfXY) : Single;
var
  Pt    : TfXY;
  Len   : Single;
  Angle : Single;
begin
  Angle := 0;
  Pt.X  := B.X-A.X;
  Pt.Y  := B.Y-A.Y;
  // Prevent Div Zero
  If (Pt.X = 0) and (Pt.Y = 0) then
  begin
    Pt.X := 1;
    Pt.Y := 1;
  end;
  Len := Sqrt( (Pt.X*Pt.X) + (Pt.Y*Pt.Y) );
  //
  Case (Pt.X > 0) of
   True : Case (Pt.Y > 0) of
           False: Angle :=      ArcSin( Pt.Y *-1/ Len ) * (180/pi);
           True : Angle := 360- ArcSin( Pt.Y    / Len ) * (180/pi);
          End;
   False: Case (Pt.Y > 0) of
           False: Angle := (90 -ArcSin( Pt.Y*-1 / Len ) * (180/pi))+90;
           True : Angle :=      ArcSin( Pt.Y    / Len ) * (180/pi)+180;
          End;
end;
  //
  Angle := 360-Angle;
  While Angle >= 360 do Angle := Angle - 360;
  While Angle <    0 do Angle := Angle + 360;

  Result := Angle;
 end;

// Input  Touches
// Output MTouch
Procedure MultiTouch_Calc(Var Mouches : TMouches );
 begin
  //
  If Mouches.Cnt > 1 then
   begin
    If Not(Mouches.Mouch.Active) then
     begin
      Mouches.sPt    := csAvg  ( Mouches.XYs[0], Mouches.XYs[1] );
      Mouches.sLen   := csLen  ( Mouches.XYs[0], Mouches.XYs[1] );
      Mouches.sAngle := csAngle( Mouches.XYs[0], Mouches.XYs[1] );
      Mouches.Mouch.Active := True;
     end;
    Inc(Mouches.sCount);
    Mouches.Mouch.Start  := (Mouches.sCount = 1);
    //If Touches.MTouch.Start then dbg('Start###################################');
    Mouches.Mouch.Pt    :=  csAvg  ( Mouches.XYs[0],Mouches.XYs[1] );
    Mouches.Mouch.Zoom  :=  csLen  ( Mouches.XYs[0],Mouches.XYs[1] ) / Mouches.sLen;
    Mouches.Mouch.Angle :=  csAngle( Mouches.XYs[0],Mouches.XYs[1] ) - Mouches.sAngle;
   end
  else
   begin
    Mouches.Mouch.Pt    :=  Mouches.XYs[0];
   end;
 end;

Procedure MultiTouch_End(Var Mouches : TMouches);
 begin
  //If Touches.Cnt = 2 then
  Mouches.Mouch.Active := False;
  Mouches.sCount       := 0;
 end;

//------------------------------------------------------------------------------
// Touch Event
//------------------------------------------------------------------------------

Procedure VHandler_touchesBegan_withEvent(Sender        : TObject;
                                          TouchCnt      : Integer;
                                          Touch1        : TfXY;
                                          Touch2        : TfXY;
                                          Var TouchDown : TOnTouchEvent;
                                          Var Mouches   : TMouches);

 begin
  //
  If not Assigned(TouchDown) then Exit;
  //
  Mouches.Cnt    := Min(TouchCnt,cjMouchMax);
  Mouches.XYs[0] := Touch1;
  Mouches.XYs[1] := Touch2;

  MultiTouch_Calc(Mouches);
  TouchDown(Sender, Mouches.Mouch);
 end;

//
Procedure VHandler_touchesMoved_withEvent(Sender        : TObject;
                                          TouchCnt      : Integer;
                                          Touch1        : TfXY;
                                          Touch2        : TfXY;
                                          Var TouchMove : TOnTouchEvent;
                                          Var Mouches   : TMouches);
begin
  //
 If not(Assigned(TouchMove)) then Exit;
  //
  Mouches.Cnt    := Min(TouchCnt,cjMouchMax);
  Mouches.XYs[0] := Touch1;
  Mouches.XYs[1] := Touch2;
  MultiTouch_Calc(Mouches);
  TouchMove(Sender,Mouches.Mouch);
end;

//
Procedure VHandler_touchesEnded_withEvent(Sender         : TObject;
                                          TouchCnt       : Integer;
                                          Touch1         : TfXY;
                                          Touch2         : TfXY;
                                          Var TouchUp    : TOnTouchEvent;
                                          Var Mouches    : TMouches);
 begin
  //
  If not(Assigned(TouchUp)) then Exit;
  //
  Mouches.Cnt    := Min(TouchCnt,cjMouchMax);
  Mouches.XYs[0] := Touch1;
  Mouches.XYs[1] := Touch2;

  MultiTouch_End(Mouches);
  TouchUp(Sender,Mouches.Mouch);
 end;

//------------------------------------------------------------------------------
//  Activity Event
//------------------------------------------------------------------------------

Function Java_Event_pAppOnScreenStyle(env: PJNIEnv; this: jobject): integer;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  case gApp.Screen.Style of
    ssSensor    : Result := 0;
    ssPortrait  : Result := 1;
    ssLandScape : Result := 2;
  end;
end;

Procedure Java_Event_pAppOnNewIntent(env: PJNIEnv; this: jObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

// The activity is about to be destroyed.
Procedure Java_Event_pAppOnDestroy(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

{
Paused
Another activity is in the foreground and has focus, but this one is still visible.
That is, another activity is visible on top of this one and that activity is partially transparent
or doesn't cover the entire screen. A paused activity is completely alive (the Activity object is retained in memory,
it maintains all state and member information, and remains attached to the window manager),
but can be killed by the system in extremely low memory situations.
}
// Another activity is taking focus (this activity is about to be "paused").
Procedure Java_Event_pAppOnPause(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;


Procedure Java_Event_pAppOnRestart(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

{
Resume: The activity is in the foreground of the screen and has user focus.
(This state is also sometimes referred to as "running".)
}
Procedure Java_Event_pAppOnResume(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

//The activity is about to become visible.....
Procedure Java_Event_pAppOnStart(env: PJNIEnv; this: jObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

{
Stopped
The activity is completely obscured by another activity (the activity is now in the "background").
A stopped activity is also still alive (the Activity object is retained in memory, it maintains
all state and member information, but is not attached to the window manager).
However, it is no longer visible to the user and it can be killed by the system when memory is needed elsewhere.
}
Procedure Java_Event_pAppOnStop(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

// Event : OnBackPressed -> Form OnClose
procedure Java_Event_pAppOnBackPressed(env: PJNIEnv; this: jobject);
var
  AForm : jForm;
  CanClose: boolean;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  AForm:= gApp.Forms.Stack[gApp.GetCurrentFormsIndex].Form;

  if not Assigned(AForm) then Exit;

  if AForm.FormState <> fsFormWork then Exit;

  if Assigned(AForm.OnBackButton) then AForm.OnBackButton(AForm);

  // Event : OnCloseQuery
  if Assigned(AForm.OnCloseQuery) then
  begin
    CanClose := True;
    AForm.OnCloseQuery(AForm, CanClose);
    if CanClose = False then Exit;
  end;

  AForm.Close;

end;

// Event : OnRotate -> Form OnRotate
Function Java_Event_pAppOnRotate(env: PJNIEnv; this: jobject; rotate : integer) : Integer;
var                   {rotate=1 --> device vertical/default position ; 2: device horizontal position}
  Form      : jForm;
  rstRotate : Integer;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  rstRotate:= rotate; //just initialize [var] param...

  Result := rotate;

  Form := gApp.Forms.Stack[gApp.GetCurrentFormsIndex].Form;

  if not Assigned(Form) then Exit;

  Form.UpdateJNI(gApp);

  Form.SetOrientation(rotate);

  if Assigned(Form.OnRotate) then Form.OnRotate(Form, rotate, {var}rstRotate);

  Result := rstRotate;

end;

Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

Procedure Java_Event_pAppOnActivityResult(env: PJNIEnv; this: jobject;
                                                requestCode, resultCode : Integer;
                                               jData : jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.GetCurrentFormsIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnActivityRst) then Form.OnActivityRst(Form,requestCode,resultCode,jData);
end;

//------------------------------------------------------------------------------
//  Control Event
//------------------------------------------------------------------------------

Procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject;
                             Obj: TObject; jCanvas: jObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Obj) then Exit;
  if Obj is jView  then
  begin
    jForm(jView(Obj).Owner).UpdateJNI(gApp);
    jView(Obj).GenEvent_OnDraw(Obj, jCanvas);
  end;
end;

Procedure Java_Event_pOnClick(env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  //------------------------------------------------------

  if not (Assigned(Obj)) then Exit;
  if Obj is jForm then
  begin
    jForm(Obj).UpdateJNI(gApp);
    jForm(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jButton then
  begin
    jForm(jButton(Obj).Owner).UpdateJNI(gApp);
    jButton(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jCheckBox then
  begin
    jForm(jCheckBox(Obj).Owner).UpdateJNI(gApp);
    jCheckBox(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jRadioButton then
  begin
    jForm(jRadioButton(Obj).Owner).UpdateJNI(gApp);
    jRadioButton(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jDialogYN then
  begin
    jDialogYN(Obj).GenEvent_OnClick(Obj,Value); exit;
  end;
  if Obj is jImageBtn then
  begin
    jForm(jImageBtn(Obj).Owner).UpdateJNI(gApp);
    jImageBtn(Obj).GenEvent_OnClick(Obj);       exit;
  end;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnClick(Obj,Value); exit;
  end;
  if Obj is jImageView then
  begin
    jForm(jImageView(Obj).Owner).UpdateJNI(gApp);
    jImageView(Obj).GenEvent_OnClick(Obj);       exit;
  end;
end;

Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnClickWidgetItem(Obj, index, checked); exit;
  end;
end;

Procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject;
                               Obj: TObject; EventType : integer);
begin                 {0:beforeTextChanged ; 1:onTextChanged ; 2: afterTextChanged}
 gApp.Jni.jEnv:= env;
 gApp.Jni.jThis:= this;

 if not Assigned(Obj) then Exit;
 if Obj is jEditText then
 begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnChange(Obj, EventType);
    exit;
 end;

end;

// LORDMAN
Procedure Java_Event_pOnEnter(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Obj) then Exit;
  if Obj is jEditText then
  begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnEnter(Obj);
    exit;
  end;

end;

Procedure Java_Event_pOnTimer(env: PJNIEnv; this: jobject; Obj: TObject);
Var
  Timer : jTimer;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if App_IsLock then Exit;

  if not (Assigned(Obj)) then Exit;
  if not (Obj is jTimer) then Exit;

  Timer := jTimer(Obj);

  if not (Timer.Enabled) then Exit;

  Timer.Parent.UpdateJNI(gApp);

  if Timer.Parent.FormState = fsFormClose then Exit;

  if Assigned(Timer.OnTimer) then Timer.OnTimer(Timer);

end;

procedure Java_Event_pOnTouch(env: PJNIEnv; this: jobject;
                              Obj: TObject;
                              act,cnt: integer; x1,y1,x2,y2 : single);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj)  then Exit;
  if Obj is jGLViewEvent  then
  begin
    jForm(jGLViewEvent(Obj).Owner).UpdateJNI(gApp);
    jGLViewEvent(Obj).GenEvent_OnTouch(Obj,act,cnt,x1,y1,x2,y2);
    Exit;
  end;
  if Obj is jView then
  begin
    jForm(jView(Obj).Owner).UpdateJNI(gApp);
    jView(Obj).GenEvent_OnTouch(Obj,act,cnt,x1,y1,x2,y2);
    Exit;
  end;
end;

procedure Java_Event_pOnGLRenderer(env: PJNIEnv; this: jobject;
                                   Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent  then
  begin
    jForm(jGLViewEvent(Obj).Owner).UpdateJNI(gApp);
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
    Exit;
  end;
end;

function Java_Event_pOnWebViewStatus(env: PJNIEnv; this: jobject;
                                      webview   : TObject;
                                      eventtype : integer;
                                      URL       : jString) : Integer;
var
  pasWebView : jWebView;
  pasURL     : String;
  pasCanNavi : Boolean;
  _jBoolean  : jBoolean;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  Result     := cjWebView_Act_Continue;
  pasWebView := jWebView(webview);
  if not Assigned(pasWebView) then Exit;
  if not Assigned(pasWebView.OnStatus) then Exit;
  //
  pasURL := '';
  if URL <> nil then
  begin
    _jBoolean := JNI_False;
    pasURL    := String( env^.GetStringUTFChars(Env,URL,@_jBoolean) );
  end;
  //
  pasCanNavi := True;
  pasWebView.OnStatus(pasWebView,IntToWebViewStatus(EventType),pasURL,pasCanNavi);
  if not(pasCanNavi) then Result := cjWebView_Act_Break;

end;


Procedure Java_Event_pOnAsyncEvent(env: PJNIEnv; this: jobject;
                                      Obj: TObject; EventType,Progress : integer);
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
    jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
    jAsyncTask(Obj).GenEvent_OnAsyncEvent(Obj,EventType,Progress);
    Exit;
  end;

end;

//------------------------------------------------------------------------------
// jApp
//------------------------------------------------------------------------------

constructor jApp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
  FAppName         := ''; //gjAppName;
  FClassName       := ''; //gjClassName;
  FillChar(Forms,SizeOf(Forms),#0);
  //
  Jni.jEnv         := nil;
  Jni.jThis        := nil;
  Jni.jActivity    := nil;
  Jni.jRLayout     := nil;
  //
  Path.App         := '';       // /data/app/com.kredix-1.apk
  Path.Dat         := '';       // /data/data/com.kredix/files
  Path.Ext         := '';       // /storage/emulated/0
  Path.DCIM        := '';       // /storage/emulated/0/DCIM
  Path.DataBase    := '';       // /data/data/com.kredix/databases  ::by jmpessoa
  //
  Screen.Style     := ssSensor; // Free
  Screen.WH.Width  := 0; //480;
  Screen.WH.Height := 0; //640;
  //
  Lock             := False;
  //
  FForm            := nil;
  StopOnException  :=True;

  Device.PhoneNumber := '';
  Device.ID          := '';

  FInitialized     := False;
  Forms.Index      := -1; //dummy
end;

Destructor jApp.Destroy;
begin
  inherited Destroy;
end;

Procedure jApp.Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject);
begin
  if FInitialized  then Exit;
  // Setting Global Environment -----------------------------------------------
  FillChar(Forms,SizeOf(Forms),#0);
  //
  Screen.Style  := ssSensor;     // Screen Style [Device,Portrait,Lanscape]
  // Jni
  Jni.jEnv      := env;  //a reference to the JNI environment
  Jni.jThis     := this; //a reference to the object making this call (or class if static).
  Jni.jActivity := activity;
  Jni.jRLayout  := layout;
  // Screen
  Screen.WH     := jSysInfo_ScreenWH(env, this, activity);
  Orientation   := jSystem_GetOrientation(env, this);
  // Device
  Path.App      := jSysInfo_PathApp(env, this, activity, PChar(FAppName){gjAppName});
  Path.Dat      := jSysInfo_PathDat(env, this, activity);
  Path.Ext      := jSysInfo_PathExt(env, this);
  Path.DCIM     := jSysInfo_PathDCIM(env, this);

  Path.DataBase := jSysInfo_PathDataBase(env, this, activity);  //by jmpessoa

  // Phone
  Device.PhoneNumber := jSysInfo_DevicePhoneNumber(env, this);
  Device.ID          := jSysInfo_DeviceID(env, this);
  FInitialized       := True;

end;

procedure jApp.CreateForm(InstanceClass: TComponentClass; out Reference);
var
  Instance: TComponent;
begin
  Instance := TComponent(InstanceClass.NewInstance);
  TComponent(Reference):= Instance;
  Instance.Create(Self);
end;

function jApp.GetCurrentFormsIndex: integer;
begin
   Result:= Forms.Index;
end;

Procedure jApp.IncFormsIndex;
begin
   Inc(Forms.Index);
end;

function jApp.GetNewFormsIndex: integer;
begin
  Inc(Forms.Index);
  Result:= Forms.Index;
end;

function jApp.GetPreviousFormsIndex: integer;
begin
  Dec(Forms.Index);
  Result:= Forms.Index;
end;

Procedure jApp.DecFormsIndex;
begin
   Dec(Forms.Index);
end;

Procedure jApp.SetAppName (Value : String);
begin
  FAppName:= Value;
end;

Procedure jApp.SetClassName(Value : String);
begin
  FClassName:= Value;
end;

Procedure jApp.Finish;
begin
  jApp_Finish2(Self.Jni.jEnv, Self.Jni.jThis);
end;

//------------------------------------------------------------------------------
// jForm
//------------------------------------------------------------------------------

constructor jForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Initialize
  FVisible              := False;
  FEnabled              := True;
  FColor                := colbrBlack;
  FFormName             := 'jForm';
  FormState             := fsFormCreate;
  FCloseCallBack.Event  := nil;
  FCloseCallBack.Sender := nil;
 // FMainActivity          := True;
  FActivityMode          := actMain;  //actMain, actRecyclable, actDisposable

  FOnActive             := nil;
  FOnCloseQuery         := nil;
  FOnClose              := nil;
  FOnRotate             := nil;
  FOnClick              := nil;
  FOnActivityRst        := nil;
  FOnJNIPrompt          := nil;

  FjObject              := nil;
  FjRLayout{View}       := nil;
  FApp                  := nil;

  FScreenWH.Height      := 100; //dummy
  FScreenWH.Width       := 100;

  FAnimation.In_        := cjEft_None; //cjEft_FadeIn;
  FAnimation.Out_       := cjEft_None; //cjEft_FadeOut;
  FOrientation          := 0;
  FInitialized          := False;
end;

destructor jForm.Destroy;
begin
  inherited Destroy;
end;

procedure jForm.Finish;
begin
  UpdateJNI(gApp);
  jForm_Free2(App.Jni.jEnv, App.Jni.jThis, FjObject);
  jForm_FreeLayout(App.Jni.jEnv, App.Jni.jThis, FjRLayout);
  jSystem_GC2(App.Jni.jEnv, App.Jni.jThis);
end;

procedure jForm.Init(refApp: jApp);
var
  i: integer;
  bkImgIndex: integer;
begin

  if FInitialized  then Exit;
  if refApp = nil then Exit;
  if not refApp.Initialized then Exit;

  FApp:= refApp;

  FScreenWH:= App.Screen.WH;
  FOrientation:= App.Orientation;

  FjObject:=  jForm_Create(App.Jni.jEnv, App.Jni.jThis, Self);

  FjRLayout:= jForm_Getlayout2(App.Jni.jEnv, App.Jni.jThis, FjObject);  {view}

  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout, GetARGB(FColor));

  bkImgIndex:= -1;

  FInitialized:= True;

  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       if (Self.Components[i] as jControl).ClassName = 'jImageView' then
       begin
          if (Self.Components[i] as jImageView).IsBackgroundImage = True then
          begin
             bkImgIndex:= i;
            (Self.Components[i] as jControl).Init; //init just background image
          end;
       end;
    end;
  end;

  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
      if i <> bkImgIndex then
      begin
         (Self.Components[i] as jControl).Init;
      end;
    end;
  end;

  jForm_SetEnabled2(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);

  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
end;

procedure jForm.UpdateJNI(refApp: jApp);
begin
  Self.App.Jni.jEnv:= refApp.Jni.jEnv;
  Self.App.Jni.jThis:= refApp.Jni.jThis;
end;

{
procedure jForm.SetOnJNIPrompt(Value: TOnNotify);
begin
  if FOnJNIPrompt = AValue then Exit;
  FOnJNIPrompt:= AValue;
end;
}

procedure jForm.ShowMessage(msg: string);
begin
  UpdateJNI(gApp);
  jForm_ShowMessage(Self.App.Jni.jEnv, Self.App.Jni.jThis,  FjObject, msg);
end;

function jForm.GetDateTime: String;
begin
  UpdateJNI(gApp);
  Result:= jForm_GetDateTime(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

procedure jForm.SetOrientation(Value: integer);
begin
  FOrientation:= Value;
end;

Procedure jForm.setEnabled(Value: Boolean);
begin
  FEnabled := Value;
  if FInitialized then
  begin
    UpdateJNI(gApp);
    jForm_SetEnabled2(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
  end;
end;

Procedure jForm.SetVisible(Value: Boolean);
begin
 FVisible := Value;
 if FInitialized then
 begin
   UpdateJNI(gApp);
   jForm_SetVisibility2(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
 end;
end;

Procedure jForm.SetColor(Value: TARGBColorBridge);
begin
 FColor:= Value;
 if (FInitialized = True) and (FColor <> colbrDefault)  then
 begin
   UpdateJNI(gApp);
   jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout,GetARGB(FColor));
 end;
end;

Procedure jForm.Show;
var
  newIndex: integer;
begin

  UpdateJNI(gApp);

  if not FInitialized then Exit;
  if FVisible then Exit;

  if gApp.GetCurrentFormsIndex = (cjFormsMax-1) then Exit;

  newIndex:= gApp.GetNewFormsIndex;
  gApp.Forms.Stack[newIndex].Form    := Self;
  gApp.Forms.Stack[newIndex].CloseCB := FCloseCallBack;

  FormState := fsFormWork;
  FVisible:= True;

  jForm_Show2(App.Jni.jEnv,App.Jni.jThis,FjObject, FAnimation.In_);
end;

Procedure jForm.UpdateLayout;
var
  i: integer;
begin
  UpdateJNI(gApp);
  for i := Self.ComponentCount - 1 downto 0 do
  begin
      if Self.Components[i] is jVisualControl then
      begin
        (Self.Components[i] as jVisualControl).UpdateLayout;
      end;
  end;
end;

//Ref. Destroy
procedure jForm.Close;
var
 CanClose: boolean;
 Inx: integer;
begin

 UpdateJNI(gApp);

 FormState := fsFormClose;
 FVisible:= False;

 //LORDMAN - 2013-08-01 / Call Back - 현재 Form 이전것을 한다.
 Inx := gApp.GetCurrentFormsIndex;

 if Assigned(gApp.Forms.Stack[Inx].CloseCB.Event) then
 begin
    gApp.Forms.Stack[Inx].CloseCB.Event(gApp.Forms.Stack[Inx].CloseCB.Sender);
    gApp.Forms.Stack[Inx].CloseCB.Event  := nil;
    gApp.Forms.Stack[Inx].CloseCB.Sender := nil;
 end;

 gApp.DecFormsIndex;

 jForm_Close2(App.Jni.jEnv, App.Jni.jThis, FjObject)

 // Post Closing Step
 // --------------------------------------------------------------------------
 // Java           Java          Java-> Pascal
 // jForm_Close -> RemoveView -> Java_Event_pOnClose

end;

//after form close......
Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject;  Form : TObject);
var
  i, Inx  : Integer;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Form) then exit; //just precaution...

  jForm(Form).UpdateJNI(gApp);

  if Assigned(jForm(Form).OnClose) then jForm(Form).OnClose(jForm(Form));

  if jForm(Form).ActivityMode = actMain then  //"The End"
  begin
    jForm(Form).Finish;
    gApp.Finish;
  end;

  if jForm(Form).ActivityMode = actDisposable then
  begin
    jForm(Form).Finish;
  end;

end;

Procedure Java_Event_pOnActive(env: PJNIEnv; this: jobject;  Form : TObject);
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  (Form as jForm).UpdateJNI(gApp);
  if Assigned((Form as jForm).OnActive) then (Form as jForm).OnActive(Form);
end;

Procedure jForm.Refresh;
begin
  if FInitialized then
  begin
    UpdateJNI(gApp);
    jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, Self.View);
  end;
end;

Procedure jForm.SetCloseCallBack(func : TOnNotify; Sender : TObject);
begin
  FCloseCallBack.Event  := func;
  FCloseCallBack.Sender := Sender;
end;

// Event : Java -> Pascal
Procedure jForm.GenEvent_OnClick(Obj: TObject);
begin
   if Assigned(FOnClick) then FOnClick(Obj);
end;

function jForm.GetView: jObject;
begin
  Result:= FjRLayout;
end;

//-------------------------------------------------
   {jControl by jmpessoa}
//--------------------------------------------------
Constructor jControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitialized:= False;
end;

//
Destructor jControl.Destroy;
begin
  inherited Destroy;
end;

procedure jControl.Init;
begin
  //
end;

//-------------------------------------------------
   {jVisualControl by jmpessoa}
//--------------------------------------------------
Constructor jVisualControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjPRLayout := nil;  //java parent
  FjObject   := nil; //java object
  FEnabled   := True;
  FVisible   := True;
  FColor     := colbrDefault;
  FFontColor := colbrDefault;
  FFontSize  := 0; //default size!
  FId        := 0; //0: no control anchor on this control!
  FAnchorId  := -1;  //dummy
  FAnchor    := nil;
  FLParamWidth := lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FMarginLeft   := 0;
  FMarginTop   := 0;
  FMarginBottom:= 0;
  FMarginRight:= 0;
  //FGravity:=[];      TODO!
  FPositionRelativeToAnchor:= [];
  FPositionRelativeToParent:= [];
  FParentPanel:= nil;
end;

//
Destructor jVisualControl.Destroy;
begin
  inherited Destroy;
end;

procedure jVisualControl.SetId(Value: DWord);
begin
  FId:= Value;
end;

procedure jVisualControl.Init;
begin
  inherited Init;
  FjPRLayout:= jForm(Owner).View;  //set parent!
  FOrientation:= jForm(Owner).Orientation;
end;

procedure jVisualControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    {checks whether the AComponent parameter is a jVisualControl or any type descending from jVisualControl}
    if (AComponent is jVisualControl) then
    begin
      if AComponent = FParentPanel then
      begin
        FParentPanel:= nil;
        FjPRLayout:= jForm(Owner).View;  //default...
        Exit;
      end;
      if AComponent = FAnchor then
      begin
         FAnchor:= nil;
         FAnchorId:= -1;  //dummy
      end;
    end
  end;
end;

procedure jVisualControl.SetAnchor(Value: jVisualControl);
begin
  if Value <> FAnchor then
  begin
    if Assigned(FAnchor) then
    begin
      FAnchor.RemoveFreeNotification(Self); //remove free notification...
    end;
    FAnchor:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(Self);
       if not (csDesigning in ComponentState) then Exit;
       if (csLoading in ComponentState) then Exit;
       if  Value.Id = 0 then
       begin
         Randomize;
         Value.Id:= Random(10000000);  //warning: remember the law of Murphi...
       end;
    end;
  end;
end;

procedure jVisualControl.SetParentPanel(Value: jPanel);
begin
  if Value <> FParentPanel then
  begin
    if Assigned(FParentPanel) then
    begin
       FParentPanel.RemoveFreeNotification(Self); //remove free notification...
    end;
    FParentPanel:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       FjPRLayout:= Value.View;
       Value.FreeNotification(self);
    end;
  end;
end;

procedure jVisualControl.UpdateLayout;
begin
  //dummy...
end;

function jVisualControl.GetWidth: integer;
begin
  Result:= 0;
end;

function jVisualControl.GetHeight: integer;
begin
  Result:= 0;
end;

//------------------------------------------------------------------------------
// jTextView
//------------------------------------------------------------------------------

constructor jTextView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextAlignment:= taLeft;
  FText:= utf8encode('jTextView');
  FFontColor:= colbrSilver;
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpWrapContent;
end;

//
Destructor jTextView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jTextView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jTextView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  //gvt: TGravity;     TODO
begin

  if FInitialized  then Exit;

  inherited Init;

  FjObject:= jTextView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
    FParentPanel.Init;
    FjPRLayout:= FParentPanel.View;
  end;

  jTextView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);

  jTextView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jTextView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  (* TODO
  for gvt := gvBottom  to gvFillVertical do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addGravity(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetGravity(gvt));
    end;
  end;
  *)

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jTextView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jTextView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  jTextView_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);

  if  FFontColor <> colbrDefault then
     jTextView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jTextView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

  jTextView_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Ord(FTextAlignment));

  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jTextView_setEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FEnabled);

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

Procedure jTextView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jTextView_setParent3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jTextView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jTextView.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  if FInitialized then
    jTextView_setEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FEnabled);
end;

Function jTextView.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jTextView_getText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jTextView.SetText(Value: string);
begin
  FText:= utf8encode(Value);
  if FInitialized then
    jTextView_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);
end;

Procedure jTextView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
    jTextView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jTextView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and  (FFontSize > 0) then
    jTextView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);
end;

procedure jTextView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if jForm(Owner).Orientation = jForm(Owner).App.Orientation then
      side:= sdW
   else
      side:= sdH;
   jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jTextView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jTextView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jTextView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

// LORDMAN 2013-08-12
Procedure jTextView.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
    jTextView_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Ord(FTextAlignment));
end;

Procedure jTextView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

// Event : Java -> Pascal
Procedure jTextView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

//------------------------------------------------------------------------------
// jEditText
//------------------------------------------------------------------------------

constructor jEditText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColor     := colbrWhite;
  FOnEnter   := nil;
  FOnChange  := nil;
  FInputTypeEx := itxText;
  FHint      := '';
  FText      := '';
  FLineMaxLength := 300;
  FSingleLine:= True;
  FMaxLines:= 1;

  FScrollBarStyle:= scrNone;
  FVerticalScrollBar:= False;
  FHorizontalScrollBar:= True;

  FWrappingLine:= False;

  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
end;

Destructor jEditText.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jEditText_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jEditText.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init;

  FjObject:= jEditText_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
    FParentPanel.Init;
    FjPRLayout:= FParentPanel.View;
  end;

  jEditText_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);

  jEditText_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);


  jEditText_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jEditText_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jEditText_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jEditText_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  if  FHint <> '' then
    jEditText_setHint(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FHint);

  if FFontColor <> colbrDefault then
    jEditText_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
    jEditText_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

  jEditText_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Ord(FTextAlignment));

  jEditText_maxLength(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FLineMaxLength);

  jEditText_setScroller2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);

  jEditText_setHorizontalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FHorizontalScrollBar);
  jEditText_setVerticalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVerticalScrollBar);

  if FInputTypeEx <> itxMultiLine then FInputTypeEx:= itxMultiLine; //hard code to by pass a BUG!

  jEditText_editInputType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, InputTypeToStrEx(FInputTypeEx));

  if FInputTypeEx = itxMultiLine then
  begin
    jEditText_setSingleLine(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, False);
    jEditText_setMaxLines(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FMaxLines);
    jEditText_setHorizontallyScrolling(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FWrappingLine);
    if (FVerticalScrollBar = True) or  (FHorizontalScrollBar = True) then
    begin
      jEditText_setScrollbarFadingEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, False);
      jEditText_setMovementMethod(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
      if FScrollBarStyle <> scrNone then
         jEditText_setScrollBarStyle(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetScrollBarStyle(FScrollBarStyle));
    end;
  end;

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  if  FText <> '' then
    jEditText_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);

  FInitialized:= True;
end;

Procedure jEditText.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jEditText_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jEditText.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jEditText.setColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jEditText.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jEditText.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jEditText_getText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jEditText.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
  begin
     jEditText_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);
  end;
end;

procedure jEditText.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jEditText_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jEditText.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jEditText_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);
end;

Procedure jEditText.SetHint(Value : String);
begin
  FHint:= Value;
  if FInitialized then
     jEditText_setHint2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FHint);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetFocus;
begin
  if FInitialized then
     jEditText_SetFocus2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

{
//InputMethodManager
mgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
mgr.hideSoftInputFromWindow(myView.getWindowToken(), 0);

}
// LORDMAN - 2013-07-26
Procedure jEditText.immShow;
begin
  if FInitialized then
     jEditText_immShow2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

// LORDMAN - 2013-07-26
Procedure jEditText.immHide;
begin
  if FInitialized then
      jEditText_immHide2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

//by jmpessoa
Procedure jEditText.SetInputTypeEx(Value : TInputTypeEx);
begin
  FInputTypeEx:= Value;
  if FInitialized then
     jEditText_editInputType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,InputTypeToStrEx(FInputTypeEx));
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetLineMaxLength(Value: DWord);
begin
  FLineMaxLength:= Value;
  if FInitialized then
     jEditText_maxLength(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

//by jmpessoa
Procedure jEditText.SetMaxLines(Value: DWord);
begin
  FMaxLines:= Value;
  if FInitialized then
     jEditText_setMaxLines(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetSingleLine(Value: boolean);
begin
  FSingleLine:= Value;
  if FInitialized then
     jEditText_setSingleLine(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetScrollBarStyle(Value: TScrollBarStyle);
begin
  FScrollBarStyle:= Value;
  if FInitialized then
  begin
    if Value <> scrNone then
    begin
       jEditText_setScrollBarStyle(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetScrollBarStyle(Value));
    end;
  end;
end;

procedure jEditText.SetHorizontalScrollBar(Value: boolean);
begin
  FHorizontalScrollBar:= Value;
  if FInitialized then
    jEditText_setHorizontalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetVerticalScrollBar(Value: boolean);
begin
  FVerticalScrollBar:= Value;
  if FInitialized then
    jEditText_setVerticalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetScrollBarFadingEnabled(Value: boolean);
begin
  if FInitialized then
    jEditText_setScrollbarFadingEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetMovementMethod;
begin
  if FInitialized then ;
    jEditText_setMovementMethod(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

// LORDMAN - 2013-07-26
Function jEditText.GetCursorPos: TXY;
begin
  Result.x := 0;
  Result.y := 0;
  if FInitialized then
     jEditText_GetCursorPos2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,Result.x,Result.y);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetCursorPos(Value: TXY);
begin
  if FInitialized then
     jEditText_SetCursorPos2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value.X,Value.Y);
end;

// LORDMAN 2013-08-12
Procedure jEditText.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
     jEditText_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Ord(FTextAlignment));
end;

// Event : Java -> Pascal
// LORDMAN - 2013-07-26
Procedure jEditText.GenEvent_OnEnter(Obj: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Obj);
end;

Procedure jEditText.GenEvent_OnChange(Obj: TObject; EventType : Integer);
begin
  if not FInitialized then Exit;
  if not(Assigned(FOnChange)) then Exit;
  if jForm(Owner).FormState = fsFormClose then Exit;
  case EventType of
   0 : FOnChange(Obj,ctChangeBefore);
   1 : FOnChange(Obj,ctChange      );
   2 : FOnChange(Obj,ctChangeAfter );
  end;
end;

procedure jEditText.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jEditText.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jEditText.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jEditText_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//------------------------------------------------------------------------------
// jButton
//------------------------------------------------------------------------------
constructor jButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= utf8encode('jButton');
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
end;

Destructor jButton.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if jForm(Owner).App <> nil then
     begin
       if jForm(Owner).App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jButton_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init;

  FjObject:= jButton_Create2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);

  jButton_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jButton_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
       jButton_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jButton_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jButton_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  jButton_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jButton_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then //not default...
     jButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

Procedure jButton.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jButton_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jButton.Refresh;
begin
  if not FInitialized then Exit;
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Function jButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jButton_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
    jButton_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);
end;

Procedure jButton.SetFontColor(Value : TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jButton_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jButton.SetFontSize (Value : DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);
end;

procedure jButton.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jButton.setParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jButton.UpdateLayout;
begin
  inherited UpdateLayout;
  SetParamWidth(FLParamWidth);
  SetParamHeight(FLParamHeight);
  jButton_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

// Event : Java -> Pascal
Procedure jButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

//------------------------------------------------------------------------------
// jCheckBox
//------------------------------------------------------------------------------

constructor jCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText      := utf8encode('jCheckBox');
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FFontColor    := colbrSilver;
end;

destructor jCheckBox.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jCheckBox_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jCheckBox.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init;

  FjObject := jCheckBox_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jCheckBox_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jCheckBox_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jCheckBox_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCheckBox_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jCheckBox_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= 0;

  jCheckBox_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jCheckBox_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jCheckBox_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jCheckBox_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

Procedure jCheckBox.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jCheckBox_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jCheckBox.SetVisible(Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jCheckBox.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jCheckBox.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Function jCheckBox.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jCheckBox_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jCheckBox.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jCheckBox_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);
end;

Procedure jCheckBox.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jCheckBox_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jCheckBox.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jCheckBox_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);
end;

Function jCheckBox.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
     Result:= jCheckBox_isChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jCheckBox.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jCheckBox_setChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FChecked);
end;

procedure jCheckBox.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jCheckBox.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jCheckBox.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jCheckBox_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

// Event Java -> Pascal
Procedure jCheckBox.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

//------------------------------------------------------------------------------
// jRadioButton
//------------------------------------------------------------------------------

constructor jRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText      := utf8encode('jRadioButton');
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FFontColor    := colbrSilver;
end;

destructor jRadioButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jRadioButton_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jRadioButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jRadioButton_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jRadioButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jRadioButton_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jRadioButton_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jRadioButton_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jRadioButton_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jRadioButton_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jRadioButton_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jRadioButton_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jRadioButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

  jRadioButton_setChecked(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FChecked);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

Procedure jRadioButton.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jRadioButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jRadioButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jRadioButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jRadioButton.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Function jRadioButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jRadioButton_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jRadioButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jRadioButton_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FText);
end;

Procedure jRadioButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jRadioButton_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jRadioButton.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jRadioButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);
end;

Function jRadioButton.GetChecked: boolean;
begin
  Result:= FChecked;
  if FInitialized then
     Result:= jRadioButton_isChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jRadioButton.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jRadioButton_setChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FChecked);
end;

procedure jRadioButton.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jRadioButton.setParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jRadioButton.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jRadioButton_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

// Event Java -> Pascal
Procedure jRadioButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

//------------------------------------------------------------------------------
// jProgressBar
//------------------------------------------------------------------------------

constructor jProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProgress  := 0;
  FMax       := 100;  //default...
  FStyle     := cjProgressBarStyleHorizontal;
  FVisible   := False;
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
end;

Destructor jProgressBar.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if jForm(Owner).App <> nil then
     begin
       if jForm(Owner).App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jProgressBar_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jProgressBar.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jProgressBar_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, GetProgressBarStyle(FStyle));

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jProgressBar_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jProgressBar_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jProgressBar_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jProgressBar_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jProgressBar_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jProgressBar_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jProgressBar_setProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FProgress);
  jProgressBar_setMax(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FMax);  //by jmpessoa

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jProgressBar.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jProgressBar_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

procedure jProgressBar.Stop;
begin
  SetProgress(0);
  SetVisible(False);
end;

procedure jProgressBar.Start;
begin
   SetProgress(FProgress);
   SetVisible(True);
end;

Procedure jProgressBar.SetStyle(Value : TProgressBarStyle);
begin
  if csDesigning in ComponentState then FStyle:= Value;
end;

Procedure jProgressBar.SetVisible(Value: Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jProgressBar.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jProgressBar.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Function jProgressBar.GetProgress: integer;
begin
  Result:= FProgress;
  if FInitialized then
     Result:= jProgressBar_getProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jProgressBar.SetProgress(Value: integer);
begin
  if Value >= 0 then FProgress:= Value
  else FProgress:= 0;
  if FInitialized then
     jProgressBar_setProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FProgress);
end;

//by jmpessoa
Procedure jProgressBar.SetMax(Value: integer);
begin
  if Value > FProgress  then FMax:= Value;
  if FInitialized then
     jProgressBar_setMax2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FMax);
end;

//by jmpessoa
Function jProgressBar.GetMax: integer;
begin
  Result:= FMax;
  if FInitialized then
     Result:= jProgressBar_getMax2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jProgressBar.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jProgressBar.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jProgressBar.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jProgressBar_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//------------------------------------------------------------------------------
// jImageView
//------------------------------------------------------------------------------

constructor jImageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FImageName:= '';
  FImageIndex:= -1;
  FLParamWidth:= lpWrapContent;
  FIsBackgroundImage:= False;
  FFilePath:= fpathData;
end;

destructor jImageView.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if jForm(Owner).App <> nil then
     begin
       if jForm(Owner).App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jImageView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jImageView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jImageView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jImageView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FjPRLayout);
  jImageView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jImageView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  if FColor <> colbrDefault then
      jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  FInitialized:= True;  //neded here....
  if FImageList <> nil then
  begin
    FImageList.Init;
    if FImageList.Images.Count > 0 then
    begin
       if FImageIndex >=0 then SetImageByIndex(FImageIndex);
    end;
  end;

  jImageView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

procedure jImageView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jImageView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FjPRLayout);
end;

Procedure jImageView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jImageView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jImageView.SetImageByName(Value: string);
var
  i: integer;
  foundIndex: integer;
begin
   If not Self.Initialized then Exit;
   if Value = '' then Exit;
   foundIndex:= -1;
   for i:=0 to FImageList.Images.Count-1 do
   begin    //simply compares ASCII values...
     if CompareText(Trim(FImageList.Images.Strings[i]), Trim(Value)) = 0 then foundIndex:= i;
   end;
   if foundIndex > -1 then
   begin
      FImageIndex:= foundIndex;
      FImageName:= Trim(FImageList.Images.Strings[foundIndex]);
      jImageView_setImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
   end;
end;

Procedure jImageView.SetImageByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageName:= Trim(FImageList.Images.Strings[Value]);
      if  (FImageName <> '') and (FImageName <> 'null') then
      begin
        jImageView_setImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
      end;
   end;
end;

function jImageView.GetCount: integer;
begin
  Result:= FImageList.Images.Count;
end;

Function jImageView.GetImageName: string;
begin
  Result:= FImageName;
end;

Procedure jImageView.SetImageName(Value: string);
begin
  FImageName:= Value;
  if FInitialized then SetImageByName(Value);  ;
end;

procedure jImageView.SetImageIndex(Value: integer);
begin
  FImageIndex:= Value;
  if FInitialized then
  begin
    if Value > FImageList.Images.Count then FImageIndex:= FImageList.Images.Count;
    if Value < 0 then FImageIndex:= 0;
    SetImageByIndex(Value);
  end;
end;

function jImageView.GetImageIndex: integer;
begin
  Result:= FImageIndex;
end;

procedure jImageView.SetImageBitmap(bitmap: jObject);
begin
  if FInitialized then
     jImageView_setBitmapImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, bitmap);
end;

procedure jImageView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jImageView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

function jImageView.GetWidth: integer;
begin
  Result:= 0;
  if FInitialized then
   Result:= jImageView_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject)
end;

function jImageView.GetHeight: integer;
begin
  Result:= 0;
  if FInitialized then
    Result:= jImageView_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jImageView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jImageView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

// Event : Java -> Pascal
Procedure jImageView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jImageView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FImageList then
      begin
        FImageList:= nil;
      end
  end;
end;

procedure jImageView.SetImages(Value: jImageList);
begin
  if Value <> FImageList then
  begin
    if Assigned(FImageList) then
    begin
       FImageList.RemoveFreeNotification(Self); //remove free notification...
    end;
    FImageList:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

//  new by jmpessoa
{jImageList}

constructor jImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FFilePath:= fpathData;
  FImages := TStringList.Create;
  TStringList(FImages).OnChange:= ListImagesChange;
end;

destructor jImageList.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        //
      end;
    end;
  end;
  FImages.Free;
  inherited Destroy;
end;

procedure jImageList.Init;
var
  i: integer;
begin
  if FInitialized  then Exit;
  inherited Init;
  for i:= 0 to FImages.Count - 1 do
  begin
     if Trim(FImages.Strings[i]) <> '' then
        Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
  end;
  FInitialized:= True;
end;

procedure jImageList.SetImages(Value: TStrings);
begin
  FImages.Assign(Value);
end;

function jImageList.GetCount: integer;
begin
  Result:= FImages.Count;
end;

function jImageList.GetImageByIndex(index: integer): string;
begin
  if index < FImages.Count then
     Result:= Trim(FImages.Strings[index]);
end;

function jImageList.GetImageExByIndex(index: integer): string;
begin
  if Initialized then
  begin
     if (index < FImages.Count) and (index >= 0) then
        Result:= GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[index]);
  end;
end;

procedure jImageList.ListImagesChange(Sender: TObject);
begin
   //TODO
end;

{jHttpClient}
constructor jHttpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FUrls:= TStringList.Create;
  FUrl:= '';
  FIndexUrl:= -1;
end;

destructor jHttpClient.Destroy;
begin
 if not (csDesigning in ComponentState) then
 begin
 if jForm(Owner).App <> nil then
 begin
  if jForm(Owner).App.Initialized then
  begin
    //
  end;
 end;
 end;
 FUrls.Free;
 inherited Destroy;
end;

procedure jHttpClient.Init;
begin
 if FInitialized  then Exit;
 inherited Init;
 SetUrlByIndex(FIndexUrl);
 FInitialized:= True;
end;

procedure jHttpClient.SetUrls(Value: TStrings);
begin
  FUrls.Assign(Value);
end;

function jHttpClient.Get: string;
begin
 if FInitialized then
   Result:= jHttp_get(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FUrl);
end;

function jHttpClient.Get(location: string): string;
begin
  FUrl:= location;
  if FInitialized then
     Result:= jHttp_get(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, location);
end;

Procedure jHttpClient.SetUrlByIndex(Value: integer);
begin
   FUrl:='';
   if (Value >= 0) and (Value < FUrls.Count) then
      FUrl:= Trim(FUrls.Strings[Value]);
end;

procedure jHttpClient.SetIndexUrl(Value: integer);
begin
  FIndexUrl:= Value;
  if FInitialized then SetUrlByIndex(Value);
end;

{jSMTPClient by jmpessoa: warning: not tested!}

constructor jSMTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FMails:= TStringList.Create;
  FMailMessage:= TStringList.Create;
  FMailTo:='';
  FMailCc:='';
  FMailBcc:='';
  FMailSubject:='';
end;

destructor jSMTPClient.Destroy;
begin
 if not (csDesigning in ComponentState) then
 begin
 if jForm(Owner).App <> nil then
 begin
  if jForm(Owner).App.Initialized then
  begin
    //
  end;
 end;
 end;
 FMails.Free;
 FMailMessage.Free;
 inherited Destroy;
end;

procedure jSMTPClient.Init;
begin
 if FInitialized  then Exit;
 inherited Init;
(*  TODO
 for i:= 0 to FMails.Count - 1 do
 begin
  if Trim(FMails.Strings[i]) <> '' then
    Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
 end;  *)
 FInitialized:= True;
end;

procedure jSMTPClient.SetMails(Value: TStrings);
begin
  FMails.Assign(Value);
end;

procedure jSMTPClient.SetMailMessage(Value: TStrings);
begin
  FMailMessage.Assign(Value);
end;

procedure jSMTPClient.Send;
begin
 if FInitialized then
    jSend_Email(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                FMailTo,              //to
                FMailCc,              //cc
                FMailBcc,             //bcc
                FMailSubject,         //subject
                FMailMessage.Text);   //message
end;

procedure jSMTPClient.Send(mTo: string; subject: string; msg: string);
begin
  if FInitialized then
     jSend_Email(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                 mTo,     //to
                 '',      //cc
                 '',      //bcc
                 subject, //subject
                 msg);    //message
end;

//
{jSMS by jmpessoa: warning: not tested!}

constructor jSMS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FContactListDelimiter:= ';';
  FMobileNumber:='';
  FContactName:='';
  FLoadMobileContacts:= False;

  FSMSMessage:= TStringList.Create;

  FContactList:= TStringList.Create;
  FContactList.Delimiter:= FContactListDelimiter;
end;

destructor jSMS.Destroy;
begin
 if not (csDesigning in ComponentState) then
 begin
 if jForm(Owner).App <> nil then
 begin
  if jForm(Owner).App.Initialized then
  begin
    //
  end;
 end;
 end;
 FSMSMessage.Free;
 FContactList.Free;
 inherited Destroy;
end;

procedure jSMS.Init;
begin
 if FInitialized  then Exit;
 inherited Init;
 if FLoadMobileContacts then GetContactList;
 FInitialized:= True;
end;

function jSMS.GetContactList: string;
begin
 if FInitialized then
   FContactList.DelimitedText:= jContact_getDisplayNameList(jForm(Owner).App.Jni.jEnv,
                                                                      jForm(Owner).App.Jni.jThis,
                                                                      FContactListDelimiter);
  Result:=FContactList.DelimitedText;
end;

procedure jSMS.SetSMSMessage(Value: TStrings);
begin
  FSMSMessage.Assign(Value);
end;

procedure jSMS.Send;
begin
  if FInitialized then
  begin
    if (FMobileNumber = '') and (FContactName <> '') then
      FMobileNumber:= jContact_getMobileNumberByDisplayName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                                                         FContactName);
    if FMobileNumber <> '' then
        jSend_SMS(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                  FMobileNumber,     //to
                  FSMSMessage.Text);  //message
  end;
end;

procedure jSMS.Send(toName: string);
begin
  if FInitialized then
  begin
    if toName<> '' then
      FMobileNumber:= jContact_getMobileNumberByDisplayName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                                                            toName);
    if FMobileNumber <> '' then
        jSend_SMS(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                  FMobileNumber,     //to
                  FSMSMessage.Text);  //message
  end;
end;

procedure jSMS.Send(toNumber: string;  msg: string);
begin
 if FInitialized then
 begin
    if toNumber <> '' then
        jSend_SMS(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                  toNumber,     //to
                  msg);  //message
  end;
end;

  {jCamera warning by jmpessoa: not tested!}
constructor jCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FFilePath:= fpathDCIM;
  FFilename:= 'photo1.jpg';
end;

destructor jCamera.Destroy;
begin
 if not (csDesigning in ComponentState) then
 begin
 if jForm(Owner).App <> nil then
 begin
  if jForm(Owner).App.Initialized then
  begin
    //
  end;
 end;
 end;
 inherited Destroy;
end;

procedure jCamera.Init;
begin
 if FInitialized  then Exit;
 inherited Init;
 FInitialized:= True;
end;

procedure jCamera.TakePhoto;
var
  strExt: string;
begin
  if FInitialized then
  begin
     if Pos('.', FFileName) < 0 then
          FFileName:= FFileName + '.jpg'
     else if Pos('.jpg', FFileName)  < 0 then
     begin
       //force jpg extension....
       strExt:= FFileName;
       FFileName:= SplitStr(strExt, '.');
       FFileName:= FFileName + '.jpg';
     end;
     Self.FullPathToBitmapFile:= jCamera_takePhoto(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,
                                                   GetFilePath(FFilePath), FFileName);
  end;
end;

//------------------------------------------------------------------------------
// jListlView
//------------------------------------------------------------------------------
//TWidgetItem = (hasNone,hasCheckBox,hasRadioButton,hasButton,hasTextView,hastEditText,hasImageView);

constructor jListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFontSize:= 0;
  FFontColor:= colbrRed;
  FWidgetItem:= wgNone;

  FDelimiter:= '|';

  FTextDecorated:= txtNormal;
  FItemLayout:= layImageTextWidget;
  FTextSizeDecorated:= sdNone;
  FTextAlign:= alLeft;

  FItems:= TStringList.Create;
  TStringList(FItems).OnChange:= ListViewChange;  //event handle
end;

destructor jListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jListView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  FItems.Free;
  inherited Destroy;
end;

procedure jListView.Init;
var
  i: integer;
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;

  //if Self.Items.Count = 0 then Self.Items.Add('------Select------');  Items//FWidgetItem:= wgNone;

  if FImageItem <> nil then
  begin
     FImageItem.Init;
     FjObject:= jListView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
                               Ord(FWidgetItem), FWidgetText, FImageItem.GetJavaBitmap,
                               Ord(FTextDecorated),Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));
    if FFontColor <> colbrDefault then
       jListView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

    if FFontSize > 0 then
       jListView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

    if FColor <> colbrDefault then
       jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

     for i:= 0 to Self.Items.Count-1 do
     begin
       FImageItem.ImageIndex:= i;
       jListView_add22(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Items.Strings[i], FDelimiter, FImageItem.GetJavaBitmap);
     end;
  end
  else
  begin
     FjObject:= jListView_Create3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
                               Ord(FWidgetItem), FWidgetText,
                               Ord(FTextDecorated),Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));
     if FFontColor <> colbrDefault then
        jListView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor));

     if FFontSize > 0 then
        jListView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize);

     if FColor <> colbrDefault then
        jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

     for i:= 0 to Self.Items.Count-1 do
        jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Items.Strings[i], FDelimiter);
  end;

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jListView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jListView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jListView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jListView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jListView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jListView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

procedure jListView.SetWidget(Value: TWidgetItem);
begin
  FWidgetItem:= Value;
 // if FInitialized then
   //  jListView_setHasWidgetItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(FHasWidgetItem));
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(Value), index);
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(Value), txt, index);
end;

procedure jListView.SetWidgetTextByIndex(txt: string; index: integer);
begin
   if FInitialized then
      jListView_setWidgetText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject,txt,index);
end;

procedure jListView.SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextDecorated(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(Value), index);
end;

procedure jListView.SetTextSizeDecoratedByIndex(value: TTextSizeDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextSizeDecorated(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Ord(value), index);
end;

procedure jListView.SetLayoutByIndex(Value: TItemLayout; index: integer);
begin
  if FInitialized then
   jListView_setItemLayout(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(Value), index);
end;

procedure jListView.SetImageByIndex(Value: jObject; index: integer);
begin
  //FHasWidgetItem:= Value;
  if FInitialized then
     jListView_SetImageItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value, index);
end;

procedure jListView.SetTextAlignByIndex(Value: TTextAlign; index: integer);
begin
  if FInitialized then
    jListView_setTextAlign(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, ord(Value), index);
end;


function jListView.IsItemChecked(index: integer): boolean;
begin
  if FInitialized then
    Result:= jListView_IsItemChecked(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, index);
end;

procedure jListView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jListView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jListView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jListView.SetColor (Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jListView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis, FjObject);
end;


Procedure jListView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  //if (FInitialized = True) and (FFontColor <> colbrDefault ) then
    // jListView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FFontColor), index);
end;

Procedure jListView.SetFontColorByIndex(Value: TARGBColorBridge; index: integer);
begin
  //FFontColor:= Value;
  if FInitialized  and (Value <> colbrDefault) then
     jListView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(Value), index);
end;

Procedure jListView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  //if FInitialized and (FFontSize > 0) then
   //  jListView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FFontSize, index);
end;

Procedure jListView.SetFontSizeByIndex(Value: DWord; index: integer);
begin
  //FFontSize:= Value;
  if FInitialized and (Value > 0) then
     jListView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value, index);
end;

// LORDMAN 2013-08-07
Procedure jListView.SetItemPosition(Value: TXY);
begin
  if FInitialized then
     jListView_setItemPosition2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value.X, Value.Y);
end;

//
Procedure jListView.Add(item: string; delim: string);
begin
  if FInitialized then
  begin
     if delim = '' then delim:= '+';
     if item = '' then delim:= 'dummy';
     jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, item,delim);
     Self.Items.Add(item);
  end;
end;

Procedure jListView.Add(item: string);
begin
  if FInitialized then
  begin
     if item = '' then item:= 'dummy';
     jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, item,'+');
     Self.Items.Add(item);
  end;
end;

Procedure jListView.Add(item: string; delim: string; fColor: TARGBColorBridge; fSize: integer; hasWidget:
                                      TWidgetItem; widgetText: string; image: jObject);
begin
  if FInitialized then
  begin
     if delim = '' then delim:= '+';
     if item = '' then delim:= 'dummy';
     jListView_add3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, item,
     delim, GetARGB(fColor), fSize, Ord(hasWidget), widgetText, image);
     Self.Items.Add(item);
  end;
end;

function jListView.GetText(index: Integer): string;
begin
  if FInitialized then
    Result:= jListView_GetItemText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, index);
end;

function jListView.GetCount: integer;
begin
  Result:= Self.Items.Count;
  if FInitialized then
    Result:= jListView_GetCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

//
Procedure jListView.Delete(index: Integer);
begin
  if FInitialized then
  begin
     if (index >= 0) and (index < Self.Items.Count) then    //bug fix 27-april-2014
     begin
       jListView_delete2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, index);
       Self.Items.Delete(index);
     end;
  end;
end;

//
Procedure jListView.Clear;
begin
  if FInitialized then
  begin
    jListView_clear2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
    Self.Items.Clear;
  end;
end;

//by jmpessoa
procedure jListView.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

//by jmpessoa
procedure jListView.ListViewChange(Sender: TObject);
//var
  //i: integer;
begin
{  if FInitialized then
  begin
    jListView_clear2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
    for i:= 0 to FItems.Count - 1 do
    begin
       jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FItems.Strings[i],
                                    FDelimiter, GetARGB(FFontColor), FFontSize, FWidgetText, Ord(FWidgetItem));
    end;
  end; }
end;

procedure jListView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jListView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jListView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jListView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

procedure jListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FImageItem then
      begin
        FImageItem:= nil;
      end
  end;
end;

procedure jListView.SetImage(Value: jBitmap);
begin
  if Value <> FImageItem then
  begin
    if Assigned(FImageItem) then
    begin
       FImageItem.RemoveFreeNotification(Self); //remove free notification...
    end;
    FImageItem:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

// Event : Java -> Pascal
Procedure jListView.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Obj,Value);
end;

//by jmpessoa
procedure jListView.GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
begin
  if Assigned(FOnClickWidgetItem) then FOnClickWidgetItem(Obj,index,checked);
end;

//------------------------------------------------------------------------------
// jScrollView
//------------------------------------------------------------------------------

constructor jScrollView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScrollSize := 800; //to scrolling images this number could be higher....
end;

Destructor jScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jScrollView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jScrollView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;

  FjObject:= jScrollView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FjRLayout:= jScrollView_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject); // Java : Self Layout

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jScrollView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jScrollView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jScrollView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jScrollView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jScrollView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  jScrollView_setScrollSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FScrollSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jScrollView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jScrollView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jScrollView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jScrollView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize:= Value;
  if FInitialized then
     jScrollView_setScrollSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FScrollSize);
end;

procedure jScrollView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jScrollView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jScrollView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jScrollView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

{NEW jPanel by jmpessoa}

constructor jPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpMatchParent;
end;

Destructor jPanel.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jPanel_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jPanel.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;

  FjObject:= jPanel_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  FjRLayout{View}:= jPanel_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject); // Java : Self Layout

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jPanel_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jPanel_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);

  jPanel_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jPanel_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jPanel_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jPanel_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

procedure jPanel.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jPanel_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jPanel.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jPanel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));
end;

Procedure jPanel.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jPanel.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jPanel.setParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

function jPanel.GetWidth: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jPanel_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject)
end;

function jPanel.GetHeight: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jPanel_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jPanel.ResetRules;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
   jPanel_resetLParamsRules2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jPanel_addlParamsParentRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jPanel_addlParamsAnchorRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
   end;
end;

procedure jPanel.UpdateLayout;
begin
  inherited UpdateLayout;
  ResetRules;    //TODO optimize here: if "only rules_changed" then --> ResetRules
  SetParamWidth(FLParamWidth);
  setParamHeight(FLParamHeight);
  jPanel_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//--------

//------------------------------------------------------------------------------
// jHorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------

Constructor jHorizontalScrollView.Create(AOwner: TComponent);
 begin
  inherited Create(AOwner);
  FScrollSize := 800;
 end;

Destructor jHorizontalScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jHorizontalScrollView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jHorizontalScrollView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;                   //fix create
  FjObject := jHorizontalScrollView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FjRLayout:= jHorizontalScrollView_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject); //self layout!

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jHorizontalScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jHorizontalScrollView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jHorizontalScrollView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jHorizontalScrollView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jHorizontalScrollView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jHorizontalScrollView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jHorizontalScrollView_setScrollSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FScrollSize);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jHorizontalScrollView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jHorizontalScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jHorizontalScrollView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jHorizontalScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jHorizontalScrollView.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jHorizontalScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FInitialized then
     jHorizontalScrollView_setScrollSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FScrollSize);
end;

procedure jHorizontalScrollView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jHorizontalScrollView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jHorizontalScrollView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jHorizontalScrollView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//------------------------------------------------------------------------------
// jViewFlipper
//------------------------------------------------------------------------------

Constructor jViewFlipper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

Destructor jViewFlipper.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jViewFlipper_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jViewFlipper.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject := jViewFlipper_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jViewFlipper_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jViewFlipper_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jViewFlipper_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jViewFlipper_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jViewFlipper_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jViewFlipper_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jViewFlipper.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jViewFlipper_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jViewFlipper.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jViewFlipper.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jViewFlipper.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jViewFlipper.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jViewFlipper.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jViewFlipper.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jViewFlipper_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//------------------------------------------------------------------------------
// jWebView
//------------------------------------------------------------------------------

constructor jWebView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJavaScript := False;
  FOnStatus   := nil;
end;

destructor jWebView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jWebView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jWebView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jWebView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jWebView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jWebView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jWebView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jWebView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jWebView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jWebView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  jWebView_SetJavaScript(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FJavaScript);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jWebView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jWebView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jWebView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jWebView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jWebView.Refresh;
 begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
 end;

Procedure jWebView.SetJavaScript(Value : Boolean);
begin
  FJavaScript:= Value;
  if FInitialized then
     jWebView_SetJavaScript2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FJavaScript);
end;

Procedure jWebView.Navigate(url: string);
begin
  if not FInitialized then Exit;
  jWebView_loadURL2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, url);
end;

procedure jWebView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jWebView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jWebView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jWebView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

//------------------------------------------------------------------------------
// jBitmap
//------------------------------------------------------------------------------

constructor jBitmap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FWidth    := 0;
  FHeight   := 0;
  FImageName:='';
  FImageIndex:= -1;
    { TFilePath = (pathjForm(Owner).App, pathData, pathExt, pathDCIM); }
  FFilePath:= fpathData;
  //
  FjObject  := nil;
end;

Destructor jBitmap.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jBitmap_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jBitmap.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject := jBitmap_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FInitialized:= True;  //neded here....
  if FImageList <> nil then
  begin
    FImageList.Init;
    if FImageList.Images.Count > 0 then
    begin
       if FImageIndex >=0 then SetImageByIndex(FImageIndex);
    end;
  end;
end;

function jBitmap.TryPath(path: string; fileName: string): boolean;
begin
  Result:= False;
  if Pos(path, fileName) > 0 then Result:= True;
end;

procedure jBitmap.LoadFromFile(fileName : string);
var
  path: string;
begin
  if FInitialized then
  begin
     if fileName <> '' then
     begin
       path:='';

       if TryPath(jForm(Owner).App.Path.Dat,fileName) then begin path:= jForm(Owner).App.Path.Dat; FFilePath:= fpathApp end
       else if TryPath(jForm(Owner).App.Path.Dat,fileName) then begin path:= jForm(Owner).App.Path.Dat; FFilePath:= fpathData  end
       else if TryPath(jForm(Owner).App.Path.DCIM,fileName) then begin path:= jForm(Owner).App.Path.DCIM; FFilePath:= fpathDCIM end
       else if TryPath(jForm(Owner).App.Path.Ext,fileName) then begin path:= jForm(Owner).App.Path.Ext; FFilePath:= fpathExt end;

       if path <> '' then FImageName:= ExtractFileName(fileName)
       else  FImageName:= fileName;

       jBitmap_loadFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath)+'/'+FImageName);
       jBitmap_getWH(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,integer(FWidth),integer(FHeight));
     end;
  end;
end;

Procedure jBitmap.CreateJavaBitmap(w, h: Integer);
begin
  FWidth  := 0;
  FHeight := 0;
  if FInitialized then
  begin
    FWidth  := w;
    FHeight := h;
    jBitmap_createBitmap2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FWidth, FHeight);
  end;
end;

Function jBitmap.GetJavaBitmap: jObject;
begin
  if FInitialized then
  begin
     Result:= jBitmap_jInstance2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis, FjObject);
  end;
end;

function jBitmap.BitmapToByte(var bufferImage: TArrayOfByte): integer; //local/self
var
  PJavaPixel: PScanByte; {need by delphi mode!} //PJByte;
  k, row, col: integer;
  w, h: integer;
begin
  Result:= 0;
  if Self.GetInfo then
  begin
     //demo API LockPixels - overloaded - paramenter is "PJavaPixel"
    Self.LockPixels(PJavaPixel); //ok
    k:= 0;
    w:= Self.Width;
    h:= Self.Height;
    Result:=  h*w;
    SetLength(bufferImage,Result);
    for row:= 0 to h-1 do  //ok
    begin
      for col:= 0 to w-1 do //ok
      begin
          bufferImage[k*4]:=    PJavaPixel^[k*4]; //delphi mode....
          bufferImage[k*4+1]:=  PJavaPixel^[k*4+1];
          bufferImage[k*4+2]:=  PJavaPixel^[k*4+2];
          bufferImage[k*4+3]:=  PJavaPixel^[k*4+3];
          inc(k);
      end;
    end;
    Self.UnlockPixels;
  end;
end;

function jBitmap.GetByteArrayFromBitmap(var bufferImage: TArrayOfByte): integer;
begin
  if FInitialized then
   Result:= jBitmap_GetByteArrayFromBitmap(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,
                                    FjObject, bufferImage);
end;

procedure jBitmap.SetByteArrayToBitmap(var bufferImage: TArrayOfByte; size: integer);
begin
  if FInitialized then
    jBitmap_SetByteArrayToBitmap(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,
                                    FjObject, bufferImage, size);
end;

procedure jBitmap.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FImageList then
      begin
        FImageList:= nil;
      end
  end;
end;

procedure jBitmap.SetImages(Value: jImageList);
begin
  if Value <> FImageList then
  begin
    if Assigned(FImageList) then
    begin
       FImageList.RemoveFreeNotification(Self); //remove free notification...
    end;
    FImageList:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

Procedure jBitmap.SetImageByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageName:= Trim(FImageList.Images.Strings[Value]);
      if  (FImageName <> '') then
      begin
        jBitmap_loadFile2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
        jBitmap_getWH2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, integer(FWidth),integer(FHeight));
      end;
   end;
end;

procedure jBitmap.SetImageIndex(Value: integer);
begin
  FImageIndex:= Value;
  if FInitialized then
  begin
    if Value > FImageList.Images.Count then  FImageIndex:= FImageList.Images.Count;
    if Value < 0 then  FImageIndex:= 0;
    SetImageByIndex(FImageIndex);
  end;
end;

Procedure jBitmap.SetImageByName(Value: string);
var
   i: integer;
   foundIndex: integer;
begin
   if not Self.Initialized then Exit;
   if Value = '' then Exit;
   foundIndex:= -1;
   for i:=0 to FImageList.Images.Count-1 do
   begin    //simply compares ASCII values...
     if CompareText(Trim(FImageList.Images.Strings[i]), Trim(Value)) = 0 then foundIndex:= i;
   end;
   if foundIndex > -1 then
   begin
     FImageIndex:= foundIndex;
     FImageName:= Trim(FImageList.Images.Strings[foundIndex]);
     jBitmap_loadFile2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
     jBitmap_getWH2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,integer(FWidth),integer(FHeight));
   end;
end;

procedure jBitmap.SetImageName(Value: string);
begin
  FImageName:= Value;
  if FInitialized then SetImageByName(FImageName);
end;

procedure jBitmap.LockPixels(var PDWordPixel : PScanLine);
begin
  if FInitialized then
    AndroidBitmap_lockPixels(jForm(Owner).App.Jni.jEnv, Self.GetJavaBitmap, @PDWordPixel);
end;

procedure jBitmap.LockPixels(var PBytePixel : PScanByte {delphi mode});
begin
  if FInitialized then
    AndroidBitmap_lockPixels(jForm(Owner).App.Jni.jEnv, Self.GetJavaBitmap, @PBytePixel);
end;

procedure jBitmap.LockPixels(var PSJByte: PJByte {FPC mode });
begin
  if FInitialized then
    AndroidBitmap_lockPixels(jForm(Owner).App.Jni.jEnv, Self.GetJavaBitmap, @PSJByte);
end;

procedure jBitmap.UnlockPixels;
begin
  if FInitialized then
     AndroidBitmap_unlockPixels(jForm(Owner).App.Jni.jEnv, Self.GetJavaBitmap);
end;

function jBitmap.GetInfo: boolean;
var
  rtn: integer;
begin
  Result:= False;
  if FInitialized then
  begin
    rtn:= AndroidBitmap_getInfo(jForm(Owner).App.Jni.jEnv,Self.GetJavaBitmap,@Self.FBitmapInfo);
    case rtn = 0 of
      True  :begin
                 Result:= True;
                 FWidth:= FBitmapInfo.width;   //uint32_t
                 FHeight:= FBitmapInfo.height;  ////uint32_t
                 FStride:= FBitmapInfo.stride;  //uint32_t
                 FFormat:= FBitmapInfo.format;  //int32_t
                 FFlags:= FBitmapInfo.flags;   //uint32_t      // 0 for now
              end;
      False : Result:= False;
    end;
  end;
end;

function jBitmap.GetRatio: Single;
begin
  Result:= 1;  //dummy
  if Self.GetInfo then Result:= Round(Self.Width/Self.Height);
end;

//TODO: http://stackoverflow.com/questions/13583451/how-to-use-scanline-property-for-24-bit-bitmaps
procedure jBitmap.ScanPixel(PBytePixel: PScanByte; notByteIndex: integer);
var
  row, col, k, notFlag: integer;
begin

    if (notByteIndex < 0) or (notByteIndex > 4) then
        notFlag:= 4
    else
       notFlag:= notByteIndex;

     //API LockPixels - overloaded - paramenter is PScanByte
    Self.LockPixels(PBytePixel); //ok
    k:= 0;
    case notFlag of
      1:begin
          for row:= 0 to Self.Height-1 do  //ok
          begin
             for col:= 0 to Self.Width-1 do //ok
             begin
               PBytePixel^[k*4+0]:= not PBytePixel^[k*4]; //delphi mode....
               PBytePixel^[k*4+1]:= PBytePixel^[k*4+1];
               PBytePixel^[k*4+2]:= PBytePixel^[k*4+2];
               PBytePixel^[k*4+3]:= PBytePixel^[k*4+3];
               inc(k);
             end;
          end;
      end;
      2:begin
          for row:= 0 to Self.Height-1 do  //ok
          begin
             for col:= 0 to Self.Width-1 do //ok
             begin
               PBytePixel^[k*4+0]:= not PBytePixel^[k*4]; //delphi mode....
               PBytePixel^[k*4+1]:= PBytePixel^[k*4+1];
               PBytePixel^[k*4+2]:= PBytePixel^[k*4+2];
               PBytePixel^[k*4+3]:= PBytePixel^[k*4+3];
               inc(k);
             end;
          end;
      end;
      3:begin
          for row:= 0 to Self.Height-1 do  //ok
          begin
             for col:= 0 to Self.Width-1 do //ok
             begin
               PBytePixel^[k*4+0]:= not PBytePixel^[k*4]; //delphi mode....
               PBytePixel^[k*4+1]:= PBytePixel^[k*4+1];
               PBytePixel^[k*4+2]:= PBytePixel^[k*4+2];
               PBytePixel^[k*4+3]:= PBytePixel^[k*4+3];
               inc(k);
             end;
          end;
      end;
      4:begin
          for row:= 0 to Self.Height-1 do  //ok
          begin
             for col:= 0 to Self.Width-1 do //ok
             begin
               PBytePixel^[k*4+0]:= not PBytePixel^[k*4]; //delphi mode....
               PBytePixel^[k*4+1]:= PBytePixel^[k*4+1];
               PBytePixel^[k*4+2]:= PBytePixel^[k*4+2];
               PBytePixel^[k*4+3]:= PBytePixel^[k*4+3];
               inc(k);
             end;
          end;
      end;
    end;
    Self.UnlockPixels;
end;

//TODO: http://stackoverflow.com/questions/13583451/how-to-use-scanline-property-for-24-bit-bitmaps
procedure jBitmap.ScanPixel(PDWordPixel: PScanLine);
var
  k: integer;
begin     //API LockPixels... parameter is "PScanLine"
    Self.LockPixels(PDWordPixel); //ok
    for k:= 0 to Self.Width*Self.Height-1 do
        PDWordPixel^[k]:= not PDWordPixel^[k];  //ok
    Self.UnlockPixels;
end;

//------------------------------------------------------------------------------
// jCanvas
//------------------------------------------------------------------------------

constructor jCanvas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjObject := nil;
  FPaintStrokeWidth:= 1;
  FPaintStyle:= psFillAndStroke;
  FPaintTextSize:= 20;
  FPaintColor:= colbrBlue;
  FInitialized:= False;
end;

destructor jCanvas.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jCanvas_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jCanvas.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jCanvas_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  jCanvas_setStrokeWidth2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,FPaintStrokeWidth);
  jCanvas_setStyle2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,ord(FPaintStyle));
  jCanvas_setColor2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,GetARGB(FPaintColor));
  jCanvas_setTextSize2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,FPaintTextSize);
  FInitialized:= True;
end;

Procedure jCanvas.SetStrokeWidth(Value : single );
begin
  FPaintStrokeWidth:= Value;
  if FInitialized then
     jCanvas_setStrokeWidth2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,FPaintStrokeWidth);
end;

Procedure jCanvas.SetStyle(Value : TPaintStyle{integer});
begin
  FPaintStyle:= Value;
  if FInitialized then
     jCanvas_setStyle2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,Ord(FPaintStyle));
end;

Procedure jCanvas.SetColor(Value : TARGBColorBridge);
begin
  FPaintColor:= Value;
  if FInitialized then
     jCanvas_setColor2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,GetARGB(FPaintColor));
end;

Procedure jCanvas.SetTextSize(Value: single);
begin
  FPaintTextSize:= Value;
  if FInitialized then
     jCanvas_setTextSize2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,FPaintTextSize);
end;

Procedure jCanvas.DrawLine(x1,y1,x2,y2 : single);
begin
  if FInitialized then
     jCanvas_drawLine2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,x1,y1,x2,y2);
end;

Procedure jCanvas.DrawPoint(x1,y1 : single);
begin
  if FInitialized then
     jCanvas_drawPoint2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,x1,y1);
end;

Procedure jCanvas.drawText(Text: string; x,y: single);
begin
  if FInitialized then
     jCanvas_drawText2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,text,x,y);
end;

Procedure jCanvas.drawBitmap(bmp: jObject; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,bmp, b, l, r, t);
end;

Procedure jCanvas.drawBitmap(bmp: jBitmap; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject,bmp.GetJavaBitmap, b, l, r, t);
end;


Procedure jCanvas.drawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-20);
  t1:= Round((size-20)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject, bmp, x1, y1, r1, t1);
end;


Procedure jCanvas.drawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-20);
  t1:= Round((size-20)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject, bmp.GetJavaBitmap, x1, y1, r1, t1);
end;

//------------------------------------------------------------------------------
// jView
//------------------------------------------------------------------------------

constructor jView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start  := False;
  FMouches.Mouch.Zoom   := 1.0;
  FMouches.Mouch.Angle  := 0.0;
  FFilePath:=  fpathData;
  //FjCanvas := jCanvas.Create; // jCanvas
end;

Destructor jView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;

  FjObject := jView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  FjCanvas.Init;
  jView_setjCanvas(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self.FjObject, FjCanvas.JavaObj);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FjPRLayout);
  jView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject, FjPRLayout);
end;

Procedure jView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;

// LORDMAN 2013-08-14
procedure jView.SaveToFile(fileName: string);
var
  str: string;
begin
  str:= fileName;
  if str = '' then str := 'null';
  if FInitialized then
  begin
     if str <> 'null' then
     begin
        jView_viewSave2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath)+'/'+str);
     end;
  end;
end;

Procedure jView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

// Event : Java Event -> Pascal
Procedure jView.GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: Single);
begin
  case Act of
   cTouchDown : VHandler_touchesBegan_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchDown,FMouches);
   cTouchMove : VHandler_touchesMoved_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchMove,FMouches);
   cTouchUp   : VHandler_touchesEnded_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchUp  ,FMouches);
  end;
end;

// Event : Java Event -> Pascal
Procedure jView.GenEvent_OnDraw(Obj: TObject; jCanvas: jObject);
begin
  if Assigned(FOnDraw) then FOnDraw(Obj, jCanvas{FjCanvas});
end;

procedure jView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
    jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

function jView.GetWidth: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jView_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject)
end;

function jView.GetHeight: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jView_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FjCanvas then
      begin
        FjCanvas:= nil;
      end
  end;
end;

procedure jView.SetjCanvas(Value: jCanvas);
begin
  if Value <> FjCanvas then
  begin
    if Assigned(FjCanvas) then
    begin
       FjCanvas.RemoveFreeNotification(Self); //remove free notification...
    end;
    FjCanvas:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

//------------------------------------------------------------------------------
// jTimer
//------------------------------------------------------------------------------

Constructor jTimer.Create(AOwner: TComponent);
 begin
  inherited Create(AOwner);
  // Init
  FEnabled  := False;
  FInterval := 20;
  FOnTimer  := nil;
  FParent   := jForm(AOwner);
  FjObject  := nil;
end;

destructor jTimer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jTimer_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jTimer.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject:= jTimer_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  jTimer_SetInterval(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FInterval);
  FInitialized:= True;
end;

Procedure jTimer.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jTimer_SetEnabled2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FEnabled);
end;

Procedure jTimer.SetInterval(Value: integer);
begin
  FInterval:= Value;
  if FInitialized then
     jTimer_SetInterval2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FInterval);
end;

//------------------------------------------------------------------------------
// jDialog YN
//------------------------------------------------------------------------------

constructor jDialogYN.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FTitle:= 'jDialogYesNo';
  FMsg:= 'Accept ?';
  FYes:= 'Yes';
  FNo:= 'No';
  FParent:= jForm(AOwner);
  FjObject:= nil;
end;

Destructor jDialogYN.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jDialogYN_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogYN.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jDialogYN_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, FTitle, FMsg, FYes, FNo);
  FInitialized:= True;
end;

Procedure jDialogYN.Show;
begin
  if FInitialized then
     jDialogYN_Show2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

// Event : Java -> Pascal
Procedure jDialogYN.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if not Assigned(FOnDialogYN) then Exit;
  case (Value = cjClick_Yes) of
    True : FOnDialogYN(Obj, ClickYes);
    False: FOnDialogYN(Obj, ClickNo);
  end;
end;

//------------------------------------------------------------------------------
// jDialog Progress
//------------------------------------------------------------------------------
Constructor jDialogProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FParent  := jForm(AOwner);
  FjObject := nil;
  FTitle:= 'jDialogProgress';
  FMsg:= 'Please, wait...';
end;

Destructor jDialogProgress.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jDialogProgress_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogProgress.Stop;
begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jDialogProgress_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
        end;
      end;
    end;
end;

procedure jDialogProgress.Start;
begin
  if (FjObject = nil) and (FInitialized = True) then
     FjObject:= jDialogProgress_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, FTitle, FMsg);
end;

procedure jDialogProgress.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FInitialized:= True;
end;

//------------------------------------------------------------------------------
// jImageBtn
//------------------------------------------------------------------------------

Constructor jImageBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageUpName:='';
  FImageDownName:='';
  FImageUpIndex:= -1;
  FImageDownIndex:= -1;
  FLParamWidth:= lpWrapContent;
  FFilePath := fpathData;
end;

Destructor jImageBtn.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jImageBtn_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jImageBtn.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jImageBtn_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init;
   FjPRLayout:= FParentPanel.View;
  end;

  jImageBtn_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jImageBtn_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jImageBtn_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageBtn_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageBtn_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jImageBtn_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);

  FInitialized:= True;  //neded here....

  if FImageList <> nil then
  begin
    FImageList.Init;   //must have!
    if FImageList.Images.Count > 0 then
    begin
       if FImageUpIndex >=0 then SetImageUpByIndex(FImageUpIndex);
       if FImageDownIndex >=0 then SetImageDownByIndex(FImageDownIndex);
    end;
  end;
  jImageBtn_SetEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,FEnabled);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

procedure jImageBtn.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jImageBtn_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jImageBtn.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;

Procedure jImageBtn.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;
 
// LORDMAN 2013-08-16
procedure jImageBtn.SetEnabled(Value : Boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jImageBtn_SetEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FEnabled);
end;

procedure jImageBtn.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

Procedure jImageBtn.SetImageDownByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageDownName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageDownName <> '' then
      begin
        jImageBtn_setButtonDown2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageDownName);
      end;
   end;
end;

Procedure jImageBtn.SetImageUpByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageUpName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageUpName <> '' then
      begin
        jImageBtn_setButtonUp2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageUpName);
      end;
   end;
end;

procedure jImageBtn.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if jForm(Owner).Orientation = gApp.Orientation then
      side:= sdW
   else
      side:= sdH;
  jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jImageBtn.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
   if jForm(Owner).Orientation = gApp.Orientation then
      side:= sdH
   else
      side:= sdW;
   jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jImageBtn.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jImageBtn_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

procedure jImageBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FImageList then
      begin
        FImageList:= nil;
      end
  end;
end;

procedure jImageBtn.SetImages(Value: jImageList);
begin
  if Value <> FImageList then
  begin
    if Assigned(FImageList) then
    begin
       FImageList.RemoveFreeNotification(Self); //remove free notification...
    end;
    FImageList:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

// Event : Java -> Pascal
procedure jImageBtn.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

//------------------------------------------------------------------------------
// jAsyncTask
// http://stackoverflow.com/questions/5517641/publishprogress-from-inside-a-function-in-doinbackground
//------------------------------------------------------------------------------

//
constructor jAsyncTask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FOnAsyncEvent := nil;
  FjObject      := nil;
  FRunning:= False;
  FAutoPublishProgress:= False;
end;

destructor jAsyncTask.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jAsyncTask_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jAsyncTask.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FInitialized:= True;
end;

procedure jAsyncTask.Done;
begin
  if jForm(Owner).App <> nil then
  begin
    if jForm(Owner).App.Initialized then
    begin
      if FjObject <> nil then
      begin
        jAsyncTask_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
        FjObject:= nil;
        FRunning:= False;
      end;
    end;
  end;
end;

Procedure jAsyncTask.Execute;
begin
  if (FjObject = nil) and (FInitialized = True) and (FRunning = False) then
  begin
    FjObject:= jAsyncTask_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
    jAsyncTask_SetAutoPublishProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FAutoPublishProgress);
    jAsyncTask_Execute2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
    FRunning:= True;
  end;
end;

Procedure jAsyncTask.UpdateUI(Progress : Integer);
begin
  if FInitialized then
  begin
    jAsyncTask_setProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,Progress);
  end;
end;

procedure jAsyncTask.SetAutoPublishProgress(Value: boolean);
begin
  FAutoPublishProgress:= Value;
  if FInitialized then
  begin
    jAsyncTask_SetAutoPublishProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
  end;
end;

Procedure jAsyncTask.GenEvent_OnAsyncEvent(Obj: TObject;EventType, Progress:Integer);
begin
  if Assigned(FOnAsyncEvent) then FOnAsyncEvent(Obj,EventType,Progress);
end;

//------------------------------------------------------------------------------
// jGLViewEvent
//------------------------------------------------------------------------------

constructor jGLViewEvent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnGLCreate  := nil;
  FOnGLChange  := nil;
  FOnGLDraw    := nil;
  FOnGLDestroy := nil;
  //
  FOnGLDown := nil;
  FOnGLMove := nil;
  FOnGLUp   := nil;
  //
  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start  := False;
  FMouches.Mouch.Zoom   := 1.0;
  FMouches.Mouch.Angle  := 0.0;
  FInitialized:= False;
end;

Destructor jGLViewEvent.Destroy;
begin
  FOnGLCreate  := nil;
  FOnGLChange  := nil;
  FOnGLDraw    := nil;
  FOnGLDestroy := nil;
  //
  FOnGLDown := nil;
  FOnGLMove := nil;
  FOnGLUp   := nil;
  //
  inherited Destroy;
end;

procedure jGLViewEvent.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FInitialized:= True;
end;

//Event : Java Event -> Pascal
procedure jGLViewEvent.GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
begin
  if not FInitialized then Exit;
  gApp.Lock:= True;
  case Act of
    cTouchDown: VHandler_touchesBegan_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2), FOnGLDown, FMouches);
    cTouchMove: VHandler_touchesMoved_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2), FOnGLMove, FMouches);
    cTouchUp  : VHandler_touchesEnded_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2), FOnGLUp  , FMouches);
  end;
  gApp.Lock:= False;
end;

Procedure jGLViewEvent.GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
begin
  if not FInitialized then Exit;
  gApp.Lock:= True;
  Case EventType of
   cRenderer_onGLCreate  : If Assigned(FOnGLCreate ) then FOnGLCreate (Obj);
   cRenderer_onGLChange  : If Assigned(FOnGLChange ) then FOnGLChange (Obj,w,h);
   cRenderer_onGLDraw    : If Assigned(FOnGLDraw   ) then FOnGLDraw   (Obj);
   cRenderer_onGLDestroy : If Assigned(FOnGLDestroy) then FOnGLDestroy(Obj);
   cRenderer_onGLThread  : If Assigned(FOnGLThread ) then FOnGLThread (Obj);
  end;
  gApp.Lock:= False;
end;

  {jSqliteCursor}

constructor jSqliteCursor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FjObject := nil;
end;

destructor jSqliteCursor.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jSqliteCursor_Free(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jSqliteCursor.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jSqliteCursor_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FInitialized:= True;
end;

procedure jSqliteCursor.SetCursor(Value: jObject);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_SetCursor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Value);
end;


procedure jSqliteCursor.MoveToFirst;
begin
   if not FInitialized  then Exit;
   jSqliteCursor_MoveToFirst(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jSqliteCursor.MoveToNext;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToNext(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jSqliteCursor.MoveToLast;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToLast(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jSqliteCursor.MoveToPosition(position: integer);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToPosition(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, position);
end;

function jSqliteCursor.GetRowCount: integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetRowCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jSqliteCursor.GetColumnCount: integer;
begin
  if not FInitialized  then Exit;
  Result:= jSqliteCursor_GetColumnCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jSqliteCursor.GetColumnIndex(colName: string): integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumnIndex(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, colName);
end;

function jSqliteCursor.GetColumName(columnIndex: integer): string;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;
{
Cursor.FIELD_TYPE_NULL    //0
Cursor.FIELD_TYPE_INTEGER //1
Cursor.FIELD_TYPE_FLOAT   //2
Cursor.FIELD_TYPE_STRING  //3
Cursor.FIELD_TYPE_BLOB;   //4
}
function jSqliteCursor.GetColType(columnIndex: integer): TSqliteFieldType;
var
   colType: integer;
begin
   if not FInitialized  then Exit;
   colType:= jSqliteCursor_GetColType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
   case colType of
     0: Result:= ftNull;
     1: Result:= ftInteger;
     2: Result:= ftFloat;
     3: Result:= ftString;
     4: Result:= ftBlob;
   end;
end;

function jSqliteCursor.GetValueAsString(columnIndex: integer): string;
begin
 if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetValueAsString(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;

function jSqliteCursor.GetValueAsBitmap(columnIndex: integer): jObject;
begin
  if not FInitialized  then Exit;
    Result:= jSqliteCursor_GetValueAsBitmap(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;

function jSqliteCursor.GetValueAsInteger(columnIndex: integer): integer;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsInteger(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;

function jSqliteCursor.GetValueAsDouble(columnIndex: integer): double;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsDouble(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;


function jSqliteCursor.GetValueAsFloat(columnIndex: integer): real;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsFloat(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, columnIndex);
end;


{jSqliteDataAccess}

constructor jSqliteDataAccess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColDelimiter:= '|';
  FRowDelimiter:='#';
  FDataBaseName:='myData.db';
  FCreateTableQuery:= TStringList.Create;
  FTableName:= TStringList.Create;
  FInitialized:= False;
end;

Destructor jSqliteDataAccess.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jSqliteDataAccess_Free(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  FTableName.Free;
  FCreateTableQuery.Free;
  inherited Destroy;
end;

procedure jSqliteDataAccess.Init;
var
  i: integer;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject:= jSqliteDataAccess_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
  FDataBaseName, FColDelimiter, FRowDelimiter);

  FInitialized:= True;

  for i:= 0 to FTableName.Count-1 do
  begin
     jSqliteDataAccess_AddTableName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FTableName.Strings[i]);
  end;

  for i:= 0 to FCreateTableQuery.Count-1 do
  begin
     jSqliteDataAccess_AddCreateTableQuery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FCreateTableQuery.Strings[i]);
  end;

  {
  if FjSqliteCursor <> nil then
  begin
    FjSqliteCursor.Init;
    FjSqliteCursor.SetCursor(Self.GetCursor);
  end;
  }

end;

Procedure jSqliteDataAccess.ExecSQL(execQuery: string);
begin
   if not FInitialized then Exit;
   jSqliteDataAccess_ExecSQL(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, execQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

////"data/data/com.data.pack/databases/" + myData.db;
function jSqliteDataAccess.CheckDataBaseExists(databaseName: string): boolean;
var
  fullPathDB: string;
begin                      {/data/data/com.example.program/databases}
  if not FInitialized then Exit;
  fullPathDB:=  GetFilePath(fpathDataBase) + '/' + databaseName;
  Result:= jSqliteDataAccess_CheckDataBaseExists(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, fullPathDB);
end;

procedure jSqliteDataAccess.OpenOrCreate(dataBaseName: string);
begin
  if not FInitialized then Exit;
  if dataBaseName <> '' then FDataBaseName:= dataBaseName;
  jSqliteDataAccess_OpenOrCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FDataBaseName);
end;

procedure jSqliteDataAccess.AddTable(tableName: string; createTableQuery: string);
begin
  if not FInitialized then Exit;
   jSqliteDataAccess_AddTableName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, tableName);
   jSqliteDataAccess_AddCreateTableQuery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, createTableQuery);
end;

procedure jSqliteDataAccess.CreateAllTables;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateAllTables(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jSqliteDataAccess.Select(selectQuery: string) : string;
begin
   if not FInitialized then Exit;
   Result:= jSqliteDataAccess_Select(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, selectQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

procedure jSqliteDataAccess.Select(selectQuery: string);
begin
   if not FInitialized then Exit;
   jSqliteDataAccess_Select(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,  selectQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;


function jSqliteDataAccess.GetCursor: jObject;
begin
  if not FInitialized then Exit;
  Result:= jSqliteDataAccess_GetCursor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jSqliteDataAccess.SetSelectDelimiters(coldelim: char; rowdelim: char);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_SetSelectDelimiters(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, coldelim, rowdelim);
end;

//ex. "CREATE TABLE IF NOT EXISTS TABLE1  (_ID INTEGER PRIMARY KEY, NAME TEXT, PLACE TEXT);"
procedure jSqliteDataAccess.CreateTable(createQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, createQuery);
end;

procedure jSqliteDataAccess.DropTable(tableName: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DropTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, tableName);
end;

//ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('BRASILIA','CENTRO OESTE')"
procedure jSqliteDataAccess.InsertIntoTable(insertQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_InsertIntoTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, insertQuery);
end;

//ex: "DELETE FROM TABLE1  WHERE PLACE = 'BR'";
procedure jSqliteDataAccess.DeleteFromTable(deleteQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DeleteFromTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, deleteQuery);
end;

//ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'BR'"
procedure jSqliteDataAccess.UpdateTable(updateQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_UpdateTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, updateQuery);
end;

procedure jSqliteDataAccess.UpdateImage(tableName: string;imageFieldName: string;keyFieldName: string;imageValue: jObject;keyValue: integer);
begin
  jSqliteDataAccess_UpdateImage(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                                 tableName,imageFieldName,keyFieldName,imageValue,keyValue);
end;

procedure jSqliteDataAccess.Close;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_Close(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jSqliteDataAccess.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FjSqliteCursor then
      begin
        FjSqliteCursor:= nil;
      end
  end;
end;

procedure jSqliteDataAccess.SetjSqliteCursor(Value: jSqliteCursor);
begin
  if Value <> FjSqliteCursor then
  begin
    if Assigned(FjSqliteCursor) then
    begin
       FjSqliteCursor.RemoveFreeNotification(Self); //remove free notification...
    end;
    FjSqliteCursor:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

{jMediaPlayer}
(*
constructor jMediaPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;


destructor jMediaPlayer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jMediaPlayer_Free(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...
  inherited Destroy;
end;

Procedure jMediaPlayer.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject := jMediaPlayer_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, 'Path');
  //your code here
  FInitialized:= True;
end;

procedure jMediaPlayer.SetVolume(leftVolume: JFloat; rightVolume: JFloat);
begin

end;

function jMediaPlayer.GetDuration(): JInt;
begin

end;

function jMediaPlayer.GetCurrentPosition(): JInt;
begin

end;

procedure jMediaPlayer.SelectTrack(index: JInt);
begin

end;

function jMediaPlayer.IsLooping(): boolean;
begin

end;

procedure jMediaPlayer.SetLooping(looping: boolean);
begin

end;

procedure jMediaPlayer.SeekTo(millis: JInt);
begin

end;

function jMediaPlayer.IsPlaying(): boolean;
begin

end;

procedure jMediaPlayer.Pause();
begin

end;

procedure jMediaPlayer.Stop();
begin

end;

procedure jMediaPlayer.Start();
begin

end;

procedure jMediaPlayer.Prepare();
begin

end;

procedure jMediaPlayer.SetDataSource(path: string);
begin

end;
  *)

end.
