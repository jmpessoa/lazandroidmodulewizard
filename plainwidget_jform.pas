unit PlainWidget;

{$mode delphi}

interface

uses
  Classes, SysUtils, Math, types, Graphics, And_jni, And_jni_Bridge, CustApp;

const

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

TActivityMode = (actMain, actRecyclable, actDisposable, actSplash);

//
jForm      = class; // Forward Declaration

//
TOnNotify          = Procedure(Sender: TObject) of object;
TOnClickEx         = Procedure(Sender: TObject; Value: integer) of object;
TOnChange          = Procedure(Sender: TObject; EventType : TChangeType) of object;

TOnTouch           = Procedure(Sender: TObject; ID: integer; X, Y: single) of object;
TOnTouchEvent      = Procedure(Sender: TObject; Touch : TMouch ) of Object;
TOnCloseQuery      = Procedure(Sender: TObject; var CanClose: boolean) of object;

TOnRotate          = Procedure(Sender: TObject; rotate : integer; Var rstRotate : integer) of Object;

TOnOptionMenuItemCreate=  Procedure(Sender: TObject; jObjMenu: jObject) of Object;
TOnClickOptionMenuItem = Procedure(Sender: TObject; jObjMenuItem: jObject;
                                   itemID: integer; itemCaption: string; checked: boolean) of Object;

TOnContextMenuItemCreate=  Procedure(Sender: TObject; jObjMenu: jObject) of Object;
TOnClickContextMenuItem = Procedure(Sender: TObject; jObjMenuItem: jObject;
                                   itemID: integer; itemCaption: string; checked: boolean) of Object;

TOnActivityRst     = Procedure(Sender: TObject; requestCode,resultCode : Integer; jData : jObject) of Object;
TOnGLChange        = Procedure(Sender: TObject; W, H: integer) of object;

TOnClickYN         = Procedure(Sender: TObject; YN  : TClickYN) of object;
TOnClickItem       = Procedure(Sender: TObject; Item: Integer) of object;

TOnClickWidgetItem = Procedure(Sender: TObject; Item: integer; checked: boolean) of object;
TOnClickCaptionItem= Procedure(Sender: TObject; Item: integer; caption: string) of object;


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


//by jmpessoa
TEnvPath    = record
               App         : string;    // /data/app/com.kredix-1.apk
               Dat         : string;    // /data/data/com.kredix/files
               Ext         : string;    // /storage/emulated/0
               DCIM        : string;    // /storage/emulated/0/DCIM
               DataBase    : string;
end;
{
 The folder "Digital Camera Image"-DCIM- store photographs from digital camera
}


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
  

  { jForm }

  jForm = class(TPlainForm)
  private
    // Java
    FjObject       : jObject;      // Java : Java Object
    FjRLayout{View}: jObject;      // Java Relative Layout View
    FOrientation   : integer;
    FApp           : jApp;
    FScreenWH      : TWH;
    FScreenStyle   : TScreenStyle;
    FAnimation     : TAnimation;

    FColor         : TARGBColorBridge;        // Background Color

    FCloseCallback : TjCallBack;   // Close Call Back Event

    FActivityMode  : TActivityMode;

    FOnClick      : TOnNotify;
    FOnActive     : TOnNotify;
    FOnClose      :   TOnNotify;
    FOnCloseQuery  : TOnCloseQuery;
    FOnRotate      : TOnRotate;

    FOnActivityRst : TOnActivityRst;
    FOnJNIPrompt   : TOnNotify;
    FOnBackButton  : TOnNotify;

    FOnOptionMenuCreate: TOnOptionMenuItemCreate;
    FOnClickOptionMenuItem: TOnClickOptionMenuItem;
    FOnContextMenuCreate: TOnContextMenuItemCreate;
    FOnClickContextMenuItem: TOnClickContextMenuItem;

    Procedure SetColor   (Value : TARGBColorBridge);
    function GetView: jObject;

  protected
    Procedure SetVisible (Value : Boolean); override;
    Procedure SetEnabled (Value : Boolean); override;
  public
    FormState     : TjFormState;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetOrientation(Value: integer);
    Procedure GenEvent_OnClick(Obj: TObject);

    //Warning: An inherited method is hidden by "procedure Init(jApp);"
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
    property Orientation   : integer read FOrientation write SetOrientation;
    property App: jApp read FApp write FApp;
  published

    property ActivityMode  : TActivityMode read FActivityMode write FActivityMode;
    //property Title: string  read FFormName write FFormName;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;
    // Event
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityRst: TOnActivityRst read FOnActivityRst write FOnActivityRst;
    property OnJNIPrompt  : TOnNotify read FOnJNIPrompt write FOnJNIPrompt;
    property OnBackButton : TOnNotify read FOnBackButton write FOnBackButton;
    property OnActive     : TOnNotify read FOnActive write FOnActive;
    property OnClose      : TOnNotify read FOnClose write FOnClose;
    property OnCreateOptionMenu: TOnOptionMenuItemCreate read FOnOptionMenuCreate write FOnOptionMenuCreate;
    property OnClickOptionMenuItem: TOnClickOptionMenuItem read FOnClickOptionMenuItem write FOnClickOptionMenuItem;
    property OnCreateContextMenu: TOnContextMenuItemCreate read FOnContextMenuCreate write FOnContextMenuCreate;
    property OnClickContextMenuItem: TOnClickContextMenuItem read FOnClickContextMenuItem write FOnClickContextMenuItem;

  end;

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

    // Form Event
  Procedure Java_Event_pOnClose                  (env: PJNIEnv; this: jobject; Form : TObject);

  //new by jmpessoa - form Active - after form show....
  Procedure Java_Event_pOnActive                  (env: PJNIEnv; this: jobject; Form : TObject);


var
  gApp: jApp; //global App !

implementation


{ jForm }

constructor jForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize
  FVisible              := False;
  FEnabled              := True;
  FColor                := colbrBlack;
  //FFormName             := 'jForm';
  FormState             := fsFormCreate;
  FCloseCallBack.Event  := nil;
  FCloseCallBack.Sender := nil;
 // FMainActivity          := True;
  FActivityMode          := actMain;  //actMain, actRecyclable, actDisposable

  FOnActive             := nil;
  FOnCloseQuery         := nil;
  FOnClose              := nil;
  FOnRotate             := nil;
  //FOnClick              := nil;
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

  FjObject:=  jForm_Create(App.Jni.jEnv, App.Jni.jThis, Self); {jSef}

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
         {
          if (Self.Components[i] as jImageView).IsBackgroundImage = True then
          begin
             bkImgIndex:= i;
            (Self.Components[i] as jControl).Init; //init just background image
          end;
          }
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

Procedure jForm.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  if FInitialized then
  begin
    UpdateJNI(gApp);
    jForm_SetEnabled2(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
  end;
end;

Procedure jForm.SetVisible(Value: Boolean);
begin
 inherited SetVisible(Value);
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

  {jApp}

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

end.

