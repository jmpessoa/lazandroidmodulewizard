//------------------------------------------------------------------------------
//
//   Native Android Controls for Pascal
//
//   Compiler   Free Pascal Compiler FPC 2.7.1, ( XE5 in near future )
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
unit Laz_And_Controls; {start: 2013-10-26: a modified version of the simonsayz's "And_Controls"}
                       {author: jmpessoa@hotmail.com}
                       {ver_0.1 * 08-december-2013}
{$mode delphi}

interface

uses
  SysUtils, Classes, Math,
  And_jni, And_jni_Bridge,
  And_lib_Unzip, And_bitmap_h, CustApp{by jmpessoa};

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
  TInputTypeExArray: array[0..31] of DWord = ($00000000,
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
  TInputTypeEx  =(itxNone,
                  itxText,
                  itxCapCharacters,
                  itxCapWords,
                  itxCapSentences,
                  itxAutoCorrect,
                  itxAutoComplete,
                  itxMultiLine,
                  itxImeMultiLine,
                  itxNoSuggestions,
                  itxUri,
                  itxEmailAddress,
                  itxEmailSubject,
                  itxShortMessage,
                  itxLongMessage,
                  itxPersonName,
                  itxPostalAddress,
                  itxPassword,
                  itxVisiblePassword,
                  itxWebEditText,
                  itxFilter,
                  itxPhonetic,
                  itxWebEmailAddress,
                  itxWebPassword,
                  itxNumber,
                  itxNumberSigned,
                  itxNumberDecimal,
                  itxNumberPassword,
                  itxPhone,
                  itxDatetime,
                  itxDate,
                  itxTime);

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
  //TLayoutParamsEx = (lpMatchParent, lpWrapContent, lpTwoThirdParent, lpHalfParent,  lpThirdParent, lpQuarterParent);
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

  TScanLine = Array[0..0] of DWord;
  PScanLine = ^TScanline;

  TScanByte = Array[0..0] of JByte;  //by jmpessoa
  PScanByte = ^TScanByte;

  TLayoutRelativeTo = (lrParent, lrAnchor);

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
  TOnRotate          = Procedure(Sender: TObject; rotate : integer; Var rstRotate : integer) of Object;
  TOnActivityRst     = Procedure(Sender: TObject; requestCode,resultCode : Integer; jData : jObject) of Object;
  TOnGLChange        = Procedure(Sender: TObject; W, H: integer) of object;

  TOnClickYN         = Procedure(Sender: TObject; YN  : TClickYN) of object;
  TOnClickItem       = Procedure(Sender: TObject; Item: Integer ) of object;
  //
  TOnWebViewStatus   = Procedure(Sender: TObject; Status : TWebViewStatus;
                                 URL : String; Var CanNavi : Boolean) of object;
  TOnAsyncEvent      = Procedure(Sender: TObject; EventType,Progress : Integer) of object;
  // App
  TEnvJni     = record
                 jEnv        : PJNIEnv;
                 jThis       : jObject;   // JNI
                 jActivity   : jObject;   // Java Activity / android.content.Context
                 jRLayout    : jObject;   // Java Base Layout
                end;


           {
           The folder Digital Camera Image (DCIM) stored photographs from our digital camera
           }
  TEnvPath    = record
                 App         : string;    // /data/app/com.kredix-1.apk
                 Dat         : string;    // /data/data/com.kredix/files
                 Ext         : string;    // /storage/emulated/0
                 DCIM        : string;    // /storage/emulated/0/DCIM
  end;

  //by jmpessoa
  TFilePath = (fpathNone, fpathApp, fpathData, fpathExt, fpathDCIM);

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
                 CloseCB     : TjCallBack; // Close Call Back Event
                end;

  TjForms    =  record
                 Index       : integer;
                 Stack       : Array[0..cjFormsMax-1] of TjFormStack;
                end;

  TjFormState = (fsFormCreate,  // Initializing
                 fsFormWork,    // Working
                 fsFormClose);  // Closing


  jApp = class(TCustomApplication)
  private
    FInitialized : boolean;
    FAppName     : String;
    FClassName   : String;
    FForm        : jForm;       // Main/Initial Form
    //
    Procedure SetAppName  (Value : String);
    Procedure SetClassName(Value : String);
  protected
  public
    Jni           : TEnvJni;
    Path          : TEnvPath;
    Screen        : TEnvScreen;
    Device        : TEnvDevice;
    Forms         : TjForms;     // Form Stack
    Lock          : Boolean;     //
    Orientation   : integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; out Reference);

    Procedure Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject);
    Procedure Finish;
    //properties
    property Initialized : boolean read FInitialized;
    property Form: jForm read FForm write FForm;       // Main Form
    property AppName    : String     read FAppName    write SetAppName;
    property ClassName  : String     read FClassName  write SetClassName;
  end;

  jForm = class(TDataModule)
  private
    FInitialized : boolean;
    // Java
    FjObject       : jObject;      // Java : Java Object
    FjRLayout{View}: jObject;      // Java Relative Layout View
    //
    FFormName      : String;       // Form name
    FScreenWH      : TWH;
    FScreenStyle   : TScreenStyle;
    FAnimation     : TAnimation;

    FApp           : jApp;
    FEnabled       : Boolean;
    FVisible       : Boolean;
    FColor         : TARGBColorBridge;        // Background Color

    FCloseCallback : TjCallBack;   // Close Call Back Event
    FBackButton    : Boolean;      // Android Back Button Enabled

    FOnActive      : TOnNotify;
    FOnClose       : TOnNotify;
    FOnCloseQuery  : TOnCloseQuery;
    FOnRotate      : TOnRotate;
    FOnClick       : TOnNotify;
    FOnActivityRst : TOnActivityRst;
    FOnJNIPrompt   : TOnNotify;
    Procedure setEnabled (Value : Boolean);
    Procedure setVisible (Value : Boolean);
    Procedure setColor   (Value : TARGBColorBridge);
    function GetOrientation: integer;
  protected
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    FormState     : TjFormState;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(App: jApp);

    Procedure Show;
    Procedure Close;
    Procedure Refresh;

    Procedure SetCloseCallBack(Func : TOnNotify; Sender : TObject);
    //by jmpessoa
    Procedure UpdateLayout;
    // Property
    property View         : jObject        read FjRLayout      write FjRLayout;
    property Visible      : Boolean        read FVisible       write SetVisible;
    property ScreenStyle  : TScreenStyle   read FScreenStyle   write FScreenStyle;
    property Animation    : TAnimation     read FAnimation     write FAnimation;
    property Initialized  : boolean read FInitialized;
    property Orietation   : integer read GetOrientation;
    property App: jApp read FApp write FApp;
  published
    property BackButton: boolean read FBackButton write FBackButton;
    property Title: string  read FFormName write FFormName;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;
    // Event
    property OnActive     : TOnNotify      read FOnActive      write FOnActive;
    property OnClose      : TOnNotify      read FOnClose       write FOnClose;
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityRst: TOnActivityRst read FOnActivityRst write FOnActivityRst;
    property OnJNIPrompt: TOnNotify read FOnJNIPrompt write FOnJNIPrompt;
  end;

  {jControl - new by jmpessoa}

  jControl = class(TComponent)
  protected
    FjObject     : jObject; //Self
    FEnabled     : boolean;
    FInitialized : boolean;
    FApp         : jApp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(App: jApp);  virtual;
    // Property
    property Initialized : boolean read FInitialized;
    property App: jApp read FApp write FApp;
  end;

   //new by jmpessoa
  jImageList = class(jControl)
  private
    FImages : TStrings;
    FFilePath: TFilePath;
    procedure SetImages(Value: TStrings);
    procedure ListImagesChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(App: jApp); override;
    function GetImageByIndex(index: integer): string;
    function GetImageExByIndex(index: integer): string;
    // Property
  published
    property Images: TStrings read FImages write SetImages;
  end;

  //new by jmpessoa
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
   procedure Init(App: jApp); override;
   function Get: string; overload;
   function Get(location: string): string; overload;
   // Property
   property Url: string read FUrl;
  published
    property IndexUrl: integer read  FIndexUrl write SetIndexUrl;
    property Urls: TStrings read FUrls write SetUrls;
  end;

  //new by jmpessoa
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
   procedure Init(App: jApp); override;
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

  //new by jmpessoa
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
   procedure Init(App: jApp); override;
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

  //new by jmpessoa
  jCamera = class(jControl)
  private
   FFilename : string;
   FFilePath: TFilePath;
  public
   FullPathToBitmapFile: string;
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init(App: jApp); override;
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
    Procedure SetOnTimer(Value: TOnNotify);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init(App: jApp); override;
    //Property
    property Parent   : jForm     read FParent   write FParent;
  published
    property Enabled  : boolean   read FEnabled  write SetEnabled;
    property Interval : integer   read FInterval write SetInterval;
    //Event
    property OnTimer: TOnNotify read FOnTimer write SetOnTimer;
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
    procedure Init(App: jApp); override;

    Procedure LoadFromFile(fileName : String);
    Procedure CreateJavaBitmap(w,h : Integer);
    Function  GetJavaBitmap : jObject;
    procedure LockPixels(var PScanDWord: PScanLine); overload;
    procedure LockPixels(var PScanJByte: {PJByte} PScanByte); overload;
    procedure UnlockPixels;
    function GetInfo: boolean;

    //Function  GetBitmap : Pointer;
    //Procedure SetBitmap ( data : pointer );
    // Property

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
    procedure Init(App: jApp);  override;
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
    procedure Init(App: jApp); override;
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
  protected
    Procedure GenEvent_OnAsyncEvent(Obj: TObject;EventType,Progress : Integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(App: jApp); override;
    procedure Done;    //by jmpessoa
    Procedure Execute;
    Procedure UpdateUI(Progress : Integer);
    property Running: boolean read FRunning  write FRunning;
  published
    // Event
    property  OnAsyncEvent : TOnAsyncEvent read FOnAsyncEvent write FOnAsyncEvent;
  end;


  jVisualControl = class;
  jPanel = class;

  {jVisualControl - new by jmpessoa}
  jVisualControl = class(jControl)
  protected
    // Java
    FjPRLayout : jObject; // Java : Parent Relative Layout
    FParentPanel:  jPanel;

    FVisible   : Boolean;
    FColor     : TARGBColorBridge;
    FFontColor : TARGBColorBridge;
    FText      : string;
    FTextAlignment: TTextAlignment;

    FFontSize  : DWord;
    FId           : DWord;        //by jmpessoa
    FAnchorId     : DWord;
    FAnchor       : jVisualControl;  //http://www.semurjengkol.com/android-relative-layout-example/
    FPositionRelativeToAnchor: TPositionRelativeToAnchorIDSet;
    FPositionRelativeToParent: TPositionRelativeToParentSet;

    //FGravity      : TGravitySet;    TODO  - java "setGravity"

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
    procedure Init(App: jApp);  override;
    property AnchorId: DWord read FAnchorId write FAnchorId;
    property Width: integer Read GetWidth;
    property Height: integer Read GetHeight;
  published
    property Id: DWord read FId write SetId;
    property Anchor  : jVisualControl read FAnchor write SetAnchor;
    //property Gravity      : TGravitySet read FGravity write FGravity;   TODO!
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
    function GetWidth: integer; virtual;
    function GetHeight: integer;  virtual;
    procedure ResetRules;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(App: jApp);  override;
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
    procedure Init(App: jApp);  override;
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
    // Event
    property OnClick : TOnNotify read FOnClick   write FOnClick;
  end;

  jEditText = class(jVisualControl)
  private
    FInputTypeEx: TInputTypeEx;  //by jmpessoa
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
    procedure setParamHeight(Value: TLayoutParams);   //override;
    procedure SetParamWidth(Value: TLayoutParams);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(App: jApp); override;
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
    property SingleLine: boolean read FSingleLine write SetSingleLine;
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
    procedure Init(App: jApp); override;
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
    procedure Init(App: jApp); override;
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
    procedure Init(App: jApp); override;
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

    Function  GetProgress: integer;
    Procedure SetProgress (Value : integer);
    Function  GetMax: integer;   //by jmpessoa
    Procedure SetMax (Value : integer);  //by jmpessoa

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
    procedure Init(App: jApp); override;
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
    FCount: integer;
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
    procedure Init(App: jApp); override;
    Procedure SetImageByName(Value : string);
    Procedure SetImageByIndex(Value : integer);
    procedure SetImageBitmap(bitmap: jObject);

    // Property
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

  jListView = class(jVisualControl)
  private
    FjRLayout    : jObject; // Java : Self Layout
    FOnClickItem : TOnClickItem;
    FItems       : TStrings;
    Procedure SetVisible      (Value : Boolean);
    Procedure SetColor        (Value : TARGBColorBridge);
    Procedure SetFontColor    (Value : TARGBColorBridge);
    Procedure SetFontSize     (Value : DWord  );
    Procedure SetItemPosition (Value : TXY    );
    procedure ListViewChange(Sender: TObject);

    procedure SetItems(Value: TStrings);

    Procedure Item_Add(item : string);
    Procedure Item_Delete(index: Integer);
    Procedure Item_Clear;
    procedure SetParent(Value: jObject);
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    Procedure GenEvent_OnClick(Obj: TObject; Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(App: jApp);  override;
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View      : jObject   read FjRLayout  write FjRLayout; //self View
    property setItemIndex: TXY write SetItemPosition;
  published
    property Items     : TStrings read FItems write SetItems;
    property Visible   : Boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    // Event
    property OnClickItem : TOnClickItem read FOnClickItem write FOnClickItem;
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
    procedure Init(App: jApp);  override;
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
    procedure Init(App: jApp);  override;
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
    procedure Init(App: jApp);  override;
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
    procedure Init(App: jApp); override;
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
  protected
    procedure setParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    function GetWidth: integer ; override;
    function GetHeight: integer;  override;
    Procedure GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnDraw (Obj: TObject; jCanvas: jObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(App: jApp); override;
    Procedure SaveToFile(fileName:String);
    // Property
    property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property Canvas: jCanvas read FjCanvas write FjCanvas;
  published
    property Visible     : Boolean       read FVisible     write SetVisible;
    property BackgroundColor       : TARGBColorBridge{DWord} read FColor       write SetColor;
    // Event - Drawing
    property OnDraw      : TOnDraw       read FOnDraw      write FOnDraw;
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
    procedure Init(App: jApp); override;
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

  jCanvas = class
  private
    FInitialized : boolean;
    FApp         : jApp;
    // Java
    FjObject     : jObject; // Java : View
  protected
  public
    constructor Create;
    Destructor  Destroy; override;
    procedure Init(App: jApp);
    //
    Procedure setStrokeWidth       (width : single );
    Procedure setStyle             (style : integer);
    Procedure setColor             (color : TARGBColorBridge);
    Procedure setTextSize          (textsize : single );
    //
    Procedure drawLine             (x1,y1,x2,y2 : single);
    // LORDMAN 2013-08-13
    Procedure drawPoint            (x1,y1 : single);
    Procedure drawText             (Text : String; x,y : single);
    Procedure drawBitmap           (bmp : jBitmap; b,l,r,t : integer);
    // Property
    property  JavaObj : jObject           read FjObject;
    property Initialized : boolean read FInitialized;
    property App: jApp read FApp write FApp;
  end;

  jGLViewEvent = class
  private
    FInitialized : boolean;
    FApp         : jApp;
    //
    FOnGLCreate  : TOnNotify;
    FOnGLChange  : TOnGLChange;
    FOnGLDraw    : TOnNotify;
    FOnGLDestroy : TOnNotify;
    FOnGLThread  : TOnNotify;
    //
    FMouches     : TMouches;
    //
    FOnTouchDown : TOnTouchEvent;
    FOnTouchMove : TOnTouchEvent;
    FOnTouchUp   : TOnTouchEvent;
  protected
  public
    constructor Create;
    Destructor  Destroy; override;
    procedure Init(App: jApp);
    //
    Procedure GenEvent_OnTouch (Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
    //property
    property App: jApp read FApp write FApp;
    property Initialized : boolean read FInitialized;
  //published
    // Event - Drawing
    property OnGLCreate  : TOnNotify     read FOnGLCreate  write FOnGLCreate;
    property OnGLChange  : TOnGLChange   read FOnGLChange  write FOnGLChange;
    property OnGLDraw    : TOnNotify     read FOnGLDraw    write FOnGLDraw;
    property OnGLDestroy : TOnNotify     read FOnGLDestroy write FOnGLDestroy;
    property OnGLThread  : TOnNotify     read FOnGLThread  write FOnGLThread;
    // Event - Touch
    property OnTouchDown : TOnTouchEvent read FOnTouchDown write FOnTouchDown;
    property OnTouchMove : TOnTouchEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchUp   : TOnTouchEvent read FOnTouchUp   write FOnTouchUp;
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
  Procedure Java_Event_pAppOnActive              (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnStop                (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnBackPressed         (env: PJNIEnv; this: jobject);
  Function  Java_Event_pAppOnRotate              (env: PJNIEnv; this: jobject; rotate : Integer) : integer;
  Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnActivityResult      (env: PJNIEnv; this: jobject; requestCode,resultCode : Integer; jData : jObject);

  // Control Event
  Procedure Java_Event_pOnDraw                   (env: PJNIEnv; this: jobject; Obj: TObject; jCanvas: jObject);
  Procedure Java_Event_pOnClick                  (env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
  Procedure Java_Event_pOnChange                 (env: PJNIEnv; this: jobject; Obj: TObject; EventType : integer);
  Procedure Java_Event_pOnEnter                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTimer                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTouch                  (env: PJNIEnv; this: jobject; Obj: TObject;act,cnt: integer; x1,y1,x2,y2: single);

  // Control GLSurfaceView.Renderer Event
  Procedure Java_Event_pOnGLRenderer             (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);

  // Form Event
  Procedure Java_Event_pOnClose                  (env: PJNIEnv; this: jobject);

  // WebView Event
  Function  Java_Event_pOnWebViewStatus          (env: PJNIEnv; this: jobject; WebView : TObject; EventType : integer; URL : jString) : Integer;

  // AsyncTask Event & Task
  Procedure Java_Event_pOnAsyncEvent             (env: PJNIEnv; this: jobject; Obj : TObject; EventType,Progress : integer);

// Helper Function
Function  xy  (x, y: integer): TXY;
Function  xyWH(x, y, w, h: integer): TXYWH;
Function  fxy (x, y: Single ): TfXY;
Function  stringLen   (str: String): Integer;
Function  getDateTime: String;
Procedure ShowMessage(msg: string);
Function  getAnimation(i,o : TEffect ): TAnimation;
// Asset Function (P : Pascal Native)
Function  Asset_SaveToFile (srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;
Function  Asset_SaveToFileP(srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;
// App
Procedure App_Lock; {just for OO model!}
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
function SplitStr(var theString: string; delimiter: string): string;
function GetARGB(colbrColor: TARGBColorBridge): DWord;
function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle ): DWord;
function GetInputTypeEx(itxType: TInputTypeEx): DWord;
function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle ): DWord;
function GetPositionRelativeToAnchor(posRelativeToAnchorID: TPositionRelativeToAnchorID): DWord;
function GetPositionRelativeToParent(posRelativeToParent: TPositionRelativeToParent): DWord;

function GetLayoutParams(App: jApp; lpParam: TLayoutParams;  side: TSide): DWord;
function GetParamBySide(App: jApp; side: TSide): DWord;
function GetFilePath(filePath: TFilePath): string;

function GetGravity(gvValue: TGravity): DWord;  //TODO

var
  App: jApp; //global App !

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
function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle): DWord;
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
var
  index: integer;
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

function GetInputTypeEx(itxType: TInputTypeEx ): DWord;
var
  index: integer;
begin
  index:= (Ord(itxType));
  Result:= TInputTypeExArray[index];
end;

function GetFilePath(filePath: TFilePath): string;
begin
  Result:='';
  case filePath of
      fpathNone: Result:='';
      fpathExt: Result:= App.Path.Ext;
      fpathData: Result:= App.Path.Dat;
      fpathDCIM: Result:= App.Path.DCIM;
      fpathApp: Result:= App.Path.App;
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
  result := jStr_GetLength(App.Jni.jEnv, App.Jni.jThis, str);
 end;

// LORDMAN - 2013-07-30
Function getDateTime: String;
 begin
  result := jStr_GetDateTime(App.Jni.jEnv, App.Jni.jThis);
 end;

Procedure ShowMessage(msg: string);
begin
  if App = nil then Exit;
  if not App.Initialized then Exit;
  jToast(App.Jni.jEnv, App.Jni.jThis, msg);
end;

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
  jAsset_SaveToFile(App.Jni.jEnv,App.Jni.jThis,srcFile,outFile);
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
  If ZipExtract(App.Path.App,srcFile,Stream) then
   Stream.SaveToFile(outFile);
  Stream.free;
  Result := FileExists(outFile);
 end;


//------------------------------------------------------------------------------
//  App Lock
//------------------------------------------------------------------------------

Procedure App_Lock;
 begin
  App.Lock := True;
 end;

Procedure App_UnLock;
 begin
  App.Lock := False;
 end;

Function  App_IsLock: Boolean;
 begin
  Result := App.Lock;
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
  If Not(Assigned(TouchDown)) then Exit;
  //
  Mouches.Cnt    := Min(TouchCnt,cjMouchMax);
  Mouches.XYs[0] := Touch1;
  Mouches.XYs[1] := Touch2;

  MultiTouch_Calc(Mouches);
  TouchDown(Sender,Mouches.Mouch);
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
  If Not(Assigned(TouchMove)) then Exit;
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
  If Not(Assigned(TouchUp)) then Exit;
  //
  Mouches.Cnt    := Min(TouchCnt,cjMouchMax);
  Mouches.XYs[0] := Touch1;
  Mouches.XYs[1] := Touch2;

  MultiTouch_End(Mouches);
  TouchUp  (Sender,Mouches.Mouch);
 end;

//------------------------------------------------------------------------------
//  Activity Event
//------------------------------------------------------------------------------

Function Java_Event_pAppOnScreenStyle(env: PJNIEnv; this: jobject): integer;
begin
  case App.Screen.Style of
    ssSensor    : Result := 0;
    ssPortrait  : Result := 1;
    ssLandScape : Result := 2;
  end;
end;

Procedure Java_Event_pAppOnNewIntent(env: PJNIEnv; this: jObject);
begin
  dbg('pAppOnNewIntent');
end;

Procedure Java_Event_pAppOnDestroy(env: PJNIEnv; this: jobject);
begin
  dbg('pAppOnDestroy');
end;

Procedure Java_Event_pAppOnPause(env: PJNIEnv; this: jobject);
begin
  dbg('pAppOnPause');
end;

Procedure Java_Event_pAppOnRestart(env: PJNIEnv; this: jobject);
begin
  dbg('pAppOnRestart');
end;

Procedure Java_Event_pAppOnResume(env: PJNIEnv; this: jobject);
begin
  dbg('pAppOnResume');
end;

Procedure Java_Event_pAppOnActive(env: PJNIEnv; this: jObject);
begin
  //dbg('pAppOnActive');
  //ShowMessage('pAppOnActive NOT Implemented Yet!!');
end;

Procedure Java_Event_pAppOnStop(env: PJNIEnv; this: jobject);
begin
  dbg('pAppOnStop');
end;

// Event : OnBackPressed -> Form OnClose
Procedure Java_Event_pAppOnBackPressed(env: PJNIEnv; this: jobject);
var
  AForm : jForm;
begin
  AForm := App.Forms.Stack[App.Forms.Index-1].Form;
  if not(Assigned(AForm))           then Exit;
  if not(AForm.BackButton)         then Exit;
  if AForm.FormState <> fsFormWork then Exit;
  //
  AForm.Close;
end;

// Event : OnRotate -> Form OnRotate
Function Java_Event_pAppOnRotate(env: PJNIEnv; this: jobject;
                                 rotate : integer) : Integer;
 Var                   {rotate=1 --> device vertical/default position ; 2: device horizontal position}
  Form      : jForm;
  rstRotate : Integer;
 begin
  rstRotate:= -1; //just init...
  Result := rotate;
  Form := App.Forms.Stack[App.Forms.Index-1].Form;
  if Not( Assigned(Form         )) then Exit;
  if Assigned(Form.OnRotate) then Form.OnRotate(Form,rotate,{var}rstRotate);
  Result := rstRotate;
 end;

Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
 begin
  dbg('pAppOnConfigurationChanged');
 end;

Procedure Java_Event_pAppOnActivityResult(env: PJNIEnv; this: jobject;
                                                requestCode,resultCode : Integer;
                                                jData : jObject);
var
  Form      : jForm;
begin
  Form := App.Forms.Stack[App.Forms.Index-1].Form;
  if not( Assigned(Form              )) then Exit;
  if not( Assigned(Form.OnActivityRst)) then Exit;
  Form.OnActivityRst(Form,requestCode,resultCode,jData);
end;

//------------------------------------------------------------------------------
//  Control Event
//------------------------------------------------------------------------------


Procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject;
                             Obj: TObject; jCanvas: jObject);
begin
  if not (Assigned(Obj)) then Exit;
  if Obj is jView  then begin jView(Obj).GenEvent_OnDraw(Obj, jCanvas);  end;
end;


Procedure Java_Event_pOnClick(env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
begin
  if not (Assigned(Obj)) then Exit;
  if Obj is jForm        then begin jForm       (Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jTextView    then begin jTextView   (Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jButton      then begin jButton     (Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jCheckBox    then begin jCheckBox   (Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jRadioButton then begin jRadioButton(Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jDialogYN    then begin jDialogYN   (Obj).GenEvent_OnClick(Obj,Value); exit; end;
  if Obj is jImageBtn    then begin jImageBtn   (Obj).GenEvent_OnClick(Obj);       exit; end;
  if Obj is jListView    then begin jListVIew   (Obj).GenEvent_OnClick(Obj,Value); exit; end;
  if Obj is jImageView   then begin jImageView  (Obj).GenEvent_OnClick(Obj);       exit; end;
end;

Procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject;
                               Obj: TObject; EventType : integer);
begin
 if not (Assigned(Obj)) then Exit;
 if Obj is jEditText    then begin jEditText   (Obj).GenEvent_OnChange(Obj,EventType); exit; end;
end;

// LORDMAN
Procedure Java_Event_pOnEnter(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  if not (Assigned(Obj)) then Exit;
  if Obj is jEditText    then begin jEditText   (Obj).GenEvent_OnEnter(Obj);       exit; end;
end;

Procedure Java_Event_pOnTimer(env: PJNIEnv; this: jobject; Obj: TObject);
Var
  Timer : jTimer;
begin
  If App_IsLock then Exit;
  if not (Assigned(Obj)) then Exit;
  if not (Obj is jTimer) then Exit;

  Timer := jTimer(Obj);

  If not (Timer.Enabled)   then Exit;

  If Timer.Parent.FormState = fsFormClose then Exit;

  If not (Assigned(Timer.OnTimer)) then Exit;
  Timer.OnTimer(Timer);
end;


Procedure Java_Event_pOnTouch(env: PJNIEnv; this: jobject;
                              Obj: TObject;
                              act,cnt: integer; x1,y1,x2,y2 : single);
begin
  if not (Assigned(Obj))  then Exit;
  if Obj is jGLViewEvent  then begin jGLViewEvent(Obj).GenEvent_OnTouch(Obj,act,cnt,x1,y1,x2,y2); exit; end;
  if Obj is jView         then begin jView       (Obj).GenEvent_OnTouch(Obj,act,cnt,x1,y1,x2,y2); exit; end;
end;

Procedure Java_Event_pOnGLRenderer(env: PJNIEnv; this: jobject;
                                   Obj: TObject; EventType, w, h: integer);
begin
  if not (Assigned(Obj))  then Exit;
  if Obj is jGLViewEvent  then begin jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h); exit; end;
end;

Function  Java_Event_pOnWebViewStatus(env: PJNIEnv; this: jobject;
                                      webview   : TObject;
                                      eventtype : integer;
                                      URL       : jString) : Integer;
var
  pasWebView : jWebView;
  pasURL     : String;
  pasCanNavi : Boolean;
  _jBoolean  : jBoolean;
begin
  //
  Result     := cjWebView_Act_Continue;
  pasWebView := jWebView(webview);
  if Not(assigned(pasWebView         )) then Exit;
  if Not(assigned(pasWebView.OnStatus)) then Exit;
  //
  pasURL := '';
  If URL <> nil then
   begin
    _jBoolean := JNI_False;
    pasURL    := String( env^.GetStringUTFChars(Env,URL,@_jBoolean) );
   end;
  //
  pasCanNavi := True;
  pasWebView.OnStatus(pasWebView,IntToWebViewStatus(EventType),pasURL,pasCanNavi);
  If Not(pasCanNavi) then
   Result := cjWebView_Act_Break;
end;


Procedure Java_Event_pOnAsyncEvent   (env: PJNIEnv; this: jobject;
                                      Obj: TObject; EventType,Progress : integer);
begin
  if not (Assigned(Obj)) then Exit;
  if Obj is jAsyncTask then begin jAsyncTask(Obj).GenEvent_OnAsyncEvent(Obj,EventType,Progress); exit; end;
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
end;

Destructor jApp.Destroy;
begin
  Self.Finish;
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
  Jni.jEnv      := env;
  Jni.jThis     := this;
  Jni.jActivity := activity;
  Jni.jRLayout  := layout;
  // Screen
  Screen.WH     := jSysInfo_ScreenWH(env, this, activity);
  Orientation   := jSystem_GetOrientation(env, this, activity{context});
  // Device
  Path.App      := jSysInfo_PathApp(env, this, activity, PChar(FAppName){gjAppName});
  Path.Dat      := jSysInfo_PathDat(env, this, activity);
  Path.Ext      := jSysInfo_PathExt(env, this);
  Path.DCIM     := jSysInfo_PathDCIM(env, this);
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

Procedure jApp.SetAppName (Value : String);
begin
  FAppName  := Value;
end;

Procedure jApp.SetClassName(Value : String);
begin
  FClassName  := Value;
end;

Procedure jApp.Finish;
begin
  jApp_Finish(Self.Jni.jEnv,Self.Jni.jThis);
end;

//------------------------------------------------------------------------------
// jForm
//------------------------------------------------------------------------------

constructor jForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Initialize
  FApp                  := nil;
  FVisible              := False; //True;
  FEnabled              := True;
  //FForm               := nil; //Owner;
  FColor                := colbrBlack;
  FFormName             := 'jForm';
  FormState            := fsFormCreate;
  FCloseCallBack.Event  := nil;
  FCloseCallBack.Sender := nil;
  FBackButton           := True;//False;        // Back Button Press Event Enabled
  FOnActive             := nil;
  FOnClose              := nil;
  FOnCloseQuery         := nil;
  FOnRotate             := nil;
  FOnClick              := nil;
  FOnActivityRst        := nil;
  FOnJNIPrompt          := nil;

  FjObject              := nil;
  FjRLayout{View}       := nil;
  FScreenWH.Height      := 100; //dummy
  FScreenWH.Width       := 100;

  FAnimation.In_        := cjEft_None; //cjEft_FadeIn;
  FAnimation.Out_       := cjEft_None; //cjEft_FadeOut;
  FInitialized          := False;
end;

destructor jForm.Destroy;
begin
  if FjObject <> nil then
  begin
     if App <> nil then
     begin
        if App.Initialized then
        begin
         jForm_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
         jSystem_GC(App.Jni.jEnv, App.Jni.jThis);
        end;
     end;
  end;
  inherited Destroy;
end;

procedure jForm.Init(App: jApp);
var
  i: integer;
  bkImgIndex: integer;
begin
  if FInitialized  then Exit;
  if App = nil then Exit;
  if not App.Initialized then Exit;
  FApp:= App;
  FScreenWH:= App.Screen.WH;
  FjObject:= jForm_Create(App.Jni.jEnv, App.Jni.jThis, Self);
  FjRLayout:= jForm_Getlayout(App.Jni.jEnv, App.Jni.jThis, FjObject);

  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout, GetARGB(FColor));

  //jForm_SetVisibility(App.Jni.jEnv, App.Jni.jThis, FjObject ,FVisible); //BUG
  jForm_SetEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);

  bkImgIndex:= -1;
  FInitialized:= True;

  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if Self.Components[i] is jControl then
    begin
       if (Self.Components[i] as jControl).ClassName = 'jImageView' then
       begin
          if (Self.Components[i] as jImageView).IsBackgroundImage = True then
          begin
             bkImgIndex:= i;
            (Self.Components[i] as jControl).Init(App);
          end;
       end;
    end;
  end;

  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if Self.Components[i] is jControl then
    begin
      if i <> bkImgIndex then (Self.Components[i] as jControl).Init(App);
    end;
  end;

  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
end;

function jForm.GetOrientation: integer;
begin
   Result:= App.Orientation; //jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity{context});
end;

Procedure jForm.setEnabled(Value: Boolean);
begin
 FEnabled := Value;
 if FInitialized then
   jForm_SetEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject,FEnabled);
end;

Procedure jForm.SetVisible(Value: Boolean);
begin
 FVisible := Value;
 if FInitialized then
    jForm_SetVisibility(App.Jni.jEnv, App.Jni.jThis, FjObject ,FVisible);
end;

Procedure jForm.SetColor(Value: TARGBColorBridge);
begin
 FColor:= Value;
 if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout,GetARGB(FColor));
end;

Procedure jForm.Show;
 begin
  if not FInitialized then Exit;
  if FVisible then Exit;
  if App.Forms.Index = cjFormsMax then Exit;
  //
  FVisible:= True;
  //
  //jForm_SetVisibility(App.Jni.jEnv, App.Jni.jThis, FjObject ,FVisible); //BUG
  App.Forms.Stack[App.Forms.Index].Form    := Self;
  App.Forms.Stack[App.Forms.Index].CloseCB := FCloseCallBack;
  Inc(App.Forms.Index);
  jForm_Show(App.Jni.jEnv,App.Jni.jThis,FjObject,FAnimation.In_);
  FormState := fsFormWork;
  if Assigned(FOnActive) then FOnActive(Self);
end;

Procedure jForm.UpdateLayout;
var
  i: integer;
begin
    for i := Self.ComponentCount - 1 downto 0 do
    begin
      if Self.Components[i] is jVisualControl then
      begin
        (Self.Components[i] as jVisualControl).UpdateLayout;
      end;
    end;
end;

//Ref. Destroy
Procedure jForm.Close;
var
  CanClose : boolean;
  //rst : Integer;
begin
  if not FInitialized then Exit;
  // Event : OnCloseQuery
  if Assigned(FOnCloseQuery) then
  begin
    CanClose := False;
    FOnCloseQuery(Self, CanClose);
    if CanClose = False then
    begin
        Exit;
    end;
  end;
  //
  FormState := fsFormClose;
  //FVisible:= False;
  //jForm_SetVisibility(App.Jni.jEnv, App.Jni.jThis, FjObject ,FVisible);
  jForm_Close(App.Jni.jEnv, App.Jni.jThis, FjObject,FAnimation.Out_);
  // Post Closing Step
  // --------------------------------------------------------------------------
  // Java           Java          Java-> Pascal
  // jForm_Close -> RemoveView -> Java_Event_pOnClose
end;

Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject);
var
  Form : jForm;
  Inx  : Integer;
begin
  if App = nil then Exit;
  if not App.Initialized then exit;
  Form := App.Forms.stack[App.Forms.Index-1].Form;
  if not(Assigned(Form)) then Exit;
  Form.Visible  := False;
  If Assigned(Form.OnClose) then Form.OnClose(Form);

  If App.Forms.Index > 0 then Dec(App.Forms.Index);

  // LORDMAN - 2013-08-01 / Call Back - 현재 Form 이전것을 한다.

  Inx := App.Forms.Index;
  if Assigned(App.Forms.Stack[Inx].CloseCB.Event) then
  begin
    App.Forms.Stack[Inx].CloseCB.Event(App.Forms.Stack[Inx].CloseCB.Sender);
    App.Forms.Stack[Inx].CloseCB.Event  := nil;
    App.Forms.Stack[Inx].CloseCB.Sender := nil;
  end;
end;

Procedure jForm.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, Self.View);
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

//-------------------------------------------------
   {jControl by jmpessoa}
//--------------------------------------------------
Constructor jControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FApp       := nil;
  FInitialized:= False;
end;

//
Destructor jControl.Destroy;
begin
  inherited Destroy;
end;

procedure jControl.Init(App: jApp);
begin
  if App = nil then Exit;
  if not App.Initialized then Exit;
  FApp:= App;
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
  FColor     := colbrDefault; //colbrNone;
  FFontColor := colbrDefault; //colbrWhite;
  FFontSize  := 0; //default size!
  FId        := 0; //( 0: no control anchor on this control!)
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

procedure jVisualControl.Init(App: jApp);
begin
  inherited Init(App);
  FjPRLayout:= jForm(Owner).View;  //set parent!
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jTextView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jTextView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  //gvt: TGravity;     TODO
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jTextView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jTextView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);

  jTextView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jTextView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));
  (* TODO
  for gvt := gvBottom  to gvFillVertical do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addGravity(App.Jni.jEnv, App.Jni.jThis, FjObject, GetGravity(gvt));
    end;
  end;
  *)
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jTextView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jTextView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  jTextView_setEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
  jTextView_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);

  if  FFontColor <> colbrDefault then
     jTextView_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jTextView_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);

  jTextView_setTextAlignment(App.Jni.jEnv, App.Jni.jThis, FjObject, Ord(FTextAlignment));

  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jTextView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jTextView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jTextView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jTextView.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  if FInitialized then
    jTextView_setEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
end;

Function jTextView.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jTextView_getText(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jTextView.SetText(Value: string);
begin
  FText:= utf8encode(Value);
  if FInitialized then
    jTextView_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);
end;

Procedure jTextView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
    jTextView_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jTextView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and  (FFontSize > 0) then
    jTextView_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

procedure jTextView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jTextView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jTextView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jTextView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jTextView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jTextView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
end;

// LORDMAN 2013-08-12
Procedure jTextView.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
    jTextView_setTextAlignment(App.Jni.jEnv, App.Jni.jThis, FjObject, Ord(FTextAlignment));
end;

Procedure jTextView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
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
  FHorizontalScrollBar:= False;
  FWrappingLine:= True;
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
end;

Destructor jEditText.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jEditText_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jEditText.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jEditText_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jEditText_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jEditText_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jEditText_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jEditText_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jEditText_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jEditText_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jEditText_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);

  if  FFontColor <> colbrDefault then
     jEditText_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jEditText_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);

  jEditText_setSingleLine(App.Jni.jEnv, App.Jni.jThis, FjObject, FSingleLine);

  if (FMaxLines > 1) and (FSingleLine = False) then
    jEditText_setMaxLines(App.Jni.jEnv, App.Jni.jThis, FjObject, FMaxLines);

  jEditText_setScroller(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, FjObject);

  jEditText_setHorizontalScrollBarEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FHorizontalScrollBar);
  jEditText_setVerticalScrollBarEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FVerticalScrollBar);

  if FScrollBarStyle <> scrNone then
     jEditText_setScrollBarStyle(App.Jni.jEnv, App.Jni.jThis, FjObject, GetScrollBarStyle(FScrollBarStyle));

  if (FVerticalScrollBar = True) or  (FHorizontalScrollBar = True) then
  begin
    jEditText_setScrollbarFadingEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, False);
    jEditText_setMovementMethod(App.Jni.jEnv, App.Jni.jThis, FjObject);
  end;

  jEditText_setHorizontallyScrolling(App.Jni.jEnv, App.Jni.jThis, FjObject, not(FWrappingLine));

  jEditText_setHint(App.Jni.jEnv, App.Jni.jThis, FjObject, FHint);
  jEditText_editInputTypeEx(App.Jni.jEnv, App.Jni.jThis, FjObject,GetInputTypeEx(FInputTypeEx));
  jEditText_maxLength(App.Jni.jEnv, App.Jni.jThis, FjObject, FLineMaxLength);
  jEditText_setTextAlignment(App.Jni.jEnv, App.Jni.jThis, FjObject, Ord(FTextAlignment));

  if  FColor <> colbrDefault then
      jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jEditText.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jEditText_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jEditText.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jEditText.setColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jEditText.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

function jEditText.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jEditText_getText(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jEditText.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jEditText_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);
end;

procedure jEditText.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jEditText_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jEditText.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jEditText_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

Procedure jEditText.SetHint(Value : String);
begin
  FHint:= Value;
  if FInitialized then
     jEditText_setHint(App.Jni.jEnv, App.Jni.jThis, FjObject, FHint);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetFocus();
begin
  if FInitialized then
     jEditText_SetFocus(App.Jni.jEnv, App.Jni.jThis, FjObject );
end;

{
//InputMethodManager
mgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
mgr.hideSoftInputFromWindow(myView.getWindowToken(), 0);

}
// LORDMAN - 2013-07-26
Procedure jEditText.immShow();
begin
  if FInitialized then
     jEditText_immShow(App.Jni.jEnv, App.Jni.jThis, FjObject );
end;

// LORDMAN - 2013-07-26
Procedure jEditText.immHide();
begin
  if FInitialized then
      jEditText_immHide(App.Jni.jEnv, App.Jni.jThis, FjObject );
end;

//by jmpessoa
Procedure jEditText.SetInputTypeEx(Value : TInputTypeEx);
begin
  FInputTypeEx:= Value;
  if FInitialized then
     jEditText_editInputTypeEx(App.Jni.jEnv, App.Jni.jThis, FjObject,GetInputTypeEx(FInputTypeEx));
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetLineMaxLength(Value: DWord);
begin
  FLineMaxLength:= Value;
  if FInitialized then
     jEditText_maxLength(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

//by jmpessoa
Procedure jEditText.SetMaxLines(Value: DWord);
begin
  FMaxLines:= Value;
  if FInitialized then
     jEditText_setMaxLines(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetSingleLine(Value: boolean);
begin
  FSingleLine:= Value;
  if FInitialized then
     jEditText_setSingleLine(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetScrollBarStyle(Value: TScrollBarStyle);
begin
  FScrollBarStyle:= Value;
  if FInitialized then
  begin
    if Value <> scrNone then
    begin
       jEditText_setScrollBarStyle(App.Jni.jEnv, App.Jni.jThis, FjObject, GetScrollBarStyle(Value));
    end;
  end;
end;

procedure jEditText.SetHorizontalScrollBar(Value: boolean);
begin
  FHorizontalScrollBar:= Value;
  if FInitialized then
    jEditText_setHorizontalScrollBarEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetVerticalScrollBar(Value: boolean);
begin
  FVerticalScrollBar:= Value;
  if FInitialized then
    jEditText_setVerticalScrollBarEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetScrollBarFadingEnabled(Value: boolean);
begin
  if FInitialized then
    jEditText_setScrollbarFadingEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, Value);
end;

procedure jEditText.SetMovementMethod;
begin
  if FInitialized then ;
    jEditText_setMovementMethod(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

// LORDMAN - 2013-07-26
Function jEditText.GetCursorPos: TXY;
begin
  Result.x := 0;
  Result.y := 0;
  if FInitialized then
     jEditText_GetCursorPos(App.Jni.jEnv, App.Jni.jThis, FjObject,Result.x,Result.y);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetCursorPos(Value: TXY);
begin
  if FInitialized then
     jEditText_SetCursorPos(App.Jni.jEnv, App.Jni.jThis, FjObject, Value.X,Value.Y);
end;

// LORDMAN 2013-08-12
Procedure jEditText.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
     jEditText_setTextAlignment(App.Jni.jEnv, App.Jni.jThis, FjObject, Ord(FTextAlignment));
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
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jEditText_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jEditText.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jEditText_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jEditText.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jEditText_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
     if App <> nil then
     begin
       if App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jButton_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jButton.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jButton_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jButton_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);

  jButton_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jButton_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
       jButton_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jButton_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jButton_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  jButton_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jButton_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then //not default...
     jButton_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jButton.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jButton_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jButton.Refresh;
begin
  if not FInitialized then Exit;
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Function jButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jButton_getText(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
    jButton_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);
end;

Procedure jButton.SetFontColor(Value : TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jButton_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jButton.SetFontSize (Value : DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jButton_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

procedure jButton.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jButton_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jButton.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jButton_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jButton.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jButton_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
end;

destructor jCheckBox.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jCheckBox_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jCheckBox.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject := jCheckBox_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jCheckBox_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jCheckBox_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jCheckBox_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCheckBox_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jCheckBox_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= 0;

  jCheckBox_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jCheckBox_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jCheckBox_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jCheckBox_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jCheckBox.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jCheckBox_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jCheckBox.SetVisible(Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jCheckBox.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jCheckBox.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Function jCheckBox.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jCheckBox_getText(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jCheckBox.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jCheckBox_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);
end;

Procedure jCheckBox.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jCheckBox_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jCheckBox.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jCheckBox_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

Function jCheckBox.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
     Result:= jCheckBox_isChecked(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jCheckBox.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jCheckBox_setChecked(App.Jni.jEnv, App.Jni.jThis, FjObject, FChecked);
end;

procedure jCheckBox.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jCheckBox_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jCheckBox.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jCheckBox_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jCheckBox.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jCheckBox_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
end;

destructor jRadioButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jRadioButton_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jRadioButton.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jRadioButton_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jRadioButton_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jRadioButton_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jRadioButton_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jRadioButton_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jRadioButton_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jRadioButton_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jRadioButton_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);

  if FFontColor <> colbrDefault then
     jRadioButton_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));

  if FFontSize > 0 then
     jRadioButton_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);

  jRadioButton_setChecked(App.Jni.jEnv, App.Jni.jThis, FjObject, FChecked);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jRadioButton.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jRadioButton_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jRadioButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jRadioButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jRadioButton.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Function jRadioButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jRadioButton_getText(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jRadioButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jRadioButton_setText(App.Jni.jEnv, App.Jni.jThis, FjObject, FText);
end;

Procedure jRadioButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jRadioButton_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jRadioButton.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jRadioButton_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

Function jRadioButton.GetChecked: boolean;
begin
  Result:= FChecked;
  if FInitialized then
     Result:= jRadioButton_isChecked(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jRadioButton.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jRadioButton_setChecked(App.Jni.jEnv, App.Jni.jThis, FjObject, FChecked);
end;

procedure jRadioButton.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if FInitialized then
  begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jRadioButton_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
  end;
end;

procedure jRadioButton.setParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jRadioButton_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jRadioButton.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jRadioButton_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
     if App <> nil then
     begin
       if App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jProgressBar_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jProgressBar.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jProgressBar_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self, GetProgressBarStyle(FStyle));

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jProgressBar_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jProgressBar_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jProgressBar_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jProgressBar_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jProgressBar_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jProgressBar_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jProgressBar_setProgress(App.Jni.jEnv, App.Jni.jThis, FjObject, FProgress);
  jProgressBar_setMax(App.Jni.jEnv, App.Jni.jThis, FjObject, FMax);  //by jmpessoa

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

Procedure jProgressBar.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jProgressBar_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
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
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jProgressBar.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jProgressBar.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Function jProgressBar.GetProgress: integer;
begin
  Result:= FProgress;
  if FInitialized then
     Result:= jProgressBar_getProgress(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jProgressBar.SetProgress(Value: integer);
begin
  if Value >= 0 then FProgress:= Value
  else FProgress:= 0;
  if FInitialized then
     jProgressBar_setProgress(App.Jni.jEnv, App.Jni.jThis, FjObject, FProgress);
end;

//by jmpessoa
Procedure jProgressBar.SetMax(Value: integer);
begin
  if Value > FProgress  then FMax:= Value;
  if FInitialized then
     jProgressBar_setMax(App.Jni.jEnv, App.Jni.jThis, FjObject, FMax);
end;

//by jmpessoa
Function jProgressBar.GetMax: integer;
begin
  Result:= FMax;
  if FInitialized then
     Result:= jProgressBar_getMax(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jProgressBar.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jProgressBar_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jProgressBar.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jProgressBar_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jProgressBar.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jProgressBar_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
     if App <> nil then
     begin
       if App.Initialized then
       begin
         if FjObject <> nil then
         begin
           jImageView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
           FjObject:= nil;
         end;
       end;
     end;
   end;
   inherited Destroy;
end;

Procedure jImageView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jImageView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jImageView_setParent(App.Jni.jEnv, App.Jni.jThis,FjObject, FjPRLayout);
  jImageView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jImageView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  if FColor <> colbrDefault then
      jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  FInitialized:= True;  //neded here....
  if FImageList <> nil then
  begin
    FImageList.Init(App);
    if FImageList.Images.Count > 0 then
    begin
       if FImageIndex >=0 then SetImageByIndex(FImageIndex);
    end;
  end;

  jImageView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

procedure jImageView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jImageView_setParent(App.Jni.jEnv, App.Jni.jThis,FjObject, FjPRLayout);
end;

Procedure jImageView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jImageView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
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
      jImageView_setImage(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageName);
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
        jImageView_setImage(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageName);
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
  if FInitialized then SetImageByIndex(Value);
end;

function jImageView.GetImageIndex: integer;
begin
  Result:= FImageIndex;
end;

procedure jImageView.SetImageBitmap(bitmap: jObject);
begin
  if FInitialized then
     jImageView_setBitmapImage(App.Jni.jEnv, App.Jni.jThis, FjObject, bitmap);
end;

procedure jImageView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jImageView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jImageView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jImageView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jImageView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jImageView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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

//-------------- by jmpessoa

    {jImageList}
//-------------
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        //
      end;
    end;
  end;
  FImages.Free;
  inherited Destroy;
end;

procedure jImageList.Init(App: jApp);
var
  i: integer;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  for i:= 0 to FImages.Count - 1 do
  begin
     if Trim(FImages.Strings[i]) <> '' then
        Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
  end;
  FInitialized:= True;
end;

procedure jImageList.SetImages(Value: TStrings);
begin
  FImages.Assign(Value);
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
        Result:= GetFilePath(FFilePath){App.Path.Dat}+'/'+Trim(FImages.Strings[index]);
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
 if App <> nil then
 begin
  if App.Initialized then
  begin
    //
  end;
 end;
 end;
 FUrls.Free;
 inherited Destroy;
end;

procedure jHttpClient.Init(App: jApp);
var
 i: integer;
begin
 if FInitialized  then Exit;
 inherited Init(App);
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
   Result:= jHttp_get(App.jni.jEnv, App.jni.jThis, FUrl);
end;

function jHttpClient.Get(location: string): string;
begin
  FUrl:= location;
  if FInitialized then
     Result:= jHttp_get(App.jni.jEnv, App.jni.jThis, location);
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
 if App <> nil then
 begin
  if App.Initialized then
  begin
    //
  end;
 end;
 end;
 FMails.Free;
 FMailMessage.Free;
 inherited Destroy;
end;

procedure jSMTPClient.Init(App: jApp);
var
 i: integer;
begin
 if FInitialized  then Exit;
 inherited Init(App);
(*  TODO
 for i:= 0 to FMails.Count - 1 do
 begin
  if Trim(FMails.Strings[i]) <> '' then
    Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
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
    jSend_Email(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
                FMailTo,              //to
                FMailCc,              //cc
                FMailBcc,             //bcc
                FMailSubject,         //subject
                FMailMessage.Text);   //message
end;

procedure jSMTPClient.Send(mTo: string; subject: string; msg: string);
begin
  if FInitialized then
     jSend_Email(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
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
 if App <> nil then
 begin
  if App.Initialized then
  begin
    //
  end;
 end;
 end;
 FSMSMessage.Free;
 FContactList.Free;
 inherited Destroy;
end;

procedure jSMS.Init(App: jApp);
var
 i: integer;
begin
 if FInitialized  then Exit;
 inherited Init(App);
 if FLoadMobileContacts then GetContactList;
 FInitialized:= True;
end;

function jSMS.GetContactList: string;
begin
 if FInitialized then
  FContactList.DelimitedText:= jContact_getDisplayNameList(App.Jni.jEnv,
                                                                      App.Jni.jThis, App.Jni.jActivity,
                                                                      FContactListDelimiter);
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
      FMobileNumber:= jContact_getMobileNumberByDisplayName(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
                                                         FContactName);
    if FMobileNumber <> '' then
        jSend_SMS(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
                  FMobileNumber,     //to
                  FSMSMessage.Text);  //message
  end;
end;

procedure jSMS.Send(toName: string);
begin
  if FInitialized then
  begin
    if toName<> '' then
      FMobileNumber:= jContact_getMobileNumberByDisplayName(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
                                                            toName);
    if FMobileNumber <> '' then
        jSend_SMS(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
                  FMobileNumber,     //to
                  FSMSMessage.Text);  //message
  end;
end;

procedure jSMS.Send(toNumber: string;  msg: string);
begin
 if FInitialized then
 begin
    if toNumber <> '' then
        jSend_SMS(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity,
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
 if App <> nil then
 begin
  if App.Initialized then
  begin
    //
  end;
 end;
 end;
 inherited Destroy;
end;

procedure jCamera.Init(App: jApp);
begin
 if FInitialized  then Exit;
 inherited Init(App);
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
     Self.FullPathToBitmapFile:= jCamera_takePhoto(App.jni.jEnv, App.jni.jThis,App.jni.jActivity,
                                                   GetFilePath(FFilePath), FFileName);
  end;
end;

//------------------------------------------------------------------------------
// jListlView
//------------------------------------------------------------------------------

constructor jListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems      := TStringList.Create;
  TStringList(FItems).OnChange:= ListViewChange;  //event handle
end;

destructor jListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jListView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  FItems.Free;
  inherited Destroy;
end;

procedure jListView.Init(App: jApp);
var
  i: integer;
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jListView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jListView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jListView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jListView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jListView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jListView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jListView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  if FFontColor <> colbrDefault then
     jListView_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
  if FFontSize > 0 then
     jListView_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  for i:= 0 to FItems.Count - 1 do
  begin
    jListView_add(App.Jni.jEnv, App.Jni.jThis, FjObject, FItems.Strings[i]);
  end;
  FInitialized:= True;
end;

procedure jListView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jListView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jListView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jListView.SetColor (Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jListView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv,App.Jni.jThis, FjObject);
end;

Procedure jListView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault ) then
     jListView_setTextColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FFontColor));
end;

Procedure jListView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jListView_setTextSize(App.Jni.jEnv, App.Jni.jThis, FjObject, FFontSize);
end;

// LORDMAN 2013-08-07
Procedure jListView.SetItemPosition(Value: TXY);
begin
  if FInitialized then
     jListView_setItemPosition(App.Jni.jEnv, App.Jni.jThis, FjObject, Value.X, Value.Y);
end;

//
Procedure jListView.Item_Add(item : string);
begin
  if FInitialized then
     jListView_add(App.Jni.jEnv, App.Jni.jThis, FjObject, item);
end;

//
Procedure jListView.Item_Delete(index: Integer);
begin
  if FInitialized then
     jListView_delete(App.Jni.jEnv, App.Jni.jThis, FjObject, index);
end;

//
Procedure jListView.Item_Clear;
begin
  if FInitialized then
    jListView_clear(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

//by jmpessoa
procedure jListView.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

//by jmpessoa
procedure jListView.ListViewChange(Sender: TObject);
var
  i: integer;
begin
  if FInitialized then
  begin
    jListView_clear(App.Jni.jEnv, App.Jni.jThis, FjObject);
    for i:= 0 to FItems.Count - 1 do
    begin
       jListView_add(App.Jni.jEnv, App.Jni.jThis, FjObject, FItems.Strings[i]);
    end;
  end;
end;

procedure jListView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jListView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jListView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jListView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jListView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jListView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
end;

// Event : Java -> Pascal
Procedure jListView.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Obj,Value);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jScrollView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jScrollView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);

  FjObject:= jScrollView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);
  FjRLayout:= jScrollView_getView(App.Jni.jEnv, App.Jni.jThis, FjObject); // Java : Self Layout

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jScrollView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jScrollView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jScrollView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jScrollView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jScrollView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jScrollView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  jScrollView_setScrollSize(App.Jni.jEnv, App.Jni.jThis,FjObject, FScrollSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jScrollView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jScrollView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jScrollView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jScrollView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize:= Value;
  if FInitialized then
     jScrollView_setScrollSize(App.Jni.jEnv, App.Jni.jThis,FjObject, FScrollSize);
end;

procedure jScrollView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jScrollView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jScrollView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jScrollView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jScrollView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jScrollView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jPanel_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jPanel.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);

  FjObject:= jPanel_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  FjRLayout{View}:= jPanel_getView(App.Jni.jEnv, App.Jni.jThis, FjObject); // Java : Self Layout

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jPanel_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jPanel_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);

  jPanel_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jPanel_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jPanel_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jPanel_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));

  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);

  FInitialized:= True;
end;

procedure jPanel.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jPanel_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jPanel.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jPanel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));
end;

Procedure jPanel.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jPanel.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if FInitialized then
  begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jPanel_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
  end;
end;

procedure jPanel.setParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if FInitialized then
  begin
    if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
      side:= sdH
    else
      side:= sdW;
    jPanel_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
  end;
end;

function jPanel.GetWidth: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jPanel_getLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject)
end;

function jPanel.GetHeight: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jPanel_getLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jPanel.ResetRules;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
   jPanel_resetLParamsRules(App.Jni.jEnv, App.Jni.jThis, FjObject);
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jPanel_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jPanel_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
   end;
end;

procedure jPanel.UpdateLayout;
begin
  inherited UpdateLayout;
  ResetRules;    //TODO optimize here: if "only rules_changed" then --> ResetRules
  SetParamWidth(FLParamWidth);
  setParamHeight(FLParamHeight);
  jPanel_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jHorizontalScrollView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jHorizontalScrollView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject := jHorizontalScrollView_Create (App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);
  FjRLayout:= jHorizontalScrollView_getView(App.Jni.jEnv, App.Jni.jThis, FjObject); //self layout!

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jHorizontalScrollView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jHorizontalScrollView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jHorizontalScrollView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jHorizontalScrollView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jHorizontalScrollView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jHorizontalScrollView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jHorizontalScrollView_setScrollSize(App.Jni.jEnv, App.Jni.jThis,FjObject, FScrollSize);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jHorizontalScrollView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jHorizontalScrollView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jHorizontalScrollView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jHorizontalScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jHorizontalScrollView.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jHorizontalScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FInitialized then
     jHorizontalScrollView_setScrollSize(App.Jni.jEnv, App.Jni.jThis,FjObject, FScrollSize);
end;

procedure jHorizontalScrollView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jHorizontalScrollView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jHorizontalScrollView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jHorizontalScrollView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jHorizontalScrollView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jHorizontalScrollView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jViewFlipper_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jViewFlipper.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject := jViewFlipper_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jViewFlipper_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jViewFlipper_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jViewFlipper_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jViewFlipper_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jViewFlipper_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jViewFlipper_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jViewFlipper.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jViewFlipper_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jViewFlipper.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jViewFlipper.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jViewFlipper.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jViewFlipper.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jViewFlipper_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jViewFlipper.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jViewFlipper_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jViewFlipper.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jViewFlipper_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jWebView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jWebView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jWebView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jWebView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jWebView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jWebView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jWebView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jWebView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jWebView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  jWebView_SetJavaScript(App.Jni.jEnv, App.Jni.jThis, FjObject, FJavaScript);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jWebView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jWebView_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jWebView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jWebView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;

Procedure jWebView.Refresh;
 begin
  if not FInitialized then Exit;
  jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
 end;

Procedure jWebView.SetJavaScript(Value : Boolean);
begin
  FJavaScript:= Value;
  if FInitialized then
     jWebView_SetJavaScript(App.Jni.jEnv, App.Jni.jThis, FjObject, FJavaScript);
end;

Procedure jWebView.Navigate(url: string);
begin
  if not FInitialized then Exit;
  jWebView_loadURL(App.Jni.jEnv, App.Jni.jThis, FjObject, url);
end;

procedure jWebView.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jWebView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jWebView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jWebView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jWebView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jWebView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
    { TFilePath = (pathApp, pathData, pathExt, pathDCIM); }
  FFilePath:= fpathData;
  //
  FjObject  := nil;
end;

Destructor jBitmap.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jBitmap_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jBitmap.Init(App: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject := jBitmap_Create(App.Jni.jEnv, App.Jni.jThis, Self);
  FInitialized:= True;  //neded here....
  if FImageList <> nil then
  begin
    FImageList.Init(App);
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

       if TryPath(App.Path.App,fileName) then begin path:= App.Path.App; FFilePath:= fpathApp end
       else if TryPath(App.Path.Dat,fileName) then begin path:= App.Path.Dat; FFilePath:= fpathData  end
       else if TryPath(App.Path.DCIM,fileName) then begin path:= App.Path.DCIM; FFilePath:= fpathDCIM end
       else if TryPath(App.Path.Ext,fileName) then begin path:= App.Path.Ext; FFilePath:= fpathExt end;

       if path <> '' then FImageName:= ExtractFileName(fileName)
       else  FImageName:= fileName;

       jBitmap_loadFile(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath)+'/'+FImageName);
       jBitmap_getWH(App.Jni.jEnv, App.Jni.jThis, FjObject,integer(FWidth),integer(FHeight));
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
    jBitmap_createBitmap(App.Jni.jEnv, App.Jni.jThis, FjObject, FWidth, FHeight);
  end;
end;

Function jBitmap.GetJavaBitmap : jObject;
begin
  if FInitialized then
     Result:= jBitmap_getJavaBitmap(App.Jni.jEnv,App.Jni.jThis, FjObject);
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
        jBitmap_loadFile(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageName);
        jBitmap_getWH(App.Jni.jEnv, App.Jni.jThis, FjObject, integer(FWidth),integer(FHeight));
      end;
   end;
end;

procedure jBitmap.SetImageIndex(Value: integer);
begin
  FImageIndex:= Value;
  if FInitialized then SetImageByIndex(Value);
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
     jBitmap_loadFile(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageName);
     jBitmap_getWH(App.Jni.jEnv, App.Jni.jThis, FjObject,integer(FWidth),integer(FHeight));
   end;
end;

procedure jBitmap.SetImageName(Value: string);
begin
  FImageName:= Value;
  if FInitialized then SetImageByName(FImageName);
end;

procedure jBitmap.LockPixels(var PScanDWord : PScanLine);
begin
  if FInitialized then
    AndroidBitmap_lockPixels(App.Jni.jEnv, Self.GetJavaBitmap, @PScanDWord);
end;

procedure jBitmap.LockPixels(var PScanJByte : PScanByte{PJByte});
begin
  if FInitialized then
    AndroidBitmap_lockPixels(App.Jni.jEnv, Self.GetJavaBitmap, @PScanJByte);
end;

procedure jBitmap.UnlockPixels;
begin
  if FInitialized then
     AndroidBitmap_unlockPixels(App.Jni.jEnv, Self.GetJavaBitmap);
end;

function jBitmap.GetInfo: boolean;
var
  rtn: integer;
begin
  Result:= False;
  if FInitialized then
  begin
    rtn:= AndroidBitmap_getInfo(App.Jni.jEnv,Self.GetJavaBitmap,@Self.FBitmapInfo);
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

//------------------------------------------------------------------------------
// jCanvas
//------------------------------------------------------------------------------

constructor jCanvas.Create;
begin
  //Init
  FApp     := nil;
  FjObject := nil;
  FInitialized:= False;
end;

destructor jCanvas.Destroy;
begin
  if App <> nil then
  begin
    if App.Initialized then
    begin
      if FjObject <> nil then
      begin
        jCanvas_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
        FjObject:= nil;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jCanvas.Init(App: jApp);
begin
  if FInitialized  then Exit;
  if App = nil then Exit;
  if not App.Initialized then Exit;
  FApp:= App;
  FjObject:= jCanvas_Create(App.Jni.jEnv, App.Jni.jThis, Self);
  FInitialized:= True;
end;

Procedure jCanvas.SetStrokeWidth(width : single );
begin
  if FInitialized then
     jCanvas_setStrokeWidth(App.Jni.jEnv,App.Jni.jThis,FjObject,width);
end;

Procedure jCanvas.SetStyle(style : integer);
begin
  if FInitialized then
     jCanvas_setStyle(App.Jni.jEnv,App.Jni.jThis,FjObject,style);
end;

Procedure jCanvas.SetColor(color : TARGBColorBridge);
begin
  if FInitialized then
     jCanvas_setColor(App.Jni.jEnv,App.Jni.jThis,FjObject,GetARGB(color));
end;

Procedure jCanvas.SetTextSize(textsize: single);
begin
  if FInitialized then
     jCanvas_setTextSize(App.Jni.jEnv,App.Jni.jThis,FjObject,textsize);
end;

Procedure jCanvas.DrawLine(x1,y1,x2,y2 : single);
begin
  if FInitialized then
     jCanvas_drawLine(App.Jni.jEnv,App.Jni.jThis,FjObject,x1,y1,x2,y2);
end;

Procedure jCanvas.DrawPoint(x1,y1 : single);
begin
  if FInitialized then
     jCanvas_drawPoint(App.Jni.jEnv,App.Jni.jThis,FjObject,x1,y1);
end;

Procedure jCanvas.drawText(Text:string; x,y: single);
begin
  if FInitialized then
     jCanvas_drawText(App.Jni.jEnv,App.Jni.jThis,FjObject,text,x,y);
end;

Procedure jCanvas.drawBitmap(bmp: jBitmap; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap(App.Jni.jEnv,App.Jni.jThis,FjObject,bmp.GetjavaBitmap, b, l, r, t);
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
  FjCanvas := jCanvas.Create; // jCanvas
end;

Destructor jView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jView_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  FjCanvas.Free;
  inherited Destroy;
end;

procedure jView.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjCanvas.Init(App);
  FjObject := jView_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);
  jView_setjCanvas(App.Jni.jEnv, App.Jni.jThis, Self.FjObject, FjCanvas.JavaObj);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jView_setParent(App.Jni.jEnv, App.Jni.jThis,FjObject, FjPRLayout);
  jView_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jView_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jView_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jView_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
  FInitialized:= True;
end;

procedure jView.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jView_setParent(App.Jni.jEnv, App.Jni.jThis,FjObject, FjPRLayout);
end;

Procedure jView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
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
        jView_viewSave(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+str);
     end;
  end;
end;

Procedure jView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
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
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jView_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jView.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if FInitialized then
  begin
    if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
      side:= sdH
    else
      side:= sdW;
    jView_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
  end;
end;

procedure jView.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jView_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
end;

function jView.GetWidth: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jView_getLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject)
end;

function jView.GetHeight: integer;
begin
   Result:= 0;
   if FInitialized then
      Result:= jView_getLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject);
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
  FOnTimer   := nil;
  FParent   := jForm(AOwner);
  FjObject  := nil;
end;

destructor jTimer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jTimer_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jTimer.Init(App: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jTimer_Create(App.Jni.jEnv, App.Jni.jThis, Self);
  jTimer_SetInterval(App.Jni.jEnv, App.Jni.jThis, FjObject, FInterval);
  FInitialized:= True;
end;

Procedure jTimer.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jTimer_SetEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
end;

Procedure jTimer.SetInterval(Value: integer);
begin
  FInterval:= Value;
  if FInitialized then
     jTimer_SetInterval(App.Jni.jEnv, App.Jni.jThis, FjObject, FInterval);
end;

Procedure jTimer.SetOnTimer(Value: TOnNotIFy);
begin
   FOnTimer:= Value;
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jDialogYN_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogYN.Init(App: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jDialogYN_Create(App.Jni.jEnv, App.Jni.jThis, Self, FTitle, FMsg, FYes, FNo);
  FInitialized:= True;
end;

Procedure jDialogYN.Show;
begin
  if FInitialized then
     jDialogYN_Show(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

// Event : Java -> Pascal
Procedure jDialogYN.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if not (Assigned(FOnDialogYN)) then Exit;
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jDialogProgress_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogProgress.Stop;
begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jDialogProgress_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
           FjObject:= nil;
        end;
      end;
    end;
end;

procedure jDialogProgress.Start;
begin
  if (FjObject = nil) and (FInitialized = True) then
     FjObject:= jDialogProgress_Create(App.Jni.jEnv, App.Jni.jThis, Self, FTitle, FMsg);
end;

procedure jDialogProgress.Init(App: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(App);
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
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jImageBtn_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jImageBtn.Init(App: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FjObject:= jImageBtn_Create(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity, Self);

  if FParentPanel <> nil then
  begin
   FParentPanel.Init(App);
   FjPRLayout:= FParentPanel.View;
  end;

  jImageBtn_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
  jImageBtn_setId(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.Id);
  jImageBtn_setLeftTopRightBottomWidthHeight(App.Jni.jEnv, App.Jni.jThis, FjObject,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(App, FLParamWidth, sdW),
                                           GetLayoutParams(App, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageBtn_addlParamsAnchorRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageBtn_addlParamsParentRule(App.Jni.jEnv, App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jImageBtn_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);

  FInitialized:= True;  //neded here....

  if FImageList <> nil then
  begin
    FImageList.Init(App);   //must have!
    if FImageList.Images.Count > 0 then
    begin
       if FImageUpIndex >=0 then SetImageUpByIndex(FImageUpIndex);
       if FImageDownIndex >=0 then SetImageDownByIndex(FImageDownIndex);
    end;
  end;
  jImageBtn_SetEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject,FEnabled);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

procedure jImageBtn.SetParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jImageBtn_setParent(App.Jni.jEnv, App.Jni.jThis, FjObject, FjPRLayout);
end;

Procedure jImageBtn.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(App.Jni.jEnv, App.Jni.jThis, FjObject, FVisible);
end;

Procedure jImageBtn.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjObject, GetARGB(FColor));
end;
 
// LORDMAN 2013-08-16
procedure jImageBtn.SetEnabled(Value : Boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jImageBtn_SetEnabled(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
end;

procedure jImageBtn.Refresh;
begin
  if FInitialized then
     jView_Invalidate(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

Procedure jImageBtn.SetImageDownByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageDownName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageDownName <> '' then
      begin
        jImageBtn_setButtonDown(App.Jni.jEnv, App.Jni.jThis, FjObject, GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageDownName);
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
        jImageBtn_setButtonUp(App.Jni.jEnv, App.Jni.jThis, FjObject,GetFilePath(FFilePath){App.Path.Dat}+'/'+FImageUpName);
      end;
   end;
end;

procedure jImageBtn.SetParamWidth(Value: TLayoutParams);
var
   side: TSide;
begin
   if FInitialized then
   begin
     if jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity) = App.Orientation  then
        side:= sdW
     else
        side:= sdH;
     jImageBtn_setLParamWidth(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamWidth, side));
   end;
end;

procedure jImageBtn.setParamHeight(Value: TLayoutParams);
var
   side: TSide;
begin
  if not FInitialized then  Exit;

  if  jSystem_GetOrientation(App.Jni.jEnv, App.Jni.jThis, App.Jni.jActivity)  = App.Orientation then
    side:= sdH
  else
    side:= sdW;

  jImageBtn_setLParamHeight(App.Jni.jEnv, App.Jni.jThis, FjObject, GetLayoutParams(App, FLParamHeight, side));
end;

procedure jImageBtn.UpdateLayout;
begin
   inherited UpdateLayout;
   SetParamWidth(FLParamWidth);
   setParamHeight(FLParamHeight);
   jImageBtn_setLayoutAll(App.Jni.jEnv, App.Jni.jThis, FjObject, Self.AnchorId);
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
end;

destructor jAsyncTask.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if App <> nil then
    begin
      if App.Initialized then
      begin
        if FjObject <> nil then
        begin
          jAsyncTask_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
          FjObject:= nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jAsyncTask.Init(App: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(App);
  FInitialized:= True;
end;

procedure jAsyncTask.Done;
begin
  if App <> nil then
  begin
    if App.Initialized then
    begin
      if FjObject <> nil then
      begin
        jAsyncTask_Free(App.Jni.jEnv, App.Jni.jThis, FjObject);
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
    FjObject:= jAsyncTask_Create(App.Jni.jEnv, App.Jni.jThis, Self);
    jAsyncTask_Execute(App.Jni.jEnv, App.Jni.jThis, FjObject);
    FRunning:= True;
  end;
end;

Procedure jAsyncTask.UpdateUI(Progress : Integer);
begin
  if FInitialized then
    jAsyncTask_setProgress(App.Jni.jEnv, App.Jni.jThis, FjObject,Progress);
end;

Procedure jAsyncTask.GenEvent_OnAsyncEvent(Obj: TObject;EventType, Progress:Integer);
begin
  If Assigned(FOnAsyncEvent) then FOnAsyncEvent(Obj,EventType,Progress);
end;

//------------------------------------------------------------------------------
// jGLViewEvent
//------------------------------------------------------------------------------
constructor jGLViewEvent.Create;
begin
  FApp         := nil;
  // Clear Event
  FOnGLCreate  := nil;
  FOnGLChange  := nil;
  FOnGLDraw    := nil;
  FOnGLDestroy := nil;
  //
  FOnTouchDown := nil;
  FOnTouchMove := nil;
  FOnTouchUp   := nil;
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
  FOnTouchDown := nil;
  FOnTouchMove := nil;
  FOnTouchUp   := nil;
  //
  inherited Destroy;
end;

procedure jGLViewEvent.Init(App: jApp);
begin
  if FInitialized  then Exit;
  if App = nil then Exit;
  if not App.Initialized then Exit;
  FApp:= App;
  FInitialized:= True;
end;

// Event : Java Event -> Pascal
Procedure jGLViewEvent.GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
begin
  if not FInitialized then Exit;
  App.Lock:= True;
  case Act of
   cTouchDown : VHandler_touchesBegan_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchDown,FMouches);
   cTouchMove : VHandler_touchesMoved_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchMove,FMouches);
   cTouchUp   : VHandler_touchesEnded_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchUp  ,FMouches);
  end;
  App.Lock:= False;
end;

Procedure jGLViewEvent.GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
begin
  if not FInitialized then Exit;
  App.Lock:= True;
  Case EventType of
   cRenderer_onGLCreate  : If Assigned(FOnGLCreate ) then FOnGLCreate (Obj);
   cRenderer_onGLChange  : If Assigned(FOnGLChange ) then FOnGLChange (Obj,w,h);
   cRenderer_onGLDraw    : If Assigned(FOnGLDraw   ) then FOnGLDraw   (Obj);
   cRenderer_onGLDestroy : If Assigned(FOnGLDestroy) then FOnGLDestroy(Obj);
   cRenderer_onGLThread  : If Assigned(FOnGLThread ) then FOnGLThread (Obj);
  end;
  App.Lock:= False;
end;

end.
