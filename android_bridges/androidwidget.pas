unit AndroidWidget;

//Legacy: based on Simosays's Native Android Controls for Pascal

(*
LAMW: Lazarus Android Module Wizard:
	:: RAD Android! Form Designer and Components Development Model!

"A wizard to create JNI Android loadable module (.so) and Android Apk
	widh Lazarus/Free Pascal using Form Designer and Components!"

Authors:

	Jose Marques Pessoa
		jmpessoa@hotmail dot com
		https://github.com/jmpessoa/lazandroidmodulewizard
		http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

	Simon,Choi / Choi,Won-sik
		simonsayz@naver dot com
		http://blog.naver.com/simonsayz

	Anton A. Panferov [@A.S.]
		ast.a_s@mail dot ru
		https://github.com/odisey1245

*)

{$mode delphi}

{$SMARTLINK ON}

interface

uses
  Classes, SysUtils, Math, types, And_jni, CustApp;

type

  TFlashlightMode = (fmOFF, fmON);
  
  PAlphaColor = ^TAlphaColor; //by Kordal
  TAlphaColor = 0..$FFFFFFFF; // ARGB
  TLayerType = (ltNONE, ltSOFTWARE, ltHARDWARE);


  TStrokeCap = (scDefault, scRound);
  TStrokeJoin = (sjDefault, sjRound);

  TAndroidLayoutType = (altMATCHPARENT,altWRAPCONTENT);
  TViewVisibility = (vvVisible=0,  vvInvisible=4, vvGone=8);

  TCollapsingMode = (cmOff, cmPin, cmParallax);

  TCollapsingScrollflag = (csfExitUntilCollapsed, csfEnterAlwaysCollapsed, csfEnterAlways, csfSnap, csfNone);

  TOnClickNavigationViewItem = procedure(Sender: TObject; itemId: integer; itemCaption: string) of object;

  TAppTheme = (actThemeOverlayAppCompatDarkActionBar);

  TDensityAssets = (daNONE=0, daLOW=120, daMEDIUM=160, daTV=213,
                    daHIGH=240, daXHIGH=320, daXXHIGH=480, daXXXHIGH=640);

  jObjectRef = Pointer;

const

  // Event id for Pascal & Java
  cTouchDown            = 0;
  cTouchMove            = 1;
  cTouchUp              = 2;
  cClick                = 3;
  cDoubleClick          = 4;

  cRenderer_onGLCreate  = 0;
  cRenderer_onGLChange  = 1;
  cRenderer_onGLDraw    = 2;
  cRenderer_onGLDestroy = 3;
  cRenderer_onGLThread  = 4;
  cRenderer_onGLPause  = 5;
  cRenderer_onGLResume  = 6;


  cjFormsMax = 60; // Max Form Stack Count

  TFPColorBridgeArray: array[0..144] of longint = (
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
    $90EE90,$9370D8,$9400D3,$000000,$000000); //colbrDefault

  //https://coderwall.com/p/dedqca/argb-colors-in-android
  //https://stackoverflow.com/questions/5445085/understanding-colors-on-android-six-characters/25170174#25170174
  {
  AA - Alpha component [0..255] of the color
  RR - Red component [0..255] of the color
  GG - Green component [0..255] of the color
  BB - Blue component [0..255] of the color
  }
  //https://www.rapidtables.com/web/color/RGB_Color.html
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

  TProgressBarStyleArray: array[0..7] of DWord = ($01010077,
                                                  $01010078,
                                                  $01010287,
                                                  $0101007a,
                                                  $01010289,
                                                  $01010079,
                                                  $0101020f,
                                                  $0101013c);
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
  TScrollBarStyleArray: array[0..5] of DWord = ($00000000,
                                                $01000000,
                                                $02000000,
                                                $03000000,
                                                $00000001,
                                                $00000002);
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

 TSinglePoint = record
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

 //jbyte <->  shortint
 TDynArrayOfJByte = array of JByte;  //array of shortint
 TDynArrayOfShortint = array of shortint;  //array of jbyte

 TDynArrayOfJObject = array of JObject;

 TArrayOfByte = array of JByte;
 TArrayOfJByte = array of JByte;

 TScanByte = Array[0..0] of JByte;
 PScanByte = ^TScanByte;

 TScanLine = Array[0..0] of DWord;
 PScanLine = ^TScanline;

 TItemLayout = (layImageTextWidget, layWidgetTextImage, layText);

 TToggleState = (tsOff, tsOn);

 TOnClickToggleButton = procedure (Sender: TObject; isStateOn: boolean) of Object;

 TWidgetItem = (wgNone,wgCheckBox,wgRadioButton,wgButton,wgTextView, wgEditText, wgSwitch);

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
                        misIfRoomCollapseView,
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

  //ref. http://www.abpsoft.com/criacaoweb/tabcores.html
  //https://coderwall.com/p/dedqca/argb-colors-in-android
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
  colbrLightGreen,colbrMediumPurple,colbrDarkViolet,colbrNone,
  colbrDefault, colbrCustom);  //default=transparent!

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

  TTextAlign = (alLeft, alRight, alCenter);       //jListView
  TTextPosition = (posTop, posCenter, posBottom); //jListView by ADiV

  TTextAlignment = (taLeft, taRight, taCenter);  //others...

  TTextAlignHorizontal = (thLeft, thRight, thCenter);  //jCanvas
  TTextAlignVertical = (tvTop, tvBottom, tvCenter);

  TGravity = (gvBottom, gvCenter, gvCenterHorizontal, gvCenterVertical, gvLeft, gvNoGravity,
              gvRight, gvStart, gvTop, gvEnd, gvFillHorizontal, gvFillVertical);

  TLayoutGravity = (lgNone,
                   lgTopLeft, lgTopCenter, lgTopRight,
                   lgBottomLeft, lgBottomCenter, lgBottomRight,
                   lgCenter,
                   lgCenterVerticalLeft, lgCenterVerticalRight,
                   lgLeft, lgRight,
                   lgTop, lgBottom);

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

  TInputTypeEx  =(  itxText,
                    itxCapCharacters,
                    itxNumber,
                    itxNumberFloat,
                    itxNumberFloatPositive,		    
                    itxCurrency,
                    itxPhone,
                    itxNumberPassword,
                    itxTextPassword,
                    itxMultiLine, itxNull);

  TInputModeAdjust = ( imaNothig,
                       imaResize,
                       imaPan );

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

  TPositionRelativeToAnchorIDSet = set of TPositionRelativeToAnchorID;

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
  TPositionRelativeToParentSet = set of TPositionRelativeToParent;

  TLayoutParams = (lpMatchParent, lpWrapContent, lpHalfOfParent, lpOneQuarterOfParent, lpTwoThirdOfParent,
                   lpOneThirdOfParent, lpOneEighthOfParent,lpThreeEighthOfParent, lpFiveEighthOfParent,
                   lpSevenEighthOfParent, lpOneSixthOfParent, lpFiveSixthOfParent, lpOneFifthOfParent,
                   lpTwoFifthOfParent, lpThreeFifthOfParent, lpThreeQuarterOfParent,
                   lpFourFifthOfParent, lpNineTenthsOfParent, lp95PercentOfParent, lp99PercentOfParent,
                   lp16px, lp24px, lp32px, lp40px, lp48px, lp72px, lp96px, lp128px, lp192px, lpExact, lpUseWeight);

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
                    dirSharedPrefs,
                    dirCache,
                    dirDocuments); //warning: if Device Api < 19 then return dirDownloads!

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

  TPaintStyle = (psDefault, psFill , psFillAndStroke, psStroke);

  TActivityMode = (actMain, actRecyclable, actSplash, actEasel, actGdxScreen);

  //TDeviceType = (dtPhone, dtWatch);

  TTextTypeFace = (tfNormal, tfBold, tfItalic, tfBoldItalic);
  TFontFace = (ffNormal, ffSans, ffSerif, ffMonospace);

  TOnNotify = Procedure(Sender: TObject) of object;
  TViewClick = Procedure(jObjView: jObject; Id: integer) of object;
  TListItemClick = Procedure(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer) of object;

  TOnCallBackData = Procedure(Sender: TObject; strData: string; intData: integer; doubleData: double) of object;
  TOnCallBackPointer = Procedure(Sender: TObject; _pointer: Pointer) of object;

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

  TManifestPermissionResult = (PERMISSION_DENIED = -1, PERMISSION_GRANTED = 0);

  TOnRequestPermissionResult = Procedure(Sender: TObject; requestCode: integer; manifestPermission: string; grantResult: TManifestPermissionResult) of Object;

  TOnActivityCreate = Procedure(Sender: TObject; intentData: jObject) of Object;

  TOnActivityPause = Procedure(Sender: TObject) of Object;
  TOnActivityResume = Procedure(Sender: TObject) of Object;
  TOnActivityStart = Procedure(Sender: TObject) of Object;
  TOnActivityStop = Procedure(Sender: TObject) of Object;

  TOnNewIntent = Procedure(Sender: TObject; intentData: jObject) of Object;

  TActionBarTabSelected = Procedure(Sender: TObject; view: jObject; title: string) of Object;

  TOnGLChange        = Procedure(Sender: TObject; W, H: integer) of object;

  TOnClickYN         = Procedure(Sender: TObject; YN  : TClickYN) of object;
  TOnClickItem       = Procedure(Sender: TObject; itemIndex: Integer) of object;

  TOnClickWidgetItem = Procedure(Sender: TObject; itemIndex: integer; checked: boolean) of object;
  TOnClickImageItem = Procedure(Sender: TObject; itemIndex: integer) of object; // by ADiV

  TOnClickCaptionItem = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string) of object;

  TOnWidgeItemLostFocus = Procedure(Sender: TObject; itemIndex: integer; widgetText: string) of object;

  TOnScrollStateChanged = Procedure(Sender: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: boolean) of object;

  TOnEditLostFocus = Procedure(Sender: TObject; textContent: string) of object;

  TOnDrawItemTextColor = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge) of Object;
  TOnDrawItemBackColor = Procedure(Sender: TObject; itemIndex: integer; out backColor: TARGBColorBridge) of Object; //by ADiV
  TOnDrawItemWidgetTextColor = Procedure(Sender: TObject; itemIndex: integer; widgetText: string; out textColor: TARGBColorBridge) of Object;
  TOnDrawItemWidgetText = Procedure(Sender: TObject; itemIndex: integer; widgetText: string; out newWidgetText: string) of Object;

  TOnDrawItemBitmap  = Procedure(Sender: TObject; itemIndex: integer; itemCaption: string; out bimap: JObject) of Object;
  TOnDrawItemWidgetBitmap  = Procedure(Sender: TObject; itemIndex: integer; widgetText: string; out bimap: JObject) of Object;

  TOnDrawItemCustomFont=procedure(Sender:TObject;position:integer;caption:string; var outCustomFontName:string) of object;

  TOnWebViewStatus   = Procedure(Sender: TObject; Status : TWebViewStatus;
                                 URL : String; Var CanNavi : Boolean) of object;

  //LMB:
  TOnWebViewFindResult = Procedure(Sender: TObject; findIndex, findCount: integer) of object;

  //by segator
  TOnWebViewEvaluateJavascriptResult=procedure(Sender:TObject;data:string) of object;

  TWebViewSslError = (sslNotYetValid, sslExpired, sslIdMisMatch, sslUntrusted);

  TOnWebViewReceivedSslError=procedure(Sender:TObject;error:string;primaryError:TWebViewSslError;var outProceed:boolean) of object;

  //SSL_UNTRUSTED:  //SSL_NOT YET VALID   SSL_IDMISMATCH  SSL_EXPIRED

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

  The folder "Digital Camera Image"-DCIM- store photographs from digital camera
  }


  TEnvPath    = record
                 App         : string;    // /data/app/com.kredix-1.apk
                 Dat         : string;    // /data/data/com.kredix/files
                 Ext         : string;    // /storage/emulated/0
                 DCIM        : string;    // /storage/emulated/0/DCIM
                 DataBase    : string;

  end;

  TFilePath = (fpathNone, fpathApp, fpathData, fpathExt, fpathDCIM, fpathDataBase);


  TjCallBack =  record
                  Event       : TOnNotify;
                  EventData   : TOnCallBackData;
                  EventPointer: TOnCallBackPointer;
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


  jForm         = class; // Forward Declaration
  TAndroidForm  = class; // Forward Declaration

  TjFormStack=  record
                 Form        : TAndroidForm; //jForm;  gdx change
                 CloseCB     : TjCallBack; //Close Call Back Event
                end;

  TjForms    =  record
                 Index       : integer;
                 Stack       : array[0..cjFormsMax-1] of TjFormStack;
                end;

  TjFormState = (fsFormCreate,  // Initializing
                 fsFormWork,    // Working
                 fsFormClose);  // Closing

  TSimpleRGBAColor = record
    r: single;    //red
    g: single;   //green
    b: single;  //blue
    a: single; //alfa
  end;


  { jApp }

  jApp = class(TCustomApplication)
  private
    FInitialized : boolean;
    FAppName     : string;

    //FMainActivity: string;
    //FPackageName   : string;
    FAPILevel      : Integer;

    FjClassName   : string;
    FForm        : TAndroidForm; //jForm; gdx change      // Main/Initial Form

    FNewId       : integer;
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

    IsAppActivityRecreate : boolean; // For detect AppActivityRecreate

    Locale        : TLocale;    //by thierrydijoux
    ControlsVersionInfo: string; //
    TopIndex: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateForm(InstanceClass: TComponentClass; out Reference);
    procedure Init(env: PJNIEnv; this: jObject; activity: jObject; layout: jObject; intent: jobject);

    function GetNewId(): integer; // by ADiV
    function GetLastId(): integer; // by ADiV

    procedure Finish();
    Procedure Recreate();
    function  GetContext(): jObject;
    function GetControlsVersionInfo: string;
    function GetControlsVersionFeatures: string; //sorry!

    function GetCurrentFormsIndex: integer;
    function GetNewFormsIndex: integer;
    function GetPreviousFormsIndex: integer;

    procedure IncFormsIndex;
    procedure DecFormsIndex;

    function GetMainActivityName: string;
    function GetPackageName: string;

    //properties
    property Initialized : boolean read FInitialized;
    property Form: {jForm} TAndroidForm read FForm write FForm; // Main Form  gdx change
    property AppName    : string read FAppName write SetAppName;
    property ClassName  : string read FjClassName write SetjClassName;
    property MainActivityName: string read GetMainActivityName;
    property PackageName  : string read GetPackageName;
    property APILevel: Integer read FAPILevel;
  end;

 {jControl by jmpessoa}

  jControl = class(TComponent)
  protected
    FjClass: jObject;
    FClassPath: string; //need by new pure jni model! -->> initialized by widget.Create
    FjObject     : jObject; //jSelf - java object
    FInitialized : boolean;
    FCustomColor: DWord;
  protected
    FEnabled     : boolean;
    procedure SetEnabled(Value: boolean); virtual;
  public
    property Initialized : boolean read FInitialized write FInitialized;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
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
  protected
    FColor       : TARGBColorBridge;  //background ... needed by designer...
    FFontColor   : TARGBColorBridge;  //needed by designer...

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
    procedure Init; override;

    function ChildCount: integer;
    property Children[Index: integer]: TAndroidWidget read GetChilds;
    function HasParent: Boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer); virtual;
    procedure InvalidateRect(ARect: TRect; Erase: boolean);
    procedure Invalidate;

    property AcceptChildrenAtDesignTime:boolean read FAcceptChildrenAtDesignTime;
    property Parent: TAndroidWidget read FParent write SetParent;
    property Visible: boolean read FVisible write FVisible;
    property Text: string read GetText write SetText;
    property CustomColor: DWord read FCustomColor write FCustomColor;

    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    property MarginLeft: integer read FMarginLeft write SetMarginLeft default 3;
    property MarginTop: integer read FMarginTop write SetMarginTop default 3;
    property MarginRight: integer read FMarginRight write SetMarginRight default 3;
    property MarginBottom: integer read FMarginBottom write SetMarginBottom default 3;
    property Enabled     : boolean read FEnabled  write SetEnabled;

  published
    //
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

    procedure ReadBoolAutoAssignIDs(Reader: TReader);   //hide "AutoAssignIDs"  in [old] ".lfm"
    procedure WriteBoolAutoAssignIDs(Writer: TWriter);  //hide "AutoAssignIDs"  in [old] ".lfm"

  protected
    FModuleType: integer; //gdx
    FPackageName: string; //gdx
    FActivityMode: TActivityMode; //gdx
    FScreenWH: TWH; //gdx
    FScreenStyle  : TScreenStyle; //gdx

    procedure SetActivityMode(Value: TActivityMode); virtual;

    procedure InternalInvalidateRect(ARect: TRect; Erase: boolean); override;
    // tk
    procedure Loaded; override;
    // end tk
    procedure DefineProperties(Filer: TFiler); override;  //hide "AutoAssignIDs"  in ".lfm"
  public

    ScreenStyleAtStart: TScreenStyle;    //device direction [vertical=1 and vertical=2]
    FormState     : TjFormState;
    FormIndex: integer;
    FormBaseIndex: integer;
    Finished: boolean;

    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    property Designer: IAndroidWidgetDesigner read FDesigner write FDesigner;

    property ActivityMode: TActivityMode read FActivityMode write SetActivityMode;
    property ScreenStyle  : TScreenStyle   read FScreenStyle    write FScreenStyle; //gdx
    property ScreenWH      : TWH read FScreenWH write FScreenWH; //gdx
    property ModuleType: integer read FModuleType write FModuleType; //gdx
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;

  published
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  { jForm }

  TAnimationMode = (animNone, animFade, animRightToLeft, animLeftToRight, animTopToBottom, animBottomToTop, animMoveCustom);
  TOnRunOnUiThread=procedure(Sender:TObject;tag:integer) of object;

  jForm = class(TAndroidForm)
  private
    FCBDataString: string;
    FCBDataInteger: integer;
    FCBDataDouble: double;
    FCBPointer: Pointer;

    FjRLayout: jObject;  //form Relative Layout/view
    FjPRLayout: jObject; //base actvity layout/view

    FjPRLayoutHome: jObject;  //save origin
    FOnViewClick      : TViewClick;
    FOnListItemClick  : TListItemClick;

    FAnimation     : TAnimation;
    FActionBarTitle: TActionBarTitle;

    FOnClick      : TOnNotify;
    FOnClose      :   TOnNotify;
    FOnCloseQuery  : TOnCloseQuery;
    FOnRotate      : TOnRotate;
    FOnActivityRst : TOnActivityRst;
    FOnJNIPrompt   : TOnNotify;

    FOnBackButton  : TOnNotify;
    FOnSpecialKeyDown : TOnKeyDown;

    //FOnNewIntent: TOnNewIntent;
    FCloseCallback : TjCallBack; // Close Call Back Event

    FOnShow       : TOnNotify;    // by ADiV
    FOnLayoutDraw : TOnNotify;    // by ADiV
    FOnInit       : TNotifyEvent; // by ADiV

    //FActionBarHeight: integer;
    FOnOptionMenuCreate: TOnOptionMenuItemCreate;
    FOnClickOptionMenuItem: TOnClickOptionMenuItem;
    FOnContextMenuCreate: TOnContextMenuItemCreate;
    FOnClickContextMenuItem: TOnClickContextMenuItem;

    FOnPrepareOptionsMenu: TOnPrepareOptionsMenu;
    FOnPrepareOptionsMenuItem: TOnPrepareOptionsMenuItem;
    FOnActivityCreate: TOnActivityCreate;
    FOnActivityReCreate: TOnNotify;
    FOnActivityPause: TOnActivityPause;
    FOnActivityResume: TOnActivityResume;
    FOnActivityStart: TOnActivityStart;
    FOnActivityStop: TOnActivityStop;
    FOnRequestPermissionResult: TOnRequestPermissionResult;
    FOnRunOnUiThread: TOnRunOnUiThread;
    FOnNewIntent: TOnNewIntent;

    FLayoutVisibility: boolean;
    FBackgroundImageIdentifier: string;

    FAnimationDurationIn: integer;
    FAnimationDurationOut: integer;
    FAnimationMode: TAnimationMode;

    Procedure SetColor   (Value : TARGBColorBridge);

  protected

    Procedure SetVisible (Value : Boolean);
    Procedure SetEnabled (Value : Boolean); override;
    procedure SetActivityMode(Value: TActivityMode); override;

    function  GetOnViewClickListener(jObjForm: jObject): jObject;
    function  GetOnListItemClickListener(jObjForm: jObject): jObject;

  public
    PromptOnBackKey: boolean;
    TryBacktrackOnClose: boolean;
    DoJNIPromptOnShow: boolean;
    DoJNIPromptOnInit: boolean;
    Standby: boolean;

    constructor CreateNew(AOwner: TComponent);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure InitShowing;
    procedure ReInitShowing;

    procedure Finish;

    Procedure Show; overload;
    Procedure Show(jniPrompt: boolean); overload;

    Procedure DoJNIPrompt;
    procedure DoOnShow; //by ADiV
    procedure FormChangeSize;

    Procedure GenEvent_OnClick(Obj: TObject);

    Procedure Close;
    Procedure Refresh;
    procedure ShowMessage(msg: string); overload;
    procedure ShowMessage(_msg: string; _gravity: TGravity; _timeLength: TShowLength); overload;
    
    function GetDateTime: string; overload;
    function GetDateTime( millisDateTime : int64 ) : string; overload; // By ADiV
    function GetBatteryPercent : integer; // BY ADiV
    function GetStatusBarHeight: integer; // BY ADiV
    function GetActionBarHeight: integer; // BY ADiV
    function GetContextTop: integer;        // BY ADiV
    function GetNavigationHeight : integer; // BY ADiV

    function GetStringExtra(intentData: jObject; extraName: string): string;
    function GetIntExtra(intentData: jObject; extraName: string; defaultValue: integer): integer;
    function GetDoubleExtra(intentData: jObject; extraName: string; defaultValue: double): double;

    Procedure SetCloseCallBack(Func : TOnNotify; Sender : TObject);  overload;
    Procedure SetCloseCallBack(Func : TOnCallBackData; Sender : TObject); overload;
    Procedure SetCloseCallBack(Func : TOnCallBackPointer; Sender : TObject); overload;

    //Procedure GenEvent_OnViewClick(jObjView: jObject; Id: integer);
    //Procedure GenEvent_OnListItemClick(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer);

    Procedure UpdateLayout;

    function SetWifiEnabled(_status: boolean): boolean;
    function IsWifiEnabled(): boolean;
    function IsConnected(): boolean; // by renabor
    function IsConnectedWifi(): boolean; // by renabor
    function IsScreenLocked(): boolean; // by ADiV
    function IsSleepMode(): boolean; // by ADiV

    function GetEnvironmentDirectoryPath(_directory: TEnvDirectory): string;
    function GetInternalAppStoragePath: string;
    function CopyFile(srcFullFilename: string; destFullFilename: string): boolean;
    function CopyFileFromUri(srcUri: jObject; destDir: string): string;
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

    procedure SetActionBarShowHome( showHome : boolean );   // By ADiV
    procedure SetActionBarColor( color : TARGBColorBridge); // By ADiV
    procedure SetNavigationColor(color : TARGBColorBridge); // By ADiV
    procedure SetStatusColor( color : TARGBColorBridge);    // By ADiV

    procedure SetIconActionBar(_iconIdentifier: string);
    procedure SetTabNavigationModeActionBar;
    procedure RemoveAllTabsActionBar();

    function GetStringResourceId(_resName: string): integer;
    function GetStringResourceById(_resID: integer): string;
    function GetDrawableResourceId(_resName: string): integer;
    function GetDrawableResourceById(_resID: integer): jObject;
    function GetQuantityStringByName(_resName: string; _quantity: integer): string;
    function GetStringResourceByName(_resName: string): string;

    function GetStringReplace(_strIn, _strFind, _strReplace: string): string; // By ADiV
    function GetStringCopy( _strData: string; _startIndex, _endIndex : integer ) : string;
    function GetStringPos( _strFind, _strData: string ) : integer;
    function GetStringPosUpperCase( _strFind, _strData: string ) : integer;
    function GetStringLength( _strData : string ) : integer;
    function GetStringCapitalize( _strIn : string ) : string;
    function GetStringUpperCase(_strIn : string ) : string;

    function GetStripAccents(_str: string): string;
    function GetStripAccentsUpperCase(_str: string): string;

    //needed: <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
    function GetSystemVersion: Integer;
    function GetDevicePhoneNumber: String;
    function GetDeviceID: String;

    function IsPackageInstalled(_packagename: string): boolean;

    procedure ShowCustomMessage(_panel: jObject; _gravity: TGravity);  overload;
    procedure ShowCustomMessage(_layout: jObject; _gravity: TGravity; _lenghTimeSecond: integer); overload;
    procedure CancelShowCustomMessage();

    procedure SetScreenOrientationStyle(_orientation: TScreenStyle);
    function  GetScreenOrientationStyle(): TScreenStyle;

    function  GetJavaLastId(): integer; // by ADiV
    function  GetScreenSize(): string;
    function  GetScreenDensity(): string; overload;
    function  GetScreenRealSizeInInches(): double;
    function  GetScreenDpi(): integer;
    function  GetScreenRealXdpi(): double;
    function  GetScreenRealYdpi(): double;    
    function  GetScreenDensity(strDensity: string): integer; overload;
    procedure SetDensityAssets( _value : TDensityAssets ); // by ADiV

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
    procedure SetSoftInputModeAdjust( _inputMode : TInputModeAdjust );

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
    function GetFileList(_envPath: string): TDynArrayOfString;  overload;
    function ToStringList(_dynArrayOfString: TDynArrayOfString; _delimiter: char): TStringList;

    function FileExists(_fullFileName: string): boolean;
    function DirectoryExists(_fullDirectoryName: string): boolean;

    procedure Minimize();

    procedure MoveToBack();
    //the "guide line' is try to mimic java Api ...
    procedure MoveTaskToBack(_nonRoot: boolean);
    procedure MoveTaskToFront();
    function isUsageStatsAllowed():boolean;
    procedure RequestUsageStatsPermission();
    function GetTaskInFront():string;
    function GetApplicationIcon(_package:string):jObject;
    function GetApplicationName(_package:string): string;
    function GetInstalledAppList(): TDynArrayOfString;
    procedure Restart(_delay: integer);
    procedure HideSoftInput(_view: jObject); overload;
    function UriEncode(_message: string): string;
    function ParseHtmlFontAwesome(_htmlString: string): string;

    procedure ReInit; //force the form to recreate the layout...
    procedure SetLayoutParent(_viewgroup: jObject);   //FjPRLayout
    function GetLayoutParent: jObject;
    procedure RemoveFromLayoutParent();
    procedure SetLayoutVisibility(_value: boolean);
    procedure ResetLayoutParent();

    function GetSettingsSystemInt(_strKey: string): integer;
    function GetSettingsSystemString(_strKey: string): string;
    function GetSettingsSystemFloat(_strKey: string): single;
    function GetSettingsSystemLong(_strKey: string): int64;
    function PutSettingsSystemInt(_strKey: string; _value: integer): boolean;
    function PutSettingsSystemLong(_strKey: string; _value: int64): boolean;
    function PutSettingsSystemFloat(_strKey: string; _value: single): boolean;
    function PutSettingsSystemString(_strKey: string; _strValue: string): boolean;

    function IsRuntimePermissionNeed(): boolean;
    function IsRuntimePermissionGranted(_manifestPermission: string): boolean;
    procedure RequestRuntimePermission(_manifestPermission: string; _requestCode: integer); overload;
    procedure RequestRuntimePermission(var _androidPermissions: TDynArrayOfString; _requestCode: integer); overload;
    procedure RequestRuntimePermission(_androidPermissions: array of string; _requestCode: integer); overload;

    function HasActionBar(): boolean;
    function IsAppCompatProject(): boolean;

    //by ADiV
    function  GetVersionCode() : integer;
    function  GetVersionName() : string;

    function  GetVersionPlayStore( appUrlString : string ) : string;
    
    function  GetDateTimeDecode( var day : integer; var month : integer; var year : integer;
                                 var hours : integer; var minutes: integer; var seconds : integer ) : boolean;
    function  GetScreenWidth(): integer;      // by ADiV
    function  GetScreenHeight(): integer;     // by ADiV
    function  GetRealScreenWidth(): integer;  // by ADiV
    function  GetRealScreenHeight(): integer; // by ADiV
    function  IsInMultiWindowMode(): boolean; // by ADiV
    function  GetSystemVersionString(): string; // by ADiV

    function  GetTimeInMilliseconds : int64;
    function  GetTimeHHssSS( millisTime : int64 ) : string;
    function  GetDateTimeToMillis( _dateTime: string; _zone: boolean ) : int64;
    function  GetDateTimeUTC( _dateTime: string ) : string;

    procedure SetBackgroundImageIdentifier(_imageIdentifier: string); overload;
    procedure SetBackgroundImageIdentifier(_imageIdentifier: string; _scaleType: integer); overload; // by ADiV
    procedure SetBackgroundImageMatrix( _scaleX, _scaleY, _degress,
                                        _dx, _dy, _centerX, _centerY : real ); // by ADiV
    //end ADiV

    function GetJByteBuffer(_width: integer; _height: integer): jObject;
    function GetJByteBufferFromImage(_bitmap: jObject): jObject;
    function GetJByteBufferAddress(jbyteBuffer: jObject): PJByte;
    function GetJGlobalRef(jObj: jObject): jObject;

    procedure SetAnimationDurationIn(_animationDurationIn: integer);
    procedure SetAnimationDurationOut(_animationDurationOut: integer);

    procedure SetAnimationMode(_animationMode: TAnimationMode);
    function GetRealPathFromURI(_Uri: jObject): string; //thanks to Segator!

    { We are using pascal "shortint" to simulate the [Signed] java byte ....
      however "shortint" works in the range "-127 to 128" equal to the byte in java ....
      So every time we assign a value outside this range, for example 192, we get
      the "range check" message...

      How to Fix:

      var
        bufferToSend: array of jbyte; //jbyte = shortint
      begin
        ...........
        bufferToSend[0] := ToSignedByte($C0);    //<-- fixed!
        ........
      end;}

    function ToSignedByte(b: byte): shortint;
    procedure StartDefaultActivityForFile(_filePath, _mimeType: string); //by Tomash

    procedure RunOnUiThread(_tag: integer);   //thanks to WayneSherman!
    procedure GenEvent_OnRunOnUiThread(Sender:TObject;tag:integer);

    Procedure GenEvent_OnViewClick(jObjView: jObject; Id: integer);
    Procedure GenEvent_OnListItemClick(jObjAdapterView: jObject; jObjView: jObject; position: integer; Id: integer);

    function IsExternalStorageReadWriteAvailable(): boolean;
    function IsExternalStorageReadable(): boolean;

    procedure CopyStringToClipboard(_txt: string);
    function PasteStringFromClipboard(): string;

    // Android 11 - Api 30  has restricted developers to access devices folders (ex: "Download, Documents, ..., etc")
    //Developers no longer have access to a file via its path. Instead, you need to use via “Uri“.

    //get user permission... and an uri
    procedure RequestCreateFile(_envPath: string; _fileMimeType: string; _fileName: string; _requestCode: integer);
    procedure RequestOpenFile(_envPath: string; _fileMimeType: string; _requestCode: integer);
    procedure RequestOpenDirectory(_envPath: string; _requestCode: integer);
    procedure TakePersistableUriPermission(_treeUri: jObject);

     //handling file by uri....
    function GetBitmapFromUri(_treeUri: jObject): jObject;
    function LoadBytesFromUri(_treeUri: jObject): TDynArrayOfJByte;
    function GetFileNameByUri(_treeUri: jObject): string;
    function GetTextFromUri(_treeUri: jObject): string;
    procedure SaveImageToUri(_bitmap: jObject; _toTreeUri: jObject);
    procedure SaveImageTypeToUri(_bitmap: jObject; _toTreeUri: jObject; _type: integer);
    procedure SaveBytesToUri(_bytes: TDynArrayOfJByte; _toTreeUri: jObject);
    procedure SaveTextToUri(_text: string; _toTreeUri: jObject);
    function GetFileList(_treeUri: jObject): TDynArrayOfString; overload;
    function GetFileList(_treeUri: jObject; _fileExtension: string): TDynArrayOfString; overload;

    function GetMimeTypeFromExtension(_fileExtension: string): string;
    function GetUriFromFile(_fullFileName: string): jObject;

    function IsAirPlaneModeOn(): boolean;
    function IsBluetoothOn(): boolean;
    function GetDeviceBuildVersionApi(): integer;
    function GetDeviceBuildVersionRelease(): string;

    // Property            FjRLayout
    property View         : jObject        read FjRLayout; //layout!
    property ViewParent {ViewParent}: jObject  read  GetLayoutParent  write SetLayoutParent; // Java : Parent Relative Layout

    property Animation    : TAnimation     read FAnimation      write FAnimation;
    property CallBackDataString: string read FCBDataString write FCBDataString;
    property CallBackDataInteger: integer read FCBDataInteger write FCBDataInteger;
    property CallBackDataDouble: double read FCBDataDouble write FCBDataDouble;
    property CallBackPointer: Pointer read FCBPointer write FCBPointer;

    property PackageName: string read FPackageName;
    property ActionBarHeight: integer read GetActionBarHeight;
    property LayoutVisibility: boolean   read FLayoutVisibility write  SetLayoutVisibility;
    //---------------  dummies for compatibility----
    {
    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
    property Title: string read FTitle write FTitle;
    property HorizontalOffset: integer read FHorizontalOffset write FHorizontalOffset;
    property VerticalOffset: integer read FVerticalOffset write FVerticalOffset;
    }
    //--------------------
    property  OnViewClick: TViewClick read FOnViewClick write FOnViewClick;
    property  OnListItemClick: TListItemClick read FOnListItemClick write FOnListItemClick;

  published

    property MarginLeft: integer read FMarginLeft write SetMarginLeft default 3;
    property MarginTop: integer read FMarginTop write SetMarginTop default 3;
    property MarginRight: integer read FMarginRight write SetMarginRight default 3;
    property MarginBottom: integer read FMarginBottom write SetMarginBottom default 3;
    property Enabled     : boolean read FEnabled  write SetEnabled;
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;

    property Text: string read GetText write SetText;
    property ActivityMode  : TActivityMode read FActivityMode write SetActivityMode;
    property BackgroundColor: TARGBColorBridge  read FColor write SetColor;
    property BackgroundImageIdentifier: string read FBackgroundImageIdentifier write SetBackgroundImageIdentifier;
    property ActionBarTitle: TActionBarTitle read FActionBarTitle write FActionBarTitle;
    property AnimationDurationIn: integer read FAnimationDurationIn write SetAnimationDurationIn;
    property AnimationDurationOut: integer read FAnimationDurationOut write SetAnimationDurationOut;
    property AnimationMode: TAnimationMode read FAnimationMode write SetAnimationMode;

    // Event
    property OnInit: TNotifyEvent read FOnInit write FOnInit; // by ADiV
    property OnCloseQuery : TOnCloseQuery  read FOnCloseQuery  write FOnCloseQuery;
    property OnRotate     : TOnRotate      read FOnRotate      write FOnRotate;
    property OnClick      : TOnNotify      read FOnClick       write FOnClick;
    property OnActivityResult: TOnActivityRst read FOnActivityRst write FOnActivityRst;
    property OnJNIPrompt  : TOnNotify read FOnJNIPrompt write FOnJNIPrompt;
    property OnBackButton : TOnNotify read FOnBackButton write FOnBackButton;
    property OnClose      : TOnNotify read FOnClose write FOnClose;
    property OnShow       : TOnNotify read FOnShow write FOnShow; //by ADiV
    property OnLayoutDraw : TOnNotify read FOnLayoutDraw write FOnLayoutDraw; //by ADiV
    property OnSpecialKeyDown    :TOnKeyDown read FOnSpecialKeyDown write FOnSpecialKeyDown;
    property OnCreateOptionMenu: TOnOptionMenuItemCreate read FOnOptionMenuCreate write FOnOptionMenuCreate;
    property OnClickOptionMenuItem: TOnClickOptionMenuItem read FOnClickOptionMenuItem write FOnClickOptionMenuItem;

    property OnPrepareOptionsMenu: TOnPrepareOptionsMenu read FOnPrepareOptionsMenu write FOnPrepareOptionsMenu;
    property OnPrepareOptionsMenuItem: TOnPrepareOptionsMenuItem read FOnPrepareOptionsMenuItem write FOnPrepareOptionsMenuItem;

    property OnCreateContextMenu: TOnContextMenuItemCreate read FOnContextMenuCreate write FOnContextMenuCreate;
    property OnClickContextMenuItem: TOnClickContextMenuItem read FOnClickContextMenuItem write FOnClickContextMenuItem;

    property OnActivityCreate: TOnActivityCreate read FOnActivityCreate write FOnActivityCreate;
    property OnActivityReCreate : TOnNotify read FOnActivityReCreate write FOnActivityReCreate;

    property OnActivityPause: TOnActivityPause read FOnActivityPause write FOnActivityPause;
    property OnActivityResume: TOnActivityResume read FOnActivityResume write FOnActivityResume;
    property OnRequestPermissionResult: TOnRequestPermissionResult read FOnRequestPermissionResult write FOnRequestPermissionResult;
    property OnNewIntent: TOnNewIntent read FOnNewIntent write FOnNewIntent;

    property OnActivityStart: TOnActivityStart read FOnActivityStart write FOnActivityStart;
    property OnActivityStop: TOnActivityStop read FOnActivityStop write FOnActivityStop;
    property OnRunOnUiThread: TOnRunOnUiThread read FOnRunOnUiThread write FOnRunOnUiThread;
  end;


  {jVisualControl}

  TFontSizeUnit =(unitDefault, unitPixel, unitDIP, {unitInch,} unitMillimeter, unitPoint, unitScaledPixel);

  jVisualControl = class(TAndroidWidget)
  private

    procedure ReadIntId(Reader: TReader);   //hide "id"  in ".lfm"
    procedure WriteIntId(Writer: TWriter);  //hide "id"  in ".lfm"

    //procedure NotSetId(_id: DWord);

  protected
    FId: DWord;
    FjPRLayout   : jObject; //Java: Parent Layout {parent View)
    FjPRLayoutHome: jObject; //Save parent origin

    FScreenStyle    : TScreenStyle;
    FFontSize     : DWord;
    FFontSizeUnit: TFontSizeUnit;

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

    FGravityInParent: TLayoutGravity;

    FOnBeforeDispatchDraw: TOnBeforeDispatchDraw;
    FOnAfterDispatchDraw: TOnAfterDispatchDraw;
    FOnLayouting: TOnLayouting;
    FMyClassParentName: string;

    procedure SetAnchor(Value: jVisualControl);
    procedure DefineProperties(Filer: TFiler); override;  //hide "id"  in ".lfm"
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetViewParent(Value: jObject);  virtual;
    function GetViewParent: jObject;  virtual;
    procedure RemoveFromViewParent;  virtual;
    procedure ResetViewParent(); virtual;

    procedure SetVisible(Value: boolean);
    function GetVisible(): boolean;

    procedure SetParamHeight(Value: TLayoutParams); virtual;
    procedure SetParamWidth(Value: TLayoutParams);  virtual;
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
    procedure SetParentComponent(Value: TComponent); override;

    procedure Init; override;
    procedure UpdateLayout(); virtual;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    property AnchorId: integer read FAnchorId write FAnchorId;
    property ScreenStyle   : TScreenStyle read FScreenStyle  write FScreenStyle   ;
    property ViewParent {ViewParent}: jObject  read  GetViewParent write SetViewParent; // Java : Parent Relative Layout
    property View: jObject read GetView;     //FjObject; //View/Layout
    property MyClassParentName: string read FMyClassParentName write FMyClassParentName;

    //hide "id"  in ".lfm"
    property Id: DWord read FId; // Id must be read only, NOT published anymore...!

  published

    //gdx begin
    property MarginLeft: integer read FMarginLeft write SetMarginLeft default 3;
    property MarginTop: integer read FMarginTop write SetMarginTop default 3;
    property MarginRight: integer read FMarginRight write SetMarginRight default 3;
    property MarginBottom: integer read FMarginBottom write SetMarginBottom default 3;
    property Enabled     : boolean read FEnabled  write SetEnabled;

    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    //gdx end

    property Visible: boolean read GetVisible write SetVisible;
    property Anchor  : jVisualControl read FAnchor write SetAnchor;
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
  function GetARGBJava(customColor: DWord; colbrColor: TARGBColorBridge): integer; // By ADiV
  function ARGBToCustomColor( conv_clr: TColorRGBA ): DWORD;  overload;  // By ADiV
  function ARGBToCustomColor( _a, _r, _g, _b : byte ): DWORD; overload;  // By ADiV
  function CustomColorToARGB( cColor : DWORD ): TColorRGBA;  // By ADiV
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

  function jForm_GetActionBar(env: PJNIEnv; _jform: JObject): jObject;

  function jForm_GetDrawableResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): jObject;

  procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer); overload;
  procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer; _lenghTimeSecond: integer); overload;

  procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; var _millisecondsPattern: TDynArrayOfInt64);

  function jForm_ParseUri(env: PJNIEnv; _jform: JObject; _uriAsString: string): jObject;
  function jForm_UriToString(env: PJNIEnv; _jform: JObject; _uri: jObject): string;

  function jForm_GetRealPathFromURI(env: PJNIEnv; _jform: JObject; _Uri: jObject): string;

  function jForm_GetBitmapFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): jObject;
  function jForm_LoadBytesFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): TDynArrayOfJByte;
  function jForm_GetFileNameByUri(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
  function jForm_GetTextFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
  procedure jForm_TakePersistableUriPermission(env: PJNIEnv; _jform: JObject; _uri: jObject);
  procedure jForm_SaveImageToUri(env: PJNIEnv; _jform: JObject; _bitmap: jObject; _toUri: jObject);
  procedure jForm_SaveImageTypeToUri(env: PJNIEnv; _jform: JObject; _bitmap: jObject; _toUri: jObject; _type: integer);
  procedure jForm_SaveBytesToUri(env: PJNIEnv; _jform: JObject; _bytes: TDynArrayOfJByte; _toUri: jObject);
  procedure jForm_SaveTextToUri(env: PJNIEnv; _jform: JObject; _text: string; _toUri: jObject);
  function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _treeUri: jObject): TDynArrayOfString; overload;
  function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _treeUri: jObject; _fileExtension: string): TDynArrayOfString; overload;
  function jForm_GetMimeTypeFromExtension(env: PJNIEnv; _jform: JObject; _fileExtension: string): string;
  function jForm_GetUriFromFile(env: PJNIEnv; _jform: JObject; _fullFileName: string): jObject;
  function jForm_IsAirPlaneModeOn(env: PJNIEnv; _jform: JObject): boolean;
  function jForm_IsBluetoothOn(env: PJNIEnv; _jform: JObject): boolean;
  function jForm_GetDeviceBuildVersionApi(env: PJNIEnv; _jform: JObject): integer;
  function jForm_GetDeviceBuildVersionRelease(env: PJNIEnv; _jform: JObject): string;


  //jni API Bridge
// http://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/functions.html
function Get_jClassLocalRef(fullClassName: string): jClass;
function Get_jObjectArrayElement(jobjectArray: jObject; index: integer): jObject;
procedure Set_jObjectArrayElement(jobjectArray: jObject; index: integer; element: jObject);
function Create_jObjectArray(Len: integer; cls: jClass; initialElement: jObject): jObject;
function Get_jArrayLength(jobjectArray: jObject): integer;
function Is_jInstanceOf(jObj:JObject; cls:JClass): boolean;
function Get_jObjectClass(jObj: jObject): jClass;

function Get_jObjGlobalRef(jObj: jObject): jObject;
function Create_jObjectLocalRef(cls: JClass): JObject;
function Create_jObjectLocalRefA(cls: JClass;
                        paramFullSignature: string; paramValues: array of jValue): JObject;
function Get_jMethodID(cls: jClass; funcName, funcSignature : string): jMethodID; //fixed missing...
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

function jApp_GetAssetContentList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
function jApp_GetDriverList(env: PJNIEnv; this: JObject): TDynArrayOfString;
function jApp_GetFolderList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
function jApp_GetFileList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;

function  jApp_GetContext(env:PJNIEnv;this:jobject): jObject;

function  jForm_GetOnViewClickListener        (env:PJNIEnv; Form: jObject): jObject;
function  jForm_GetOnListItemClickListener    (env:PJNIEnv; Form: jObject): jObject;

procedure jApp_GetJNIEnv(var env: PJNIEnv);

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

Function  jForm_Create                 (env:PJNIEnv;this:jobject; SelfObj : TObject) : jObject;
Procedure jForm_Free2                   (env:PJNIEnv; Form    : jObject);
Procedure jForm_Show2                   (env:PJNIEnv; Form    : jObject; effect : Integer);

Function  jForm_GetLayout2(env:PJNIEnv; Form    : jObject) : jObject;
Function jForm_GetView(env:PJNIEnv; Form: jObject): jObject;

Function jForm_GetClickListener(env:PJNIEnv;  Form: jObject): jObject;
Procedure jForm_FreeLayout              (env:PJNIEnv; Layout    : jObject);
Procedure jForm_SetEnabled2             (env:PJNIEnv;Form    : jObject; enabled : Boolean);

function jForm_CopyFileFromUri(env: PJNIEnv;  _jform: JObject; _srcUri : JObject; _destDir: string): string;

function jForm_GetAssetContentList(env: PJNIEnv; _jform: JObject; _path: string): TDynArrayOfString;
function jForm_GetDriverList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;
function jForm_GetFolderList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString; overload;

procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject; _view: jObject);  overload;
procedure jForm_SetViewParent(env: PJNIEnv; _jform: JObject; _viewgroup: jObject);
function jForm_GetParent(env: PJNIEnv; _jform: JObject): jObject;
procedure jForm_RequestRuntimePermission(env: PJNIEnv; _jform: JObject; var _androidPermissions: TDynArrayOfString; _requestCode: integer);  overload;
procedure jForm_RequestRuntimePermission(env: PJNIEnv; _jform: JObject; _androidPermissions: array of string; _requestCode: integer);  overload;

procedure jForm_SetBackgroundImageMatrix(env: PJNIEnv; _jform: JObject;
                                              _scaleX, _scaleY, _degress,
                                              _dx, _dy, _centerX, _centerY : real);

function jForm_GetJByteBuffer(env: PJNIEnv; _jform: JObject; _width: integer; _height: integer): jObject;
function jForm_GetByteBufferFromImage(env: PJNIEnv; _jform: JObject; _bitmap: jObject): jObject;
function jForm_GetInstalledAppList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;

//------------------------------------------------------------------------------
// View  - Generics
//------------------------------------------------------------------------------

procedure View_AddLParamsParentRule   (env:PJNIEnv; _jobject : jObject; rule: DWord);
procedure View_AddLParamsAnchorRule   (env:PJNIEnv; _jobject : jObject; rule: DWord);
procedure View_SetLGravity            (env: PJNIEnv; _jobject: JObject; _value: integer);
procedure View_SetLWeight             (env: PJNIEnv; _jobject: JObject; _w: single);
procedure View_SetVisible             (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean); overload;

procedure View_SetLParamHeight        (env:PJNIEnv; _jobject : jObject; h: DWord);
procedure View_SetLParamWidth         (env:PJNIEnv; _jobject : jObject; w: DWord);

function  View_GetLParamWidth         (env:PJNIEnv; _jobject : jObject): integer;
function  View_GetLParamHeight        (env:PJNIEnv; _jobject : jObject): integer;

procedure View_SetLayoutAll           (env:PJNIEnv; _jobject : jObject; idAnchor: DWord);
procedure View_ClearLayoutAll         (env: PJNIEnv; _jobject : JObject);

procedure View_SetVisible             (env:PJNIEnv; view: jObject; visible : Boolean); overload;
function  View_GetVisible             (env:PJNIEnv; view: jObject): boolean;

function  View_GetView                (env: PJNIEnv; view: JObject): jObject;
function  View_GetViewGroup           (env: PJNIEnv; view : jObject): jObject;
function  View_GetParent              (env: PJNIEnv; view: JObject): jObject;

procedure View_SetId                  (env:PJNIEnv; view : jObject; Id :DWord);

procedure View_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jobject: JObject; _left, _top, _right, _bottom, _width, _height: integer);

procedure View_SetBackGroundColor     (env:PJNIEnv;this:jobject; view : jObject; color : DWord);  overload;
procedure View_SetBackGroundColor     (env:PJNIEnv;view : jObject; color : DWord);  overload;

procedure View_Invalidate             (env:PJNIEnv;this:jobject; view : jObject); overload;
procedure View_Invalidate             (env:PJNIEnv; view : jObject); overload;
procedure View_PostInvalidate         (env:PJNIEnv; view : jObject);

procedure View_BringToFront           (env:PJNIEnv; view : jObject);
procedure View_SetViewParent          (env: PJNIEnv; view: JObject; _viewgroup: jObject);
procedure View_RemoveFromViewParent   (env: PJNIEnv; view: JObject);

// System Info
Function  jSysInfo_ScreenWH            (env:PJNIEnv;this:jobject) : TWH;

//by thierrydijoux
Function jSysInfo_Language (env:PJNIEnv; this: jobject; localeType: TLocaleType): String;

// Device Info

Procedure jSystem_ShowAlert(env:PJNIEnv; this:jobject; _title: string; _message: string; _btnText: string);
function Get_gjClass(env: PJNIEnv): jClass;

//-----
// Helper Function
Function xy  (x, y: integer): TXY;
Function xyWH(x, y, w, h: integer): TXYWH;
Function fxy (x, y: Single): TfXY;
Function getAnimation(i,o : TEffect ): TAnimation;
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

  procedure Java_Event_pAppOnCreate(env: PJNIEnv; this: jobject; context:jobject;  layout:jobject; intent: jobject);

  function sysGetLayoutParams( data : integer; layoutParam : TLayoutParams; parent : TAndroidWidget; sd : TSide; margins: integer): integer;
  function sysIsHeightExactToParent(widget: jVisualControl) : boolean;
  function sysGetHeightOfParent(FParent: TAndroidWidget) : integer;
  function sysIsWidthExactToParent(widget: jVisualControl) : boolean;
  function sysGetWidthOfParent(FParent: TAndroidWidget) : integer;
  function GetPStringAndDeleteLocalRef(env: PJNIEnv; var jStr: jString): string;

  (*
   Abbreviation for variable types for "jni_func" or "jni_proc"

   z:jboolean);
   b:jbyte);
   c:jchar);
   s:jshort);
   i:jint);
   j:jlong);
   f:jfloat);
   d:jdouble);
   l:jobject);
   t: String    -> Ljava/lang/String;
   h: CharSecuence -> Ljava/lang/CharSequence;

   ars: array of string -> [Ljava/lang/String;
   bmp: Bitmap    -> Landroid/graphics/Bitmap;
   int: Intent    -> Landroid/content/Intent;
   mei: MenuItem  -> Landroid/view/MenuItem;
   men: Menu      -> Landroid/view/Menu;
   uri: Uri       -> Landroid/net/Uri;
   vig: ViewGroup -> Landroid/view/ViewGroup;
   viw: View      -> Landroid/view/View;
   dab: jDynArrayOfJByte -> [B
   das: TDynArrayOfString -> [Ljava/lang/String;
  *)

  function  JBool( Bool : Boolean ) : byte;
  function  jni_ExceptionOccurred(env: PJNIEnv) : boolean;

  procedure jni_free(env:PJNIEnv; this : jObject);

  procedure jni_proc_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject );
  procedure jni_proc_das(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _das: TDynArrayOfString);
  procedure jni_proc_bmp_iiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject; _int0, _int1, _int2, _int3 : integer);
  procedure jni_proc_bmp_ii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject; _int0, _int1 : integer);
  procedure jni_proc_bmp_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject; _int : integer);
  procedure jni_proc_bmp_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject; _str: string);
  procedure jni_proc(env: PJNIEnv; _jobject: JObject; javaFuncion : string);
  procedure jni_proc_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float: single);
  procedure jni_proc_ff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: single);
  procedure jni_proc_fff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2, _float3: single);
  procedure jni_proc_ffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2, _float3, _float4: single);
  procedure jni_proc_fffffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2, _float3, _float4, _float5, _float6, _float7 : single);
  procedure jni_proc_h(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str : String);
  procedure jni_proc_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer);
  procedure jni_proc_ii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1: integer);
  procedure jni_proc_it(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0: integer; _str: string);
  procedure jni_proc_iz(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer; _bool: boolean);
  procedure jni_proc_iit(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1: integer; _str: string);
  procedure jni_proc_iiit(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2: integer; _str: string);
  procedure jni_proc_iii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2: integer);
  procedure jni_proc_iiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2, _int3: integer);
  procedure jni_proc_iiiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2, _int3, _int4: integer);
  procedure jni_proc_if(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer; _float:single);
  procedure jni_proc_iff(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer; _float0, _float1:single);
  procedure jni_proc_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long: int64);
  procedure jni_proc_mei(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menuItem: jObject);
  procedure jni_proc_mei_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menuItem: jObject; _bool: boolean);
  procedure jni_proc_men_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menu: jObject; _int0: integer);
  procedure jni_proc_men_i_das(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menu: jObject; _int0: integer; var _das: TDynArrayOfString);
  procedure jni_proc_men_it(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menu: jObject; _int0: integer; _str0: string);
  procedure jni_proc_uri(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: JObject);
  procedure jni_proc_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string);
  procedure jni_proc_tf(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _single: single);
  procedure jni_proc_ti(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int0: integer);
  procedure jni_proc_tii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int0, _int1: integer);
  procedure jni_proc_tj(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _long: int64);
  procedure jni_proc_tz(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _bool : boolean);
  procedure jni_proc_tt(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string);
  procedure jni_proc_tti(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string; _int0: integer);
  procedure jni_proc_ttii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string; _int0,_int1: integer);
  procedure jni_proc_ttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2, _str3: string);
  procedure jni_proc_tttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2, _str3, _str4: string);
  procedure jni_proc_ttti(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2, _str3: string; _int0 : integer);
  procedure jni_proc_ttttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2, _str3, _str4, _str5: string);
  procedure jni_proc_ttz(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string; _bool : boolean);
  procedure jni_proc_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _viewgroup: jObject);
  procedure jni_proc_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _view: jObject);
  procedure jni_proc_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bool: boolean);
  procedure jni_proc_zii(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bool: boolean; _int0, _int1: integer);

  function jni_func_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string): single;
  function jni_func_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string): integer;
  function jni_func_out_h(env: PJNIEnv; _jobject: JObject; javaFuncion : string): String;
  function jni_func_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string): int64;
  function jni_func_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string): double;
  function jni_func_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string): string;
  function jni_func_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
  function jni_func_out_int(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
  function jni_func_out_uri(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
  function jni_func_out_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
  function jni_func_out_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
  function jni_func_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string): boolean;

  function jni_func_bmp_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject): jObject;
  function jni_func_bmp_i_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: JObject; _int : integer): jObject;
  function jni_func_bmp_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject): integer;
  function jni_func_int_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _intent: jObject): jObject;
  function jni_func_t_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): jObject;
  function jni_func_t_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): integer;
  function jni_func_t_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): single;
  function jni_func_t_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): double;
  function jni_func_t_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): int64;
  function jni_func_t_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string): string;
  function jni_func_tii_out_t( env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int0, _int1 : integer): string;
  function jni_func_ttt_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1, _str2 : string): string;
  function jni_func_t_out_uri(env: PJNIEnv; _jobject:JObject; javaFuncion : string; _str0: string): jObject;
  function jni_func_t_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string; _str: string): boolean;
  function jni_func_uri_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: jObject): jObject;
  function jni_func_uri_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: jObject): integer;
  function jni_func_uri_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: jObject): string;
  function jni_func_uri_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _uri: jObject): boolean;
  function jni_func_dab_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _byteArray: TDynArrayOfJByte): jObject;
  function jni_func_dab_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _byteArray: TDynArrayOfJByte; _bool1: boolean): boolean;
  function jni_func_dd_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2: double): string;
  function jni_func_dd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2: double): single;
  function jni_func_dddd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _double1, _double2, _double3, _double4: double): single;
  function jni_func_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bool: boolean): boolean;

  function jni_func_i_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): integer;
  function jni_func_i_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): double;
  function jni_func_i_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): real;
  function jni_func_i_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): boolean;
  function jni_func_i_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): string;
  function jni_func_i_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int : integer): jObject;
  function jni_func_i_out_mei(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int : integer): jObject;
  function jni_func_iiii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2, _int3 : integer): jObject;
  function jni_func_ii_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1: integer): string;
  function jni_func_it_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string; _int: integer; _str: string): boolean;
  function jni_func_it_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer; _str: string): string;
  function jni_func_iii_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int0, _int1, _int2: integer): string;
  function jni_func_int_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _intent: jObject): string;
  function jni_func_j_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long: int64): string;
  function jni_func_ii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int1, _int2: integer): jObject;
  function jni_func_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: single): jObject;
  function jni_func_ffz_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _float1, _float2: double; _bool: boolean): string;function jni_func_bmp_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _float1, _float2: single): jObject;
  function jni_func_bmp_t_out_dab(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str: string): TDynArrayOfJByte;
  function jni_func_bmp_t_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str: string) : boolean;
  function jni_func_bmp_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _bitmap: jObject; _str1, _str2: string) : boolean;
  function jni_func_men_i_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _menu: jObject; _int0: integer): integer;
  function jni_func_tt_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str1, _str2: string): jObject;
  function jni_func_tt_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string): integer;
  function jni_func_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string): boolean;
  function jni_func_tt_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string): string;
  function jni_func_tt_ars_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string; _ars: array of string): integer;
  function jni_func_tt_ars_t_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1: string; _ars: array of string; _str3 : string): integer;
  function jni_func_tz_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _bool: boolean): int64;
  function jni_func_tz_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _bool: boolean): boolean;
  function jni_func_ti_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): jObject;
  function jni_func_tii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int0, _int1: integer): jObject;
  function jni_func_tiii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int0, _int1, _int2: integer): jObject;
  function jni_func_ti_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): integer;
  function jni_func_ti_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): string;
  function jni_func_ti_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int: integer): boolean;
  function jni_func_tj_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _long: int64): int64;
  function jni_func_i_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): int64;
  function jni_func_jji_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long0, _long1:int64; _int: integer): int64;
  function jni_func_tj_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _long: int64): boolean;
  function jni_func_tf_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _float: single): single;
  function jni_func_tf_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _float: single): boolean;
  function jni_func_tii_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _int1, _int2: integer): boolean;

var
  gApp:       jApp;       //global App !
  gVM         : PJavaVM;
  gjClass     : jClass = nil;
  gDbgMode    : Boolean;
  gjAppName   : PChar; // Ex 'com.kredix';
  gjClassName : PChar; // Ex 'com/kredix/Controls';

  exceptionCount : integer;
  exceptionInfo  : string;

  ActivityModeDesign: TActivityMode = actMain;

implementation

//by Tomash
function GetPStringAndDeleteLocalRef(env: PJNIEnv; var jStr: jString): string;
var
 jBoo: jBoolean;
 pch: pchar;
begin
 Result:= '';

 if jStr = nil then exit;

 jBoo   := JNI_False;
 pch    := env^.GetStringUTFChars(env, jStr, @jBoo);
 Result := string(pch);

 //IMPORTANT if function is executed more than 512 times in one call - App crash with error:
 //JNI ERROR (app bug): local reference table overflow (max=512)
 //In single calls java garbage collector it does
 env^.ReleaseStringUTFChars(env, jStr, pch);
 env^.DeleteLocalRef(env, jStr);
end;

function sysIsHeightExactToParent(widget: jVisualControl) : boolean;
begin
  Result := false;

  if widget.FLParamHeight = lpMatchParent then
  begin
   if widget.FAnchor = nil then
   begin
    Result := true;
    exit;
   end;

   if (not (raBelow in widget.FPositionRelativeToAnchor)) and
      (not (raAbove in widget.FPositionRelativeToAnchor)) and
      (not (raAlignBottom in widget.FPositionRelativeToAnchor)) and
      (not (raAlignTop in widget.FPositionRelativeToAnchor)) and
      (not (raAlignBaseline in widget.FPositionRelativeToAnchor)) then
   begin
    Result := true;
    exit;
   end;
  end;
end;

function sysIsWidthExactToParent(widget: jVisualControl) : boolean;
begin
 result := false;

 if widget.FLParamWidth = lpMatchParent then
  begin
   if widget.FAnchor = nil then
   begin
    Result := true;
    exit;
   end;

   if (not (raAlignLeft in widget.FPositionRelativeToAnchor)) and
      (not (raAlignRight in widget.FPositionRelativeToAnchor)) and
      (not (raAlignEnd in widget.FPositionRelativeToAnchor)) and
      (not (raAlignStart in widget.FPositionRelativeToAnchor)) and
      (not (raToLeftOf in widget.FPositionRelativeToAnchor)) and
      (not (raToRightOf in widget.FPositionRelativeToAnchor)) and
      (not (raToEndOf in widget.FPositionRelativeToAnchor)) and
      (not (raToStartOf in widget.FPositionRelativeToAnchor)) then
   begin
    Result := true;
    exit;
   end;
  end;
end;

function sysGetLayoutParams( data : integer; layoutParam : TLayoutParams; parent : TAndroidWidget; sd : TSide; margins: integer): integer;
begin

   result := 0;

   if layoutParam = lpExact then
   begin
    result := data;
    exit;
   end;

   if parent is jForm then
    Result := GetLayoutParams(gApp, layoutParam, sd)
   else
    if parent <> nil then
     result := GetLayoutParamsByParent((parent as jVisualControl), layoutParam, sd);

   if result > 0 then
    result := result - margins;

end;

function sysGetHeightOfParent(FParent: TAndroidWidget) : integer;
begin
      if FParent is jForm then
         Result:= (FParent as jForm).ScreenWH.Height // - gapp.GetContextTop
      else
         Result:= (FParent as jVisualControl).GetHeight;
end;

function sysGetWidthOfParent(FParent: TAndroidWidget) : integer;
begin
      if FParent is jForm then
        Result:= (FParent as jForm).ScreenWH.Width
      else
        Result:= (FParent as jVisualControl).GetWidth;
end;

procedure Java_Event_pAppOnCreate(env: PJNIEnv; this: jobject; context:jobject; layout:jobject; intent: jobject);
begin
  gApp.IsAppActivityRecreate := gApp.FInitialized;
  gApp.FInitialized := False;
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
   itMultiLine  : Result := 'TEXTMULTILINE';
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
  FClassPath:= '';
  FCustomColor:= $FF2C2F3E;    // <<--- thanks to Ps
end;

destructor jControl.Destroy;
begin
  inherited Destroy;
end;

procedure jControl.Init;
begin
  if  FClassPath <> '' then
     FjClass:= Get_jClassLocalRef(FClassPath);  //needed by new direct jni component model...
end;

procedure jControl.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
end;

procedure jControl.AttachCurrentThread();
begin
  gVM^.AttachCurrentThread(gVm,@(gapp.Jni.jEnv),nil);
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
end;

destructor TAndroidWidget.Destroy;
begin
  Parent:=nil;
  while ChildCount > 0 do Children[ChildCount-1].Free;
  if FChilds <> nil then FreeAndNil(FChilds);
  inherited Destroy;
end;

procedure TAndroidWidget.Init;
begin
   Inherited Init;
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
  if [csDesigning, csLoading] * ComponentState = [csDesigning] then
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

  FjPRLayout := nil;  //java view parent
  FjPRLayoutHome:= nil;

  FjObject    := nil; //java object
  FEnabled   := True;
  FVisible   := True;

  FColor     := colbrDefault;  //background
 // FFontColor := colbrDefault;
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

procedure jVisualControl.Init;
begin
  inherited Init;
  FjPRLayout := jForm(Owner).View;  //set default ViewParent/FjPRLayout as jForm.View!
  FjPRLayoutHome:= FjPRLayout;      //save origin
  FScreenStyle := jForm(Owner).ScreenStyle;
  (*
  if (PosRelativeToAnchor = []) and (PosRelativeToParent = []) then
  begin
    //commented by jmpessoa: causing error to jPanel when used as a "flying" view [jActonBarTab, jRecyclerView...]
    //FMarginLeft := FLeft;
    //FMarginTop := FTop;
  end;
  *)
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
     end;
  end;
end;

procedure jVisualControl.SetParent(const AValue: TAndroidWidget);
begin
  inherited SetParent(AValue);
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

procedure jVisualControl.RemoveFromViewParent;
begin
   //
end;

procedure jVisualControl.ResetViewParent();
begin
  FjPRLayout:= FjPRLayoutHome;
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
     View_SetVisible(gapp.Jni.jEnv, FjObject, FVisible);
end;

function jVisualControl.GetVisible(): boolean;
begin
  if FInitialized then
     FVisible:= View_GetVisible(gapp.Jni.jEnv, FjObject);

  Result:= FVisible;
end;

procedure jVisualControl.DefineProperties(Filer: TFiler); //hide "id"  in ".lfm"
begin
 inherited DefineProperties(Filer);
 Filer.DefineProperty('Id', ReadIntId, WriteIntId, False); // Id<>0
end;

procedure jVisualControl.ReadIntId(Reader: TReader);  //hide "id"  in ".lfm"
begin
  Reader.ReadInteger;  // Not load the id
end;

procedure jVisualControl.WriteIntId(Writer: TWriter); //hide "id"  in ".lfm"
begin
   Writer.WriteInteger(0); // id write to 0
end;

// needed by jForm process logic ...
procedure jVisualControl.UpdateLayout();
begin
  //dummy...
  // ADiV
  if Self.Anchor <> nil then
    Self.AnchorId:= Self.Anchor.Id
  else
    Self.AnchorId:= -1;
  // end ADiV
end;

procedure jVisualControl.SetParamWidth(Value: TLayoutParams);
begin
  FLParamWidth:= Value;
end;

procedure jVisualControl.SetParamHeight(Value: TLayoutParams);
begin
  FLParamHeight:= Value;
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

procedure TAndroidForm.Init;
begin
   Inherited Init;
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

procedure TAndroidForm.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('AutoAssignIDs', ReadBoolAutoAssignIDs, WriteBoolAutoAssignIDs, False);
end;

procedure TAndroidForm.ReadBoolAutoAssignIDs(Reader: TReader);
begin
  Reader.ReadBoolean; // Not load the AutoAssignIDs
end;

procedure TAndroidForm.WriteBoolAutoAssignIDs(Writer: TWriter);
begin
  Writer.WriteBoolean(False); // id write to False
end;

procedure TAndroidForm.SetActivityMode(Value: TActivityMode);
begin
   FActivityMode:= Value;
end;

procedure TAndroidForm.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
 if (Parent=nil) and (Designer<>nil) then
   Designer.InvalidateRect(Self,ARect,Erase);
end;

procedure TAndroidForm.Loaded;
begin
  inherited Loaded;
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
  FCloseCallBack.EventData:= nil;
  FCloseCallBack.EventPointer:= nil;
  FCloseCallBack.Sender := nil;
  FActivityMode         := ActivityModeDesign; //actMain;  //actMain, actRecyclable, actSplash, act...

  FActionBarTitle:= abtDefault;

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
  DoJNIPromptOnInit:= True;

  FAnimationDurationIn:=  1500;
  FAnimationDurationOut:=  1500;

  FAnimationMode:= animNone;

  //now load the stream   ***
  //InitInheritedComponent(Self, TAndroidWidget {TAndroidForm}); {thanks to  x2nie !!}
  InitInheritedComponent(Self, jForm {Need for Android 12}); {thanks to  x2nie !!}
end;

destructor jForm.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FInitialized and (not Finished) then
    begin
      jForm_FreeLayout(gapp.Jni.jEnv, FjRLayout);      //free jni jForm Layout global reference
      jForm_FreeLayout(gapp.Jni.jEnv, FjPRLayoutHome); //free jni jForm Layout global reference
      jForm_Free2(gapp.Jni.jEnv, FjObject);
    end;
  end;
  inherited Destroy;
end;

procedure jForm.Finish;
begin
  if FInitialized and (not Finished)  then
  begin
    jForm_FreeLayout(gapp.Jni.jEnv, FjRLayout);      //free jni jForm Layout global reference
    jForm_FreeLayout(gapp.Jni.jEnv, FjPRLayoutHome); //free jni [saved copy] jForm Layout global reference
    jForm_Free2(gapp.Jni.jEnv, FjObject);
    Finished:= True;
  end;
end;

procedure jForm.Init;
var
  i: integer;
begin

  // For Reinit if calling 2 times or more [need split-screen] by ADiV
  if FInitialized then begin Reinit; Exit; end;

  Inherited Init;

  //gdx
  if not (csDesigning in ComponentState) then
    if Assigned(FOnInit) then FOnInit(Self);    //by TRE3

  if FActivityMode <> actEasel then
  begin

    if FActivityMode = actSplash then
       Randomize; //thanks to Gerrit

    if FActivityMode = actMain then
       Randomize; //thanks to Gerrit

    FScreenStyle:= gApp.Orientation;
    FScreenWH:= gApp.Screen.WH;   //sAved on start!

    FWidth   := gApp.Screen.WH.Width;
    FHeight  := gApp.Screen.WH.Height;

    FPackageName:= gApp.AppName;
    ScreenStyleAtStart:= FScreenStyle;   //saved on start!

    FjObject:=  jForm_Create(gApp.Jni.jEnv, gApp.Jni.jThis, Self); {jSef}

    if FjObject = nil then exit;

    FjRLayout:=  jForm_Getlayout2(gApp.Jni.jEnv, FjObject);  {View}    //jni grobal ref

    if FjRLayout = nil then exit;

    FjPRLayoutHome:= jForm_GetParent(gApp.Jni.jEnv, FjObject); //save origin  //jni grobal ref
    FjPRLayout:= FjPRLayoutHome; //base appLayout

    //thierrydijoux - if backgroundColor is set to black, no theme ...
    if FColor <> colbrDefault then
       View_SetBackGroundColor(gApp.Jni.jEnv, gApp.Jni.jThis, FjRLayout, GetARGB(FCustomColor, FColor));

    FInitialized:= True;    //need here...

    if FBackgroundImageIdentifier <> '' then
      SetBackgroundImageIdentifier(FBackgroundImageIdentifier);

    if FAnimationDurationIn <> 1500 then  //default
       SetAnimationDurationIn(FAnimationDurationIn);

    if FAnimationDurationOut <> 1500 then  //default
       SetAnimationDurationOut(FAnimationDurationOut);

    if FAnimationMode <> animNone then  //default
       SetAnimationMode(FAnimationMode);


    for i:= (Self.ComponentCount-1) downto 0 do
    begin
      if (Self.Components[i] is jControl) then
      begin
         (Self.Components[i] as jControl).Init;
      end;
    end;

    jForm_SetEnabled2(gApp.Jni.jEnv, FjObject, FEnabled);

    if gApp.GetCurrentFormsIndex = (cjFormsMax-1) then Exit; //no more form is possible!

    FormBaseIndex:= gApp.TopIndex;           //initial = -1

    //if it is a new form .... [not a ReInit form ...]
    if (FormIndex < 0) or (FormIndex > gApp.Forms.index) then  // if ReCretateActivity
        FormIndex:= gApp.GetNewFormsIndex;  // first valid index = 0;


    gApp.Forms.Stack[FormIndex].Form    := Self;
    gApp.Forms.Stack[FormIndex].CloseCB := FCloseCallBack;

    FormState := fsFormWork;

    if Self.HasActionBar() then
    begin
      if FActionBarTitle = abtHide then
         HideActionBar();

      if FActionBarTitle = abtHideLogo then
          ShowLogoActionBar(False);

      if FActionBarTitle = abtTextAsTitle then
         SetTitleActionBar(FText);

      if FActionBarTitle = abtTextAsTitleHideLogo then
      begin
         ShowLogoActionBar(False);
         SetTitleActionBar(FText);
      end;
    end;

    if (FActivityMode = actMain) or (FActivityMode = actSplash) then
    begin
      FVisible := True;
    end;

    if Assigned(FOnActivityCreate) then FOnActivityCreate(Self, gApp.Jni.jIntent);

    // Detect AppActivityRecreate, launch this event only in the main process or splash
    if gapp.IsAppActivityRecreate then
    begin
       if (FActivityMode = actMain) or (FActivityMode = actSplash) then
          if Assigned(FOnActivityReCreate) then FOnActivityReCreate(Self);

       gapp.IsAppActivityRecreate := false;
    end;

    //Show ...
    if FVisible then
    begin
       gApp.TopIndex:= FormIndex;
       jForm_Show2(gApp.Jni.jEnv, FjObject, FAnimation.In_);
       DoOnShow; //by ADiV
    end;

    if DoJNIPromptOnInit then
    begin
      if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
    end;

  end
  else    //actEasel ...
  begin
    FScreenStyle:= gApp.Orientation;
    FScreenWH:= gApp.Screen.WH;   //sAved on start!

    FWidth   := gApp.Screen.WH.Width;
    FHeight  := gApp.Screen.WH.Height;

    FPackageName:= gApp.AppName;
    ScreenStyleAtStart:= FScreenStyle;   //saved on start!

    FjObject:=  jForm_Create(gApp.Jni.jEnv, gApp.Jni.jThis, Self);

    if FjObject = nil then exit;

    FjRLayout:=  jForm_Getlayout2(gApp.Jni.jEnv, FjObject);  {form view/RelativeLayout} //GetView

    if FjRLayout = nil then exit;

    FjPRLayoutHome:= jForm_GetParent(gApp.Jni.jEnv, FjObject); //save origin
    FjPRLayout:= FjPRLayoutHome;  //base appLayout

    FInitialized:= True;  //need here

    if FAnimationDurationIn <> 1500 then  //default
       SetAnimationDurationIn(FAnimationDurationIn);

    if FAnimationDurationOut <> 1500 then  //default
       SetAnimationDurationOut(FAnimationDurationOut);

    if FAnimationMode <> animNone then  //default
       SetAnimationMode(FAnimationMode);


    for i:= (Self.ComponentCount-1) downto 0 do
    begin
      if (Self.Components[i] is jControl) then
      begin
         (Self.Components[i] as jControl).Init;
      end;
    end;

    if DoJNIPromptOnInit then
    begin
      if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
    end;

  end;

end;

procedure jForm.InitShowing;
begin
   Init;
   Show(False);
end;

procedure jForm.ReInit;
var
  i: integer;
begin

  if not FInitialized then
  begin
     Self.Init;
     Exit;
  end;

  for i:= (Self.ComponentCount-1) downto 0 do
  begin
    if (Self.Components[i] is jControl) then
    begin
       (Self.Components[i] as jControl).Initialized:= False;
    end;
  end;
  self.Initialized:= False;
  Self.Init;
end;

procedure jForm.ReInitShowing;
begin
  ReInit;
  Show(False);
end;

function jForm.GetFormByIndex(index: integer): jForm;
begin
   Result:= nil;
   if FActivityMode = actEasel then Exit;

   if index < gApp.GetCurrentFormsIndex then
      Result:= jForm(gApp.Forms.Stack[index].Form)
   else
      Result:=  jForm(gApp.Forms.Stack[gApp.GetCurrentFormsIndex].Form)
end;

procedure jForm.ShowMessage(msg: string);
begin
  if FInitialized then
     jni_proc_t(gapp.Jni.jEnv, FjObject, 'ShowMessage', msg);
end;

procedure jForm.ShowMessage(_msg: string; _gravity: TGravity; _timeLength: TShowLength);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tii(gapp.Jni.jEnv, FjObject, 'ShowMessage', _msg , Ord(_gravity) ,Ord(_timeLength));
end;

function jForm.GetDateTime: String;
begin
  Result := '';
  if not FInitialized then Exit;
  Result:= jni_func_out_t(gapp.Jni.jEnv,FjObject, 'GetDateTime');
end;

function jForm.GetDateTime( millisDateTime : int64 ) : string;
begin
  Result := '';
  if not FInitialized then Exit;
  Result := jni_func_j_out_t( gapp.Jni.jEnv, FjObject, 'GetDateTime', millisDateTime);
end;

// BY ADiV
function jForm.GetBatteryPercent: integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetBatteryPercent');
end;

function jForm.GetStatusBarHeight: integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetStatusBarHeight');
end;

function jForm.GetActionBarHeight: integer;
begin
  Result := 0;
  if not FInitialized then Exit;

  if FActionBarTitle <> abtNone then
   Result := GetContextTop - GetStatusBarHeight;
end;

function jForm.GetContextTop: integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetContextTop');
end;

function jForm.GetNavigationHeight : integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetNavigationHeight');
end;

//by ADiV
function jForm.GetJavaLastId(): integer;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetJavaLastId');
end;

//by ADiV
procedure jForm.SetDensityAssets( _value : TDensityAssets );

begin
  if not FInitialized then Exit;
  jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetDensityAssets', ord(_value));
end;

// BY ADiV
function jForm.GetTimeInMilliseconds: int64;
begin
  Result := 0;
  if not FInitialized then Exit;
  Result:= jni_func_out_j(gapp.Jni.jEnv,FjObject, 'GetTimeInMilliseconds');
end;

// BY ADiV
function jForm.GetTimeHHssSS( millisTime : int64 ) : string;
begin
  Result := '';
  if not FInitialized then Exit;
  Result:= jni_func_j_out_t(gapp.Jni.jEnv,FjObject, 'GetTimeHHssSS', millisTime);
end;

// BY ADiV
function jForm.GetDateTimeToMillis( _dateTime: string; _zone: boolean ) : int64;
begin
 Result := 0;
 if not FInitialized then Exit;
 Result:= jni_func_tz_out_j(gapp.Jni.jEnv, FjObject, 'GetDateTimeToMillis', _dateTime, _zone);
end;

// BY ADiV
function jForm.GetDateTimeUTC( _dateTime: string ) : string;
begin
 Result := '';
 if not FInitialized then Exit;
 Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetDateTimeUTC', _dateTime);
end;

procedure jForm.SetEnabled(Value: Boolean);
begin
  if FActivityMode = actEasel then Exit;
  FEnabled:= Value;
  if FInitialized then
    jForm_SetEnabled2(gapp.Jni.jEnv, FjObject, FEnabled);
end;

procedure jForm.SetVisible(Value: Boolean);
begin
 FVisible:= Value;
 if FInitialized then
   jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetVisible', FVisible);
end;

procedure jForm.SetColor(Value: TARGBColorBridge);
begin
  //if FActivityMode = actEasel then Exit;
  FColor:= Value;
  if FInitialized then
      View_SetBackGroundColor(gapp.Jni.jEnv, FjRLayout,GetARGB(FCustomColor, FColor));
end;

procedure jForm.UpdateLayout;
var
  i: integer;
begin
  //if FActivityMode = actEasel then Exit;
  if not FInitialized  then Exit;
  for i:= 0 to (Self.ComponentCount - 1) do
  begin
    if Self.Components[i] is jVisualControl then
    begin
       (Self.Components[i] as jVisualControl).UpdateLayout;
    end;
  end;
end;

procedure jForm.Show;
begin
  if FActivityMode = actEasel then Exit;
  if FVisible then Exit;

  if not FInitialized then Exit; //by ADiV

  //If AppRecreateActivity [by ADiV]
  if FormIndex = -1 then
  begin
    ReInit;
    if FVisible then exit;
  end;

  FormState := fsFormWork;
  FormBaseIndex:= gApp.TopIndex;
  gApp.TopIndex:= Self.FormIndex;
  jForm_Show2(gapp.Jni.jEnv,FjObject,FAnimation.In_);
  FVisible:= True;

  if DoJNIPromptOnShow then
  begin
    if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
  end;

  DoOnShow; //by ADiV
end;

procedure jForm.Show(jniPrompt: boolean);
begin
  if FActivityMode = actEasel then Exit;
  if FVisible then Exit;
  if not FInitialized then Exit;

  // If AppRecreateActivity [by ADiV]
  if FormIndex = -1 then
  begin
    ReInit;
    if FVisible then exit;
  end;

  FormState := fsFormWork;
  FVisible:= True;
  FormBaseIndex:= gApp.TopIndex;
  gApp.TopIndex:= Self.FormIndex;
  jForm_Show2(gapp.Jni.jEnv,FjObject,FAnimation.In_);
  if jniPrompt then
  begin
    if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
  end;

  DoOnShow; //by ADiV

end;

procedure jForm.DoJNIPrompt;
begin
  //if FActivityMode = actEasel then Exit;
  if Assigned(FOnJNIPrompt) then FOnJNIPrompt(Self);
end;

//by ADiV
procedure jForm.DoOnShow;
begin

  // if change size
  if (FScreenWH.Width <> gapp.Screen.WH.Width) or
     (FScreenWH.Height <> gapp.Screen.WH.Height) then
  begin
   FScreenWH:= gapp.Screen.WH;
   FWidth   := gapp.Screen.WH.Width;
   FHeight  := gapp.Screen.WH.Height;
   FormChangeSize;
  end;

  if Assigned(FOnShow) then FOnShow(Self);
end;

procedure jForm.FormChangeSize;
begin
 if self.Initialized then
  jni_proc( gapp.Jni.jEnv, FjObject, 'FormChangeSize');
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
  if FActivityMode = actEasel then Exit;
 // Post Closing Step
 // --------------------------------------------------------------------------
 // Java           Java          Java-> Pascal
 // jForm_Close -> RemoveView -> Java_Event_pOnClose
  jni_proc(gapp.Jni.jEnv, FjObject, 'Close2');  //close java form...  remove view layout ....
end;

//[2] after java form close......
Procedure Java_Event_pOnClose(env: PJNIEnv; this: jobject;  Form : TObject);
var
  Inx: integer;
  formBaseInx: integer;
begin

  gApp.Jni.jEnv:= env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Form) then exit; //just precaution...

  if jForm(Form).ActivityMode = actEasel then Exit;

  Inx:= jForm(Form).FormIndex;

  // Prevents the error that is called close before it has been show [by ADiV]
  if Inx = gapp.TopIndex then
  begin
    formBaseInx:= jForm(Form).FormBaseIndex;
    gApp.TopIndex:= formBaseInx; //update topIndex...
  end else
    formBaseInx:= -1;

  if Assigned(jForm(Form).OnClose) then
  begin
    jForm(Form).OnClose(jForm(Form));
  end;

  jForm(Form).FormState := fsFormClose;
  jForm(Form).FVisible  := False;

  if jForm(Form).ActivityMode <> actMain then //actSplash or actRecycable
  begin

      if formBaseInx > -1 then
      begin
        if jForm(gApp.Forms.Stack[formBaseInx].Form).PromptOnBackKey then
            jForm(gApp.Forms.Stack[formBaseInx].Form).DoJNIPrompt; //<<--- thanks to @arenabor

        jForm(gApp.Forms.Stack[formBaseInx].Form).DoOnShow; // by ADiV
      end;

      //LORDMAN - 2013-08-01 // Call Back event
      if Assigned(gApp.Forms.Stack[Inx].CloseCB.Event) then
         gApp.Forms.Stack[Inx].CloseCB.Event(gApp.Forms.Stack[Inx].CloseCB.Sender);

      if Assigned(gApp.Forms.Stack[Inx].CloseCB.EventData) then
         gApp.Forms.Stack[Inx].CloseCB.EventData(gApp.Forms.Stack[Inx].CloseCB.Sender,
                                                 jForm(Form).FCBDataString,
                                                 jForm(Form).FCBDataInteger ,
                                                 jForm(Form).FCBDataDouble);

      if Assigned(gApp.Forms.Stack[Inx].CloseCB.EventPointer) then
         gApp.Forms.Stack[Inx].CloseCB.EventPointer(gApp.Forms.Stack[Inx].CloseCB.Sender,
                                                 jForm(Form).FCBPointer);

      //BacktrackOnClose
      if jForm(Form).TryBacktrackOnClose then
      begin
        // Prevents the error that is called close before it has been show [by ADiV]
        if formBaseInx > 0 then
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
  if FActivityMode = actEasel then Exit;
  if FInitialized then
    View_Invalidate(gapp.Jni.jEnv, Self.View);
end;

procedure jForm.SetCloseCallBack(Func: TOnNotify; Sender: TObject);
begin
  //if not FInitialized then Exit; // SetCloseCallBack is normally called before Init !!
  FCloseCallBack.Event:= Func;
  FCloseCallBack.Sender:= Sender;
end;

procedure jForm.SetCloseCallBack(Func: TOnCallBackData; Sender: TObject);
begin
  //if not FInitialized then Exit; // SetCloseCallBack is normally called before Init !!
  FCloseCallBack.EventData:= Func;
  FCloseCallBack.Sender:= Sender;
end;

procedure jForm.SetCloseCallBack(Func: TOnCallBackPointer; Sender: TObject);
begin
  //if not FInitialized then Exit; // SetCloseCallBack is normally called before Init !!
  FCloseCallBack.EventPointer:= Func;
  FCloseCallBack.Sender:= Sender;
end;

// Event : Java -> Pascal
procedure jForm.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function  jForm.GetOnViewClickListener(jObjForm: jObject): jObject;
begin
  result := nil;
  if FInitialized then
    Result:= jForm_GetOnViewClickListener(gapp.Jni.jEnv, jObjForm);
end;

function  jForm.GetOnListItemClickListener(jObjForm: jObject): jObject;
begin
  result := nil;
  if FInitialized then
    Result:= jForm_GetOnListItemClickListener(gapp.Jni.jEnv, jObjForm);
end;

procedure jForm.GenEvent_OnListItemClick(jObjAdapterView: jObject; //gdx
  jObjView: jObject; position: integer; Id: integer);
begin
  if FInitialized then
    if Assigned(FOnListItemClick) then FOnListItemClick(jObjAdapterView, jObjView,position,Id);
end;

procedure jForm.GenEvent_OnViewClick(jObjView: jObject; Id: integer);  //gdx
begin
   if not FInitialized then Exit;

   if Assigned(FOnViewClick) then FOnViewClick(jObjView,Id);
end;

function jForm.GetStringExtra(intentData: jObject; extraName: string): string;
begin
   result := '';
   if FInitialized then
     Result:= jForm_GetStringExtra(gapp.Jni.jEnv, FjObject, intentData ,extraName);
end;

function jForm.GetIntExtra(intentData: jObject; extraName: string; defaultValue: integer): integer;
begin
  result := 0;
  if FInitialized then
    Result:= jForm_GetIntExtra(gapp.Jni.jEnv, FjObject, intentData ,extraName ,defaultValue);
end;

function jForm.GetDoubleExtra(intentData: jObject; extraName: string; defaultValue: double): double;
begin
  result := 0;
  if FInitialized then
    Result:= jForm_GetDoubleExtra(gapp.Jni.jEnv, FjObject, intentData ,extraName ,defaultValue);
end;

function jForm.SetWifiEnabled(_status: boolean): boolean;
begin
  result := false;

  if not FInitialized then Exit;

  Result:= jni_func_z_out_z(gapp.Jni.jEnv, FjObject, 'SetWifiEnabled', _status);
end;

function jForm.IsWifiEnabled(): boolean;
begin
   result := false;
   if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsWifiEnabled');
end;

function jForm.IsConnected(): boolean; // by renabor
begin
   result := false;
   if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsConnected');
end;

function jForm.IsConnectedWifi(): boolean; // by renabor
begin
  result := false;
  if FInitialized then
     Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsConnectedWifi');
end;

function jForm.IsScreenLocked(): boolean;
begin
   result := false;
   if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsScreenLocked');
end;

function jForm.IsSleepMode(): boolean;
begin
   result := false;
   if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsSleepMode');
end;

function jForm.GetEnvironmentDirectoryPath(_directory: TEnvDirectory): string;
begin
  Result:='';
  if FInitialized then
    Result:= jni_func_i_out_t(gapp.Jni.jEnv, FjObject, 'GetEnvironmentDirectoryPath', Ord(_directory))
end;

function jForm.GetInternalAppStoragePath: string;
begin
  Result:='';
  if FInitialized then
    Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetInternalAppStoragePath');
end;

function jForm.CopyFile(srcFullFilename: string; destFullFilename: string): boolean;
begin
  Result:= False;
  if FInitialized then
    Result:= jni_func_tt_out_z(gapp.Jni.jEnv, FjObject, 'CopyFile', srcFullFilename, destFullFilename);
end;

//by Tomash
function jForm.CopyFileFromUri(srcUri: jObject; destDir: string): string; //tk+
begin
 Result:= '';
 if FInitialized then
   Result:= jForm_CopyFileFromUri(gapp.Jni.jEnv, FjObject, srcUri, destDir);
end;

function jForm.LoadFromAssets(fileName: string): string;
begin
  Result:= '';
  if FInitialized then
    Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'LoadFromAssets', fileName);
end;

function jForm.IsSdCardMounted: boolean;
begin
  Result:= False;
  if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsSdCardMounted');
end;

procedure jForm.DeleteFile(_filename: string);
begin
  if FInitialized then
     jni_proc_t(gapp.Jni.jEnv, FjObject, 'DeleteFile', _filename);
end;

procedure jForm.DeleteFile(_fullPath: string; _filename: string);
begin
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv,FjObject, 'DeleteFile', _fullPath ,_filename);
end;

procedure jForm.DeleteFile(_environmentDir: TEnvDirectory; _filename: string);
begin
  if FInitialized then
     jni_proc_it(gapp.Jni.jEnv, FjObject, 'DeleteFile', Ord(_environmentDir) ,_filename);
end;

function jForm.CreateDir(_dirName: string): string;
begin
  result := '';
  if FInitialized then
    Result:= jni_func_t_out_t(gapp.Jni.jEnv,FjObject, 'CreateDir', _dirName);
end;

function jForm.CreateDir(_environmentDir: TEnvDirectory; _dirName: string): string;
begin
  result := '';
  if FInitialized then
    Result:= jni_func_it_out_t(gapp.Jni.jEnv, FjObject, 'CreateDir', Ord(_environmentDir) ,_dirName);
end;

function jForm.CreateDir(_fullPath: string; _dirName: string): string;
begin
  result := '';
  if FInitialized then
    Result:= jni_func_tt_out_t(gapp.Jni.jEnv, FjObject, 'CreateDir', _fullPath ,_dirName);
end;

function jForm.IsExternalStorageEmulated(): boolean;
begin
  result := false;
  if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsExternalStorageEmulated');
end;

function jForm.IsExternalStorageRemovable(): boolean;
begin
  result := false;
  if FInitialized then
    Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsExternalStorageRemovable');
end;

function jForm.GetjFormVersionFeatures(): string;
begin
  result := '';
  if FInitialized then
    Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetjFormVersionFeatures');
end;

function jForm.GetActionBar(): jObject;
begin
  result := nil;

  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       Result:= jForm_GetActionBar(gapp.Jni.jEnv, FjObject);
  end;
end;

procedure jForm.HideActionBar();
begin
  if FjObject = nil then exit;


  if FActionBarTitle <> abtNone then
   jni_proc(gapp.Jni.jEnv, FjObject, 'HideActionBar');

end;

procedure jForm.ShowActionBar();
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
       jni_proc(gapp.Jni.jEnv, FjObject, 'ShowActionBar');
  end;
end;

procedure jForm.ShowTitleActionBar(_value: boolean);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc_z(gapp.Jni.jEnv, FjObject, 'ShowTitleActionBar', _value);
  end;
end;

procedure jForm.ShowLogoActionBar(_value: boolean);
begin
  if FjObject = nil then exit;

  if FActionBarTitle <> abtNone then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'ShowLogoActionBar', _value);
end;

procedure jForm.SetTitleActionBar(_title: string);
begin
  if FjObject = nil then exit;

  if FActionBarTitle <> abtNone then
    jni_proc_t(gapp.Jni.jEnv, FjObject, 'SetTitleActionBar', _title);

end;

procedure jForm.SetActionBarShowHome( showHome : boolean );
begin
 if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetActionBarShowHome', showHome);
  end;
end;

procedure jForm.SetActionBarColor(color : TARGBColorBridge);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetActionBarColor', GetARGB(FCustomColor, color));
  end;
end;

procedure jForm.SetNavigationColor(color : TARGBColorBridge);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetNavigationColor', GetARGB(FCustomColor, color));
  end;
end;

procedure jForm.SetStatusColor(color : TARGBColorBridge);
begin
  if FInitialized then
  begin
    FColor:= color;

     if FActionBarTitle <> abtNone then
       jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetStatusColor', GetARGB(FCustomColor, FColor));
  end;
end;

procedure jForm.SetSubTitleActionBar(_subtitle: string);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
        jni_proc_t(gapp.Jni.jEnv, FjObject, 'SetSubTitleActionBar', _subtitle);
  end;
end;

procedure jForm.SetIconActionBar(_iconIdentifier: string);
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc_t(gapp.Jni.jEnv, FjObject, 'SetIconActionBar', _iconIdentifier);
  end;
end;

procedure jForm.SetTabNavigationModeActionBar;
begin
  if FInitialized then
  begin
    if FActionBarTitle <> abtNone then
      jni_proc(gapp.Jni.jEnv, FjObject, 'SetTabNavigationModeActionBar');
  end;
end;

procedure jForm.RemoveAllTabsActionBar();
begin
  if FInitialized then
  begin
     if FActionBarTitle <> abtNone then
       jni_proc(gapp.Jni.jEnv, FjObject, 'RemoveAllTabsActionBar');
  end;
end;

function jForm.GetStringResourceId(_resName: string): integer;
begin
  result := 0;

  if FInitialized then
   result:= jni_func_t_out_i(gapp.Jni.jEnv, FjObject, 'GetStringResourceId', _resName);
end;

function jForm.GetStringReplace(_strIn, _strFind, _strReplace: string): string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_ttt_out_t(gapp.Jni.jEnv, FjObject, 'GetStringReplace', _strIn, _strFind, _strReplace);
end;

function jForm.GetStringCopy( _strData: string; _startIndex, _endIndex : integer ) : string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_tii_out_t(gapp.Jni.jEnv, FjObject, 'GetStringCopy', _strData, _startIndex, _endIndex);
end;

function jForm.GetStringPos( _strFind, _strData: string ) : integer;
begin
  result := -1;

  if FInitialized then
   result:= jni_func_tt_out_i(gapp.Jni.jEnv, FjObject, 'GetStringPos', _strFind, _strData);
end;

function jForm.GetStringPosUpperCase( _strFind, _strData: string ) : integer;
begin
  result := -1;

  if FInitialized then
   result:= jni_func_tt_out_i(gapp.Jni.jEnv, FjObject, 'GetStringPosUpperCase', _strFind, _strData);
end;

function jForm.GetStringLength( _strData : string ) : integer;
begin
  result := 0;

  if FInitialized then
   result:= jni_func_t_out_i(gapp.Jni.jEnv, FjObject, 'GetStringLength', _strData);
end;

function jForm.GetStringCapitalize( _strIn : string ) : string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetStringCapitalize', _strIn);
end;

function jForm.GetStringUpperCase(_strIn : string) : string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetStringUpperCase', _strIn);
end;

function jForm.GetStringResourceById(_resID: integer): string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_i_out_t(gapp.Jni.jEnv, FjObject, 'GetStringResourceById', _resID);
end;

function jForm.GetDrawableResourceId(_resName: string): integer;
begin
  result := 0;

  if FInitialized then
    result:= jni_func_t_out_i(gapp.Jni.jEnv, FjObject, 'GetDrawableResourceId', _resName);
end;

function jForm.GetDrawableResourceById(_resID: integer): jObject;
begin
  result := nil;

  if FInitialized then
   result:= jForm_GetDrawableResourceById(gapp.Jni.jEnv, FjObject, _resID);
end;

function jForm.GetQuantityStringByName(_resName: string; _quantity: integer): string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_ti_out_t(gapp.Jni.jEnv, FjObject, 'GetQuantityStringByName', _resName ,_quantity);
end;

function jForm.GetStringResourceByName(_resName: string): string;
begin
  result := '';

  if FInitialized then
   result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetStringResourceByName', _resName);
end;

function jForm.GetSystemVersion: Integer;
begin
  result := 0;

  if(FInitialized) then
    result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetSystemVersion');
end;

function jForm.GetDevicePhoneNumber: String;
begin
   result := '';

   if FInitialized then
    result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDevPhoneNumber');
end;

function jForm.GetDeviceID: String;
begin
   result := '';

   if FInitialized then
   result:=jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDevDeviceID');
end;

function jForm.IsPackageInstalled(_packagename: string): boolean;
begin
  result := false;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(gapp.Jni.jEnv, FjObject, 'IsPackageInstalled', _packagename);
end;

procedure jForm.ShowCustomMessage(_panel: jObject; _gravity: TGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowCustomMessage(gapp.Jni.jEnv, FjObject, _panel, GetGravity(_gravity) );
end;

procedure jForm.CancelShowCustomMessage();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'CancelShowCustomMessage');
end;

procedure jForm.SetScreenOrientationStyle(_orientation: TScreenStyle);
begin
  //in designing component state: set value here...
  FScreenStyle:= _orientation;
  if FInitialized then
     jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetScreenOrientation', Ord(_orientation));
end;

function jForm.GetScreenOrientationStyle(): TScreenStyle;
begin
  //in designing component state: result value here...
  Result:= FScreenStyle;
  if FInitialized then
   Result:= TScreenStyle(jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetScreenOrientation'));
end;

function jForm.GetScreenDpi(): integer;
begin
  result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetScreenDpi');
end;

function jForm.GetScreenRealXdpi(): double;
begin
  result := 0.0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(gapp.Jni.jEnv, FjObject, 'GetScreenRealXdpi');
end;

function jForm.GetScreenRealYdpi(): double;
begin
  result := 0.0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(gapp.Jni.jEnv, FjObject, 'GetScreenRealYdpi');
end;

function jForm.GetScreenDensity(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetScreenDensity');
end;

//SplitStr(var theString: string; delimiter: string): string;
function jForm.GetScreenDensity(strDensity: string): integer;
begin
   result := 0;
   SplitStr(strDensity, ':');
   if (strDensity <> '') then
     Result:= StrToInt(strDensity);
end;

function jForm.GetScreenSize(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetScreenSize');
end;

function jForm.GetScreenRealSizeInInches(): double;
begin
  result := 0.0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_d(gapp.Jni.jEnv, FjObject, 'GetScreenRealSizeInInches');
end;

procedure jForm.LogDebug(_tag: string; _msg: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv, FjObject, 'LogDebug', _tag ,_msg);
end;

procedure jForm.ShowCustomMessage(_layout: jObject; _gravity: TGravity; _lenghTimeSecond: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_ShowCustomMessage(gapp.Jni.jEnv, FjObject, _layout ,GetGravity(_gravity) ,_lenghTimeSecond);
end;

procedure jForm.Vibrate(_milliseconds: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gapp.Jni.jEnv, FjObject, 'Vibrate', _milliseconds);
end;

procedure jForm.Vibrate(var _millisecondsPattern: TDynArrayOfInt64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_Vibrate(gapp.Jni.jEnv, FjObject, _millisecondsPattern);
end;

procedure jForm.TakeScreenshot(_savePath: string; _saveFileNameJPG: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv, FjObject, 'TakeScreenshot', _savePath ,_saveFileNameJPG);
end;

function jForm.GetTitleActionBar(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
    if FActionBarTitle <> abtNone then
       Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetTitleActionBar');

end;

function jForm.GetSubTitleActionBar(): string;
begin
  //in designing component state: result value here...
  result := '';

  if FInitialized then
    if FActionBarTitle <> abtNone then
      Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetSubTitleActionBar');

end;

function jForm.CopyFromAssetsToInternalAppStorage(_filename: string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'CopyFromAssetsToInternalAppStorage', _filename);
end;

procedure jForm.CopyFromInternalAppStorageToEnvironmentDir(_filename: string; _environmentDirPath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv, FjObject, 'CopyFromInternalAppStorageToEnvironmentDir', _filename ,_environmentDirPath);
end;

procedure jForm.CopyFromAssetsToEnvironmentDir(_filename: string; _environmentDirPath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv, FjObject, 'CopyFromAssetsToEnvironmentDir', _filename ,_environmentDirPath);
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

function jForm.GetRealPathFromURI(_Uri: jObject): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetRealPathFromURI(gapp.Jni.jEnv, FjObject, _Uri);
end;

function jForm.ToSignedByte(b: byte): shortint;
begin
  Result:= shortint(b);
end;

//by Tomash
procedure jForm.StartDefaultActivityForFile(_filePath, _mimeType: string);
begin
  if FInitialized then
     jni_proc_tt(gapp.Jni.jEnv, FjObject, 'StartDefaultActivityForFile', _filePath, _mimeType);
end;

function jForm.ActionBarIsShowing(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
    if FActionBarTitle <> abtNone then
      Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'ActionBarIsShowing');

end;

procedure jForm.ToggleSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'ToggleSoftInput');
end;

function jForm.GetDeviceModel(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDeviceModel');
end;

function jForm.GetDeviceManufacturer(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDeviceManufacturer');
end;

procedure jForm.SetActivityMode(Value: TActivityMode);
begin
   if Value <> actGdxScreen then
     FActivityMode:= Value;
end;

procedure jForm.SetKeepScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetKeepScreenOn', _value);
end;

procedure jForm.SetTurnScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetTurnScreenOn', _value);
end;

procedure jForm.SetAllowLockWhileScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetAllowLockWhileScreenOn', _value);
end;

procedure jForm.SetShowWhenLocked(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetShowWhenLocked', _value);
end;

function jForm.ParseUri(_uriAsString: string): jObject;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_ParseUri(gapp.Jni.jEnv, FjObject, _uriAsString);
end;

function jForm.UriToString(_uri: jObject): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_UriToString(gapp.Jni.jEnv, FjObject, _uri);
end;

function jForm.IsConnectedTo(_connectionType: TConnectionType): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_z(gapp.Jni.jEnv, FjObject, 'IsConnectedTo', Ord(_connectionType));
end;

function jForm.IsMobileDataEnabled(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsMobileDataEnabled');
end;

procedure jForm.HideSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'HideSoftInput');
end;

procedure jForm.ShowSoftInput();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'ShowSoftInput');
end;

procedure jForm.SetSoftInputModeAdjust( _inputMode : TInputModeAdjust );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetSoftInputMode', Ord(_inputMode));
end;

function jForm.GetNetworkStatus(): TNetworkStatus;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TNetworkStatus(jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetNetworkStatus'));
end;

function jForm.GetDeviceDataMobileIPAddress(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDeviceDataMobileIPAddress');
end;

function jForm.GetDeviceWifiIPAddress(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetDeviceWifiIPAddress');
end;

function jForm.GetWifiBroadcastIPAddress(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetWifiBroadcastIPAddress');
end;

function jForm.LoadFromAssetsTextContent(_filename: string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'LoadFromAssetsTextContent', _filename);
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

function jForm.GetStripAccents(_str: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetStripAccents', _str);
end;

function jForm.GetStripAccentsUpperCase(_str: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetStripAccentsUpperCase', _str);
end;

function jForm.GetPathFromAssetsFile(_assetsFileName: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetPathFromAssetsFile', _assetsFileName);
end;

function jForm.GetImageFromAssetsFile(_assetsImageFileName: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gapp.Jni.jEnv, FjObject, 'GetImageFromAssetsFile', _assetsImageFileName);
end;

function jForm.GetAssetContentList(_path: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetAssetContentList(gapp.Jni.jEnv, FjObject, _path);
end;

function jForm.GetDriverList(): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDriverList(gapp.Jni.jEnv, FjObject);
end;

function jForm.GetFolderList(_envPath: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFolderList(gapp.Jni.jEnv, FjObject, _envPath);
end;

function jForm.GetFileList(_envPath: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFileList(gapp.Jni.jEnv, FjObject, _envPath);
end;

function jForm.ToStringList(_dynArrayOfString: TDynArrayOfString; _delimiter: char): TStringList;
var
  count, i: integer;
  resList: TStringList;
begin
   resList:= TStringList.Create;
   resList.Delimiter:= _delimiter;
   resList.StrictDelimiter:= True;
   count:= Length(_dynArrayOfString);
   for i:= 0 to  count-1 do
   begin
      if _dynArrayOfString[i] <> '' then
        resList.Add(_dynArrayOfString[i]);
   end;
   Result:= resList;
end;

function jForm.FileExists(_fullFileName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jni_func_t_out_z(gapp.Jni.jEnv, FjObject, 'FileExists', _fullFileName);
end;

function jForm.DirectoryExists(_fullDirectoryName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jni_func_t_out_z(gapp.Jni.jEnv, FjObject, 'DirectoryExists', _fullDirectoryName);
end;

procedure jForm.Minimize();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'Minimize');
end;

procedure jForm.MoveToBack();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'MoveToBack');
end;

procedure jForm.MoveTaskToBack(_nonRoot: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'MoveTaskToBack', _nonRoot);
end;

procedure jForm.MoveTaskToFront();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'MoveTaskToFront');
end;

function jForm.isUsageStatsAllowed(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'isUsageStatsAllowed');
end;

procedure jForm.RequestUsageStatsPermission();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gapp.Jni.jEnv, FjObject, 'RequestUsageStatsPermission');
end;

function jForm.GetTaskInFront(): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetTaskInFront');
end;

function jForm.GetApplicationIcon(_package:string): jObject;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_bmp(gapp.Jni.jEnv, FjObject, 'GetApplicationIcon', _package);
end;

function jForm.GetApplicationName(_package:string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetApplicationName', _package);
end;

function jForm.GetInstalledAppList(): TDynArrayOfString;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetInstalledAppList(gapp.Jni.jEnv, FjObject);
end;

procedure jForm.Restart(_delay: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gapp.Jni.jEnv, FjObject, 'Restart', _delay);
end;

procedure jForm.HideSoftInput(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_HideSoftInput(gapp.Jni.jEnv, FjObject, _view);
end;

function jForm.UriEncode(_message: string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'UriEncode', _message);
end;

function jForm.ParseHtmlFontAwesome(_htmlString: string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'ParseHtmlFontAwesome', _htmlString);
end;

procedure jForm.SetLayoutParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout:= _viewgroup;
  if FInitialized then
     jForm_SetViewParent(gapp.Jni.jEnv, FjObject, FjPRLayout);
end;

procedure jForm.ResetLayoutParent();
begin
  FjPRLayout:= FjPRLayoutHome;
  if FInitialized then
     jForm_SetViewParent(gapp.Jni.jEnv, FjObject, FjPRLayout);
end;

function jForm.GetLayoutParent: jObject;
begin
  Result:= FjPRLayout;
  if FInitialized then
    Result:= jForm_GetParent(gapp.Jni.jEnv, FjObject);
end;

procedure jForm.RemoveFromLayoutParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gapp.Jni.jEnv, FjObject, 'RemoveFromViewParent');
end;


procedure jForm.SetLayoutVisibility(_value: boolean);
begin
  //in designing component state: set value here...
  FLayoutVisibility:= _value;
  if FInitialized then
     jni_proc_z(gapp.Jni.jEnv, FjObject, 'SetLayoutVisibility', _value);
end;

function jForm.GetSettingsSystemInt(_strKey: string): integer;
begin
  result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(gapp.Jni.jEnv, FjObject, 'GetSettingsSystemInt', _strKey);
end;

function jForm.GetSettingsSystemString(_strKey: string): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetSettingsSystemString', _strKey);
end;

function jForm.GetSettingsSystemFloat(_strKey: string): single;
begin
  result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_f(gapp.Jni.jEnv, FjObject, 'GetSettingsSystemFloat', _strKey);
end;

function jForm.GetSettingsSystemLong(_strKey: string): int64;
begin
  result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_j(gapp.Jni.jEnv, FjObject, 'GetSettingsSystemLong', _strKey);
end;

function jForm.PutSettingsSystemInt(_strKey: string; _value: integer): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ti_out_z(gapp.Jni.jEnv, FjObject, 'PutSettingsSystemInt', _strKey ,_value);
end;

function jForm.PutSettingsSystemLong(_strKey: string; _value: int64): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tj_out_z(gapp.Jni.jEnv, FjObject, 'PutSettingsSystemLong', _strKey ,_value);
end;

function jForm.PutSettingsSystemFloat(_strKey: string; _value: single): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tf_out_z(gapp.Jni.jEnv, FjObject, 'PutSettingsSystemFloat', _strKey ,_value);
end;

function jForm.PutSettingsSystemString(_strKey: string; _strValue: string): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_z(gapp.Jni.jEnv, FjObject, 'PutSettingsSystemString', _strKey ,_strValue);
end;

function jForm.IsRuntimePermissionNeed(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsRuntimePermissionNeed');
end;

function jForm.IsRuntimePermissionGranted(_manifestPermission: string): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_z(gapp.Jni.jEnv, FjObject, 'IsRuntimePermissionGranted', _manifestPermission);
end;

procedure jForm.RequestRuntimePermission(_manifestPermission: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ti(gapp.Jni.jEnv, FjObject, 'RequestRuntimePermission', _manifestPermission ,_requestCode);
end;

procedure jForm.RequestRuntimePermission(var _androidPermissions: TDynArrayOfString; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_RequestRuntimePermission(gapp.Jni.jEnv, FjObject, _androidPermissions ,_requestCode);
end;

procedure jForm.RequestRuntimePermission(_androidPermissions: array of string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_RequestRuntimePermission(gapp.Jni.jEnv, FjObject, _androidPermissions ,_requestCode);
end;

function jForm.HasActionBar(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'HasActionBar');
end;

function jForm.IsAppCompatProject(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsAppCompatProject');
end;

function jForm.GetVersionCode() : integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetVersionCode');
end;

function jForm.GetVersionName() : string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetVersionName');
end;

function jForm.GetVersionPlayStore( appUrlString : string ) : string;
begin
  Result := '';

  if FInitialized then
   Result:= jni_func_t_out_t(gapp.Jni.jEnv, FjObject, 'GetVersionPlayStore', appUrlString);
end;

function jForm.GetScreenWidth(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetScreenWidth');
end;

function jForm.GetScreenHeight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetScreenHeight');
end;

function jForm.GetRealScreenWidth(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetRealScreenWidth');
end;

function jForm.GetRealScreenHeight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(gapp.Jni.jEnv, FjObject, 'GetRealScreenHeight');
end;

function jForm.IsInMultiWindowMode(): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsInMultiWindowMode');
end;

function jForm.GetSystemVersionString(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'GetSystemVersionString');
end;

function jForm.GetDateTimeDecode(
                             var day : integer; var month : integer; var year : integer;
                             var hours : integer; var minutes: integer; var seconds : integer ) : boolean;
var
 strDateTime : string;
begin
 Result := false;
 strDateTime := GetDateTime;
 day := 0; month := 0; year := 0;
 hours := 0; minutes := 0; seconds := 0;
 try
   year  := strToInt( copy(strDateTime, 1, 4) );
   month := strToInt( copy(strDateTime, 6, 2) );
   day   := strToInt( copy(strDateTime, 9, 2) );
   hours   := strToInt( copy(strDateTime, 12, 2) );
   minutes := strToInt( copy(strDateTime, 15, 2) );
   seconds := strToInt( copy(strDateTime, 18, 2) );
 except
   exit;
 end;
 Result := true;
end;

procedure jForm.SetBackgroundImageIdentifier(_imageIdentifier: string);
begin
  //in designing component state: set value here...
 FBackgroundImageIdentifier:= _imageIdentifier;

 if FjObject = nil then exit;

 jni_proc_t(gapp.Jni.jEnv, FjObject, 'SetBackgroundImage', _imageIdentifier);
end;

// BY ADiV
procedure jForm.SetBackgroundImageIdentifier(_imageIdentifier: string; _scaleType: integer);
begin
  //in designing component state: set value here...
 FBackgroundImageIdentifier:= _imageIdentifier;
  if FInitialized then
     jni_proc_ti(gapp.Jni.jEnv, FjObject, 'SetBackgroundImage', _imageIdentifier, _scaleType);
end;

// BY ADiV
procedure jForm.SetBackgroundImageMatrix(_scaleX, _scaleY, _degress,
                                         _dx, _dy, _centerX, _centerY : real);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SetBackgroundImageMatrix(gapp.Jni.jEnv, FjObject, _scaleX, _scaleY, _degress,
                                    _dx, _dy, _centerX, _centerY );
end;

function jForm.GetJByteBuffer(_width: integer; _height: integer): jObject;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetJByteBuffer(gapp.Jni.jEnv, FjObject, _width ,_height);
end;

function jForm.GetJByteBufferAddress(jbyteBuffer: jObject): PJByte;
begin
   Result:= PJByte((gapp.Jni.jEnv^).GetDirectBufferAddress(gapp.Jni.jEnv,jbyteBuffer));
end;

function jForm.GetJByteBufferFromImage(_bitmap: jObject): jObject;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetByteBufferFromImage(gapp.Jni.jEnv, FjObject, _bitmap);
end;

function jForm.GetJGlobalRef(jObj: jObject): jObject;
begin
  Result := gapp.Jni.jEnv^.NewGlobalRef(gapp.Jni.jEnv,jObj);
end;

procedure jForm.SetAnimationDurationIn(_animationDurationIn: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationIn:= _animationDurationIn;
  if FjObject = nil then exit;
  jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetAnimationDurationIn', _animationDurationIn);
end;

procedure jForm.SetAnimationDurationOut(_animationDurationOut: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationOut:= _animationDurationOut;
  if FjObject = nil then exit;
  jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetAnimationDurationOut', _animationDurationOut);
end;

procedure jForm.SetAnimationMode(_animationMode: TAnimationMode);
begin
  //in designing component state: set value here...
  FAnimationMode:= _animationMode;
  if FjObject = nil then exit;
  jni_proc_i(gapp.Jni.jEnv, FjObject, 'SetAnimationMode', Ord(_animationMode));
end;

procedure jForm.RunOnUiThread(_tag: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gapp.Jni.jEnv, FjObject, 'RunOnUiThread', _tag);
end;

procedure jForm.CopyStringToClipboard(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gapp.Jni.jEnv, FjObject, 'CopyStringToClipboard', _txt);
end;

function jForm.PasteStringFromClipboard(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(gapp.Jni.jEnv, FjObject, 'PasteStringFromClipboard');
end;

procedure jForm.RequestCreateFile(_envPath: string; _fileMimeType: string; _fileName: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ttti(gapp.Jni.jEnv, FjObject, 'RequestCreateFile', _envPath ,_fileMimeType ,_fileName ,_requestCode);
end;

procedure jForm.RequestOpenFile(_envPath: string; _fileMimeType: string;  _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tti(gapp.Jni.jEnv, FjObject, 'RequestOpenFile', _envPath ,_fileMimeType ,_requestCode);
end;

procedure jForm.RequestOpenDirectory(_envPath: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ti(gapp.Jni.jEnv, FjObject, 'RequestOpenDirectory', _envPath ,_requestCode);
end;

function jForm.GetBitmapFromUri(_treeUri: jObject): jObject;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetBitmapFromUri(gapp.Jni.jEnv, FjObject, _treeUri);
end;

function jForm.LoadBytesFromUri(_treeUri: jObject): TDynArrayOfJByte;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_LoadBytesFromUri(gapp.Jni.jEnv, FjObject, _treeUri);
end;

function jForm.GetFileNameByUri(_treeUri: jObject): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFileNameByUri(gapp.Jni.jEnv, FjObject, _treeUri);
end;

function jForm.GetTextFromUri(_treeUri: jObject): string;
begin
  result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetTextFromUri(gapp.Jni.jEnv, FjObject, _treeUri);
end;

procedure jForm.TakePersistableUriPermission(_treeUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_TakePersistableUriPermission(gapp.Jni.jEnv, FjObject, _treeUri);
end;

procedure jForm.SaveImageToUri(_bitmap: jObject; _toTreeUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SaveImageToUri(gapp.Jni.jEnv, FjObject, _bitmap ,_toTreeUri);
end;


procedure jForm.SaveImageTypeToUri(_bitmap: jObject; _toTreeUri: jObject; _type: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SaveImageTypeToUri(gapp.Jni.jEnv, FjObject, _bitmap ,_toTreeUri, _type);
end;

procedure jForm.SaveBytesToUri(_bytes: TDynArrayOfJByte; _toTreeUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SaveBytesToUri(gapp.Jni.jEnv, FjObject, _bytes ,_toTreeUri);
end;


procedure jForm.SaveTextToUri(_text: string; _toTreeUri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jForm_SaveTextToUri(gapp.Jni.jEnv, FjObject, _text ,_toTreeUri);
end;

function jForm.GetFileList(_treeUri: jObject): TDynArrayOfString;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFileList(gapp.Jni.jEnv, FjObject, _treeUri);
end;


function jForm.GetFileList(_treeUri: jObject; _fileExtension: string): TDynArrayOfString;
begin
  result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetFileList(gapp.Jni.jEnv, FjObject, _treeUri ,_fileExtension);
end;

function jForm.GetMimeTypeFromExtension(_fileExtension: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetMimeTypeFromExtension(gApp.jni.jEnv, FjObject, _fileExtension);
end;

function jForm.GetUriFromFile(_fullFileName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetUriFromFile(gApp.jni.jEnv, FjObject, _fullFileName);
end;

function jForm.IsAirPlaneModeOn(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_IsAirPlaneModeOn(gApp.jni.jEnv, FjObject);
end;

function jForm.IsBluetoothOn(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_IsBluetoothOn(gApp.jni.jEnv, FjObject);
end;

function jForm.GetDeviceBuildVersionApi(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceBuildVersionApi(gApp.jni.jEnv, FjObject);
end;

function jForm.GetDeviceBuildVersionRelease(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jForm_GetDeviceBuildVersionRelease(gApp.jni.jEnv, FjObject);
end;

{-------- jForm_JNI_Bridge ----------}

function jForm_GetBitmapFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapFromUri', '(Landroid/net/Uri;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_LoadBytesFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'LoadBytesFromUri', '(Landroid/net/Uri;)[B');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetFileNameByUri(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileNameByUri', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetTextFromUri(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextFromUri', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jForm_TakePersistableUriPermission(env: PJNIEnv; _jform: JObject; _uri: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'TakePersistableUriPermission', '(Landroid/net/Uri;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jForm_SaveImageToUri(env: PJNIEnv; _jform: JObject; _bitmap: jObject; _toUri: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SaveImageToUri', '(Landroid/graphics/Bitmap;Landroid/net/Uri;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= _toUri;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;



procedure jForm_SaveImageTypeToUri(env: PJNIEnv; _jform: JObject; _bitmap: jObject; _toUri: jObject; _type: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SaveImageTypeToUri', '(Landroid/graphics/Bitmap;Landroid/net/Uri;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= _toUri;
  jParams[2].i:= _type;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jForm_SaveBytesToUri(env: PJNIEnv; _jform: JObject; _bytes: TDynArrayOfJByte; _toUri: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;

  byteArray: jByteArray;
  len: SizeInt;

label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SaveBytesToUri', '([BLandroid/net/Uri;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  len := Length(_bytes);
  byteArray:= env^.NewByteArray(env, len);

  if byteArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetByteArrayRegion(env, byteArray, 0 , len, @_bytes[0]);

  jParams[0].l:= byteArray;
  jParams[1].l:= _toUri;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jForm_SaveTextToUri(env: PJNIEnv; _jform: JObject; _text: string; _toUri: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SaveTextToUri', '(Ljava/lang/String;Landroid/net/Uri;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].l:= _toUri;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _treeUri: jObject): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin

  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileList', '(Landroid/net/Uri;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _treeUri;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _treeUri: jObject; _fileExtension: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin

  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileList', '(Landroid/net/Uri;Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _treeUri;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileExtension));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm.IsExternalStorageReadWriteAvailable(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsExternalStorageReadWriteAvailable');
end;

function jForm.IsExternalStorageReadable(): boolean;
begin
  result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gapp.Jni.jEnv, FjObject, 'IsExternalStorageReadable');
end;

procedure jForm.GenEvent_OnRunOnUiThread(Sender:TObject;tag:integer);
begin
  if Assigned(FOnRunOnUiThread) then FOnRunOnUiThread(Sender,tag);
end;

procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ShowCustomMessage', '(Landroid/view/View;I)V'); //RelativeLayout
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _layout;
  jParams[1].i:= _gravity;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jForm_ShowCustomMessage(env: PJNIEnv; _jform: JObject; _layout: jObject; _gravity: integer; _lenghTimeSecond: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ShowCustomMessage', '(Landroid/view/View;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _layout;
  jParams[1].i:= _gravity;
  jParams[2].i:= _lenghTimeSecond;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetStringExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringExtra', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetIntExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: integer): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntExtra', '(Landroid/content/Intent;Ljava/lang/String;I)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].i:= defaultValue;

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetDoubleExtra(env: PJNIEnv; _jform: JObject; intentData: jObject; extraName: string; defaultValue: double): double;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDoubleExtra', '(Landroid/content/Intent;Ljava/lang/String;D)D');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(extraName));
  jParams[2].d:= defaultValue;

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetActionBar(env: PJNIEnv; _jform: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionBar', '()Landroid/app/ActionBar;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jform, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jForm_GetDrawableResourceById(env: PJNIEnv; _jform: JObject; _resID: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawableResourceById', '(I)Landroid/graphics/drawable/Drawable;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _resID;

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jForm_Vibrate(env: PJNIEnv; _jform: JObject; var _millisecondsPattern: TDynArrayOfInt64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Vibrate', '([J)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_millisecondsPattern);
  jNewArray0:= env^.NewLongArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetLongArrayRegion(env, jNewArray0, 0 , newSize0, @_millisecondsPattern[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_ParseUri(env: PJNIEnv; _jform: JObject; _uriAsString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ParseUri', '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriAsString));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jForm_UriToString(env: PJNIEnv; _jform: JObject; _uri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jform = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'UriToString', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetAssetContentList(env: PJNIEnv; _jform: JObject; _path: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetAssetContentList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetDriverList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDriverList', '()[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jresultArray:= env^.CallObjectMethod(env, _jform, jMethod);

  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetFolderList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFolderList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_envPath));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetFileList(env: PJNIEnv; _jform: JObject; _envPath: string): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_envPath));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jform, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jForm_HideSoftInput(env: PJNIEnv; _jform: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'HideSoftInput', '(Landroid/view/View;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _view;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jForm_SetViewParent(env: PJNIEnv; _jform: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetParent(env: PJNIEnv; _jform: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jform, jMethod);

  Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jForm_RequestRuntimePermission(env: PJNIEnv; _jform: JObject; var _androidPermissions: TDynArrayOfString; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RequestRuntimePermission', '([Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_androidPermissions);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_androidPermissions[i])));
  end;
  jParams[0].l:= jNewArray0;
  jParams[1].i:= _requestCode;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jForm_RequestRuntimePermission(env: PJNIEnv; _jform: JObject; _androidPermissions: array of string; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RequestRuntimePermission', '([Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_androidPermissions);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_androidPermissions[i])));
  end;
  jParams[0].l:= jNewArray0;
  jParams[1].i:= _requestCode;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

// BY ADiV
procedure jForm_SetBackgroundImageMatrix(env: PJNIEnv; _jform: JObject;
                                              _scaleX, _scaleY, _degress,
                                              _dx, _dy, _centerX, _centerY : real);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundImageMatrix', '(FFFFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _scaleX;
  jParams[1].f := _scaleY;
  jParams[2].f := _degress;
  jParams[3].f := _dx;
  jParams[4].f := _dy;
  jParams[5].f := _centerX;
  jParams[6].f := _centerY;

  env^.CallVoidMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetJByteBuffer(env: PJNIEnv; _jform: JObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetJByteBuffer', '(II)Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _width;
  jParams[1].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jForm_GetByteBufferFromImage(env: PJNIEnv; _jform: JObject; _bitmap: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBufferFromImage', '(Landroid/graphics/Bitmap;)Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jForm_GetRealPathFromURI(env: PJNIEnv; _jform: JObject; _Uri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetRealPathFromURI', '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _Uri;

  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetInstalledAppList(env: PJNIEnv; _jform: JObject): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetInstalledAppList', '()[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jresultArray:= env^.CallObjectMethod(env, _jform, jMethod);

  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetMimeTypeFromExtension(env: PJNIEnv; _jform: JObject; _fileExtension: string): string;
var
  jStr: JString;
  //jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetMimeTypeFromExtension', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileExtension));


  jStr:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetUriFromFile(env: PJNIEnv; _jform: JObject; _fullFileName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetUriFromFile', '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullFileName));

  Result:= env^.CallObjectMethodA(env, _jform, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_IsAirPlaneModeOn(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsAirPlaneModeOn', '()Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);

  Result:= boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_IsBluetoothOn(env: PJNIEnv; _jform: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsBluetoothOn', '()Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethod(env, _jform, jMethod);

  Result:= boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jForm_GetDeviceBuildVersionApi(env: PJNIEnv; _jform: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceBuildVersionApi', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _jform, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jForm_GetDeviceBuildVersionRelease(env: PJNIEnv; _jform: JObject): string;
var
  jStr: JString;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jform = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jform);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceBuildVersionRelease', '()Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethod(env, _jform, jMethod);

  Result := GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//-----{ jApp } ------

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
  StopOnException  := True;
  //Device.PhoneNumber := '';
  //Device.ID          := '';
  FInitialized     := False;
  TopIndex:= -1;

  FNewId := 0;
  Forms.Index:= -1;

  IsAppActivityRecreate := False; // For detect AppActivityRecreate

  exceptionCount := 0;
  exceptionInfo  := '';
end;

destructor jApp.Destroy;
begin
  inherited Destroy;
end;

// To automatically enter id from 1 to the limit set by "Controls.java" [by ADiV]
function jApp.GetNewId() : integer;
begin
 FNewId := FNewId + 1;
 result := FNewId;
end;

//by ADiV
function jApp.GetLastId() : integer;
begin
 result := FNewId;
end;

procedure jApp.Init(env: PJNIEnv; this: jObject; activity: jObject;
  layout: jObject; intent: jobject);
var
  startOrient, i: integer;
  AForm: TAndroidForm;
begin
  if FInitialized  then Exit;

  //If AppRecreateActivity reset forms
  if gapp.Forms.Index >= 0 then
  begin
    gapp.TopIndex:= -1;
    for i := 0 to gapp.Forms.Index do
    begin
      AForm := gApp.Forms.Stack[i].Form;
      AForm.FormIndex := -1;
      AForm.FVisible  := false;
    end;
  end;

  // Setting Global Environment
  FillChar(Forms,SizeOf(Forms),#0);
  Forms.Index:= -1; //initial dummy index ...

  // Jni
  Jni.jEnv      := env;  //a reference to the JNI environment

  //[by jmpessoa: for API > 13 "STALED"!!! do not use its!
  Jni.jThis     := this; //["Controls.java"] a reference to the object making this call (or class if static).
  Jni.jActivity := activity;
  Jni.jRLayout  := layout;
  Jni.jIntent   := intent;

  FAPILevel := jni_func_out_i(env, this, 'getAPILevel');

  // Screen
  Screen.WH     := jSysInfo_ScreenWH(env, this);
  startOrient   := jni_func_out_i(env, this, 'systemGetOrientation');

  if  startOrient = 1 then
       Orientation   :=  ssPortrait
  else if startOrient = 2 then
       Orientation   :=  ssLandscape
  else if startOrient = 4 then Orientation:=  ssSensor
  else Orientation   :=  ssUnknown ;

  // Device
  Path.App      := jni_func_t_out_t(env, this, 'getPathApp', PChar(FAppName){gjAppName});
  Path.Dat      := jni_func_out_t(env, this, 'getPathDat');
  Path.Ext      := jni_func_out_t(env, this, 'getPathExt');
  Path.DCIM     := jni_func_out_t(env, this, 'getPathDCIM');

  Path.DataBase := jni_func_out_t(env, this, 'getPathDataBase');

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

  Instance              := TComponent(InstanceClass.NewInstance);
  TComponent(Reference) := Instance;

  if Instance <> nil then
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

procedure jApp.SetAppName(Value: String);
begin
  FAppName:= Value;
end;

procedure jApp.SetjClassName(Value: String);
begin
  FjClassName:= Value;
end;

procedure jApp.Finish();
begin
  jni_proc(Self.Jni.jEnv, Self.Jni.jThis, 'appFinish');
end;

procedure jApp.Recreate();
begin
  jni_proc(Self.Jni.jEnv, Self.Jni.jThis, 'appRecreate');
end;

function jApp.GetContext(): jObject;
begin
  Result:= jApp_GetContext(Self.Jni.jEnv, Self.Jni.jThis);
end;

function jApp.GetControlsVersionInfo: string;
begin
  Result:= jni_func_out_t(Self.Jni.jEnv, Self.Jni.jThis, 'GetControlsVersionInfo'); //"ver&rev|newFeature;ver$rev|newfeature2"
end;

function jApp.GetControlsVersionFeatures: string;     //"ver&rev|newFeature;ver$rev|newfeature2"
begin
  Result:= jni_func_out_t(Self.Jni.jEnv, Self.Jni.jThis, 'GetControlsVersion');
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
   itxNumberFloat     : Result := 'NUMBERFLOAT';   
   itxNumberFloatPositive     : Result := 'NUMBERFLOATPOSITIVE';   
   itxCurrency   : Result := 'CURRENCY';  //thanks to @renabor
   itxPhone      : Result := 'PHONE';
   itxNumberPassword : Result := 'PASSNUMBER';
   itxTextPassword   : Result := 'PASSTEXT';
   itxMultiLine  : Result := 'TEXTMULTILINE';
   itxNull  : Result := 'NULL';  //thanks to jjhofman
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

// by ADiV
function GetARGBJava(customColor: DWord; colbrColor: TARGBColorBridge):  integer;
var
 index: integer;
 A,R,G,B:Byte;
 color : DWord;
begin
  //(conv_clr.A shl 24) + (conv_clr.R shl 16) + (conv_clr.G shl 8) + conv_clr.B;
  if colbrColor <> colbrCustom then
  begin
      index:= (Ord(colbrColor));
      color := TARGBColorBridgeArray[index];
  end else
      color:= customColor;

  A := color shr 24; color := (color - (A shl 24));
  R := color shr 16; color := (color - (R shl 16));
  G := color shr 8;  color := (color - (G shl 8));
  B := color;

  result := (A shl 24) + (R shl 16) + (G shl 8) + B;
end;

// by ADiV
function ARGBToCustomColor( conv_clr: TColorRGBA ): DWORD;
begin
  Result := (conv_clr.A shl 24) + (conv_clr.R shl 16) + (conv_clr.G shl 8) + conv_clr.B;
end;

// by ADiV
function ARGBToCustomColor( _a, _r, _g, _b : byte ): DWORD;
begin
  Result := (_a shl 24) + (_r shl 16) + (_g shl 8) + _b;
end;

// by ADiV
function CustomColorToARGB( cColor : DWORD ): TColorRGBA;
var
  temp : DWORD;
begin
  Result.A := cColor shr 24; temp := (cColor - (Result.A shl 24));
  Result.R := temp   shr 16; temp := (cColor - (Result.A shl 24) - (Result.R shl 16));
  Result.G := temp   shr  8; temp := (cColor - (Result.A shl 24) - (Result.R shl 16) - (Result.G shl 8));
  Result.B := temp;
end;

function GetProgressBarStyle(cjProgressBarStyle: TProgressBarStyle): DWord;
var
  index: integer;
begin
  index:= (Ord(cjProgressBarStyle));
  Result:= TProgressBarStyleArray[index];
end;

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
               Result:= paren.GetWidth;
          end;
     sdH: begin
              Result:= paren.GetHeight;
           end;
   end;
end;


function GetLayoutParamsByParent(paren: jVisualControl; lpParam: TLayoutParams;  side: TSide): DWord;
begin
  result := 0;
  case lpParam of
     lpMatchParent:          Result:= GetParamByParentSide(paren, side);//TLayoutParamsArray[altMATCHPARENT];  //-1
     lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];  //-2
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamByParentSide(paren, side));
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamByParentSide(paren, side));

     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamByParentSide(paren, side));

     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamByParentSide(paren, side)); //0.25
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamByParentSide(paren, side)); //0.125
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamByParentSide(paren, side)); //0.20
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamByParentSide(paren, side)); //0.40
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamByParentSide(paren, side)); //0.60
     lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamByParentSide(paren, side)); //0.75
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamByParentSide(paren, side)); //0.80

     lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamByParentSide(paren, side)); //0.375
     lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamByParentSide(paren, side)); //0.625
     lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamByParentSide(paren, side)); //0.875
     lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamByParentSide(paren, side)); //0.167
     lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamByParentSide(paren, side)); //0.833
     lpNineTenthsOfParent:   Result:= Trunc((9/10)*GetParamByParentSide(paren, side)); //0.90
     lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamByParentSide(paren, side)); //0.95
     lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamByParentSide(paren, side)); //0.99

     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
     lp128px: Result:= 128;
     lp192px: Result:= 192;

     // not yet implemented
     // lpUseWeight: Result:= 0;
     // so, for now:
     //lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];
     lpUseWeight: Result:= GetParamByParentSide(paren, side);

     //lpDesigner: Result:= 0;
  end;
end;

function GetLayoutParamsByParent2(paren: TAndroidWidget; lpParam: TLayoutParams;  side: TSide): DWord;
begin
  result := 0;
  case lpParam of
     lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
     lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
     lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamByParentSide2(paren, side)); //0.66
     lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamByParentSide2(paren, side)); //0.33
     lpHalfOfParent:         Result:= Trunc((1/2)*GetParamByParentSide2(paren, side)); //0.50

     lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamByParentSide2(paren, side)); //0.25
     lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamByParentSide2(paren, side)); //0.125
     lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamByParentSide2(paren, side));  //0.20
     lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamByParentSide2(paren, side));  //0.40
     lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamByParentSide2(paren, side));  //0.60

     lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamByParentSide2(paren, side)); //0.75
     lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamByParentSide2(paren, side)); //0.80

     lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamByParentSide2(paren, side)); //0.375
     lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamByParentSide2(paren, side)); //0.625
     lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamByParentSide2(paren, side)); //0.875
     lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamByParentSide2(paren, side)); //0.167
     lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamByParentSide2(paren, side)); //0.833
     lpNineTenthsOfParent:    Result:= Trunc((9/10)*GetParamByParentSide2(paren, side)); //0.90
     lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamByParentSide2(paren, side));
     lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamByParentSide2(paren, side));

     lp16px: Result:= 16;
     lp24px: Result:= 24;
     lp32px: Result:= 32;
     lp40px: Result:= 40;
     lp48px: Result:= 48;
     lp72px: Result:= 72;
     lp96px: Result:= 96;
     lp128px: Result:= 128;
     lp192px: Result:= 192;

     //lpUseWeight: Result:= 0;
     lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];

     //lpDesigner: Result:= 0;
  end;
end;


function GetParamBySide(App:jApp; side: TSide): DWord;
begin
   case side of
     sdW: Result:= App.Screen.WH.Width;
     sdH: Result:= App.Screen.WH.Height; // - app.GetContextTop;
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
     27: Result:= lp128px;
     28: Result:= lp192px;
     29: Result:= lpExact;
     30: Result:= lpUseWeight;

   end;
end;

function GetLayoutParamsOrd(lpParam: TLayoutParams): DWord;
begin
   Result:= Ord(lpParam);
end;

function GetLayoutParams(App:jApp; lpParam: TLayoutParams; side: TSide): DWord;
begin
  result := 0;

  if App = nil then exit;

  case lpParam of

   lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
   lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
   lpTwoThirdOfParent:     Result:= Trunc((2/3)*GetParamBySide(App, side));
   lpOneThirdOfParent:     Result:= Trunc((1/3)*GetParamBySide(App, side));

   lpHalfOfParent:         Result:= Trunc((1/2)*GetParamBySide(App, side));

   lpOneQuarterOfParent:   Result:= Trunc((1/4)*GetParamBySide(App, side));
   lpOneEighthOfParent:    Result:= Trunc((1/8)*GetParamBySide(App, side));
   lpOneFifthOfParent:     Result:= Trunc((1/5)*GetParamBySide(App, side));
   lpTwoFifthOfParent:     Result:= Trunc((2/5)*GetParamBySide(App, side));
   lpThreeFifthOfParent:   Result:= Trunc((3/5)*GetParamBySide(App, side));
   lpThreeQuarterOfParent: Result:= Trunc((3/4)*GetParamBySide(App, side));
   lpFourFifthOfParent:    Result:= Trunc((4/5)*GetParamBySide(App, side));

   lpThreeEighthOfParent:  Result:= Trunc((3/8)*GetParamBySide(App, side)); //0.375
   lpFiveEighthOfParent:   Result:= Trunc((5/8)*GetParamBySide(App, side)); //0.625
   lpSevenEighthOfParent:  Result:= Trunc((7/8)*GetParamBySide(App, side)); //0.875
   lpOneSixthOfParent:     Result:= Trunc((1/6)*GetParamBySide(App, side)); //0.167
   lpFiveSixthOfParent:    Result:= Trunc((5/6)*GetParamBySide(App, side)); //0.833
   lpNineTenthsOfParent:   Result:= Trunc((9/10)*GetParamBySide(App, side)); //0.90

   lp95PercentOfParent:   Result:= Trunc((9.5/10)*GetParamBySide(App, side));
   lp99PercentOfParent:   Result:= Trunc((9.9/10)*GetParamBySide(App, side));

   lp16px: Result:= 16;
   lp24px: Result:= 24;
   lp32px: Result:= 32;
   lp40px: Result:= 40;
   lp48px: Result:= 48;
   lp72px: Result:= 72;
   lp96px: Result:= 96;
   lp128px: Result:= 128;
   lp192px: Result:= 192;

   //lpUseWeight: Result:= 0;
   lpUseWeight: Result:= TLayoutParamsArray[altMATCHPARENT];

     //lpDesigner: Result:= 0;
  end;
end;

function GetDesignerLayoutParams(lpParam: TLayoutParams;  L: integer): DWord;
begin
  result := 0;
  case lpParam of

   lpMatchParent:          Result:= TLayoutParamsArray[altMATCHPARENT];
   lpWrapContent:          Result:= TLayoutParamsArray[altWRAPCONTENT];
   lpTwoThirdOfParent:     Result:= Trunc((2/3)*L);
   lpOneThirdOfParent:     Result:= Trunc((1/3)*L);

   lpHalfOfParent:         Result:= Trunc((1/2)*L);

   lpOneQuarterOfParent:   Result:= Trunc((1/4)*L);
   lpOneEighthOfParent:    Result:= Trunc((1/8)*L);
   lpOneFifthOfParent:     Result:= Trunc((1/5)*L);
   lpTwoFifthOfParent:     Result:= Trunc((2/5)*L);
   lpThreeFifthOfParent:   Result:= Trunc((3/5)*L);
   lpThreeQuarterOfParent: Result:= Trunc((3/4)*L);
   lpFourFifthOfParent:    Result:= Trunc((4/5)*L);

   lpThreeEighthOfParent:  Result:= Trunc((3/8)*L); //0.375
   lpFiveEighthOfParent:   Result:= Trunc((5/8)*L); //0.625
   lpSevenEighthOfParent:  Result:= Trunc((7/8)*L); //0.875
   lpOneSixthOfParent:     Result:= Trunc((1/6)*L); //0.167
   lpFiveSixthOfParent:    Result:= Trunc((5/6)*L); //0.833
   lpNineTenthsOfParent:   Result:= Trunc((9/10)*L); //0.90

   lp95PercentOfParent:   Result:= Trunc((9.5/10)*L); //0.95
   lp99PercentOfParent:   Result:= Trunc((9.9/10)*L); //0.99

   lp16px: Result:= 16;
   lp24px: Result:= 24;
   lp32px: Result:= 32;
   lp40px: Result:= 40;
   lp48px: Result:= 48;
   lp72px: Result:= 72;
   lp96px: Result:= 96;

   lp128px: Result:= 128;
   lp192px: Result:= 192;

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
   else if Value = 128 then Result:= lp128px
   else if Value = 192 then Result:= lp192px
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
  result := false; if (jObj = nil) or (cls = nil) then exit;

  result := boolean(gApp.Jni.jEnv^.IsInstanceOf(gApp.Jni.jEnv, jObj, cls));
end;

function Get_jObjectClass(jObj: jObject): jClass;
begin
  result := nil; if (jObj = nil) then exit;

  Result := gApp.Jni.jEnv^.GetObjectClass(gApp.Jni.jEnv, jObj);
end;

function Create_jObjectLocalRef(cls: JClass): JObject;
var
  jMethod: JMethodID;
label
  _exceptionOcurred;
begin
  Result := nil; if (cls = nil) then exit;
  // Find the class
  try
    //Get its default constructor
    jMethod := gApp.Jni.jEnv^.GetMethodID(gApp.Jni.jEnv, cls, '<init>', '()V');
    if jMethod = nil then goto _exceptionOcurred;
    //Create the object
    Result := gApp.Jni.jEnv^.NewObjectA(gApp.Jni.jEnv, cls, jMethod, nil);

    _exceptionOcurred: if jni_ExceptionOccurred(gApp.Jni.jEnv) then result := nil;
  except
    on E: Exception do Exit;
  end;
end;

function Get_jObjGlobalRef(jObj: jObject): JObject;
begin
  result := nil; if (jObj = nil) then exit;

  Result := gApp.Jni.jEnv^.NewGlobalRef(gApp.Jni.jEnv,jObj);
end;

function Create_jObjectLocalRefA(cls: JClass;
                        paramFullSignature: string; paramValues: array of jValue): JObject;
var
  jMethod: JMethodID;
label
  _exceptionOcurred;
begin
  Result := nil; if (cls = nil) then exit;
  // Find the class
  try
    //Get its default constructor
    jMethod := gApp.Jni.jEnv^.GetMethodID(gApp.Jni.jEnv, cls, '<init>', PChar('('+paramFullSignature+')V'));
    if jMethod = nil then goto _exceptionOcurred;
    //Create the object
    Result := gApp.Jni.jEnv^.NewObjectA(gApp.Jni.jEnv, cls, jMethod, @paramValues);

    _exceptionOcurred: if jni_ExceptionOccurred(gApp.Jni.jEnv) then result := nil;
  except
    on E: Exception do Exit;
  end;   

end;

function Create_jObjectArray(Len: integer; cls: jClass; initialElement: jObject): jObject;
begin
  Result := nil; if (cls = nil) or (initialElement = nil) then exit;

  try
    Result := gApp.Jni.jEnv^.NewObjectArray(gApp.Jni.jEnv, len, cls, initialElement);
  except
    on E: Exception do Exit;
  end;
end;

procedure Set_jObjectArrayElement(jobjectArray: jObject; index: integer; element: jObject);
begin
  if (jobjectArray = nil) or (element = nil) then exit;

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
  if (jobjectArray = nil) then exit;

  jClass_string := Get_jClassLocalRef('java/lang/String');

  if (jClass_string = nil) then exit;

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
  Result:= nil; if (jobjectArray = nil) then exit;

  Result:= gApp.Jni.jEnv^.GetObjectArrayElement(gApp.Jni.jEnv, jobjectArray, index);
end;

function Get_jArrayLength(jobjectArray: jObject): integer;
begin
  Result:= 0; if (jobjectArray = nil) then exit;

  Result:= gApp.Jni.jEnv^.GetArrayLength(gApp.Jni.jEnv, jobjectArray);
end;

function Get_jStaticMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
begin
  Result:= nil; if (cls = nil) then exit;
    //a jmethodID is not an object. So don't need to convert it to a GlobalRef!
  Result:= gApp.Jni.jEnv^.GetStaticMethodID( gApp.Jni.jEnv, cls , PChar(funcName), PChar(funcSignature));
end;

//fixed missing...
function Get_jMethodID(cls: jClass; funcName, funcSignature : string): jMethodID;
begin
  Result:= nil; if (cls = nil) then exit;
    //a jmethodID is not an object. So don't need to convert it to a GlobalRef!
  Result:= gApp.Jni.jEnv^.GetMethodID( gApp.Jni.jEnv, cls , PChar(funcName), PChar(funcSignature));
end;


function Call_jIntMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue): integer;
begin
  Result:= 0; if (jObj = nil) or (method = nil) then exit;

  Result:= gApp.Jni.jEnv^.CallIntMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

function Call_jDoubleMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): double;
begin
  Result:= 0; if (jObj = nil) or (method = nil) then exit;

  Result:= gApp.Jni.jEnv^.CallDoubleMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

function Call_jDoubleMethod(jObj:jObject; method: jMethodID): double;
begin
  Result:= 0; if (jObj = nil) or (method = nil) then exit;

  Result:= gApp.Jni.jEnv^.CallDoubleMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jIntMethod(jObj:jObject; method: jMethodID): integer;
begin
  Result:= 0; if (jObj = nil) or (method = nil) then exit;

  Result:= gApp.Jni.jEnv^.CallIntMethod(gApp.Jni.jEnv, jObj, method);
end;

procedure Call_jVoidMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue);
begin
   if (jObj = nil) or (method = nil) then exit;

   gApp.Jni.jEnv^.CallVoidMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

procedure Call_jVoidMethod(jObj:jObject; method: jMethodID);
begin
   if (jObj = nil) or (method = nil) then exit;

   gApp.Jni.jEnv^.CallVoidMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jObjectMethodA(jObj:jObject; method: jMethodID; var jParams: array of jValue): jObject;
begin
   Result:= nil; if (jObj = nil) or (method = nil) then exit;

   Result:= gApp.Jni.jEnv^.CallObjectMethodA(gApp.Jni.jEnv, jObj, method, @jParams);
end;

function Call_jObjectMethod(jObj:jObject; method: jMethodID): jObject;
begin
   Result:= nil; if (jObj = nil) or (method = nil) then exit;

   Result:= gApp.Jni.jEnv^.CallObjectMethod(gApp.Jni.jEnv, jObj, method);
end;

function Call_jBooleanMethod(jObj:jObject; method: jMethodID): boolean;
begin
   Result:= false; if (jObj = nil) or (method = nil) then exit;

   Result:= boolean(gApp.Jni.jEnv^.CallBooleanMethod(gApp.Jni.jEnv, jObj, method));
end;

function Call_jBooleanMethodA(jObj:jObject; method: jMethodID; var jParams:array of jValue): boolean;
begin
     Result:= false; if (jObj = nil) or (method = nil) then exit;

     Result:= boolean(gApp.Jni.jEnv^.CallBooleanMethodA(gApp.Jni.jEnv, jObj, method, @jParams));
end;

procedure Delete_jLocalParamRef(var jParams: array of jValue; index: integer);
begin
  gApp.Jni.jEnv^.DeleteLocalRef(gApp.Jni.jEnv, jParams[index].l);
end;

procedure Delete_jLocalRef(jObj: jObject);
begin
  if (jObj = nil) then exit;

  gApp.Jni.jEnv^.DeleteLocalRef(gApp.Jni.jEnv, jObj);
end;

procedure Delete_jGlobalRef(jObj: jObject);
begin
  if (jObj = nil) then exit;

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
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := 0;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:= gApp.Jni.jEnv^.CallStaticIntMethodA(gApp.Jni.jEnv, cls, jMethod, @jParams);

  Delete_jLocalRef(cls);

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function Call_jStaticIntMethod(fullClassName: string;
                       funcName: string; funcSignature: string): integer;
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := 0;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:= gApp.Jni.jEnv^.CallStaticIntMethod(gApp.Jni.jEnv, cls, jMethod);

  Delete_jLocalRef(cls); 

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function Call_jStaticDoubleMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue): double;
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := 0;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:= gApp.Jni.jEnv^.CallStaticDoubleMethodA(gApp.Jni.jEnv, cls, jMethod, @jParams);

  Delete_jLocalRef(cls);  

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function Call_jStaticDoubleMethod(fullClassName: string; funcName: string; funcSignature: string): double;
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := 0;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:= gApp.Jni.jEnv^.CallStaticDoubleMethod(gApp.Jni.jEnv, cls, jMethod);

  Delete_jLocalRef(cls);  

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

procedure Call_jCallStaticVoidMethodA(fullClassName: string; funcName: string; funcSignature: string; var jParams: array of jValue);
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  gApp.Jni.jEnv^.CallStaticVoidMethodA(gApp.Jni.jEnv, cls, jMethod, @jParams);

  Delete_jLocalRef(cls);   

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

procedure Call_jCallStaticVoidMethod(fullClassName: string; funcName: string; funcSignature: string);
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  gApp.Jni.jEnv^.CallStaticVoidMethod(gApp.Jni.jEnv, cls, jMethod);

  Delete_jLocalRef(cls);  

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function Call_jCallStaticBooleanMethodA(fullClassName: string;
                       funcName: string; funcSignature: string; var jParams: array of jValue): boolean;
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := false;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:=  boolean(gApp.Jni.jEnv^.CallStaticBooleanMethodA(gApp.Jni.jEnv, cls, jMethod, @jParams));

  Delete_jLocalRef(cls);  

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function Call_jCallStaticBooleanMethod(fullClassName: string;
                       funcName: string; funcSignature: string): boolean;
var
  cls: jClass;
  jMethod: jMethodID;
label
  _exceptionOcurred;
begin
  result := false;

  cls:= Get_jClassLocalRef(fullClassName);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= Get_jStaticMethodID(cls, funcName, funcSignature);
  if jMethod = nil then begin Delete_jLocalRef(cls); goto _exceptionOcurred; end;

  Result:= boolean(gApp.Jni.jEnv^.CallStaticBooleanMethod(gApp.Jni.jEnv, cls, jMethod));

  Delete_jLocalRef(cls);   

  _exceptionOcurred: jni_ExceptionOccurred(gApp.Jni.jEnv);
end;

function jApp_GetAssetContentList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString; 
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  SizeArr, i: Integer;
label
  _exceptionOcurred;
begin  
  Result := nil; if (env = nil) or (this = nil) then exit;

  JCls := env^.GetObjectClass(env, this);
  if jCls = nil then goto _exceptionOcurred;
  JMethod := env^.GetMethodID(env, JCls, 'getAssetContentList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  JParams[0].l := env^.NewStringUTF(env, PChar(Path));

  if JParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams);

  if(DataArray <> nil) then 
  begin 
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr); 
    for i := 0 to SizeArr - 1 do 
    begin 
      StrX := env^.GetObjectArrayElement(env, DataArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, StrX);
    end;
  end;

  env^.DeleteLocalRef(env, JParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jApp_GetDriverList(env: PJNIEnv; this: JObject): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  StrX: JString;
  SizeArr, i: Integer;
label
  _exceptionOcurred;
begin
  Result := nil; if (env = nil) or (this = nil) then exit;

  JCls := env^.GetObjectClass(env, this);
  if jCls = nil then goto _exceptionOcurred;
  JMethod := env^.GetMethodID(env, JCls, 'getDriverList', '()[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  DataArray := env^.CallObjectMethod(env, this, JMethod);

  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, StrX);
    end;
  end;

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jApp_GetFolderList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  SizeArr, i: Integer;
label
  _exceptionOcurred;
begin
  Result := nil; if (env = nil) or (this = nil) then exit;

  JCls := env^.GetObjectClass(env, this);
  if jCls = nil then goto _exceptionOcurred;
  JMethod := env^.GetMethodID(env, JCls, 'getFolderList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  JParams[0].l := env^.NewStringUTF(env, PChar(Path));

  if JParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams);

  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, StrX);
    end;
  end;

  env^.DeleteLocalRef(env, JParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jApp_GetFileList(env: PJNIEnv; this: JObject; Path: string): TDynArrayOfString;
  var
  JCls: JClass = nil;
  JMethod: JMethodID = nil;
  DataArray: JObject;
  JParams: array[0..0] of JValue;
  StrX: JString;
  SizeArr, i: Integer;
label
  _exceptionOcurred;
begin
  Result := nil; if (env = nil) or (this = nil) then exit;

  JCls := env^.GetObjectClass(env, this);
  if jCls = nil then goto _exceptionOcurred;
  JMethod := env^.GetMethodID(env, JCls, 'getFileList', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  JParams[0].l := env^.NewStringUTF(env, PChar(Path));

  if JParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  DataArray := env^.CallObjectMethodA(env, this, JMethod, @JParams);

  if(DataArray <> nil) then
  begin
    SizeArr := env^.GetArrayLength(env, DataArray);
    SetLength(Result, SizeArr);
    for i := 0 to SizeArr - 1 do
    begin
      StrX := env^.GetObjectArrayElement(env, DataArray, i);

      Result[i]:= GetPStringAndDeleteLocalRef(env, StrX);
    end;
  end;

  env^.DeleteLocalRef(env, JParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function  jApp_GetContext(env:PJNIEnv; this:jobject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (this = nil) then exit;

  cls := env^.GetObjectClass(env, this);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetContext', '()Landroid/content/Context;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, this, jMethod);

  env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function  jForm_GetOnViewClickListener(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (Form = nil) then exit;

  cls := env^.GetObjectClass(env, Form);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetOnViewClickListener', '()Landroid/view/View$OnClickListener;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, Form, jMethod);

  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function  jForm_GetOnListItemClickListener(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (Form = nil) then exit;

  cls := env^.GetObjectClass(env, Form);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetOnListItemClickListener', '()Landroid/widget/AdapterView$OnItemClickListener;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, Form, jMethod);

  env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


//by jmpessoa
procedure jApp_GetJNIEnv(var env:PJNIEnv);
var
 PEnv: PPointer {PJNIEnv};
begin
  gVM^.GetEnv(gVM, @PEnv,JNI_VERSION_1_6);
  env:= PJNIEnv(PEnv);
end;

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

Function  jForm_Create (env:PJNIEnv; this: jobject; SelfObj : TObject) : jObject;
var
 jMethod : jMethodID = nil;
 _jParam  : jValue;
  _cls: jClass;
label
  _exceptionOcurred;
begin
 result := nil; if (env = nil) or (this = nil) or (SelfObj = nil) then exit;

 _cls:= Get_gjClass(env);
 if _cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, _cls, 'jForm_Create', '(J)Ljava/lang/Object;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParam.j := Int64(SelfObj);

 Result := env^.CallObjectMethodA(env, this,jMethod,@_jParam);

 if result <> nil then Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//by jmpessoa   -- java clean up ....
Procedure jForm_Free2(env:PJNIEnv; Form: jObject);
begin

 if (env = nil) or (Form = nil) then exit;

 jni_proc(env, Form, 'Free');

end;

//addView( layout )
Procedure jForm_Show2(env:PJNIEnv; Form: jObject; effect : Integer);
begin
    if (env = nil) or (Form = nil) then exit;

    jni_proc_i(env, Form, 'Show', effect);
end;

//by jmpessoa
Function jForm_GetLayout2(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (Form = nil) then exit;

  cls := env^.GetObjectClass(env, Form);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetLayout', '()Landroid/widget/RelativeLayout;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, Form, jMethod);

  Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

Function jForm_GetView(env:PJNIEnv; Form: jObject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (Form = nil) then exit;

  cls := env^.GetObjectClass(env, Form);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetView', '()Landroid/widget/RelativeLayout;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result := env^.CallObjectMethod(env, Form, jMethod);

  if result <> nil then Result := env^.NewGlobalRef(env,Result);   //<---- need here for ap1 > 13 - by jmpessoa
  env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//by jmpessoa
Function jForm_GetClickListener(env:PJNIEnv; Form: jObject): jObject;
var
   cls: jClass;
   jMethod: jmethodID;
label
  _exceptionOcurred;
begin
    result := nil; if (env = nil) or (Form = nil) then exit;

    cls := env^.GetObjectClass(env, Form);
    if cls = nil then goto _exceptionOcurred;
    jMethod:= env^.GetMethodID(env, cls, 'GetClikListener', '()Landroid/view/View$OnClickListener;');
    if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

    Result:= env^.CallObjectMethod(env, Form, jMethod);

    env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//by jmpessoa
Procedure jForm_FreeLayout(env:PJNIEnv; Layout: jObject);
begin
  if (env = nil) or (Layout = nil) then exit;

  env^.DeleteGlobalRef(env, Layout);
end;

 //by jmpessoa
Procedure jForm_SetEnabled2(env:PJNIEnv;Form : jObject; enabled : Boolean);
begin
    if (env = nil) or (Form = nil) then exit;

    jni_proc_z(env, Form, 'SetEnabled', enabled);
end;

function jForm_CopyFileFromUri(env: PJNIEnv;  _jform: JObject; _srcUri : JObject; _destDir: string): string;
var
   _jCls: jClass;
   jMethod: jmethodID;
   _jString : jstring;
   _jParams : Array[0..1] of jValue;
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jform = nil) or (_srcUri = nil) then exit;

  _jCls := env^.GetObjectClass(env, _jform);
  if _jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, _jCls, 'CopyFileFromUri', '(Landroid/net/Uri;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, _jCls); goto _exceptionOcurred; end;

  _jParams[0].l:= _srcUri;
  _jParams[1].l:= env^.NewStringUTF(env, pchar(_destDir) );

  if _jParams[1].l = nil then begin env^.DeleteLocalRef(env, _jCls); goto _exceptionOcurred; end;

  _jString:= env^.CallObjectMethodA(env, _jform, jMethod,@_jParams);

  Result:= GetPStringAndDeleteLocalRef(env, _jString);
  env^.DeleteLocalRef(env, _jParams[1].l);
  env^.DeleteLocalRef(env, _jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// View  - generics - "controls.java"
//------------------------------------------------------------------------------

//by jmpessoa
procedure View_AddLParamsParentRule(env:PJNIEnv; _jobject : jObject; rule: DWord);
Var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
   if (env = nil) or (_jobject = nil) then exit;

   cls:= env^.GetObjectClass(env, _jobject);
   if cls = nil then goto _exceptionOcurred;
   jMethod:= env^.GetMethodID(env, cls, 'AddLParamsParentRule', '(I)V');
   if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

   _jParams[0].i := rule;

   env^.CallVoidMethodA(env,_jobject,jMethod,@_jParams);

   env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_AddLParamsAnchorRule(env:PJNIEnv; _jobject : jObject; rule: DWord);
var
   jMethod : jMethodID = nil;
    _jParams : array[0..0] of jValue;
   cls: jClass;
label
  _exceptionOcurred;
begin
   if (env = nil) or (_jobject = nil) then exit;

   cls := env^.GetObjectClass(env, _jobject);
   if cls = nil then goto _exceptionOcurred;
   jMethod:= env^.GetMethodID(env, cls, 'AddLParamsAnchorRule', '(I)V');
   if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

   _jParams[0].i := rule;

   env^.CallVoidMethodA(env, _jobject, jMethod, @_jParams);

   env^.DeleteLocalRef(env, cls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_SetLGravity(env: PJNIEnv; _jobject: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _value;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_SetLWeight(env: PJNIEnv; _jobject: JObject; _w: single);
var
       jParams: array[0..0] of jValue;
       jMethod: jMethodID = nil;
       jCls: jClass = nil;
label
  _exceptionOcurred;
begin
       if (env = nil) or (_jobject = nil) then exit;

       jCls := env^.GetObjectClass(env, _jobject);
       if jCls = nil then goto _exceptionOcurred;
       jMethod := env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
       if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

       jParams[0].f := _w;

       env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

       env^.DeleteLocalRef(env, jCls);   

       _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_SetLParamHeight(env:PJNIEnv; _jobject : jObject; h: DWord);
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (_jobject = nil) then exit;

 cls := env^.GetObjectClass(env, _jobject);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'SetLParamHeight', '(I)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].i := h;

 env^.CallVoidMethodA(env, _jobject,jMethod,@_jParams);

 env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_SetLParamWidth(env:PJNIEnv; _jobject : jObject; w: DWord);
var
   jMethod : jMethodID = nil;
   _jParams : array[0..0] of jValue;
   cls: jClass;
label
  _exceptionOcurred;
begin
   if (env = nil) or (_jobject = nil) then exit;

   cls := env^.GetObjectClass(env, _jobject);
   if cls = nil then goto _exceptionOcurred;
    jMethod:= env^.GetMethodID(env, cls, 'SetLParamWidth', '(I)V');
   if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

   _jParams[0].i := w;

   env^.CallVoidMethodA(env,_jobject,jMethod,@_jParams);

   env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_SetLayoutAll(env:PJNIEnv; _jobject : jObject;  idAnchor: DWord);
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (_jobject = nil) then exit;

 cls := env^.GetObjectClass(env, _jobject);
 if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'SetLayoutAll', '(I)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].i := idAnchor;

 env^.CallVoidMethodA(env,_jobject,jMethod,@_jParams);

 env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_ClearLayoutAll(env: PJNIEnv; _jobject: JObject);
var
    jMethod: jMethodID=nil;
    jCls: jClass=nil;
label
  _exceptionOcurred;
begin
    if (env = nil) or (_jobject = nil) then exit;

    jCls:= env^.GetObjectClass(env, _jobject);
    if jCls = nil then goto _exceptionOcurred;
    jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
    if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

    env^.CallVoidMethod(env, _jobject, jMethod);

    env^.DeleteLocalRef(env, jCls); 

    _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function View_GetLParamWidth(env:PJNIEnv; _jobject : jObject): integer;
var
  jMethod : jMethodID = nil;
  cls: jClass;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  cls := env^.GetObjectClass(env, _jobject);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetLParamWidth', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env,_jobject,jMethod);

  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function View_GetLParamHeight(env:PJNIEnv; _jobject : jObject ): integer;
var
 jMethod : jMethodID = nil;
 cls: jClass;
label
  _exceptionOcurred;
begin
 result := 0; if (env = nil) or (_jobject = nil) then exit;

 cls := env^.GetObjectClass(env, _jobject);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'GetLParamHeight', '()I');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 Result:= env^.CallIntMethod(env,_jobject,jMethod);

 env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_SetId(env:PJNIEnv; view : jObject; Id :DWord);
var
  jMethod: jmethodID;
  _jParams : array[0..0] of jValue;
    cls: jClass;
label
  _exceptionOcurred;
begin
  if (env = nil) or (view = nil) then exit;

  cls:= env^.GetObjectClass(env, view);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].i:= Id;

  env^.CallVoidMethodA(env, view, jMethod, @_jParams);

  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jobject: JObject;
                          _left, _top, _right, _bottom, _width, _height: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _width;
  jParams[5].i:= _height;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//by jmpessoa
Procedure View_SetVisible(env:PJNIEnv; this:jobject; view : jObject; visible : Boolean);
var
  jMethod: jmethodID;
  _jParams : array[0..1] of jValue;
    cls: jClass;
label
  _exceptionOcurred;
begin
  if (env = nil) or (this = nil) or (view = nil) then exit;

  cls:= Get_gjClass(env);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'view_SetVisible', '(Landroid/view/View;I)V');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].l := view;
  case visible of
    True  : _jParams[1].i := 0; //
    False : _jParams[1].i := 4; //
  end;

  env^.CallVoidMethodA(env, this, jMethod, @_jParams);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


Procedure View_SetVisible(env:PJNIEnv; view: jObject; visible: Boolean);
var
  jMethod: jmethodID;
  _jParams : array[0..0] of jValue;
    cls: jClass;
label
  _exceptionOcurred;
begin
  if (env = nil) or (view = nil) then exit;

  cls:= env^.GetObjectClass(env, view);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'setVisibility', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  case visible of
    True  : _jParams[0].i := 0; // visible
    False : _jParams[0].i := 4; // invisible
  end;

  env^.CallVoidMethodA(env, view, jMethod, @_jParams);

  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function View_GetVisible(env:PJNIEnv; view: jObject): boolean;
var
   //jBoo: JBoolean;
   jParams: array[0..0] of jValue;
   jMethod: jMethodID=nil;
   jCls: jClass=nil;
   res: integer;
label
  _exceptionOcurred;
begin
   Result:= False; if (env = nil) or (view = nil) then exit;

   jCls:= env^.GetObjectClass(env, view);
   if jCls = nil then goto _exceptionOcurred;
   jMethod:= env^.GetMethodID(env, jCls, 'getVisibility', '()I');
   if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

   jParams[0].l:= view;

   res:= env^.CallIntMethodA(env, view, jMethod, @jParams);

   env^.DeleteLocalRef(env, jCls);
   if res = 0  then Result:= True;   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by jmpessoa
Procedure View_SetBackGroundColor(env:PJNIEnv;this:jobject; view : jObject; color : DWord);
var
 jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
  cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (this = nil) or (view = nil) then exit;

 cls:= Get_gjClass(env);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'view_SetBackGroundColor', '(Landroid/view/View;I)V');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l := view;
 _jParams[1].i := color;

 env^.CallVoidMethodA(env,this,jMethod,@_jParams);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_SetBackGroundColor(env:PJNIEnv; view : jObject; color : DWord);
var
 jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (view = nil) then exit;

 cls:= env^.GetObjectClass(env, view);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'setBackgroundColor', '(I)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].i := color;

 env^.CallVoidMethodA(env,view,jMethod,@_jParams);

 env^.DeleteLocalRef(env, cls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_Invalidate(env:PJNIEnv; this:jobject; view : jObject);
var
 jMethod : jMethodID = nil;
 _jParam  : jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (this = nil) or (view = nil) then exit;

 cls:= Get_gjClass(env);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'view_Invalidate', '(Landroid/view/View;)V');
 if jMethod = nil then goto _exceptionOcurred;

 _jParam.l := view;

 env^.CallVoidMethodA(env,this,jMethod,@_jParam);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_Invalidate(env:PJNIEnv;  view : jObject);
var
 jMethod : jMethodID = nil;
 cls: jClass; 
label
  _exceptionOcurred;
begin
 if (env = nil) or (view = nil) then exit;

 cls:= env^.GetObjectClass(env, view);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'invalidate', '()V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethod(env,view,jMethod);

 env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_SetTextColor(env:PJNIEnv; view : jObject; color : DWord);
var
 jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass; 
label
  _exceptionOcurred;
begin
 if (env = nil) or (view = nil) then exit;

 cls:= env^.GetObjectClass(env, view);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].i := color;

 env^.CallVoidMethodA(env,view,jMethod,@_jParams);
 env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_PostInvalidate(env:PJNIEnv; view : jObject);
var
 jMethod : jMethodID = nil;
 cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (view = nil) then exit;

 cls:= env^.GetObjectClass(env, view);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'postInvalidate', '()V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethod(env,view,jMethod);

 env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure View_BringToFront(env:PJNIEnv; view : jObject);
var
 jMethod : jMethodID = nil;
 cls: jClass;
label
  _exceptionOcurred;
begin

 if (env = nil) or (view = nil) then exit;

 cls:= env^.GetObjectClass(env, view);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'BringToFront', '()V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethod(env,view,jMethod);

 env^.DeleteLocalRef(env, cls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_SetViewParent(env: PJNIEnv; view: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (view = nil) or (_viewgroup = nil) then exit;

  jCls:= env^.GetObjectClass(env, view);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, view, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure View_RemoveFromViewParent(env: PJNIEnv; view: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (view = nil) then exit;

  jCls:= env^.GetObjectClass(env, view);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, view, jMethod);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function View_GetView(env: PJNIEnv; view: JObject): jObject;
var
     jMethod: jMethodID = nil;
     jCls: jClass = nil;
label
  _exceptionOcurred;
begin
     result := nil; if (env = nil) or (view = nil) then exit;

     jCls := env^.GetObjectClass(env, view);
     if jCls = nil then goto _exceptionOcurred;
     jMethod := env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
     if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     Result := env^.CallObjectMethod(env, view, jMethod);

     env^.DeleteLocalRef(env, jCls);  

     _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function View_GetViewGroup(env:PJNIEnv; view : jObject) : jObject;
var
  jMethod : jMethodID = nil;
  cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (view = nil) then exit;

  cls := env^.GetObjectClass(env, view);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetView', '()Landroid/view/ViewGroup;'); //Landroid/widget/RelativeLayout;
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result := env^.CallObjectMethod(env, view,jMethod);

  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function View_GetParent(env: PJNIEnv; view: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (view = nil) then exit;

  jCls:= env^.GetObjectClass(env, view);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, view, jMethod);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// System Info
//------------------------------------------------------------------------------

// Get Device Screen
Function  jSysInfo_ScreenWH (env:PJNIEnv;this:jobject) : TWH;
 Var
  jMethod  : jMethodID = nil;
  _wh      : Integer;
  jCls     : jClass=nil;
label
  _exceptionOcurred;
 begin
  Result.Width  := 0;
  Result.Height := 0;

  if (env = nil) or (this = nil) then exit;

  jCls:= env^.GetObjectClass(env, this);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'getScreenWH', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  _wh           := env^.CallIntMethod(env,this,jMethod);
  Result.Width  := (_wh shr 16);
  Result.Height := (_wh and $0000FFFF);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
 end;

//by thierrydijoux
Function jSysInfo_Language (env:PJNIEnv; this: jObject; localeType: TLocaleType): String;
begin
 Result:= jni_func_i_out_t(env, this, 'getLocale', Ord(localeType));
end;

Procedure jSystem_ShowAlert(env:PJNIEnv; this:jobject; _title: string; _message: string; _btnText: string);
var
 jMethod : jMethodID = nil;
 _jParams  : Array[0..2] of jValue;
 jCls   : jClass=nil;
label
  _exceptionOcurred;
begin
 if (env = nil) or (this = nil) then exit;

 jCls:= env^.GetObjectClass(env, this);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'ShowAlert', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env,jCls); goto _exceptionOcurred; end;

 _jParams[0].l := env^.NewStringUTF(env, pchar(_title) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(_message));
 _jParams[2].l := env^.NewStringUTF(env, pchar(_btnText));

 if (_jParams[0].l = nil) then begin env^.DeleteLocalRef(env,jCls); goto _exceptionOcurred; end;
 if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,jCls); goto _exceptionOcurred; end;
 if (_jParams[2].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,jCls); goto _exceptionOcurred; end;

 env^.CallVoidMethodA(env,this,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

// --- Jni create, procedures and functions ---//

function jni_ExceptionOccurred(env: PJNIEnv) : boolean;
var
  exc   : jthrowable;
  jStr  : jString;
  mid   : jMethodID=nil;
  clazz : jClass=nil;
  jlc   : jClass=nil;
begin
  Result := false; if (env = nil) then exit;

  exc := env^.ExceptionOccurred(env);

  if exc <> nil then
  begin
    env^.ExceptionDescribe(env); // See in ADB Logcat
    env^.ExceptionClear(env);

    clazz := env^.GetObjectClass(env, exc); // exception's class
    jlc   := env^.GetObjectClass(env, clazz);   // java.lang.Class
    mid   := env^.GetMethodID(env, jlc, 'getSimpleName', '()Ljava/lang/String;');
    jStr  := env^.CallObjectMethod(env, clazz, mid);

    if length(exceptionInfo) <= 0 then
     exceptionInfo := GetPStringAndDeleteLocalRef(env, jStr)
    else
     exceptionInfo := exceptionInfo + ' ' + GetPStringAndDeleteLocalRef(env, jStr);

    mid  := env^.GetMethodID(env, clazz, 'getMessage', '()Ljava/lang/String;');
    jStr := env^.CallObjectMethod(env, exc, mid);

    env^.DeleteLocalRef(env, clazz);
    env^.DeleteLocalRef(env, jlc);
    env^.DeleteLocalRef(env, exc);

    exceptionCount := exceptionCount + 1;
    exceptionInfo  := exceptionInfo + ': ' + GetPStringAndDeleteLocalRef(env, jStr);

    Result := true;
  end;
end;

function JBool( Bool : Boolean ) : byte;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End;
 end;

procedure jni_free(env:PJNIEnv; this : jObject);
var
  jMethod : jMethodID = nil;
  cls: jClass;
label
  _exceptionOcurred;
begin
  if (env = nil) or (this = nil) then exit;

  cls:= env^.GetObjectClass(env, this);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, this, jMethod);

  env^.DeleteGlobalRef(env, this);
  env^.DeleteLocalRef(env, cls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc(env: PJNIEnv; _jobject: JObject; javaFuncion : string );
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float1;
  jParams[1].f:= _float2;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_fff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2, _float3: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float1;
  jParams[1].f:= _float2;
  jParams[2].f:= _float3;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jni_proc_ffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2, _float3, _float4: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float1;
  jParams[1].f:= _float2;
  jParams[2].f:= _float3;
  jParams[3].f:= _float4;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_fffffff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _float1, _float2, _float3, _float4, _float5, _float6, _float7 : single);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FFFFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float1;
  jParams[1].f:= _float2;
  jParams[2].f:= _float3;
  jParams[3].f:= _float4;
  jParams[4].f:= _float5;
  jParams[5].f:= _float6;
  jParams[6].f:= _float7;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) or (_viewgroup = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) or (_view = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/View;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _view;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iz(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _int: integer; _bool: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IZ)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;
  jParams[1].z:= JBool(_bool);

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _bool: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_bool);

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_zii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _bool: boolean; _int0, _int1: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(ZII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_bool);
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int0, _int1: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: JObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_mei(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                  _menuItem: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/MenuItem;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menuItem;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_mei_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                  _menuItem: jObject; _bool: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/MenuItem;Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menuItem;
  jParams[1].z:= JBool(_bool);

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_men_i_das(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                  _menu: jObject; _int0: integer; var _das: TDynArrayOfString);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/Menu;I[Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _int0;
  newSize0:= Length(_das); //?; Length(?);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_das[i])));
  end;

  jParams[2].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_men_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                  _menu: jObject; _int0: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/Menu;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _int0;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_men_it(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                  _menu: jObject; _int0: integer; _str0: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/Menu;ILjava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _int0;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str0));

  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_uri(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _uri: JObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_das(env: PJNIEnv; _jobject: JObject; javaFuncion : string; var _das: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '([Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_das);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_das[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_bmp_iiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: JObject; _int0, _int1, _int2, _int3: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;IIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;
  jParams[3].i:= _int2;
  jParams[4].i:= _int3;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_bmp_ii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: JObject; _int0, _int1 : integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_bmp_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: JObject; _int : integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _int;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_bmp_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                         _bitmap: JObject; _str: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_it(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _int0: integer; _str: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(ILjava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tf(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _str: string; _single: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].f:= _single;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ti(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _str: string; _int0: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int0;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tti(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _str0, _str1: string; _int0: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[2].i:= _int0;

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ttii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _str0, _str1: string; _int0,_int1: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[2].i:= _int0;
  jParams[3].i:= _int1;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _str: string; _int0, _int1: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tj(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str: string; _long: int64);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;J)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].j:= _long;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iit(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _int0, _int1: integer; _str: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IILjava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iiit(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _int0, _int1, _int2: integer; _str: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IIILjava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[3].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int0, _int1, _int2: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(III)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int0, _int1, _int2, _int3: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;
  jParams[3].i:= _int3;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iiiii(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                         _int0, _int1, _int2, _int3, _int4: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IIIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;
  jParams[3].i:= _int3;
  jParams[4].i:= _int4;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_if(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _int: integer; _float:single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;
  jParams[1].f:= _float;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_iff(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                       _int: integer; _float0, _float1:single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;
  jParams[1].f:= _float0;
  jParams[2].f:= _float1;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _long: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(J)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].j:= _long;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _str: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_h(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _str : String);
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 if (env = nil) or (_jobject = nil) then exit;

 cls := env^.GetObjectClass(env, _jobject);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, PChar(javaFuncion), '(Ljava/lang/CharSequence;)V'); //direct jni api
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].l := env^.NewStringUTF(env, pchar(_str) );

 if _jParams[0].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethodA(env,_jobject,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env, cls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tz(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _str: string; _bool : boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].z:= JBool(_bool);

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tt(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _str1, _str2: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l := env^.NewStringUTF(env, PChar(_str2));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _str1, _str2, _str3: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str2));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str3));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[2].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_tttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _str1, _str2, _str3, _str4: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str2));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str3));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_str4));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[2].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[3].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ttti(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                      _str1, _str2, _str3: string; _int0 : integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str2));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str3));
  jParams[3].i:= _int0;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ttttt(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str1, _str2, _str3, _str4, _str5: string);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l := env^.NewStringUTF(env, PChar(_str2));
  jParams[2].l := env^.NewStringUTF(env, PChar(_str3));
  jParams[3].l := env^.NewStringUTF(env, PChar(_str4));
  jParams[4].l := env^.NewStringUTF(env, PChar(_str5));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[2].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[3].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[4].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env,jParams[3].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jni_proc_ttz(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                     _str1, _str2: string; _bool : boolean);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l := env^.NewStringUTF(env, PChar(_str2));
  jParams[2].z := JBool(_bool);

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallFloatMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()D');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallDoubleMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_vig(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/view/ViewGroup;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_out_int(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/content/Intent;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_uri(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/net/Uri;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_h(env: PJNIEnv; _jobject: JObject; javaFuncion : string) : String;
var
  jMethod : jMethodID = nil;
  _jString : jString;
  cls: jClass;
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  cls := env^.GetObjectClass(env, _jobject);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, PChar(javaFuncion), '()Ljava/lang/CharSequence;');  //direct jni api
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jString:= env^.CallObjectMethod(env,_jobject,jMethod);

  Result:= GetPStringAndDeleteLocalRef(env, _jString);
  env^.DeleteLocalRef(env, cls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallLongMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string ): string;
var
  jStr: JString;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethod(env, _jobject, jMethod);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_out_viw(env: PJNIEnv; _jobject: JObject; javaFuncion : string): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Landroid/view/View;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jobject, jMethod);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
   Result := false; if (env = nil) or (_jobject = nil) then exit;

   jCls:= env^.GetObjectClass(env, _jobject);
   if jCls = nil then goto _exceptionOcurred;
   jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '()Z');
   if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

   jBoo:= env^.CallBooleanMethod(env, _jobject, jMethod);

   Result:= boolean(jBoo);
   env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bitmap: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_dab_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          var _byteArray: TDynArrayOfJByte): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) or (_byteArray = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '([B)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_dab_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              var _byteArray: TDynArrayOfJByte; _bool1: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) or (_byteArray = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '([BZ)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].z:= JBool(_bool1);

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_dd_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _double1, _double2: double): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DD)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].d:= _double1;
  jParams[1].d:= _double2;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_dd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _double1, _double2: double): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DD)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].d:= _double1;
  jParams[1].d:= _double2;

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_dddd_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _double1, _double2, _double3, _double4: double): single;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DDDD)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].d:= _double1;
  jParams[1].d:= _double2;
  jParams[2].d:= _double3;
  jParams[3].d:= _double4;

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_z_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bool: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Z)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_bool);

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _bitmap: JObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_bmp_i_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: JObject; _int : integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _int;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function  jni_func_iiii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                    _int0, _int1, _int2, _int3: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(IIII)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;
  jParams[3].i:= _int3;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;

end;


function jni_func_t_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_uri_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _uri: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_uri_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _uri: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_uri_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _uri: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_uri_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _uri: jObject): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/net/Uri;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _uri;

  jBoo   := env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result := boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_int_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                              _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/content/Intent;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _intent;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_int_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _intent: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/content/Intent;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _intent;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_i_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_i_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): double;
var
 jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jobject = nil) then exit;

  cls := env^.GetObjectClass(env, _jobject);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, PChar(javaFuncion), '(I)D');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParam[0].i := _int;

  Result:= env^.CallDoubleMethodA(env,_jobject,jMethod,@_jParam);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_i_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): real;
var
 jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jobject = nil) then exit;

  cls := env^.GetObjectClass(env, _jobject);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, PChar(javaFuncion), '(I)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParam[0].i := _int;

  Result:= env^.CallDoubleMethodA(env,_jobject,jMethod,@_jParam);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_i_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_ii_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int0, _int1: integer): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(II)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_iii_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int0, _int1, _int2: integer): string;
var
  jStr: JString;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(III)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int0;
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_j_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _long: int64): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(J)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].j:= _long;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_i_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_ii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _int1, _int2: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int1;
  jParams[1].i:= _int2;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_i_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _int : integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_i_out_mei(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _int : integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)Landroid/view/MenuItem;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_tt_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str1, _str2: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str2));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_tt_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str0, _str1: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tz_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _bool: boolean): int64;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Z)J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].z:= JBool(_bool);

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallLongMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tz_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str: string; _bool: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Z)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].z:= JBool(_bool);

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_ti_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _str: string; _int: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_ti_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str: string; _int: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _str: string; _int0, _int1: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_tiii_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _str: string; _int0, _int1, _int2: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;III)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;
  jParams[3].i:= _int2;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_ti_out_z( env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _int: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function  jni_func_ti_out_t( env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _str: string; _int: integer): string;
var
 jCls: jClass=nil;
 jMethod : jMethodID = nil;
 jParams : array[0..1] of jValue;
 jStr: JString;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls := env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;I)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := env^.NewStringUTF(env, pchar(_str) );
  jParams[1].i:= _int;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jParams[0].l); //added..
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tj_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _long: int64): int64;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;J)J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].j:= _long;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallLongMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by Segator
function jni_func_i_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _int: integer): int64;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(I)J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;

  Result:= env^.CallLongMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_jji_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _long0, _long1:int64; _int: integer): int64;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(JJI)J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].j:= _long0;
  jParams[1].j:= _long1;
  jParams[2].i:= _int;

  Result:= env^.CallLongMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tj_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _long: int64): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;J)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].j:= _long;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);      

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tf_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _float: single): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;F)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].f:= _float;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tf_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _float: single): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;F)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].f:= _float;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str0, _str1: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tt_ars_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                _str0, _str1: string; _ars: array of string): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0   := Length(_ars);
  jNewArray0 := env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_ars[i])));

  jParams[2].l:= jNewArray0;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tt_ars_t_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                _str0, _str1: string; _ars: array of string; _str3 : string): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_str3));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[3].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0   := Length(_ars);
  jNewArray0 := env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[3].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_ars[i])));

  jParams[2].l:= jNewArray0;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tii_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                            _str: string; _int1, _int2: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;II)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int1;
  jParams[2].i:= _int2;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_t_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _bitmap: jObject; _str: string) : boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls    := env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo    := env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result  := boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_men_i_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _menu: jObject; _int0: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  Result:= 0; if (env = nil) or (_jobject = nil) then exit;

  jCls    := env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/view/Menu;I)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _menu;
  jParams[1].i:= _int0;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_tt_out_z(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _bitmap: jObject; _str1, _str2: string) : boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls    := env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str2));

  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[2].l = nil) then begin env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo    := env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);
  Result  := boolean(jBoo);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);      

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _float1, _float2: single): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(FF)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _float1;
  jParams[1].f:= _float2;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_ffz_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                             _float1, _float2: double; _bool: boolean): string;
var
  jStr: JString;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(DDZ)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].d:= _float1;
  jParams[1].d:= _float2;
  jParams[2].z:= JBool(_bool);

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_ff_out_bmp(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                 _bitmap: jObject; _float1, _float2: single): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;FF)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].f:= _float1;
  jParams[2].f:= _float2;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jni_func_t_out_i(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_f(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallFloatMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_d(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): double;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)D');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallDoubleMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_j(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): int64;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := 0; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)J');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallLongMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_t( env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tii_out_t( env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _str: string; _int0, _int1 : integer): string;
var
  jStr: JString;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;II)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jParams[1].i:= _int0;
  jParams[2].i:= _int1;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_ttt_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string; _str0, _str1, _str2 : string): string;
var
  jStr: JString;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_str2));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[2].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_uri(env: PJNIEnv; _jobject:JObject; javaFuncion : string; _str0: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jobject = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Landroid/net/Uri;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_t_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string;
                          _str: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_it_out_z(env: PJNIEnv; _jobject:JObject; javaFuncion : string;
                           _int: integer; _str: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := false; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(ILjava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo:= env^.CallBooleanMethodA(env, _jobject, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_it_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                          _int: integer; _str: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(ILjava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _int;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);       

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_tt_out_t(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                           _str0, _str1: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  result := ''; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_str0));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str1));

  if (jParams[0].l = nil) then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if (jParams[1].l = nil) then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jobject, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);      

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jni_func_bmp_t_out_dab(env: PJNIEnv; _jobject: JObject; javaFuncion : string;
                                _bitmap: jObject; _str: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  Result := nil; if (env = nil) or (_jobject = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jobject);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, PChar(javaFuncion), '(Landroid/graphics/Bitmap;Ljava/lang/String;)[B');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_str));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jobject, jMethod,  @jParams);

  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
