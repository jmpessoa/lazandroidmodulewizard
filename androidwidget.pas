unit AndroidWidget;   //by jmpessoa

{$mode delphi}

{$SMARTLINK ON}

interface

uses
  Classes, SysUtils, Math, types, And_jni, CustApp;

const

  cjFormsMax = 40; // Max Form Stack Count

    //by jmpessoa
  TFPColorBridgeArray: array[0..143] of longint = (
    $000000,$98FB98,$9932CC,$9ACD32,$A0522D,
    $A52A2A,$A9A9A9,$ADD8E6,$ADFF2F,$AFEEEE,
    $B0C4DE,$B0E0E6,$B22222,$B8860B,$BA55D3,
    $BC8F8F,$BDB76B,$C0C0C0,$000080,$C71585,
    $CD5C5C,$CD853F,$D02090,$D19275,$D2691E,
    $D2B48C,$D3D3D3,$00008B,$D87093,$D8BFD8,
    $DA70D6,$DAA520,$DC143C,$DCDCDC,$DDA0DD,
    $DEB887,$E0FFFF,$E6E6FA,$E9967A,$EE82EE,
    $EEE8AA,$F08080,$F0E68C,$F0F8FF,$F0FFF0,
    $F0FFFF,$F4A460,$F5DEB3,$F5F5DC,$F5F5F5,
    $F5FFFA,$F8F8FF,$FA8072,$FAEBD7,$FAF0E6,
    $FAFAD2,$191970,$FDF5E6,$FF0000,$FF00FF,
    $FF00FF,$FF1493,$FF4500,$FF6347,$FF69B4,
    $FF7F50,$FF8C00,$FFA07A,$FFA500,$FFB6C1,
    $FFC0CB,$FFD700,$FFDAB9,$FFDEAD,$FFE4B5,
    $FFE4C4,$FFE4E1,$FFEBCD,$FFEFD5,$FFF0F5,
    $FFF5EE,$FFF8DC,$FFFACD,$FFFAF0,$FFFAFA,
    $FFFF00,$FFFFE0,$FFFFF0,$FFFFFF,$1E90FF,
    $0000CD,$20B2AA,$228B22,$0000FF,$006400,
    $2E8B57,$2F4F4F,$008000,$008080,$32CD32,
    $008B8B,$3CB371,$40E0D0,$4169E1,$4682B4,
    $483D8B,$48D1CC,$00BFFF,$4B0082,$00CED1,
    $556B2F,$5F9EA0,$00FA9A,$00FF00,$00FF7F,
    $00FFFF,$00FFFF,$6495ED,$66CDAA,$696969,
    $6A5ACD,$6B8E23,$708090,$778899,$7B68EE,
    $7CFC00,$7FFF00,$7FFFD4,$800000,$800080,
    $808000,$808080,$8470FF,$87CEEB,$87CEFA,
    $8A2BE2,$8B0000,$8B008B,$8B4513,$8FBC8F,
    $90EE90,$9370D8,$9400D3, $000000); //colbrDefault

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
  //
  cjOpenGLESv1                           =  1;
  cjOpenGLESv2                           =  2;
  //
  cjMouchMax                             =  10; // Max Touch


type

  // thierrydijoux - locale type def
 TLocaleType = (ltCountry = 0, ltDisplayCountry = 1, ltDisplayLanguage = 2,
                ltDisplayName = 3, ltDisplayVariant = 4, ltIso3Country = 5,
                ltIso3Language = 6, ltVariant = 7);


  TWH = Record
        Width : Integer;
        Height: Integer;
       End;

  TMenuItemShowAsAction = (misNever,
                        misIfRoom,
                        misAlways,
                        misNone,    //dummy
                        misIfRoomWithText,
                        misAlwaysWithText);

  TMenuItemType = (mitDefault, mitCheckable);

  TColorRGB=packed record {copy from  ...\fcl-image\src\BMPcomn.pp}
     B,G,R:Byte;
  end;

  TColorRGBA=packed record  {copy from  ...\fcl-image\src\BMPcomn.pp}
  case Boolean of
      False:(B,G,R,A:Byte);
      True:(RGB:TColorRGB);
  end;

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
  colbrLightGreen,colbrMediumPurple,colbrDarkViolet,colbrNone, colbrDefault);  //default=transparent!

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

  TLanguage      = (tPascal, tJava);

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
                   lpOneFifthOfParent, lpTwoFifthOfParent, lpThreeFifthOfParent, lpThreeQuarterOfParent,
                   lpFourFifthOfParent,lp16px, lp24px, lp32px, lp40px, lp48px, lp72px, lp96px);

  TSide = (sdW, sdH);

  TScreenStyle   = (ssSensor,       // by Device Status
                    ssPortrait,     // Force Portrait
                    ssLandScape);   // Force LandScape

  TWebViewStatus = (wvOnUnknown,    // WebView
                    wvOnBefore,
                    wvOnFinish,
                    wvOnError);

       //dirDocuments,  //only for API >= 19!!!!
   TEnvDirectory = (dirDownloads,
                    dirDCIM,
                    dirMusic,
                    dirPictures,
                    dirNotifications,
                    dirMovies,
                    dirPodcasts,
                    dirRingtones,
                    dirSdCard,
                    dirInternalAppStorage,
                    dirDatabase,
                    dirSharedPrefs);

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

  TActivityMode = (actMain, actRecyclable, actSplash); //actDisposable

  TTextTypeFace = (tfNormal, tfBold, tfItalic, tfBoldItalic); //by jmpessoa

  //...

  TOnNotify = Procedure(Sender: TObject) of object;

  TViewClick = Procedure(jObjView: jObject; Id: integer) of object;
  TListItemClick = Procedure(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer) of object;

  TOnCallBackData = Procedure(Sender: TObject; strData: string; intData: integer; doubleData: double) of object;

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

  TActionBarTabSelected = Procedure(Sender: TObject; view: jObject; title: string) of Object;
  TCustomDialogShow = Procedure(Sender: TObject; dialog: jObject; title: string) of Object;

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
                 jEnv        : PJNIEnv;  // a pointer reference to the JNI environment,
                 jThis       : jObject;  // a reference to the object making this call (or class if static).
                 jActivity   : jObject;  // Java Activity / android.content.Context -
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
  //The folder "Digital Camera Image"-DCIM- store photographs from digital camera


  //by jmpessoa
  TFilePath = (fpathNone, fpathApp, fpathData, fpathExt, fpathDCIM, fpathDataBase);


  TjCallBack =  record
                 Event       : TOnNotify;
                 EventData   : TOnCallBackData;
                 Sender      : TObject;
                end;

  TEnvScreen =  record
                  Style       : TScreenStyle;
                  WH          : TWH;
                end;

  TEnvDevice =  record
                 PhoneNumber : string;
                 ID          : string;
                end;

  //by thierrydijoux
  TLocale =     record
                 Country         : string;
                 DisplayCountry  : string;
                 DisplayLanguage : string;
                 DisplayName     : string;
                 DisplayVariant  : string;
                 Iso3Country     : string;
                 Iso3Language    : string;
                 Variant         : string;
                end;


  jForm      = class; // Forward Declaration

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

    Locale        : TLocale;    //by thierrydijoux

    ControlsVersionInfo: string; //by jmpessoa


    TopIndex: integer;
    BaseIndex: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; out Reference);
    procedure Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject);

    procedure Finish;
    function  GetContext: jObject;

    function GetControlsVersionInfo: string;
    function GetControlsVersionFeatures: string; //sorry!

    //thanks to  thierrydijoux
    function GetStringResourceId(_resName: string): integer;
    function GetStringResourceById(_resId: integer): string;

    //by thierrydijoux - get a resource string by name
    function GetStringResourceByName(_resName: string): string;
    function GetQuantityStringByName(_resName: string; _Quantity: integer): string;

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

 {jControl by jmpessoa}

  jControl = class(TComponent)
  protected
    FApplication: jApp;
    FjClass: jObject;
    FClassPath: string;
    FjObject      : jObject; //jSelf
    FEnabled     : boolean;
    FInitialized : boolean;
    procedure SetEnabled(Value: boolean);
  public
    property Enabled     : boolean read FEnabled  write SetEnabled;
    property Initialized : boolean read FInitialized write FInitialized;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); virtual;

    property jSelf: jObject read FjObject ;
  end;


  TAndroidWidget = class(jControl)
  private

    FLeft: integer;
    FTop: integer;

    FChilds: TFPList; // list of TAndroidWidget

    function GetChilds(Index: integer): TAndroidWidget;

    procedure SetMarginBottom(const AValue: integer);
    procedure SetMarginLeft(const AValue: integer);
    procedure SetMarginRight(const AValue: integer);
    procedure SetMarginTop(const AValue: integer);

    procedure SetLeft(const AValue: integer);
    procedure SetTop(const AValue: integer);

  {
    procedure ReadIntHeightData(Reader: TReader);
    procedure ReadIntWidthData(Reader: TReader);
    procedure WriteIntHeightData(Writer: TWriter);
    procedure WriteIntWidthData(Writer: TWriter);
   }

  protected
    FColor       : TARGBColorBridge; //background ... needed by design...
    FFontColor   : TARGBColorBridge;  //needed by design...
    FParent: TAndroidWidget;
    FText: string;
    FMarginBottom: integer;
    FMarginLeft: integer;
    FMarginRight: integer;
    FMarginTop: integer;

    FHeight: integer;
    FWidth: integer;

    FVisible: boolean;

    FAcceptChildrenAtDesignTime: boolean;

    procedure SetParent(const AValue: TAndroidWidget);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure InternalInvalidateRect({%H-}ARect: TRect; {%H-}Erase: boolean); virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;

    procedure SetText(Value: string); virtual;
    function GetText: string; virtual;

    procedure SetWidth(const AValue: integer);
    procedure SetHeight(const AValue: integer);

    function GetWidth: integer;  virtual;
    function GetHeight: integer; virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;

    function ChildCount: integer;
    property Children[Index: integer]: TAndroidWidget read GetChilds;
    function HasParent: Boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer); virtual;
    procedure InvalidateRect(ARect: TRect; Erase: boolean);
    procedure Invalidate;

    property  AcceptChildrenAtDesignTime:boolean read FAcceptChildrenAtDesignTime;
    property Parent: TAndroidWidget read FParent write SetParent;
    property Visible: boolean read FVisible write FVisible;

  published
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;

    property MarginLeft: integer read FMarginLeft write SetMarginLeft default 3;
    property MarginTop: integer read FMarginTop write SetMarginTop default 3;
    property MarginRight: integer read FMarginRight write SetMarginRight default 3;
    property MarginBottom: integer read FMarginBottom write SetMarginBottom default 3;

    property Text: string read GetText write SetText;  //not here!
  end;

  IAndroidWidgetDesigner = interface(IUnknown)
     procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
  end;

  TAndroidWidgetClass = class of TAndroidWidget;

  { TAndroidForm }

  TAndroidForm = class(TAndroidWidget)
  private
    FDesigner: IAndroidWidgetDesigner;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
  protected
    procedure InternalInvalidateRect(ARect: TRect; Erase: boolean); override;
  public
    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(refApp: jApp); override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Designer: IAndroidWidgetDesigner read FDesigner write FDesigner;
  published
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  { jForm }

  jForm = class(TAndroidForm)
  private
    FCBDataString: string;
    FCBDataInteger: integer;
    FCBDataDouble: double;

    FjRLayout{View}: jObject;      // Java Relative Layout View

    FOnViewClick      : TViewClick;
    FOnListItemClick  : TListItemClick;

    FOrientation   : integer;

    FScreenWH      : TWH;
    FScreenStyle   : TScreenStyle;
    FAnimation     : TAnimation;

    FActivityMode  : TActivityMode;
    FOnClick      : TOnNotify;
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

    //---------------  dummies for compatibility----
   {  FHorizontalOffset: integer;
     FVerticalOffset: integer;
     FOldCreateOrder: boolean;
     FTitle: string;}
    //---------------

    Procedure SetColor   (Value : TARGBColorBridge);
    function GetView: jObject;

    {
    procedure ReadIntHorizontalOffset(Reader: TReader);
    procedure WriteIntHorizontalOffset(Writer: TWriter);
    procedure ReadIntVerticalOffset(Reader: TReader);
    procedure WriteIntVerticalOffset(Writer: TWriter);
    procedure ReadBolOldCreateOrder(Reader: TReader);
    procedure WriteBolOldCreateOrder(Writer: TWriter);
    procedure ReadStrTitle(Reader: TReader);
    procedure WriteStrTitle(Writer: TWriter);
    }

  protected
    //procedure DefineProperties(Filer: TFiler); override;
    FCloseCallback : TjCallBack;   // Close Call Back Event

    Procedure SetVisible (Value : Boolean);
    Procedure SetEnabled (Value : Boolean);

    function  GetOnViewClickListener(jObjForm: jObject): jObject;
    function  GetOnListItemClickListener(jObjForm: jObject): jObject;

  public
    FormState     : TjFormState;
    FormIndex: integer;

    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetOrientation(Value: integer);
    Procedure GenEvent_OnClick(Obj: TObject);

    procedure Init(refApp: jApp); override;
    procedure Finish;
    Procedure Show;
    Procedure Close;
    Procedure Refresh;
    procedure UpdateJNI(refApp: jApp);
    procedure ShowMessage(msg: string);
    function GetDateTime: String;

    function GetStringExtra(data: jObject; extraName: string): string;
    function GetIntExtra(data: jObject; extraName: string; defaultValue: integer): integer;
    function GetDoubleExtra(data: jObject; extraName: string; defaultValue: double): double;

    Procedure SetCloseCallBack(Func : TOnNotify; Sender : TObject);  overload;
    Procedure SetCloseCallBack(Func : TOnCallBackData; Sender : TObject); overload; //by jmpessoa

    Procedure GenEvent_OnViewClick(jObjView: jObject; Id: integer);
    Procedure GenEvent_OnListItemClick(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer);

    //by jmpessoa
    Procedure UpdateLayout;

    procedure SetWifiEnabled(_status: boolean);
    function IsWifiEnabled(): boolean;

    function GetEnvironmentDirectoryPath(_directory: TEnvDirectory): string;
    function GetInternalAppStoragePath: string;
    function CopyFile(srcFullFilename: string; destFullFilename: string): boolean;
    function LoadFromAssets(fileName: string): string;
    function IsSdCardMounted: boolean;

    procedure DeleteFile(_filename: string);  overload; //mode delphi!
    procedure DeleteFile(_fullPath: string; _filename: string); overload; //mode delphi!
    procedure DeleteFile(_environmentDir: TEnvDirectory; _filename: string); overload; //mode delphi!
    function CreateDir(_dirName: string): string;  overload; //mode delphi!
    function CreateDir(_environmentDir: TEnvDirectory; _dirName: string): string;  overload; //mode delphi!
    function CreateDir(_fullPath: string; _dirName: string): string; overload; //mode delphi!
    function IsExternalStorageEmulated(): boolean;  //API level 11
    function IsExternalStorageRemovable(): boolean; //API level 9

    function GetjFormVersionFeatures(): string;

    //Action bar was introduced in Android 3.0 (API level 11)
    function GetActionBar(): jObject;    //Set targetSdkVersion to >= 14, then test your app on Android 4.0.
    procedure HideActionBar();
    procedure ShowActionBar();
    procedure ShowTitleActionBar(_value: boolean);
    procedure HideLogoActionBar(_value: boolean);
    procedure SetTitleActionBar(_title: string);
    procedure SetSubTitleActionBar(_subtitle: string);

    procedure SetIconActionBar(_iconIdentifier: string);
    procedure SetTabNavigationModeActionBar;
    procedure RemoveAllTabsActionBar();

    function GetStringResourceId(_resName: string): integer;
    function GetStringResourceById(_resID: integer): string;
    function GetDrawableResourceId(_resName: string): integer;
    function GetDrawableResourceById(_resID: integer): jObject;
    function GetQuantityStringByName(_resName: string; _quantity: integer): string;
    function GetStringResourceByName(_resName: string): string;

    // Property
    property View         : jObject        read FjRLayout {GetView } write FjRLayout;
    property ScreenStyle  : TScreenStyle   read FScreenStyle    write FScreenStyle;
    property Animation    : TAnimation     read FAnimation      write FAnimation;
    property Orientation   : integer read FOrientation write SetOrientation;
    property App: jApp read FApplication write FApplication;
    property ScreenWH      : TWH read FScreenWH;

    property CallBackDataString: string read FCBDataString write FCBDataString;
    property CallBackDataInteger: integer read FCBDataInteger write FCBDataInteger;
    property CallBackDataDouble: double read FCBDataDouble write FCBDataDouble;

    property  OnViewClick: TViewClick read FOnViewClick write FOnViewClick;
    property  OnListItemClick: TListItemClick read FOnListItemClick write FOnListItemClick;

    //---------------  dummies for compatibility----
    {
    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
    property Title: string read FTitle write FTitle;
    property HorizontalOffset: integer read FHorizontalOffset write FHorizontalOffset;
    property VerticalOffset: integer read FVerticalOffset write FVerticalOffset;
    }
    //--------------------
  published

    property ActivityMode  : TActivityMode read FActivityMode write FActivityMode;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;

    // Event
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityRst: TOnActivityRst read FOnActivityRst write FOnActivityRst;

    property OnJNIPrompt  : TOnNotify read FOnJNIPrompt write FOnJNIPrompt;
    property OnBackButton : TOnNotify read FOnBackButton write FOnBackButton;
    property OnClose      : TOnNotify read FOnClose write FOnClose;

    property OnCreateOptionMenu: TOnOptionMenuItemCreate read FOnOptionMenuCreate write FOnOptionMenuCreate;
    property OnClickOptionMenuItem: TOnClickOptionMenuItem read FOnClickOptionMenuItem write FOnClickOptionMenuItem;

    property OnCreateContextMenu: TOnContextMenuItemCreate read FOnContextMenuCreate write FOnContextMenuCreate;
    property OnClickContextMenuItem: TOnClickContextMenuItem read FOnClickContextMenuItem write FOnClickContextMenuItem;

  end;


    {jVisualControl - NEW by jmpessoa}

  jVisualControl = class(TAndroidWidget)
  private

    procedure ReadIntId(Reader: TReader);
    procedure WriteIntId(Writer: TWriter);
    {
    procedure ReadIntOrdLParamWidth(Reader: TReader);
    procedure WriteIntOrdLParamWidth(Writer: TWriter);
    procedure ReadIntOrdLParamHeight(Reader: TReader);
    procedure WriteIntOrdLParamHeight(Writer: TWriter);
     }
  protected
    // Java
    FId: DWord;

    FjPRLayout   : jObject; //Java: Parent Layout {parent View)
    FjRLayout: jObject; // Java : Self Layout  {Self.View}

    FOrientation : integer;
    FTextAlignment: TTextAlignment;
    FFontSize     : DWord;
    FTextTypeFace: TTextTypeFace;

    FAnchorId     : integer;
    FAnchor       : jVisualControl;  //http://www.semurjengkol.com/android-relative-layout-example/

    FPositionRelativeToAnchor: TPositionRelativeToAnchorIDSet;
    FPositionRelativeToParent: TPositionRelativeToParentSet;

    //FGravity      : TGravitySet;    TODO: by jmpessoa  - java "setGravity"
    FLParamWidth: TLayoutParams;
    FLParamHeight: TLayoutParams;

    FOnClick: TOnNotify;
    procedure SetAnchor(Value: jVisualControl);
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetViewParent(Value: jObject);  virtual;
    function GetViewParent: jObject;  virtual;


    procedure SetView(Value: jObject);  virtual;
    function GetView: jObject;  virtual;


    procedure SetParentComponent(Value: TComponent); override;
    procedure SetParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    procedure SetTextTypeFace(Value: TTextTypeFace); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //procedure Init;  override;
    procedure Init(refApp: jApp); override;

    procedure UpdateLayout; virtual;
    property AnchorId: integer read FAnchorId write FAnchorId;
    property Orientation: integer read FOrientation write FOrientation;

    property ViewParent {ViewParent}: jObject  read  GetViewParent write SetViewParent; // Java : Parent Relative Layout

    property View: jObject read GetView write SetView; // Java : Self View/Layout

    property Id: DWord read FId write FId;                        //Must be published for data persistence!!!
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
  published
    property Visible: boolean read FVisible write FVisible;
    property Anchor  : jVisualControl read FAnchor write SetAnchor;
    //property Gravity      : TGravitySet read FGravity write FGravity;   TODO: by jmpessoa
    property PosRelativeToAnchor: TPositionRelativeToAnchorIDSet read FPositionRelativeToAnchor
                                                                       write FPositionRelativeToAnchor;
    property PosRelativeToParent: TPositionRelativeToParentSet read FPositionRelativeToParent
                                                                 write FPositionRelativeToParent;
    property LayoutParamWidth: TLayoutParams read FLParamWidth write SetParamWidth;
    property LayoutParamHeight: TLayoutParams read FLParamHeight write SetParamHeight;
end;


  //by jmpessoa
  Function InputTypeToStrEx ( InputType : TInputTypeEx ) : String;
  function SplitStr(var theString: string; delimiter: string): string;
  function ReplaceChar(query: string; oldchar, newchar: char):string;

  function GetARGB(colbrColor: TARGBColorBridge): DWord;


  function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle ): DWord;

  //function GetInputTypeEx(itxType: TInputTypeEx): DWord;

  function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle ): integer;
  function GetPositionRelativeToAnchor(posRelativeToAnchorID: TPositionRelativeToAnchorID): DWord;
  function GetPositionRelativeToParent(posRelativeToParent: TPositionRelativeToParent): DWord;

  function GetLayoutParams(App: jApp; lpParam: TLayoutParams;  side: TSide): DWord;
  function GetLayoutParamsByParent(paren: TAndroidWidget; lpParam: TLayoutParams;  side: TSide): DWord;

  function GetLayoutParamsOrd(lpParam: TLayoutParams): DWord;
  function GetLayoutParamsName(ordIndex: DWord): TLayoutParams;

  function GetDesignerLayoutParams(lpParam: TLayoutParams; L: integer): DWord;
  function GetDesignerLayoutByWH(Value: DWord; L: integer): TLayoutParams;

  function GetParamBySide(App: jApp; side: TSide): DWord;
  function GetParamByParentSide(paren: TAndroidWidget; side: TSide): DWord;

  function GetFilePath(filePath: TFilePath): string;

  function GetGravity(gvValue: TGravity): DWord;  //TODO

  //Form Event
  Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject; Form : TObject);

  function jForm_GetStringExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string): string;
  function jForm_GetIntExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string; defaultValue: integer): integer;
  function jForm_GetDoubleExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string; defaultValue: double): double;

  procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _filename: string); overload;
  procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _fullPath: string; _filename: string);  overload;
  procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _environmentDir: integer; _filename: string);  overload;
  function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _dirName: string): string;  overload;
  function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _environmentDir: integer; _dirName: string): string;  overload;
  function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _fullPath: string; _dirName: string): string;  overload;
  function jForm_IsExternalStorageEmulated(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
  function jForm_IsExternalStorageRemovable(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
  function jForm_GetjFormVersionFeatures(env: PJNIEnv; this: JObject; _jform: JObject): string;

  function jForm_GetActionBar(env: PJNIEnv; this: JObject; _jform: JObject): jObject;
  procedure jForm_HideActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
  procedure jForm_ShowActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
  procedure jForm_ShowTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _value: boolean);
  procedure jForm_HideLogoActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _value: boolean);
  procedure jForm_SetTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _title: string);
  procedure jForm_SetSubTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _subtitle: string);

  procedure jForm_SetIconActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _iconIdentifier: string);

  procedure jForm_SetTabNavigationModeActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
  procedure jForm_RemoveAllTabsActionBar(env: PJNIEnv; this: JObject; _jform: JObject);

  function jForm_GetStringResourceId(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): integer;

  function jForm_GetStringResourceById(env: PJNIEnv; this: JObject; _jform: JObject; _resID: integer): string;
  function jForm_GetDrawableResourceId(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): integer;
  function jForm_GetDrawableResourceById(env: PJNIEnv; this: JObject; _jform: JObject; _resID: integer): jObject;
  function jForm_GetQuantityStringByName(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string; _quantity: integer): string;
  function jForm_GetStringResourceByName(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): string;


//jni API Bridge

// http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html

function Get_jClassLocalRef(fullClassName: string): jClass;
function Get_jObjectArrayElement(jobjectArray: jObject; index: integer): jObject;
procedure Set_jObjectArrayElement(jobjectArray: jObject; index: integer; element: jObject);
function Create_jObjectArray(Len: integer; cls: jClass; initialElement: jObject): jObject;
function Get_jArrayLength(jobjectArray: jObject): integer;
function  Is_jInstanceOf(jObj:JObject; cls:JClass): boolean;
function Get_jObjectClass(jObj: jObject): jClass;

function Get_jObjGlobalRef(jObj: jObject): jObject;
function Create_jObjectLocalRef(cls: JClass): JObject;
function Create_jObjectLocalRefA(cls: JClass;
                        paramFullSignature: string; paramValues: array of jValue): JObject;
function Get_jMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
function Get_jStaticMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
function Call_jIntMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): integer;
function Call_jIntMethod(jObj:jObject; method: jMethodID): integer;
function Call_jDoubleMethod(jObj:jObject; method: jMethodID): double;
function Call_jDoubleMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): double;
procedure Call_jVoidMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue);
procedure Call_jVoidMethod(jObj:jObject; method: jMethodID);

function Call_jBooleanMethod(jObj:jObject; method: jMethodID): boolean;
function Call_jBooleanMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue): boolean;
procedure Delete_jLocalRef(jObj: jObject);
procedure Delete_jLocalParamRef(var jParams: array of jValue; index: integer);
procedure Delete_jGlobalRef(jObj: jObject);
function Get_jString(str: string): jObject;
function Get_pString(jStr: jObject): string;
function Call_jStaticIntMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue): integer;
function Call_jStaticIntMethod(fullClassName: string; funcName: string; funcSignature: string): integer;
function Call_jStaticDoubleMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue): double;
function Call_jStaticDoubleMethod(fullClassName: string; funcName: string; funcSignature: string): double;
function Call_jObjectMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): jObject;
function Call_jObjectMethod(jObj:jObject; method: jMethodID): jObject;
function Call_jCallStaticBooleanMethod(fullClassName: string;
                       funcName: string; funcSignature: string): boolean;
function Call_jCallStaticBooleanMethodA(fullClassName: string;
                       funcName: string; funcSignature: string; var jParams: array of jValue): boolean;
procedure Call_jCallStaticVoidMethod(fullClassName: string; funcName: string; funcSignature: string);
procedure Call_jCallStaticVoidMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue);

//------------------------------------------------------------------------------
// App - Main Activity
//------------------------------------------------------------------------------

//Please, use jForm_getDateTime...
Function jApp_GetControlsVersionFeatures          (env:PJNIEnv;this:jobject): String;

Procedure jApp_Finish                  (env:PJNIEnv;this:jobject);

//by jmpessoa
Procedure jApp_Finish2                  (env:PJNIEnv;this:jobject);
function  jApp_GetContext               (env:PJNIEnv;this:jobject): jObject;
function jApp_GetControlsVersionInfo(env:PJNIEnv;this:jobject): string;

function  jForm_GetOnViewClickListener        (env:PJNIEnv; this:jobject; Form: jObject): jObject;
function  jForm_GetOnListItemClickListener    (env:PJNIEnv; this:jobject; Form: jObject): jObject;

Procedure jApp_KillProcess             (env:PJNIEnv;this:jobject);
Procedure jApp_ScreenStyle             (env:PJNIEnv;this:jobject; screenstyle : integer);

//by jmpessoa
procedure jApp_GetJNIEnv(var env: PJNIEnv);

function  jApp_GetStringResourceId(env:PJNIEnv;this:jobject; _resName: string): integer;
function  jApp_GetStringResourceById(env:PJNIEnv;this:jobject; _resId: integer ): string;

// thierrydijoux - get a resource quantity string by name
function  jApp_GetStringResourceByName(env:PJNIEnv;this:jobject; _resName: string): string;
function  jApp_GetQuantityStringByName(env:PJNIEnv;this:jobject; _resName: string; _Quantity: integer): string;

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

Function  jForm_Create                 (env:PJNIEnv;this:jobject; SelfObj : TObject) : jObject;

Procedure jForm_Free                   (env:PJNIEnv;this:jobject; Form    : jObject);

//by jmpessoa
Procedure jForm_Free2                   (env:PJNIEnv;this:jobject; Form    : jObject);

Procedure jForm_Show                   (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);

Procedure jForm_Show2                   (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);

Procedure jForm_Close                  (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);

//by jmpessoa
Procedure jForm_Close2                  (env:PJNIEnv; this:jobject; Form: jObject);

Function  jForm_GetLayout              (env:PJNIEnv;this:jobject; Form    : jObject) : jObject;

//by jmpessoa
Function  jForm_GetLayout2              (env:PJNIEnv;this:jobject; Form    : jObject) : jObject;

Function jForm_GetClickListener(env:PJNIEnv; this:jobject; Form: jObject): jObject;

//by jmpessoa
Procedure jForm_FreeLayout              (env:PJNIEnv;this:jobject; Layout    : jObject);

Procedure jForm_SetVisibility          (env:PJNIEnv;this:jobject; Form    : jObject; visible : boolean);

//by jmpessoa
Procedure jForm_SetVisibility2          (env:PJNIEnv;this:jobject; Form    : jObject; visible : boolean);

Procedure jForm_SetEnabled             (env:PJNIEnv;this:jobject; Form    : jObject; enabled : Boolean);

//by jmpessoa
Procedure jForm_SetEnabled2             (env:PJNIEnv;this:jobject; Form    : jObject; enabled : Boolean);

//by jmpessoa
procedure jForm_ShowMessage(env:PJNIEnv; this:jobject; Form:jObject; msg: string);
function jForm_GetDateTime(env:PJNIEnv; this:jobject; Form:jObject): string;

procedure jForm_SetWifiEnabled(env: PJNIEnv; this: JObject; _jform: JObject; _status: boolean);
function jForm_IsWifiEnabled              (env: PJNIEnv; this: JObject; _jform: JObject): boolean;
function jForm_GetEnvironmentDirectoryPath(env: PJNIEnv; this: JObject; _jform: JObject; _directory: integer): string;
function jForm_GetInternalAppStoragePath(env: PJNIEnv; this: JObject; _jform: JObject): string;
function jForm_CopyFile(env: PJNIEnv; this: JObject; _jform: JObject; _srcFullName: string; _destFullName: string): boolean;
function jForm_LoadFromAssets(env: PJNIEnv; this: JObject; _jform: JObject; _fileName: string): string;
function jForm_IsSdCardMounted(env: PJNIEnv; this: JObject; _jform: JObject): boolean;

//------------------------------------------------------------------------------
// View
//------------------------------------------------------------------------------

// View
Procedure jView_SetVisible             (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean);

//by jmpessoa
Procedure jView_SetVisible2             (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean);


Procedure jView_SetBackGroundColor     (env:PJNIEnv;this:jobject; view : jObject; color   : DWord  );

//by jmpessoa2
Procedure jView_SetBackGroundColor2     (env:PJNIEnv;this:jobject; view : jObject; color : DWord);

Procedure jView_Invalidate             (env:PJNIEnv;this:jobject; view : jObject);

Procedure jView_Invalidate2             (env:PJNIEnv;this:jobject; view : jObject);


Function  jView_Create                 (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
//by jmpessoa
Function  jView_Create2                 (env:PJNIEnv;this:jobject; SelfObj: TObject): jObject;

Procedure jView_Free                   (env:PJNIEnv;this:jobject; View : jObject);

//by jmpessoa
Procedure jView_Free2                   (env:PJNIEnv;this:jobject; View : jObject);
//
Procedure jView_setXYWH                (env:PJNIEnv;this:jobject;
                                        View : jObject;x,y,w,h : integer);
Procedure jView_setParent              (env:PJNIEnv;this:jobject;
                                        View : jObject;ViewGroup : jObject);
Procedure jView_setjCanvas             (env:PJNIEnv;this:jobject;
                                        View : jObject;jCanvas   : jObject);
Procedure jView_viewSave               (env:PJNIEnv;this:jobject;
                                        View : jObject; Filename: String );

Procedure jView_viewSave2               (env:PJNIEnv;this:jobject;
                                        View : jObject; Filename: String );
//by jmpessoa
Procedure jView_setId(env:PJNIEnv;this:jobject; View : jObject; id: DWord);
Procedure jView_setMarginLeft(env:PJNIEnv;this:jobject; View : jObject; x: DWord);
Procedure jView_setMarginTop(env:PJNIEnv;this:jobject; View : jObject; y: DWord);

Procedure jView_setMarginRight(env:PJNIEnv;this:jobject; View : jObject; x: DWord);
Procedure jView_setMarginBottom(env:PJNIEnv;this:jobject; View : jObject; y: DWord);

Procedure jView_setLParamWidth(env:PJNIEnv;this:jobject; View : jObject; w: DWord);
Procedure jView_setLParamHeight(env:PJNIEnv;this:jobject; View : jObject; h: DWord);

Procedure jView_setLParamWidth2(env:PJNIEnv;this:jobject; View : jObject; w: DWord);
Procedure jView_setLParamHeight2(env:PJNIEnv;this:jobject; View : jObject; h: DWord);

Procedure jView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        View : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jView_addLParamsParentRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Procedure jView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Procedure jView_setLayoutAll(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);
Procedure jView_setLayoutAll2(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);


function jView_getLParamHeight(env:PJNIEnv;this:jobject; View : jObject ): integer;
function jView_getLParamWidth(env:PJNIEnv;this:jobject; View : jObject): integer;

function jView_getLParamHeight2(env:PJNIEnv;this:jobject; View : jObject ): integer;
function jView_getLParamWidth2(env:PJNIEnv;this:jobject; View : jObject): integer;

//------------
  function JBool( Bool : Boolean ) : byte;

//----------
// System Info
Function  jSysInfo_ScreenWH            (env:PJNIEnv;this:jobject;context : jObject) : TWH;
Function  jSysInfo_PathApp             (env:PJNIEnv;this:jobject;context : jObject; AppName : String) : String;
Function  jSysInfo_PathDat             (env:PJNIEnv;this:jobject;context : jObject) : String;
Function  jSysInfo_PathExt             (env:PJNIEnv;this:jobject) : String;
Function  jSysInfo_PathDCIM            (env:PJNIEnv;this:jobject) : String;

//by thierrydijoux
Function jSysInfo_Language (env:PJNIEnv; this: jobject; localeType: TLocaleType): String;

//by jmpessoa
Function  jSysInfo_PathDataBase             (env:PJNIEnv;this:jobject;context : jObject) : String;


// Device Info
Function  jSysInfo_DevicePhoneNumber   (env:PJNIEnv;this:jobject) : String;
Function  jSysInfo_DeviceID            (env:PJNIEnv;this:jobject) : String;

//-------------

  Procedure jSystem_SetOrientation       (env:PJNIEnv;this:jobject; orientation : Integer);

  //by jmpessoa
  function jSystem_GetOrientation        (env:PJNIEnv;this:jobject): integer;

  Procedure jClassMethod(FuncName, FuncSig : PChar;
                       env : PJNIEnv; var Class_ : jClass; var Method_ :jMethodID);

  function Get_gjClass(env: PJNIEnv): jClass; //by jmpessoa


var
  gApp: jApp; //global App !
  gVM         : PJavaVM;
  gjClass     : jClass = nil;
  gDbgMode    : Boolean;
  gjAppName   : PChar; // Ex 'com.kredix';
  gjClassName : PChar; // Ex 'com/kredix/Controls';

implementation

uses
  Laz_And_Controls, Laz_And_GLESv2_Canvas, Laz_And_GLESv1_Canvas, Spinner, customdialog;

constructor jControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInitialized:= False;
  FEnabled:= False;
  FjObject := nil;
end;

destructor jControl.Destroy;
begin
  inherited Destroy;
end;

procedure jControl.Init(refApp: jApp);
begin
  FApplication:= refApp;
  FjClass:= Get_jClassLocalRef(FClassPath);
end;

procedure jControl.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
end;

{jVisualControl}

constructor jVisualControl.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
  FjPRLayout := nil;  //java parent
  FjObject    := nil; //java object
  FEnabled   := True;
  FVisible   := True;
  FColor     := colbrDefault;
  FFontColor := colbrDefault;
  FFontSize  := 0; //default size!
  FId        := 0; //0: no control anchored on this control!
  FAnchorId  := -1;  //dummy
  FAnchor    := nil;
  //FGravity:=[];      TODO!
  FPositionRelativeToAnchor:= [];
  FPositionRelativeToParent:= [];
end;

//
Destructor jVisualControl.Destroy;
begin
  inherited Destroy;
end;


procedure jVisualControl.Init(refApp: jApp);
begin
  inherited Init(refApp);
  FjPRLayout:= jForm(Owner).View;  //set default ViewParent/FjPRLayout as jForm.View!
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
        if  Value.Id = 0 then   //Id must be published for data persistence!
        begin
          Randomize;
          Value.Id:= Random(10000000);  //warning: remember the law of Murphi...
        end;
     end;
  end;
end;

procedure jVisualControl.SetParentComponent(Value: TComponent);
begin
  inherited SetParentComponent(Value);
end;

procedure jVisualControl.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
end;

function jVisualControl.GetViewParent: jObject;
begin
  Result:= FjPRLayout;
end;

procedure jVisualControl.SetView(Value: jObject);
begin
  FjRLayout:= Value;
end;

function jVisualControl.GetView: jObject;
begin
  Result:= FjRLayout;
end;

procedure jVisualControl.DefineProperties(Filer: TFiler);
begin
 inherited DefineProperties(Filer);
  {Define new properties and reader/writer methods }
  Filer.DefineProperty('Id', ReadIntId, WriteIntId, True);
end;

procedure jVisualControl.ReadIntId(Reader: TReader);
begin
  FId:= Reader.ReadInteger;
end;

procedure jVisualControl.WriteIntId(Writer: TWriter);
begin
  Writer.WriteInteger(FId);
end;

// needed by jForm process logic ...
procedure jVisualControl.UpdateLayout;
begin
  //dummy...
end;

procedure jVisualControl.SetParamWidth(Value: TLayoutParams);   //***********
begin
  FLParamWidth:= Value;
  if (csDesigning in ComponentState) and (Value <> lpMatchParent) and (Value <> lpWrapContent) then
    FLParamWidth:= GetDesignerLayoutByWH(Self.Width, Self.Parent.Width);
end;

procedure jVisualControl.SetParamHeight(Value: TLayoutParams);
begin
  FLParamHeight:= Value;
  if (csDesigning in ComponentState) and (Value <> lpMatchParent) and (Value <> lpWrapContent) then
     FLParamHeight:= GetDesignerLayoutByWH(Self.Height, Self.Parent.Height);
end;

procedure jVisualControl.SetTextTypeFace(Value: TTextTypeFace);
begin
  FTextTypeFace:= Value;
end;

{ TAndroidWidget }

constructor TAndroidWidget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParent:= nil;
  FChilds:=TFPList.Create;
  FMarginLeft:= 3;
  FMarginRight:= 3;
  FMarginBottom:= 3;
  FMarginTop:= 3;
  FAcceptChildrenAtDesignTime:= False;
  FColor:= colbrDefault;
  FFontColor:= colbrDefault;
end;

destructor TAndroidWidget.Destroy;
begin
  Parent:=nil;
  while ChildCount>0 do Children[ChildCount-1].Free;
  FreeAndNil(FChilds);
  inherited Destroy;
end;

procedure TAndroidWidget.Init(refApp: jApp);
begin
   Inherited Init(refApp);
end;

function TAndroidWidget.GetChilds(Index: integer): TAndroidWidget;
begin
  Result:=TAndroidWidget(FChilds[Index]);
end;

procedure TAndroidWidget.SetMarginBottom(const AValue: integer);
begin
  FMarginBottom:=AValue;
  if (csDesigning in ComponentState) then Invalidate;
end;

procedure TAndroidWidget.SetMarginLeft(const AValue: integer);
begin
  FMarginLeft:=AValue;
  if (csDesigning in ComponentState) then Invalidate;
end;

procedure TAndroidWidget.SetMarginRight(const AValue: integer);
begin
  FMarginRight:=AValue;
  if (csDesigning in ComponentState) then Invalidate;
end;

procedure TAndroidWidget.SetMarginTop(const AValue: integer);
begin
  FMarginTop:=AValue;
  if (csDesigning in ComponentState) then Invalidate;
end;

procedure TAndroidWidget.SetText(Value: string);
begin
  FText:= Value;
  if (csDesigning in ComponentState) then Invalidate;
end;

function TAndroidWidget.GetText: string;
begin
  Result:= FText;
end;

procedure TAndroidWidget.SetLeft(const AValue: integer);
begin
  if (csDesigning in ComponentState) then
    SetBounds(AValue,Top,Width,Height);
end;

procedure TAndroidWidget.SetTop(const AValue: integer);
begin
  if (csDesigning in ComponentState) then
    SetBounds(Left,AValue,Width,Height);
end;

procedure TAndroidWidget.SetWidth(const AValue: integer);
begin
  if (csDesigning in ComponentState) then
    SetBounds(Left,Top,AValue,Height)
  else
    FWidth:= AValue;
end;

procedure TAndroidWidget.SetHeight(const AValue: integer);
begin
  if (csDesigning in ComponentState) then
    SetBounds(Left,Top,Width,AValue)
  else FHeight:= AValue;
end;

function TAndroidWidget.GetWidth: integer;
begin
  Result:= FWidth;
end;

function TAndroidWidget.GetHeight: integer;
begin
  Result:= FHeight;
end;

procedure TAndroidWidget.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
  //see TAndroidForm ...
end;

procedure TAndroidWidget.SetName(const NewName: TComponentName);
begin
  if (csDesigning in ComponentState) then
     if Name = FText then FText:= NewName;
  inherited SetName(NewName);
end;

procedure TAndroidWidget.Notification(AComponent: TComponent; Operation: TOperation);
begin
 inherited Notification(AComponent, Operation);
 if Operation = opRemove then
 begin
   if AComponent = FParent then
   begin
      FParent:= nil;
   end
 end;
end;

procedure TAndroidWidget.SetParent(const AValue: TAndroidWidget);
begin

  if AValue <> FParent then
  begin

      if Assigned(FParent) then
      begin
        FParent.RemoveFreeNotification(Self); //remove free notification...
        if (csDesigning in ComponentState) then Invalidate;
        FParent.FChilds.Remove(Self);
      end;

      FParent:= AValue;

      if AValue <> nil then  //re- add free notification...
      begin
           AValue.FreeNotification(self);
           FParent.FChilds.Add(Self);
      end;

      if (csDesigning in ComponentState) then Invalidate;
  end;
end;

procedure TAndroidWidget.SetParentComponent(Value: TComponent);
begin

  if Value = nil then Exit;

  if Value is TAndroidWidget then
  begin

    Parent:= TAndroidWidget(Value);

    if Self.Height < 50 then
       Self.Height:= 50;

    if Self.Width < 51 then
       Self.Width:= Trunc(TAndroidWidget(Parent).Width/2) - 15;//Trunc(2.0*(Parent.MarginLeft+Parent.MarginRight))-2;

    if (Self is jListView)    or (Self is jPanel) or (Self is jCustomDialog)  or (Self is jCanvasES1) or
       (Self is jCanvasES2)   or (Self is jWebView) or
       (Self is jViewFlipper) or (Self is jSpinner) or
       (Self is jHorizontalScrollView) then
    begin
      Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13;//2*(Parent.MarginLeft+Parent.MarginRight)-2;
    end;

    if (Self is jWebView) then
    begin
      Self.Height:= 100;
      Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13; //2*(Parent.MarginLeft+Parent.MarginRight)-2;
    end;

    if (Self is jScrollView) then
    begin
      Self.Height:= 100;
      Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13; //2*(Parent.MarginLeft+Parent.MarginRight)-2;
    end;

    if (Self is jProgressBar) then
    begin
      Self.Height:= 30;
      Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13; //2*(Parent.MarginLeft+Parent.MarginRight)-2;
    end;

    if (Self is jCheckBox) or (Self is jRadioButton) or (Self is jTextView) then
       Self.Height:= 25;

    if (Self is jImageBtn) then
    begin
      Self.Height:= 48;
      Self.Width:=  48;
    end;

    if (Self is jImageView)   then
    begin
      Self.Height:= 48;
      Self.Width:=  48;
    end;

    if (Self is jView) then
    begin
      Self.Height:= 96;
      Self.Width:=  96;
    end;

    if (Self is jButton) or (Self is jEditText) or (Self is jSpinner)   then
    begin
      Self.Height:= 40;
    end;

    if (Self is jPanel) or (Self is jCustomDialog) then
    begin
      Self.Height:= 48;
    end;

    if Self is jCustomDialog then
    begin
      Self.Height:= 96;
    end;

  end;

end;

function TAndroidWidget.HasParent: Boolean;
begin
  Result:=Parent<>nil;
end;

function TAndroidWidget.GetParentComponent: TComponent;
begin
  Result:= Parent;
end;

procedure TAndroidWidget.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  for i:=0 to ChildCount-1 do
   if Children[i].Owner=Root then Proc(Children[i]);

  if Root = Self then
    for i:=0 to ComponentCount-1 do
      if Components[i].GetParentComponent = nil then
        Proc(Components[i]);
end;

function TAndroidWidget.ChildCount: integer;
begin
  Result:=FChilds.Count;
end;

procedure TAndroidWidget.SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer);
begin
  if (Left=NewLeft) and (Top=NewTop) and (Width=NewWidth) and (Height=NewHeight) then Exit;
  if (csDesigning in ComponentState) then Invalidate;;
  FLeft:=NewLeft;
  FTop:=NewTop;
  FWidth:=NewWidth;
  FHeight:=NewHeight;
  if (Self is jForm) then
  begin
    if FWidth < 300 then FWidth:= 300;
    if FHeight < 600 then FHeight:= 600;
  end;
  if (csDesigning in ComponentState) then Invalidate;;
end;

procedure TAndroidWidget.InvalidateRect(ARect: TRect; Erase: boolean);
begin
  if (csDesigning in ComponentState) then
  begin
    ARect.Left:=Max(0,ARect.Left);
    ARect.Top:=Max(0,ARect.Top);
    ARect.Right:=Min(Width,ARect.Right);
    ARect.Bottom:=Max(Height,ARect.Bottom);
    if Parent <> nil then
    begin
      OffsetRect(ARect,Left+Parent.MarginLeft,Top+Parent.MarginTop);
      Parent.InvalidateRect(ARect,Erase);
    end
    else
    begin
      InternalInvalidateRect(ARect,Erase);
    end;
  end;
end;

procedure TAndroidWidget.Invalidate;
begin
  InvalidateRect(Rect(0,0,Width,Height),False);
end;

  { TAndroidForm }

constructor TAndroidForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TAndroidForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner); //no stream loaded yet.
  FAcceptChildrenAtDesignTime:= True;
end;

destructor TAndroidForm.Destroy;
begin
  inherited Destroy;
end;

procedure TAndroidForm.Init(refApp: jApp);
begin
   Inherited Init(refApp);
end;

procedure TAndroidForm.AfterConstruction;
begin
  inherited AfterConstruction;
  if not (csDesigning in ComponentState) then
     if Assigned(FOnCreate) then FOnCreate(Self);
end;


procedure TAndroidForm.BeforeDestruction;
begin
  inherited BeforeDestruction;
  if not (csDesigning in ComponentState) then
     if Assigned(FOnDestroy) then FOnDestroy(Self);
end;

procedure TAndroidForm.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
 if (Parent=nil) and (Designer<>nil) then
   Designer.InvalidateRect(Self,ARect,Erase);
end;

{ jForm }

constructor jForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner); //don't load stream
end;

constructor jForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner); //no stream loaded yet. {thanks to  x2nie !!}

  FVisible              := False; //true just after Show!
  FEnabled              := True;
  FColor                := colbrDefault;
  FormState             := fsFormCreate;
  FCloseCallBack.Event  := nil;
  FCloseCallBack.EventData:= nil; //by jmpessoa
  FCloseCallBack.Sender := nil;
  FActivityMode          := actMain;  //actMain, actRecyclable, actSplash

  FOnCloseQuery         := nil;
  FOnClose              := nil;
  FOnRotate             := nil;
  FOnClick              := nil;
  FOnActivityRst        := nil;
  FOnJNIPrompt          := nil;

  FjObject              := nil;
  FjRLayout{View}       := nil;
  FApplication            := nil;

  FScreenWH.Height      := 100; //dummy
  FScreenWH.Width       := 100;

  FAnimation.In_        := cjEft_None; //cjEft_FadeIn;
  FAnimation.Out_       := cjEft_None; //cjEft_FadeOut;
  FOrientation          := 0;
  FInitialized          := False;

  FMarginBottom:= 0;
  FMarginLeft:= 0;
  FMarginRight:= 0;
  FMarginTop:= 0;

  //-------------- dummies for compatibility----
  //FOldCreateOrder:= False;
  //FTitle:= 'jForm';
  //FHorizontalOffset:= 300;
  //FVerticalOffset:= 150;
  //--------------

  //now load the stream
  InitInheritedComponent(Self, TAndroidWidget {TAndroidForm}); {thanks to  x2nie !!}

end;

destructor jForm.Destroy;
begin
  inherited Destroy;
end;

procedure jForm.Finish;
begin
  UpdateJNI(gApp);
  jForm_FreeLayout(App.Jni.jEnv, App.Jni.jThis, FjRLayout);
  //jSystem_GC2(App.Jni.jEnv, App.Jni.jThis);
  jForm_Free2(App.Jni.jEnv, App.Jni.jThis, FjObject);
end;

procedure jForm.Init(refApp: jApp);
var
  i: integer;
  bkImgIndex: integer;
begin
  if FInitialized  then Exit;
  if refApp = nil then Exit;
  if not refApp.Initialized then Exit;

  Inherited Init(refApp);

  FScreenWH:= App.Screen.WH;
  FOrientation:= App.Orientation;   //on start ...
  //FActivity:= App.Jni.jActivity;

  FjObject:=  jForm_Create(App.Jni.jEnv, App.Jni.jThis, Self); {jSef}

  FjRLayout:= jForm_Getlayout2(App.Jni.jEnv, App.Jni.jThis, FjObject);  {view/RelativeLayout}

  //thierrydijoux - if backgroundColor is set to black, no theme ...
  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout, GetARGB(FColor));
  //else
     //jView_SetBackGroundColor(App.Jni.jEnv, App.Jni.jThis, FjRLayout, GetARGB(colbrBlack));

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
            (Self.Components[i] as jControl).Init(App); //init just background image
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
         (Self.Components[i] as jControl).Init(App);
      end;
    end;
  end;

  jForm_SetEnabled2(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);

  if gApp.GetCurrentFormsIndex = (cjFormsMax-1) then Exit; //no more form is possible!

  gApp.BaseIndex:= gApp.TopIndex;

  gApp.TopIndex:= gApp.GetCurrentFormsIndex;
  gApp.Forms.Stack[gApp.TopIndex].Form    := Self;
  gApp.Forms.Stack[gApp.TopIndex].CloseCB := FCloseCallBack;

  FormState := fsFormWork;
  FormIndex:= gApp.TopIndex;
  FVisible:= True;

  //inc Index..
  gApp.IncFormsIndex;  //prepare next index...

  //Show ...
  jForm_Show2(App.Jni.jEnv,App.Jni.jThis,FjObject, FAnimation.In_);

  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);

end;

procedure jForm.UpdateJNI(refApp: jApp);
begin
  Self.App.Jni.jEnv:= refApp.Jni.jEnv;
  Self.App.Jni.jThis:= refApp.Jni.jThis;
  //Self.App.Jni.jActivity:= refApp.Jni.jActivity;
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
  FEnabled:= Value;
  if FInitialized then
  begin
    UpdateJNI(gApp);
    jForm_SetEnabled2(App.Jni.jEnv, App.Jni.jThis, FjObject, FEnabled);
  end;
end;

Procedure jForm.SetVisible(Value: Boolean);
begin
 FVisible:= Value;
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
begin

  UpdateJNI(gApp);

  if not FInitialized then Exit;
  if FVisible then Exit;

  FormState := fsFormWork;
  FVisible:= True;

  gApp.BaseIndex := gApp.TopIndex;

  gApp.TopIndex:= Self.FormIndex;

  jForm_Show2(App.Jni.jEnv,App.Jni.jThis,FjObject, FAnimation.In_);

  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);    //*****

end;

Procedure jForm.UpdateLayout;
var
  i: integer;
begin
  UpdateJNI(gApp);
  for i := 0 to  (Self.ComponentCount - 1) do   //********
  begin
     if Self.Components[i] is jVisualControl then
     begin
        (Self.Components[i] as jVisualControl).UpdateLayout;
     end;
  end;
end;

//Ref. Destroy
procedure jForm.Close;
begin
 // Post Closing Step
 // --------------------------------------------------------------------------
 // Java           Java          Java-> Pascal
 // jForm_Close -> RemoveView -> Java_Event_pOnClose
  UpdateJNI(gApp);
  jForm_Close2(App.Jni.jEnv, App.Jni.jThis, FjObject);  //close java form...
end;

//after java form close......
Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject;  Form : TObject);
var
  Inx: integer;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  gApp.TopIndex:= gApp.BaseIndex;  //update topIndex...

  Inx := jForm(Form).FormIndex ;

  if not Assigned(Form) then exit; //just precaution...

  if Assigned(jForm(Form).OnClose) then
  begin
   // jForm(Form).ShowMessage('OnQuery: '+ IntTostr(Inx)); //ok...
   // jForm(Form).ShowMessage('BaseIndex: '+ IntTostr(gApp.BaseIndex));
    jForm(Form).OnClose(jForm(Form));
  end;

  jForm(Form).FormState := fsFormClose;
  jForm(Form).FVisible:= False;

  if jForm(Form).ActivityMode <> actMain then //actSplash or actRecycable
  begin
      //LORDMAN - 2013-08-01 / Call Back
      if Assigned(gApp.Forms.Stack[Inx].CloseCB.Event) then
         gApp.Forms.Stack[Inx].CloseCB.Event(gApp.Forms.Stack[Inx].CloseCB.Sender);

      //by jmpessoa Call Back Data
      if Assigned(gApp.Forms.Stack[Inx].CloseCB.EventData) then
         gApp.Forms.Stack[Inx].CloseCB.EventData(gApp.Forms.Stack[Inx].CloseCB.Sender,
                                                 jForm(Form).FCBDataString,
                                                 jForm(Form).FCBDataInteger ,
                                                 jForm(Form).FCBDataDouble);
  end;

  gApp.Forms.Stack[Inx].CloseCB.EventData  := nil;
  gApp.Forms.Stack[Inx].CloseCB.Event  := nil;
  gApp.Forms.Stack[Inx].CloseCB.Sender := nil;

  if jForm(Form).ActivityMode = actMain then  //"The End"
  begin
    jForm(Form).Finish;
    gApp.Finish;
  end;
end;

Procedure jForm.Refresh;
begin
  if FInitialized then
  begin
    UpdateJNI(gApp);
    jView_Invalidate(Self.App.Jni.jEnv, Self.App.Jni.jThis, Self.View);
  end;
end;

Procedure jForm.SetCloseCallBack(func : TOnNotify; Sender : TObject);
begin
  FCloseCallBack.Event  := func;
  FCloseCallBack.Sender := Sender;
end;

Procedure jForm.SetCloseCallBack(func : TOnCallBackData; Sender : TObject);
begin
  FCloseCallBack.EventData:= func;
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

function  jForm.GetOnViewClickListener(jObjForm: jObject): jObject;
begin
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetOnViewClickListener(Self.App.Jni.jEnv, Self.App.Jni.jThis, jObjForm);
  end;
end;

function  jForm.GetOnListItemClickListener(jObjForm: jObject): jObject;
begin
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetOnListItemClickListener(Self.App.Jni.jEnv, Self.App.Jni.jThis, jObjForm);
  end;
end;

Procedure jForm.GenEvent_OnListItemClick(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer);
begin
 if FInitialized then
   if Assigned(FOnListItemClick) then FOnListItemClick(jObjAdapterView, jObjView,position,Id);
end;


Procedure jForm.GenEvent_OnViewClick(jObjView: jObject; Id: integer);
begin
   if Assigned(FOnViewClick) then FOnViewClick(jObjView,Id);
end;

(*
procedure jForm.ReadIntHorizontalOffset(Reader: TReader);
begin
  FHorizontalOffset:= Reader.ReadInteger;
end;

procedure jForm.WriteIntHorizontalOffset(Writer: TWriter);
begin
   Writer.WriteInteger(FHorizontalOffset);
end;

procedure jForm.ReadIntVerticalOffset(Reader: TReader);
begin
  FVerticalOffset:= Reader.ReadInteger;
end;

procedure jForm.WriteIntVerticalOffset(Writer: TWriter);
begin
   Writer.WriteInteger(FVerticalOffset);
end;

procedure jForm.ReadBolOldCreateOrder(Reader: TReader);
begin
   FOldCreateOrder:= Reader.ReadBoolean;
end;

procedure jForm.WriteBolOldCreateOrder(Writer: TWriter);
begin
   Writer.WriteBoolean(FOldCreateOrder);
end;

procedure jForm.ReadStrTitle(Reader: TReader);
begin
   FTitle:= Reader.ReadString;
end;

procedure jForm.WriteStrTitle(Writer: TWriter);
begin
   Writer.WriteString(FTitle);
end;

procedure jForm.DefineProperties(Filer: TFiler);
begin
 inherited DefineProperties(Filer);
  {Define new properties and reader/writer methods }
  Filer.DefineProperty('HorizontalOffset', ReadIntHorizontalOffset, WriteIntHorizontalOffset, True);
  Filer.DefineProperty('VerticalOffset', ReadIntVerticalOffset, WriteIntVerticalOffset, True);
  Filer.DefineProperty('OldCreateOrder', ReadBolOldCreateOrder, WriteBolOldCreateOrder, True);
  Filer.DefineProperty('Title', ReadStrTitle, WriteStrTitle, FTitle<>'');
end;
*)

function jForm.GetStringExtra(data: jObject; extraName: string): string;
begin
  //in designing component state: result value here...
   if FInitialized then
   begin
     UpdateJNI(gApp);
     Result:= jForm_GetStringExtra(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, data ,extraName);
   end;
end;

function jForm.GetIntExtra(data: jObject; extraName: string; defaultValue: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetIntExtra(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, data ,extraName ,defaultValue);
  end;
end;

function jForm.GetDoubleExtra(data: jObject; extraName: string; defaultValue: double): double;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetDoubleExtra(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, data ,extraName ,defaultValue);
  end;
end;

procedure jForm.SetWifiEnabled(_status: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     UpdateJNI(gApp);
     jForm_SetWifiEnabled(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _status);
  end;
end;

function jForm.IsWifiEnabled(): boolean;
begin
  //in designing component state: result value here...
   if FInitialized then
   begin
      UpdateJNI(gApp);
      Result:= jForm_IsWifiEnabled(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
   end;
end;

function jForm.GetEnvironmentDirectoryPath(_directory: TEnvDirectory): string;
begin
  Result:='';
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetEnvironmentDirectoryPath(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, Ord(_directory))
  end;
end;

function jForm.GetInternalAppStoragePath: string;
begin
  Result:='';
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_GetInternalAppStoragePath(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
  end;
end;

function jForm.CopyFile(srcFullFilename: string; destFullFilename: string): boolean;
begin
  Result:= False;
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_CopyFile(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, srcFullFilename, destFullFilename);
  end;
end;

function jForm.LoadFromAssets(fileName: string): string;
begin
  Result:= '';
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_LoadFromAssets(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, fileName);
  end;
end;

function jForm.IsSdCardMounted: boolean;
begin
  Result:= False;
  if FInitialized then
  begin
    UpdateJNI(gApp);
    Result:= jForm_IsSdCardMounted(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
  end;
end;

procedure jForm.DeleteFile(_filename: string);
begin
  //in designing component state: set value here...
  UpdateJNI(gApp);
  if FInitialized then
     jForm_DeleteFile(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _filename);
end;

procedure jForm.DeleteFile(_fullPath: string; _filename: string);
begin
  //in designing component state: set value here...
  UpdateJNI(gApp);
  if FInitialized then
     jForm_DeleteFile(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _fullPath ,_filename);
end;

procedure jForm.DeleteFile(_environmentDir: TEnvDirectory; _filename: string);
begin
  //in designing component state: set value here...
  UpdateJNI(gApp);
  if FInitialized then
     jForm_DeleteFile(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, Ord(_environmentDir) ,_filename);
end;

function jForm.CreateDir(_dirName: string): string;
begin
  //in designing component state: result value here...
  UpdateJNI(gApp);
  if FInitialized then
   Result:= jForm_CreateDir(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _dirName);
end;

function jForm.CreateDir(_environmentDir: TEnvDirectory; _dirName: string): string;
begin
  //in designing component state: result value here...
  UpdateJNI(gApp);
  if FInitialized then
   Result:= jForm_CreateDir(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, Ord(_environmentDir) ,_dirName);
end;

function jForm.CreateDir(_fullPath: string; _dirName: string): string;
begin
  //in designing component state: result value here...
  UpdateJNI(gApp);
  if FInitialized then
   Result:= jForm_CreateDir(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _fullPath ,_dirName);
end;

function jForm.IsExternalStorageEmulated(): boolean;
begin
  //in designing component state: result value here...
  UpdateJNI(gApp);
  if FInitialized then
   Result:= jForm_IsExternalStorageEmulated(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

function jForm.IsExternalStorageRemovable(): boolean;
begin
  //in designing component state: result value here...
  UpdateJNI(gApp);
  if FInitialized then
   Result:= jForm_IsExternalStorageRemovable(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

function jForm.GetjFormVersionFeatures(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetjFormVersionFeatures(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

function jForm.GetActionBar(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

procedure jForm.HideActionBar();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_HideActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

procedure jForm.ShowActionBar();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

procedure jForm.ShowTitleActionBar(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowTitleActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _value);
end;

procedure jForm.HideLogoActionBar(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_HideLogoActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _value);
end;

procedure jForm.SetTitleActionBar(_title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetTitleActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _title);
end;

procedure jForm.SetSubTitleActionBar(_subtitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetSubTitleActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _subtitle);
end;

procedure jForm.SetIconActionBar(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetIconActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _iconIdentifier);
end;


procedure jForm.SetTabNavigationModeActionBar();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetTabNavigationModeActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

procedure jForm.RemoveAllTabsActionBar();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_RemoveAllTabsActionBar(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject);
end;

function jForm.GetStringResourceId(_resName: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetStringResourceId(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resName);
end;

function jForm.GetStringResourceById(_resID: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetStringResourceById(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resID);
end;

function jForm.GetDrawableResourceId(_resName: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDrawableResourceId(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resName);
end;

function jForm.GetDrawableResourceById(_resID: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDrawableResourceById(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resID);
end;

function jForm.GetQuantityStringByName(_resName: string; _quantity: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetQuantityStringByName(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resName ,_quantity);
end;

function jForm.GetStringResourceByName(_resName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetStringResourceByName(Self.App.Jni.jEnv, Self.App.Jni.jThis, FjObject, _resName);
end;

{-------- jForm_JNI_Bridge ----------}

function jForm_GetStringExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= data;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringExtra', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
end;


function jForm_GetIntExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string; defaultValue: integer): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= data;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].i:= defaultValue;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntExtra', '(Landroid/content/Intent;Ljava/lang/String;I)I');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

function jForm_GetDoubleExtra(env: PJNIEnv; this: JObject; _jform: JObject; data: jObject; extraName: string; defaultValue: double): double;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= data;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].d:= defaultValue;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDoubleExtra', '(Landroid/content/Intent;Ljava/lang/String;D)D');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
end;


procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _fullPath: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullPath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;


procedure jForm_DeleteFile(env: PJNIEnv; this: JObject; _jform: JObject; _environmentDir: integer; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _environmentDir;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteFile', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
end;


function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _dirName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dirName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateDir', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
end;


function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _environmentDir: integer; _dirName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _environmentDir;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dirName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateDir', '(ILjava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[1].l);
end;


function jForm_CreateDir(env: PJNIEnv; this: JObject; _jform: JObject; _fullPath: string; _dirName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullPath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dirName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateDir', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;


function jForm_IsExternalStorageEmulated(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsExternalStorageEmulated', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
end;


function jForm_IsExternalStorageRemovable(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsExternalStorageRemovable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
end;

function jForm_GetjFormVersionFeatures(env: PJNIEnv; this: JObject; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetjFormVersionFeatures', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
end;


function jForm_GetActionBar(env: PJNIEnv; this: JObject; _jform: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionBar', '()Landroid/app/ActionBar;');
  Result:= env^.CallObjectMethod(env, _jform, jMethod);
end;

procedure jForm_HideActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'HideActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
end;

procedure jForm_ShowActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
end;

procedure jForm_ShowTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowTitleActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
end;

procedure jForm_HideLogoActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'HideLogoActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
end;

procedure jForm_SetTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleActionBar', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jForm_SetSubTitleActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _subtitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_subtitle));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubTitleActionBar', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jForm_SetIconActionBar(env: PJNIEnv; this: JObject; _jform: JObject; _iconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconActionBar', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jForm_SetTabNavigationModeActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabNavigationModeActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
end;

procedure jForm_RemoveAllTabsActionBar(env: PJNIEnv; this: JObject; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveAllTabsActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
end;

function jForm_GetStringResourceId(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_resName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringResourceId', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


function jForm_GetStringResourceById(env: PJNIEnv; this: JObject; _jform: JObject; _resID: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _resID;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringResourceById', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
end;


function jForm_GetDrawableResourceId(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_resName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawableResourceId', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

function jForm_GetDrawableResourceById(env: PJNIEnv; this: JObject; _jform: JObject; _resID: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _resID;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawableResourceById', '(I)Landroid/graphics/drawable/Drawable;');
  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
end;


function jForm_GetQuantityStringByName(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string; _quantity: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_resName));
  jParams[1].i:= _quantity;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetQuantityStringByName', '(Ljava/lang/String;I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;


function jForm_GetStringResourceByName(env: PJNIEnv; this: JObject; _jform: JObject; _resName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_resName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringResourceByName', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;

  {jApp by jmpessoa}

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

  Forms.Index      := 0; //dummy
  TopIndex:= 0;
  BaseIndex:= 0;

end;

Destructor jApp.Destroy;
begin
  inherited Destroy;
end;

Procedure jApp.Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject);
//var
  //version, revision: string;
  //intVer: integer;
  //intRev: integer;

begin
  if FInitialized  then Exit;
  // Setting Global Environment -----------------------------------------------
  FillChar(Forms,SizeOf(Forms),#0);
  //
  Screen.Style  := ssSensor;     // Screen Style [Device,Portrait,Lanscape]
  // Jni
  Jni.jEnv      := env;  //a reference to the JNI environment
  Jni.jThis     := this; //a reference to the object making this call (or class if static).
  Jni.jActivity := activity;  //[by jmpessoa: for API > 13 STALED!!! do not use!
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

  if Pos('getLocale',Self.GetControlsVersionFeatures) > 0 then //"ver&rev=Feature;ver$rev=Feature2"
  begin
      with Locale do
      begin
         Country         := jSysInfo_Language(env, this, ltCountry);
         DisplayCountry  := jSysInfo_Language(env, this, ltDisplayCountry);
         DisplayLanguage := jSysInfo_Language(env, this, ltDisplayLanguage);
         DisplayName     := jSysInfo_Language(env, this, ltDisplayName);
         DisplayVariant  := jSysInfo_Language(env, this, ltDisplayVariant);
         Iso3Country     := jSysInfo_Language(env, this, ltIso3Country);
         Iso3Language    := jSysInfo_Language(env, this, ltIso3Language);
         Variant         := jSysInfo_Language(env, this, ltVariant);
      end;
  end;

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
   Forms.Index:= Forms.Index +1;
end;

function jApp.GetNewFormsIndex: integer;
begin
  Forms.Index:= Forms.Index +1;
  Result:= Forms.Index;
end;

function jApp.GetPreviousFormsIndex: integer;
begin
  Result:= Forms.Index - 1;
end;

Procedure jApp.DecFormsIndex;
begin
  Forms.Index:= Forms.Index - 1;
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

function jApp.GetContext: jObject;
begin
  Result:= jApp_GetContext(Self.Jni.jEnv, Self.Jni.jThis);
end;

function jApp.GetControlsVersionInfo: string;
begin
   Result:= jApp_GetControlsVersionInfo(Self.Jni.jEnv, Self.Jni.jThis); //"ver&rev|newFeature;ver$rev|newfeature2"
end;

function jApp.GetControlsVersionFeatures: string;     //"ver&rev|newFeature;ver$rev|newfeature2"
begin
   Result:= jApp_GetControlsVersionFeatures(Self.Jni.jEnv, Self.Jni.jThis);
end;

//thanks to  thierrydijoux
function jApp.GetStringResourceId(_resName: string): integer;
begin
   Result:= jApp_GetStringResourceId(Self.Jni.jEnv, Self.Jni.jThis, PChar(_resName));
end;

function  jApp.GetStringResourceById(_resId: integer): string;
begin
  Result:= jApp_GetStringResourceById(Self.Jni.jEnv, Self.Jni.jThis, _resId);
end;

//by thierrydijoux - get a resource string by name
function jApp.GetStringResourceByName(_resName: string): string;
begin
  Result:= jApp_GetStringResourceByName(Self.Jni.jEnv, Self.Jni.jThis, _resName);
end;

//by thierrydijoux - get a resource string by name
function jApp.GetQuantityStringByName(_resName: string; _Quantity: integer): string;
begin
  Result:= jApp_GetQuantityStringByName(Self.Jni.jEnv, Self.Jni.jThis, _resName, _Quantity);
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

function GetParamByParentSide(paren: TAndroidWidget; side: TSide): DWord;
//var
// l: TLayoutParams;
begin
   case side of
     sdW: begin
            //l:= (paren as jVisualControl).LayoutParamWidth;
            Result:= paren.Width;
          end;
     sdH: begin
            //l:= (paren as jVisualControl).LayoutParamHeight;
            Result:= paren.Height;
           end;
   end;
end;

function GetLayoutParamsName(ordIndex: DWord): TLayoutParams;
begin
   case  ordIndex of
     0: Result:= lpMatchParent;
     1: Result:= lpWrapContent;
     2: Result:= lpHalfOfParent;
     3: Result:= lpOneQuarterOfParent;
     4: Result:= lpTwoThirdOfParent;
     5: Result:= lpOneThirdOfParent;
     6: Result:= lpOneEighthOfParent;
     7: Result:= lpOneFifthOfParent;
     8: Result:= lpTwoFifthOfParent;
     9: Result:= lpThreeFifthOfParent;
     10: Result:= lpThreeQuarterOfParent;
     11: Result:= lpFourFifthOfParent;
     12: Result:= lp16px;
     13: Result:= lp24px;
     14: Result:= lp32px;
     15: Result:= lp40px;
     16: Result:= lp48px;
     17: Result:= lp72px;
     18: Result:= lp96px;
     //19: Result:= lpDesigner;
   end;
end;

function GetLayoutParamsOrd(lpParam: TLayoutParams): DWord;
begin
   Result:= Ord(lpParam);
end;


function GetLayoutParamsByParent(paren: TAndroidWidget; lpParam: TLayoutParams;  side: TSide): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[0];
     lpWrapContent:          Result:= TLayoutParamsArray[1];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamByParentSide(paren, side)-14);
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamByParentSide(paren, side)-14);
     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamByParentSide(paren, side)-14);
     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamByParentSide(paren, side)-14);
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamByParentSide(paren, side)-14);
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamByParentSide(paren, side)-14);
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamByParentSide(paren, side)-14);
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamByParentSide(paren, side)-14);
     lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamByParentSide(paren, side)-14);
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamByParentSide(paren, side)-14);
     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
     //lpDesigner: Result:= 0;
  end;
end;

function GetLayoutParams(App:jApp; lpParam: TLayoutParams; side: TSide): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[0];
     lpWrapContent:          Result:= TLayoutParamsArray[1];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamBySide(App, side)-14);
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamBySide(App, side)-14);
     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamBySide(App, side)-14);
     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamBySide(App, side)-14);
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamBySide(App, side)-14);
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamBySide(App, side)-14);
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamBySide(App, side)-14);
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamBySide(App, side)-14);
     lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamBySide(App, side)-14);
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamBySide(App, side)-14);
     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
     //lpDesigner: Result:= 0;
  end;
end;

function GetDesignerLayoutParams(lpParam: TLayoutParams;  L: integer): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[0];
     lpWrapContent:          Result:= TLayoutParamsArray[1];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*L-14);
     lpOneThirdOfParent:     Result:= Trunc((1/3)*L-14);
     lpHalfOfParent:         Result:= Trunc((1/2)*L-14);
     lpOneQuarterOfParent:   Result:= Trunc((1/4)*L-14);
     lpOneEighthOfParent:    Result:= Trunc((1/8)*L-14);
     lpOneFifthOfParent:     Result:= Trunc((1/5)*L-14);
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*L-14);
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*L-14);
     lpThreeQuarterOfParent: Result:= Trunc((3/4)*L-14);
     lpFourFifthOfParent:    Result:= Trunc((4/5)*L-14);
     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
     //lpDesigner: Result:= 0;
  end;
end;

function GetDesignerLayoutByWH(Value: DWord; L: integer): TLayoutParams;  //just for design time...
begin
        if Value = 16 then Result:= lp16px
   else if Value = 24 then Result:= lp24px
   else if Value = 32 then Result:= lp32px
   else if Value = 40 then Result:= lp40px
   else if Value = 48 then Result:= lp48px
   else if Value = 72 then Result:= lp72px
   else if Value = 96 then Result:= lp96px
   else if Value <= Trunc((1/8)*L) then Result:=lpOneEighthOfParent    //12.5
   else if Value <= Trunc((1/5)*L) then Result:=lpOneFifthOfParent     //20
   else if Value <= Trunc((1/4)*L) then Result:=lpOneQuarterOfParent   //25.00
   else if Value <= Trunc((1/3)*L) then Result:=lpOneThirdOfParent     //33.33
   else if Value <= Trunc((2/5)*L) then Result:=lpTwoFifthOfParent     //40
   else if Value <= Trunc((1/2)*L) then Result:=lpHalfOfParent         //50.00
   else if Value <= Trunc((3/5)*L) then Result:=lpThreeFifthOfParent   //60
   else if Value <= Trunc((2/3)*L) then Result:=lpTwoThirdOfParent     //66.66
   else if Value <= Trunc((3/4)*L) then Result:=lpThreeQuarterOfParent //75
   else if Value <= Trunc((4/5)*L) then Result:=lpFourFifthOfParent    //80
   else Result:= lpMatchParent;
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

//JNI API Bridge: by jmpessoa
function Get_jClassLocalRef(fullClassName: string): jClass;
begin
 Result:= nil;
 if  fullClassName <> '' then
    Result:= jClass(gApp.Jni.jEnv^.FindClass(gApp.Jni.jEnv, PChar(fullClassName)));
end;

function  Is_jInstanceOf(jObj:JObject; cls: jClass): boolean;
begin
  Result:= boolean(gApp.Jni.jEnv^.IsInstanceOf(gApp.Jni.jEnv, jObj, cls));
end;

function Get_jObjectClass(jObj: jObject): jClass;
begin
  Result:=gApp.Jni.jEnv^.GetObjectClass(gApp.Jni.jEnv, jObj);
end;

function Create_jObjectLocalRef(cls: JClass): JObject;
var
  Mid: JMethodID;
begin
  Result := nil;
  // Find the class
  try
    //Get its default constructor
    Mid := gApp.Jni.jEnv^.GetMethodID(gApp.Jni.jEnv, cls, '<init>', '()V');

    if Mid = nil then exit;

    //Create the object
    Result := gApp.Jni.jEnv^.NewObjectA(gApp.Jni.jEnv, cls, Mid, nil);
  except
    on E: Exception do Exit;
  end;
end;

function Get_jObjGlobalRef(jObj: jObject): JObject;
begin
  Result := gApp.Jni.jEnv^.NewGlobalRef(gApp.Jni.jEnv,jObj);
end;


function Create_jObjectLocalRefA(cls: JClass;
                        paramFullSignature: string; paramValues: array of jValue): JObject;
var
  Mid: JMethodID;
begin
  Result := nil;
  // Find the class
  try
    //Get its default constructor
    Mid := gApp.Jni.jEnv^.GetMethodID(gApp.Jni.jEnv, cls, '<init>', PChar('('+paramFullSignature+')V'));

    if Mid = nil then exit;

    //Create the object
    Result := gApp.Jni.jEnv^.NewObjectA(gApp.Jni.jEnv, cls, Mid, @paramValues);
  except
    on E: Exception do Exit;
  end;
end;


//NewObjectArray:function(Env:PJNIEnv; Len:JSize;AClass:JClass; Init:JObject):JObjectArray;

function Create_jObjectArray(Len: integer; cls: jClass; initialElement: jObject): jObject;
begin
  Result := nil;
  try
    Result := gApp.Jni.jEnv^.NewObjectArray(gApp.Jni.jEnv, len, cls, initialElement);
  except
    on E: Exception do Exit;
  end;
end;

//void SetObjectArrayElement(JNIEnv *env, jobjectArray array,jsize index, jobject value);
procedure Set_jObjectArrayElement(jobjectArray: jObject; index: integer; element: jObject);
begin
  gApp.Jni.jEnv^.SetObjectArrayElement(gApp.Jni.jEnv, jobjectArray, index, element);
end;

//http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html
procedure Set_jObjectArray(jobjectArray: jObject; indexInitial: integer; elements: array of string);
var
  len, i: integer;
  jParamsString: array[0..0] of jValue;
  jObj_string: jObject;
  jClass_string: jClass;
begin
  jClass_string:=  Get_jClassLocalRef('java/lang/String');
  len:= Length(elements);
  for i:= indexInitial to len-1 do
  begin
    jParamsString[0].l:= Get_jString(elements[i]); //result is object!
    jObj_string:= Create_jObjectLocalRefA(jClass_string,'Ljava/lang/String;', jParamsString);
    Delete_jLocalParamRef(jParamsString, 0 {index});  //just cleanup...
    Set_jObjectArrayElement(jobjectArray, i, jObj_string);
  end;
end;

//jobject GetObjectArrayElement(JNIEnv *env,jobjectArray array, jsize index);
function Get_jObjectArrayElement(jobjectArray: jObject; index: integer): jObject;
begin
  Result:= gApp.Jni.jEnv^.GetObjectArrayElement(gApp.Jni.jEnv, jobjectArray, index);
end;

//jsize GetArrayLength(JNIEnv *env, jarray array);
function Get_jArrayLength(jobjectArray: jObject): integer;
begin
  Result:= gApp.Jni.jEnv^.GetArrayLength(gApp.Jni.jEnv, jobjectArray);
end;


function Get_jMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
begin
    //a jmethodID is not an object. So don't need to convert it to a GlobalRef!
   Result:= gApp.Jni.jEnv^.GetMethodID( gApp.Jni.jEnv, cls , PChar(funcName), PChar(funcSignature));
end;

function Get_jStaticMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
begin
    //a jmethodID is not an object. So don't need to convert it to a GlobalRef!
  Result:= gApp.Jni.jEnv^.GetStaticMethodID( gApp.Jni.jEnv, cls , PChar(funcName), PChar(funcSignature));
end;

function Call_jIntMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue): integer;
begin
  Result:= gApp.Jni.jEnv^.CallIntMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

// ...
function Call_jDoubleMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): double;
begin
  Result:= gApp.Jni.jEnv^.CallDoubleMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

// ...
function Call_jDoubleMethod(jObj:jObject; method: jMethodID): double;
begin
  Result:= gApp.Jni.jEnv^.CallDoubleMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jIntMethod(jObj:jObject; method: jMethodID): integer;
begin
  Result:= gApp.Jni.jEnv^.CallIntMethod(gApp.Jni.jEnv, jObj, method);
end;

procedure Call_jVoidMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue);
begin
   gApp.Jni.jEnv^.CallVoidMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

procedure Call_jVoidMethod(jObj:jObject; method: jMethodID);
begin
   gApp.Jni.jEnv^.CallVoidMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jObjectMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): jObject;
begin
   Result:= gApp.Jni.jEnv^.CallObjectMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

function Call_jObjectMethod(jObj:jObject; method: jMethodID): jObject;
begin
   Result:= gApp.Jni.jEnv^.CallObjectMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jBooleanMethod(jObj:jObject; method: jMethodID): boolean;
begin
   Result:= boolean(gApp.Jni.jEnv^.CallBooleanMethod(gApp.Jni.jEnv, jObj, method));
end;

function Call_jBooleanMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue): boolean;
begin
     Result:= boolean(gApp.Jni.jEnv^.CallBooleanMethodA(gApp.Jni.jEnv, jObj, method, @jParams));
end;

procedure Delete_jLocalParamRef(var jParams: array of jValue; index: integer);
begin
  gApp.Jni.jEnv^.DeleteLocalRef(gApp.Jni.jEnv, jParams[index].l);
end;

procedure Delete_jLocalRef(jObj: jObject);
begin
  gApp.Jni.jEnv^.DeleteLocalRef(gApp.Jni.jEnv, jObj);
end;

procedure Delete_jGlobalRef(jObj: jObject);
begin
  if jObj <> nil then
    gApp.Jni.jEnv^.DeleteGlobalRef(gApp.Jni.jEnv,jObj);
end;

function Get_jString(str: string): jObject;
begin
  Result:= gApp.Jni.jEnv^.NewStringUTF(gApp.Jni.jEnv, PChar(str));
end;

function Get_pString(jStr: jObject): string;
var
  _jBoolean: jBoolean;
begin
 case jStr = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := String( gApp.Jni.jEnv^.GetStringUTFChars(gApp.Jni.jEnv,jStr,@_jBoolean) );
         end;
 end;
end;

function Call_jStaticIntMethodA(fullClassName: string;
                       funcName: string; funcSignature: string; var jParams: array of jValue): integer;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:= gApp.Jni.jEnv^.CallStaticIntMethodA(gApp.Jni.jEnv, cls, Mid, @jParams);
  Delete_jLocalRef(cls);
end;

function Call_jStaticIntMethod(fullClassName: string;
                       funcName: string; funcSignature: string): integer;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:= gApp.Jni.jEnv^.CallStaticIntMethod(gApp.Jni.jEnv, cls, Mid);
  Delete_jLocalRef(cls);
end;

function Call_jStaticDoubleMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue): double;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:= gApp.Jni.jEnv^.CallStaticDoubleMethodA(gApp.Jni.jEnv, cls, Mid, @jParams);
  Delete_jLocalRef(cls);
end;

function Call_jStaticDoubleMethod(fullClassName: string; funcName: string; funcSignature: string): double;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:= gApp.Jni.jEnv^.CallStaticDoubleMethod(gApp.Jni.jEnv, cls, Mid);
  Delete_jLocalRef(cls);
end;

procedure Call_jCallStaticVoidMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue);
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  gApp.Jni.jEnv^.CallStaticVoidMethodA(gApp.Jni.jEnv, cls, Mid, @jParams);
  Delete_jLocalRef(cls);
end;

procedure Call_jCallStaticVoidMethod(fullClassName: string; funcName: string; funcSignature: string);
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  gApp.Jni.jEnv^.CallStaticVoidMethod(gApp.Jni.jEnv, cls, Mid);
  Delete_jLocalRef(cls);
end;

function Call_jCallStaticBooleanMethodA(fullClassName: string;
                       funcName: string; funcSignature: string; var jParams: array of jValue): boolean;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:=  boolean(gApp.Jni.jEnv^.CallStaticBooleanMethodA(gApp.Jni.jEnv, cls, Mid, @jParams));
  Delete_jLocalRef(cls);
end;

function Call_jCallStaticBooleanMethod(fullClassName: string;
                       funcName: string; funcSignature: string): boolean;
var
  cls: jClass;
  Mid: jMethodID;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  Mid:= Get_jStaticMethodID(cls, funcName, funcSignature);
  Result:= boolean(gApp.Jni.jEnv^.CallStaticBooleanMethod(gApp.Jni.jEnv, cls, Mid));
  Delete_jLocalRef(cls);
end;

function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
  end;
end;

//hacked by jmpessoa!! sorry, was for a good cause!
//please, use the  jForm_GetDateTime!!
//return GetControlsVersionFeatures ... "6$4=GetControlsVersionInfo;6$4=getLocale"
function jApp_GetControlsVersionFeatures(env:PJNIEnv;this:jobject): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'getStrDateTime', '()Ljava/lang/String;');
  _jString:= env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

Procedure jApp_Finish(env:PJNIEnv;this:jobject);
Const
  _cFuncName = 'appFinish';
  _cFuncSig  = '()V';
  _jMethod: jMethodID = nil;
begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  env^.CallVoidMethod(env,this,_jMethod);
end;

//by jmpessoa
Procedure jApp_Finish2(env:PJNIEnv; this: jobject);
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, this);
  method:= env^.GetMethodID(env, cls, 'appFinish', '()V');
  env^.CallVoidMethod(env, this, method);
end;

function  jApp_GetContext(env:PJNIEnv;this:jobject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, this);
  method:= env^.GetMethodID(env, cls, 'GetContext', '()Landroid/content/Context;');
  Result:= env^.CallObjectMethod(env, this, method);
end;

function jApp_GetControlsVersionInfo(env:PJNIEnv;this:jobject): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'GetControlsVersionInfo', '()Ljava/lang/String;');
  _jString:= env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

function  jForm_GetOnViewClickListener(env:PJNIEnv; this:jobject; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetOnViewClickListener', '()Landroid/view/View$OnClickListener;');
  Result:= env^.CallObjectMethod(env, Form, method);
  //Result := env^.NewGlobalRef(env,Result);
end;

function  jForm_GetOnListItemClickListener(env:PJNIEnv; this:jobject; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetOnListItemClickListener', '()Landroid/widget/AdapterView$OnItemClickListener;');
  Result:= env^.CallObjectMethod(env, Form, method);
  //Result := env^.NewGlobalRef(env,Result);
end;

Procedure jApp_KillProcess(env:PJNIEnv;this:jobject);
Const
 _cFuncName = 'appKillProcess';
 _cFuncSig  = '()V';
Var
 _jMethod : jMethodID = nil;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 env^.CallVoidMethod(env,this,_jMethod);
end;

Procedure jApp_ScreenStyle(env:PJNIEnv; this:jobject; screenstyle: integer);
Const
 _cFuncName = 'appScreenStyle';
 _cFuncSig  = '(I)';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.I := screenStyle;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

//by jmpessoa
procedure jApp_GetJNIEnv(var env:PJNIEnv);
var
 PEnv: PPointer {PJNIEnv};
begin
  gVM^.GetEnv(gVM, @PEnv,JNI_VERSION_1_6);
  env:= PJNIEnv(PEnv);
end;

function  jApp_GetStringResourceId(env:PJNIEnv;this:jobject; _resName: string): integer;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'GetStringResourceId', '(Ljava/lang/String;)I');
  _jParams[0].l := env^.NewStringUTF(env, pchar(_resName) );
  Result:= env^.CallIntMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

function  jApp_GetStringResourceById(env:PJNIEnv;this:jobject; _resId: integer ): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 _jString : jString;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'GetStringResourceById', '(I)Ljava/lang/String;');
  _jParams[0].i := _resId;
  _jString:= env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

function  jApp_GetStringResourceByName(env:PJNIEnv;this:jobject; _resName: string): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'getStringResourceByName', '(Ljava/lang/String;)Ljava/lang/String;');
  _jParams[0].l := env^.NewStringUTF(env, pchar(_resName) );
  _jString:= env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteLocalRef(env,_jParams[0].l); //added ...
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

// thierrydijoux - get a resource quantity string by name
function  jApp_GetQuantityStringByName(env:PJNIEnv;this:jobject; _resName: string; _Quantity: integer): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, this);
  _jMethod:= env^.GetMethodID(env, _cls, 'getQuantityStringByName', '(Ljava/lang/String;I)Ljava/lang/String;');
  _jParams[0].l := env^.NewStringUTF(env, pchar(_resName) );
  _jParams[1].i:= _Quantity;
  _jString:= env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteLocalRef(env,_jParams[0].l); //added..
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

Function  jForm_Create (env:PJNIEnv;this:jobject; SelfObj : TObject) : jObject;
const
 _cFuncName = 'jForm_Create';
 _cFuncSig  = '(J)Ljava/lang/Object;';
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 //gVM^.AttachCurrentThread(gVm,@env,nil);
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.j := Int64(SelfObj);
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Result := env^.NewGlobalRef(env,Result);
end;

//
Procedure jForm_Free(env:PJNIEnv; this:jobject; Form    : jObject);
Const
 _cFuncName = 'jForm_Free';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := Form;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 env^.DeleteGlobalRef(env,Form);
end;

//by jmpessoa
Procedure jForm_Free2(env:PJNIEnv; this:jobject; Form: jObject);
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env, Form, method);
  env^.DeleteGlobalRef(env,Form);
end;

//
Procedure jForm_Show (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);
Const
 _cFuncName = 'jForm_Show';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Form;
 _jParams[1].i := effect;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jForm_Show2(env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);
var
   cls: jClass;
   method: jmethodID;
    _jParams : Array[0..0] of jValue;
begin
    _jParams[0].i:= effect;
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'Show', '(I)V');
    env^.CallVoidMethodA(env, Form, method,@_jParams);
end;

Procedure jForm_Close2(env:PJNIEnv; this:jobject; Form: jObject);
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'Close2', '()V');
  env^.CallVoidMethod(env, Form, method);
end;

Procedure jForm_Close(env:PJNIEnv;this:jobject; Form: jObject; effect : Integer);
Const
  _cFuncName = 'jForm_Close';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);    //GetObjectClass(env, obj);"?
  _jParams[0].l := Form;
  _jParams[1].i := effect;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Function  jForm_GetLayout (env:PJNIEnv;this:jobject; Form    : jObject) : jObject;
Const
 _cFuncName = 'jForm_GetLayout';
 _cFuncSig  = '(Ljava/lang/Object;)Landroid/widget/RelativeLayout;';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := Form;
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
end;

//by jmpessoa
Function jForm_GetLayout2(env:PJNIEnv; this:jobject; Form: jObject): jObject;
var
   cls: jClass;
   method: jmethodID;
begin
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'GetLayout', '()Landroid/widget/RelativeLayout;');
    Result:= env^.CallObjectMethod(env, Form, method);
    Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
end;

//by jmpessoa
Function jForm_GetClickListener(env:PJNIEnv; this:jobject; Form: jObject): jObject;
var
   cls: jClass;
   method: jmethodID;
begin
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'GetClikListener', '()Landroid/view/View$OnClickListener;');
    Result:= env^.CallObjectMethod(env, Form, method);
end;

//by jmpessoa
Procedure jForm_FreeLayout(env:PJNIEnv;this:jobject; Layout: jObject);
begin
  env^.DeleteGlobalRef(env, Layout);
end;

Procedure jForm_SetVisibility (env:PJNIEnv; this:jobject; Form : jObject; visible : boolean);
Const
 _cFuncName = 'jForm_SetVisible';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Form;
 _jParams[1].z := JBool(visible);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jForm_SetVisibility2(env:PJNIEnv;this:jobject; Form : jObject; visible : boolean);
var
   cls: jClass;
   method: jmethodID;
   _jParams : array[0..0] of jValue;
begin
    _jParams[0].z := JBool(visible);
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'SetVisible', '(Z)V');
    env^.CallVoidMethodA(env, Form, method, @_jParams);
end;

Procedure jForm_SetEnabled(env:PJNIEnv;this:jobject; Form : jObject; enabled : Boolean);
Const
 _cFuncName = 'jForm_SetEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Form;
 _jParams[1].z := JBool(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

 //by jmpessoa
Procedure jForm_SetEnabled2(env:PJNIEnv;this:jobject; Form : jObject; enabled : Boolean);
var
   cls: jClass;
   method: jmethodID;
   _jParams : array[0..0] of jValue;
begin
   _jParams[0].z := JBool(enabled);
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'SetEnabled', '(Z)V');
    env^.CallVoidMethodA(env, Form, method, @_jParams);
end;

//by jmpessoa
procedure jForm_ShowMessage(env:PJNIEnv; this:jobject; Form:jObject; msg: string);
var
   cls: jClass;
   method: jmethodID;
    _jParams : Array[0..0] of jValue;
begin
 _jParams[0].l:= env^.NewStringUTF(env, pchar(msg) );
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'ShowMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, Form, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
function jForm_GetDateTime(env:PJNIEnv; this:jobject; Form:jObject): string;
var
  _jString: jString;
  _jBoolean: jBoolean;
  cls: jClass;
  method: jmethodID;
begin
  cls:= env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetDateTime', '()Ljava/lang/String;');
  _jString  := env^.CallObjectMethod(env,Form,method);
  case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := string( env^.GetStringUTFChars(env,_jString,@_jBoolean) );
          end;
  end;
end;

procedure jForm_SetWifiEnabled(env: PJNIEnv; this: JObject; _jform: JObject; _status: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_status);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
end;


function jForm_IsWifiEnabled(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsWifiEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
end;

function jForm_GetEnvironmentDirectoryPath(env: PJNIEnv; this: JObject; _jform: JObject; _directory: integer): string;
var
  _jParams: array[0..0] of jValue;
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _cls, 'GetEnvironmentDirectoryPath', '(I)Ljava/lang/String;');
  _jParams[0].i:= _directory;
  _jString:= env^.CallObjectMethodA(env,_jform,_jMethod, @_jParams);
  case _jString = nil of
     True : Result    := '';
     False: begin
             _jBoolean := JNI_False;
             Result:= String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
           end;
  end;
end;

function jForm_GetInternalAppStoragePath(env: PJNIEnv; this: JObject; _jform: JObject): string;
var
 _cls: jClass;
 _jMethod : jMethodID = nil;
 _jString : jstring;
 _jBoolean: jBoolean;
begin
  _cls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _cls, 'GetInternalAppStoragePath', '()Ljava/lang/String;');
  _jString:= env^.CallObjectMethod(env,_jform,_jMethod);
  case _jString = nil of
     True : Result    := '';
     False: begin
             _jBoolean := JNI_False;
             Result:= String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
           end;
  end;
end;

function jForm_CopyFile(env: PJNIEnv; this: JObject; _jform: JObject; _srcFullName: string; _destFullName: string): boolean;
var
   _jBoo: JBoolean;
   _jCls: jClass;
   _jMethod: jmethodID;
   _jParams : Array[0..1] of jValue;
begin
 _jParams[0].l:= env^.NewStringUTF(env, pchar(_srcFullName) );
 _jParams[1].l:= env^.NewStringUTF(env, pchar(_destFullName) );
  _jCls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _jCls, 'CopyFile', '(Ljava/lang/String;Ljava/lang/String;)Z');
  _jBoo:= env^.CallBooleanMethodA(env, _jform, _jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  Result:= boolean(_jBoo);
end;

function jForm_LoadFromAssets(env: PJNIEnv; this: JObject; _jform: JObject; _fileName: string): string;
var
   _jString: jString;
   _jBoolean: JBoolean;
   _jCls: jClass;
   _jMethod: jmethodID;
   _jParams : Array[0..0] of jValue;
begin
 _jParams[0].l:= env^.NewStringUTF(env, pchar(_fileName) );
  _jCls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _jCls, 'LoadFromAssets', '(Ljava/lang/String;)Ljava/lang/String;');
  _jString:= env^.CallObjectMethodA(env, _jform, _jMethod,@_jParams);
  case _jString = nil of
     True : Result    := '';
     False: begin
             _jBoolean := JNI_False;
             Result:= String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
           end;
  end;
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

function jForm_IsSdCardMounted(env: PJNIEnv; this: JObject; _jform: JObject): boolean;
var
   _jBoo: JBoolean;
   _jCls: jClass;
   _jMethod: jmethodID;
begin
  _jCls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _jCls, 'IsSdCardMounted', '()Z');
  _jBoo:= env^.CallBooleanMethod(env, _jform, _jMethod);
  Result:= boolean(_jBoo);
end;

//------------------------------------------------------------------------------
// View
//------------------------------------------------------------------------------

Procedure jView_SetVisible(env:PJNIEnv;this:jobject; view : jObject; visible : Boolean);
Const
 _cFuncName = 'view_SetVisible';
 _cFuncSig  = '(Landroid/view/View;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := view;
 case visible of
   True  : _jParams[1].i := 0; //
   False : _jParams[1].i := 4; //
 end;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_SetVisible2(env:PJNIEnv; this:jobject; view : jObject; visible : Boolean);
var
  method: jmethodID;
  _jParams : array[0..1] of jValue;
    cls: jClass;
begin
  _jParams[0].l := view;
  case visible of
    True  : _jParams[1].i := 0; //
    False : _jParams[1].i := 4; //
  end;
  cls:= Get_gjClass(env);
  method:= env^.GetMethodID(env, cls, 'jView_SetVisible2', '(Landroid/view/View;I)V');
  env^.CallVoidMethodA(env, view, method, @_jParams);
end;

//
Procedure jView_SetBackGroundColor (env:PJNIEnv;this:jobject; view : jObject; color : DWord);
Const
 _cFuncName = 'view_SetBackGroundColor';
 _cFuncSig  = '(Landroid/view/View;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := view;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_SetBackGroundColor2(env:PJNIEnv;this:jobject; view : jObject; color : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
  cls: jClass;
begin
 _jParams[0].l := view;
 _jParams[1].i := color;
 cls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, cls, 'view_SetBackGroundColor', '(Landroid/view/View;I)V');
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jView_Invalidate (env:PJNIEnv;this:jobject; view : jObject);
Const
 _cFuncName = 'view_Invalidate';
 _cFuncSig  = '(Landroid/view/View;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := view;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

//by jmpessoa
Procedure jView_Invalidate2(env:PJNIEnv;this:jobject; view : jObject);
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
 cls: jClass;
begin
 _jParam.l := view;
 cls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, cls, 'view_Invalidate', '(Landroid/view/View;)V');
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

//by jmpessoa
function jView_getLParamHeight(env:PJNIEnv;this:jobject; View : jObject ): integer;
Const
 _cFuncName = 'jView_getLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := View;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
function jView_getLParamHeight2(env:PJNIEnv;this:jobject; View : jObject ): integer;
var
 _jMethod: jMethodID = nil;
 cls: jClass;
begin
  cls:= env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'getLParamHeight', '()I');
 Result:= env^.CallIntMethod(env,View,_jMethod);
end;

//by jmpessoa
function jView_getLParamWidth(env:PJNIEnv;this:jobject; View : jObject): integer;
Const
 _cFuncName = 'jView_getLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := View;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

function jView_getLParamWidth2(env:PJNIEnv;this:jobject; View : jObject): integer;
Var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'getLParamWidth', '()I');
 Result     := env^.CallIntMethod(env,View,_jMethod);
end;

//--------
function JBool( Bool : Boolean ) : byte;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End;
 end;

//------------------------------------------------------------------------------
// System Info
//------------------------------------------------------------------------------

// Get Device Screen
Function  jSysInfo_ScreenWH (env:PJNIEnv;this:jobject;context : jObject) : TWH;
 Const
  _cFuncName = 'getScreenWH';
  _cFuncSig  = '(Landroid/content/Context;)I';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
  _wh      : Integer;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l     := context;
  _wh           := env^.CallIntMethodA(env,this,_jMethod,@_jParam);
  Result.Width  := (_wh shr 16);
  Result.Height := (_wh and $0000FFFF);
  //dbg('Screen : ' + IntToStr(Result.Width) + 'x' + IntTostr(Result.Height));
 end;

// "/data/app/com.kredix-1.apk"
Function  jSysInfo_PathApp(env:PJNIEnv; this:jobject; context : jObject; AppName : String) : String;
 Const
  _cFuncName = 'getPathApp';
  _cFuncSig  = '(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := env^.NewStringUTF(env, pchar(AppName) );
  _jString      := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 // dbg('PathApp:'+ Result);
 end;

// "/data/data/com.kredix/files"
Function  jSysInfo_PathDat  (env:PJNIEnv; this:jobject; context : jObject) : String;
 Const
  _cFuncName = 'getPathDat';
  _cFuncSig  = '(Landroid/content/Context;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := context;
  _jString  := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
  //dbg('PathDat:'+ Result);
 end;

//by jmpessoa
Function  jSysInfo_PathDataBase (env:PJNIEnv;this:jobject;context : jObject) : String;
Const
 _cFuncName = 'getPathDataBase';
 _cFuncSig  = '(Landroid/content/Context;)Ljava/lang/String;';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
 _jString : jString;
 _jBoolean: jBoolean;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := context;
 _jString  := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 //dbg('PathDataBase:'+ Result);
end;

Function  jSysInfo_PathExt             (env:PJNIEnv;this:jobject) : String;
 Const
  _cFuncName = 'getPathExt';
  _cFuncSig  = '()Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jString  := env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
  //dbg('PathExt:'+ Result);
 end;

Function  jSysInfo_PathDCIM            (env:PJNIEnv;this:jobject) : String;
 Const
  _cFuncName = 'getPathDCIM';
  _cFuncSig  = '()Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jString  := env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 // dbg('PathDCIM:'+ Result);
 end;

//by thierrydijoux
Function jSysInfo_Language (env:PJNIEnv; this: jObject; localeType: TLocaleType): String;
Var
 _jCls: jClass;
 _jMethod : jMethodID;
 _jParams : Array[0..0] of jValue;
 _jString : jString;
 _jBoolean: jBoolean;
begin
 _jCls:= env^.GetObjectClass(env, this);
 _jMethod:= env^.GetMethodID(env, _jCls, 'getLocale', '(I)Ljava/lang/String;');
 _jParams[0].i := Ord(localeType);
 _jString  := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 Case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 //dbg('Language:'+ Result);
end;

//------------------------------------------------------------------------------
// Device Info
//------------------------------------------------------------------------------

Function  jSysInfo_DevicePhoneNumber(env:PJNIEnv;this:jobject) : String;
 Const
  _cFuncName = 'getDevPhoneNumber';
  _cFuncSig  = '()Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jString  := env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;  //0
           Result    := string( env^.GetStringUTFChars(Env,_jString, @_jBoolean) );
          end;
  end;
 // dbg('PhoneNumber:'+ Result);
 end;

Function  jSysInfo_DeviceID(env:PJNIEnv;this:jobject) : String;
 Const
  _cFuncName = 'getDevDeviceID';
  _cFuncSig  = '()Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jString  := env^.CallObjectMethod(env,this,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
  //dbg('DeviceID:'+ Result);
 end;

//-------------

Procedure jSystem_SetOrientation(env:PJNIEnv; this:jobject; orientation : Integer);
const
 _cFuncName = 'systemSetOrientation';
 _cFuncSig  = '(I)V';
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.i := orientation;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 //dbg('loasdf');
end;

//by jmpessoa
function jSystem_GetOrientation(env:PJNIEnv; this:jobject): integer;
const
  _cFuncName = 'systemGetOrientation';
  _cFuncSig  = '()I';
var
  _jMethod : jMethodID = nil;
 // _wh      : Integer;
begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  Result        := env^.CallIntMethod(env,this,_jMethod);
end;

//-----
Procedure jClassMethod(FuncName, FuncSig : PChar;
                       env : PJNIEnv; var Class_ : jClass; var Method_ :jMethodID);
var
  tmpClass: jClass;
begin
  if Class_  = nil then
  begin
    //by jmpessoa fix: "FindClass" returns only  local references..."
    tmpClass:= jClass(env^.FindClass(env, gjClassName));
    if tmpClass <> nil then
    begin
       Class_ := env^.NewGlobalRef(env, tmpClass);  //<< -------- jmpessoa fix!
    end;
  end;
  if Method_ = nil then
  begin       //a jmethodID is not an object. So don't need to convert it to a GlobalRef!
    Method_:= env^.GetMethodID( env, Class_ , FuncName, FuncSig);
  end;
end;

//by jmpessoa
function Get_gjClass(env: PJNIEnv): jClass;
begin
  if gjClass {global} = nil then
  begin
     gjClass:= jClass(env^.FindClass(env, gjClassName {global}));
     if gjClass <> nil then gjClass := env^.NewGlobalRef(env, gjClass); //needed for Appi > 13
  end;
  Result:= gjClass;
end;

//------------------------------------------------------------------------------
// View
//------------------------------------------------------------------------------

Function  jView_Create  (env:PJNIEnv;this:jobject;
                         context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jView_Create';
  _cFuncSig  = '(Landroid/content/Context;J)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//by jmpessoa
function jView_Create2(env: PJNIEnv; this:jobject;  SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jView_Create2', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

//
Procedure jView_Free   (env:PJNIEnv;this:jobject; View : jObject);
  Const
   _cFuncName = 'jView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := View;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,View);
  end;

//by jmpessoa
Procedure jView_Free2(env:PJNIEnv;this:jobject; View : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls := env^.GetObjectClass(env, View);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,View,_jMethod);
   env^.DeleteGlobalRef(env,View);
end;

//
Procedure jView_setXYWH(env:PJNIEnv;this:jobject;
                        View : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := View;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        View : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jView_setParent(env:PJNIEnv;this:jobject;
                          View : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := View;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jView_setjCanvas(env:PJNIEnv; this:jobject;
                           View : jObject;jCanvas : jObject);
 Const
  _cFuncName = 'jView_setjCanvas';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/Object;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := View;
  _jParams[1].l := jCanvas;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jView_setjCanvas2(env:PJNIEnv; this:jobject;
                           View : jObject;jCanvas : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := jCanvas;
   cls := env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'setjCanvas', '(Ljava/lang/Object;)V');
  env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-14
Procedure jView_viewSave (env:PJNIEnv; this:jobject;
                          View : jObject; Filename : String);
Const
 _cFuncName = 'jView_saveView';
 _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].l := env^.NewStringUTF(env, pchar(Filename) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

Procedure jView_viewSave2(env:PJNIEnv; this:jobject;
                          View : jObject; Filename : String);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(Filename) );
   cls := env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'saveView2', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;


//by jmpessoa
Procedure jView_setId(env:PJNIEnv;this:jobject; View : jObject; id: DWord);
Const
 _cFuncName = 'jView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jView_setMarginLeft(env:PJNIEnv;this:jobject; View: jObject; x: DWord);
Const
 _cFuncName = 'jView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_setMarginTop(env:PJNIEnv;this:jobject; View: jObject; y: DWord);
Const
 _cFuncName = 'jView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jView_setMarginRight(env:PJNIEnv;this:jobject; View: jObject; x: DWord);
Const
 _cFuncName = 'jView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_setMarginBottom(env:PJNIEnv;this:jobject; View: jObject; y: DWord);
Const
 _cFuncName = 'jView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_setLParamWidth2(env:PJNIEnv;this:jobject; View : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, View);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

Procedure jView_setLParamWidth(env:PJNIEnv;this:jobject; View : jObject; w: DWord);
Const
 _cFuncName = 'jView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_setLParamHeight(env:PJNIEnv;this:jobject; View : jObject; h: DWord);
Const
 _cFuncName = 'jView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jView_setLParamHeight2(env:PJNIEnv;this:jobject; View : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_addLParamsParentRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Const
 _cFuncName = 'jView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
procedure jView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
const
 _cFuncName = 'jView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
procedure jView_setLayoutAll(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);
const
 _cFuncName = 'jView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

procedure jView_setLayoutAll2(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

end.

