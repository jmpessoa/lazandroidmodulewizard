unit AndroidWidget;

//Lazarus Android Module Wizard: Form Designer and Components development model!
//Author: jmpessoa@hotmail.com
//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

{$mode delphi}

{$SMARTLINK ON}

interface

uses
  Classes, SysUtils, Math, types, And_jni, CustApp;

type
  TAndroidLayoutType = (altMATCHPARENT,altWRAPCONTENT);

const

  // Event id for Pascal & Java

  cTouchDown            = 0;
  cTouchMove            = 1;
  cTouchUp              = 2;

  cRenderer_onGLCreate  = 0;
  cRenderer_onGLChange  = 1;
  cRenderer_onGLDraw    = 2;
  cRenderer_onGLDestroy = 3;
  cRenderer_onGLThread  = 4;


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
  TARGBColorBridgeArray: array[0..144] of DWord = (
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
    $FF90EE90,$FF9370D8,$FF9400D3,$00000000,$00000000);

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

  TLayoutParamsArray: array[TAndroidLayoutType] of DWord =
  (
    $ffffffff, // match_parent  = -1
    $fffffffe  // wrap_contents = -2
  );

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

  //
  cjORIENTATION_PORTRAIT                 =  1;
  cjORIENTATION_LANDSCAPE                =  2;
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

  TSpeechLanguage = ( slDefault,
                      slCanada,
                      slCanadaFrench,
                      slChinese,
                      slEnglish,
                      slFrench,
                      slGerman,
                      slItalian,
                      slJapanese,
                      slKorean,
                      slSimplifiedChinese,
                      slTaiwan,
                      slTraditionalChinese,
                      slUK,
                      slUS);

 TTextDirection = (tdInherit,tdFirstStrong, tdAnyRTL, tdLTR, tdRTL);

 TCompoundDrawablesSide = (cdsLeft, cdsRight, cdsAbove, cdsBelow);

 TOnBeforeDispatchDraw = procedure(Sender: TObject; canvas: JObject; tag: integer) of Object;
 TOnAfterDispatchDraw = procedure(Sender: TObject; canvas: JObject; tag: integer) of Object;
 TOnLayouting = procedure(Sender: TObject; changed: boolean) of Object;

 TConnectionType = (ctMobile, ctWifi, ctBluetooch, ctEthernet);

 TNetworkStatus = (nsOff, nsWifiOn, nsMobileDataOn);

 TAndroidResult = (RESULT_OK = -1, RESULT_CANCELED = 0);

 TImageScaleType = (scaleCenter, scaleCenterCrop, scaleCenterInside, scaleFitCenter,
                scaleFitEnd, scaleFitStart, scaleFitXY, scaleMatrix);

 TPinchZoomScaleState = (pzScaleBegin, pzScaling, pzScaleEnd, pzNone);
 TFlingGesture = (fliRightToLeft, fliLeftToRight, fliBottomToTop, fliTopToBottom);  // on swipe!

 TOnFling = procedure(Sender: TObject; flingGesture: TFlingGesture) of Object;
 TOnPinchZoom = procedure(Sender: TObject; scaleFactor: single; scaleState: TPinchZoomScaleState) of Object;

 TTouchPoint = record
       X: single;
       Y: single;
 end;

 TOnTouchExtended = procedure(Sender: TObject; countXY: integer;
                                 X: array of single;  Y: array of single;
                                 flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single) of Object;


 TDynArrayOfSmallint = array of smallint;

 TDynArrayOfInteger = array of integer;

 TDynArrayOfLongint = array of longint;
 TDynArrayOfDouble = array of double;
 TDynArrayOfSingle = array of single;
 TDynArrayOfInt64  = array of int64;
 TDynArrayOfString = array of string;

 TDynArrayOfJChar = array of JChar;
 TDynArrayOfJBoolean = array of JBoolean;
 TDynArrayOfJByte = array of JByte;

 TArrayOfByte = array of JByte;
 TArrayOfJByte = array of JByte;

 TScanByte = Array[0..0] of JByte;
 PScanByte = ^TScanByte;

 TScanLine = Array[0..0] of DWord;
 PScanLine = ^TScanline;

 TItemLayout = (layImageTextWidget, layWidgetTextImage, layText);

 TToggleState = (tsOff, tsOn);

  TOnClickToggleButton = procedure (Sender: TObject; state: boolean) of Object;

  TWidgetItem = (wgNone,wgCheckBox,wgRadioButton,wgButton,wgTextView, wgEditText);

  // thierrydijoux - locale type def
 TLocaleType = (ltCountry = 0, ltDisplayCountry = 1, ltDisplayLanguage = 2,
                ltDisplayName = 3, ltDisplayVariant = 4, ltIso3Country = 5,
                ltIso3Language = 6, ltVariant = 7);


  TWH = Record
        Width : Integer;
        Height: Integer;
       End;

  TScreenResolution = (sr320x480, // <-- phones
                       sr480x800,
                       sr480x854,
                       sr540x960,
                       sr1280x720, //HD
                       sr1920x1080, //Full HD
                        sr1024x600,  // <-- tablets
                        sr1280x800,
                        {sr1920x1080,}
                        sr2048x1536,
                        sr2560x1440,
                        sr2560x1600);


  TImeOptions = (imeFlagNoFullScreen,
                 imeActionNone,
                 imeActionGo,
                 imeActionSearch,
                 imeActionSend,
                 imeActionNext,
                 imeActionDone,
                 imeActionPrevious,
                 imeFlagForceASCII);

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
  colbrLightGreen,colbrMediumPurple,colbrDarkViolet,colbrNone, colbrDefault, colbrCustom);  //default=transparent!

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

  TTextDecorated = (txtNormal,
                    txtNormalAndItalic,
                    txtNormalAndBold,
                    txtBold,
                    txtBoldAndNormal,
                    txtBoldAndItalic,
                    txtItalic,
                    txtItalicAndNormal,
                    txtItalicAndBold);

  TTextSizeDecorated = (sdNone, sdDecreasing, sdIncreasing);

  TTextAlign = (alLeft, alRight, alCenter); //jListView

  TTextAlignment = (taLeft, taRight, taCenter); //others...

 TTextAlignHorizontal = (thLeft, thRight, thCenter);  //jCanvas
 TTextAlignVertical = (tvTop, tvBottom, tvCenter);

  TGravity = (gvBottom, gvCenter, gvCenterHorizontal, gvCenterVertical, gvLeft, gvNoGravity,
              gvRight, gvStart, gvTop, gvEnd, gvFillHorizontal, gvFillVertical);

  TGravitySet = set of TGravity;

  TShowLength = (slShort, slLong);

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
                    itCapCharacters,
                    itNumber,
                    itPhone,
                    itPassNumber,
                    itPassText,
                    itMultiLine);
  //by jmpessoa
  TInputTypeEx  =(  itxText,
                    itxCapCharacters,
                    itxNumber,
                    itxCurrency,
                    itxPhone,
                    itxNumberPassword,
                    itxTextPassword,
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
  TLayoutParams = (lpMatchParent, lpWrapContent, lpHalfOfParent, lpOneQuarterOfParent, lpTwoThirdOfParent,
                   lpOneThirdOfParent, lpOneEighthOfParent,lpThreeEighthOfParent, lpFiveEighthOfParent,
                   lpSevenEighthOfParent, lpOneSixthOfParent, lpFiveSixthOfParent, lpOneFifthOfParent,
                   lpTwoFifthOfParent, lpThreeFifthOfParent, lpThreeQuarterOfParent,
                   lpFourFifthOfParent, lpNineTenthsOfParent, lp95PercentOfParent, lp99PercentOfParent,
                   lp16px, lp24px, lp32px, lp40px, lp48px, lp72px, lp96px, lpExact, lpUseWeight);

  TSide = (sdW, sdH);

  TScreenStyle   = (ssPortrait  = 1,  //Force Portrait
                    ssLandscape = 2, //Force LandScape
                    ssUnknown   = 3,
                    ssSensor    = 4);   //by Device Status

  //TRotateOrientation = (orientUnknown, orientVertical, orientHorizontal, orientSensor);


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

  //TDeviceType = (dtPhone, dtWatch);

  TTextTypeFace = (tfNormal, tfBold, tfItalic, tfBoldItalic); //by jmpessoa
  TFontFace = (ffNormal, ffSans, ffSerif, ffMonospace);
  //...
  TOnNotify = Procedure(Sender: TObject) of object;
  TViewClick = Procedure(jObjView: jObject; Id: integer) of object;
  TListItemClick = Procedure(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer) of object;

  TOnCallBackData = Procedure(Sender: TObject; strData: string; intData: integer; doubleData: double) of object;

  TOnClickEx         = Procedure(Sender: TObject; Value: integer) of object;

  TOnChange         = Procedure(Sender: TObject; txt: string; count: integer) of object;

  TOnTouch           = Procedure(Sender: TObject; ID: integer; X, Y: single) of object;
  TOnTouchEvent      = Procedure(Sender: TObject; Touch : TMouch ) of Object;
  TOnCloseQuery      = Procedure(Sender: TObject; var CanClose: boolean) of object;

  TOnRotate          = Procedure(Sender: TObject; rotate: TScreenStyle) of Object;
  TOnCanRotate       = Procedure(Sender: TObject; var canRotate: boolean) of Object;

  TOnKeyDown = Procedure(Sender: TObject; keyChar: char; keyCode: integer; keyCodeString:string; var mute: boolean) of Object;

  TActionBarTitle = (abtDefault, abtTextAsTitle, abtTextAsTitleHideLogo, abtHideLogo, abtHide, abtNone);

  TOnOptionMenuItemCreate = Procedure(Sender: TObject; jObjMenu: jObject) of Object;

  TOnPrepareOptionsMenu = Procedure(Sender: TObject; jObjMenu: jObject; menuSize: integer; out prepareItems: boolean) of Object;
  TOnPrepareOptionsMenuItem = Procedure(Sender: TObject; jObjMenu: jObject; jObjMenuItem:jObject; itemIndex: integer; out prepareMoreItems: boolean ) of Object;

  TOnClickOptionMenuItem = Procedure(Sender: TObject; jObjMenuItem: jObject;
                                     itemID: integer; itemCaption: string; checked: boolean) of Object;

  TOnContextMenuItemCreate = Procedure(Sender: TObject; jObjMenu: jObject) of Object;

  TOnClickContextMenuItem = Procedure(Sender: TObject; jObjMenuItem: jObject;
                                     itemID: integer; itemCaption: string; checked: boolean) of Object;

  TOnActivityRst = Procedure(Sender: TObject; requestCode: integer; resultCode: TAndroidResult; intentData: jObject) of Object;

  TOnActivityCreate = Procedure(Sender: TObject; intentData: jObject) of Object;

  TOnNewIntent = Procedure(Sender: TObject; intentData: jObject) of Object;

  TActionBarTabSelected = Procedure(Sender: TObject; view: jObject; title: string) of Object;
  TCustomDialogShow = Procedure(Sender: TObject; dialog: jObject; title: string) of Object;

  TOnGLChange        = Procedure(Sender: TObject; W, H: integer) of object;

  TOnClickYN         = Procedure(Sender: TObject; YN  : TClickYN) of object;
  TOnClickItem       = Procedure(Sender: TObject; itemIndex: Integer) of object;

  TOnClickWidgetItem = Procedure(Sender: TObject; itemIndex: integer; checked: boolean) of object;

  TOnClickCaptionItem = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string) of object;

  TOnWidgeItemLostFocus = Procedure(Sender: TObject; itemIndex: integer; widgetText: string) of object;

  TOnScrollStateChanged = Procedure(Sender: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: boolean) of object;

  TOnEditLostFocus = Procedure(Sender: TObject; textContent: string) of object;

  TOnDrawItemTextColor = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge) of Object;
  TOnDrawItemWidgetTextColor = Procedure(Sender: TObject; itemIndex: integer; widgetText: string; out textColor: TARGBColorBridge) of Object;

  TOnDrawItemBitmap  = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string; out bimap: JObject) of Object;
  TOnDrawItemWidgetBitmap  = Procedure(Sender: TObject; itemIndex: integer; widgetText: string; out bimap: JObject) of Object;

  TOnWebViewStatus   = Procedure(Sender: TObject; Status : TWebViewStatus;
                                 URL : String; Var CanNavi : Boolean) of object;

  TAsyncTaskState = (atsBefore, atsProgress, atsPost, atsInBackground);
  TOnAsyncEvent = Procedure(Sender: TObject; eventType, progress: integer) of object;
  TOnAsyncEventDoInBackground = Procedure(Sender: TObject; progress: integer; out keepInBackground: boolean) of object;
  TOnAsyncEventProgressUpdate = Procedure(Sender: TObject; progress: integer; out progressUpdate: integer) of object;
  TOnAsyncEventPreExecute= Procedure(Sender: TObject; out startProgress: integer) of object;
  TOnAsyncEventPostExecute= Procedure(Sender: TObject; progress: integer) of object;
  // App
  TEnvJni     = record
                 jEnv        : PJNIEnv;  // a pointer reference to the JNI environment,
                 jThis       : jObject;  // a reference to the object making this call (or class if static-> controls.java).
                 jActivity   : jObject;  // Java Activity / android.content.Context
                 jRLayout    : jObject;  // Java Base Relative Layout
                 jIntent     : jObject;  // Java OIntent
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

  { jApp }

  jApp = class(TCustomApplication)
  private
    FInitialized : boolean;
    FAppName     : string;

    FMainActivity: string;
    FPackageName   : string;

    FjClassName   : string;
    FForm        : jForm;       // Main/Initial Form
    //
    Procedure SetAppName  (Value : String);
    Procedure SetjClassName(Value : String);
  protected
    //
  public
    Jni           : TEnvJni;
    Path          : TEnvPath;
    Screen        : TEnvScreen;
    //Device        : TEnvDevice;
    Forms         : TjForms;     // Form Stack
    Lock          : Boolean;     //
    Orientation   : TScreenStyle;   //orientation on app start....

    Locale        : TLocale;    //by thierrydijoux

    ControlsVersionInfo: string; //by jmpessoa

    TopIndex: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; out Reference);
    procedure Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject; intent: jobject);

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

    procedure ShowMessage(_title: string; _message: string; _btnText: string);

    function GetMainActivityName: string;
    function GetPackageName: string;

    //properties
    property Initialized : boolean read FInitialized;
    property Form: jForm read FForm write FForm; // Main Form
    property AppName    : string read FAppName write SetAppName;
    property ClassName  : string read FjClassName write SetjClassName;
    property MainActivityName: string read GetMainActivityName;
    property PackageName  : string read GetPackageName;

  end;

 {jControl by jmpessoa}

  jControl = class(TComponent)
  protected
    FjClass: jObject;
    FClassPath: string; //need by new pure jni model! -->> initialized by widget.Create
    FjObject     : jObject; //jSelf - java object
    FInitialized : boolean;
    FjEnv: PJNIEnv;
    FjThis: jObject;  //java class Controls\libcontrols
    FCustomColor: DWord;
  protected
    FEnabled     : boolean;
    procedure SetEnabled(Value: boolean); virtual;
  public
    procedure UpdateJNI(refApp: jApp); virtual;
    property Initialized : boolean read FInitialized write FInitialized;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); virtual;
    procedure AttachCurrentThread();  overload;
    procedure AttachCurrentThread(env: PJNIEnv); overload;
    property jSelf: jObject read FjObject;
  end;

  { TAndroidWidget }

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

    procedure SetParent(const AValue: TAndroidWidget); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure InternalInvalidateRect({%H-}ARect: TRect; {%H-}Erase: boolean); virtual;
    procedure SetName(const NewName: TComponentName); override;
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

    // tk
    procedure ReassignIDs; virtual;
    // end tk

    property AcceptChildrenAtDesignTime:boolean read FAcceptChildrenAtDesignTime;
    property Parent: TAndroidWidget read FParent write SetParent;
    property Visible: boolean read FVisible write FVisible;
    property Text: string read GetText write SetText;
    property CustomColor: DWord read FCustomColor write FCustomColor;

  published
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    property MarginLeft: integer read FMarginLeft write SetMarginLeft default 3;
    property MarginTop: integer read FMarginTop write SetMarginTop default 3;
    property MarginRight: integer read FMarginRight write SetMarginRight default 3;
    property MarginBottom: integer read FMarginBottom write SetMarginBottom default 3;
    property Enabled     : boolean read FEnabled  write SetEnabled;
  end;

  IAndroidWidgetDesigner = interface(IUnknown)
     procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
  end;

  TAndroidWidgetClass = class of TAndroidWidget;

  { TAndroidForm }

  TAndroidForm = class(TAndroidWidget)
  private
    FAutoAssignIDs: Boolean;
    FDesigner: IAndroidWidgetDesigner;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnAutoAssignIDs: TNotifyEvent;
    procedure SetAutoAssignIDs(AValue: Boolean);
  protected
    procedure InternalInvalidateRect(ARect: TRect; Erase: boolean); override;
    // tk
    procedure Loaded; override;
    // end tk
  public
    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init(refApp: jApp); override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property Designer: IAndroidWidgetDesigner read FDesigner write FDesigner;
    // tk
    property OnAutoAssignIDs: TNotifyEvent read FOnAutoAssignIDs write FOnAutoAssignIDs;
    // end tk
  published
    // tk
    property AutoAssignIDs: Boolean read FAutoAssignIDs write SetAutoAssignIDs default False;
    // end tk
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;


TSimpleRGBAColor = record
  r: single;    //red
  g: single;   //green
  b: single;  //blue
  a: single; //alfa
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

    FScreenWH      : TWH;
    FPackageName: string;

    FScreenStyle   : TScreenStyle;

    FAnimation     : TAnimation;

    FActivityMode  : TActivityMode;
    FActionBarTitle: TActionBarTitle;

    FOnClick      : TOnNotify;
    FOnClose      :   TOnNotify;
    FOnCloseQuery  : TOnCloseQuery;
    FOnRotate      : TOnRotate;

    FOnActivityRst : TOnActivityRst;

    FOnJNIPrompt   : TOnNotify;
    FOnBackButton  : TOnNotify;

    FOnSpecialKeyDown      : TOnKeyDown;
    FActionBarHeight: integer;

    FOnOptionMenuCreate: TOnOptionMenuItemCreate;
    FOnClickOptionMenuItem: TOnClickOptionMenuItem;
    FOnContextMenuCreate: TOnContextMenuItemCreate;
    FOnClickContextMenuItem: TOnClickContextMenuItem;

    FOnPrepareOptionsMenu: TOnPrepareOptionsMenu;
    FOnPrepareOptionsMenuItem: TOnPrepareOptionsMenuItem;
    FOnActivityCreate: TOnActivityCreate;
    //FOnNewIntent: TOnNewIntent;

    //---------------  dummies for compatibility----
   {  FHorizontalOffset: integer;
     FVerticalOffset: integer;
     FOldCreateOrder: boolean;
     FTitle: string;}
    //---------------

    Procedure SetColor   (Value : TARGBColorBridge);
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
    Procedure SetEnabled (Value : Boolean); override;

    function  GetOnViewClickListener(jObjForm: jObject): jObject;
    function  GetOnListItemClickListener(jObjForm: jObject): jObject;

  public

    ScreenStyleAtStart: TScreenStyle;    //device direction [vertical=1 and vertical=2]

    FormState     : TjFormState;
    FormIndex: integer;
    FormBaseIndex: integer;
    Finished: boolean;
    PromptOnBackKey: boolean;
    TryBacktrackOnClose: boolean;
    DoJNIPromptOnShow: boolean;

    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    Procedure GenEvent_OnClick(Obj: TObject);

    procedure Init(refApp: jApp); override;
    procedure Finish;
    Procedure Show;
    Procedure DoJNIPrompt;

    Procedure Close;
    Procedure Refresh;
    procedure ShowMessage(msg: string); overload;
    procedure ShowMessage(_msg: string; _gravity: TGravity; _timeLength: TShowLength); overload;
    function GetDateTime: String;

    function GetStringExtra(intentData: jObject; extraName: string): string;
    function GetIntExtra(intentData: jObject; extraName: string; defaultValue: integer): integer;
    function GetDoubleExtra(intentData: jObject; extraName: string; defaultValue: double): double;

    Procedure SetCloseCallBack(Func : TOnNotify; Sender : TObject);  overload;
    Procedure SetCloseCallBack(Func : TOnCallBackData; Sender : TObject); overload; //by jmpessoa

    Procedure GenEvent_OnViewClick(jObjView: jObject; Id: integer);
    Procedure GenEvent_OnListItemClick(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer);

    procedure UpdateJNI(refApp: jApp); override;

    //by jmpessoa
    Procedure UpdateLayout;

    function SetWifiEnabled(_status: boolean): boolean;
    function IsWifiEnabled(): boolean;
    function isConnected(): boolean; // by renabor
    function isConnectedWifi(): boolean; // by renabor

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
    procedure ShowLogoActionBar(_value: boolean);
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

    //needed: <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
    function GetSystemVersion: Integer;
    function GetDevicePhoneNumber: String;
    function GetDeviceID: String;

    function IsPackageInstalled(_packagename: string): boolean;

    procedure ShowCustomMessage(_panel: jObject; _gravity: TGravity);  overload;
    procedure ShowCustomMessage(_layout: jObject; _gravity: TGravity; _lenghTimeSecond: integer); overload;

    procedure SetScreenOrientationStyle(_orientation: TScreenStyle);
    function  GetScreenOrientationStyle(): TScreenStyle;

    function GetScreenSize(): string;
    function GetScreenDensity(): string;
    procedure LogDebug(_tag: string; _msg: string);
    procedure Vibrate(_milliseconds: integer);  overload;
    procedure Vibrate(var _millisecondsPattern: TDynArrayOfInt64);overload;
    procedure TakeScreenshot(_savePath: string; _saveFileNameJPG: string);
    function GetTitleActionBar(): string;
    function GetSubTitleActionBar(): string;
    function GetFormByIndex(index: integer): jForm;

    function  CopyFromAssetsToInternalAppStorage(_filename: string): string;
    procedure CopyFromInternalAppStorageToEnvironmentDir(_filename: string; _environmentDirPath: string);
    procedure CopyFromAssetsToEnvironmentDir(_filename: string; _environmentDirPath: string);

    function DumpExceptionCallStack(E: Exception): string; //Thanks to Euller and Oswaldo

    function GetActionBarHeight(): integer;
    function ActionBarIsShowing(): boolean;
    procedure ToggleSoftInput();
    function GetDeviceModel(): string;
    function GetDeviceManufacturer(): string;

    procedure SetKeepScreenOn(_value: boolean); //thanks to noisy
    procedure SetTurnScreenOn(_value: boolean);
    procedure SetAllowLockWhileScreenOn(_value: boolean);
    procedure SetShowWhenLocked(_value: boolean);

    function ParseUri(_uriAsString: string): jObject;
    function UriToString(_uri: jObject): string;
    function IsConnectedTo(_connectionType: TConnectionType): boolean;
    function IsMobileDataEnabled(): boolean;

    procedure HideSoftInput(); overload;
    procedure ShowSoftInput();

    function GetNetworkStatus(): TNetworkStatus;
    function GetDeviceWifiIPAddress(): string;
    function GetDeviceDataMobileIPAddress(): string;
    function GetWifiBroadcastIPAddress(): string;
    function LoadFromAssetsTextContent(_filename: string): string;

    function RGBA(color: string): TSimpleRGBAColor;
    function GetPathFromAssetsFile(_assetsFileName: string): string;
    function GetImageFromAssetsFile(_assetsImageFileName: string): jObject;

    function GetAssetContentList(_path: string): TDynArrayOfString;
    function GetDriverList(): TDynArrayOfString;
    function GetFolderList(_envPath: string): TDynArrayOfString;
    function GetFileList(_envPath: string): TDynArrayOfString;

    function FileExists(_fullFileName: string): boolean;
    function DirectoryExists(_fullDirectoryName: string): boolean;

    procedure Minimize();
    procedure Restart(_delay: integer);
    procedure HideSoftInput(_view: jObject); overload;
    function UriEncode(_message: string): string;
    function ParseHtmlFontAwesome(_htmlString: string): string;

    procedure ReInit(refApp: jApp);

    // Property
    property View         : jObject        read FjRLayout; //layout!

    property ScreenStyle  : TScreenStyle   read FScreenStyle    write FScreenStyle;
    property Animation    : TAnimation     read FAnimation      write FAnimation;
    property ScreenWH      : TWH read FScreenWH;

    property CallBackDataString: string read FCBDataString write FCBDataString;
    property CallBackDataInteger: integer read FCBDataInteger write FCBDataInteger;
    property CallBackDataDouble: double read FCBDataDouble write FCBDataDouble;

    property  OnViewClick: TViewClick read FOnViewClick write FOnViewClick;
    property  OnListItemClick: TListItemClick read FOnListItemClick write FOnListItemClick;

    property PackageName: string read FPackageName;
    property ActionBarHeight: integer read GetActionBarHeight;
    //---------------  dummies for compatibility----
    {
    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
    property Title: string read FTitle write FTitle;
    property HorizontalOffset: integer read FHorizontalOffset write FHorizontalOffset;
    property VerticalOffset: integer read FVerticalOffset write FVerticalOffset;
    }
    //--------------------
  published
    property Text: string read GetText write SetText;
    property ActivityMode  : TActivityMode read FActivityMode write FActivityMode;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;
    property ActionBarTitle: TActionBarTitle read FActionBarTitle write FActionBarTitle;

    // Event
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityResult: TOnActivityRst read FOnActivityRst write FOnActivityRst;

    property OnJNIPrompt  : TOnNotify read FOnJNIPrompt write FOnJNIPrompt;

    property OnBackButton : TOnNotify read FOnBackButton write FOnBackButton;
    property OnClose      : TOnNotify read FOnClose write FOnClose;

    property OnSpecialKeyDown    :TOnKeyDown read FOnSpecialKeyDown write FOnSpecialKeyDown;

    property OnCreateOptionMenu: TOnOptionMenuItemCreate read FOnOptionMenuCreate write FOnOptionMenuCreate;
    property OnClickOptionMenuItem: TOnClickOptionMenuItem read FOnClickOptionMenuItem write FOnClickOptionMenuItem;

    property OnPrepareOptionsMenu: TOnPrepareOptionsMenu read FOnPrepareOptionsMenu write FOnPrepareOptionsMenu;
    property OnPrepareOptionsMenuItem: TOnPrepareOptionsMenuItem read FOnPrepareOptionsMenuItem write FOnPrepareOptionsMenuItem;

    property OnCreateContextMenu: TOnContextMenuItemCreate read FOnContextMenuCreate write FOnContextMenuCreate;
    property OnClickContextMenuItem: TOnClickContextMenuItem read FOnClickContextMenuItem write FOnClickContextMenuItem;

    property OnActivityCreate: TOnActivityCreate read FOnActivityCreate write FOnActivityCreate;
    //property OnNewIntent: TOnNewIntent read FOnNewIntent write FOnNewIntent;
  end;

  {jVisualControl}

  TFontSizeUnit =(unitDefault, unitPixel, unitDIP, {unitInch,} unitMillimeter, unitPoint, unitScaledPixel);

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
    FScreenStyle    : TScreenStyle;
    //FTextAlignment: TTextAlignment;

    FFontSize     : DWord;
    FFontSizeUnit: TFontSizeUnit;

    FFontColor     : TARGBColorBridge;
    FFontFace: TFontFace;
    FTextTypeFace: TTextTypeFace;
    FHintTextColor: TARGBColorBridge;

    FAnchorId     : integer;
    FAnchor       : jVisualControl;
    FPositionRelativeToAnchor: TPositionRelativeToAnchorIDSet;
    FPositionRelativeToParent: TPositionRelativeToParentSet;

    FLParamWidth: TLayoutParams;
    FLParamHeight: TLayoutParams;

    FOnClick: TOnNotify;
    FOnLongClick: TOnNotify;

    FOnBeforeDispatchDraw: TOnBeforeDispatchDraw;
    FOnAfterDispatchDraw: TOnAfterDispatchDraw;
    FOnLayouting: TOnLayouting;

    procedure SetAnchor(Value: jVisualControl);
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetViewParent(Value: jObject);  virtual;
    function GetViewParent: jObject;  virtual;

    procedure SetVisible(Value: boolean);

    procedure SetParentComponent(Value: TComponent); override;

    procedure SetParamHeight(Value: TLayoutParams); virtual;
    procedure SetParamWidth(Value: TLayoutParams);  virtual;

    //procedure SetFontFace(AValue: TFontFace); virtual;
    //procedure SetFontColor(AValue: TARGBColorBridge); virtual;
    //procedure SetFontSize(AValue : DWord); virtual;
    //procedure SetTextTypeFace(Value: TTextTypeFace); virtual;
    //procedure SetHintTextColor(Value: TARGBColorBridge); virtual;

    function GetView: jObject; virtual;

    // tk
    function InternalIDExistsInParent(const ID: DWord): Boolean; virtual;
    function InternalIDExistsInChildren(const ID: DWord): Boolean; virtual;
    function InternalNewIDFromParent: DWord; virtual;
    procedure SetParent(const AValue: TAndroidWidget); override;
    // end tk

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // tk
    procedure AssignNewId; virtual;
    function IDExistsInParent: Boolean; virtual;
    // end tk

    procedure Init(refApp: jApp); override;
    procedure UpdateLayout(); virtual;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    procedure SetId(_id: DWord);

    property AnchorId: integer read FAnchorId write FAnchorId;
    property ScreenStyle   : TScreenStyle read FScreenStyle  write FScreenStyle   ;
    property ViewParent {ViewParent}: jObject  read  GetViewParent write SetViewParent; // Java : Parent Relative Layout

    property View: jObject read GetView;     //FjObject; //View/Layout

    //property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    //property FontSize: DWord read FFontSize write SetFontSize;
    //property FontFace: TFontFace read FFontFace write SetFontFace;
    //property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    //property HintTextColor: TARGBColorBridge read FHintTextColor write SetHintTextColor;

  published
    property Visible: boolean read FVisible write SetVisible;
    property Anchor  : jVisualControl read FAnchor write SetAnchor;
    property Id: DWord read FId write SetId; //FId; // quickfix #25
    property PosRelativeToAnchor: TPositionRelativeToAnchorIDSet read FPositionRelativeToAnchor
                                                                       write FPositionRelativeToAnchor;
    property PosRelativeToParent: TPositionRelativeToParentSet read FPositionRelativeToParent
                                                               write FPositionRelativeToParent;
    property LayoutParamWidth: TLayoutParams read FLParamWidth write SetParamWidth;
    property LayoutParamHeight: TLayoutParams read FLParamHeight write SetParamHeight;
end;

  Function InputTypeToStrEx ( InputType : TInputTypeEx ) : String;
  function SplitStr(var theString: string; delimiter: string): string;
  function GetARGB(customColor: Dword; colbrColor: TARGBColorBridge): DWord;
  function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle ): DWord;
  function GetScrollBarStyle(scrlBarStyle: TScrollBarStyle ): integer;
  function GetPositionRelativeToAnchor(posRelativeToAnchorID: TPositionRelativeToAnchorID): DWord;
  function GetPositionRelativeToParent(posRelativeToParent: TPositionRelativeToParent): DWord;
  function GetLayoutParams(App: jApp; lpParam: TLayoutParams;  side: TSide): DWord;

  function GetLayoutParamsByParent(paren: jVisualControl; lpParam: TLayoutParams;  side: TSide): DWord;
  function GetLayoutParamsByParent2(paren: TAndroidWidget; lpParam: TLayoutParams;  side: TSide): DWord; //old

  function GetLayoutParamsOrd(lpParam: TLayoutParams): DWord;
  function GetLayoutParamsName(ordIndex: DWord): TLayoutParams;

  function GetDesignerLayoutParams(lpParam: TLayoutParams; L: integer): DWord;
  function GetDesignerLayoutByWH(Value: DWord; L: integer): TLayoutParams;

  function GetParamBySide(App: jApp; side: TSide): DWord;

  function GetParamByParentSide(paren: jVisualControl; side: TSide): DWord;
  function GetParamByParentSide2(paren: TAndroidWidget; side: TSide): DWord;

  function GetFilePath(filePath: TFilePath): string;

  function GetGravity(gvValue: TGravity): DWord;

  //Form Event
  Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject; Form : TObject);

  function jForm_GetStringExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string): string;
  function jForm_GetIntExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: integer): integer;
  function jForm_GetDoubleExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: double): double;

  procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _filename: string); overload;
  procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _fullPath: string; _filename: string);  overload;
  procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _environmentDir: integer; _filename: string);  overload;
  function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _dirName: string): string;  overload;
  function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _environmentDir: integer; _dirName: string): string;  overload;
  function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _fullPath: string; _dirName: string): string;  overload;
  function jForm_IsExternalStorageEmulated(env: PJNIEnv; _jform: JObject): boolean;
  function jForm_IsExternalStorageRemovable(env: PJNIEnv; _jform: JObject): boolean;
  function jForm_GetjFormVersionFeatures(env: PJNIEnv; _jform: JObject): string;

  function jForm_GetActionBar(env: PJNIEnv; _jform: JObject): jObject;
  procedure jForm_HideActionBar(env: PJNIEnv; _jform: JObject);
  procedure jForm_ShowActionBar(env: PJNIEnv; _jform: JObject);
  procedure jForm_ShowTitleActionBar(env: PJNIEnv; _jform: JObject; _value: boolean);
  procedure jForm_ShowLogoActionBar(env: PJNIEnv; _jform: JObject; _value: boolean);
  procedure jForm_SetTitleActionBar(env: PJNIEnv; _jform: JObject; _title: string);
  procedure jForm_SetSubTitleActionBar(env: PJNIEnv; _jform: JObject; _subtitle: string);

  procedure jForm_SetIconActionBar(env: PJNIEnv; _jform: JObject; _iconIdentifier: string);

  procedure jForm_SetTabNavigationModeActionBar(env: PJNIEnv; _jform: JObject);
  procedure jForm_RemoveAllTabsActionBar(env: PJNIEnv; _jform: JObject);

  function jForm_GetStringResourceId(env: PJNIEnv; _jform: JObject; _resName: string): integer;

  function jForm_GetStringResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): string;
  function jForm_GetDrawableResourceId(env: PJNIEnv; _jform: JObject; _resName: string): integer;
  function jForm_GetDrawableResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): jObject;
  function jForm_GetQuantityStringByName(env: PJNIEnv; _jform: JObject; _resName: string; _quantity: integer): string;
  function jForm_GetStringResourceByName(env: PJNIEnv; _jform: JObject; _resName: string): string;

  function jForm_IsPackageInstalled(env: PJNIEnv; _jform: JObject; _packagename: string): boolean;

  procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer); overload;
  procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer; _lenghTimeSecond: integer); overload;

  procedure jForm_SetScreenOrientation(env: PJNIEnv; _jform: JObject; _orientation: integer);
  function jForm_GetScreenOrientation(env: PJNIEnv; _jform: JObject): integer;

  function jForm_GetScreenDensity(env: PJNIEnv; _jform: JObject): string;
  function jForm_GetScreenSize(env: PJNIEnv; _jform: JObject): string;
  procedure jForm_LogDebug(env: PJNIEnv; _jform: JObject; _tag: string; _msg: string);

  procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; _milliseconds: integer); overload;
  procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; var _millisecondsPattern: TDynArrayOfInt64); overload;
  procedure jForm_TakeScreenshot(env: PJNIEnv; _jform: JObject; _savePath: string; _saveFileNameJPG: string);

  function jForm_GetTitleActionBar(env: PJNIEnv; _jform: JObject): string;
  function jForm_GetSubTitleActionBar(env: PJNIEnv; _jform: JObject): string;

  function jForm_CopyFromAssetsToInternalAppStorage(env: PJNIEnv; _jform: JObject; _filename: string): string;
  procedure jForm_CopyFromInternalAppStorageToEnvironmentDir(env: PJNIEnv; _jform: JObject; _filename: string; _environmentDir: string);
  procedure jForm_CopyFromAssetsToEnvironmentDir(env: PJNIEnv; _jform: JObject; _filename: string; _environmentDir: string);

  function jForm_GetActionBarHeight(env: PJNIEnv; _jform: JObject): integer;
  function jForm_ActionBarIsShowing(env: PJNIEnv; _jform: JObject): boolean;

  procedure jForm_ToggleSoftInput(env: PJNIEnv; _jform: JObject);
  function jForm_GetDeviceModel(env: PJNIEnv; _jform: JObject): string;
  function jForm_GetDeviceManufacturer(env: PJNIEnv; _jform: JObject): string;

  procedure jForm_SetKeepScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
  procedure jForm_SetTurnScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
  procedure jForm_SetAllowLockWhileScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
  procedure jForm_SetShowWhenLocked(env: PJNIEnv; _jform: JObject; _value: boolean);

  function jForm_ParseUri(env: PJNIEnv; _jform: JObject; _uriAsString: string): jObject;
  function jForm_UriToString(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
  function jForm_IsConnectedTo(env: PJNIEnv; _jform: JObject; _connectionType: integer): boolean;
  function jForm_IsMobileDataEnabled(env: PJNIEnv; _jform: JObject): boolean;

  procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject); overload;
  procedure jForm_ShowSoftInput(env: PJNIEnv; _jform: JObject);

  function jForm_GetNetworkStatus(env: PJNIEnv; _jform: JObject): integer;
  function jForm_GetDeviceDataMobileIPAddress(env: PJNIEnv; _jform: JObject): string;
  function jForm_GetDeviceWifiIPAddress(env: PJNIEnv; _jform: JObject): string;
  function jForm_GetWifiBroadcastIPAddress(env: PJNIEnv; _jform: JObject): string;

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

function jApp_GetAssetContentList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
function jApp_GetDriverList(env: PJNIEnv; this: JObject): TDynArrayOfString;
function jApp_GetFolderList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
function jApp_GetFileList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;

Procedure jApp_Finish                  (env:PJNIEnv;this:jobject);

//by jmpessoa
Procedure jApp_Finish2                  (env:PJNIEnv;this:jobject);
function  jApp_GetContext               (env:PJNIEnv;this:jobject): jObject;
function jApp_GetControlsVersionInfo(env:PJNIEnv;this:jobject): string;

function  jForm_GetOnViewClickListener        (env:PJNIEnv; Form: jObject): jObject;
function  jForm_GetOnListItemClickListener    (env:PJNIEnv; Form: jObject): jObject;

Procedure jApp_KillProcess             (env:PJNIEnv;this:jobject);
Procedure jApp_ScreenStyle             (env:PJNIEnv;this:jobject; screenstyle : integer);

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
Procedure jForm_Free2                   (env:PJNIEnv; Form    : jObject);
Procedure jForm_Show2                   (env:PJNIEnv; Form    : jObject; effect : Integer);
Procedure jForm_Close2                  (env:PJNIEnv;  Form: jObject);

Function  jForm_GetLayout2(env:PJNIEnv; Form    : jObject) : jObject;
Function jForm_GetView(env:PJNIEnv; Form: jObject): jObject;

Function jForm_GetClickListener(env:PJNIEnv;  Form: jObject): jObject;
Procedure jForm_FreeLayout              (env:PJNIEnv; Layout    : jObject);
Procedure jForm_SetVisibility2          (env:PJNIEnv; Form    : jObject; visible : boolean);
Procedure jForm_SetEnabled2             (env:PJNIEnv;Form    : jObject; enabled : Boolean);
procedure jForm_ShowMessage(env:PJNIEnv; Form:jObject; msg: string); overload;
procedure jForm_ShowMessage(env: PJNIEnv; _jform: JObject; _msg: string; _gravity: integer; _timeLength: integer); overload;

function jForm_GetDateTime(env:PJNIEnv; Form:jObject): string;

function jForm_SetWifiEnabled(env: PJNIEnv; _jform: JObject; _status: boolean): boolean;

function jForm_IsWifiEnabled              (env: PJNIEnv;  _jform: JObject): boolean;
function jForm_IsConnected              (env: PJNIEnv;  _jform: JObject): boolean;
function jForm_IsConnectedWifi              (env: PJNIEnv;  _jform: JObject): boolean;

function jForm_GetEnvironmentDirectoryPath(env: PJNIEnv;  _jform: JObject; _directory: integer): string;
function jForm_GetInternalAppStoragePath(env: PJNIEnv;  _jform: JObject): string;
function jForm_CopyFile(env: PJNIEnv;  _jform: JObject; _srcFullName: string; _destFullName: string): boolean;
function jForm_LoadFromAssets(env: PJNIEnv;  _jform: JObject; _fileName: string): string;
function jForm_IsSdCardMounted(env: PJNIEnv;  _jform: JObject): boolean;
function jForm_LoadFromAssetsTextContent(env: PJNIEnv; _jform: JObject; _filename: string): string;
function jForm_GetPathFromAssetsFile(env: PJNIEnv; _jform: JObject; _assetsFileName: string): string;
function jForm_GetImageFromAssetsFile(env: PJNIEnv; _jform: JObject; _assetsImageFileName: string): jObject;

function jForm_GetAssetContentList(env: PJNIEnv; _jform: JObject; _path: string): TDynArrayOfString;
function jForm_GetDriverList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;
function jForm_GetFolderList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;

function jForm_FileExists(env: PJNIEnv; _jform: JObject; _fullFileName: string): boolean;
function jForm_DirectoryExists(env: PJNIEnv; _jform: JObject; _fullDirectoryName: string): boolean;

procedure jForm_Minimize(env: PJNIEnv; _jform: JObject);
procedure jForm_Restart(env: PJNIEnv; _jform: JObject; _delay: integer);
procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject; _view: jObject);  overload;
function jForm_UriEncode(env: PJNIEnv; _jform: JObject; _message: string): string;
function jForm_ParseHtmlFontAwesome(env: PJNIEnv; _jform: JObject; _htmlString: string): string;

//------------------------------------------------------------------------------
// View  - Generics
//------------------------------------------------------------------------------

Procedure View_SetVisible             (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean); overload;

Procedure View_SetVisible             (env:PJNIEnv;view : jObject; visible : Boolean); overload;


Procedure View_SetId                  (env:PJNIEnv;this:jobject; view : jObject; Id: DWord); overload;
Procedure View_SetId                  (env:PJNIEnv; view : jObject; Id :DWord); overload;

Procedure View_SetBackGroundColor     (env:PJNIEnv;this:jobject; view : jObject; color : DWord);  overload;
Procedure View_SetBackGroundColor     (env:PJNIEnv;view : jObject; color : DWord);  overload;

Procedure View_Invalidate             (env:PJNIEnv;this:jobject; view : jObject); overload;
Procedure View_Invalidate             (env:PJNIEnv; view : jObject); overload;
Procedure View_PostInvalidate(env:PJNIEnv; view : jObject);

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

function jSysInfo_GetSystemVersion(env: PJNIEnv; _jform: JObject) : Integer;
Function  jSysInfo_DevicePhoneNumber   (env:PJNIEnv;this:jobject) : String;
Function  jSysInfo_DeviceID            (env:PJNIEnv;this:jobject) : String;

//-------------

  Procedure jSystem_ShowAlert(env:PJNIEnv; this:jobject; _title: string; _message: string; _btnText: string);
  Procedure jSystem_SetOrientation       (env:PJNIEnv;this:jobject; orientation : Integer);
  function jSystem_GetOrientation        (env:PJNIEnv;this:jobject): integer;
  Procedure jClassMethod(FuncName, FuncSig : PChar;
                       env : PJNIEnv; var Class_ : jClass; var Method_ :jMethodID);
  function Get_gjClass(env: PJNIEnv): jClass;

//-----
// Helper Function
Function  xy  (x, y: integer): TXY;
Function  xyWH(x, y, w, h: integer): TXYWH;
Function  fxy (x, y: Single): TfXY;
Function  getAnimation(i,o : TEffect ): TAnimation;
function DoTouchPoint(x, y: Single): TTouchPoint;
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

  procedure jForm_ShowMessageAsync(env:PJNIEnv; Form:jObject; msg: string);

  procedure Java_Event_pAppOnCreate(env: PJNIEnv; this: jobject; context:jobject;  layout:jobject; intent: jobject);

var
  gApp:       jApp;       //global App !
  gVM         : PJavaVM;
  gjClass     : jClass = nil;
  gDbgMode    : Boolean;
  gjAppName   : PChar; // Ex 'com.kredix';
  gjClassName : PChar; // Ex 'com/kredix/Controls';

  ActivityModeDesign: TActivityMode = actMain;
  //ActionBarTitleDesign: TActionBarTitle = abtDefault;


implementation

procedure Java_Event_pAppOnCreate(env: PJNIEnv; this: jobject; context:jobject; layout:jobject; intent: jobject);
begin
  gApp.Init(env,this,context,layout, intent);
end;

//------------------------------------------------------------------------------
//  Helper Function
//------------------------------------------------------------------------------
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

function DoTouchPoint(x, y: Single): TTouchPoint;
begin
  Result.X := x;
  Result.Y := y;
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
   itCapCharacters: Result := 'CAPCHARACTERS'; 
   itNumber     : Result := 'NUMBER';
   itPhone      : Result := 'PHONE';
   itPassNumber : Result := 'PASSNUMBER';
   itPassText   : Result := 'PASSTEXT';
   itMultiLine  : Result:= 'TEXTMULTILINE';
  end;
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
function  csAvg(const A,B : TfXY) : TfXY;
begin
  Result.X := (A.X + B.X) / 2;
  Result.Y := (A.Y + B.Y) / 2;
end;

function  csLen(const A,B : TfXY) : Single;
begin
  Result := Sqrt( (A.X - B.X)*(A.X - B.X) +
                  (A.Y - B.Y)*(A.Y - B.Y) );
end;

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

//by jmpessoa
function Get_gjClass(env: PJNIEnv): jClass;
begin
  if gjClass {global} = nil then
  begin                                   //com/example/appsdl2demo1/Controls
     gjClass:= jClass(env^.FindClass(env, gjClassName {global class name: "../Controls"}));
     if gjClass <> nil then gjClass := env^.NewGlobalRef(env, gjClass); //needed for Appi > 13
  end;
  Result:= gjClass;
end;

   {jControl: by jmpessoa}

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
  FjEnv:= refApp.Jni.jEnv;
  FjThis:= refApp.Jni.jThis;
  FjClass:= Get_jClassLocalRef(FClassPath);  //needed by new direct jni component model...
end;

procedure jControl.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
end;

procedure jControl.UpdateJNI(refApp: jApp);
begin
  FjEnv:= refApp.Jni.jEnv;
  FjThis:= refApp.Jni.jThis;;
end;

procedure jControl.AttachCurrentThread();
begin
  gVM^.AttachCurrentThread(gVm,@FjEnv,nil);
end;

procedure jControl.AttachCurrentThread(env: PJNIEnv);
begin
  gVM^.AttachCurrentThread(gVm,@env,nil);
end;


{ TAndroidWidget }

constructor TAndroidWidget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParent:= nil;
  FChilds:=TFPList.Create;
  {FMarginLeft  := 5;
  FMarginRight  := 5;
  FMarginBottom := 5;
  FMarginTop    := 5;}
  FHeight       := 100;
  FWidth        := 100;
  FAcceptChildrenAtDesignTime:= False;
  FColor:= colbrDefault;
  FFontColor:= colbrDefault;
  FCustomColor:= $FF2C2F3E;    // <<--- thanks to Ps
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
    SetBounds(AValue,Top,Width,Height)
  else
    FLeft := AValue;
end;

procedure TAndroidWidget.SetTop(const AValue: integer);
begin
  if (csDesigning in ComponentState) then
    SetBounds(Left,AValue,Width,Height)
  else
    FTop := AValue;
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

procedure TAndroidWidget.ReassignIDs;
var
  I: Integer;
  Widget: TAndroidWidget;
  NewID: DWord;
begin
  // Reassign IDs when holes found, this makes 'nice' IDs from those assigned by older LAMW versions
  NewID := 1;
  for I := 0 to ChildCount - 1 do
  begin
    Widget := Children[I];
    if Widget is jVisualControl then
    begin
      jVisualControl(Widget).FId := NewId; // directly set property value
      Inc(NewId);
    end;
    Widget.ReassignIDs; // reassign IDs for all children
  end;
end;

function TAndroidWidget.ChildCount: integer;
begin
  Result:=FChilds.Count;
end;

procedure TAndroidWidget.SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer);
begin
  if (Left=NewLeft) and (Top=NewTop) and (Width=NewWidth) and (Height=NewHeight) then Exit;
  FLeft:=NewLeft;
  FTop:=NewTop;
  FWidth:=NewWidth;
  FHeight:=NewHeight;
  if (csDesigning in ComponentState) then
    if Assigned(Parent) then
      Parent.Invalidate
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

{jVisualControl}

constructor jVisualControl.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FjPRLayout := nil;  //java parent
  FjObject    := nil; //java object
  FEnabled   := True;
  FVisible   := True;

  FColor     := colbrDefault;  //background
  FFontColor := colbrDefault;
  FFontFace := ffNormal;

  FFontSize  := 0; //default size!

  FFontSizeUnit:= unitDefault; //  --> unitScaledPixel!

  FId        := 0; //0: no control anchored on this control!
  FAnchorId  := -1;  //dummy
  FAnchor    := nil;
  //FGravity:=[];      TODO!
  FPositionRelativeToAnchor:= [];
  FPositionRelativeToParent:= [];

  FHintTextColor:= colbrDefault;
end;

//
destructor jVisualControl.Destroy;
begin
  inherited Destroy;
end;

procedure jVisualControl.AssignNewId;
begin
  ID := InternalNewIDFromParent;
end;

function jVisualControl.IDExistsInParent: Boolean;
begin
  Result := InternalIDExistsInParent(ID);
end;


procedure jVisualControl.Init(refApp: jApp);
begin
  inherited Init(refApp);
  FjPRLayout := jForm(Owner).View;  //set default ViewParent/FjPRLayout as jForm.View!
  FScreenStyle := jForm(Owner).ScreenStyle;
  if (PosRelativeToAnchor = []) and (PosRelativeToParent = []) then
  begin
    FMarginLeft := FLeft;
    FMarginTop := FTop;
  end;
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

        // tk
(*
        if Value.Initialized then  //added to run time component create!
        begin
          if Value.Id = 0 then
          begin
            //Randomize;
            //Value.Id:= Random(10000000);
            Value.SetId(Random(10000000){Value.Id}); //JNI call
          end;
        end;

        if not (csDesigning in ComponentState) then Exit;
        if (csLoading in ComponentState) then Exit;

        if Value.Id = 0 then   //Id must be published for data persistence!
        begin
          //Randomize;
          Value.Id:= Random(10000000);  //warning: remember the law of Murphi...
        end;
*)
        // end tk

     end;
  end;
end;

procedure jVisualControl.SetParent(const AValue: TAndroidWidget);
begin
  inherited SetParent(AValue);
  if (ID = 0) or IDExistsInParent then
    AssignNewId;
end;

procedure jVisualControl.SetParentComponent(Value: TComponent);
begin
  Parent := TAndroidWidget(Value);
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

function jVisualControl.GetView: jObject;
begin
  Result:= FjObject;
end;

function jVisualControl.InternalIDExistsInParent(const ID: DWord): Boolean;
var
  I: Integer;
  Widget: TAndroidWidget;
begin
  Result := False;
  if HasParent then
  begin
    for I := 0 to Parent.ChildCount - 1 do
    begin
      Widget := Parent.Children[I];
      if (Widget is jVisualControl) and (Widget <> Self) then
        if jVisualControl(Widget).Id = ID then
          Exit(True);
    end;
  end;
end;

function jVisualControl.InternalIDExistsInChildren(const ID: DWord): Boolean;
var
  I: Integer;
  Widget: TAndroidWidget;
begin
  Result := False;
  for I := 0 to ChildCount - 1 do
  begin
    Widget := Children[I];
    if Widget is jVisualControl then
      if jVisualControl(Widget).Id = ID then
        Exit(True);
  end;
end;

function jVisualControl.InternalNewIDFromParent: DWord;
var
  I: Integer;
  Widget: TAndroidWidget;
  MaxID: DWord;
begin
  MaxID := 0;
  if HasParent then
  begin
    MaxID := jVisualControl(Parent).Id;  //try fix jRadioGroup
    for I := 0 to Parent.ChildCount - 1 do
    begin
      Widget := Parent.Children[I];
      if (Widget is jVisualControl) and (Widget <> Self) then
        MaxID := Max(MaxID, jVisualControl(Widget).Id);
    end;
  end;
  Result := MaxID + 1;
end;

function jVisualControl.GetWidth: integer;
begin
   Result:= FWidth;
end;

function jVisualControl.GetHeight: integer;
begin
   Result:= FHeight
end;

procedure jVisualControl.SetVisible(Value: boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jVisualControl.DefineProperties(Filer: TFiler);
begin
 inherited DefineProperties(Filer);
  {Define new properties and reader/writer methods }
  //quickfix #25
  //Filer.DefineProperty('Id', ReadIntId, WriteIntId, True);
end;

procedure jVisualControl.ReadIntId(Reader: TReader);
begin
  FId:= Reader.ReadInteger;
end;

procedure jVisualControl.WriteIntId(Writer: TWriter);
begin
  Writer.WriteInteger(FId);
end;

procedure jVisualControl.SetId(_id: DWord);
begin
  // tk
  if InternalIDExistsInParent(_id) then
    FId := InternalNewIDFromParent // silently assign a new ID
  else
    FId:= _id;
  // end tk
  if FInitialized then
    View_SetId(FjEnv, FjObject, FId);
end;


// needed by jForm process logic ...
procedure jVisualControl.UpdateLayout();
begin
  //dummy...
end;

procedure jVisualControl.SetParamWidth(Value: TLayoutParams);
begin
  FLParamWidth:= Value;
end;

procedure jVisualControl.SetParamHeight(Value: TLayoutParams);
begin
  FLParamHeight:= Value;
end;

{
procedure jVisualControl.SetTextTypeFace(Value: TTextTypeFace);
begin
  FTextTypeFace:= Value;
end;

procedure jVisualControl.SetFontFace(AValue: TFontFace);
begin
  FFontFace := AValue;
end;

procedure jVisualControl.SetHintTextColor(Value: TARGBColorBridge);
begin
  FHintTextColor:= Value;
end;

 procedure jVisualControl.SetFontColor(AValue: TARGBColorBridge);
 begin
    FFontColor:= AValue;
 end;

 procedure jVisualControl.SetFontSize(AValue : DWord);
 begin
    FFontSize:= AValue;
 end;
 }
  { TAndroidForm }

constructor TAndroidForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TAndroidForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner); //no stream loaded yet.
  FAcceptChildrenAtDesignTime:= True;
  // tk
  FAutoAssignIDs := False;
  // end tk
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

procedure TAndroidForm.SetAutoAssignIDs(AValue: Boolean);
begin
  if FAutoAssignIDs=AValue then Exit;
  FAutoAssignIDs:=AValue;
  if Assigned(FOnAutoAssignIDs) then
    FOnAutoAssignIDs(Self);
end;

procedure TAndroidForm.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
 if (Parent=nil) and (Designer<>nil) then
   Designer.InvalidateRect(Self,ARect,Erase);
end;

procedure TAndroidForm.Loaded;
begin
  inherited Loaded;
  if AutoAssignIDs and (csDesigning in ComponentState) then
    ReassignIDs;
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
  FActivityMode         := ActivityModeDesign; //actMain;  //actMain, actRecyclable, actSplash

  FActionBarTitle:= abtDefault;
  //FActionBarTitle:= ActionBarTitleDesign; //'phone' or 'watch' or

  FOnCloseQuery         := nil;
  FOnClose              := nil;
  FOnRotate             := nil;
  FOnClick              := nil;
  FOnActivityRst        := nil;
  FOnJNIPrompt          := nil;
  FOnSpecialKeyDown     := nil;

  FjObject              := nil;
  FjRLayout{View}       := nil;

  FScreenWH.Height      := 100; //dummy
  FScreenWH.Width       := 100;

  FAnimation.In_        := cjEft_None; //cjEft_FadeIn;
  FAnimation.Out_       := cjEft_None; //cjEft_FadeOut;
  FScreenStyle          := ssUnknown;
  FInitialized          := False;

  FMarginBottom:= 0;
  FMarginLeft:= 0;
  FMarginRight:= 0;
  FMarginTop:= 0;

  FWidth := 320;
  FHeight := 400;
  Finished:= False;

  FormBaseIndex:= -1;  //dummy - main form not have a form base
  FormIndex:= -1;      //dummy

  PromptOnBackKey:= True;
  TryBacktrackOnClose:= False;

  DoJNIPromptOnShow:= True;

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
  if FInitialized and (not Finished) then
  begin
    jForm_FreeLayout(FjEnv, FjRLayout); //free jni jForm Layout global reference
    jForm_Free2(FjEnv, FjObject);
  end;
  inherited Destroy;
end;

procedure jForm.Finish;
begin
  if FInitialized  and (not Finished)  then
  begin
    jForm_FreeLayout(FjEnv, FjRLayout); //free jni jForm Layout global reference
    jForm_Free2(FjEnv, FjObject);
    Finished:= True;
  end;
end;

procedure jForm.Init(refApp: jApp);
var
  i: integer;
begin
  if FInitialized  then Exit;
  if refApp = nil then Exit;
  if not refApp.Initialized then Exit;

  Inherited Init(refApp);

  if FActivityMode = actSplash then
     Randomize; //thanks to Gerrit

  if FActivityMode = actMain then
     Randomize; //thanks to Gerrit

  FScreenStyle:= refApp.Orientation;

  FScreenWH:= refApp.Screen.WH;   //sAved on start!

  FPackageName:= refApp.AppName;

  ScreenStyleAtStart:= FScreenStyle;   //saved on start!

  FjObject:=  jForm_Create(refApp.Jni.jEnv, refApp.Jni.jThis, Self); {jSef}

  FjRLayout:=  jForm_Getlayout2(refApp.Jni.jEnv, FjObject);  {form view/RelativeLayout}

  //thierrydijoux - if backgroundColor is set to black, no theme ...
  if  FColor <> colbrDefault then
     View_SetBackGroundColor(refApp.Jni.jEnv, refApp.Jni.jThis, FjRLayout, GetARGB(FCustomColor, FColor));

  FInitialized:= True;

  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       (Self.Components[i] as jControl).Init(refApp);
    end;
  end;

  jForm_SetEnabled2(refApp.Jni.jEnv, FjObject, FEnabled);

  if gApp.GetCurrentFormsIndex = (cjFormsMax-1) then Exit; //no more form is possible!

  FormBaseIndex:= gApp.TopIndex;           //initial = -1

  if FormIndex < 0 then //if it is a new form .... [not a ReInit form ...]
      FormIndex:= gApp.GetNewFormsIndex;  //first valid index = 0;

  gApp.Forms.Stack[FormIndex].Form    := Self;
  gApp.Forms.Stack[FormIndex].CloseCB := FCloseCallBack;

  FormState := fsFormWork;
  FVisible:= True;

  gApp.TopIndex:= FormIndex;

  if FActionBarTitle = abtHide then
     jForm_HideActionBar(FjEnv, FjObject);

  if FActionBarTitle = abtHideLogo then
      jForm_ShowLogoActionBar(FjEnv, FjObject, False);

  if FActionBarTitle = abtTextAsTitle then
     jForm_SetTitleActionBar(FjEnv, FjObject, FText);

  if FActionBarTitle = abtTextAsTitleHideLogo then
  begin
     jForm_ShowLogoActionBar(FjEnv, FjObject, False);
     jForm_SetTitleActionBar(FjEnv, FjObject, FText);
  end;

  //Show ...
  jForm_Show2(refApp.Jni.jEnv, FjObject, FAnimation.In_);

  if Assigned(FOnActivityCreate) then FOnActivityCreate(Self, refApp.Jni.jIntent);

  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);

end;

procedure jForm.ReInit(refApp: jApp);
var
  i: integer;
begin
  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       (Self.Components[i] as jControl).Initialized:= False;
    end;
  end;
  self.Initialized:= False;
  Self.Init(refApp);
end;

function jForm.GetFormByIndex(index: integer): jForm;
begin
   if index < gApp.GetCurrentFormsIndex then
      Result:= jForm(gApp.Forms.Stack[index].Form)
   else
      Result:=  jForm(gApp.Forms.Stack[gApp.GetCurrentFormsIndex].Form)
end;

procedure jForm.ShowMessage(msg: string);
begin
  jForm_ShowMessage(FjEnv, FjObject, msg);
end;

procedure jForm.ShowMessage(_msg: string; _gravity: TGravity; _timeLength: TShowLength);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowMessage(FjEnv, FjObject, _msg , Ord(_gravity) ,Ord(_timeLength));
end;

function jForm.GetDateTime: String;
begin
  Result:= jForm_GetDateTime(FjEnv,FjObject);
end;

procedure jForm.SetEnabled(Value: Boolean);
begin
  FEnabled:= Value;
  if FInitialized then
    jForm_SetEnabled2(FjEnv, FjObject, FEnabled);
end;

procedure jForm.SetVisible(Value: Boolean);
begin
 FVisible:= Value;
 if FInitialized then
   jForm_SetVisibility2(FjEnv, FjObject, FVisible);
end;

procedure jForm.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
      View_SetBackGroundColor(FjEnv, FjRLayout,GetARGB(FCustomColor, FColor));
end;

procedure jForm.UpdateLayout;
var
  i: integer;
begin
  for i := 0 to (Self.ComponentCount - 1) do   //********
  begin
    if Self.Components[i] is jVisualControl then
    begin
       (Self.Components[i] as jVisualControl).UpdateLayout;
    end;
  end;
end;

procedure jForm.Show;
begin
  if not FInitialized then Exit;
  if FVisible then Exit;

  FormState := fsFormWork;
  FVisible:= True;

  FormBaseIndex:= gApp.TopIndex; //rx3!

  gApp.TopIndex:= Self.FormIndex;

  jForm_Show2(FjEnv,FjObject,FAnimation.In_);

  if DoJNIPromptOnShow then
  begin
    if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
  end;

end;

procedure jForm.DoJNIPrompt;
begin
  if not FInitialized then Exit;
  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);    //*****
end;


{events sequences after user click the "back key"
   OnCanClose
    ...
   OnBackBuutton
    ...
   OnClose
    ...
}

//[1]
procedure jForm.Close;
begin
 // Post Closing Step
 // --------------------------------------------------------------------------
 // Java           Java          Java-> Pascal
 // jForm_Close -> RemoveView -> Java_Event_pOnClose
  jForm_Close2(FjEnv, FjObject);  //close java form...  remove view layout ....
end;

//[2] after java form close......
Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject;  Form : TObject);
var
  Inx: integer;
  formBaseInx: integer;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Form) then exit; //just precaution...

  jForm(Form).UpdateJNI(gApp); //+++

  Inx:= jForm(Form).FormIndex;
  formBaseInx:= jForm(Form).FormBaseIndex;

  gApp.TopIndex:= formBaseInx; //update topIndex...

  if Assigned(jForm(Form).OnClose) then
  begin
    jForm(Form).OnClose(jForm(Form));
  end;

  jForm(Form).FormState := fsFormClose;
  jForm(Form).FVisible:= False;

  if jForm(Form).ActivityMode <> actMain then //actSplash or actRecycable
  begin

      if jForm(gApp.Forms.Stack[formBaseInx].Form).PromptOnBackKey then
         jForm(gApp.Forms.Stack[formBaseInx].Form).DoJNIPrompt; //<<--- thanks to @arenabor

      //LORDMAN - 2013-08-01 // Call Back
      if Assigned(gApp.Forms.Stack[Inx].CloseCB.Event) then
         gApp.Forms.Stack[Inx].CloseCB.Event(gApp.Forms.Stack[Inx].CloseCB.Sender);

      //by jmpessoa Call Back Data
      if Assigned(gApp.Forms.Stack[Inx].CloseCB.EventData) then
         gApp.Forms.Stack[Inx].CloseCB.EventData(gApp.Forms.Stack[Inx].CloseCB.Sender,
                                                 jForm(Form).FCBDataString,
                                                 jForm(Form).FCBDataInteger ,
                                                 jForm(Form).FCBDataDouble);
      //BacktrackOnClose
      if jForm(Form).TryBacktrackOnClose then
      begin
        if formBaseInx <> 0 then
           jForm(gApp.Forms.Stack[formBaseInx].Form).Close;
      end;

  end;

  if jForm(Form).ActivityMode = actMain then  //"The End"
  begin
    jForm(Form).Finish;
    gApp.Finish;
  end;

end;

procedure jForm.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, Self.View);
end;

procedure jForm.SetCloseCallBack(Func: TOnNotify; Sender: TObject);
begin
  FCloseCallBack.Event:= func;
  FCloseCallBack.Sender:= Sender;
end;

procedure jForm.SetCloseCallBack(Func: TOnCallBackData; Sender: TObject);
begin
  FCloseCallBack.EventData:= func;
  FCloseCallBack.Sender:= Sender;
end;

// Event : Java -> Pascal
procedure jForm.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function  jForm.GetOnViewClickListener(jObjForm: jObject): jObject;
begin
  if FInitialized then
    Result:= jForm_GetOnViewClickListener(FjEnv, jObjForm);
end;

function  jForm.GetOnListItemClickListener(jObjForm: jObject): jObject;
begin
  if FInitialized then
    Result:= jForm_GetOnListItemClickListener(FjEnv, jObjForm);
end;

procedure jForm.GenEvent_OnListItemClick(jObjAdapterView: jObject;
  jObjView: jObject; position: integer; Id: integer);
begin
  if FInitialized then
    if Assigned(FOnListItemClick) then FOnListItemClick(jObjAdapterView, jObjView,position,Id);
end;


procedure jForm.GenEvent_OnViewClick(jObjView: jObject; Id: integer);
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

function jForm.GetStringExtra(intentData: jObject; extraName: string): string;
begin
   if FInitialized then
     Result:= jForm_GetStringExtra(FjEnv, FjObject, intentData ,extraName);
end;

function jForm.GetIntExtra(intentData: jObject; extraName: string; defaultValue: integer): integer;
begin
  if FInitialized then
    Result:= jForm_GetIntExtra(FjEnv, FjObject, intentData ,extraName ,defaultValue);
end;

function jForm.GetDoubleExtra(intentData: jObject; extraName: string; defaultValue: double): double;
begin
  if FInitialized then
    Result:= jForm_GetDoubleExtra(FjEnv, FjObject, intentData ,extraName ,defaultValue);
end;

function jForm.SetWifiEnabled(_status: boolean): boolean;
begin
  Result:= False;
  if FInitialized then
   Result:= jForm_SetWifiEnabled(FjEnv, FjObject, _status);
end;

function jForm.IsWifiEnabled(): boolean;
begin
   if FInitialized then
      Result:= jForm_IsWifiEnabled(FjEnv, FjObject);
end;

function jForm.isConnected(): boolean; // by renabor
begin
   if FInitialized then
      Result:= jForm_IsConnected(FjEnv, FjObject);
end;

function jForm.isConnectedWifi(): boolean; // by renabor
begin
   if FInitialized then
      Result:= jForm_IsConnectedWifi(FjEnv, FjObject);
end;

function jForm.GetEnvironmentDirectoryPath(_directory: TEnvDirectory): string;
begin
  Result:='';
  if FInitialized then
    Result:= jForm_GetEnvironmentDirectoryPath(FjEnv, FjObject, Ord(_directory))
end;

function jForm.GetInternalAppStoragePath: string;
begin
  Result:='';
  if FInitialized then
    Result:= jForm_GetInternalAppStoragePath(FjEnv, FjObject);
end;

function jForm.CopyFile(srcFullFilename: string; destFullFilename: string): boolean;
begin
  Result:= False;
  if FInitialized then
    Result:= jForm_CopyFile(FjEnv, FjObject, srcFullFilename, destFullFilename);
end;

function jForm.LoadFromAssets(fileName: string): string;
begin
  Result:= '';
  if FInitialized then
    Result:= jForm_LoadFromAssets(FjEnv,  FjObject, fileName);
end;

function jForm.IsSdCardMounted: boolean;
begin
  Result:= False;
  if FInitialized then
    Result:= jForm_IsSdCardMounted(FjEnv, FjObject);
end;

procedure jForm.DeleteFile(_filename: string);
begin
  if FInitialized then
     jForm_DeleteFile(FjEnv, FjObject, _filename);
end;

procedure jForm.DeleteFile(_fullPath: string; _filename: string);
begin
  if FInitialized then
     jForm_DeleteFile(FjEnv,FjObject, _fullPath ,_filename);
end;

procedure jForm.DeleteFile(_environmentDir: TEnvDirectory; _filename: string);
begin
  if FInitialized then
     jForm_DeleteFile(FjEnv, FjObject, Ord(_environmentDir) ,_filename);
end;

function jForm.CreateDir(_dirName: string): string;
begin
  if FInitialized then
    Result:= jForm_CreateDir(FjEnv,FjObject, _dirName);
end;

function jForm.CreateDir(_environmentDir: TEnvDirectory; _dirName: string): string;
begin
  if FInitialized then
    Result:= jForm_CreateDir(FjEnv, FjObject, Ord(_environmentDir) ,_dirName);
end;

function jForm.CreateDir(_fullPath: string; _dirName: string): string;
begin
  if FInitialized then
    Result:= jForm_CreateDir(FjEnv, FjObject, _fullPath ,_dirName);
end;

function jForm.IsExternalStorageEmulated(): boolean;
begin
  if FInitialized then
    Result:= jForm_IsExternalStorageEmulated(FjEnv, FjObject);
end;

function jForm.IsExternalStorageRemovable(): boolean;
begin
  if FInitialized then
    Result:= jForm_IsExternalStorageRemovable(FjEnv, FjObject);
end;

function jForm.GetjFormVersionFeatures(): string;
begin
  if FInitialized then
    Result:= jForm_GetjFormVersionFeatures(FjEnv, FjObject);
end;

function jForm.GetActionBar(): jObject;
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       Result:= jForm_GetActionBar(FjEnv, FjObject);
  end;
end;

procedure jForm.HideActionBar();
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jForm_HideActionBar(FjEnv, FjObject);
  end;
end;

procedure jForm.ShowActionBar();
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       jForm_ShowActionBar(FjEnv, FjObject);
  end;
end;

procedure jForm.ShowTitleActionBar(_value: boolean);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jForm_ShowTitleActionBar(FjEnv, FjObject, _value);
  end;
end;

procedure jForm.ShowLogoActionBar(_value: boolean);
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       jForm_ShowLogoActionBar(FjEnv, FjObject, _value);
  end;
end;

procedure jForm.SetTitleActionBar(_title: string);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jForm_SetTitleActionBar(FjEnv, FjObject, _title);
  end;
end;

procedure jForm.SetSubTitleActionBar(_subtitle: string);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
        jForm_SetSubTitleActionBar(FjEnv, FjObject, _subtitle);
  end;
end;

procedure jForm.SetIconActionBar(_iconIdentifier: string);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jForm_SetIconActionBar(FjEnv, FjObject, _iconIdentifier);
  end;
end;

procedure jForm.SetTabNavigationModeActionBar();
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
      jForm_SetTabNavigationModeActionBar(FjEnv, FjObject);
  end;
end;

procedure jForm.RemoveAllTabsActionBar();
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jForm_RemoveAllTabsActionBar(FjEnv, FjObject);
  end;
end;

function jForm.GetStringResourceId(_resName: string): integer;
begin
  if FInitialized then
   Result:= jForm_GetStringResourceId(FjEnv, FjObject, _resName);
end;

function jForm.GetStringResourceById(_resID: integer): string;
begin
  if FInitialized then
   Result:= jForm_GetStringResourceById(FjEnv, FjObject, _resID);
end;

function jForm.GetDrawableResourceId(_resName: string): integer;
begin
  if FInitialized then
    Result:= jForm_GetDrawableResourceId(FjEnv, FjObject, _resName);
end;

function jForm.GetDrawableResourceById(_resID: integer): jObject;
begin
  if FInitialized then
   Result:= jForm_GetDrawableResourceById(FjEnv, FjObject, _resID);
end;

function jForm.GetQuantityStringByName(_resName: string; _quantity: integer): string;
begin
  if FInitialized then
   Result:= jForm_GetQuantityStringByName(FjEnv, FjObject, _resName ,_quantity);
end;

function jForm.GetStringResourceByName(_resName: string): string;
begin
  if FInitialized then
   Result:= jForm_GetStringResourceByName(FjEnv, FjObject, _resName);
end;

function jForm.GetSystemVersion: Integer;
begin
  if(FInitialized) then
    Result:= jSysInfo_GetSystemVersion(FjEnv, FjObject);
end;

function jForm.GetDevicePhoneNumber: String;
begin
   if FInitialized then
     Result:= jSysInfo_DevicePhoneNumber(FjEnv, gApp.Jni.jThis);
end;

function jForm.GetDeviceID: String;
begin
   if FInitialized then
      Result:= jSysInfo_DeviceID(FjEnv, gApp.Jni.jThis);
end;

function jForm.IsPackageInstalled(_packagename: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_IsPackageInstalled(FjEnv, FjObject, _packagename);
end;

procedure jForm.ShowCustomMessage(_panel: jObject; _gravity: TGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowCustomMessage(FjEnv, FjObject, _panel, GetGravity(_gravity) );
end;

procedure jForm.SetScreenOrientationStyle(_orientation: TScreenStyle);
begin
  //in designing component state: set value here...
  FScreenStyle:= _orientation;
  if FInitialized then
     jForm_SetScreenOrientation(FjEnv, FjObject, Ord(_orientation));
end;

function jForm.GetScreenOrientationStyle(): TScreenStyle;
begin
  //in designing component state: result value here...
  Result:= FScreenStyle;
  if FInitialized then
   Result:= TScreenStyle(jForm_GetScreenOrientation(FjEnv, FjObject));
end;

function jForm.GetScreenDensity(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetScreenDensity(FjEnv, FjObject);
end;

function jForm.GetScreenSize(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetScreenSize(FjEnv, FjObject);
end;

procedure jForm.LogDebug(_tag: string; _msg: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_LogDebug(FjEnv, FjObject, _tag ,_msg);
end;

procedure jForm.ShowCustomMessage(_layout: jObject; _gravity: TGravity; _lenghTimeSecond: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowCustomMessage(FjEnv, FjObject, _layout ,GetGravity(_gravity) ,_lenghTimeSecond);
end;

procedure jForm.Vibrate(_milliseconds: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_Vibrate(FjEnv, FjObject, _milliseconds);
end;

procedure jForm.Vibrate(var _millisecondsPattern: TDynArrayOfInt64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_Vibrate(FjEnv, FjObject, _millisecondsPattern);
end;

procedure jForm.TakeScreenshot(_savePath: string; _saveFileNameJPG: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_TakeScreenshot(FjEnv, FjObject, _savePath ,_saveFileNameJPG);
end;

procedure jForm.UpdateJNI(refApp: jApp);
var
  i, count: integer;
begin
  inherited UpdateJNI(refApp);
  count:= Self.ComponentCount;
  for i:= (count-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       (Self.Components[i] as jControl).UpdateJNI(refApp);
    end;
  end;
end;

function jForm.GetTitleActionBar(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       Result:= jForm_GetTitleActionBar(FjEnv, FjObject);
  end;
end;

function jForm.GetSubTitleActionBar(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
      Result:= jForm_GetSubTitleActionBar(FjEnv, FjObject);
  end;
end;

function jForm.CopyFromAssetsToInternalAppStorage(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jForm_CopyFromAssetsToInternalAppStorage(FjEnv, FjObject, _filename);
end;

procedure jForm.CopyFromInternalAppStorageToEnvironmentDir(_filename: string; _environmentDirPath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_CopyFromInternalAppStorageToEnvironmentDir(FjEnv, FjObject, _filename ,_environmentDirPath);
end;

procedure jForm.CopyFromAssetsToEnvironmentDir(_filename: string; _environmentDirPath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_CopyFromAssetsToEnvironmentDir(FjEnv, FjObject, _filename ,_environmentDirPath);
end;

function jForm.DumpExceptionCallStack(E: Exception): string; //by Euller and Oswaldo
var
  i: integer;
begin
  Result := 'Error: Pascal "libcontrols.so" exception!'+ LineEnding + LineEnding;
  if E <> nil then
  begin
    Result := Result + 'Exception class: ' + E.ClassName + LineEnding + 'Message: ' + E.Message + LineEnding;
  end;
  Result := Result + 'Address: '+BackTraceStrFunc(ExceptAddr);
  for i:= 0 to ExceptFrameCount - 1 do
    Result := Result + LineEnding + BackTraceStrFunc(ExceptFrames[i]);
end;

function jForm.GetActionBarHeight(): integer;
begin
  //in designing component state: result value here...
  Result:= 0;
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
        Result:= jForm_GetActionBarHeight(FjEnv, FjObject);
  end;
end;

function jForm.ActionBarIsShowing(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
      Result:= jForm_ActionBarIsShowing(FjEnv, FjObject);
  end;
end;

procedure jForm.ToggleSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ToggleSoftInput(FjEnv, FjObject);
end;

function jForm.GetDeviceModel(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceModel(FjEnv, FjObject);
end;

function jForm.GetDeviceManufacturer(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceManufacturer(FjEnv, FjObject);
end;

procedure jForm.SetKeepScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetKeepScreenOn(FjEnv, FjObject, _value);
end;

procedure jForm.SetTurnScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetTurnScreenOn(FjEnv, FjObject, _value);
end;

procedure jForm.SetAllowLockWhileScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetAllowLockWhileScreenOn(FjEnv, FjObject, _value);
end;

procedure jForm.SetShowWhenLocked(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetShowWhenLocked(FjEnv, FjObject, _value);
end;

function jForm.ParseUri(_uriAsString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_ParseUri(FjEnv, FjObject, _uriAsString);
end;

function jForm.UriToString(_uri: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_UriToString(FjEnv, FjObject, _uri);
end;

function jForm.IsConnectedTo(_connectionType: TConnectionType): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_IsConnectedTo(FjEnv, FjObject, Ord(_connectionType));
end;

function jForm.IsMobileDataEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_IsMobileDataEnabled(FjEnv, FjObject);
end;

procedure jForm.HideSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_HideSoftInput(FjEnv, FjObject);
end;

procedure jForm.ShowSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowSoftInput(FjEnv, FjObject);
end;

function jForm.GetNetworkStatus(): TNetworkStatus;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TNetworkStatus(jForm_GetNetworkStatus(FjEnv, FjObject));
end;

function jForm.GetDeviceDataMobileIPAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceDataMobileIPAddress(FjEnv, FjObject);
end;

function jForm.GetDeviceWifiIPAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceWifiIPAddress(FjEnv, FjObject);
end;

function jForm.GetWifiBroadcastIPAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetWifiBroadcastIPAddress(FjEnv, FjObject);
end;

function jForm.LoadFromAssetsTextContent(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_LoadFromAssetsTextContent(FjEnv, FjObject, _filename);
end;

function jForm.RGBA(color: string): TSimpleRGBAColor;
var
  cor: string;
begin
  cor:= UpperCase(color);

  Result.r:= 1.0;
  Result.g:= 1.0;
  Result.b:= 1.0;
  Result.a:= 1.0; //alfa ..

  if cor = 'BLUE' then
  begin
    Result.r:= 0.0; Result.g:= 0.0; Result.b:= 1.0; Exit;
  end;

  if cor = 'VIOLET' then
  begin
    Result.r:= 1.0; Result.g:= 0.0; Result.b:= 1.0; Exit;
  end;

  if cor = 'GREEN' then
  begin
    Result.r:= 0.0; Result.g:= 1.0; Result.b:= 0.0; Exit;
  end;

  if cor = 'YELLOW' then
  begin
    Result.r:= 1.0; Result.g:= 1.0; Result.b:= 0.0; Exit;
  end;

  if cor = 'RED' then
  begin
    Result.r:= 1.0; Result.g:= 0.0; Result.b:= 0.0; Exit;
  end;

  if cor = 'ORANGE' then
  begin
    Result.r:= 1.0; Result.g:= 0.5; Result.b:= 0.0; Exit;
  end;

  if cor = 'WHITE' then
  begin
    Result.r:= 1.0; Result.g:= 1.0; Result.b:= 1.0; Exit;
  end;

  if cor = 'BLACK' then
  begin
    Result.r:= 0.0; Result.g:= 0.0; Result.b:= 0.0; Exit;
  end;

end;

function jForm.GetPathFromAssetsFile(_assetsFileName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetPathFromAssetsFile(FjEnv, FjObject, _assetsFileName);
end;

function jForm.GetImageFromAssetsFile(_assetsImageFileName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetImageFromAssetsFile(FjEnv, FjObject, _assetsImageFileName);
end;

function jForm.GetAssetContentList(_path: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetAssetContentList(FjEnv, FjObject, _path);
end;

function jForm.GetDriverList(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDriverList(FjEnv, FjObject);
end;

function jForm.GetFolderList(_envPath: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFolderList(FjEnv, FjObject, _envPath);
end;

function jForm.GetFileList(_envPath: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFileList(FjEnv, FjObject, _envPath);
end;

function jForm.FileExists(_fullFileName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jForm_FileExists(FjEnv, FjObject, _fullFileName);
end;

function jForm.DirectoryExists(_fullDirectoryName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jForm_DirectoryExists(FjEnv, FjObject, _fullDirectoryName);
end;

procedure jForm.Minimize();
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_Minimize(FjEnv, FjObject);
end;

procedure jForm.Restart(_delay: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_Restart(FjEnv, FjObject, _delay);
end;

procedure jForm.HideSoftInput(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_HideSoftInput(FjEnv, FjObject, _view);
end;

function jForm.UriEncode(_message: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_UriEncode(FjEnv, FjObject, _message);
end;

function jForm.ParseHtmlFontAwesome(_htmlString: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_ParseHtmlFontAwesome(FjEnv, FjObject, _htmlString);
end;

{-------- jForm_JNI_Bridge ----------}

function jForm_GetPathFromAssetsFile(env: PJNIEnv; _jform: JObject; _assetsFileName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_assetsFileName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPathFromAssetsFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetImageFromAssetsFile(env: PJNIEnv; _jform: JObject; _assetsImageFileName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_assetsImageFileName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetImageFromAssetsFile', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _layout;
  jParams[1].i:= _gravity;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowCustomMessage', '(Landroid/view/View;I)V'); //RelativeLayout
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer; _lenghTimeSecond: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _layout;
  jParams[1].i:= _gravity;
  jParams[2].i:= _lenghTimeSecond;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowCustomMessage', '(Landroid/view/View;II)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetStringExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= intentData;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetIntExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: integer): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].i:= defaultValue;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntExtra', '(Landroid/content/Intent;Ljava/lang/String;I)I');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDoubleExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: double): double;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].d:= defaultValue;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDoubleExtra', '(Landroid/content/Intent;Ljava/lang/String;D)D');
  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _filename: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _fullPath: string; _filename: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_DeleteFile(env: PJNIEnv; _jform: JObject; _environmentDir: integer; _filename: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _dirName: string): string;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _environmentDir: integer; _dirName: string): string;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_CreateDir(env: PJNIEnv; _jform: JObject; _fullPath: string; _dirName: string): string;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_IsExternalStorageEmulated(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsExternalStorageEmulated', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_IsExternalStorageRemovable(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsExternalStorageRemovable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetjFormVersionFeatures(env: PJNIEnv; _jform: JObject): string;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetActionBar(env: PJNIEnv; _jform: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionBar', '()Landroid/app/ActionBar;');
  Result:= env^.CallObjectMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_HideActionBar(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'HideActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_ShowActionBar(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_ShowTitleActionBar(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowTitleActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_ShowLogoActionBar(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowLogoActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_SetTitleActionBar(env: PJNIEnv; _jform: JObject; _title: string);
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
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_SetSubTitleActionBar(env: PJNIEnv; _jform: JObject; _subtitle: string);
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
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_SetIconActionBar(env: PJNIEnv; _jform: JObject; _iconIdentifier: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_SetTabNavigationModeActionBar(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabNavigationModeActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_RemoveAllTabsActionBar(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveAllTabsActionBar', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetStringResourceId(env: PJNIEnv; _jform: JObject; _resName: string): integer;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetStringResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): string;
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
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDrawableResourceId(env: PJNIEnv; _jform: JObject; _resName: string): integer;
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
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDrawableResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _resID;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawableResourceById', '(I)Landroid/graphics/drawable/Drawable;');
  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetQuantityStringByName(env: PJNIEnv; _jform: JObject; _resName: string; _quantity: integer): string;
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
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetStringResourceByName(env: PJNIEnv; _jform: JObject; _resName: string): string;
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
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_IsPackageInstalled(env: PJNIEnv; _jform: JObject; _packagename: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packagename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsPackageInstalled', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jform, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_SetScreenOrientation(env: PJNIEnv; _jform: JObject; _orientation: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _orientation;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScreenOrientation', '(I)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetScreenOrientation(env: PJNIEnv; _jform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetScreenOrientation', '()I');
  Result:= env^.CallIntMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetScreenDensity(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetScreenDensity', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetScreenSize(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetScreenSize', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_LogDebug(env: PJNIEnv; _jform: JObject; _tag: string; _msg: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_tag));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_msg));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'LogDebug', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; _milliseconds: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _milliseconds;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'Vibrate', '(I)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; var _millisecondsPattern: TDynArrayOfInt64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_millisecondsPattern);
  jNewArray0:= env^.NewLongArray(env, newSize0);  // allocate
  env^.SetLongArrayRegion(env, jNewArray0, 0 , newSize0, @_millisecondsPattern[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'Vibrate', '([J)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_TakeScreenshot(env: PJNIEnv; _jform: JObject; _savePath: string; _saveFileNameJPG: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_savePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_saveFileNameJPG));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'TakeScreenshot', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetTitleActionBar(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTitleActionBar', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetSubTitleActionBar(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSubTitleActionBar', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_CopyFromAssetsToInternalAppStorage(env: PJNIEnv; _jform: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyFromAssetsToInternalAppStorage', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_CopyFromInternalAppStorageToEnvironmentDir(env: PJNIEnv; _jform: JObject; _filename: string; _environmentDir: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_environmentDir));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyFromInternalAppStorageToEnvironmentDir', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_CopyFromAssetsToEnvironmentDir(env: PJNIEnv; _jform: JObject; _filename: string; _environmentDir: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_environmentDir));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyFromAssetsToEnvironmentDir', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
   env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetActionBarHeight(env: PJNIEnv; _jform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionBarHeight', '()I');
  Result:= env^.CallIntMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_ActionBarIsShowing(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ActionBarIsShowing', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_ToggleSoftInput(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ToggleSoftInput', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDeviceModel(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceModel', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDeviceManufacturer(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceManufacturer', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_SetKeepScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetKeepScreenOn', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_SetTurnScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTurnScreenOn', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_SetAllowLockWhileScreenOn(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAllowLockWhileScreenOn', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_SetShowWhenLocked(env: PJNIEnv; _jform: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetShowWhenLocked', '(Z)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_ParseUri(env: PJNIEnv; _jform: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ParseUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_UriToString(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _uri;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'UriToString', '(Landroid/net/Uri;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_IsConnectedTo(env: PJNIEnv; _jform: JObject; _connectionType: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _connectionType;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnectedTo', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jform, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_IsMobileDataEnabled(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsMobileDataEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'HideSoftInput', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jForm_ShowSoftInput(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowSoftInput', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetNetworkStatus(env: PJNIEnv; _jform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNetworkStatus', '()I');
  Result:= env^.CallIntMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetDeviceDataMobileIPAddress(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceDataMobileIPAddress', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetDeviceWifiIPAddress(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceWifiIPAddress', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetWifiBroadcastIPAddress(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetWifiBroadcastIPAddress', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jform, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetAssetContentList(env: PJNIEnv; _jform: JObject; _path: string): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAssetContentList', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetDriverList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDriverList', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jform, jMethod);
  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                 end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetFolderList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_envPath));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFolderList', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_envPath));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileList', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jForm_FileExists(env: PJNIEnv; _jform: JObject; _fullFileName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullFileName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'FileExists', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jform, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_DirectoryExists(env: PJNIEnv; _jform: JObject; _fullDirectoryName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullDirectoryName));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'DirectoryExists', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jform, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_Minimize(env: PJNIEnv; _jform: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'Minimize', '()V');
  env^.CallVoidMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_Restart(env: PJNIEnv; _jform: JObject; _delay: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _delay;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'Restart', '(I)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _view;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'HideSoftInput', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_UriEncode(env: PJNIEnv; _jform: JObject; _message: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'UriEncode', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_ParseHtmlFontAwesome(env: PJNIEnv; _jform: JObject; _htmlString: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_htmlString));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ParseHtmlFontAwesome', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

//-----------------------------------------------
   {jApp by jmpessoa}

constructor jApp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //
  FAppName         := ''; //gjAppName;
  FjClassName       := ''; //gjClassName;
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
  //Device.PhoneNumber := '';
  //Device.ID          := '';
  FInitialized     := False;
  TopIndex:= -1;
end;

destructor jApp.Destroy;
begin
  inherited Destroy;
end;

procedure jApp.Init(env: PJNIEnv; this: jObject; activity: jObject;
  layout: jObject; intent: jobject);
var
  startOrient: integer;
begin
  if FInitialized  then Exit;
  // Setting Global Environment -----------------------------------------------
  FillChar(Forms,SizeOf(Forms),#0);
  Forms.Index:= -1; //initial dummy index ...

  // Jni
  Jni.jEnv      := env;  //a reference to the JNI environment

  //[by jmpessoa: for API > 13 "STALED"!!! do not use its!
  Jni.jThis     := this; //["Controls.java"] a reference to the object making this call (or class if static).
  Jni.jActivity := activity;
  Jni.jRLayout  := layout;
  Jni.jIntent   := intent;

  // Screen
  Screen.WH     := jSysInfo_ScreenWH(env, this, activity);

  startOrient:= jSystem_GetOrientation(env, this);

  if  startOrient = 1 then
       Orientation   :=  ssPortrait
  else if startOrient = 2 then
       Orientation   :=  ssLandscape
  else if startOrient = 4 then Orientation:=  ssSensor
  else Orientation   :=  ssUnknown ;

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
  //Device.PhoneNumber := jSysInfo_DevicePhoneNumber(env, this);
  //Device.ID          := jSysInfo_DeviceID(env, this);
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

procedure jApp.IncFormsIndex;
begin
   if Forms.Index < (cjFormsMax-1) then
      Forms.Index:= Forms.Index + 1;
end;

function jApp.GetNewFormsIndex: integer;
begin
  if Forms.Index < (cjFormsMax-1) then
     Forms.Index:= Forms.Index +1;
  Result:= Forms.Index;
end;

function jApp.GetPreviousFormsIndex: integer;
begin
  if  Forms.Index > 0 then
    Result:= Forms.Index - 1
  else
    Result:= Forms.Index;
end;

procedure jApp.DecFormsIndex;
begin
    if  Forms.Index > 0 then
      Forms.Index:= Forms.Index - 1;
end;

procedure jApp.ShowMessage(_title: string; _message: string; _btnText: string);
begin
  jSystem_ShowAlert(Jni.jEnv, Jni.jThis,  _title,  _message,  _btnText);
end;

procedure jApp.SetAppName(Value: String);
begin
  FAppName:= Value;
end;

procedure jApp.SetjClassName(Value: String);
begin
  FjClassName:= Value;
end;

procedure jApp.Finish;
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

function jApp.GetMainActivityName: string;
begin
   Result:= 'App';
end;

function jApp.GetPackageName: string;
begin
    Result:= Self.AppName;
end;

   { generics }
Function InputTypeToStrEx ( InputType : TInputTypeEx ) : String;
 begin
  Result := 'TEXT';
  Case InputType of
   itxText       : Result := 'TEXT';
   itxCapCharacters: Result := 'CAPCHARACTERS'; 
   itxNumber     : Result := 'NUMBER';
   itxCurrency   : Result := 'CURRENCY';  //thanks to @renabor
   itxPhone      : Result := 'PHONE';
   itxNumberPassword : Result := 'PASSNUMBER';
   itxTextPassword   : Result := 'PASSTEXT';
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
function GetARGB(customColor: DWord; colbrColor: TARGBColorBridge):  DWord;
var
  index: integer;
begin
  if colbrColor <> colbrCustom then
  begin
    index:= (Ord(colbrColor));
    Result:= TARGBColorBridgeArray[index];
  end
  else Result:= customColor;
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

function GetParamByParentSide(paren: jVisualControl; side: TSide): DWord;
begin
   case side of
     sdW: begin
              Result:= paren.GetWidth;
          end;
     sdH: begin
              Result:= paren.GetHeight;
           end;
   end;
end;

function GetParamByParentSide2(paren: TAndroidWidget; side: TSide): DWord;
begin
   case side of
     sdW: begin
               Result:= paren.Width;
          end;
     sdH: begin
              Result:= paren.Height;
           end;
   end;
end;


function GetLayoutParamsByParent(paren: jVisualControl; lpParam: TLayoutParams;  side: TSide): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];  //-1
     lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];  //-2
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

     lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamByParentSide(paren, side)-14); //0.375
     lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamByParentSide(paren, side)-14); //0.625
     lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamByParentSide(paren, side)-14); //0.875
     lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamByParentSide(paren, side)-14); //0.167
     lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamByParentSide(paren, side)-14); //0.833
     lpNineTenthsOfParent:   Result:= Trunc((9/10)*GetParamByParentSide(paren, side)-14); //0.90
     lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamByParentSide(paren, side)-14); //0.95
     lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamByParentSide(paren, side)-14); //0.99

     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;

     // not yet implemented
     // lpUseWeight: Result:= 0;
     // so, for now:
     lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];

     //lpDesigner: Result:= 0;
  end;
end;

function GetLayoutParamsByParent2(paren: TAndroidWidget; lpParam: TLayoutParams;  side: TSide): DWord;
begin
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
     lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamByParentSide2(paren, side)-14); //0.66
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamByParentSide2(paren, side)-14); //0.33
     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamByParentSide2(paren, side)-14); //0.50

     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamByParentSide2(paren, side)-14); //0.25
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamByParentSide2(paren, side)-14); //0.125
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamByParentSide2(paren, side)-14);  //0.20
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamByParentSide2(paren, side)-14);  //0.40
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamByParentSide2(paren, side)-14);  //0.60

     lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamByParentSide2(paren, side)-14); //0.75
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamByParentSide2(paren, side)-14); //0.80

     lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamByParentSide2(paren, side)-14); //0.375
     lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamByParentSide2(paren, side)-14); //0.625
     lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamByParentSide2(paren, side)-14); //0.875
     lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamByParentSide2(paren, side)-14); //0.167
     lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamByParentSide2(paren, side)-14); //0.833
     lpNineTenthsOfParent:    Result:= Trunc((9/10)*GetParamByParentSide2(paren, side)-14); //0.90
     lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamByParentSide2(paren, side)-14);
     lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamByParentSide2(paren, side)-14);

     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;

     //lpUseWeight: Result:= 0;
     lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];

     //lpDesigner: Result:= 0;
  end;
end;


function GetParamBySide(App:jApp; side: TSide): DWord;
begin
   case side of
     sdW: Result:= App.Screen.WH.Width;
     sdH: Result:= App.Screen.WH.Height;
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
     7: Result:= lpThreeEighthOfParent;
     8: Result:= lpFiveEighthOfParent;
     9: Result:= lpSevenEighthOfParent;
     10: Result:= lpOneSixthOfParent;
     11: Result:= lpFiveSixthOfParent;
     12: Result:= lpOneFifthOfParent;
     13: Result:= lpTwoFifthOfParent;
     14: Result:= lpThreeFifthOfParent;
     15: Result:= lpThreeQuarterOfParent;
     16: Result:= lpFourFifthOfParent;
     17: Result:= lpNineTenthsOfParent;

     18: Result:= lp95PercentOfParent;
     19: Result:= lp99PercentOfParent;

     20: Result:= lp16px;
     21: Result:= lp24px;
     22: Result:= lp32px;
     23: Result:= lp40px;
     24: Result:= lp48px;
     25: Result:= lp72px;
     26: Result:= lp96px;
     27: Result:= lpExact;
     28: Result:= lpUseWeight;

   end;
end;

function GetLayoutParamsOrd(lpParam: TLayoutParams): DWord;
begin
   Result:= Ord(lpParam);
end;

function GetLayoutParams(App:jApp; lpParam: TLayoutParams; side: TSide): DWord;
begin
  case lpParam of

   lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
   lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
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

   lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamBySide(App, side)-14); //0.375
   lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamBySide(App, side)-14); //0.625
   lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamBySide(App, side)-14); //0.875
   lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamBySide(App, side)-14); //0.167
   lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamBySide(App, side)-14); //0.833
   lpNineTenthsOfParent:   Result:= Trunc((9/10)*GetParamBySide(App, side)-14); //0.90

   lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamBySide(App, side)-14);
   lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamBySide(App, side)-14);

   lp16px: Result:= 16;
   lp24px: Result:= 24;
   lp32px: Result:= 32;
   lp40px: Result:= 40;
   lp48px: Result:= 48;
   lp72px: Result:= 72;
   lp96px: Result:= 96;

   //lpUseWeight: Result:= 0;
   lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];

     //lpDesigner: Result:= 0;
  end;
end;

function GetDesignerLayoutParams(lpParam: TLayoutParams;  L: integer): DWord;
begin
  case lpParam of

   lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
   lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
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

   lpThreeEighthOfParent:  Result:= Trunc((3/8)*L-14); //0.375
   lpFiveEighthOfParent:   Result:= Trunc((5/8)*L-14); //0.625
   lpSevenEighthOfParent:  Result:= Trunc((7/8)*L-14); //0.875
   lpOneSixthOfParent:     Result:= Trunc((1/6)*L-14); //0.167
   lpFiveSixthOfParent:    Result:= Trunc((5/6)*L-14); //0.833
   lpNineTenthsOfParent:   Result:= Trunc((9/10)*L-14); //0.90

   lp95PercentOfParent:   Result:= Trunc((9.5/10)*L-14); //0.95
   lp99PercentOfParent:   Result:= Trunc((9.9/10)*L-14); //0.99

   lp16px: Result:= 16;
   lp24px: Result:= 24;
   lp32px: Result:= 32;
   lp40px: Result:= 40;
   lp48px: Result:= 48;
   lp72px: Result:= 72;
   lp96px: Result:= 96;

   lpExact: Result:= L;

  end;
end;

function GetDesignerLayoutByWH(Value: DWord; L: integer): TLayoutParams;  //just for design time...
begin
  if Value = 0 then Result:= lpUseWeight
   else if Value = 16 then Result:= lp16px
   else if Value = 24 then Result:= lp24px
   else if Value = 32 then Result:= lp32px
   else if Value = 40 then Result:= lp40px
   else if Value = 48 then Result:= lp48px
   else if Value = 72 then Result:= lp72px
   else if Value = 96 then Result:= lp96px
   else if Value <= Trunc((1/8)*L) then Result:= lpOneEighthOfParent   //0.125
   else if Value <= Trunc((1/5)*L) then Result:= lpOneFifthOfParent    //0.20
   else if Value <= Trunc((1/4)*L) then Result:= lpOneQuarterOfParent  //0.25
   else if Value <= Trunc((1/3)*L) then Result:= lpOneThirdOfParent    //0.33
   else if Value <= Trunc((3/8)*L) then Result:= lpThreeEighthOfParent //0.375
   else if Value <= Trunc((2/5)*L) then Result:= lpTwoFifthOfParent    //0.40
   else if Value <= Trunc((1/2)*L) then Result:= lpHalfOfParent        //0.50
   else if Value <= Trunc((3/5)*L) then Result:= lpThreeFifthOfParent  //0.60
   else if Value <= Trunc((5/8)*L) then Result:= lpFiveEighthOfParent  //0.625
   else if Value <= Trunc((2/3)*L) then Result:= lpTwoThirdOfParent    //0.66
   else if Value <= Trunc((3/4)*L) then Result:= lpThreeQuarterOfParent//0.75
   else if Value <= Trunc((4/5)*L) then Result:= lpFourFifthOfParent   //0.80
   else if Value <= Trunc((5/6)*L) then Result:= lpFiveSixthOfParent   //0.833
   else if Value <= Trunc((7/8)*L) then Result:= lpSevenEighthOfParent //0.875
   else if Value <= Trunc((9/10)*L)then Result:= lpNineTenthsOfParent  //0.90
   else if Value <= Trunc((9.5/10)*L) then Result:= lp95PercentOfParent  //0.95
   else if Value <= Trunc((9.9/10)*L) then Result:= lp95PercentOfParent  //0.99
   else if Value = L then Result:= lpExact
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
      fpathExt: Result:=  gApp.Path.Ext;
      fpathData: Result:= gApp.Path.Dat;
      fpathDCIM: Result:= gApp.Path.DCIM;
      fpathApp: Result:=  gApp.Path.App;
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


//-----------------------------------------------------------------
//JNI API Bridges: by jmpessoa
//-----------------------------------------------------------------

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

function Create_jObjectArray(Len: integer; cls: jClass; initialElement: jObject): jObject;
begin
  Result := nil;
  try
    Result := gApp.Jni.jEnv^.NewObjectArray(gApp.Jni.jEnv, len, cls, initialElement);
  except
    on E: Exception do Exit;
  end;
end;

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

function Get_jObjectArrayElement(jobjectArray: jObject; index: integer): jObject;
begin
  Result:= gApp.Jni.jEnv^.GetObjectArrayElement(gApp.Jni.jEnv, jobjectArray, index);
end;

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

function Call_jDoubleMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): double;
begin
  Result:= gApp.Jni.jEnv^.CallDoubleMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

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
  True : Result:= '';
  False: begin
          _jBoolean := JNI_False;
          Result    := String(gApp.Jni.jEnv^.GetStringUTFChars(gApp.Jni.jEnv,jStr,@_jBoolean) );
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
  env^.DeleteLocalRef(env, _cls);
end;

function jApp_GetAssetContentList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString; 
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  ResB: JBoolean;
  SizeArr, i: Integer;
begin  

  JCls := env^.GetObjectClass(env, this);
  JParams[0].l := env^.NewStringUTF(env, PChar(Path)); 
  JMethod := env^.GetMethodID(env, JCls, 'getAssetContentList', '(Ljava/lang/String;)[Ljava/lang/String;'); 
  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams); 
  if(DataArray <> nil) then 
  begin 
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr); 
    for i := 0 to SizeArr - 1 do 
    begin 
      StrX := env^.GetObjectArrayElement(env, DataArray, i);
      case StrX = nil of 
        True: Result[i] := '';
        False:
 	      begin
          ResB := JNI_False;
          Result[i] := string(env^.GetStringUTFChars(env, StrX, @ResB));
 	      end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jApp_GetDriverList(env: PJNIEnv; this: JObject): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  StrX: JString;
  ResB: JBoolean;
  SizeArr, i: Integer;
begin

  JCls := env^.GetObjectClass(env, this);
  JMethod := env^.GetMethodID(env, JCls, 'getDriverList', '()[Ljava/lang/String;');
  DataArray := env^.CallObjectMethod(env, this, JMethod);
  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);
      case StrX = nil of
        True: Result[i] := '';
        False:
 	      begin
          ResB := JNI_False;
          Result[i] := string(env^.GetStringUTFChars(env, StrX, @ResB));
 	      end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jApp_GetFolderList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  ResB: JBoolean;
  SizeArr, i: Integer;
begin

  JCls := env^.GetObjectClass(env, this);
  JParams[0].l := env^.NewStringUTF(env, PChar(Path));
  JMethod := env^.GetMethodID(env, JCls, 'getFolderList', '(Ljava/lang/String;)[Ljava/lang/String;');
  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams);
  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);
      case StrX = nil of
        True: Result[i] := '';
        False:
 	      begin
          ResB := JNI_False;
          Result[i] := string(env^.GetStringUTFChars(env, StrX, @ResB));
 	      end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jApp_GetFileList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  ResB: JBoolean;
  SizeArr, i: Integer;
begin

  JCls := env^.GetObjectClass(env, this);
  JParams[0].l := env^.NewStringUTF(env, PChar(Path));
  JMethod := env^.GetMethodID(env, JCls, 'getFileList', '(Ljava/lang/String;)[Ljava/lang/String;');
  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams);
  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);
      case StrX = nil of
        True: Result[i] := '';
        False:
 	      begin
          ResB := JNI_False;
          Result[i] := string(env^.GetStringUTFChars(env, StrX, @ResB));
 	      end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
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
  env^.DeleteLocalRef(env, cls);
end;

function  jApp_GetContext(env:PJNIEnv;this:jobject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, this);
  method:= env^.GetMethodID(env, cls, 'GetContext', '()Landroid/content/Context;');
  Result:= env^.CallObjectMethod(env, this, method);
  env^.DeleteLocalRef(env, cls);
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
  env^.DeleteLocalRef(env, _cls);
end;

function  jForm_GetOnViewClickListener(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetOnViewClickListener', '()Landroid/view/View$OnClickListener;');
  Result:= env^.CallObjectMethod(env, Form, method);
  env^.DeleteLocalRef(env, cls);
end;

function  jForm_GetOnListItemClickListener(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetOnListItemClickListener', '()Landroid/widget/AdapterView$OnItemClickListener;');
  Result:= env^.CallObjectMethod(env, Form, method);
  env^.DeleteLocalRef(env, cls);
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
  env^.DeleteLocalRef(env, _cls);
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
  env^.DeleteLocalRef(env, _cls);
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
  env^.DeleteLocalRef(env, _cls);
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
  env^.DeleteLocalRef(env, _cls);
end;

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

Function  jForm_Create (env:PJNIEnv; this: jobject; SelfObj : TObject) : jObject;
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
  _cls: jClass;
begin
  _cls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, _cls, 'jForm_Create', '(J)Ljava/lang/Object;');
 _jParam.j := Int64(SelfObj);
 Result := env^.CallObjectMethodA(env, this,_jMethod,@_jParam);
 Result := env^.NewGlobalRef(env,Result);
end;

//by jmpessoa   -- java clean up ....
Procedure jForm_Free2(env:PJNIEnv; Form: jObject);
var
  cls: jClass;
  method: jmethodID;
begin
  if Form <> nil then
  begin
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'Free', '()V');
    env^.CallVoidMethod(env, Form, method);
    env^.DeleteLocalRef(env, cls);
    env^.DeleteGlobalRef(env,Form);
  end;
end;

//addView( layout )
Procedure jForm_Show2(env:PJNIEnv; Form: jObject; effect : Integer);
var
   cls: jClass;
   method: jmethodID;
    _jParams : Array[0..0] of jValue;
begin
    _jParams[0].i:= effect;
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'Show', '(I)V');
    env^.CallVoidMethodA(env, Form, method,@_jParams);
    env^.DeleteLocalRef(env, cls);
end;
           //remove view layout ....
Procedure jForm_Close2(env:PJNIEnv; Form: jObject);
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'Close2', '()V');
  env^.CallVoidMethod(env, Form, method);
  env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
Function jForm_GetLayout2(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetLayout', '()Landroid/widget/RelativeLayout;');
  Result:= env^.CallObjectMethod(env, Form, method);
  Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
  env^.DeleteLocalRef(env, cls);
end;

Function jForm_GetView(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'GetView', '()Landroid/widget/RelativeLayout;');
  Result:= env^.CallObjectMethod(env, Form, method);
  Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
  env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
Function jForm_GetClickListener(env:PJNIEnv; Form: jObject): jObject;
var
   cls: jClass;
   method: jmethodID;
begin
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'GetClikListener', '()Landroid/view/View$OnClickListener;');
    Result:= env^.CallObjectMethod(env, Form, method);
    env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
Procedure jForm_FreeLayout(env:PJNIEnv;Layout: jObject);
begin
  if Layout <> nil then
     env^.DeleteGlobalRef(env, Layout);
end;

Procedure jForm_SetVisibility2(env:PJNIEnv;Form : jObject; visible : boolean);
var
   cls: jClass;
   method: jmethodID;
   _jParams : array[0..0] of jValue;
begin
    _jParams[0].z := JBool(visible);
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'SetVisible', '(Z)V');
    env^.CallVoidMethodA(env, Form, method, @_jParams);
    env^.DeleteLocalRef(env, cls);
end;

 //by jmpessoa
Procedure jForm_SetEnabled2(env:PJNIEnv;Form : jObject; enabled : Boolean);
var
   cls: jClass;
   method: jmethodID;
   _jParams : array[0..0] of jValue;
begin
   _jParams[0].z := JBool(enabled);
    cls := env^.GetObjectClass(env, Form);
    method:= env^.GetMethodID(env, cls, 'SetEnabled', '(Z)V');
    env^.CallVoidMethodA(env, Form, method, @_jParams);
    env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
procedure jForm_ShowMessage(env:PJNIEnv; Form:jObject; msg: string);
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
  env^.DeleteLocalRef(env, cls);
end;

procedure jForm_ShowMessage(env: PJNIEnv; _jform: JObject; _msg: string; _gravity: integer; _timeLength: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_msg));
  jParams[1].i:= _gravity;
  jParams[2].i:= _timeLength;
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowMessage', '(Ljava/lang/String;II)V');
  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

//by jmpessoa

procedure jForm_ShowMessageAsync(env:PJNIEnv; Form:jObject; msg: string);
var
   cls: jClass;
   method: jmethodID;
    _jParams : Array[0..0] of jValue;
begin
 gVM^.AttachCurrentThread(gVm,@env,nil); //fix here!
 _jParams[0].l:= env^.NewStringUTF(env, pchar(msg) );
  cls := env^.GetObjectClass(env, Form);
  method:= env^.GetMethodID(env, cls, 'ShowMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, Form, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
function jForm_GetDateTime(env:PJNIEnv; Form:jObject): string;
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
  env^.DeleteLocalRef(env, cls);
end;

function jForm_SetWifiEnabled(env: PJNIEnv; _jform: JObject; _status: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_status);
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiEnabled', '(Z)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jform, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_IsWifiEnabled(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsWifiEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

// by renabor
function jForm_IsConnected(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

// by renabor
function jForm_IsConnectedWifi(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnectedWifi', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jForm_GetEnvironmentDirectoryPath(env: PJNIEnv; _jform: JObject; _directory: integer): string;
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
  env^.DeleteLocalRef(env, _cls);
end;

function jForm_GetInternalAppStoragePath(env: PJNIEnv; _jform: JObject): string;
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
  env^.DeleteLocalRef(env, _cls);
end;

function jForm_CopyFile(env: PJNIEnv; _jform: JObject; _srcFullName: string; _destFullName: string): boolean;
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
  env^.DeleteLocalRef(env, _jCls);
end;

function jForm_LoadFromAssets(env: PJNIEnv; _jform: JObject; _fileName: string): string;
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
  env^.DeleteLocalRef(env, _jCls);
end;

function jForm_IsSdCardMounted(env: PJNIEnv; _jform: JObject): boolean;
var
   _jBoo: JBoolean;
   _jCls: jClass;
   _jMethod: jmethodID;
begin
  _jCls := env^.GetObjectClass(env, _jform);
  _jMethod:= env^.GetMethodID(env, _jCls, 'IsSdCardMounted', '()Z');
  _jBoo:= env^.CallBooleanMethod(env, _jform, _jMethod);
  Result:= boolean(_jBoo);
  env^.DeleteLocalRef(env, _jCls);
end;

function jForm_LoadFromAssetsTextContent(env: PJNIEnv; _jform: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jform);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssetsTextContent', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

//------------------------------------------------------------------------------
// View  - generics - "controls.java"
//------------------------------------------------------------------------------

Procedure View_SetId(env:PJNIEnv; view : jObject; Id :DWord);
var
  method: jmethodID;
  _jParams : array[0..0] of jValue;
    cls: jClass;
begin
  _jParams[0].i:= Id;
  cls:= env^.GetObjectClass(env, view);
  method:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, view, method, @_jParams);
  env^.DeleteLocalRef(env, cls);
end;


Procedure View_SetId(env:PJNIEnv; this:jobject; view : jObject; Id : DWord);
var
  method: jmethodID;
  _jParams : array[0..1] of jValue;
    cls: jClass;
begin
  _jParams[0].l := view;
 _jParams[1].i := Id;
  cls:= Get_gjClass(env);
  method:= env^.GetMethodID(env, cls, 'view_SetId', '(Landroid/view/View;I)V');
  env^.CallVoidMethodA(env, this, method, @_jParams);
end;


//by jmpessoa
Procedure View_SetVisible(env:PJNIEnv; this:jobject; view : jObject; visible : Boolean);
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
  method:= env^.GetMethodID(env, cls, 'view_SetVisible', '(Landroid/view/View;I)V');
  env^.CallVoidMethodA(env, this, method, @_jParams);
end;

Procedure View_SetVisible(env:PJNIEnv; view: jObject; visible: Boolean);
var
  method: jmethodID;
  _jParams : array[0..0] of jValue;
    cls: jClass;
begin
  case visible of
    True  : _jParams[0].i := 0; // visible
    False : _jParams[0].i := 4; // invisible
  end;
  cls:= env^.GetObjectClass(env, view);
  method:= env^.GetMethodID(env, cls, 'setVisibility', '(I)V');
  env^.CallVoidMethodA(env, view, method, @_jParams);
  env^.DeleteLocalRef(env, cls);
end;

//by jmpessoa
Procedure View_SetBackGroundColor(env:PJNIEnv;this:jobject; view : jObject; color : DWord);
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

Procedure View_SetBackGroundColor(env:PJNIEnv; view : jObject; color : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := color;
 cls:= env^.GetObjectClass(env, view);
 _jMethod:= env^.GetMethodID(env, cls, 'setBackgroundColor', '(I)V');
 env^.CallVoidMethodA(env,view,_jMethod,@_jParams);
 env^.DeleteLocalRef(env, cls);
end;

Procedure View_Invalidate(env:PJNIEnv; this:jobject; view : jObject);
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

Procedure View_Invalidate(env:PJNIEnv;  view : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls:= env^.GetObjectClass(env, view);
 _jMethod:= env^.GetMethodID(env, cls, 'invalidate', '()V');
 env^.CallVoidMethod(env,view,_jMethod);
 env^.DeleteLocalRef(env, cls);
end;

Procedure View_PostInvalidate(env:PJNIEnv; view : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls:= env^.GetObjectClass(env, view);
 _jMethod:= env^.GetMethodID(env, cls, 'postInvalidate', '()V');
 env^.CallVoidMethod(env,view,_jMethod);
 env^.DeleteLocalRef(env, cls);
end;

//------------------------------
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
end;

//------------------------------------------------------------------------------
// Device Info
//------------------------------------------------------------------------------
function jSysInfo_GetSystemVersion(env: PJNIEnv; _jform: JObject) : Integer;
  var
  jMethod: jMethodID = nil;
  jCls: jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jform);
  jMethod := env^.GetMethodID(env, jCls, 'getSystemVersion', '()I');
  Result := env^.CallIntMethod(env, _jform, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

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
 end;

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
end;

Procedure jSystem_ShowAlert(env:PJNIEnv; this:jobject; _title: string; _message: string; _btnText: string);
const
 _cFuncName = 'ShowAlert';
 _cFuncSig  = '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V';
var
 _jMethod : jMethodID = nil;
 _jParams  : Array[0..2] of jValue;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(_title) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(_message));
 _jParams[2].l := env^.NewStringUTF(env, pchar(_btnText));
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
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

end.

