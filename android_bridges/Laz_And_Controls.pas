unit Laz_And_Controls;

//Start:26-october-2013

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

//Legacy: Native Android Controls for Pascal
//   Developer
//              Simon,Choi / Choi,Won-sik
//                           simonsayz@naver.com   
//                           http://blog.naver.com/simonsayz

//              LoadMan    / Jang,Yang-Ho
//                           wkddidgh@naver.com    
//                           http://blog.naver.com/wkddidgh


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

//   Reserved for Delphi Compatibility
//               TBevel        TBitBtn    TCalendar     TComboBox
//               TListBox      TMemo      TPageControl  TPanel
//               Tshape        TTabSheet  TStringGrid

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


//   Reference Sites
//               http://wiki.freepascal.org/Android_Programming
//               http://wiki.freepascal.org/Android4Pascal
//               http://wiki.freepascal.org/Android_Interface/Native_Android_GUI
//               http://zengl.org/

//   Known Bugs
//               2013.03.01 Fixed : Asset 
//               2013.07.15 Fixed : Destroy Mechanism
//               2013.07.28 Screen Rotate Event (App -> Form individual )

//   To do list
//               - Custom Control : List ( Horizontal, Vertical )
//               - Network : Http Get/Post , File Up/Down
//               - Jpeg Loading 1/2, 1/4, 1/8

//------------------------------------------------------------------------------

{$mode delphi}

interface

uses
  SysUtils, Classes,
  And_bitmap_h, And_jni, And_jni_Bridge, PaintShader,
  AndroidWidget, systryparent;

type

  TImageListIndex = type integer;

  jCanvas = class;

  TOnDraw = procedure(Sender: TObject) of object;

  TSqliteFieldType = (ftNull, ftInteger, ftFloat, ftString, ftBlob);

  jPanel = class(jVisualControl)
  private
    FOnDown: TOnNotify;
    FOnUp: TOnNotify;
    FOnDoubleClick: TOnNotify;
    FOnFling: TOnFling;
    FOnPinchGesture: TOnPinchZoom;
    FMinZoomFactor: single;
    FMaxZoomFactor: single;

    FAnimationDurationIn: integer;
    FAnimationDurationOut: integer;
    FAnimationMode: TAnimationMode;

    procedure SetColor(Value: TARGBColorBridge); //background

  protected

    procedure SetParamHeight(Value: TLayoutParams); override;
    procedure SetParamWidth(Value: TLayoutParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure Init; override;

    function GetTop: integer;    // By ADiV
    function GetLeft: integer;   // By ADiV
    function GetBottom: integer; // By ADiV
    function GetRight: integer;  // By ADiV
    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure ClearLayout;
    procedure RemoveFromViewParent; override;

    procedure GenEvent_OnDown(Obj: TObject);
    procedure GenEvent_OnUp(Obj: TObject);

    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnLongClick(Obj: TObject);
    procedure GenEvent_OnDoubleClick(Obj: TObject);
    procedure GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
    procedure GenEvent_OnPinchZoomGestureDetected(Obj: TObject;
      scaleFactor: single; state: integer);

    procedure SetMinZoomFactor(_minZoomFactor: single);
    procedure SetMaxZoomFactor(_maxZoomFactor: single);

    procedure CenterInParent();
    procedure MatchParent();
    procedure WrapContent();
    procedure SetRoundCorner();
    procedure SetRoundCorners(_TopLeftRadius, _TopRightRadius,
      _BottomRightRadius, _BottomLeftRadius: single);
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetBackgroundAlpha(_alpha: integer);
    //You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
    procedure SetMarginLeftTopRightBottom(_left, _top, _right, _bottom: integer);
    procedure SetViewParent(Value: jObject); override;
    function GetViewParent(): jObject; override;
    procedure ResetViewParent(); override;
    //procedure AddView(_view: jObject);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure RemoveView(_view: jObject);
    procedure RemoveAllViews();
    function GetChildCount(): integer;
    procedure BringChildToFront(_view: jObject);
    procedure BringToFront;
    procedure SetVisibilityGone();

    procedure SetAnimationDurationIn(_animationDurationIn: integer);
    procedure SetAnimationDurationOut(_animationDurationOut: integer);
    procedure SetAnimationMode(_animationMode: TAnimationMode);
    procedure Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
    procedure AnimateRotate(_angleFrom, _angleTo: integer);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property MinPinchZoomFactor: single read FMinZoomFactor write FMinZoomFactor;
    property MaxPinchZoomFactor: single read FMaxZoomFactor write FMaxZoomFactor;

    property AnimationDurationIn: integer read FAnimationDurationIn
      write SetAnimationDurationIn;
    property AnimationDurationOut: integer
      read FAnimationDurationOut write SetAnimationDurationOut;
    property AnimationMode: TAnimationMode read FAnimationMode write SetAnimationMode;

    property OnDown: TOnNotify read FOnDown write FOnDown;
    property OnUp: TOnNotify read FOnUp write FOnUp;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnLongClick: TOnNotify read FOnLongClick write FOnLongClick;
    property OnDoubleClick: TOnNotify read FOnDoubleClick write FOnDoubleClick;
    property OnFlingGesture: TOnFling read FOnFling write FOnFling;
    property OnPinchZoomGesture: TOnPinchZoom
      read FOnPinchGesture write FOnPinchGesture;
  end;

  jImageList = class(jControl)
  private
    FImages: TStrings;
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
    function GetBitmap(imageIndex: integer): jObject;

    // Property
    property Count: integer read GetCount;
  published
    property Images: TStrings read FImages write SetImages;
  end;

  THttpClientAuthenticationMode = (autNone, autBasic{, autOAuth}); //TODO: autOAuth
  TOnHttpClientContentResult = procedure(Sender: TObject;
    content: rawbytestring) of object;
  TOnHttpClientCodeResult = procedure(Sender: TObject; code: integer) of object;

  TOnHttpClientUploadProgress = procedure(Sender: TObject; progress: int64) of object;
  TOnHttpClientUploadFinished = procedure(Sender: TObject;
    connectionStatusCode: integer; responseMessage: string; fileName: string) of object;

  { jHttpClient }

  jHttpClient = class(jControl)
  private
    FOntUpLoadProgress: TOnHttpClientUpLoadProgress;
    FUrl: string;
    FUrls: TStrings;
    FIndexUrl: integer;
    FCharSet: string;
    FAuthenticationMode: THttpClientAuthenticationMode;

    FOnContentResult: TOnHttpClientContentResult;
    FOnCodeResult: TOnHttpClientCodeResult;

    FOnUploadProgress: TOnHttpClientUploadProgress;
    FOnUploadFinished: TOnHttpClientUploadFinished;

    FResponseTimeout: integer;
    FConnectionTimeout: integer;

    FUploadFormName: string;

    function GetConnectionTimeout: integer;
    function GetResponseTimeout: integer;
    procedure SetCharSet(AValue: string);
    procedure SetIndexUrl(Value: integer);
    procedure SetUrlByIndex(Value: integer);
    procedure SetUrls(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure GetAsync(_stringUrl: string); overload;
    procedure GetAsync; overload;

    procedure GetAsyncGooglePlayVersion(_stringUrl: string); // by ADiV

    //thanks to Fatih KILIÇ
    function Get(_stringUrl: string): string; overload;
    function Get(): string; overload;

    procedure SetAuthenticationUser(_userName: string; _password: string);
    procedure SetAuthenticationMode(_authenticationMode: THttpClientAuthenticationMode);
    procedure SetAuthenticationHost(_hostName: string; _port: integer);

    procedure PostNameValueDataAsync(_stringUrl: string); overload;
    procedure PostNameValueDataAsync(_stringUrl: string; _name: string;
      _value: string); overload;
    procedure PostNameValueDataAsync(_stringUrl: string; _listNameValue: string);
      overload;

    //thanks to Fatih KILIÇ
    procedure ClearNameValueData; //ClearPost2Values;
    procedure AddNameValueData(_name, _value: string); //AddValueForPost2;
    function Post(_stringUrl: string): string; overload;

    function GetCookiesCount(): integer;
    function GetCookieByIndex(_index: integer): jObject;
    function GetCookieAttributeValue(_cookie: jObject; _fieldName: string): string;
    procedure ClearCookieStore();
    function AddCookie(_name: string; _value: string): jObject; overload;
    function IsExpired(_cookie: jObject): boolean;
    function GetStateful(_url: string): string;
    function PostStateful(_url: string): string;
    function IsCookiePersistent(_cookie: jObject): boolean;
    procedure SetCookieValue(_cookie: jObject; _value: string);
    function GetCookieByName(_cookieName: string): jObject;
    procedure SetCookieAttributeValue(_cookie: jObject; _attribute: string;
      _value: string);
    function GetCookieValue(_cookie: jObject): string;
    function GetCookieName(_cookie: jObject): string;

    function GetCookies(_nameValueSeparator: string): TDynArrayOfString; overload;

    procedure AddClientHeader(_name: string; _value: string);
    procedure ClearClientHeader(_name: string; _value: string);
    function DeleteStateful(_url: string; _value: string): string;  //thanks to @renabor

    function UrlExist(_urlString: string): boolean;

    function GetCookies(_urlString: string;
      _nameValueSeparator: string): TDynArrayOfString; overload;

    function AddCookie(_urlString: string; _name: string; _value: string): jObject;
      overload;

    function OpenConnection(_urlString: string): jObject;
    function SetRequestProperty(_httpConnection: jObject; _headerName: string;
      _headerValue: string): jObject;
    //function Connect(_httpConnection: jObject): jObject;

    function GetHeaderField(_httpConnection: jObject; _headerName: string): string;
    function GetHeaderFields(_httpConnection: jObject): TDynArrayOfString;

    procedure Disconnect(_httpConnection: jObject);
    function Get(_httpConnection: jObject): string; overload;
    function AddRequestProperty(_httpConnection: jObject; _headerName: string;
      _headerValue: string): jObject;
    function Post(_httpConnection: jObject): string; overload;
    function GetResponseCode(): integer;
    function GetDefaultConnection(): jObject;
    procedure SetResponseTimeout(_timeoutMilliseconds: integer);
    procedure SetConnectionTimeout(_timeoutMilliseconds: integer);

    procedure trustAllCertificates();//By Segator

    procedure UploadFile(_url: string; _fullFileName: string;
      _uploadFormName: string); overload;
    procedure UploadFile(_url: string; _fullFileName: string); overload;
    procedure SetUploadFormName(_uploadFormName: string);
    procedure SetUnvaluedNameData(_unvaluedName: string);
    procedure SetEncodeValueData(_value: boolean);
    procedure PostSOAPDataAsync(_SOAPData: string; _stringUrl: string);
    function PostJSONData(_strURI: string; _jsonData: string): string;

    procedure GenEvent_OnHttpClientContentResult(Obj: TObject; content: rawbytestring);
    procedure GenEvent_OnHttpClientCodeResult(Obj: TObject; code: integer);

    procedure GenEvent_OnHttpClientUploadProgress(Obj: TObject; progress: int64);
    procedure GenEvent_OnHttpClientUploadFinished(Obj: TObject;
      code: integer; response: string; fileName: string);

    // Property
    property Url: string read FUrl;
  published
    property CharSet: string read FCharSet write SetCharSet;
    property IndexUrl: integer read FIndexUrl write SetIndexUrl;
    property Urls: TStrings read FUrls write SetUrls;
    property AuthenticationMode: THttpClientAuthenticationMode
      read FAuthenticationMode write SetAuthenticationMode;
    property ResponseTimeout: integer read GetResponseTimeout write SetResponseTimeout;
    property ConnectionTimeout: integer read GetConnectionTimeout
      write SetConnectionTimeout;
    property UploadFormName: string read FUploadFormName write SetUploadFormName;
    property OnContentResult: TOnHttpClientContentResult
      read FOnContentResult write FOnContentResult;
    property OnCodeResult: TOnHttpClientCodeResult
      read FOnCodeResult write FOnCodeResult;
    property OnUploadProgress: TOnHttpClientUpLoadProgress
      read FOntUpLoadProgress write FOntUpLoadProgress;
    property OnUploadFinished: TOnHttpClientUpLoadFinished
      read FOnUpLoadFinished write FOnUpLoadFinished;

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

    function IsEmailValid(_email: string): boolean; // by ADiV
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
    function Send(multipartMessage: boolean = False): integer; overload;

    function Send(toNumber: string; msg: string;
      multipartMessage: boolean = False): integer; overload;
    function Send(toNumber: string; msg: string; packageDeliveredAction: string;
      multipartMessage: boolean = False): integer; overload;
    function Send(toName: string; multipartMessage: boolean = False): integer; overload;

    function Read(intentReceiver: jObject; addressBodyDelimiter: string): string;
    // Property
  published
    property MobileNumber: string read FMobileNumber write FMobileNumber;
    property ContactName: string read FContactName write FContactName;
    property SMSMessage: TStrings read FSMSMessage write SetSMSMessage;
    property LoadMobileContacts: boolean read FLoadMobileContacts
      write FLoadMobileContacts;
    property ContactListDelimiter: char read FContactListDelimiter
      write FContactListDelimiter;
  end;

  //NEW by jmpessoa
  jCamera = class(jControl)
  private
    FFilename: string;
    FFilePath: TFilePath;
    FRequestCode: integer;
    FAddToGallery: boolean;
  public
    FullPathToBitmapFile: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure TakePhoto; overload;
    procedure TakePhoto(_filename: string; _requestCode: integer); overload;

    // Property
    property RequestCode: integer read FRequestCode write FRequestCode;
    property AddToGallery: boolean read FAddToGallery write FAddToGallery;

  published
    property Filename: string read FFilename write FFilename;
    property FilePath: TFilePath read FFilePath write FFilePath;
  end;

  jTimer = class(jControl)
  private
    // Java
    FjParent: jForm;
    FInterval: integer;
    FOnTimer: TOnNotify;
    procedure SetInterval(Value: integer);
    //Procedure SetOnTimer(Value: TOnNotify);
  protected
    procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    //Property
    property jParent: jForm read FjParent write FjParent;
  published
    property Enabled: boolean read FEnabled write SetEnabled;
    property Interval: integer read FInterval write SetInterval;
    //Event
    property OnTimer: TOnNotify read FOnTimer write FOnTimer;//SetOnTimer;
  end;

  TBitmapCompressFormat = (cfJPG, cfPNG, cfNone);

  { jBitmap }

  jBitmap = class(jControl)
  private
    FWidth: integer;
    FHeight: integer;
    FStride: cardinal;
    FFormat: integer;
    FFlags: cardinal;

    FImageName: string;
    FImageIndex: TImageListIndex;
    FImageList: jImageList;  //by jmpessoa

    { TFilePath = (fpathApp, fpathData, fpathExt, fpathDCIM); }
    FFilePath: TFilePath;
    FBitmapInfo: AndroidBitmapInfo;

    procedure SetImages(Value: jImageList);
    procedure SetImageIndex(Value: TImageListIndex);
    procedure SetImageByIndex(Value: integer);
    procedure SetImageIdentifier(Value: string);  // ...res/drawable
    function TryPath(path: string; fileName: string): boolean;

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure LoadFromBuffer(buffer: Pointer; size: integer); overload;// by Kordal
    function LoadFromBuffer(var buffer: TDynArrayOfJByte): jObject; overload;
    procedure LoadFromFile(fullFileName: string);
    procedure LoadFromRes(imgResIdentifier: string);  // ..res/drawable

    procedure CreateJavaBitmap(w, h: integer);
    function GetJavaBitmap: jObject;  //deprecated ..
    function GetImage(): jObject;
    function GetCanvas(): jObject; //by Tomash
    procedure GetBitmapSizeFromFile(_fullPathFile: string; var w, h: integer);
    //by Tomash

    function BitmapToArrayOfJByte(var bufferImage: TDynArrayOfJByte): integer;
    //local/self

    function GetByteArrayFromBitmap(var bufferImage: TDynArrayOfJByte): integer;

    procedure SetByteArrayToBitmap(var bufferImage: TDynArrayOfJByte; size: integer);

    procedure LockPixels(var PDWordPixel: PScanLine); overload;
    procedure LockPixels(var PBytePixel: PScanByte {delphi mode}); overload;
    procedure LockPixels(var PSJByte: PJByte{fpc mode}); overload;
    procedure UnlockPixels;

    procedure ScanPixel(PBytePixel: PScanByte; notByteIndex: integer);
      overload;   //TODO - just draft
    procedure ScanPixel(PDWordPixel: PScanLine); overload;
    //TODO - just draft

    function GetInfo: boolean;
    function GetRatio: single;

    function ClockWise(_bmp: jObject): jObject;
    function AntiClockWise(_bmp: jObject): jObject;
    function SetScale(_bmp: jObject; _scaleX: single; _scaleY: single): jObject;
      overload;
    function SetScale(_scaleX: single; _scaleY: single): jObject; overload;
    function LoadFromAssets(fileName: string): jObject;
    function GetResizedBitmap(_bmp: jObject; _newWidth: integer;
      _newHeight: integer): jObject; overload;
    function GetResizedBitmap(_newWidth: integer; _newHeight: integer): jObject;
      overload;
    function GetResizedBitmap(_factorScaleX: single; _factorScaleY: single): jObject;
      overload;

    function GetJByteBuffer(_width: integer; _height: integer): jObject;
    function GetBitmapFromJByteBuffer(_jbyteBuffer: jObject; _width: integer;
      _height: integer): jObject; overload;
    function GetBitmapFromJByteArray(var _image: TDynArrayOfJByte): jObject;

    function GetJByteBufferFromImage(_bmap: jObject): jObject; overload;
    function GetJByteBufferFromImage(): jObject; overload;
    function GetJByteBufferAddress(jbyteBuffer: jObject): PJByte;
    function GetImageFromFile(_fullPathFile: string): jObject;
    function GetRoundedShape(_bitmapImage: jObject): jObject; overload;
    function GetRoundedShape(_bitmapImage: jObject; _diameter: integer): jObject;
      overload;
    function DrawText(_bitmapImage: jObject; _text: string; _left: integer;
      _top: integer; _fontSize: integer; _color: TARGBColorBridge): jObject; overload;
    function DrawText(_text: string; _left: integer; _top: integer;
      _fontSize: integer; _color: TARGBColorBridge): jObject; overload;
    function DrawBitmap(_bitmapImageIn: jObject; _left: integer; _top: integer): jObject;

    procedure SaveToFileJPG(_fullPathFile: string); overload;
    procedure SaveToFileJPG(_bitmapImage: jObject; _Path: string); overload;

    procedure SetImage(_bitmapImage: jObject);
    function CreateBitmap(_width: integer; _height: integer;
      _backgroundColor: TARGBColorBridge): jObject;
    function GetThumbnailImage(_fullPathFile: string; _thumbnailSize: integer): jObject;
      overload;
    function GetThumbnailImage(_fullPathFile: string; _width: integer;
      _height: integer): jObject; overload;
    function GetThumbnailImage(_bitmap: jObject; _thumbnailSize: integer): jObject;
      overload;
    function GetThumbnailImage(_bitmap: jObject; _width: integer;
      _height: integer): jObject; overload;
    function GetThumbnailImageFromAssets(_filename: string;
      thumbnailSize: integer): jObject; overload;
    function GetThumbnailImageFromAssets(_filename: string; _width: integer;
      _height: integer): jObject; overload;
    procedure LoadFromStream(Stream: TMemoryStream);

    function GetBase64StringFromImage(_bitmap: jObject;
      _compressFormat: TBitmapCompressFormat): string;
    function GetImageFromBase64String(_imageBase64String: string): jObject;
    function GetBase64StringFromImageFile(_fullPathToImageFile: string): string;

    function GetWidth(): integer;
    function GetHeight(): integer;

  published
    property FilePath: TFilePath read FFilePath write FFilePath;
    property ImageIndex: TImageListIndex read FImageIndex write SetImageIndex default -1;
    property Images: jImageList read FImageList write SetImages;
    property ImageIdentifier: string read FImageName write SetImageIdentifier;
    //property ImageName: string read FImageName write SetImageName;
    property Width: integer read GetWidth write FWidth;
    property Height: integer read GetHeight write FHeight;
  end;

  jDialogYN = class(jControl)
  private
    FTitle: string;
    FMsg: string;
    FYes: string;
    FNo: string;
    FParent: jForm;
    FOnDialogYN: TOnClickYN;
    FTitleAlign: TTextAlign; // by ADiV
  protected
    procedure GenEvent_OnClick(Obj: TObject; Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Show; overload;

    procedure Show(titleText, msgText, yesText, noText, neutralText: string); overload;
    procedure Show(titleText, msgText, yesText, noText: string); overload;
    procedure Show(titleText, msgText: string); overload;
    procedure ShowOK(titleText: string; msgText: string; _OkText: string);

    procedure SetFontSize(fontSize: integer); // by ADiV
    procedure SetTitleAlign(_titleAlign: TTextAlign); // by ADiV

    procedure SetColorBackground(_color: TARGBColorBridge); // by ADiV
    procedure SetColorBackgroundTitle(_color: TARGBColorBridge); // by ADiV
    procedure SetColorTitle(_color: TARGBColorBridge); // by ADiV
    procedure SetColorText(_color: TARGBColorBridge);  // by ADiV
    procedure SetColorNegative(_color: TARGBColorBridge);// by ADiV
    procedure SetColorPositive(_color: TARGBColorBridge);// by ADiV
    procedure SetColorNeutral(_color: TARGBColorBridge); // by ADiV

    property Parent: jForm read FParent write FParent;
    property CustomColor: DWord read FCustomColor write FCustomColor;
  published
    property Title: string read FTitle write FTitle;
    property Msg: string read FMsg write FMsg;
    property Yes: string read FYes write FYes;
    property No: string read FNo write FNo;
    property TitleAlign: TTextAlign read FTitleAlign write SetTitleAlign;
    //event
    property OnClickYN: TOnClickYN read FOnDialogYN write FOnDialogYN;
  end;

  jDialogProgress = class(jControl)
  private
    FTitle: string;
    FMsg: string;
    // Java
    //FjObject    : jObject; //Self
    FParent: jForm;
    FOnBackPressed: TOnNotify;
    FOnDone: TOnNotify;
    FOnGo: TOnNotify;
    FOnNext: TOnNotify;
    FOnSearch: TOnNotify;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Start;
    procedure Stop;
    procedure Close;

    procedure Show(); overload;
    procedure Show(_title: string; _msg: string); overload;
    procedure Show(_layout: jObject); overload;

    procedure SetMessage(_msg: string);
    procedure SetTitle(_title: string);

    procedure SetCancelable(_value: boolean);

    property Parent: jForm read FParent write FParent;
  published
    property Title: string read FTitle write SetTitle;
    property Msg: string read FMsg write SetMessage;
    property OnBackPressed: TOnNotify read FOnBackPressed write FOnBackPressed;
  end;

  jAsyncTask = class(jControl)
  private
    FAsyncTaskState: TAsyncTaskState;
    FRunning: boolean;
    FOnDoInBackground: TOnAsyncEventDoInBackground;
    FOnProgressUpdate: TOnAsyncEventProgressUpdate;
    FOnPreExecute: TOnAsyncEventPreExecute;
    FOnPostExecute: TOnAsyncEventPostExecute;
  protected
    procedure GenEvent_OnAsyncEventDoInBackground(Obj: TObject;
      progress: integer; out keepInBackground: boolean);
    procedure GenEvent_OnAsyncEventProgressUpdate(Obj: TObject;
      progress: integer; out progressUpdate: integer);
    procedure GenEvent_OnAsyncEventPreExecute(Obj: TObject; out startProgress: integer);
    procedure GenEvent_OnAsyncEventPostExecute(Obj: TObject; progress: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Done;    //by jmpessoa
    procedure Execute;
    property Running: boolean read FRunning write FRunning;
    property AsyncTaskState: TAsyncTaskState read FAsyncTaskState write FAsyncTaskState;
  published
    // Event
    property OnDoInBackground: TOnAsyncEventDoInBackground
      read FOnDoInBackground write FOnDoInBackground;
    property OnProgressUpdate: TOnAsyncEventProgressUpdate
      read FOnProgressUpdate write FOnProgressUpdate;
    property OnPreExecute: TOnAsyncEventPreExecute
      read FOnPreExecute write FOnPreExecute;
    property OnPostExecute: TOnAsyncEventPostExecute
      read FOnPostExecute write FOnPostExecute;
  end;

  jSqliteCursor = class(jControl)
  const
    MAXOBSERVERS = 10;
    POSITION_UNKNOWN = -1;
  private
    FObservers: array of TAndroidWidget;
    FObserverCount: integer;
  protected
    function GetCursor: jObject;
    function GetEOF: boolean;
    function GetBOF: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure MoveToFirst;
    procedure MoveToNext;
    procedure MoveToPrev;
    procedure MoveToLast;
    procedure MoveToPosition(position: integer);
    function GetRowCount: integer;

    function GetColumnCount: integer;
    function GetColumnIndex(colName: string): integer;
    function GetColumName(columnIndex: integer): string;
    function GetColType(columnIndex: integer): TSqliteFieldType;

    function GetValueToString(columnIndex: integer): string; overload;
    function GetValueToString(colName: string): string; overload;
    function GetValueAsString(columnIndex: integer): string; overload;
    function GetValueAsString(colName: string): string; overload;
    function GetValueAsBitmap(columnIndex: integer): jObject; overload;
    function GetValueAsBitmap(colName: string): jObject; overload;
    function GetValueAsInteger(columnIndex: integer): integer; overload;
    function GetValueAsInteger(colName: string): integer; overload;
    function GetValueAsDouble(columnIndex: integer): double; overload;
    function GetValueAsDouble(colName: string): double; overload;
    function GetValueAsFloat(columnIndex: integer): real; overload;
    function GetValueAsFloat(colName: string): real; overload;

    procedure SetCursor(Value: jObject);
    function GetPosition(): integer;   //position = -1 --> Last Row !

    procedure RegisterObserver(AObserver: jVisualControl);
    procedure UnRegisterObserver(AObserver: jVisualControl);
    property Cursor: jObject read GetCursor;
    property EOF: boolean read GetEOF;
    property BOF: boolean read GetBOF;

  published
  end;

  TBatchAsyncTaskType = (attUnknown, attUpdate, attInsert);
  TOnSqliteDataAccessAsyncPostExecute = procedure(Sender: TObject;
    Count: integer; msgResult: string) of object;

  jSqliteDataAccess = class(jControl)
  const
    POSITION_UNKNOWN = -1;
  private
    FjSqliteCursor: jSqliteCursor;
    FColDelimiter: char;
    FRowDelimiter: char;
    FDataBaseName: string;
    FFullPathDataBaseName: string;
    FCreateTableQuery: TStrings;
    FTableName: TStrings;
    FReturnHeaderOnSelect: boolean;

    FBatchAsyncTaskType: TBatchAsyncTaskType;
    FOnAsyncPostExecute: TOnSqliteDataAccessAsyncPostExecute;

    procedure SetjSqliteCursor(Value: jSqliteCursor);
  protected
    function GetEOF: boolean;
    function GetBOF: boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function ExecSQL(execQuery: string): boolean;
    function CheckDataBaseExists(dataBaseName: string): boolean;
    procedure OpenOrCreate(dataBaseName: string);

    procedure SetVersion(version: integer); //renabor
    function GetVersion(): integer; // renabor

    procedure AddTable(tableName: string; createTableQuery: string);
    procedure CreateAllTables;

    function Select(selectQuery: string): string;
      overload;  //set cursor and return selected rows
    function Select(selectQuery: string; moveToLast: boolean): boolean; overload;
    function Select(_tableName, _sortOrder: string): integer; overload;
    function Select(_tableName, _selection: string; _selectionArgs: array of string;
      _sortOrder: string): integer; overload;

    procedure SetSelectDelimiters(coldelim: char; rowdelim: char);
    function CreateTable(createQuery: string): boolean;
    function DropTable(tableName: string): boolean;
    function InsertIntoTable(insertQuery: string): boolean;
    function DeleteFromTable(deleteQuery: string): boolean;
    function UpdateTable(updateQuery: string): boolean;
    function UpdateImage(tableName: string; imageFieldName: string; keyFieldName: string;
      imageValue: jObject; keyValue: integer): boolean; overload;
    function UpdateImage(_tabName: string; _imageFieldName: string;
      _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer): boolean;
      overload;
    procedure Close;

    function GetCursor: jObject; overload;

    procedure MoveToFirst;
    procedure MoveToNext;
    procedure MoveToPrev;
    procedure MoveToLast;
    procedure MoveToPosition(position: integer);
    function GetRowCount: integer;

    function GetColumnCount: integer;
    function GetColumnIndex(colName: string): integer;
    function GetColumName(columnIndex: integer): string;
    function GetColType(columnIndex: integer): TSqliteFieldType;

    function GetValueToString(columnIndex: integer): string; overload;
    function GetValueToString(colName: string): string; overload;
    function GetValueAsString(columnIndex: integer): string; overload;
    function GetValueAsString(colName: string): string; overload;
    function GetValueAsBitmap(columnIndex: integer): jObject; overload;
    function GetValueAsBitmap(colName: string): jObject; overload;
    function GetValueAsInteger(columnIndex: integer): integer; overload;
    function GetValueAsInteger(colName: string): integer; overload;
    function GetValueAsDouble(columnIndex: integer): double; overload;
    function GetValueAsDouble(colName: string): double; overload;
    function GetValueAsFloat(columnIndex: integer): real; overload;
    function GetValueAsFloat(colName: string): real; overload;

    function GetPosition(): integer;   //position = -1 --> Last Row !

    procedure SetForeignKeyConstraintsEnabled(_value: boolean);
    procedure SetDefaultLocale();
    procedure DeleteDatabase(_dbName: string);
    //procedure InsertIntoTableBatch(var _insertQueries: TDynArrayOfString);
    //procedure UpdateTableBatch(var _updateQueries: TDynArrayOfString);
    function InsertIntoTableBatch(var _insertQueries: TDynArrayOfString): boolean;
    function UpdateTableBatch(var _updateQueries: TDynArrayOfString): boolean;


    function CheckDataBaseExistsByName(_dbName: string): boolean;
    procedure UpdateImageBatch(var _imageResIdentifierDataArray: TDynArrayOfString;
      _delimiter: string);

    procedure SetDataBaseName(_dbName: string);
    function GetFullPathDataBaseName(): string;

    function DBExport(_dbExportDir, _dbExportFileName: string): boolean; overload;
    function DBExport(_dbExportUri: jObject): boolean; overload;
    function DBImport(_dbImportFileFull: string): boolean; overload;
    function DBImport(_dbImportUri: jObject): boolean; overload;

    function Insert(_tableName: string): int64;
    function Update(_tableName, _whereClause: string;
      _whereArgs: array of string): integer;
    function UpdateAll(_tableName: string): integer;
    function Delete(_tableName, _whereClause: string;
      _whereArgs: array of string): integer;
    function DeleteAll(_tableName: string): integer;

    procedure ContentValuesClear;
    procedure PutString(_colum: string; _value: string);
    procedure PutShort(_colum: string; _value: smallint);
    procedure PutLong(_colum: string; _value: int64);
    procedure PutDouble(_colum: string; _value: double);
    procedure PutInteger(_colum: string; _value: integer);
    procedure PutBoolean(_colum: string; _value: boolean);
    procedure PutFloat(_colum: string; _value: single);
    procedure PutByte(_colum: string; _value: byte);

    function DatabaseExists(_databaseName: string): boolean;
    procedure SetAssetsSearchFolder(_folderName: string);
    procedure SetReturnHeaderOnSelect(_returnHeader: boolean);
    procedure SetBatchAsyncTaskType(_batchAsyncTaskType: TBatchAsyncTaskType);
    procedure ExecSQLBatchAsync(var _execSql: TDynArrayOfString);
    procedure GenEvent_OnSqliteDataAccessAsyncPostExecute(Sender: TObject;
      Count: integer; msgResult: string);

    property FullPathDataBaseName: string read GetFullPathDataBaseName;

  published
    property Cursor: jSqliteCursor read FjSqliteCursor write SetjSqliteCursor;
    property ColDelimiter: char read FColDelimiter write FColDelimiter;
    property RowDelimiter: char read FRowDelimiter write FRowDelimiter;
    property DataBaseName: string read FDataBaseName write SetDataBaseName;
    property CreateTableQuery: TStrings read FCreateTableQuery write FCreateTableQuery;
    property TableName: TStrings read FTableName write FTableName;
    property ReturnHeaderOnSelect: boolean read FReturnHeaderOnSelect
      write SetReturnHeaderOnSelect;
    property OnAsyncPostExecute: TOnSqliteDataAccessAsyncPostExecute
      read FOnAsyncPostExecute write FOnAsyncPostExecute;
    property EOF: boolean read GetEOF;
    property BOF: boolean read GetBOF;
  end;

  TOnClickDBListItem = procedure(Sender: TObject; ItemIndex: integer;
    itemCaption: string) of object;

  {Draft Component code by "Lazarus Android Module Wizard" [01/02/2018 11:13:51]}
  {https://github.com/jmpessoa/lazandroidmodulewizard}

  {jVisualControl template}

  { jDBListView -  thanks to Martin Lowry  !!! }

  jDBListView = class(jVisualControl)
  private
    FOnClickDBListItem: TOnClickDBListItem;
    FOnLongClickDBListItem: TOnClickDBListItem;
    FjSqliteCursor: jSqliteCursor;

    FColWeights: TStrings;
    FColNames: TStrings;

    procedure SetColor(Value: TARGBColorBridge); //background
    procedure SetColumnWeights(Value: TStrings);
    procedure SetColumnNames(Value: TStrings);
    procedure SetCursor(Value: jSqliteCursor);
    procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetFontSize(_size: DWord);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetVisible(Value: boolean);

  protected
    FjPRLayoutHome: jObject; //Save view parent origin
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;

    procedure GenEvent_OnClickDBListItem(Obj: TObject; position: integer;
      itemCaption: string);
    procedure GenEvent_OnLongClickDBListItem(Obj: TObject; position: integer;
      itemCaption: string);
    function jCreate(): jObject;
    procedure jFree();
    function GetParent(): jObject;
    function GetView(): jObject; override;
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent(); override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure setLGravity(_g: integer);
    procedure setLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer;
      _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);

    function GetItemIndex(): integer;
    function GetItemCaption(): string;
    procedure SetSelection(_index: integer);
    procedure ChangeCursor(NewCursor: jSqliteCursor);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ColumnWeights: TStrings read FColWeights write SetColumnWeights;
    property ColumnNames: TStrings read FColNames write SetColumnNames;
    property DataSource: jSqliteCursor read FjSqliteCursor write SetCursor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;

    property OnClickItem: TOnClickDBListItem
      read FOnClickDBListItem write FOnClickDBListItem;
    property OnLongClickItem: TOnClickDBListItem
      read FOnLongClickDBListItem write FOnLongClickDBListItem;
  end;

  { jTextView }

  TEllipsizeMode = (emEnd, emMidle, emMarquee, emStart);

  jTextView = class(jVisualControl)
  private
    FTextAlignment: TTextAlignment;
    FTextTypeFace: TTextTypeFace;
    FAllCaps: boolean;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetFontColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);

    procedure SetTextAlignment(Value: TTextAlignment);

  protected
    procedure SetEnabled(Value: boolean); override;
    function GetText: string; override;

    procedure SetFontFace(AValue: TFontFace); //override;
    procedure SetTextTypeFace(Value: TTextTypeFace); //override;

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure GenEvent_OnClick(Obj: TObject);

    procedure GenEvent_OnLOngClick(Obj: TObject);

    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure Append(_txt: string);
    procedure AppendLn(_txt: string);
    procedure CopyToClipboard();
    procedure PasteFromClipboard();

    procedure SetText(Value: string); override;
    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
      overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string;
      _side: TCompoundDrawablesSide); overload;
    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetShadowLayer(_radius: single; _dx: single; _dy: single;
      _color: TARGBColorBridge);
    procedure SetShaderLinearGradient(_startColor: TARGBColorBridge;
      _endColor: TARGBColorBridge);
    procedure SetShaderRadialGradient(_centerColor: TARGBColorBridge;
      _edgeColor: TARGBColorBridge);
    procedure SetShaderSweepGradient(_color1: TARGBColorBridge;
      _color2: TARGBColorBridge);
    procedure SetTextDirection(_textDirection: TTextDirection);
    procedure SetFontFromAssets(_fontName: string);
    procedure SetTextIsSelectable(_value: boolean);
    procedure SetScrollingText();
    procedure SetTextAsLink(_linkText: string); overload;
    procedure SetTextAsLink(_linkText: string; _color: TARGBColorBridge); overload;
    procedure SetBackgroundAlpha(_alpha: integer);
    //You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
    procedure MatchParent();
    procedure WrapParent();
    procedure ClearLayout();
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure ResetViewParent(); override;
    procedure SetAllCaps(_value: boolean);
    procedure SetTextAsHtml(_htmlText: string);

    procedure SetRotation(angle: integer);

    procedure BringToFront;
    procedure SetUnderline(_on: boolean); // by ADiV

    procedure ApplyDrawableXML(_xmlIdentifier: string);

    procedure SetSingleLine(_value: boolean);
    procedure SetHorizontallyScrolling(_value: boolean);
    procedure SetEllipsize(_mode: TEllipsizeMode);
    procedure SetTextAllCaps(_text: string);
    procedure SetScrollingMovementMethod();
    procedure SetVerticalScrollBarEnabled(_value: boolean);
    procedure SetHorizontalScrollBarEnabled(_value: boolean);
    procedure SetVerticalScrollbarPosition(_value: integer);

  published
    property Text: string read GetText write SetText;
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;
    property Enabled: boolean read FEnabled write SetEnabled;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property AllCaps: boolean read FAllCaps write SetAllCaps default False;
    // Event - if enabled!
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnLongClick: TOnNotify read FOnLongClick write FOnLongClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw
      read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw
      read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnLayouting: TOnLayouting read FOnLayouting write FOnLayouting;
  end;


  TEditTextOnActionIconTouchUp = procedure(Sender: TObject; textContent: string) of object;
  TEditTextOnActionIconTouchDown = procedure(Sender: TObject; textContent: string) of object;

  jEditText = class(jVisualControl)
  private
    FActionIconIdentifier: string;
    FOnActionIconTouchUp: TEditTextOnActionIconTouchUp;
    FOnActionIconTouchDown: TEditTextOnActionIconTouchDown;
    FInputTypeEx: TInputTypeEx;
    FHint: string;
    FMaxTextLength: integer;
    FSingleLine: boolean;
    FMaxLines: DWord;  //visibles lines!

    FScrollBarStyle: TScrollBarStyle;
    FHorizontalScrollBar: boolean;
    FVerticalScrollBar: boolean;
    FWrappingLine: boolean;

    FOnLostFocus: TOnEditLostFocus;
    FOnFocus: TOnEditLostFocus; // by ADiV
    FOnEnter: TOnNotify;
    FOnBackPressed: TOnNotify; // by ADiV
    FOnDone: TOnNotify; // by Mongkey
    FOnGo: TOnNotify; // by Mongkey
    FOnNext: TOnNotify; // by Mongkey
    FOnSearch: TOnNotify; // by Mongkey
    FOnChange: TOnChange;
    FOnChanged: TOnChange;
    FEditable: boolean;


    FTextAlignment: TTextAlignment;
    FCloseSoftInputOnEnter: boolean;
    FCapSentence: boolean;
    FCaptureBackPressed: boolean; // by ADiV

    procedure AllCaps();
    procedure SetColor(Value: TARGBColorBridge);

    procedure SetFontColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);
    procedure SetHint(Value: string);

    procedure SetInputTypeEx(Value: TInputTypeEx);
    procedure SetTextMaxLength(Value: integer);
    function GetCursorPos: TXY;
    procedure SetCursorPos(Value: TXY);
    procedure SetTextAlignment(Value: TTextAlignment);

    procedure SetSingleLine(Value: boolean);
    procedure SetScrollBarStyle(Value: TScrollBarStyle);

    procedure SetMaxLines(Value: DWord);
    procedure SetVerticalScrollBar(Value: boolean);
    procedure SetHorizontalScrollBar(Value: boolean);

  protected
    procedure SetText(Value: string); override;
    function GetText: string; override;

    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(Value: TTextTypeFace);
    procedure SetEditable(Enabled: boolean);
    procedure SetHintTextColor(Value: TARGBColorBridge);

    procedure GenEvent_OnEnter(Obj: TObject);
    procedure GenEvent_OnBackPressed(Obj: TObject); // by ADiV
    procedure GenEvent_OnDone(Obj: TObject); // by mongkey
    procedure GenEvent_OnGo(Obj: TObject); // by mongkey
    procedure GenEvent_OnNext(Obj: TObject); // by mongkey
    procedure GenEvent_OnSearch(Obj: TObject); // by mongkey
    procedure GenEvent_OnChange(Obj: TObject; txt: string; Count: integer);
    procedure GenEvent_OnChanged(Obj: TObject; txt: string; Count: integer);
    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
    procedure GenEvent_OnOnFocus(Obj: TObject; txt: string); // By ADiV

    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);

    procedure GenEvent_EditTextOnActionIconTouchUp(Sender: TObject; textContent: string);
    procedure GenEvent_EditTextOnActionIconTouchDown(Sender: TObject; textContent: string);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;

    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure SetMovementMethod;
    procedure SetScrollBarFadingEnabled(Value: boolean);

    procedure SetFocus;
    procedure ImmShow;
    procedure ImmHide;
    procedure HideSoftInput();
    procedure ShowSoftInput();

    procedure UpdateLayout; override;
    procedure DispatchOnChangeEvent(Value: boolean);
    procedure DispatchOnChangedEvent(Value: boolean);

    procedure Append(_txt: string);
    procedure AppendLn(_txt: string);
    procedure AppendTab();

    procedure SetImeOptions(_imeOption: TImeOptions);
    procedure SetSoftInputOptions(_imeOption: TImeOptions);

    procedure SetAcceptSuggestion(_value: boolean);
    procedure CopyToClipboard();
    procedure PasteFromClipboard();
    procedure Clear;

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetSelection(_value: integer);
    procedure SetSelectAllOnFocus(_value: boolean);
    procedure SelectAll();
    procedure SetBackgroundByResIdentifier(_imgResIdentifier: string);
    procedure SetBackgroundByImage(_image: jObject);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
      overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string;
      _side: TCompoundDrawablesSide); overload;
    procedure SetTextDirection(_textDirection: TTextDirection);
    procedure SetFontFromAssets(_fontName: string);
    procedure RequestFocus();
    procedure SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
    procedure SetCapSentence(_capSentence: boolean);
    procedure SetCaptureBackPressed(_capBackPressed: boolean); // by ADiV

    procedure LoadFromFile(_path: string; _filename: string); overload;
    procedure LoadFromFile(_filename: string); overload;
    procedure SaveToFile(_path: string; _filename: string); overload;
    procedure SaveToFile(_filename: string); overload;
    procedure ClearLayout();

    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure ResetViewParent(); override;
    procedure SetSoftInputShownOnFocus(_show: boolean);

    procedure SetRoundCorner();
    procedure SetRoundRadiusCorner(_radius: integer);
    procedure SetRoundBorderColor(_color: TARGBColorBridge);
    procedure SetRoundBorderWidth(_strokeWidth: integer);
    procedure SetRoundBackgroundColor(_color: TARGBColorBridge);

    procedure SetAllLowerCase(_lowercase: boolean);
    procedure SetAllUpperCase(_uppercase: boolean);

    procedure SetActionIconIdentifier(_actionIconIdentifier: string);
    procedure ShowActionIcon();
    procedure HideActionIcon();
    function IsActionIconShowing(): boolean;

    function GetTextLength(): int64;
    function IsEmpty(): boolean;


    procedure ApplyDrawableXML(_xmlIdentifier: string);

    // Property
    property CursorPos: TXY read GetCursorPos write SetCursorPos;
    //property Scroller: boolean  read FScroller write SetScroller;
  published
    property Text: string read GetText write SetText;
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;

    property InputTypeEx: TInputTypeEx read FInputTypeEx write SetInputTypeEx;
    property MaxTextLength: integer read FMaxTextLength write SetTextMaxLength;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;

    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace
      read FTextTypeFace write SetTextTypeFace default tfNormal;
    property Hint: string read FHint write SetHint;
    property HintTextColor: TARGBColorBridge read FHintTextColor write SetHintTextColor;
    property ScrollBarStyle: TScrollBarStyle read FScrollBarStyle
      write SetScrollBarStyle;
    //Max visible lines!
    property MaxLines: DWord read FMaxLines write SetMaxLines;
    property HorScrollBar: boolean read FHorizontalScrollBar
      write SetHorizontalScrollBar;
    property VerScrollBar: boolean read FVerticalScrollBar write SetVerticalScrollBar;
    property WrappingLine: boolean read FWrappingLine write FWrappingLine;
    property Editable: boolean read FEditable write SetEditable;

    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property CloseSoftInputOnEnter: boolean
      read FCloseSoftInputOnEnter write SetCloseSoftInputOnEnter;
    property CapSentence: boolean read FCapSentence write SetCapSentence;
    property CaptureBackPressed: boolean read FCaptureBackPressed
      write SetCaptureBackPressed; // by ADiV
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    // Event
    property OnLostFocus: TOnEditLostFocus read FOnLostFocus write FOnLostFocus;
    property OnFocus: TOnEditLostFocus read FOnFocus write FOnFocus;   // by ADiV
    property OnEnter: TOnNotify read FOnEnter write FOnEnter;
    property OnBackPressed: TOnNotify read FOnBackPressed write FOnBackPressed;
    property OnDone: TOnNotify read FOnDone write FOnDone;// by Mongkey
    property OnGo: TOnNotify read FOnGo write FOnGo;// by Mongkey
    property OnNext: TOnNotify read FOnNext write FOnNext;// by Mongkey
    property OnSearch: TOnNotify read FOnSearch write FOnSearch;// by Mongkey

    property OnChange: TOnChange read FOnChange write FOnChange;
    property OnChanged: TOnChange read FOnChanged write FOnChanged;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw
      read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw
      read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnLayouting: TOnLayouting read FOnLayouting write FOnLayouting;

    property ActionIconIdentifier: string read FActionIconIdentifier
      write SetActionIconIdentifier;
    property OnActionIconTouchUp: TEditTextOnActionIconTouchUp
      read FOnActionIconTouchUp write FOnActionIconTouchUp;
    property OnActionIconTouchDown: TEditTextOnActionIconTouchDown
      read FOnActionIconTouchDown write FOnActionIconTouchDown;


  end;

  { jButton }

  jButton = class(jVisualControl)
  private
    FAllCaps: boolean;
    procedure SetAllCaps(AValue: boolean);
    procedure SetColor(Value: TARGBColorBridge);

    procedure SetFontColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);

  protected
    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);

    function GetText: string; override;
    procedure SetText(Value: string); override;
    procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout(); override;

    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure PerformClick();
    procedure PerformLongClick();
    procedure SetBackgroundByResIdentifier(_imgResIdentifier: string);
    procedure SetBackgroundByImage(_image: jObject);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
      overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string;
      _side: TCompoundDrawablesSide); overload;
    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetFontFromAssets(_fontName: string);
    procedure ClearLayout();

    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetLWeight(_weight: single);

    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure ResetViewParent(); override;
    procedure SetFocus();

    procedure BringToFront; // By ADiV

    procedure ApplyDrawableXML(_xmlIdentifier: string);

    procedure Append(_txt: string);

  published
    property Text: string read GetText write SetText;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property Enabled: boolean read FEnabled write SetEnabled;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property AllCaps: boolean read FAllCaps write SetAllCaps default False;
    // Event
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw
      read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw
      read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
  end;

  jCheckBox = class(jVisualControl)
  private
    FChecked: boolean;
    procedure SetColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);
    function GetChecked: boolean;
    procedure SetChecked(Value: boolean);

  protected
    procedure GenEvent_OnClick(Obj: TObject);
    function GetText: string; override;   //by thierry
    procedure SetText(Value: string); override; //by thierry

    procedure SetFontColor(Value: TARGBColorBridge);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout(); override;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
      overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string;
      _side: TCompoundDrawablesSide); overload;
    procedure SetFontFromAssets(_fontName: string);
    procedure ClearLayout();
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

  published
    property Text: string read GetText write SetText;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property Checked: boolean read GetChecked write SetChecked;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    // Event
    property OnClick: TOnNotify read FOnClick write FOnClick;
  end;

  jRadioButton = class(jVisualControl)
  private
    FChecked: boolean;
    //FOnClick   : TOnNotify;
    procedure SetColor(Value: TARGBColorBridge);
    procedure SetFontColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);
    function GetChecked: boolean;
    procedure SetChecked(Value: boolean);

  protected
    procedure GenEvent_OnClick(Obj: TObject);
    function GetText: string; override;
    procedure SetText(Value: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout(); override;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
      overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string;
      _side: TCompoundDrawablesSide); overload;
    procedure SetFontFromAssets(_fontName: string);
    procedure ClearLayout();
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

    procedure SetRoundColor(_color: TARGBColorBridge);

  published
    property Text: string read GetText write SetText;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property Checked: boolean read GetChecked write SetChecked;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    // Event
    property OnClick: TOnNotify read FOnClick write FOnClick;
  end;

  jProgressBar = class(jVisualControl)
  private
    FProgress: integer;
    FMax: integer;
    FStyle: TProgressBarStyle;
    procedure SetColor(Value: TARGBColorBridge);

    function GetProgress: integer;
    procedure SetProgress(Value: integer);
    function GetMax: integer;   //by jmpessoa
    procedure SetMax(Value: integer);  //by jmpessoa

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    procedure ClearLayout;
    procedure UpdateLayout(); override;

    procedure Init; override;
    procedure Stop;
    procedure Start;
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

    procedure BringToFront;
    procedure SetColors(_color, _colorBack: TARGBColorBridge);
    procedure ApplyDrawableXML(_xmlIdentifier: string);
    procedure SetMarkerColor(_color: TARGBColorBridge);

  published
    property Style: TProgressBarStyle read FStyle write FStyle;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Progress: integer read GetProgress write SetProgress;
    property Max: integer read GetMax write SetMax;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;

  end;

  TOnImageViewPopupItemSelected = procedure(Sender: TObject; Caption: string) of object;

  jImageView = class(jVisualControl)
  private
    FImageName: string;
    FImageIndex: TImageListIndex;
    FImageList: jImageList;
    FFilePath: TFilePath;
    FImageScaleType: TImageScaleType;

    //by ADiV
    FMouches: TMouches;
    FOnTouchDown: TOnTouchEvent;
    FOnTouchMove: TOnTouchEvent;
    FOnTouchUp: TOnTouchEvent;

    FAlpha: integer;
    //end ADiV
    FRoundedShape: boolean;
    FOnPopupItemSelected: TOnImageViewPopupItemSelected;

    FAnimationDurationIn: integer;
    FAnimationDurationOut: integer;
    FAnimationMode: TAnimationMode;

    procedure SetColor(Value: TARGBColorBridge);

    procedure SetImages(Value: jImageList);
    function GetCount: integer;
    procedure SetImageName(Value: string);
    procedure SetImageIndex(Value: TImageListIndex);
    procedure SetRoundedShape(_value: boolean);

  protected
    procedure SetParamWidth(Value: TLayoutParams); override;
    procedure SetParamHeight(Value: TLayoutParams); override;
    procedure GenEvent_OnClick(Obj: TObject);

    //by ADiV
    procedure GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer; X1, Y1, X2, Y2: single);

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    function GetHeight: integer; override;
    function GetWidth: integer; override;

    procedure ClearLayout; //by ADiV

    procedure UpdateLayout(); override;
    procedure Init; override;
    procedure SetImageByName(Value: string);
    procedure SetImageByIndex(Value: integer);

    procedure SetImageBitmap(bitmap: jObject); overload;  //deprecated
    procedure SetImage(bitmap: jObject); overload;

    procedure SetImageByResIdentifier(_imageResIdentifier: string);    // ../res/drawable

    function GetBitmapHeight: integer;
    function GetBitmapWidth: integer;

    procedure SetAlpha(Value: integer); //by ADiV
    procedure SetSaturation(Value: single); // by ADiV

    procedure SetScale(_scaleX: single; _scaleY: single); //by ADiV
    procedure SetMatrix(_scaleX, _scaleY, _angle, _dx, _dy, _px, _py: single); //by ADiV
    procedure SetMatrixScaleCenter(_scaleX, _scaleY: single); //by ADiV

    procedure SetScaleType(_scaleType: TImageScaleType);

    function GetBitmapImage(): jObject; overload;
    function GetBitmapImage(_x, _y, _width, _height: integer): jObject; overload;
    function GetImage(): jObject;

    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;

    procedure SetRotation(angle: integer);
    function SaveToJPG(filePath: string; cuality: integer; angle: integer): boolean;
    function SaveToPNG(filePath: string; cuality: integer; angle: integer): boolean;

    procedure SetImageFromURI(_uri: jObject);
    procedure SetImageFromIntentResult(_intentData: jObject);
    procedure SetImageThumbnailFromCamera(_intentData: jObject);
    procedure SetImageFromJByteArray(var _image: TDynArrayOfJByte);
    procedure SetImageBitmap(_bitmap: jObject; _width: integer; _height: integer);
      overload; //deprecated
    procedure SetImage(_bitmap: jObject; _width: integer; _height: integer); overload;
    procedure SetImage(_fullFilename: string); overload;
    procedure SetImageFromJByteBuffer(_jbyteBuffer: jObject; _width: integer;
      _height: integer);
    procedure SetImageFromAssets(_filename: string);

    procedure SetRoundCorner(); overload;
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetCollapseMode(_collapsemode: TCollapsingMode);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure ResetViewParent(); override;
    procedure BringToFront;
    procedure SetVisibilityGone();
    function GetDirectBufferAddress(byteBuffer: jObject): PJByte;
    function GetJByteBuffer(_width: integer; _height: integer): jObject;
    function GetBitmapFromJByteBuffer(_jbyteBuffer: jObject; _width: integer;
      _height: integer): jObject;
    procedure LoadFromURL(_url: string);
    procedure SaveToFile(_filename: string);
    function GetView(): jObject; override;
    procedure ShowPopupMenu(var _items: TDynArrayOfString); overload;
    procedure ShowPopupMenu(_items: array of string); overload;

    procedure SetAnimationDurationIn(_animationDurationIn: integer);
    procedure SetAnimationDurationOut(_animationDurationOut: integer);
    procedure SetAnimationMode(_animationMode: TAnimationMode);
    procedure Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
    procedure AnimateRotate(_angleFrom, _angleTo: integer);

    procedure SetImageDrawable(_imageAnimation: jObject);
    procedure Clear();

    procedure ApplyDrawableXML(_xmlIdentifier: string);
    procedure SetClipToOutline(_value: boolean);

    procedure SetRoundCorner(_cornersRadius: integer); overload;
    procedure SetRippleEffect();

    procedure GenEvent_OnImageViewPopupItemSelected(Sender: TObject; Caption: string);

    property Count: integer read GetCount;
  published
    property ImageIndex: TImageListIndex read FImageIndex write SetImageIndex default -1;
    property Images: jImageList read FImageList write SetImages;

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ImageIdentifier: string read FImageName write SetImageByResIdentifier;
    property ImageScaleType: TImageScaleType read FImageScaleType write SetScaleType;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property RoundedShape: boolean read FRoundedShape write SetRoundedShape;

    property AnimationDurationIn: integer read FAnimationDurationIn
      write SetAnimationDurationIn;
    property AnimationDurationOut: integer read FAnimationDurationOut
      write SetAnimationDurationOut;
    property AnimationMode: TAnimationMode read FAnimationMode write SetAnimationMode;

    // Events
    property OnPopupItemSelected: TOnImageViewPopupItemSelected
      read FOnPopupItemSelected write FOnPopupItemSelected;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    //by ADiV
    property OnTouchDown: TOnTouchEvent read FOnTouchDown write FOnTouchDown;
    property OnTouchMove: TOnTouchEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchUp: TOnTouchEvent read FOnTouchUp write FOnTouchUp;

  end;

  TFilterMode = (fmStartsWith, fmContains);

  jListView = class(jVisualControl)
  private
    FOnClickItem: TOnClickCaptionItem;
    FOnClickTextLeft: TOnClickCaptionItem; // by ADiV
    FOnClickTextCenter: TOnClickCaptionItem; // by ADiV
    FOnClickTextRight: TOnClickCaptionItem; // by ADiV
    FOnClickWidgetItem: TOnClickWidgetItem;
    FOnClickImageItem: TOnClickImageItem; // by ADiV
    FOnLongClickItem: TOnClickCaptionItem;
    FOnDrawItemTextColor: TOnDrawItemTextColor;
    FOnDrawItemBackColor: TOnDrawItemBackColor; // by ADiV
    FOnDrawItemWidgetTextColor: TOnDrawItemWidgetTextColor;
    FOnDrawItemWidgetText: TOnDrawItemWidgetText;
    FOnDrawItemBitmap: TOnDrawItemBitmap;
    FOnWidgeItemLostFocus: TOnWidgeItemLostFocus;
    FOnScrollStateChanged: TOnScrollStateChanged;
    FOnDrawItemWidgetBitmap: TOnDrawItemWidgetBitmap;
    FOnDrawItemCustomFont: TOnDrawItemCustomFont;

    FItems: TStrings;
    FWidgetItem: TWidgetItem;
    FWidgetText: string;
    FDelimiter: string;
    FImageItem: jBitmap;
    FTextColorInfo: TARGBColorBridge; // by ADiV
    FTextDecorated: TTextDecorated;
    FTextSizeDecorated: TTextSizeDecorated;
    FItemLayout: TItemLayout;
    FTextAlign: TTextAlign;
    FTextPosition: TTextPosition;

    FHighLightSelectedItemColor: TARGBColorBridge;
    FImageItemIdentifier: string;

    FItemPaddingTop: integer;
    FItemPaddingBottom: integer;
    FItemPaddingLeft: integer;  // by ADiV
    FItemPaddingRight: integer; // by ADiV

    FTextMarginLeft: integer; // by ADiV
    FTextMarginRight: integer; // by ADiV
    FTextMarginInner: integer; // by ADiV

    FTextWordWrap: boolean; // by ADiV
    FEnableOnClickTextLeft: boolean; // by ADiV
    FEnableOnClickTextCenter: boolean; // by ADiV
    FEnableOnClickTextRight: boolean; // by ADiV

    FWidgetTextColor: TARGBColorBridge;
    FItemTextEllipsis: boolean;

    procedure SetHighLightSelectedItemColor(_color: TARGBColorBridge);

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetItemPosition(Value: TXY);
    procedure ListViewChange(Sender: TObject);

    procedure SetItems(Value: TStrings);

    procedure SetFontColor(Value: TARGBColorBridge);
    procedure SetFontSize(Value: DWord);
    procedure SetWidget(Value: TWidgetItem);
    procedure SetImage(Value: jBitmap);
    function GetCount: integer;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetFontFace(AValue: TFontFace);

    procedure SetItemLayout(_itemLayout: TItemLayout); // by ADiV
    procedure SetTextAlign(_textAlign: TTextAlign);    // by ADiV
  protected
    procedure GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; Checked: boolean);
    procedure GenEvent_OnClickImageItem(Obj: TObject; index: integer); // by ADiV

    procedure GenEvent_OnClickCaptionItem(Obj: TObject; index: integer; Caption: string);
    procedure GenEvent_OnClickTextLeft(Obj: TObject; index: integer;
      Caption: string); // by ADiV
    procedure GenEvent_OnClickTextCenter(Obj: TObject; index: integer;
      Caption: string); // by ADiV
    procedure GenEvent_OnClickTextRight(Obj: TObject; index: integer;
      Caption: string); // by ADiV

    procedure GenEvent_OnLongClickCaptionItem(Obj: TObject; index: integer;
      Caption: string);

    procedure GenEvent_OnDrawItemCaptionColor(Obj: TObject; index: integer;
      Caption: string; out color: dword);
    procedure GenEvent_OnListViewDrawItemCustomFont(Sender: TObject;
      position: integer; Caption: string; var outCustomFontName: string);
    procedure GenEvent_OnDrawItemBackgroundColor(Obj: TObject;
      index: integer; out color: dword); // by ADiV

    procedure GenEvent_OnDrawItemWidgetTextColor(Obj: TObject;
      index: integer; Caption: string; out color: dword);
    procedure GenEvent_OnDrawItemWidgetText(Obj: TObject; index: integer;
      Caption: string; out newtext: string);

    procedure GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer;
      Caption: string; out bitmap: JObject);
    procedure GenEvent_OnDrawItemWidgetBitmap(Obj: TObject; index: integer;
      Caption: string; out bitmap: JObject);

    procedure GenEvent_OnWidgeItemLostFocus(Obj: TObject; index: integer;
      Caption: string);
    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnScrollStateChanged(Obj: TObject;
      firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer;
      lastItemReached: boolean);

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    procedure ClearLayout;
    procedure UpdateLayout(); override;
    procedure Init; override;

    function GetWidth: integer; override;
    function GetHeight: integer; override;

    function IsItemChecked(index: integer): boolean;
    procedure Add(item: string); overload;

    procedure Add(item: string; delim: string); overload;
    procedure Insert(_index: integer; item: string; _delimiter: string); overload;
    procedure Insert(_index: integer; item: string); overload;

    procedure Add(item: string; delim: string; fontColor: TARGBColorBridge;
      fontSize: integer; hasWidget: TWidgetItem;
      widgetText: string; image: jObject); overload;
    procedure Delete(index: integer);
    function GetItemText(index: integer): string;
    procedure SetItemText(txt: string; index: integer); // by ADiV
    procedure Clear;
    procedure SetFontColorByIndex(Value: TARGBColorBridge; index: integer);
    procedure SetFontSizeByIndex(Value: DWord; index: integer);
    function GetFontSizeByIndex(index: integer): integer; // by ADiV

    procedure SetWidgetByIndex(Value: TWidgetItem; index: integer); overload;
    procedure SetWidgetByIndex(Value: TWidgetItem; txt: string;
      index: integer); overload;
    procedure SetWidgetTextByIndex(txt: string; index: integer);

    procedure SetImageByIndex(Value: jObject; index: integer); overload;

    procedure SetImageByIndex(imgResIdentifier: string; index: integer);
      overload; // ..res/drawable

    procedure SetTextColorInfo(_color: TARGBColorBridge); // by ADiV
    procedure SetTextColorInfoByIndex(Value: TARGBColorBridge; index: integer);
    // by ADiV

    procedure SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
    procedure SetTextSizeDecoratedByIndex(Value: TTextSizeDecorated; index: integer);
    procedure SetTextAlignByIndex(Value: TTextAlign; index: integer);
    procedure SetTextPositionByIndex(Value: TTextPosition; index: integer); // by ADiV
    procedure SetTextWordWrap(_value: boolean); // by ADiV
    procedure SetEnableOnClickTextLeft(_value: boolean); // by ADiV
    procedure SetEnableOnClickTextCenter(_value: boolean); // by ADiV
    procedure SetEnableOnClickTextRight(_value: boolean); // by ADiV

    procedure SetMaxLinesFirstString(_value: integer); // by ADiV

    procedure SetLayoutByIndex(Value: TItemLayout; index: integer);

    function GetTotalHeight: integer;
    function GetItemHeight(aItemIndex: integer): integer;

    function GetItemIndex(): integer;
    function GetItemCaption(): string;
    procedure DispatchOnDrawItemTextColor(_value: boolean);
    procedure DispatchOnDrawItemBitmap(_value: boolean);
    function GetWidgetText(_index: integer): string;

    procedure SetWidgetOnTouch(_ontouch: boolean); // by ADiV
    procedure SetWidgetCheck(_value: boolean; _index: integer);
    function GetWidgetCheck(_index: integer): boolean; //by ADiV
    procedure SetItemTagString(_tagString: string; _index: integer);
    function GetItemTagString(_index: integer): string;
    procedure SetImageByResIdentifier(_imageResIdentifier: string);

    procedure SetLeftDelimiter(_leftDelimiter: string);
    procedure SetRightDelimiter(_rightDelimiter: string);
    function GetCenterItemCaption(_fullItemCaption: string): string;
    function GetLeftItemCaption(_fullItemCaption: string): string;
    function GetRightItemCaption(_fullItemCaption: string): string;
    function GetLongPressSelectedItem(): integer;
    procedure SetAllPartsOnDrawItemTextColor(_value: boolean);
    procedure SetItemPaddingTop(_ItemPaddingTop: integer);
    procedure SetItemPaddingBottom(_itemPaddingBottom: integer);
    procedure SetItemPaddingLeft(_itemPaddingLeft: integer); // by ADiV
    procedure SetItemPaddingRight(_itemPaddingRight: integer); // by ADiV
    procedure SetTextMarginLeft(_left: integer); // by ADiV
    procedure SetTextMarginRight(_right: integer); // by ADiV
    procedure SetTextMarginInner(_inner: integer); // by ADiV
    procedure SetWidgetImageSide(_side: integer); // by ADiV
    procedure SetWidgetTextColor(_textcolor: TARGBColorBridge);
    procedure SetDispatchOnDrawItemWidgetTextColor(_value: boolean);
    procedure SetDispatchOnDrawItemWidgetText(_value: boolean);
    procedure SetWidgetInputTypeIsCurrency(_value: boolean);
    procedure SetWidgetFontFromAssets(_customFontName: string);
    procedure DispatchOnDrawWidgetItemWidgetTextColor(_value: boolean);
    procedure DispatchOnDrawItemWidgetImage(_value: boolean);
    function SplitCenterItemCaption(_centerItemCaption: string;
      _delimiter: string): TDynArrayOfString;
    procedure SetSelection(_index: integer);
    procedure SmoothScrollToPosition(_index: integer);
    procedure SetDrawAlphaBackground(_alpha: integer); // by ADiV
    procedure ClearChecked(); // by ADiV
    function GetItemsChecked(): integer; // by ADiV
    procedure SetItemChecked(_index: integer; _value: boolean);
    function GetCheckedItemPosition(): integer;
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure ResetViewParent(); override;
    procedure SetFitsSystemWindows(_value: boolean);
    procedure BringToFront;
    procedure SetVisibilityGone();

    procedure SaveToFile(_appInternalFileName: string);
    procedure LoadFromFile(_appInternalFileName: string);

    procedure SetFilterQuery(_query: string); overload;
    procedure SetFilterQuery(_query: string; _filterMode: integer); overload;
    procedure SetFilterMode(_filterMode: TFilterMode);
    procedure ClearFilterQuery();
    procedure SetDrawItemBackColorAlpha(_alpha: integer);

    procedure DisableScroll(_disable: boolean); // by ADiV
    procedure SetFastScrollEnabled(_enable: boolean); // by ADiV
    procedure SetBackgroundByResIdentifier(_imgResIdentifier: string);
    procedure DispatchOnDrawItemTextCustomFont(_value: boolean);

    procedure SetItemTextEllipsis(_value: boolean);

    //Property
    property setItemIndex: TXY write SetItemPosition;
    property Count: integer read GetCount;

    property OnWidgeItemLostFocus: TOnWidgeItemLostFocus
      read FOnWidgeItemLostFocus write FOnWidgeItemLostFocus;
  published
    property Items: TStrings read FItems write SetItems;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize: DWord read FFontSize write SetFontSize;
    property WidgetItem: TWidgetItem read FWidgetItem write SetWidget;
    property WidgetText: string read FWidgetText write FWidgetText;
    property ImageItem: jBitmap read FImageItem write SetImage;
    property Delimiter: string read FDelimiter write FDelimiter;
    property TextColorInfo: TARGBColorBridge read FTextColorInfo write SetTextColorInfo;
    // by ADiV
    property TextDecorated: TTextDecorated read FTextDecorated write FTextDecorated;
    property ItemLayout: TItemLayout read FItemLayout write SetItemLayout;
    property TextSizeDecorated: TTextSizeDecorated
      read FTextSizeDecorated write FTextSizeDecorated;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property TextPosition: TTextPosition read FTextPosition write FTextPosition;
    // by ADiV
    property TextWordWrap: boolean read FTextWordWrap write SetTextWordWrap; // by ADiV
    property EnableOnClickTextLeft: boolean
      read FEnableOnClickTextLeft write SetEnableOnClickTextLeft; // by ADiV
    property EnableOnClickTextCenter: boolean
      read FEnableOnClickTextCenter write SetEnableOnClickTextCenter; // by ADiV
    property EnableOnClickTextRight: boolean
      read FEnableOnClickTextRight write SetEnableOnClickTextRight; // by ADiV
    property HighLightSelectedItemColor: TARGBColorBridge
      read FHighLightSelectedItemColor write SetHighLightSelectedItemColor;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;

    property ImageItemIdentifier: string read FImageItemIdentifier
      write SetImageByResIdentifier;
    property ItemPaddingTop: integer read FItemPaddingTop write SetItemPaddingTop;
    property ItemPaddingBottom: integer read FItemPaddingBottom
      write SetItemPaddingBottom;
    property ItemPaddingLeft: integer read FItemPaddingLeft write SetItemPaddingLeft;
    // by ADiV
    property ItemPaddingRight: integer read FItemPaddingRight write SetItemPaddingRight;

    property TextMarginLeft: integer read FTextMarginLeft write SetTextMarginLeft;
    // by ADiV
    property TextMarginRight: integer read FTextMarginRight write SetTextMarginRight;
    // by ADiV
    property TextMarginInner: integer read FTextMarginInner write SetTextMarginInner;
    // by ADiV

    property WidgetTextColor: TARGBColorBridge
      read FWidgetTextColor write SetWidgetTextColor;
    property ItemTextEllipsis: boolean read FItemTextEllipsis write SetItemTextEllipsis;
    // Event
    property OnClickItem: TOnClickCaptionItem read FOnClickItem write FOnClickItem;
    property OnClickItemTextLeft: TOnClickCaptionItem
      read FOnClickTextLeft write FOnClickTextLeft; // by ADiV
    property OnClickItemTextCenter: TOnClickCaptionItem
      read FOnClickTextCenter write FOnClickTextCenter; // by ADiV
    property OnClickItemTextRight: TOnClickCaptionItem
      read FOnClickTextRight write FOnClickTextRight; // by ADiV

    property OnClickWidgetItem: TOnClickWidgetItem
      read FOnClickWidgetItem write FOnClickWidgetItem;
    property OnClickImageItem: TOnClickImageItem
      read FOnClickImageItem write FOnClickImageItem;
    property OnLongClickItem: TOnClickCaptionItem
      read FOnLongClickItem write FOnLongClickItem;

    property OnDrawItemTextColor: TOnDrawItemTextColor
      read FOnDrawItemTextColor write FOnDrawItemTextColor;
    property OnDrawItemCustomFont: TOnDrawItemCustomFont
      read FOnDrawItemCustomFont write FOnDrawItemCustomFont;

    property OnDrawItemBackColor: TOnDrawItemBackColor
      read FOnDrawItemBackColor write FOnDrawItemBackColor; // by ADiV
    property OnDrawItemWidgetTextColor: TOnDrawItemWidgetTextColor
      read FOnDrawItemWidgetTextColor write FOnDrawItemWidgetTextColor;
    property OnDrawItemWidgetText: TOnDrawItemWidgetText
      read FOnDrawItemWidgetText write FOnDrawItemWidgetText;
    property OnDrawItemBitmap: TOnDrawItemBitmap
      read FOnDrawItemBitmap write FOnDrawItemBitmap;
    property OnDrawItemWidgetBitmap: TOnDrawItemWidgetBitmap
      read FOnDrawItemWidgetBitmap write FOnDrawItemWidgetBitmap;

    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw
      read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnAfterDispatchDraw
      read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnScrollStateChanged: TOnScrollStateChanged
      read FOnScrollStateChanged write FOnScrollStateChanged;

  end;

  TScrollPosition = (spIntermediary, spBegin, spEnd);

  TOnScrollChanged = procedure(Sender: TObject; currHor: integer;
    currVerti: integer; prevHor: integer; prevVertical: integer;
    position: TScrollPosition; scrolldiff: integer) of object;

  TOnScrollViewInnerItemClick = procedure(Sender: TObject; itemId: integer) of object;
  TOnScrollViewInnerItemLongClick = procedure(Sender: TObject; index: integer;
    itemId: integer) of object;

  TScrollInnerLayout = (ilRelative, ilLinear);

  { jScrollView }

  jScrollView = class(jVisualControl)
  private
    FInnerLayout: TScrollInnerLayout;
    FScrollSize: integer;
    FFillViewportEnabled: boolean;
    FOnScrollChanged: TOnScrollChanged;
    FOnInnerItemClick: TOnScrollViewInnerItemClick;
    FOnInnerItemLongClick: TOnScrollViewInnerItemLongClick;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetScrollSize(Value: integer);
    procedure SetInnerLayout(layout: TScrollInnerLayout);
  protected
    function GetView: jObject; override;
    //procedure SetParamWidth(Value: TLayoutParams); override; TODO
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    procedure ClearLayout;
    procedure UpdateLayout(); override;
    procedure Init; override;

    procedure SetFillViewport(fillenabled: boolean);
    procedure ScrollTo(_x: integer; _y: integer);
    procedure SmoothScrollTo(_x: integer; _y: integer);
    procedure SmoothScrollBy(_x: integer; _y: integer);

    function GetScrollX(): integer;
    function GetScrollY(): integer;
    function GetBottom(): integer;
    function GetTop(): integer;
    function GetLeft(): integer;
    function GetRight(): integer;
    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure DispatchOnScrollChangedEvent(_value: boolean);
    procedure GenEvent_OnChanged(Obj: TObject; currHor: integer;
      currVerti: integer; prevHor: integer; prevVertical: integer;
      onPosition: integer; scrolldiff: integer);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

    procedure AddView(_view: jObject);
    procedure AddImage(_bitmap: jObject); overload;
    procedure AddImage(_bitmap: jObject; _itemId: integer); overload;
    procedure AddImage(_bitmap: jObject; _itemId: integer;
      _scaleType: TImageScaleType); overload;

    procedure AddImageFromFile(_path: string; _filename: string); overload;
    procedure AddImageFromFile(_path: string; _filename: string;
      _itemId: integer); overload;
    procedure AddImageFromFile(_path: string; _filename: string;
      _itemId: integer; _scaleType: TImageScaleType); overload;

    procedure AddImageFromAssets(_filename: string); overload;
    procedure AddImageFromAssets(_filename: string; _itemId: integer); overload;
    procedure AddImageFromAssets(_filename: string; _itemId: integer;
      _scaleType: TImageScaleType); overload;

    procedure AddText(_text: string);

    function GetInnerItemId(_index: integer): integer;
    function GetInnerItemIndex(_itemId: integer): integer;
    procedure Delete(_index: integer);
    procedure Clear();

    procedure BringToFront;

    procedure GenEvent_OnScrollViewInnerItemClick(Sender: TObject; itemId: integer);
    procedure GenEvent_OnScrollViewInnerItemLongClick(Sender: TObject;
      index: integer; itemId: integer);
  published
    property InnerLayout: TScrollInnerLayout read FInnerLayout write SetInnerLayout;
    property FillViewportEnabled: boolean read FFillViewportEnabled
      write SetFillViewport;
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnScrollChanged: TOnScrollChanged
      read FOnScrollChanged write FOnScrollChanged;
    property OnInnerItemClick: TOnScrollViewInnerItemClick
      read FOnInnerItemClick write FOnInnerItemClick;
    property OnInnerItemLongClick: TOnScrollViewInnerItemLongClick
      read FOnInnerItemLongClick write FOnInnerItemLongClick;
  end;

  { jHorizontalScrollView }

  jHorizontalScrollView = class(jVisualControl)
  private
    FInnerLayout: TScrollInnerLayout;
    FScrollSize: integer;
    FOnScrollChanged: TOnScrollChanged;
    FOnInnerItemClick: TOnScrollViewInnerItemClick;
    FOnInnerItemLongClick: TOnScrollViewInnerItemLongClick;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetScrollSize(Value: integer);
    procedure SetInnerLayout(layout: TScrollInnerLayout);

  protected
    function GetView: jObject; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout(); override;

    procedure Init; override;
    procedure ScrollTo(_x: integer; _y: integer);
    procedure SmoothScrollTo(_x: integer; _y: integer);
    procedure SmoothScrollBy(_x: integer; _y: integer);
    function GetScrollX(): integer;
    function GetScrollY(): integer;
    function GetBottom(): integer;
    function GetTop(): integer;
    function GetLeft(): integer;
    function GetRight(): integer;
    procedure DispatchOnScrollChangedEvent(_value: boolean);
    procedure GenEvent_OnChanged(Obj: TObject; currHor: integer;
      currVerti: integer; prevHor: integer; prevVertical: integer;
      onPosition: integer; scrolldiff: integer);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

    function GetWidth: integer; override;
    function GetHeight: integer; override;

    procedure AddView(_view: jObject);
    procedure AddImage(_bitmap: jObject); overload;
    procedure AddImage(_bitmap: jObject; _itemId: integer); overload;
    procedure AddImage(_bitmap: jObject; _itemId: integer;
      _scaleType: TImageScaleType); overload;

    procedure AddImageFromFile(_path: string; _filename: string); overload;
    procedure AddImageFromFile(_path: string; _filename: string;
      _itemId: integer); overload;
    procedure AddImageFromFile(_path: string; _filename: string;
      _itemId: integer; _scaleType: TImageScaleType); overload;

    procedure AddImageFromAssets(_filename: string); overload;
    procedure AddImageFromAssets(_filename: string; _itemId: integer); overload;
    procedure AddImageFromAssets(_filename: string; _itemId: integer;
      _scaleType: TImageScaleType); overload;

    procedure AddText(_text: string);

    function GetInnerItemId(_index: integer): integer;
    function GetInnerItemIndex(_itemId: integer): integer;
    procedure Delete(_index: integer);
    procedure Clear();

    procedure GenEvent_OnScrollViewInnerItemClick(Sender: TObject; itemId: integer);
    procedure GenEvent_OnScrollViewInnerItemLongClick(Sender: TObject;
      index: integer; itemId: integer);
  published
    property InnerLayout: TScrollInnerLayout read FInnerLayout write SetInnerLayout;
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnScrollChanged: TOnScrollChanged
      read FOnScrollChanged write FOnScrollChanged;
    property OnInnerItemClick: TOnScrollViewInnerItemClick
      read FOnInnerItemClick write FOnInnerItemClick;
    property OnInnerItemLongClick: TOnScrollViewInnerItemLongClick
      read FOnInnerItemLongClick write FOnInnerItemLongClick;

  end;

  //------------------------------------------------------------------

  { jWebView }

  jWebView = class(jVisualControl)
  private
    FJavaScript: boolean;
    FOnStatus: TOnWebViewStatus;
    // Fatih - ZoomControl
    FZoomControl: boolean;
    //LMB
    FOnFindResult: TOnWebViewFindResult;
    //segator
    FOnEvaluateJavascriptResult: TOnWebViewEvaluateJavascriptResult;

    FDomStorage: boolean;
    FOnReceivedSslError: TOnWebViewReceivedSslError;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetZoomControl(Value: boolean);
    procedure SetJavaScript(Value: boolean);

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Refresh;

    procedure ClearLayout;
    procedure UpdateLayout(); override;

    procedure Navigate(url: string);
    procedure LoadFromHtmlFile(environmentDirectoryPath: string; htmlFileName: string);
    procedure LoadFromHtmlString(_htmlString: string); //thanks to Anton!

    procedure SetHttpAuthUsernamePassword(_hostName: string; _domain: string;
      _username: string; _password: string);
    procedure GenEvent_OnLongClick(Obj: TObject);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;

    function CanGoBack(): boolean;
    function CanGoBackOrForward(_steps: integer): boolean;
    function CanGoForward(): boolean;
    procedure GoBack();
    procedure GoBackOrForward(steps: integer);
    procedure GoForward();
    procedure ScrollTo(_x, _y: integer);//by MB:

    procedure ClearHistory();  // By ADiV
    procedure ClearCache(_clearDiskFiles: boolean); // By ADiV

    //LMB
    function ScrollY: integer;//LMB
    procedure LoadDataWithBaseURL(s1, s2, s3, s4, s5: string);//LMB
    procedure FindAll(_s: string); //LMB:
    procedure FindNext(_forward: boolean); //LMB
    procedure ClearMatches();//LMB
    function GetFindIndex: integer;//LMB
    function GetFindCount: integer;//LMB
    function GetWidth: integer; override;//LMB
    function GetHeight: integer; override;//LMB

    procedure SetDomStorage(_domStorage: boolean);
    procedure SetLoadWithOverviewMode(_overviewMode: boolean);
    procedure SetUseWideViewPort(_wideViewport: boolean);
    procedure SetAllowContentAccess(_allowContentAccess: boolean);
    procedure SetAllowFileAccess(_allowFileAccess: boolean);
    procedure SetAppCacheEnabled(_cacheEnabled: boolean);
    procedure SetDisplayZoomControls(_displayZoomControls: boolean);
    procedure SetGeolocationEnabled(_geolocationEnabled: boolean);
    procedure SetJavaScriptCanOpenWindowsAutomatically(
      _javaScriptCanOpenWindows: boolean);
    procedure SetLoadsImagesAutomatically(_loadsImagesAutomatically: boolean);
    procedure SetSupportMultipleWindows(_supportMultipleWindows: boolean);
    procedure SetAllowUniversalAccessFromFileURLs(
      _allowUniversalAccessFromFileURLs: boolean);
    procedure SetMediaPlaybackRequiresUserGesture(
      _mediaPlaybackRequiresUserGesture: boolean);
    procedure SetSafeBrowsingEnabled(_safeBrowsingEnabled: boolean);
    procedure SetSupportZoom(_supportZoom: boolean);
    procedure SetUserAgent(_userAgent: string);
    procedure SetInitialScale(_scaleInPercent: integer);

    procedure CallEvaluateJavascript(_jsInnerCode: string); //segator
    procedure GenEvent_OnEvaluateJavascriptResult(Sender: TObject; Data: string); //segator

    procedure GenEvent_OnWebViewReceivedSslError(Sender: TObject;
      error: string; primaryError: integer; var outReturn: boolean);

  published
    property JavaScript: boolean read FJavaScript write SetJavaScript;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ZoomControl: boolean read FZoomControl write SetZoomControl;

    // Event
    property OnStatus: TOnWebViewStatus read FOnStatus write FOnStatus;
    property OnLongClick: TOnNotify read FOnLongClick write FOnLongClick;
    property OnFindResult: TOnWebViewFindResult read FOnFindResult write FOnFindResult;
    property DomStorage: boolean read FDomStorage write SetDomStorage;
    property OnEvaluateJavascriptResult: TOnWebViewEvaluateJavascriptResult
      read FOnEvaluateJavascriptResult write FOnEvaluateJavascriptResult;
    property OnReceivedSslError: TOnWebViewReceivedSslError
      read FOnReceivedSslError write FOnReceivedSslError;


  end;

  jCanvas = class(jControl)
  private
    FInitialized: boolean;

    FPaintShader: JPaintShader;  // new component! by kordal

    FPaintStrokeWidth: single;
    FPaintStyle: TPaintStyle;
    FPaintTextSize: single;
    FPaintRotation: single;
    FPaintColor: TARGBColorBridge;

    //FTypeface: TFontFace; //deprecated

    FFontFace: TFontFace;
    FTextTypeFace: TTextTypeFace;

    procedure SetStrokeWidth(Value: single);
    procedure SetStyle(Value: TPaintStyle);
    procedure SetColor(Value: TARGBColorBridge);
    procedure SetTextSize(Value: single);
    //Procedure SetTypeface          (Value : TFontFace);

    procedure SetPaintShader(Value: jPaintShader);//by kordal

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure InitPaintShader;

    procedure DrawLine(x1, y1, x2, y2: single); overload;
    procedure DrawLine(var _points: TDynArrayOfSingle); overload;

    // LORDMAN 2013-08-13
    procedure DrawPoint(x1, y1: single);
    procedure DrawText(_text: string; x, y: single); overload;

    procedure DrawCircle(_cx: single; _cy: single; _radius: single);
    procedure DrawOval(_left, _top, _right, _bottom: single);
    procedure DrawBackground(_color: integer);
    procedure DrawRect(_left, _top, _right, _bottom: single); overload;
    procedure DrawRoundRect(_left, _top, _right, _bottom, _rx, _ry: single);

    procedure DrawBitmap(bmp: jObject; b, l, r, t: integer); overload;
    procedure DrawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single); overload;
    procedure DrawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single); overload;
    procedure DrawBitmap(bmp: jBitmap; b, l, r, t: integer); overload;
    procedure DrawBitmap(_bitmap: jObject; _width: integer; _height: integer); overload;
    procedure DrawBitmap(_left: single; _top: single; _bitmap: jObject); overload;

    procedure SetDensityScale(_scale: boolean);

    function GetNewPath(var _points: TDynArrayOfSingle): jObject; overload;
    function GetNewPath(_points: array of single): jObject; overload;
    procedure DrawPath(var _points: TDynArrayOfSingle); overload;
    procedure DrawPath(_points: array of single); overload;
    procedure DrawPath(_path: jObject); overload;
    procedure DrawArc(_leftRectF: single; _topRectF: single;
      _rightRectF: single; _bottomRectF: single; _startAngle: single;
      _sweepAngle: single; _useCenter: boolean);

    procedure SetCanvas(_canvas: jObject);
    procedure DrawTextAligned(_text: string; _left, _top, _right, _bottom: single;
      _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);

    function CreateBitmap(_width: integer; _height: integer;
      _backgroundColor: TARGBColorBridge): jObject; overload;
    function CreateBitmap(_width: integer; _height: integer;
      _backgroundColor: integer): jObject; overload; //by ADiV
    function GetBitmap(): jObject;
    procedure SetBitmap(_bitmap: jObject); overload;
    procedure SetBitmap(_bitmap: jObject; _width: integer; _height: integer); overload;

    function GetPaint(): JObject;  // uses jPaintShader

    procedure DrawText(_text: string; _x: single; _y: single;
      _angleDegree: single; _rotateCenter: boolean); overload;
    procedure DrawText(_text: string; _x: single; _y: single;
      _angleDegree: single); overload;
    procedure DrawRect(_P0x: single; _P0y: single; _P1x: single;
      _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single); overload;
    procedure DrawRect(var _box: TDynArrayOfSingle); overload;
    procedure DrawTextMultiLine(_text: string; _left: single; _top: single;
      _right: single; _bottom: single);
    procedure Clear(_color: TARGBColorBridge); overload; //by ADiV
    procedure Clear(_color: DWord); overload;
    function GetJInstance(): jObject;
    procedure SaveBitmapJPG(_fullPathFileName: string);

    //by Tomash
    procedure SetRotation(Value: single);

    //by Kordal
    function GetDensity(): single;
    procedure ClipRect(Left, Top, Right, Bottom: single);
    procedure DrawGrid(Left, Top, Width, Height: single; cellsX, cellsY: integer);
    procedure DrawBitmap(bitMap: jBitmap; srcL, srcT, srcR, srcB: integer;
      dstL, dstT, dstR, dstB: single); overload;
    procedure DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH: integer;
      X, Y, Wh, Ht, rotateDegree: single); overload;
    procedure DrawFrame(bitMap: jObject; X, Y: single; Index, Size: integer;
      scaleFactor, rotateDegree: single); overload;

    function GetTextHeight(_text: string): single;
    function GetTextWidth(_text: string): single;

    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(AValue: TTextTypeFace);

    procedure SetFontAndTextTypeFace(_fontFace: integer; _fontStyle: integer);

    //Property
    property CustomColor: DWord read FCustomColor write FCustomColor;
    property Density: single read GetDensity;

  published
    property PaintShader: JPaintShader read FPaintShader write SetPaintShader;
    // new! //by kordal
    property PaintStrokeWidth: single read FPaintStrokeWidth write SetStrokeWidth;
    property PaintStyle: TPaintStyle read FPaintStyle write setStyle;
    property PaintTextSize: single read FPaintTextSize write setTextSize;
    property PaintColor: TARGBColorBridge read FPaintColor write setColor;

    //property Typeface: TFontFace read FTypeFace write setTypeFace; //deprecated

    property FontFace: TFontFace read FFontFace write SetFontface;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;


  end;

  jView = class(jVisualControl)
  private
    FjCanvas: jCanvas; // Java : jCanvas
    FMouches: TMouches;

    FOnDraw: TOnDraw;

    FOnTouchDown: TOnTouchEvent;
    FOnTouchMove: TOnTouchEvent;
    FOnTouchUp: TOnTouchEvent;
    FFilePath: TFilePath;

    procedure SetColor(Value: TARGBColorBridge);
    procedure SetjCanvas(Value: jCanvas);

  protected
    procedure GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer; X1, Y1, X2, Y2: single);
    procedure GenEvent_OnDraw(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    function GetWidth: integer; override;
    function GetHeight: integer; override;
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure BringToFront;

    procedure ClearLayout();
    procedure UpdateLayout(); override;
    procedure Init; override;
    procedure SaveToFile(fullFileName: string);
    function GetDrawingCache(): jObject;
    function GetImage(): jObject;

    property FilePath: TFilePath read FFilePath write FFilePath;
    procedure SetLayerType(Value: TLayerType);  //by kordal

  published
    property Canvas: jCanvas read FjCanvas write SetjCanvas; // Java : jCanvas
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    // Event - Drawing
    property OnDraw: TOnDraw read FOnDraw write FOnDraw;
    // Event - Touch
    property OnTouchDown: TOnTouchEvent read FOnTouchDown write FOnTouchDown;
    property OnTouchMove: TOnTouchEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchUp: TOnTouchEvent read FOnTouchUp write FOnTouchUp;
  end;

  TImageBtnState = (imUp, imDown);

  jImageBtn = class(jVisualControl)
  private
    FOnDown: TOnNotify; //by ADiV
    FOnUp: TOnNotify;   //by ADiV

    FImageUpName: string;
    FImageDownName: string;
    FImageUpIndex: TImageListIndex;
    FImageDownIndex: TImageListIndex;

    FImageList: jImageList;
    FFilePath: TFilePath;
    FSleepDown: integer;
    FAlpha: integer;

    FAnimationDurationIn: integer;
    FAnimationDurationOut: integer;
    FAnimationMode: TAnimationMode;

    procedure SetImages(Value: jImageList);
    procedure SetColor(Value: TARGBColorBridge);

    procedure SetImageDownByIndex(Value: integer);
    procedure SetImageUpByIndex(Value: integer);

    procedure SetImageUpIndex(Value: TImageListIndex); // by ADiV
    procedure SetImageDownIndex(Value: TImageListIndex); // by ADiV

    procedure SetImageDownByRes(imgResIdentifief: string); //  ../res/drawable
    procedure SetImageUpByRes(imgResIdentifief: string);   //  ../res/drawable

  protected
    procedure SetEnabled(Value: boolean); override;
    procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

    procedure ClearLayout;
    procedure UpdateLayout(); override;

    procedure GenEvent_OnDown(Obj: TObject); // by ADiV
    procedure GenEvent_OnUp(Obj: TObject);

    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;

    procedure BringToFront; // By ADiV

    procedure Init; override;
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetViewParent(Value: jObject); override;
    procedure RemoveFromViewParent; override;
    procedure SetSleepDown(_sleepMiliSeconds: integer);

    procedure SetImageUp(_bmp: jObject);
    procedure SetImageDown(_bmp: jObject);
    procedure SetImageDownScale(Value: single); // by ADiV
    procedure SetAlpha(Value: integer); // by ADiV
    procedure SetSaturation(Value: single); // by ADiV
    procedure SetColorScale(_red, _green, _blue, _alpha: single); // by ADiV
    procedure SetImageState(_imageState: TImageBtnState);
    procedure SetRotation(_angle: integer);

    procedure SetAnimationDurationIn(_animationDurationIn: integer);
    procedure SetAnimationDurationOut(_animationDurationOut: integer);
    procedure SetAnimationMode(_animationMode: TAnimationMode);
    procedure Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
    procedure AnimateRotate(_angleFrom, _angleTo: integer);

  published
    property OnDown: TOnNotify read FOnDown write FOnDown; // by ADiV
    property OnUp: TOnNotify read FOnUp write FOnUp;

    property AnimationDurationIn: integer read FAnimationDurationIn
      write SetAnimationDurationIn;
    property AnimationDurationOut: integer read FAnimationDurationOut
      write SetAnimationDurationOut;
    property AnimationMode: TAnimationMode read FAnimationMode write SetAnimationMode;

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Enabled: boolean read FEnabled write SetEnabled;
    property Images: jImageList read FImageList write SetImages;
    property IndexImageUp: TImageListIndex read FImageUpIndex write SetImageUpIndex;
    // Fix by ADiV
    property IndexImageDown: TImageListIndex read FImageDownIndex
      write SetImageDownIndex;
    // Fix by ADiV

    property ImageUpIdentifier: string read FImageUpName write SetImageUpByRes;
    property ImageDownIdentifier: string read FImageDownName write SetImageDownByRes;
    property SleepDown: integer read FSleepDown write SetSleepDown;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;

    // Event
    property OnClick: TOnNotify read FOnClick write FOnClick;
  end;

  jGLViewEvent = class(jVisualControl)
  private
    // FInitialized : boolean;

    FOnGLCreate: TOnNotify;
    FOnGLChange: TOnGLChange;
    FOnGLDraw: TOnNotify;
    FOnGLDestroy: TOnNotify;
    FOnGLThread: TOnNotify;
    FOnGLPause: TOnNotify;
    FOnGLResume: TOnNotify;

    FMouches: TMouches;

    FOnGLDown: TOnTouchEvent;
    FOnGLMove: TOnTouchEvent;
    FOnGLUp: TOnTouchEvent;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer; X1, Y1, X2, Y2: single);
    procedure GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
    //property Initialized : boolean read FInitialized;
  published
    // Event - Drawing
    property OnGLCreate: TOnNotify read FOnGLCreate write FOnGLCreate;
    property OnGLChange: TOnGLChange read FOnGLChange write FOnGLChange;
    property OnGLDraw: TOnNotify read FOnGLDraw write FOnGLDraw;
    property OnGLDestroy: TOnNotify read FOnGLDestroy write FOnGLDestroy;
    property OnGLThread: TOnNotify read FOnGLThread write FOnGLThread;
    property OnGLPause: TOnNotify read FOnGLPause write FOnGLPause;
    property OnGLResume: TOnNotify read FOnGLResume write FOnGLResume;
    // Event - Touch
    property OnGLDown: TOnTouchEvent read FOnGLDown write FOnGLDown;
    property OnGLMove: TOnTouchEvent read FOnGLMove write FOnGLMove;
    property OnGLUp: TOnTouchEvent read FOnGLUp write FOnGLUp;
  end;

// ----------------------------------------------------------------------------
//  Event Handler  : Java -> Pascal
// ----------------------------------------------------------------------------

// Activity Event
function Java_Event_pAppOnScreenStyle(env: PJNIEnv; this: jobject): JInt;
procedure Java_Event_pAppOnNewIntent(env: PJNIEnv;
  this: jobject; intent: jobject);
procedure Java_Event_pAppOnDestroy(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnPause(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnRestart(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnResume(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnStart(env: PJNIEnv; this: jobject);
//old OnActive
procedure Java_Event_pAppOnStop(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnBackPressed(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnDone(env: PJNIEnv; this: jobject);//By Mongkey
procedure Java_Event_pAppOnGo(env: PJNIEnv; this: jobject);//By Mongkey
procedure Java_Event_pAppOnNext(env: PJNIEnv; this: jobject);//By Mongkey
procedure Java_Event_pAppOnSearch(env: PJNIEnv; this: jobject);//By Mongkey
procedure Java_Event_pAppOnUpdateLayout(env: PJNIEnv; this: jobject);

function Java_Event_pAppOnSpecialKeyDown(env: PJNIEnv;
  this: jobject; keyChar: JChar; keyCode: integer; keyCodeString: JString): jBoolean;

function Java_Event_pAppOnRotate(env: PJNIEnv;
  this: jobject; rotate: integer): integer;
procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
procedure Java_Event_pAppOnActivityResult(env: PJNIEnv;
  this: jobject; requestCode, resultCode: integer; intentData: jObject);

procedure Java_Event_pAppOnCreateOptionsMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject);
procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: jboolean); overload;


procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: boolean); overload; //deprecated..


function Java_Event_pAppOnPrepareOptionsMenuItem(env: PJNIEnv;
  this: jobject; jObjMenu: jObject; jObjMenuItem: jObject; ItemIndex: integer): jBoolean;
function Java_Event_pAppOnPrepareOptionsMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject; menuSize: integer): jBoolean;

//by jmpessoa: support to Context Menu
procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: jboolean); overload;

procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: boolean); overload; //deprecated

procedure Java_Event_pAppOnCreateContextMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject);

procedure Java_Event_pAppOnRequestPermissionResult(env: PJNIEnv;
  this: jobject; requestCode: integer;
  permission: JString; grantResult: integer);

// Control Event
procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject; Obj: TObject);

procedure Java_Event_pOnDown(env: PJNIEnv; this: jobject; Obj: TObject);
procedure Java_Event_pOnUp(env: PJNIEnv; this: jobject; Obj: TObject);

procedure Java_Event_pOnDoubleClick(env: PJNIEnv; this: jobject; Obj: TObject);
procedure Java_Event_pOnClick(env: PJNIEnv; this: jobject; Obj: TObject;
  Value: integer);
procedure Java_Event_pOnLongClick(env: PJNIEnv; this: jobject; Obj: TObject);

//by jmpessoa
procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Checked: jboolean); overload;
procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Checked: boolean); overload; //deprecated
//by ADiV
procedure Java_Event_pOnClickImageItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer); //by ADiV
procedure Java_Event_pOnClickItemTextLeft(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString); //by ADiV
procedure Java_Event_pOnClickItemTextCenter(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString); //by ADiV
procedure Java_Event_pOnClickItemTextRight(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString); //by ADiV

procedure Java_Event_pOnClickCaptionItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
procedure Java_Event_pOnListViewLongClickCaptionItem(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString);

function Java_Event_pOnListViewDrawItemCaptionColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JInt;
function Java_Event_pOnListViewDrawItemCustomFont(env: PJNIEnv;
  this: JObject; Sender: TObject; position: integer; Caption: jString): jString;

function Java_Event_pOnListViewDrawItemBackgroundColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer): JInt; // by ADiV
function Java_Event_pOnListViewDrawItemWidgetTextColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JInt;
function Java_Event_pOnListViewDrawItemWidgetText(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JString;
function Java_Event_pOnListViewDrawItemBitmap(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JObject;
procedure Java_Event_pOnWidgeItemLostFocus(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
procedure Java_Event_pOnListViewScrollStateChanged(env: PJNIEnv;
  this: jobject; Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer;
  totalItemCount: integer; lastItemReached: JBoolean);
function Java_Event_pOnListViewDrawItemWidgetImage(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JObject;

procedure Java_Event_pOnBeforeDispatchDraw(env: PJNIEnv; this: jobject;
  Obj: TObject; canvas: JObject; tag: integer);
procedure Java_Event_pOnAfterDispatchDraw(env: PJNIEnv; this: jobject;
  Obj: TObject; canvas: JObject; tag: integer);

procedure Java_Event_pOnLayouting(env: PJNIEnv; this: jobject;
  Obj: TObject; changed: JBoolean);

procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject; Obj: TObject;
  txt: JString; Count: integer);
procedure Java_Event_pOnChanged(env: PJNIEnv; this: jobject;
  Obj: TObject; txt: JString; Count: integer);

procedure Java_Event_pOnEnter(env: PJNIEnv;
  this: jobject; Obj: TObject);
procedure Java_Event_pOnBackPressed(env: PJNIEnv;
  this: jobject; Obj: TObject); // by ADiV
procedure Java_Event_pOnDone(env: PJNIEnv;
  this: jobject; Obj: TObject); // by Mongkey
procedure Java_Event_pOnGo(env: PJNIEnv;
  this: jobject; Obj: TObject); // by Mongkey
procedure Java_Event_pOnNext(env: PJNIEnv;
  this: jobject; Obj: TObject); // by Mongkey
procedure Java_Event_pOnSearch(env: PJNIEnv;
  this: jobject; Obj: TObject); // by Mongkey

procedure Java_Event_pOnTimer(env: PJNIEnv;
  this: jobject; Obj: TObject);
procedure Java_Event_pOnTouch(env: PJNIEnv;
  this: jobject; Obj: TObject; act, cnt: integer; x1, y1, x2, y2: single);

// Control GLSurfaceView.Renderer Event
procedure Java_Event_pOnGLRenderer(env: PJNIEnv;
  this: jobject; Obj: TObject; EventType, w, h: integer);
procedure Java_Event_pOnGLRenderer1(env: PJNIEnv;
  this: jobject; Obj: TObject; EventType, w, h: integer);
procedure Java_Event_pOnGLRenderer2(env: PJNIEnv;
  this: jobject; Obj: TObject; EventType, w, h: integer);

// WebView Event
function Java_Event_pOnWebViewStatus(env: PJNIEnv;
  this: jobject; WebView: TObject; EventType: integer; URL: jString): integer;
//LMB:
procedure Java_Event_pOnWebViewFindResultReceived(env: PJNIEnv;
  this: jobject; webview: TObject; findIndex, findCount: integer);

//by segator
procedure Java_Event_pOnWebViewEvaluateJavascriptResult(env: PJNIEnv;
  this: JObject; Sender: TObject; Data: jString);

function Java_Event_pOnWebViewReceivedSslError(env: PJNIEnv;
  this: JObject; Sender: TObject; error: jString; primaryError: integer): jBoolean;

// AsyncTask Event & Task
// procedure Java_Event_pOnAsyncEvent(env: PJNIEnv; this: jobject; Obj : TObject; EventType,Progress: integer);
function Java_Event_pOnAsyncEventDoInBackground(env: PJNIEnv;
  this: jobject; Obj: TObject; Progress: integer): JBoolean;

function Java_Event_pOnAsyncEventProgressUpdate(env: PJNIEnv;
  this: jobject; Obj: TObject; Progress: integer): JInt;
function Java_Event_pOnAsyncEventPreExecute(env: PJNIEnv; this: jobject;
  Obj: TObject): JInt;
procedure Java_Event_pOnAsyncEventPostExecute(env: PJNIEnv;
  this: jobject; Obj: TObject; Progress: integer);

procedure Java_Event_pAppOnViewClick(env: PJNIEnv; this: jobject;
  jObjView: jObject; id: integer);
procedure Java_Event_pAppOnListItemClick(env: PJNIEnv;
  this: jobject; jObjAdapterView: jObject; jObjView: jObject; position: integer;
  id: integer);

procedure Java_Event_pOnFlingGestureDetected(env: PJNIEnv; this: jobject;
  Obj: TObject; direction: integer);
procedure Java_Event_pOnPinchZoomGestureDetected(env: PJNIEnv;
  this: jobject; Obj: TObject; scaleFactor: single; state: integer);

procedure Java_Event_pOnHttpClientContentResult(env: PJNIEnv;
  this: jobject; Obj: TObject; content: JByteArray);
procedure Java_Event_pOnHttpClientCodeResult(env: PJNIEnv; this: jobject;
  Obj: TObject; code: integer);
procedure Java_Event_pOnHttpClientUploadFinished(env: PJNIEnv;
  this: jobject; Obj: TObject; code: integer; response: JString; fullFileName: JString);
procedure Java_Event_pOnHttpClientUploadProgress(env: PJNIEnv;
  this: jobject; Obj: TObject; progress: int64);


procedure Java_Event_pOnLostFocus(env: PJNIEnv; this: jobject;
  Obj: TObject; content: JString);
procedure Java_Event_pOnFocus(env: PJNIEnv; this: jobject; Obj: TObject;
  content: JString);

procedure Java_Event_pOnScrollViewChanged(env: PJNIEnv; this: jobject;
  Obj: TObject; currenthorizontal: integer;
  currentVertical:
  integer;
  previousHorizontal: integer;
  previousVertical:
  integer;
  onPosition: integer; scrolldiff: integer);


procedure Java_Event_pOnHorScrollViewChanged(env: PJNIEnv; this: jobject;
  Obj: TObject; currenthorizontal: integer;
  currentVertical:
  integer;
  previousHorizontal: integer;
  previousVertical:
  integer;
  onPosition: integer; scrolldiff: integer);

procedure Java_Event_pOnScrollViewInnerItemClick(env: PJNIEnv;
  this: JObject; Sender: TObject; itemId: integer);
procedure Java_Event_pOnScrollViewInnerItemLongClick(env: PJNIEnv;
  this: JObject; Sender: TObject; index: integer; itemId: integer);

procedure Java_Event_pOnHorScrollViewInnerItemClick(env: PJNIEnv;
  this: JObject; Sender: TObject; itemId: integer);
procedure Java_Event_pOnHorScrollViewInnerItemLongClick(env: PJNIEnv;
  this: JObject; Sender: TObject; index: integer; itemId: integer);

procedure Java_Event_pOnClickDBListItem(env: PJNIEnv; this: jobject;
  Obj: TObject; position: integer; Caption: JString);
procedure Java_Event_pOnLongClickDBListItem(env: PJNIEnv; this: jobject;
  Obj: TObject; position: integer; Caption: JString);
procedure Java_Event_pOnSqliteDataAccessAsyncPostExecute(env: PJNIEnv;
  this: JObject; Sender: TObject; Count: integer; msgResult: jString);
procedure Java_Event_pOnImageViewPopupItemSelected(env: PJNIEnv;
  this: JObject; Sender: TObject; Caption: jString);


procedure Java_Event_pEditTextOnActionIconTouchUp(env: PJNIEnv;
  this: JObject; Sender: TObject; textContent: jString);
procedure Java_Event_pEditTextOnActionIconTouchDown(env: PJNIEnv;
  this: JObject; Sender: TObject; textContent: jString);

//thanks to WayneSherman
procedure Java_Event_pOnRunOnUiThread(env: PJNIEnv; this: JObject;
  Sender: TObject; tag: integer);


//Asset Function (P : Pascal Native)
function Asset_SaveToFile(srcFile, outFile: string): boolean;
(**Function  Asset_SaveToFileP(srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;**)
//droped And_lib_Unzip.pas

implementation


uses
  {And_log_h,}//for debug
  autocompletetextview, viewflipper, comboedittext, radiogroup;

//helper
function GetPascalString(env: PJNIEnv; jstr: JString): string;
var
  _jBoolean: JBoolean;
begin
  Result := '';
  if jstr <> nil then
  begin
    _jBoolean := JNI_False;
    Result := string(env^.GetStringUTFChars(env, jstr, @_jBoolean));
  end;
end;

//-----------------------------------------------------------------------------
// Asset
//-----------------------------------------------------------------------------

// srcFile  'test.txt'
// outFile  '/data/data/com/kredix/files/test.txt'
function Asset_SaveToFile(srcFile, outFile: string): boolean;
begin
  Result := False;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  Result := jni_func_tt_out_z(gApp.Jni.jEnv, gApp.Jni.jThis, 'assetSaveToFile',
    srcFile, outFile);

  Result := FileExists(outFile);
end;

// PkgName  '/data/app/com/kredix-1.apk'
// srcFile  'assets/test.txt'
// outFile  '/data/data/com/kredix/files/test.txt'
(**      droped And_lib_Unzip.pas
Function Asset_SaveToFileP(srcFile, outFile : string; SkipExists : Boolean = False) : Boolean;
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
**)

function IntToWebViewStatus(EventType: integer): TWebViewStatus;
begin
  case EventType of
    cjWebView_OnBefore: Result := wvOnBefore;
    cjWebView_OnFinish: Result := wvOnFinish;
    cjWebView_OnError: Result := wvOnError;
    else
      Result := wvOnUnknown;
  end;
end;

//------------------------------------------------------------------------------
//  Activity Event
//------------------------------------------------------------------------------

function Java_Event_pAppOnScreenStyle(env: PJNIEnv; this: jobject): JInt;
begin
  Result := 1;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  case gApp.Screen.Style of
    ssSensor: Result := 0;
    ssPortrait: Result := 1;
    ssLandScape: Result := 2;
  end;
end;

procedure Java_Event_pAppOnNewIntent(env: PJNIEnv; this: jObject; intent: jobject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnNewIntent) then Form.OnNewIntent(Form, intent);
end;

// The activity is about to be destroyed.
procedure Java_Event_pAppOnDestroy(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
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
procedure Java_Event_pAppOnPause(env: PJNIEnv; this: jobject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnActivityPause) then Form.OnActivityPause(Form);
end;


procedure Java_Event_pAppOnRestart(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
end;

{
Resume: The activity is in the foreground of the screen and has user focus.
(This state is also sometimes referred to as "running".)
}
procedure Java_Event_pAppOnResume(env: PJNIEnv; this: jobject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnActivityResume) then Form.OnActivityResume(Form);
end;

//The activity is about to become visible.....
procedure Java_Event_pAppOnStart(env: PJNIEnv; this: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnActivityStart) then Form.OnActivityStart(Form);
end;

{
Stopped
The activity is completely obscured by another activity (the activity is now in the "background").
A stopped activity is also still alive (the Activity object is retained in memory, it maintains
all state and member information, but is not attached to the window manager).
However, it is no longer visible to the user and it can be killed by the system when memory is needed elsewhere.
}

procedure Java_Event_pAppOnStop(env: PJNIEnv; this: jobject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnActivityStop) then Form.OnActivityStop(Form);
end;

//Event : OnBackPressed -> Form OnClose
procedure Java_Event_pAppOnBackPressed(env: PJNIEnv; this: jobject);
var
  Form: jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  if Assigned(Form.OnBackButton) then
  begin
    // Form.ShowMessage('Back Pressed: OnBackButton: '+ IntTostr(gApp.TopIndex));
    Form.OnBackButton(Form);
  end;

  // Event : OnCloseQuery
  if Assigned(Form.OnCloseQuery) then
  begin
    // Form.ShowMessage('Back Pressed: OnCloseQuery: '+ IntTostr(gApp.TopIndex));
    canClose := True;
    Form.OnCloseQuery(Form, canClose);
    if canClose = False then Exit;
  end;

  Form.Close;
end;

procedure Java_Event_pAppOnDone(env: PJNIEnv; this: jobject);
var
  Form: jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;
end;

procedure Java_Event_pAppOnGo(env: PJNIEnv; this: jobject);
var
  Form: jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;
end;

procedure Java_Event_pAppOnNext(env: PJNIEnv; this: jobject);
var
  Form: jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;
end;

procedure Java_Event_pAppOnSearch(env: PJNIEnv; this: jobject);
var
  Form: jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;
end;

// Event : OnUpdateLayout -> Form OnUpdateLayout
procedure Java_Event_pAppOnUpdateLayout(env: PJNIEnv; this: jobject);
var
  Form: jForm; //jForm;  //gdx change
begin

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  // Update width and height when rotating
  gApp.Screen.WH := jSysInfo_ScreenWH(env, this);
  Form.ScreenWH := gApp.Screen.WH;
  Form.Width := gApp.Screen.WH.Width;
  Form.Height := gApp.Screen.WH.Height;

  if Assigned(Form.OnLayoutDraw) then Form.OnLayoutDraw(Form);

  Form.UpdateLayout;

end;

// Event : OnRotate -> Form OnRotate
function Java_Event_pAppOnRotate(env: PJNIEnv; this: jobject;
  rotate: integer): integer;
var                   {rotate=1 --> device vertical/default position ; 2: device horizontal position}
  Form: jForm;
  rotOrientation: TScreenStyle;
begin

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  Result := rotate;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  // Update width and height when rotating
  gApp.Screen.WH := jSysInfo_ScreenWH(env, this);
  Form.ScreenWH := gApp.Screen.WH;

  if rotate = 1 then
    rotOrientation := ssPortrait
  else if rotate = 2 then
    rotOrientation := ssLandscape
  else if rotate = 4 then rotOrientation := ssSensor
  else
    rotOrientation := ssUnknown;

  gApp.Orientation := rotOrientation;
  Form.ScreenStyle := rotOrientation;

  if Assigned(Form.OnRotate) then Form.OnRotate(Form, rotOrientation);

end;

procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
end;

procedure Java_Event_pAppOnActivityResult(env: PJNIEnv; this: jobject;
  requestCode, resultCode: integer;
  intentData: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnActivityResult) then
    Form.OnActivityResult(Form, requestCode, TAndroidResult(resultCode), intentData);
end;


procedure Java_Event_pAppOnViewClick(env: PJNIEnv; this: jobject;
  jObjView: jObject; id: integer);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnViewClick) then Form.GenEvent_OnViewClick(jObjView, id);
end;

procedure Java_Event_pAppOnListItemClick(env: PJNIEnv; this: jobject;
  jObjAdapterView: jObject; jObjView: jObject; position: integer; id: integer);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnListItemClick) then
    Form.GenEvent_OnListItemClick(jObjAdapterView, jObjView, position, id);
end;

//by jmpessoa: support to Option Menu
procedure Java_Event_pAppOnCreateOptionsMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnCreateOptionMenu) then Form.OnCreateOptionMenu(Form, jObjMenu);
end;

function Java_Event_pAppOnPrepareOptionsMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject; menuSize: integer): jBoolean;
var
  Form: jForm;
  prepareItems: boolean;
begin
  Result := 0;

  prepareItems := False;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  if Assigned(Form.OnPrepareOptionsMenu) then
    Form.OnPrepareOptionsMenu(Form, jObjMenu, menuSize, prepareItems);

  Result := JBool(prepareItems);
end;

function Java_Event_pAppOnPrepareOptionsMenuItem(env: PJNIEnv;
  this: jobject; jObjMenu: jObject; jObjMenuItem: jObject; ItemIndex: integer): jBoolean;
var
  Form: jForm;
  prepareMoreItems: boolean;
begin
  Result := 0;

  prepareMoreItems := True;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnPrepareOptionsMenuItem) then
    Form.OnPrepareOptionsMenuItem(Form, jObjMenu, jObjMenuItem, ItemIndex,
      prepareMoreItems);
  Result := JBool(prepareMoreItems);
end;

function Java_Event_pAppOnSpecialKeyDown(env: PJNIEnv; this: jobject;
  keyChar: JChar; keyCode: integer; keyCodeString: JString): jBoolean;
var
  Form: jForm;
  mute: boolean;
  pasStr: string;
  _jBoolean: JBoolean;
begin
  Result := 0;

  mute := False;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  pasStr := '';
  if keyCodeString <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr := string(env^.GetStringUTFChars(Env, keyCodeString, @_jBoolean));
  end;

  if Assigned(Form.OnSpecialKeyDown) then
    Form.OnSpecialKeyDown(Form, char(keyChar), keyCode, pasStr, mute);
  Result := JBool(mute);

end;

procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject;
  jObjMenuItem: jObject; itemID: integer;
  itemCaption: JString; Checked: boolean);//deprecated..
begin
  Java_Event_pAppOnClickOptionMenuItem(env, this, jObjMenuItem,
    itemID, itemCaption, JBoolean(Checked));
end;

procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject;
  jObjMenuItem: jObject; itemID: integer;
  itemCaption: JString; Checked: jboolean);
var
  Form: jForm;
  pasStr: string;
  _jBoolean: JBoolean;
begin

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;

  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);

  if not Assigned(Form) then Exit;

  pasStr := '';
  if itemCaption <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr := string(env^.GetStringUTFChars(Env, itemCaption, @_jBoolean));
  end;

  if Assigned(Form.OnClickOptionMenuItem) then
    Form.OnClickOptionMenuItem(Form, jObjMenuItem, itemID, pasStr, boolean(Checked));

end;


//by jmpessoa: support to Context Menu
procedure Java_Event_pAppOnCreateContextMenu(env: PJNIEnv; this: jobject;
  jObjMenu: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  if Assigned(Form.OnCreateContextMenu) then Form.OnCreateContextMenu(Form, jObjMenu);
end;


procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: boolean);//deprecated
begin
  Java_Event_pAppOnClickContextMenuItem(env, this, jObjMenuItem, itemID,
    itemCaption, JBoolean(Checked));
end;

//by jmpessoa: support to Context Menu
procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv;
  this: jobject; jObjMenuItem: jObject;
  itemID: integer;
  itemCaption: JString; Checked: jboolean);
var
  Form: jForm;
  pasStr: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  pasStr := '';
  if itemCaption <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr := string(env^.GetStringUTFChars(Env, itemCaption, @_jBoolean));
  end;

  if Assigned(Form.OnClickContextMenuItem) then
    Form.OnClickContextMenuItem(Form, jObjMenuItem, itemID, pasStr, boolean(Checked));
end;

procedure Java_Event_pAppOnRequestPermissionResult(env: PJNIEnv;
  this: jobject; requestCode: integer;
  permission: JString; grantResult: integer);
var
  Form: jForm;
  pasStr: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if gApp.TopIndex < 0 then Exit;
  Form := jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;

  pasStr := '';
  if permission <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr := string(env^.GetStringUTFChars(Env, permission, @_jBoolean));
  end;

  if Assigned(Form.OnRequestPermissionResult) then
    Form.OnRequestPermissionResult(Form, requestCode, pasStr,
      TManifestPermissionResult(grantResult));

end;

//------------------------------------------------------------------------------
//  Control Event
//------------------------------------------------------------------------------

procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject;
  Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jView then
  begin
    jView(Obj).GenEvent_OnDraw(Obj);
  end;
end;

procedure Java_Event_pOnDown(env: PJNIEnv; this: jobject; Obj: TObject);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jImageBtn then
  begin
    jImageBtn(Obj).GenEvent_OnDown(Obj);
    exit;
  end
  else
  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnDown(Obj);
    exit;
  end;

end;

procedure Java_Event_pOnUp(env: PJNIEnv; this: jobject; Obj: TObject);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jImageBtn then
  begin
    jImageBtn(Obj).GenEvent_OnUp(Obj);
    exit;
  end
  else
  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnUp(Obj);
    exit;
  end;

end;

procedure Java_Event_pOnDoubleClick(env: PJNIEnv; this: jobject; Obj: TObject);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnDoubleClick(Obj);
    exit;
  end;

end;

procedure Java_Event_pOnClick(env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
  //------------------------------------------------------

  if not (Assigned(Obj)) then Exit;
  if Obj is jForm then
  begin
    jForm(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jTextView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jButton then
  begin
    jButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jCheckBox then
  begin
    jCheckBox(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jRadioButton then
  begin
    jRadioButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jDialogYN then
  begin
    jDialogYN(Obj).GenEvent_OnClick(Obj, Value);
    Exit;
  end;
  if Obj is jImageBtn then
  begin
    jImageBtn(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jImageView then
  begin
    jImageView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
end;

procedure Java_Event_pOnLongClick(env: PJNIEnv; this: jobject; Obj: TObject);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;
  //------------------------------------------------------

  if not (Assigned(Obj)) then Exit;

  if Obj is jWebView then  //need fix here ... handling long clicked!
  begin
    jWebView(Obj).GenEvent_OnLongClick(Obj);
    Exit;
  end;

  if Obj is jTextView then
  begin
    jTextView(Obj).GenEvent_OnLongClick(Obj);
    Exit;
  end;

  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnLongClick(Obj);
    Exit;
  end;

end;

procedure Java_Event_pOnRunOnUiThread(env: PJNIEnv; this: JObject;
  Sender: TObject; tag: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jForm then
  begin
    jForm(Sender).GenEvent_OnRunOnUiThread(Sender, tag);
  end;
end;

procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Checked: boolean);//deprecated
begin
  Java_Event_pOnClickWidgetItem(env, this, Obj, index, JBoolean(Checked));
end;

procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Checked: jboolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListView then
  begin
    jListVIew(Obj).GenEvent_OnClickWidgetItem(Obj, index, boolean(Checked));
    Exit;
  end;
end;

// by ADiV
procedure Java_Event_pOnClickImageItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListView then
  begin
    jListVIew(Obj).GenEvent_OnClickImageItem(Obj, index);
    Exit;
  end;
end;

procedure Java_Event_pOnBeforeDispatchDraw(env: PJNIEnv; this: jobject;
  Obj: TObject; canvas: JObject; tag: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListView then
  begin
    jListVIew(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jButton then
  begin
    jButton(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jAutoTextView then
  begin
    jAutoTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
  end;
end;

procedure Java_Event_pOnAfterDispatchDraw(env: PJNIEnv; this: jobject;
  Obj: TObject; canvas: JObject; tag: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListView then
  begin
    jListVIew(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jTextView(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jButton then
  begin
    jButton(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jAutoTextView then
  begin
    jAutoTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
  end;
end;

procedure Java_Event_pOnLayouting(env: PJNIEnv; this: jobject;
  Obj: TObject; changed: JBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jTextView then
  begin
    jTextView(Obj).GenEvent_OnOnLayouting(Obj, boolean(changed));
    Exit;
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnOnLayouting(Obj, boolean(changed));
    Exit;
  end;
end;

procedure Java_Event_pOnClickCaptionItem(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnClickCaptionItem(Obj, index, pasCaption);
  end;
end;

// by ADiV
procedure Java_Event_pOnClickItemTextLeft(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnClickTextLeft(Obj, index, pasCaption);
  end;
end;

// by ADiV
procedure Java_Event_pOnClickItemTextCenter(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnClickTextCenter(Obj, index, pasCaption);
  end;
end;

// by ADiV
procedure Java_Event_pOnClickItemTextRight(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnClickTextRight(Obj, index, pasCaption);
  end;
end;

//...
procedure Java_Event_pOnWidgeItemLostFocus(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnWidgeItemLostFocus(Obj, index, pasCaption);
  end;
end;

function Java_Event_pOnListViewDrawItemCaptionColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JInt;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outColor: dword;
begin
  Result := 0;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outColor := 0;
  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnDrawItemCaptionColor(Obj, index, pasCaption, outColor);
  end;
  Result := JInt(outColor);
end;

function Java_Event_pOnListViewDrawItemCustomFont(env: PJNIEnv; this: JObject;
  Sender: TObject; position: integer; Caption: jString): jString;
var
  outReturnCustomFontname: string;
begin
  Result := nil;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outReturnCustomFontname := '';
  if Sender is jListView then
  begin
    jListView(Sender).GenEvent_OnListViewDrawItemCustomFont(
      Sender, position, GetPascalString(env, Caption), outReturnCustomFontname);
  end;
  Result := Get_jString(outReturnCustomFontname);
end;

function Java_Event_pOnListViewDrawItemWidgetTextColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JInt;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outColor: dword;
begin
  Result := 0;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outColor := 0;
  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnDrawItemWidgetTextColor(Obj, index, pasCaption, outColor);
  end;
  Result := JInt(outColor);
end;

function Java_Event_pOnListViewDrawItemWidgetText(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JString;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outText: string;
begin
  Result := nil;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outText := '';
  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnDrawItemWidgetText(Obj, index, pasCaption, outText);
  end;
  Result := Get_jString(outText);
end;

//by ADiV
function Java_Event_pOnListViewDrawItemBackgroundColor(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer): JInt;
var
  outColor: dword;
begin
  Result := 0;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outColor := 0;
  if Obj is jListVIew then
  begin
    jListVIew(Obj).GenEvent_OnDrawItemBackgroundColor(Obj, index, outColor);
  end;
  Result := outColor;
end;

function Java_Event_pOnListViewDrawItemBitmap(env: PJNIEnv; this: jobject;
  Obj: TObject; index: integer; Caption: JString): JObject;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outBitmap: JObject;
begin
  Result := nil;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outBitmap := nil;
  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnDrawItemBitmap(Obj, index, pasCaption, outBitmap);
  end;
  Result := outBitmap;
end;

function Java_Event_pOnListViewDrawItemWidgetImage(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString): JObject;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outBitmap: JObject;
begin
  Result := nil;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outBitmap := nil;
  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnDrawItemWidgetBitmap(Obj, index, pasCaption, outBitmap);
  end;
  Result := outBitmap;
end;

procedure Java_Event_pOnListViewScrollStateChanged(env: PJNIEnv;
  this: jobject; Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer;
  totalItemCount: integer; lastItemReached: JBoolean);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    jListVIew(Obj).GenEvent_OnScrollStateChanged(Obj, firstVisibleItem,
      visibleItemCount, totalItemCount, boolean(lastItemReached));
  end;
end;

procedure Java_Event_pOnListViewLongClickCaptionItem(env: PJNIEnv;
  this: jobject; Obj: TObject; index: integer; Caption: JString);
var
  pasCaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jListVIew then
  begin
    pasCaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pasCaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jListVIew(Obj).GenEvent_OnLongClickCaptionItem(Obj, index, pasCaption);
  end;
end;

procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject; Obj: TObject;
  txt: JString; Count: integer);
var
  pasTxt: string;
  _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  pasTxt := '';
  if txt <> nil then
  begin
    _jBoolean := JNI_False;
    pasTxt := string(env^.GetStringUTFChars(Env, txt, @_jBoolean));
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnChange(Obj, pasTxt, Count);
  end;
end;

procedure Java_Event_pOnChanged(env: PJNIEnv; this: jobject; Obj: TObject;
  txt: JString; Count: integer);
var
  pasTxt: string;
  _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  pasTxt := '';
  if txt <> nil then
  begin
    _jBoolean := JNI_False;
    pasTxt := string(env^.GetStringUTFChars(Env, txt, @_jBoolean));
  end;
  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnChanged(Obj, pasTxt, Count);
  end;
end;

// LORDMAN
procedure Java_Event_pOnEnter(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnEnter(Obj);
    Exit;
  end;

  if Obj is jComboEditText then
  begin
    jComboEditText(Obj).GenEvent_OnEnter(Obj);
    Exit;
  end;

  if Obj is jAutoTextView then
  begin
    jAutoTextView(Obj).GenEvent_OnEnter(Obj);
    Exit;
  end;

end;

// by ADiV
procedure Java_Event_pOnBackPressed(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnBackPressed(Obj);
    Exit;
  end;

  //by Tomash
  if Obj is jDialogProgress then
  begin
    with jDialogProgress(Obj) do if Assigned(FOnBackPressed) then FOnBackPressed(Obj);
    Exit;
  end;

end;

procedure Java_Event_pOnDone(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnDone(Obj);
    Exit;
  end;

  //by Tomash
  if Obj is jDialogProgress then
  begin
    with jDialogProgress(Obj) do if Assigned(FOnDone) then FOnDone(Obj);
    Exit;
  end;

end;

procedure Java_Event_pOnGo(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnGo(Obj);
    Exit;
  end;

  //by Tomash
  if Obj is jDialogProgress then
  begin
    with jDialogProgress(Obj) do if Assigned(FOnGo) then FOnGo(Obj);
    Exit;
  end;
end;

procedure Java_Event_pOnNext(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnNext(Obj);
    Exit;
  end;

  //by Tomash
  if Obj is jDialogProgress then
  begin
    with jDialogProgress(Obj) do if Assigned(FOnNext) then FOnNext(Obj);
    Exit;
  end;
end;

procedure Java_Event_pOnSearch(env: PJNIEnv; this: jobject; Obj: TObject);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    jEditText(Obj).GenEvent_OnSearch(Obj);
    Exit;
  end;

  //by Tomash
  if Obj is jDialogProgress then
  begin
    with jDialogProgress(Obj) do if Assigned(FOnSearch) then FOnSearch(Obj);
    Exit;
  end;
end;

procedure Java_Event_pOnTimer(env: PJNIEnv; this: jobject; Obj: TObject);
var
  Timer: jTimer;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if App_IsLock then Exit;

  if not (Assigned(Obj)) then Exit;
  if not (Obj is jTimer) then Exit;

  Timer := jTimer(Obj);

  if not (Timer.Enabled) then Exit;

  if Timer.jParent.FormState = fsFormClose then Exit;

  if Assigned(Timer.OnTimer) then Timer.OnTimer(Timer);

end;

procedure Java_Event_pOnTouch(env: PJNIEnv; this: jobject;
  Obj: TObject;
  act, cnt: integer; x1, y1, x2, y2: single);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent then
  begin
    jGLViewEvent(Obj).GenEvent_OnTouch(Obj, act, cnt, x1, y1, x2, y2);
    Exit;
  end;
  if Obj is jView then
  begin
    jView(Obj).GenEvent_OnTouch(Obj, act, cnt, x1, y1, x2, y2);
    Exit;
  end;
  if Obj is jImageView then
  begin
    jImageView(Obj).GenEvent_OnTouch(Obj, act, cnt, x1, y1, x2, y2);
    Exit;
  end;
end;

procedure Java_Event_pOnGLRenderer(env: PJNIEnv; this: jobject;
  Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent then
  begin
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
  end;
end;

procedure Java_Event_pOnGLRenderer1(env: PJNIEnv; this: jobject;
  Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;


  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent then
  begin
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
  end;
end;

procedure Java_Event_pOnGLRenderer2(env: PJNIEnv; this: jobject;
  Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent then
  begin
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
  end;
end;

function Java_Event_pOnWebViewStatus(env: PJNIEnv; this: jobject;
  webview: TObject;
  eventtype: integer;
  URL: jString): integer;
var
  pasWebView: jWebView;
  pasURL: string;
  pasCanNavi: boolean;
  _jBoolean: jBoolean;
begin
  Result := 0;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  Result := cjWebView_Act_Continue;
  pasWebView := jWebView(webview);
  if not Assigned(pasWebView) then Exit;
  if not Assigned(pasWebView.OnStatus) then Exit;

  pasURL := '';
  if URL <> nil then
  begin
    _jBoolean := JNI_False;
    pasURL := string(env^.GetStringUTFChars(Env, URL, @_jBoolean));
  end;

  pasCanNavi := True;
  pasWebView.OnStatus(pasWebView, IntToWebViewStatus(EventType), pasURL, pasCanNavi);
  if not (pasCanNavi) then Result := cjWebView_Act_Break;

end;

//LMB:
procedure Java_Event_pOnWebViewFindResultReceived(env: PJNIEnv;
  this: jobject; webview: TObject; findIndex, findCount: integer);
var
  pasWebView: jWebView;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  pasWebView := jWebView(webview);
  if not Assigned(pasWebView) then Exit;
  if not Assigned(pasWebView.OnFindResult) then Exit;
  pasWebView.OnFindResult(pasWebView, findIndex, findCount);
end;

//segator
procedure Java_Event_pOnWebViewEvaluateJavascriptResult(env: PJNIEnv;
  this: JObject; Sender: TObject; Data: jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jWebView then
  begin
    jWebView(Sender).GenEvent_OnEvaluateJavascriptResult(
      Sender, GetPascalString(env, Data));
  end;
end;

function Java_Event_pOnWebViewReceivedSslError(env: PJNIEnv; this: JObject;
  Sender: TObject; error: jString; primaryError: integer): jBoolean;
var
  outReturn: boolean;
begin
  Result := 0;

  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  outReturn := False;
  if Sender is jWebView then
  begin
    jWebView(Sender).GenEvent_OnWebViewReceivedSslError(
      Sender, GetPascalString(env, error), primaryError, outReturn);
  end;
  Result := JBool(outReturn);
end;

function Java_Event_pOnAsyncEventDoInBackground(env: PJNIEnv;
  this: jobject; Obj: TObject; Progress: integer): JBoolean;
var
  doing: boolean;
begin
  Result := 0;

  doing := True;  //doing!
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
    jAsyncTask(Obj).AsyncTaskState := atsInBackground;
    jAsyncTask(Obj).GenEvent_OnAsyncEventDoInBackground(Obj, Progress, doing);
    Result := JBool(doing);
  end;
end;

function Java_Event_pOnAsyncEventProgressUpdate(env: PJNIEnv;
  this: jobject; Obj: TObject; Progress: integer): JInt;
var
  progressUpdate: integer;
begin
  Result := 0;

  progressUpdate := Progress + 1;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
    jAsyncTask(Obj).AsyncTaskState := atsProgress;
    jAsyncTask(Obj).GenEvent_OnAsyncEventProgressUpdate(Obj, Progress, progressUpdate);
    Result := progressUpdate;
  end;
end;

function Java_Event_pOnAsyncEventPreExecute(env: PJNIEnv; this: jobject;
  Obj: TObject): JInt;
var
  startProgress: integer;
begin
  Result := 0;

  startProgress := 0;
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
    jAsyncTask(Obj).AsyncTaskState := atsBefore;
    jAsyncTask(Obj).GenEvent_OnAsyncEventPreExecute(Obj, startProgress);
    Result := startProgress;
  end;
end;

procedure Java_Event_pOnAsyncEventPostExecute(env: PJNIEnv; this: jobject;
  Obj: TObject; Progress: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
    jAsyncTask(Obj).AsyncTaskState := atsPost;
    jAsyncTask(Obj).GenEvent_OnAsyncEventPostExecute(Obj, Progress);
  end;
end;

procedure Java_Event_pOnHttpClientContentResult(env: PJNIEnv;
  this: jobject; Obj: TObject; content: JByteArray);
var
  sizeArray: integer;
  arrayResult: TDynArrayOfJByte;
  pascontent: rawbytestring;
  i: integer;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  arrayResult := nil;

  if Obj is jHttpClient then
  begin
    pascontent := '';
    if content <> nil then
    begin
      sizeArray := env^.GetArrayLength(env, content);
      SetLength(arrayResult, sizeArray);
      env^.GetByteArrayRegion(env, content, 0, sizeArray, @arrayResult[0]);
      SetLength(pascontent, sizeArray);
      for i := 1 to sizeArray do pascontent[i] := Chr(arrayResult[i - 1]);
    end;
    jHttpClient(Obj).GenEvent_OnHttpClientContentResult(Obj, pascontent);
  end;

end;

procedure Java_Event_pOnHttpClientUploadProgress(env: PJNIEnv;
  this: jobject; Obj: TObject; progress: int64);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jHttpClient then
  begin
    jHttpClient(Obj).GenEvent_OnHttpClientUploadProgress(Obj, progress);
  end;
end;

procedure Java_Event_pOnHttpClientUploadFinished(env: PJNIEnv;
  this: jobject; Obj: TObject; code: integer;
  response: JString; fullFileName: JString);
var
  pasfullFileName: string;
  pasResponse: string;
  _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jHttpClient then
  begin
    pasfullFileName := '';
    pasResponse := '';
    if fullFileName <> nil then
    begin
      _jBoolean := JNI_False;
      pasfullFileName := string(env^.GetStringUTFChars(Env, fullFileName, @_jBoolean));
    end;
    if response <> nil then
    begin
      _jBoolean := JNI_False;
      pasResponse := string(env^.GetStringUTFChars(Env, response, @_jBoolean));
    end;
    jHttpClient(Obj).GenEvent_OnHttpClientUploadFinished(Obj, code,
      pasResponse, pasfullFileName);
  end;
end;

procedure Java_Event_pOnFocus(env: PJNIEnv; this: jobject; Obj: TObject;
  content: JString);
var
  pascontent: string;
  _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent := string(env^.GetStringUTFChars(Env, content, @_jBoolean));
    end;
    jEditText(Obj).GenEvent_OnOnFocus(Obj, pascontent);
  end;
end;

procedure Java_Event_pOnLostFocus(env: PJNIEnv; this: jobject;
  Obj: TObject; content: JString);
var
  pascontent: string;
  _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent := string(env^.GetStringUTFChars(Env, content, @_jBoolean));
    end;
    jEditText(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;

  if Obj is jComboEditText then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent := string(env^.GetStringUTFChars(Env, content, @_jBoolean));
    end;
    jComboEditText(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;

  if Obj is jAutoTextView then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent := string(env^.GetStringUTFChars(Env, content, @_jBoolean));
    end;
    jAutoTextView(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;
end;

procedure Java_Event_pOnHttpClientCodeResult(env: PJNIEnv; this: jobject;
  Obj: TObject; code: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if not Assigned(Obj) then Exit;
  if Obj is jHttpClient then
  begin
    jHttpClient(Obj).GenEvent_OnHttpClientCodeResult(Obj, code);
  end;
end;

procedure Java_Event_pOnScrollViewChanged(env: PJNIEnv; this: jobject;
  Obj: TObject; currenthorizontal: integer;
  currentVertical:
  integer;
  previousHorizontal: integer;
  previousVertical:
  integer;
  onPosition: integer; scrolldiff: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jScrollView then
  begin
    jScrollView(Obj).GenEvent_OnChanged(Obj, currenthorizontal,
      currentVertical, previousHorizontal, previousVertical, onPosition, scrolldiff);
  end;
end;

procedure Java_Event_pOnHorScrollViewChanged(env: PJNIEnv; this: jobject;
  Obj: TObject; currenthorizontal: integer;
  currentVertical:
  integer;
  previousHorizontal: integer;
  previousVertical:
  integer;
  onPosition: integer; scrolldiff: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jHorizontalScrollView then
  begin
    jHorizontalScrollView(Obj).GenEvent_OnChanged(Obj, currenthorizontal,
      currentVertical, previousHorizontal, previousVertical, onPosition, scrolldiff);
  end;
end;

procedure Java_Event_pOnScrollViewInnerItemClick(env: PJNIEnv;
  this: JObject; Sender: TObject; itemId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jScrollView then
  begin
    jScrollView(Sender).GenEvent_OnScrollViewInnerItemClick(Sender, itemId);
  end;
end;

procedure Java_Event_pOnScrollViewInnerItemLongClick(env: PJNIEnv;
  this: JObject; Sender: TObject; index: integer; itemId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jScrollView then
  begin
    jScrollView(Sender).GenEvent_OnScrollViewInnerItemLongClick(Sender, index, itemId);
  end;
end;

procedure Java_Event_pOnHorScrollViewInnerItemClick(env: PJNIEnv;
  this: JObject; Sender: TObject; itemId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jHorizontalScrollView then
  begin
    jHorizontalScrollView(Sender).GenEvent_OnScrollViewInnerItemClick(Sender, itemId);
  end;
end;

procedure Java_Event_pOnHorScrollViewInnerItemLongClick(env: PJNIEnv;
  this: JObject; Sender: TObject; index: integer; itemId: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jHorizontalScrollView then
  begin
    jHorizontalScrollView(Sender).GenEvent_OnScrollViewInnerItemLongClick(
      Sender, index, itemId);
  end;
end;

procedure Java_Event_pOnSqliteDataAccessAsyncPostExecute(env: PJNIEnv;
  this: JObject; Sender: TObject; Count: integer; msgResult: jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jSqliteDataAccess then
  begin
    jSqliteDataAccess(Sender).GenEvent_OnSqliteDataAccessAsyncPostExecute(
      Sender, Count, GetPStringAndDeleteLocalRef(env, msgResult));
  end;
end;

//------------------------------------------------------------------------------
// jTextView
//------------------------------------------------------------------------------

constructor jTextView.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FTextAlignment := taLeft;
  FText := '';

  FFontFace := ffNormal;
  FTextTypeFace := tfNormal;

  FMarginLeft := 5;
  FMarginTop := 5;
  FMarginBottom := 5;
  FMarginRight := 5;
  FHeight := 25;
  FWidth := 51;
  FLParamWidth := lpWrapContent;
  FLParamHeight := lpWrapContent;
  FEnabled := True;
end;

destructor jTextView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jTextView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

  if not FInitialized then
  begin
    inherited Init;

    FjObject := jTextView_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FAllCaps <> False then
      SetAllCaps(FAllCaps);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then
      SetFontSize(FFontSize);

    SetText(FText);

    SetTextAlignment(FTextAlignment);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    if FEnabled = False then
      SetEnabled(False);

    SetFontFace(FFontFace);
    SetTextTypeFace(FTextTypeFace);

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

end;

procedure jTextView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jTextView.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jTextView.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jTextView.SetEnabled(Value: boolean);
begin
  FEnabled := Value;
  if FjObject = nil then exit;
  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnabled', FEnabled);
end;

function jTextView.GetText: string;
begin
  Result := FText;
  if FInitialized then
    Result := jni_func_out_h(gApp.jni.jEnv, FjObject, 'getText');
end;

procedure jTextView.SetText(Value: string);
begin
  inherited SetText(Value);
  if FjObject = nil then exit;

  jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Value);
end;

procedure jTextView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  if FjObject = nil then exit;

  if (FFontColor <> colbrDefault) then
  begin
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor', GetARGB(FCustomColor, FFontColor));
  end;
end;

procedure jTextView.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FjObject = nil then exit;

  if (FFontSize > 0) then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'SetTextSize', FFontSize);
end;

procedure jTextView.SetFontFace(AValue: TFontFace);
begin
  FFontFace := AValue;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontFace', Ord(FFontFace));
end;

procedure jTextView.SetTextTypeFace(Value: TTextTypeFace);
begin
  FTextTypeFace := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextTypeFace', Ord(FTextTypeFace));
end;

procedure jTextView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

// LORDMAN 2013-08-12
procedure jTextView.SetTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextAlignment', Ord(FTextAlignment));
end;

procedure jTextView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

// Event : Java -> Pascal
procedure jTextView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jTextView.GenEvent_OnLongClick(Obj: TObject);
begin
  if Assigned(FOnLongClick) then FOnLongClick(Obj);
end;

procedure jTextView.Append(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'Append', _txt);
end;

procedure jTextView.AppendLn(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AppendLn', _txt);
end;

procedure jTextView.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'CopyToClipboard');
end;

procedure jTextView.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    jni_proc(gApp.jni.jEnv, FjObject, 'PasteFromClipboard');
  end;
end;

procedure jTextView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

procedure jTextView.GenEvent_OnBeforeDispatchDraw(Obj: TObject;
  canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

procedure jTextView.GenEvent_OnAfterDispatchDraw(Obj: TObject;
  canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jTextView.GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);
begin
  if Assigned(FOnLayouting) then FOnLayouting(Obj, changed);
end;

function jTextView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jTextView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jTextView.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables', _image, Ord(_side));
end;

procedure jTextView.SetCompoundDrawables(_imageResIdentifier: string;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables',
      _imageResIdentifier, Ord(_side));
end;

procedure jTextView.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRoundCorner');
end;

procedure jTextView.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRadiusRoundCorner', _radius);
end;

procedure jTextView.SetRotation(angle: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRotation', angle);
end;

procedure jTextView.SetShadowLayer(_radius: single; _dx: single;
  _dy: single; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jTextView_SetShadowLayer(gApp.jni.jEnv, FjObject, _radius, _dx, _dy,
      GetARGB(FCustomColor, _color));
end;

procedure jTextView.SetShaderLinearGradient(_startColor: TARGBColorBridge;
  _endColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetShaderLinearGradient',
      GetARGB(FCustomColor, _startColor), GetARGB(FCustomColor, _endColor));
end;

procedure jTextView.SetShaderRadialGradient(_centerColor: TARGBColorBridge;
  _edgeColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetShaderRadialGradient',
      GetARGB(FCustomColor, _centerColor), GetARGB(FCustomColor, _edgeColor));
end;

procedure jTextView.SetShaderSweepGradient(_color1: TARGBColorBridge;
  _color2: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetShaderSweepGradient',
      GetARGB(FCustomColor, _color1), GetARGB(FCustomColor, _color2));
end;

procedure jTextView.SetTextDirection(_textDirection: TTextDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextDirection', Ord(_textDirection));
end;

procedure jTextView.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFontFromAssets', _fontName);
end;

procedure jTextView.SetTextIsSelectable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetTextIsSelectable', _value);
end;

procedure jTextView.SetScrollingText();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetScrollingText');
end;

procedure jTextView.SetTextAsLink(_linkText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTextAsLink', _linkText);
end;

//use: SetTextAsLink('<a href=''http://www.google.com''>Go to Google</a>', colbrRed);
procedure jTextView.SetTextAsLink(_linkText: string; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetTextAsLink', _linkText,
      GetARGB(FCustomColor, _color));
end;

procedure jTextView.SetBackgroundAlpha(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetBackgroundAlpha', _alpha);
end;

procedure jTextView.MatchParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'MatchParent');
end;

procedure jTextView.WrapParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'WrapParent');
end;

procedure jTextView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jTextView.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jTextView.SetAllCaps(_value: boolean);
begin
  //in designing component state: set value here...
  FAllCaps := _value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllCaps', _value);
end;

procedure jTextView.SetTextAsHtml(_htmlText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTextAsHtml', _htmlText);
end;

procedure jTextView.SetUnderline(_on: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetUnderline', _on);
end;

procedure jTextView.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jTextView.ApplyDrawableXML(_xmlIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'ApplyDrawableXML', _xmlIdentifier);
end;

procedure jTextView.SetSingleLine(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jTextView_SetSingleLine(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTextView.SetHorizontallyScrolling(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jTextView_SetHorizontallyScrolling(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTextView.SetEllipsize(_mode: TEllipsizeMode);
begin
  //in designing component state: set value here...
  if FInitialized then
    jTextView_SetEllipsize(gApp.jni.jEnv, FjObject, Ord(_mode));
end;

procedure jTextView.SetTextAllCaps(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jTextView_SetTextAllCaps(gApp.jni.jEnv, FjObject, _text);
end;

procedure jTextView.SetScrollingMovementMethod();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetScrollingMovementMethod(gApp.jni.jEnv, FjObject);
end;

procedure jTextView.SetVerticalScrollBarEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetVerticalScrollBarEnabled(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTextView.SetHorizontalScrollBarEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetHorizontalScrollBarEnabled(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTextView.SetVerticalScrollbarPosition(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetVerticalScrollbarPosition(gApp.jni.jEnv, FjObject, _value);
end;

//------------------------------------------------------------------------------
// jEditText
//------------------------------------------------------------------------------

constructor jEditText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FText := '';
  //FColor:= colbrDefault; //colbrWhite;
  FOnLostFocus := nil;
  FOnEnter := nil;
  FOnChange := nil;
  FEditable := True;
  FInputTypeEx := itxText;
  FHint := '';
  FMaxTextLength := -1; //300;
  FSingleLine := True;
  FMaxLines := 1;

  FScrollBarStyle := scrNone;
  FVerticalScrollBar := True;
  FHorizontalScrollBar := True;

  FWrappingLine := False;

  FMarginBottom := 5;
  FMarginLeft := 5;
  FMarginRight := 5;
  FMarginTop := 5;
  FHeight := 40;
  FWidth := 100;

  FLParamWidth := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
  FCloseSoftInputOnEnter := True;
  FCapSentence := False;
  FCaptureBackPressed := False;
end;

destructor jEditText.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jEditText.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jEditText_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    SetFontFace(FFontFace);

    if FActionIconIdentifier <> '' then
      SetActionIconIdentifier(FActionIconIdentifier);

    if FHint <> '' then
      SetHint(FHint);

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then
      SetFontSize(FFontSize);

    SetTextAlignment(FTextAlignment);

    if FMaxTextLength >= 0 then
      SetTextMaxLength(FMaxTextLength);

    jni_proc(gApp.jni.jEnv, FjObject, 'setScrollerEx');

    SetHorizontalScrollBar(FHorizontalScrollBar);
    SetVerticalScrollBar(FVerticalScrollBar);

    jni_proc_z(gApp.jni.jEnv, FjObject, 'setHorizontallyScrolling', FWrappingLine);

    if FCapSentence then
      SetCapSentence(FCapSentence);

    if FCaptureBackPressed then
      SetCaptureBackPressed(FCaptureBackPressed);

    SetSingleLine(True);

    if FText <> '' then
      SetText(FText);

    if FEditable = False then
      SetEditable(FEditable);

    if FHintTextColor <> colbrDefault then
      SetHintTextColor(FHintTextColor);

    if not FCloseSoftInputOnEnter then
      SetCloseSoftInputOnEnter(FCloseSoftInputOnEnter);

    SetInputTypeEx(FInputTypeEx);

    if FInputTypeEx = itxMultiLine then
    begin
      SetSingleLine(False);
      if FMaxLines = 1 then  FMaxLines := 3;   // visibles lines!
      SetMaxLines(FMaxLines);

      if FScrollBarStyle <> scrNone then
        SetScrollBarStyle(FScrollBarStyle);
    end;

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);

    DispatchOnChangeEvent(True);
    DispatchOnChangedEvent(True);
  end;
end;

procedure jEditText.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jEditText.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jEditText.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jEditText.setColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jEditText.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jEditText.GetText: string;
begin
  Result := FText;
  if FInitialized then
    Result := jni_func_out_t(gApp.jni.jEnv, FjObject, 'GetText');
  ;
end;

procedure jEditText.SetAllLowerCase(_lowercase: boolean);
begin
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllLowerCase', _lowercase);
end;

procedure jEditText.SetAllUpperCase(_uppercase: boolean);
begin
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllUpperCase', _uppercase);
end;

procedure jEditText.SetText(Value: string);
begin
  inherited SetText(Value);

  if not FInitialized then exit;

  if Value <> '' then
    jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Value)
  else
    self.Clear;
end;

procedure jEditText.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  if FjObject = nil then exit;

  if (FFontColor <> colbrDefault) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
      GetARGB(FCustomColor, FFontColor));
end;

procedure jEditText.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FjObject = nil then exit;

  if (FFontSize > 0) then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'SetTextSize', FFontSize);
end;

procedure jEditText.SetFontFace(AValue: TFontFace);
begin
  //inherited SetFontFace(AValue);
  FFontFace := AValue;
  if FjObject = nil then exit;

  jni_proc_ii(gApp.jni.jEnv, FjObject, 'setFontAndTextTypeFace',
    Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jEditText.SetTextTypeFace(Value: TTextTypeFace);
begin
  //inherited SetTextTypeFace(Value);
  FTextTypeFace := Value;
  if FjObject = nil then exit;

  jni_proc_ii(gApp.jni.jEnv, FjObject, 'setFontAndTextTypeFace',
    Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jEditText.SetHintTextColor(Value: TARGBColorBridge);
begin
  //inherited SetHintTextColor(Value);
  FHintTextColor := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setHintTextColor',
    GetARGB(FCustomColor, FHintTextColor));
end;

procedure jEditText.SetHint(Value: string);
begin
  FHint := Value;
  if FjObject = nil then exit;

  jni_proc_h(gApp.jni.jEnv, FjObject, 'setHint', FHint);
end;

// LORDMAN - 2013-07-26
procedure jEditText.SetFocus;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetFocus');
end;

{
//InputMethodManager
mgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
mgr.hideSoftInputFromWindow(myView.getWindowToken(), 0);
}

// LORDMAN - 2013-07-26
procedure jEditText.ImmShow;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'InputMethodShow');
end;

// LORDMAN - 2013-07-26
procedure jEditText.ImmHide;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'InputMethodHide');
end;

procedure jEditText.ShowSoftInput();
begin
  if FInitialized then
    Self.ImmShow();
end;

procedure jEditText.HideSoftInput();
begin
  if FInitialized then
    Self.ImmHide();
end;

procedure jEditText.SetInputTypeEx(Value: TInputTypeEx);
begin
  FInputTypeEx := Value;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetInputTypeEx', InputTypeToStrEx(FInputTypeEx));
end;

// LORDMAN - 2013-07-26
procedure jEditText.SetTextMaxLength(Value: integer);
begin
  FMaxTextLength := Value;
  if FMaxTextLength < -1 then  FMaxTextLength := -1; // reset/default: no limited !!
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'MaxLength', FMaxTextLength);
end;

procedure jEditText.SetMaxLines(Value: DWord);
begin
  FMaxLines := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setMaxLines', Value);

  if FMaxLines < 2 then
    SetSingleLine(True);
end;

procedure jEditText.SetSingleLine(Value: boolean);
begin
  FSingleLine := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setSingleLine', Value);
  jni_proc_i(gApp.jni.jEnv, FjObject, 'setMaxLines', 1);
end;

procedure jEditText.SetScrollBarStyle(Value: TScrollBarStyle);
begin
  FScrollBarStyle := Value;
  if FjObject = nil then exit;

  if Value <> scrNone then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setScrollBarStyle', GetScrollBarStyle(Value));

end;

procedure jEditText.SetHorizontalScrollBar(Value: boolean);
begin
  FHorizontalScrollBar := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setHorizontalScrollBarEnabled', Value);
end;

procedure jEditText.SetVerticalScrollBar(Value: boolean);
begin
  FVerticalScrollBar := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setVerticalScrollBarEnabled', Value);
end;

procedure jEditText.SetScrollBarFadingEnabled(Value: boolean);
begin
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setScrollbarFadingEnabled', Value);
end;

procedure jEditText.SetMovementMethod;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetMovementMethod');
end;

// LORDMAN - 2013-07-26
function jEditText.GetCursorPos: TXY;
begin
  Result.x := 0;
  Result.y := 0;
  if FInitialized then
    jEditText_GetCursorPos(gApp.jni.jEnv, FjObject, Result.x, Result.y);
end;

// LORDMAN - 2013-07-26
procedure jEditText.SetCursorPos(Value: TXY);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setCursorPos', Value.X, Value.Y);
end;

// LORDMAN 2013-08-12
procedure jEditText.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextAlignment', Ord(FTextAlignment));
end;

// Event : Java -> Pascal
// LORDMAN - 2013-07-26
procedure jEditText.GenEvent_OnEnter(Obj: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Obj);
end;

// by ADiV
procedure jEditText.GenEvent_OnBackPressed(Obj: TObject);
begin
  if Assigned(FOnBackPressed) then FOnBackPressed(Obj);
end;

procedure jEditText.GenEvent_OnDone(Obj: TObject);
begin
  if Assigned(FOnDone) then FOnDone(Obj);
end;

procedure jEditText.GenEvent_OnGo(Obj: TObject);
begin
  if Assigned(FOnGo) then FOnGo(Obj);
end;

procedure jEditText.GenEvent_OnNext(Obj: TObject);
begin
  if Assigned(FOnNext) then FOnNext(Obj);
end;

procedure jEditText.GenEvent_OnSearch(Obj: TObject);
begin
  if Assigned(FOnSearch) then FOnSearch(Obj);
end;

procedure jEditText.GenEvent_OnChange(Obj: TObject; txt: string; Count: integer);
begin
  if jForm(Owner).FormState = fsFormClose then Exit;
  if Assigned(FOnChange) then FOnChange(Obj, txt, Count);
end;

procedure jEditText.GenEvent_OnChanged(Obj: TObject; txt: string; Count: integer);
begin
  if jForm(Owner).FormState = fsFormClose then Exit;
  if Assigned(FOnChanged) then FOnChanged(Obj, txt, Count);
end;

// Event : Java -> Pascal
procedure jEditText.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jEditText.GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
begin
  if Assigned(FOnLostFocus) then FOnLostFocus(Obj, txt);
end;

procedure jEditText.GenEvent_OnOnFocus(Obj: TObject; txt: string);
begin
  if Assigned(FOnFocus) then FOnFocus(Obj, txt);
end;

procedure jEditText.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jEditText.AllCaps;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'AllCaps');
end;

procedure jEditText.DispatchOnChangeEvent(Value: boolean);
begin
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnChangeEvent', Value);
end;

procedure jEditText.DispatchOnChangedEvent(Value: boolean);
begin
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnChangedEvent', Value);
end;

procedure jEditText.Append(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'Append', _txt);
end;

procedure jEditText.AppendLn(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AppendLn', _txt);
end;

procedure jEditText.AppendTab();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'AppendTab');
end;


procedure jEditText.SetImeOptions(_imeOption: TImeOptions);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetImeOptions', Ord(_imeOption));
end;

procedure jEditText.SetSoftInputOptions(_imeOption: TImeOptions);
begin
  if FInitialized then
    Self.SetImeOptions(_imeOption);
end;

procedure jEditText.SetEditable(Enabled: boolean);
begin
  //in designing component state: set value here...
  FEditable := Enabled;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEditable', Enabled);
end;

procedure jEditText.SetAcceptSuggestion(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAcceptSuggestion', _value);
end;

procedure jEditText.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'CopyToClipboard');
end;

procedure jEditText.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'PasteFromClipboard');
end;

procedure jEditText.Clear;
begin
  if FjObject = nil then exit;

  jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jEditText.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

// by ADiV
procedure jEditText.SetSelection(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetSelection', _value);
end;

procedure jEditText.SetSelectAllOnFocus(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetSelectAllOnFocus', _value);
end;

procedure jEditText.SelectAll();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SelectAll');
end;

procedure jEditText.SetBackgroundByResIdentifier(_imgResIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetBackgroundByResIdentifier',
      _imgResIdentifier);
end;

procedure jEditText.SetBackgroundByImage(_image: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'SetBackgroundByImage', _image);
end;

procedure jEditText.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables', _image, Ord(_side));
end;

procedure jEditText.SetCompoundDrawables(_imageResIdentifier: string;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables',
      _imageResIdentifier, Ord(_side));
end;

procedure jEditText.SetTextDirection(_textDirection: TTextDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextDirection', Ord(_textDirection));
end;

procedure jEditText.GenEvent_OnBeforeDispatchDraw(Obj: TObject;
  canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

procedure jEditText.GenEvent_OnAfterDispatchDraw(Obj: TObject;
  canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jEditText.GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);
begin
  if Assigned(FOnLayouting) then FOnLayouting(Obj, changed);
end;

function jEditText.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jEditText.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jEditText.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFontFromAssets', _fontName);
end;

procedure jEditText.RequestFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'RequestFocus');
end;

procedure jEditText.SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
begin
  //in designing component state: set value here...
  FCloseSoftInputOnEnter := _closeSoftInput;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetCloseSoftInputOnEnter', _closeSoftInput);
end;

procedure jEditText.SetCapSentence(_capSentence: boolean);
begin
  //in designing component state: set value here...
  FCapSentence := _capSentence;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetCapSentence', _capSentence);
  // activate above setting
  SetInputTypeEx(FInputTypeEx);
end;

// by ADiV
procedure jEditText.SetCaptureBackPressed(_capBackPressed: boolean);
begin
  //in designing component state: set value here...
  FCaptureBackPressed := _capBackPressed;

  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetCaptureBackPressed', _capBackPressed);
end;

procedure jEditText.LoadFromFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'LoadFromFile', _path, _filename);
end;

procedure jEditText.LoadFromFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'LoadFromFile', _filename);
end;

procedure jEditText.SaveToFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'SaveToFile', _path, _filename);
end;

procedure jEditText.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SaveToFile', _filename);
end;

procedure jEditText.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jEditText.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jEditText.SetSoftInputShownOnFocus(_show: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetSoftInputShownOnFocus', _show);
end;

procedure jEditText.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRoundCorner');
end;

procedure jEditText.SetRoundRadiusCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRoundRadiusCorner', _radius);
end;

procedure jEditText.SetRoundBorderColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRoundBorderColor',
      GetARGB(FCustomColor, _color));
end;

procedure jEditText.SetRoundBorderWidth(_strokeWidth: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRoundBorderWidth', _strokeWidth);
end;

procedure jEditText.SetRoundBackgroundColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRoundBackgroundColor',
      GetARGB(FCustomColor, _color));
end;


procedure jEditText.SetActionIconIdentifier(_actionIconIdentifier: string);
begin
  //in designing component state: set value here...
  FActionIconIdentifier := _actionIconIdentifier;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetActionIconIdentifier', _actionIconIdentifier);
end;

procedure jEditText.ShowActionIcon();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ShowActionIcon');
end;

procedure jEditText.HideActionIcon();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'HideActionIcon');
end;

function jEditText.IsActionIconShowing(): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'IsActionIconShowing');
end;

function jEditText.GetTextLength(): int64;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_j(gApp.jni.jEnv, FjObject, 'GetTextLength');
end;

function jEditText.IsEmpty(): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'IsEmpty');
end;


procedure Java_Event_pEditTextOnActionIconTouchUp(env: PJNIEnv; this: JObject;
  Sender: TObject; textContent: jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jEditText then
  begin
    jEditText(Sender).GenEvent_EditTextOnActionIconTouchUp(
      Sender, GetPStringAndDeleteLocalRef(env, textContent));
  end;
end;

procedure Java_Event_pEditTextOnActionIconTouchDown(env: PJNIEnv;
  this: JObject; Sender: TObject; textContent: jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jEditText then
  begin
    jEditText(Sender).GenEvent_EditTextOnActionIconTouchDown(
      Sender, GetPStringAndDeleteLocalRef(env, textContent));
  end;
end;

procedure jEditText.ApplyDrawableXML(_xmlIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'ApplyDrawableXML', _xmlIdentifier);
end;

procedure jEditText.GenEvent_EditTextOnActionIconTouchUp(Sender: TObject;
  textContent: string);
begin
  if Assigned(FOnActionIconTouchUp) then FOnActionIconTouchUp(Sender, textContent);
end;

procedure jEditText.GenEvent_EditTextOnActionIconTouchDown(Sender: TObject;
  textContent: string);
begin
  if Assigned(FOnActionIconTouchDown) then FOnActionIconTouchDown(Sender, textContent);
end;

//------------------------------------------------------------------------------
// jButton
//------------------------------------------------------------------------------
constructor jButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FText := '';
  FMarginLeft := 5;
  FMarginTop := 5;
  FMarginBottom := 5;
  FMarginRight := 5;
  FHeight := 40;
  FWidth := 100;
  FLParamWidth := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
  FEnabled := True;
  FAllCaps := False;

end;

destructor jButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init; // set FjPRLayout:= jForm.View [default] ...

    FjObject := jButton_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;


  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then //not default...
      SetFontSize(FFontSize);

    if AllCaps <> False then
      SetAllCaps(FAllCaps);

    SetText(FText);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);

    if FEnabled = False then
      SetEnabled(False);
  end;
end;

procedure jButton.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jButton.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jButton.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jButton.SetAllCaps(AValue: boolean);
begin
  FAllCaps := AValue;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllCaps', FAllCaps);
end;

procedure jButton.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jButton.Refresh;
begin
  if not FInitialized then Exit;

  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jButton.GetText: string;
begin
  Result := FText;
  if FInitialized then
    Result := jni_func_out_h(gApp.jni.jEnv, FjObject, 'getText');
end;

procedure jButton.SetText(Value: string);
begin
  inherited SetText(Value); //by thierry

  if FjObject = nil then exit;

  jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Value{FText}); //by thierry
end;

procedure jButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  if FjObject = nil then exit;

  if (FFontColor <> colbrDefault) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
      GetARGB(FCustomColor, FFontColor));
end;

procedure jButton.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FjObject = nil then exit;

  if (FFontSize > 0) then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'SetTextSize', FFontSize);
end;

procedure jButton.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jButton.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;


procedure jButton.PerformClick();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'PerformClick');
end;

procedure jButton.PerformLongClick();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'PerformLongClick');
end;

procedure jButton.SetBackgroundByResIdentifier(_imgResIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetBackgroundByResIdentifier',
      _imgResIdentifier);
end;

procedure jButton.SetBackgroundByImage(_image: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'SetBackgroundByImage', _image);
end;

// Event : Java -> Pascal
procedure jButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jButton.GenEvent_OnBeforeDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

procedure jButton.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject;
  tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

function jButton.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jButton.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jButton.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables', _image, Ord(_side));
end;

procedure jButton.SetCompoundDrawables(_imageResIdentifier: string;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables',
      _imageResIdentifier, Ord(_side));
end;

procedure jButton.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRoundCorner');
end;

procedure jButton.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRadiusRoundCorner', _radius);
end;

procedure jButton.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFontFromAssets', _fontName);
end;

procedure jButton.SetEnabled(Value: boolean);
begin
  //in designing component state: set value here...
  FEnabled := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnabled', Value);
end;

procedure jButton.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jButton.SetLWeight(_weight: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLWeight(gApp.jni.jEnv, FjObject, _weight);
end;

procedure jButton.SetFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetFocus');
end;

procedure jButton.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jButton.ApplyDrawableXML(_xmlIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'ApplyDrawableXML', _xmlIdentifier);
end;

procedure jButton.Append(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jButton_Append(gApp.jni.jEnv, FjObject, _txt);
end;


//------------------------------------------------------------------------------
// jCheckBox
//------------------------------------------------------------------------------

constructor jCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FText := '';
  FChecked := False;
  FMarginLeft := 5;
  FMarginTop := 5;
  FMarginBottom := 5;
  FMarginRight := 5;
  FHeight := 25;
  FWidth := 100;
  FLParamWidth := lpWrapContent;
  FLParamHeight := lpWrapContent;
end;

destructor jCheckBox.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jCheckBox.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jCheckBox_Create(gApp.jni.jEnv, gApp.jni.jThis, self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := 0;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True;

    SetText(FText);

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then
      SetFontSize(FFontSize);

    SetText(FText);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
    SetChecked(FChecked);
  end;
end;

procedure jCheckBox.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jCheckBox.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jCheckBox.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jCheckBox.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jCheckBox.GetText: string;
begin
  Result := FText;
  if FInitialized then
    Result := jni_func_out_h(gApp.jni.jEnv, FjObject, 'getText');
end;

procedure jCheckBox.SetText(Value: string);
begin
  inherited SetText(Value);
  if FjObject = nil then exit;

  jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Value);
end;

procedure jCheckBox.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  if FjObject = nil then exit;

  if (FFontColor <> colbrDefault) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
      GetARGB(FCustomColor, FFontColor));
end;

procedure jCheckBox.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FjObject = nil then exit;

  if (FFontSize > 0) then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'SetTextSize', FFontSize);
end;

function jCheckBox.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'isChecked');
end;

procedure jCheckBox.SetChecked(Value: boolean);
begin
  FChecked := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setChecked', FChecked);
end;

procedure jCheckBox.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jCheckBox.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

// Event Java -> Pascal
procedure jCheckBox.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jCheckBox.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables', _image, Ord(_side));
end;

procedure jCheckBox.SetCompoundDrawables(_imageResIdentifier: string;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables',
      _imageResIdentifier, Ord(_side));
end;

procedure jCheckBox.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFontFromAssets', _fontName);
end;

procedure jCheckBox.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jCheckBox.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

//------------------------------------------------------------------------------
// jRadioButton
//------------------------------------------------------------------------------

constructor jRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FText := '';
  FChecked := False;
  FMarginLeft := 5;
  FMarginTop := 5;
  FMarginBottom := 5;
  FMarginRight := 5;
  FHeight := 25;
  FWidth := 100;
  FLParamWidth := lpWrapContent;
  FLParamHeight := lpWrapContent;
end;

destructor jRadioButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jRadioButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  flag: boolean;
begin
  flag := False;

  if not FInitialized then
  begin
    inherited Init;
    FjObject := jRadioButton_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then Self.MyClassParentName := FParent.ClassName;

    if FParent <> nil then
    begin
      sysTryNewParent(FjPRLayout, FParent);
      if FParent is jRadioGroup then flag := True;
    end;

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  if not flag then
    View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True;

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then
      SetFontSize(FFontSize);

    SetText(FText);

    SetChecked(FChecked);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;
end;

procedure jRadioButton.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jRadioButton.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jRadioButton.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jRadioButton.Refresh;
begin
  if not FInitialized then Exit;

  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jRadioButton.GetText: string;
begin
  Result := FText;
  if FInitialized then
    Result := jni_func_out_h(gApp.jni.jEnv, FjObject, 'getText');
end;

procedure jRadioButton.SetText(Value: string);
begin
  inherited SetText(Value);
  if FjObject = nil then exit;

  jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Value{ FText});
end;

procedure jRadioButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  if FjObject = nil then exit;

  if (FFontColor <> colbrDefault) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
      GetARGB(FCustomColor, FFontColor));
end;

procedure jRadioButton.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FjObject = nil then exit;

  if (FFontSize > 0) then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'SetTextSize', FFontSize);
end;

function jRadioButton.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'isChecked');
end;

procedure jRadioButton.SetChecked(Value: boolean);
begin
  FChecked := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setChecked', FChecked);
end;

procedure jRadioButton.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jRadioButton.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

// Event Java -> Pascal
procedure jRadioButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jRadioButton.SetCompoundDrawables(_image: jObject;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables', _image, Ord(_side));
end;

procedure jRadioButton.SetCompoundDrawables(_imageResIdentifier: string;
  _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetCompoundDrawables',
      _imageResIdentifier, Ord(_side));
end;

procedure jRadioButton.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFontFromAssets', _fontName);
end;

procedure jRadioButton.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jRadioButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jRadioButton.SetRoundColor(_color: TARGBColorBridge);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRoundColor', GetARGB(FCustomColor, _color));
end;

//------------------------------------------------------------------------------
// jProgressBar
//------------------------------------------------------------------------------

constructor jProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FProgress := 0;
  FMax := 100;  //default...
  FStyle := cjProgressBarStyleHorizontal;
  FVisible := True;
  FMarginLeft := 10;
  FMarginTop := 10;
  FMarginBottom := 10;
  FMarginRight := 10;
  FHeight := 30;
  FWidth := 100;
  FEnabled := False;

  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;

end;

destructor jProgressBar.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jProgressBar.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;
    FjObject := jProgressBar_Create(gApp.jni.jEnv, gApp.jni.jThis,
      Self, GetProgressBarStyle(FStyle));

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True;

    SetProgress(FProgress);
    SetMax(FMax);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;
end;

procedure jProgressBar.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jProgressBar.RemoveFromViewParent;
begin
  //if FInitialized then
  // jProgressBar_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jProgressBar.Stop;
begin
  FProgress := 0;
  FVisible := False;
  if not FInitialized then Exit;
  SetProgress(0);
  SetVisible(False);
end;

procedure jProgressBar.Start;
begin
  if not FInitialized then Exit;
  SetVisible(True);
  SetProgress(FProgress);
end;

procedure jProgressBar.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jProgressBar.SetColors(_color, _colorBack: TARGBColorBridge);
begin
  if not FInitialized then Exit;

  jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetColors', GetARGB(FCustomColor, _color),
    GetARGB(FCustomColor, _colorBack));
end;

procedure jProgressBar.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jProgressBar.Refresh;
begin
  if not FInitialized then Exit;

  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

function jProgressBar.GetProgress: integer;
begin
  Result := FProgress;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getProgress');
end;

procedure jProgressBar.SetProgress(Value: integer);
begin
  if Value >= 0 then
    FProgress := Value
  else
    FProgress := 0;

  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setProgress', FProgress);
end;

//by jmpessoa
procedure jProgressBar.SetMax(Value: integer);
begin
  if Value > FProgress then FMax := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setMax', FMax);
end;

//by jmpessoa
function jProgressBar.GetMax: integer;
begin
  Result := FMax;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getMax');
end;

procedure jProgressBar.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jProgressBar.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jProgressBar.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jProgressBar.ApplyDrawableXML(_xmlIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'ApplyDrawableXML', _xmlIdentifier);
end;

procedure jProgressBar.SetMarkerColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetMarkerColor',
      GetARGB(FCustomColor, _color));
end;

//------------------------------------------------------------------------------
// jImageView
//------------------------------------------------------------------------------

constructor jImageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  // Init
  FImageName := '';
  FImageIndex := -1;
  FLParamWidth := lpWrapContent; //lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 72;
  FWidth := 72;
  //FIsBackgroundImage:= False;
  FFilePath := fpathData;
  FImageScaleType := scaleCenter;
  FRoundedShape := False;
  FAnimationMode := animNone;
  FAnimationDurationIn := 1500;
  FAnimationDurationOut := 1500;

  FAlpha := 255;
end;

destructor jImageView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jImageView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jImageView_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  if FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
      GetARGB(FCustomColor, FColor));

  if FRoundedShape <> False then
    SetRoundedShape(FRoundedShape);

  if (FImageIndex < 0) or (FImagelist = nil) then
    if (FImageName <> '') then
      SetImageByResIdentifier(FImageName);

  if FAnimationDurationIn <> 1500 then
    SetAnimationDurationIn(FAnimationDurationIn);

  if FAnimationDurationOut <> 1500 then
    SetAnimationDurationOut(FAnimationDurationOut);

  if FAnimationMode <> animNone then
    SetAnimationMode(FAnimationMode);

  if FImageList <> nil then
  begin
    FImageList.Init;
    if FImageList.Images.Count > 0 then
    begin
      if FImageIndex >= 0 then SetImageByIndex(FImageIndex);
    end;
  end;

  if FImageScaleType <> scaleCenter then
    SetScaleType(FImageScaleType);

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;
    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

  if FAlpha <> 255 then
    SetAlpha(FAlpha);

end;

procedure jImageView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jImageView.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jImageView.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

function jImageView.GetView(): jObject;
begin
  Result := nil;
  if FInitialized then
    Result := View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jImageView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jImageView.SetImageByName(Value: string);
var
  i: integer;
  foundIndex: integer;
begin
  if FjObject = nil then exit;
  if FImageList = nil then Exit;
  if Value = '' then Exit;

  foundIndex := -1;
  for i := 0 to FImageList.Images.Count - 1 do
  begin    //simply compares ASCII values...
    if CompareText(Trim(FImageList.Images.Strings[i]), Trim(Value)) = 0 then
      foundIndex := i;
  end;
  if foundIndex > -1 then
  begin
    FImageIndex := foundIndex;
    FImageName := Trim(FImageList.Images.Strings[foundIndex]);
    SetImage(GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} + '/' + FImageName);
  end;
end;

procedure jImageView.SetImage(_fullFilename: string);
begin
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'setImage', _fullFilename);
end;

procedure jImageView.SetRotation(angle: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRotation', angle);
end;

function jImageView.SaveToJPG(filePath: string; cuality: integer;
  angle: integer): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tii_out_z(gApp.jni.jEnv, FjObject, 'SaveToJPG',
      filePath, cuality, angle);
end;

function jImageView.SaveToPNG(filePath: string; cuality: integer;
  angle: integer): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tii_out_z(gApp.jni.jEnv, FjObject, 'SaveToPNG',
      filePath, cuality, angle);
end;

procedure jImageView.SetImageByIndex(Value: integer);
begin
  if FjObject = nil then exit;
  if FImageList = nil then Exit;

  if (Value >= 0) and (Value < FImageList.Images.Count) then
  begin
    FImageName := Trim(FImageList.Images.Strings[Value]);
    if (FImageName <> '') and (FImageName <> 'null') then
    begin
      SetImage(GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} + '/' + FImageName);
    end;
  end;
end;

function jImageView.GetCount: integer;
begin
  Result := 0;

  if FjObject = nil then exit;

  if FImageList = nil then Exit;

  Result := FImageList.Images.Count;
end;

procedure jImageView.SetImageName(Value: string);
begin
  FImageName := Value;
  if FInitialized then SetImageByName(Value);
end;

procedure jImageView.SetImageIndex(Value: TImageListIndex);
begin

  FImageIndex := Value;

  if FImageList <> nil then
  begin
    if FInitialized then
    begin
      if Value > FImageList.Images.Count then FImageIndex := FImageList.Images.Count;
      if Value < 0 then FImageIndex := 0;
      SetImageByIndex(Value);
    end;
  end;

end;

procedure jImageView.SetImageBitmap(bitmap: jObject); //deprecated..
begin
  if FInitialized then
    SetImage(bitmap);
end;

procedure jImageView.SetImage(bitmap: jObject);
begin
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'SetBitmapImage', bitmap);
end;

procedure jImageView.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  FImageName := _imageResIdentifier;

  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetImageByResIdentifier', _imageResIdentifier);
end;

procedure jImageView.SetParamHeight(Value: TLayoutParams);
begin
  inherited SetParamHeight(Value);
  if FInitialized then
  begin

  end;
end;

procedure jImageView.SetParamWidth(Value: TLayoutParams);
begin
  inherited SetParamWidth(Value);     //FLParamWidth
  if FInitialized then
  begin

  end;
end;

function jImageView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jImageView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jImageView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jImageView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

// Event : Java -> Pascal
procedure jImageView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jImageView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if Operation = opRemove then
    if AComponent = FImageList then
      FImageList := nil;
end;

procedure jImageView.SetImages(Value: jImageList);
begin

  if Value <> FImageList then
  begin
    if FImageList <> nil then
      if Assigned(FImageList) then
        FImageList.RemoveFreeNotification(Self); //remove free notification...

    FImageList := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;
end;

function jImageView.GetBitmapHeight: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetBitmapHeight');
end;

function jImageView.GetBitmapWidth: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetBitmapWidth');
end;

procedure jImageView.SetScale(_scaleX: single; _scaleY: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ff(gApp.jni.jEnv, FjObject, 'SetScale', _scaleX, _scaleY);
end;

// by ADiV
procedure jImageView.SetAlpha(Value: integer);
begin
  FAlpha := Value;

  if not FInitialized then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAlpha', FAlpha);
end;

// by ADiV
procedure jImageView.SetSaturation(Value: single);
begin
  if not FInitialized then exit;

  jni_proc_f(gApp.jni.jEnv, FjObject, 'SetSaturation', Value);
end;

procedure jImageView.SetMatrixScaleCenter(_scaleX, _scaleY: single);
begin
  if FInitialized then
  begin
    if ImageScaleType <> scaleMatrix then
      SetScaleType(scaleMatrix);

    jni_proc_ff(gApp.jni.jEnv, FjObject, 'SetMatrixScaleCenter', _scaleX, _scaleY);
  end;
end;

procedure jImageView.SetMatrix(_scaleX, _scaleY, _angle, _dx, _dy, _px, _py: single);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    if ImageScaleType <> scaleMatrix then
      SetScaleType(scaleMatrix);

    jni_proc_fffffff(gApp.jni.jEnv, FjObject, 'SetMatrix', _scaleX, _scaleY,
      _angle, _dx, _dy, _px, _py);
  end;
end;


procedure jImageView.SetScaleType(_scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  FImageScaleType := _scaleType;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetScaleType', Ord(_scaleType));
end;

function jImageView.GetBitmapImage(): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapImage');
end;

function jImageView.GetImage(): jObject;
begin
  Result := GetBitmapImage();
end;

function jImageView.GetBitmapImage(_x, _y, _width, _height: integer): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_iiii_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmapImage',
      _x, _y, _width, _height);
end;

function jImageView.GetLParamWidth(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jImageView.GetLParamHeight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jImageView.SetImageFromURI(_uri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_uri(gApp.jni.jEnv, FjObject, 'SetImageFromURI', _uri);
end;

procedure jImageView.SetImageFromIntentResult(_intentData: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_SetImageFromIntentResult(gApp.jni.jEnv, FjObject, _intentData);
end;

procedure jImageView.SetImageThumbnailFromCamera(_intentData: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_SetImageThumbnailFromCamera(gApp.jni.jEnv, FjObject, _intentData);
end;


procedure jImageView.SetImageFromJByteArray(var _image: TDynArrayOfJByte);
begin
  if FInitialized then
    jImageView_SetImageFromByteArray(gApp.jni.jEnv, FjObject, _image);
end;

procedure jImageView.SetImageBitmap(_bitmap: jObject; _width: integer; _height: integer);
//deprecated
begin
  //in designing component state: set value here...
  if FInitialized then
    SetImage(_bitmap, _width, _height);
end;

procedure jImageView.SetImage(_bitmap: jObject; _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_ii(gApp.jni.jEnv, FjObject, 'SetBitmapImage',
      _bitmap, _width, _height);
end;

procedure jImageView.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRoundCorner');
end;

procedure jImageView.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRadiusRoundCorner', _radius);
end;

procedure jImageView.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jImageView.SetCollapseMode(_collapsemode: TCollapsingMode);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetCollapseMode', Ord(_collapsemode));
end;

procedure jImageView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

procedure jImageView.SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetScrollFlag', Ord(_collapsingScrollFlag));
end;

procedure jImageView.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jImageView.SetVisibilityGone();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetVisibilityGone');
end;

function jImageView.GetJByteBuffer(_width: integer; _height: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jImageView_GetByteBuffer(gApp.jni.jEnv, FjObject, _width, _height);
end;

function jImageView.GetBitmapFromJByteBuffer(_jbyteBuffer: jObject;
  _width: integer; _height: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jImageView_GetBitmapFromByteBuffer(gApp.jni.jEnv, FjObject,
      _jbyteBuffer, _width, _height);
end;

function jImageView.GetDirectBufferAddress(byteBuffer: jObject): PJByte;
begin
  Result := nil;
  if FInitialized then
    Result := PJByte((gApp.jni.jEnv^).GetDirectBufferAddress(gApp.jni.jEnv, byteBuffer));
end;

procedure jImageView.SetRoundedShape(_value: boolean);
begin
  //in designing component state: set value here...
  FRoundedShape := _value;
  if FjObject = nil then exit;
  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetRoundedShape', FRoundedShape);
end;

procedure jImageView.SetImageFromJByteBuffer(_jbyteBuffer: jObject;
  _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_SetImageFromByteBuffer(gApp.jni.jEnv, FjObject,
      _jbyteBuffer, _width, _height);
end;

procedure jImageView.LoadFromURL(_url: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'LoadFromURL', _url);
end;

procedure jImageView.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SaveToFile', _filename);
end;

procedure jImageView.ShowPopupMenu(var _items: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_ShowPopupMenu(gApp.jni.jEnv, FjObject, _items);
end;

procedure jImageView.ShowPopupMenu(_items: array of string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_ShowPopupMenu(gApp.jni.jEnv, FjObject, _items);
end;

procedure jImageView.SetAnimationDurationIn(_animationDurationIn: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationIn := _animationDurationIn;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationDurationIn', _animationDurationIn);
end;

procedure jImageView.SetAnimationDurationOut(_animationDurationOut: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationOut := _animationDurationOut;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationDurationOut', _animationDurationOut);
end;

procedure jImageView.SetAnimationMode(_animationMode: TAnimationMode);
begin
  //in designing component state: set value here...
  FAnimationMode := _animationMode;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationMode', Ord(_animationMode));
end;

procedure jImageView.Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_zii(gApp.jni.jEnv, FjObject, 'Animate', _animateIn, _xFromTo, yFromTo);
end;

procedure jImageView.AnimateRotate(_angleFrom, _angleTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_ii(gApp.jni.jEnv, FjObject, 'AnimateRotate', _angleFrom, _angleTo);
end;

procedure jImageView.SetImageFromAssets(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetImageFromAssets', _filename);
end;

procedure jImageView.SetImageDrawable(_imageAnimation: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_SetImageDrawable(gApp.jni.jEnv, FjObject, _imageAnimation);
end;

procedure jImageView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jImageView.GenEvent_OnImageViewPopupItemSelected(Sender: TObject;
  Caption: string);
begin
  if Assigned(FOnPopupItemSelected) then FOnPopupItemSelected(Sender, Caption);
end;

// Event : Java Event -> Pascal
procedure jImageView.GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer;
  X1, Y1, X2, Y2: single);
begin
  case Act of
    cTouchDown: VHandler_touchesBegan_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchDown, FMouches);
    cTouchMove: VHandler_touchesMoved_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchMove, FMouches);
    cTouchUp: VHandler_touchesEnded_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchUp, FMouches);
  end;
end;

procedure Java_Event_pOnImageViewPopupItemSelected(env: PJNIEnv;
  this: JObject; Sender: TObject; Caption: jString);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Sender is jImageView then
  begin
    jImageView(Sender).GenEvent_OnImageViewPopupItemSelected(
      Sender, GetPStringAndDeleteLocalRef(env, Caption));
  end;
end;

procedure jImageView.ApplyDrawableXML(_xmlIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'ApplyDrawableXML', _xmlIdentifier);
end;

procedure jImageView.SetClipToOutline(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetClipToOutline', _value);
end;

procedure jImageView.SetRoundCorner(_cornersRadius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jImageView_SetRoundCorner(gApp.jni.jEnv, FjObject, _cornersRadius);
end;

procedure jImageView.SetRippleEffect(); //thanks to Agmcz!
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRippleEffect');
end;

{ jImageList }

constructor jImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FFilePath := fpathData;
  FImages := TStringList.Create;
  TStringList(FImages).OnChange := ListImagesChange;
end;

destructor jImageList.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  //you others free code here...
  if FImages <> nil then FImages.Free;

  inherited Destroy;
end;

procedure jImageList.Init;
var
  i: integer;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jImageList_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

  if FjObject = nil then exit;

  FInitialized := True;

  if FImages <> nil then
    for i := 0 to FImages.Count - 1 do
      if Trim(FImages.Strings[i]) <> '' then
        Asset_SaveToFile(Trim(FImages.Strings[i]), GetFilePath(
          FFilePath){jForm(Owner).App.Path.Dat} + '/' + Trim(FImages.Strings[i]));

end;

procedure jImageList.SetImages(Value: TStrings);
begin
  if Value = nil then exit;
  if FImages = nil then exit;

  FImages.Assign(Value);
end;

function jImageList.GetCount: integer;
begin
  Result := 0;

  if FImages = nil then exit;

  Result := FImages.Count;
end;

function jImageList.GetImageByIndex(index: integer): string;
begin
  Result := '';

  if FImages = nil then exit;

  if (index >= 0) and (index < FImages.Count) then
    Result := Trim(FImages.Strings[index]);
end;

function jImageList.GetImageExByIndex(index: integer): string;
begin
  Result := '';

  if FImages = nil then exit;
  if not FInitialized then exit;

  if (index < FImages.Count) and (index >= 0) then
    Result := GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} + '/' +
      Trim(FImages.Strings[index]);

end;

function jImageList.GetBitmap(imageIndex: integer): jObject;
var
  path: string;
begin
  Result := nil;

  if FImages = nil then exit;

  if Initialized then
  begin
    if (imageIndex < FImages.Count) and (imageIndex >= 0) then
    begin
      path := GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} +
        '/' + Trim(FImages.Strings[imageIndex]);
      Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromFile', path);
    end;
  end;
end;

procedure jImageList.ListImagesChange(Sender: TObject);
begin
  //TODO
end;


{---------  jHttpClient  --------------}

constructor jHttpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FUrls := TStringList.Create;
  FUrl := '';
  FCharSet := 'UTF-8';
  FIndexUrl := -1;
  FAuthenticationMode := autNone;

  FResponseTimeout := 15000;
  FConnectionTimeout := 15000;
  FUploadformName := 'lamwFormUpload';
end;

destructor jHttpClient.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  //you others free code here...'
  FUrls.Free;
  inherited Destroy;
end;

procedure jHttpClient.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject := jHttpClient_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

  if FjObject = nil then exit;

  FInitialized := True;

  if FResponseTimeout <> 15000 then
    SetResponseTimeout(FResponseTimeout);

  if FConnectionTimeout <> 15000 then
    SetConnectionTimeout(FConnectionTimeout);

  if FUploadFormName <> '' then
    SetUploadFormName(FUploadFormName);

  SetUrlByIndex(FIndexUrl);
end;

procedure jHttpClient.SetAuthenticationUser(_userName: string; _password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'SetAuthenticationUser', _userName, _password);
end;

procedure jHttpClient.SetAuthenticationMode(_authenticationMode:
  THttpClientAuthenticationMode);
begin
  //in designing component state: set value here...
  FAuthenticationMode := _authenticationMode;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAuthenticationMode',
      Ord(_authenticationMode));
end;


procedure jHttpClient.SetAuthenticationHost(_hostName: string; _port: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetAuthenticationHost', _hostName, _port);
end;

procedure jHttpClient.SetUrls(Value: TStrings);
begin
  if Value = nil then exit;
  if FUrls = nil then exit;

  FUrls.Assign(Value);
end;

procedure jHttpClient.SetUrlByIndex(Value: integer);
begin
  if FUrls = nil then exit;

  FUrl := '';

  if (Value >= 0) and (Value < FUrls.Count) then
    FUrl := Trim(FUrls.Strings[Value]);
end;

procedure jHttpClient.SetIndexUrl(Value: integer);
begin
  if not FInitialized then exit;

  FIndexUrl := Value;
  SetUrlByIndex(Value);
end;

procedure jHttpClient.SetCharSet(AValue: string);
begin
  FCharSet := AValue;
end;

procedure jHttpClient.GetAsync;
begin
  if not FInitialized then Exit;

  if FUrl <> '' then
    GetAsync(FUrl);
end;

procedure jHttpClient.GetAsync(_stringUrl: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'GetAsync', _stringUrl);
end;

procedure jHttpClient.GetAsyncGooglePlayVersion(_stringUrl: string);
begin

  //in designing component state: result value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'GetAsyncGooglePlayVersion', _stringUrl);
end;

function jHttpClient.Get(_stringUrl: string): string;
begin
  Result := '';
  if not FInitialized then Exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetCharSet', FCharSet);
  Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'Get', _stringUrl);
end;

function jHttpClient.Get(): string;
begin
  Result := '';
  if not FInitialized then Exit;

  if FUrl <> '' then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'Get', FUrl);
end;

procedure jHttpClient.ClearNameValueData;
begin
  if (FInitialized) then jni_proc(gApp.jni.jEnv, FjObject, 'ClearNameValueData');
end;

procedure jHttpClient.AddNameValueData(_name, _value: string);
begin
  if (FInitialized) then jni_proc_tt(gApp.jni.jEnv, FjObject,
      'AddNameValueData', _name, _value);
end;

function jHttpClient.Post(_stringUrl: string): string;
begin
  Result := '';
  if not FInitialized then Exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'AddCreateTableQuery', FCharSet);
  Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'Post', _stringUrl);
  //fixed! thanks to JKennes
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'PostNameValueDataAsync', _stringUrl);
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string;
  _name: string; _value: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jni_proc_ttt(gApp.jni.jEnv, FjObject, 'PostNameValueDataAsync',
      _stringUrl, _name, _value);
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string; _listNameValue: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'PostNameValueDataAsync',
      _stringUrl, _listNameValue);
end;

function jHttpClient.GetCookiesCount(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetCookiesCount');
end;

function jHttpClient.GetCookieByIndex(_index: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookieByIndex(gApp.jni.jEnv, FjObject, _index);
end;

function jHttpClient.GetCookieAttributeValue(_cookie: jObject;
  _fieldName: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookieAttributeValue(gApp.jni.jEnv, FjObject,
      _cookie, _fieldName);
end;

procedure jHttpClient.ClearCookieStore();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ClearCookieStore');
end;

procedure jHttpClient.trustAllCertificates();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'trustAllCertificates');
end;

function jHttpClient.AddCookie(_name: string; _value: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_AddCookie(gApp.jni.jEnv, FjObject, _name, _value);
end;

function jHttpClient.IsExpired(_cookie: jObject): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_IsExpired(gApp.jni.jEnv, FjObject, _cookie);
end;

function jHttpClient.GetStateful(_url: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetStateful', _url);
end;

function jHttpClient.PostStateful(_url: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'PostStateful', _url);
end;


function jHttpClient.IsCookiePersistent(_cookie: jObject): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_IsCookiePersistent(gApp.jni.jEnv, FjObject, _cookie);
end;

procedure jHttpClient.SetCookieValue(_cookie: jObject; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jHttpClient_SetCookieValue(gApp.jni.jEnv, FjObject, _cookie, _value);
end;

function jHttpClient.GetCookieByName(_cookieName: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookieByName(gApp.jni.jEnv, FjObject, _cookieName);
end;

procedure jHttpClient.SetCookieAttributeValue(_cookie: jObject;
  _attribute: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jHttpClient_SetCookieAttributeValue(gApp.jni.jEnv, FjObject,
      _cookie, _attribute, _value);
end;

function jHttpClient.GetCookieValue(_cookie: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookieValue(gApp.jni.jEnv, FjObject, _cookie);
end;

function jHttpClient.GetCookieName(_cookie: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookieName(gApp.jni.jEnv, FjObject, _cookie);
end;

function jHttpClient.GetCookies(_nameValueSeparator: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookies(gApp.jni.jEnv, FjObject, _nameValueSeparator);
end;

procedure jHttpClient.AddClientHeader(_name: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'AddClientHeader', _name, _value);
end;

procedure jHttpClient.ClearClientHeader(_name: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'ClearClientHeader', _name, _value);
end;

function jHttpClient.DeleteStateful(_url: string; _value: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tt_out_t(gApp.jni.jEnv, FjObject, 'DeleteStateful', _url, _value);
end;

procedure jHttpClient.GenEvent_OnHttpClientContentResult(Obj: TObject;
  content: rawbytestring);
begin
  if Assigned(FOnContentResult) then FOnContentResult(Obj, content);
end;

procedure jHttpClient.GenEvent_OnHttpClientCodeResult(Obj: TObject; code: integer);
begin
  if Assigned(FOnCodeResult) then FOnCodeResult(Obj, code);
end;

procedure jHttpClient.GenEvent_OnHttpClientUploadProgress(Obj: TObject; progress: int64);
begin
  if Assigned(FOnUploadProgress) then FOnUploadProgress(Obj, progress);
end;

procedure jHttpClient.GenEvent_OnHttpClientUploadFinished(Obj: TObject;
  code: integer; response: string; fileName: string);
begin
  if Assigned(FOnUploadFinished) then FOnUploadFinished(Obj, code, response, fileName);
end;

function jHttpClient.UrlExist(_urlString: string): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'UrlExist', _urlString);
end;

function jHttpClient.GetCookies(_urlString: string;
  _nameValueSeparator: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetCookies(gApp.jni.jEnv, FjObject,
      _urlString, _nameValueSeparator);
end;

function jHttpClient.AddCookie(_urlString: string; _name: string;
  _value: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_AddCookie(gApp.jni.jEnv, FjObject, _urlString, _name, _value);
end;


// _cookieList format: 'userId=igbrown; sessionId=SID77689211949; isAuthenticated=true';

function jHttpClient.OpenConnection(_urlString: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_OpenConnection(gApp.jni.jEnv, FjObject, _urlString);
end;

function jHttpClient.SetRequestProperty(_httpConnection: jObject;
  _headerName: string; _headerValue: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_SetRequestProperty(gApp.jni.jEnv, FjObject,
      _httpConnection, _headerName, _headerValue);
end;

(*
function jHttpClient.Connect(_httpConnection: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_Connect(gApp.jni.jEnv, FjObject, _httpConnection);
end;
*)

function jHttpClient.GetHeaderField(_httpConnection: jObject;
  _headerName: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetHeaderField(gApp.jni.jEnv, FjObject,
      _httpConnection, _headerName);
end;

function jHttpClient.GetHeaderFields(_httpConnection: jObject): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetHeaderFields(gApp.jni.jEnv, FjObject, _httpConnection);
end;


procedure jHttpClient.Disconnect(_httpConnection: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jHttpClient_Disconnect(gApp.jni.jEnv, FjObject, _httpConnection);
end;

function jHttpClient.Get(_httpConnection: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_Get(gApp.jni.jEnv, FjObject, _httpConnection);
end;

function jHttpClient.AddRequestProperty(_httpConnection: jObject;
  _headerName: string; _headerValue: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_AddRequestProperty(gApp.jni.jEnv, FjObject,
      _httpConnection, _headerName, _headerValue);
end;

function jHttpClient.Post(_httpConnection: jObject): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_Post(gApp.jni.jEnv, FjObject, _httpConnection);
end;


function jHttpClient.GetResponseCode(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetResponseCode');
end;

function jHttpClient.GetDefaultConnection(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jHttpClient_GetDefaultConnection(gApp.jni.jEnv, FjObject);
end;

procedure jHttpClient.SetResponseTimeout(_timeoutMilliseconds: integer);
begin
  //in designing component state: set value here...
  FResponseTimeout := _timeoutMilliseconds;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetResponseTimeout', _timeoutMilliseconds);
end;

procedure jHttpClient.SetConnectionTimeout(_timeoutMilliseconds: integer);
begin
  //in designing component state: set value here...
  FConnectionTimeout := _timeoutMilliseconds;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetConnectionTimeout', _timeoutMilliseconds);
end;

function jHttpClient.GetResponseTimeout(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  Result := FResponseTimeout;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetResponseTimeout');
end;

function jHttpClient.GetConnectionTimeout(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  Result := FConnectionTimeout;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetConnectionTimeout');
end;


procedure jHttpClient.UploadFile(_url: string; _fullFileName: string;
  _uploadFormName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ttt(gApp.jni.jEnv, FjObject, 'UploadFile',
      _url, _fullFileName, _uploadFormName);
end;

procedure jHttpClient.UploadFile(_url: string; _fullFileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'UploadFile', _url, _fullFileName);
end;

procedure jHttpClient.SetUploadFormName(_uploadFormName: string);
begin
  //in designing component state: set value here...
  FUploadFormName := _uploadFormName;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetUploadFormName', _uploadFormName);
end;

procedure jHttpClient.SetUnvaluedNameData(_unvaluedName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetUnvaluedNameData', _unvaluedName);
end;

procedure jHttpClient.SetEncodeValueData(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEncodeValueData', _value);
end;

procedure jHttpClient.PostSOAPDataAsync(_SOAPData: string; _stringUrl: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'PostSOAPDataAsync', _SOAPData, _stringUrl);
end;

function jHttpClient.PostJSONData(_strURI: string; _jsonData: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tt_out_t(gApp.jni.jEnv, FjObject, 'PostJSONData',
      _strURI, _jsonData);
end;

{ jSMTPClient }

//by jmpessoa: warning: not tested!

constructor jSMTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FMails := TStringList.Create;
  FMailMessage := TStringList.Create;
  FMailTo := '';
  FMailCc := '';
  FMailBcc := '';
  FMailSubject := '';
end;

destructor jSMTPClient.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin

  end;

  if FMails <> nil then FMails.Free;
  if FMailMessage <> nil then FMailMessage.Free;

  inherited Destroy;
end;

procedure jSMTPClient.Init;
begin
  if FInitialized then Exit;
  inherited Init;
(*  TODO
 for i:= 0 to FMails.Count - 1 do
 begin
  if Trim(FMails.Strings[i]) <> '' then
    Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
 end;  *)
  FInitialized := True;
end;

procedure jSMTPClient.SetMails(Value: TStrings);
begin
  if Value = nil then exit;
  if FMails = nil then exit;

  FMails.Assign(Value);
end;

procedure jSMTPClient.SetMailMessage(Value: TStrings);
begin
  if Value = nil then exit;
  if FMailMessage = nil then exit;

  FMailMessage.Assign(Value);
end;

procedure jSMTPClient.Send;
begin
  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then
    jSend_Email(gApp.Jni.jEnv, gApp.Jni.jThis,
      FMailTo,              //to
      FMailCc,              //cc
      FMailBcc,             //bcc
      FMailSubject,         //subject
      FMailMessage.Text);   //message
end;

function jSMTPClient.IsEmailValid(_email: string): boolean;
const
  charslist = ['_', '-', '.', '0'..'9', 'A'..'Z', 'a'..'z'];
var
  Arobasc, lastpoint: boolean;
  i, n: integer;
  c: char;
begin
  Result := False;

  if not FInitialized then exit;

  n := length(_email);

  if n = 0 then exit;

  i := 1;
  Arobasc := False;
  lastpoint := False;

  while (i <= n) do
  begin
    c := _email[i];

    if c = '@' then
    begin
      if Arobasc or (i = 0) then exit;  // Only 1 Arobasc

      Arobasc := True;
    end
    else if (c = '.') and Arobasc then  // at least 1 . after arobasc
    begin
      lastpoint := True;
    end
    else if not (c in charslist) then exit;  // valid chars

    Inc(i);
  end;

  if lastpoint and (_email[n] <> '.') then  // not finish by . and have a . after arobasc
    Result := True;
end;

procedure jSMTPClient.Send(mTo: string; subject: string; msg: string);
begin
  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then
    jSend_Email(gApp.Jni.jEnv, gApp.Jni.jThis,
      mTo,     //to
      '',      //cc
      '',      //bcc
      subject, //subject
      msg);    //message
end;


{jSMS by jmpessoa: warning: not tested!}

constructor jSMS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FContactListDelimiter := ';';
  FMobileNumber := '';
  FContactName := '';
  FLoadMobileContacts := False;

  FSMSMessage := TStringList.Create;

  FContactList := TStringList.Create;
  FContactList.Delimiter := FContactListDelimiter;
end;

destructor jSMS.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin

  end;

  if FSMSMessage <> nil then FSMSMessage.Free;
  if FContactList <> nil then FContactList.Free;

  inherited Destroy;
end;

procedure jSMS.Init;
begin
  if FInitialized then Exit;
  inherited Init;

  FInitialized := True;

  if FLoadMobileContacts then GetContactList;
end;

function jSMS.GetContactList: string;
begin
  Result := '';

  if FContactList = nil then exit;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if not FInitialized then exit;

  FContactList.DelimitedText := jContact_getDisplayNameList(gApp.Jni.jEnv,
    gApp.Jni.jThis, FContactListDelimiter);

  Result := FContactList.DelimitedText;
end;

procedure jSMS.SetSMSMessage(Value: TStrings);
begin
  if Value = nil then exit;
  if FSMSMessage = nil then exit;

  FSMSMessage.Assign(Value);
end;

function jSMS.Send(multipartMessage: boolean): integer;
begin
  Result := 0;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FSMSMessage = nil then exit;

  if FInitialized then
  begin
    if (FMobileNumber = '') and (FContactName <> '') then
      FMobileNumber := jContact_getMobileNumberByDisplayName(gApp.Jni.jEnv,
        gApp.Jni.jThis, FContactName);
    if FMobileNumber <> '' then
      Result := jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
        FMobileNumber,     //to
        FSMSMessage.Text,  //message
        multipartMessage);
  end;
end;

function jSMS.Send(toName: string; multipartMessage: boolean): integer;
begin
  Result := 0;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FSMSMessage = nil then exit;

  if FInitialized then
  begin
    if toName <> '' then
      FMobileNumber := jContact_getMobileNumberByDisplayName(gApp.Jni.jEnv,
        gApp.Jni.jThis, toName);
    if FMobileNumber <> '' then
      Result := jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
        FMobileNumber,     //to
        FSMSMessage.Text,  //message
        multipartMessage);
  end;
end;

function jSMS.Send(toNumber: string; msg: string; multipartMessage: boolean): integer;
begin
  Result := 0;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then
  begin
    if toNumber <> '' then
      Result := jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
        toNumber,     //to
        msg,  //message
        multipartMessage);
  end;
end;

function jSMS.Send(toNumber: string; msg: string; packageDeliveredAction: string;
  multipartMessage: boolean): integer;
begin
  Result := 0;

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then
  begin
    if toNumber <> '' then
      Result := jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
        toNumber,     //to
        msg,  //message
        packageDeliveredAction, multipartMessage);
  end;
end;

function jSMS.Read(intentReceiver: jObject; addressBodyDelimiter: string): string;
begin
  Result := '';

  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then
    Result := jRead_SMS(gApp.Jni.jEnv, gApp.Jni.jThis, intentReceiver,
      addressBodyDelimiter);
  //message
end;

{jCamera warning by jmpessoa: not tested!}
constructor jCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FFilePath := fpathDCIM;
  FFilename := 'photo1.jpg';
  FRequestCode := 12345;
  FAddToGallery := True;
end;

destructor jCamera.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin

  end;
  inherited Destroy;
end;

procedure jCamera.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FInitialized := True;
end;

procedure jCamera.TakePhoto;
var
  strExt: string;
begin
  if FInitialized then
  begin
    if FFileName = '' then FFileName := 'photo1.jpg';
    if Pos('.', FFileName) < 0 then
      FFileName := FFileName + '.jpg'
    else if Pos('.jpg', FFileName) < 0 then
    begin
      //force jpg extension....
      strExt := FFileName;
      FFileName := SplitStr(strExt, '.');
      FFileName := FFileName + '.jpg';
    end;

    Self.FullPathToBitmapFile :=
      jCamera_takePhoto(gApp.jni.jEnv, gApp.jni.jThis,
      GetFilePath(FFilePath),
      FFileName, FRequestCode, FAddToGallery);
  end;
end;

procedure jCamera.TakePhoto(_filename: string; _requestCode: integer);
var
  strExt: string;
begin
  if FInitialized then
  begin
    FRequestCode := _requestCode;
    if Pos('.', _filename) < 0 then
      _filename := _filename + '.jpg'
    else if Pos('.jpg', _filename) < 0 then
    begin
      //force jpg extension....
      strExt := _filename;
      _filename := SplitStr(strExt, '.');
      _filename := _filename + '.jpg';
    end;

    Self.FullPathToBitmapFile :=
      jCamera_takePhoto(gApp.jni.jEnv, gApp.jni.jThis,
      GetFilePath(FFilePath),
      _filename, _requestCode, FAddToGallery);
  end;
end;

//------------------------------------------------------------------------------
// jListView
//------------------------------------------------------------------------------

constructor jListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FWidgetItem := wgNone;
  FDelimiter := '|';
  FTextDecorated := txtNormal;
  FItemLayout := layText;
  FTextSizeDecorated := sdNone;
  FTextAlign := alLeft;
  FTextPosition := posCenter;
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ListViewChange;  //event handle

  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 96;
  FWidth := 100;

  FHighLightSelectedItemColor := colbrDefault;
  FTextColorInfo := colbrDefault;
  FImageItemIdentifier := '';

  FItemPaddingTop := 10;
  FItemPaddingBottom := 10;
  FItemPaddingLeft := 10;
  FItemPaddingRight := 10;

  FTextMarginLeft := 10;
  FTextMarginRight := 10;
  FTextMarginInner := 2;

  FTextWordWrap := False;
  FEnableOnClickTextLeft := False;
  FEnableOnClickTextCenter := False;
  FEnableOnClickTextRight := False;
  FItemTextEllipsis := False;

  FWidgetTextColor := colbrDefault;

end;

destructor jListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;

  if FItems <> nil then FItems.Free;

  inherited Destroy;
end;

procedure jListView.Init;
var
  i: integer;
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;
    if FImageItem <> nil then
    begin
      FImageItem.Init;

      FjObject := jListView_Create2(gApp.jni.jEnv, gApp.jni.jThis, Self,
        Ord(FWidgetItem), FWidgetText,
        FImageItem.GetImage, Ord(FTextDecorated),
        Ord(FItemLayout), Ord(FTextSizeDecorated),
        Ord(FTextAlign), Ord(FTextPosition));

      if FjObject = nil then exit;

      if FWidgetTextColor <> colbrDefault then
        SetWidgetTextColor(FWidgetTextColor);

      if FFontColor <> colbrDefault then
        jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
          GetARGB(FCustomColor, FFontColor));

      if FFontSizeUnit <> unitDefault then
        SetFontSizeUnit(FFontSizeUnit);

      if FFontSize > 0 then
        jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextSize', FFontSize);

      if FFontFace <> ffNormal then
        SetFontFace(FFontFace);

      if FColor <> colbrDefault then
        View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
          GetARGB(FCustomColor, FColor));

      if FItemPaddingTop <> 10 then
        SetItemPaddingTop(FItemPaddingTop);

      if FItemPaddingBottom <> 10 then
        SetItemPaddingBottom(FItemPaddingBottom);

      if FItemPaddingLeft <> 10 then // by ADiV
        SetItemPaddingLeft(FItemPaddingLeft);

      if FItemPaddingRight <> 10 then
        SetItemPaddingRight(FItemPaddingRight);

      if FTextMarginLeft <> 10 then // by ADiV
        SetTextMarginLeft(FTextMarginLeft);

      if FTextMarginRight <> 10 then // by ADiV
        SetTextMarginRight(FTextMarginRight);

      if FTextMarginInner <> 10 then // by ADiV
        SetTextMarginInner(FTextMarginInner);

      if FItems <> nil then
        for i := 0 to FItems.Count - 1 do
          if FItems.Strings[i] <> '' then
            jListView_add22(gApp.jni.jEnv, FjObject, FItems.Strings[i],
              FDelimiter, FImageItem.GetImage);

    end
    else
    begin
      FjObject := jListView_Create3(gApp.jni.jEnv, gApp.jni.jThis, Self,
        Ord(FWidgetItem), FWidgetText,
        Ord(FTextDecorated), Ord(FItemLayout),
        Ord(FTextSizeDecorated), Ord(FTextAlign),
        Ord(FTextPosition));

      if FjObject = nil then exit;

      if FWidgetTextColor <> colbrDefault then
        SetWidgetTextColor(FWidgetTextColor);

      if FFontColor <> colbrDefault then
        jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextColor',
          GetARGB(FCustomColor, FFontColor));

      if FFontSizeUnit <> unitDefault then
        SetFontSizeUnit(FFontSizeUnit);

      if FFontSize > 0 then
        jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextSize', FFontSize);

      if FFontFace <> ffNormal then
        SetFontFace(FFontFace);

      if FColor <> colbrDefault then
        View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
          GetARGB(FCustomColor, FColor));

      if FImageItemIdentifier <> '' then    //ic_launcher
        SetImageByResIdentifier(FImageItemIdentifier);

      if FItemPaddingTop <> 10 then
        SetItemPaddingTop(FItemPaddingTop);

      if FItemPaddingBottom <> 10 then
        SetItemPaddingBottom(FItemPaddingBottom);

      if FItemPaddingLeft <> 10 then // by ADiV
        SetItemPaddingLeft(FItemPaddingLeft);

      if FItemPaddingRight <> 10 then
        SetItemPaddingRight(FItemPaddingRight);

      if FTextMarginLeft <> 10 then // by ADiV
        SetTextMarginLeft(FTextMarginLeft);

      if FTextMarginRight <> 10 then // by ADiV
        SetTextMarginRight(FTextMarginRight);

      if FTextMarginInner <> 10 then // by ADiV
        SetTextMarginInner(FTextMarginInner);

      if FItems <> nil then
        for i := 0 to FItems.Count - 1 do
          if FItems.Strings[i] <> '' then
            jListView_add2(gApp.jni.jEnv, FjObject, FItems.Strings[i], FDelimiter);

    end;

    SetTextWordWrap(FTextWordWrap);

    SetEnableOnClickTextLeft(FEnableOnClickTextLeft);
    SetEnableOnClickTextCenter(FEnableOnClickTextCenter);
    SetEnableOnClickTextRight(FEnableOnClickTextRight);

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_setId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;
    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);

    if FHighLightSelectedItemColor <> colbrDefault then
    begin
      SetHighLightSelectedItemColor(FHighLightSelectedItemColor);
    end;

    if FTextColorInfo <> colbrDefault then
    begin
      SetTextColorInfo(FTextColorInfo);
    end;

    if FItemTextEllipsis then
      jListView_SetItemTextEllipsis(gApp.jni.jEnv, FjObject, FItemTextEllipsis);

  end;

end;

procedure jListView.SetWidget(Value: TWidgetItem);
begin
  FWidgetItem := Value;
  //if FInitialized then
  //jListView_setHasWidgetItem(gApp.jni.jEnv, FjObject , Ord(FHasWidgetItem));
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setWidgetItem', Ord(Value), index);
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer);
begin
  if FInitialized then
    jListView_setWidgetItem3(gApp.jni.jEnv, FjObject, Ord(Value), txt, index);
end;

procedure jListView.SetWidgetTextByIndex(txt: string; index: integer);
begin
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'setWidgetText', txt, index);
end;

procedure jListView.SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextDecorated', Ord(Value), index);
end;

procedure jListView.SetTextSizeDecoratedByIndex(Value: TTextSizeDecorated;
  index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextSizeDecorated', Ord(Value), index);
end;

procedure jListView.SetLayoutByIndex(Value: TItemLayout; index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setItemLayout', Ord(Value), index);
end;

procedure jListView.SetImageByIndex(Value: jObject; index: integer);
begin
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'setImageItem', Value, index);
end;

procedure jListView.SetImageByIndex(imgResIdentifier: string; index: integer); overload;
begin
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'setImageItem', imgResIdentifier, index);
end;


procedure jListView.SetTextAlignByIndex(Value: TTextAlign; index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextAlign', Ord(Value), index);
end;

// by ADiV
procedure jListView.SetTextPositionByIndex(Value: TTextPosition; index: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextPosition', Ord(Value), index);
end;

// by ADiV
procedure jListView.ClearChecked;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ClearChecked');
end;

// by ADiV
function jListView.GetItemsChecked(): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetItemsChecked');
end;

function jListView.IsItemChecked(index: integer): boolean;
begin
  Result := False;
  if FInitialized then
    Result := jni_func_i_out_z(gApp.jni.jEnv, FjObject, 'isItemChecked', index);
end;

procedure jListView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jListView.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jListView.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jListView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jListView.Refresh;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Refresh'); // by ADiV
end;

procedure jListView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor := Value;
  //if (FInitialized = True) and (FFontColor <> colbrDefault ) then
  // jListView_setTextColor2(gApp.jni.jEnv, FjObject , GetARGB(FCustomColor, FFontColor), index);
  //jListView_setTextColor(gApp.jni.jEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

procedure jListView.SetFontColorByIndex(Value: TARGBColorBridge; index: integer);
begin
  //FFontColor:= Value;
  if FInitialized and (Value <> colbrDefault) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextColor2',
      GetARGB(FCustomColor, Value), index);
end;

procedure jListView.SetFontSize(Value: DWord);
begin
  FFontSize := Value;
  if FInitialized and (FFontSize > 0) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'setTextSizeAll', FFontSize);
end;

procedure jListView.SetFontSizeByIndex(Value: DWord; index: integer);
begin
  //FFontSize:= Value;
  if FInitialized and (Value > 0) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setTextSize2', Value, index);
end;

// by ADiV
function jListView.GetFontSizeByIndex(index: integer): integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetFontSizeByIndex', index);
end;

// by ADiV
procedure jListView.SetDrawAlphaBackground(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetDrawAlphaBackground', _alpha);
end;

// LORDMAN 2013-08-07
procedure jListView.SetItemPosition(Value: TXY);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'setItemPosition', Value.X, Value.Y);
end;

procedure jListView.Add(item: string; delim: string);
begin
  if FItems = nil then exit;

  if item <> '' then
  begin
    FItems.Add(item);
    if FInitialized then
      jListView_add2(gApp.jni.jEnv, FjObject, item, delim);
  end;
end;

procedure jListView.Insert(_index: integer; item: string; _delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jListView_Insert(gApp.jni.jEnv, FjObject, _index, item, _delimiter);
end;

procedure jListView.Insert(_index: integer; item: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jListView_Insert(gApp.jni.jEnv, FjObject, _index, item, FDelimiter);
end;


procedure jListView.Add(item: string);
begin
  if FItems = nil then exit;

  if item <> '' then
  begin
    FItems.Add(item);
    if FInitialized then
      jListView_add2(gApp.jni.jEnv, FjObject, item, FDelimiter);
  end;
end;

procedure jListView.Add(item: string; delim: string; fontColor: TARGBColorBridge;
  fontSize: integer; hasWidget: TWidgetItem;
  widgetText: string; image: jObject);
begin
  if FItems = nil then exit;

  if item <> '' then
  begin
    FItems.Add(item);
    if FInitialized then
      jListView_add3(gApp.jni.jEnv, FjObject, item,
        delim, GetARGB(FCustomColor, fontColor), fontSize, Ord(hasWidget),
        widgetText, image);
  end;
end;

function jListView.GetItemText(index: integer): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'getItemText', index);
end;

function jListView.GetCount: integer;
begin
  Result := 0;

  if FItems = nil then exit;

  Result := FItems.Count;

  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetSize');
end;

procedure jListView.Delete(index: integer);
begin
  if FItems = nil then exit;

  if (index >= 0) and (index < FItems.Count) then
  begin
    FItems.Delete(index);
    if FInitialized then
      jni_proc_i(gApp.jni.jEnv, FjObject, 'delete', index);
  end;
end;

procedure jListView.Clear;
begin
  if not FInitialized then exit;
  if FItems = nil then exit;

  FItems.Clear;
  jni_proc(gApp.jni.jEnv, FjObject, 'clear');
end;

procedure jListView.SetItems(Value: TStrings);
var
  i: integer;
begin
  if Value = nil then exit;
  if FItems = nil then exit;

  FItems.Assign(Value);

  if FInitialized then
  begin
    for i := 0 to FItems.Count - 1 do
    begin
      if FItems.Strings[i] <> '' then
        jListView_add2(gApp.jni.jEnv, FjObject, FItems.Strings[i], FDelimiter);
    end;
  end;

end;

//by jmpessoa
procedure jListView.ListViewChange(Sender: TObject);
//var
//i: integer;
begin
{  if FInitialized then
  begin
    jListView_clear(gApp.jni.jEnv, FjObject );
    for i:= 0 to FItems.Count - 1 do
    begin
       jListView_add2(gApp.jni.jEnv, FjObject , FItems.Strings[i],
                                    FDelimiter, GetARGB(FCustomColor, FFontColor), FFontSize, FWidgetText, Ord(FWidgetItem));
    end;
  end; }
end;

procedure jListView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jListView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FImageItem then
    begin
      FImageItem := nil;
    end;
  end;
end;

procedure jListView.SetImage(Value: jBitmap);
begin

  if Value <> FImageItem then
  begin
    if FImageItem <> nil then
      if Assigned(FImageItem) then
        FImageItem.RemoveFreeNotification(Self); //remove free notification...

    FImageItem := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;
end;

procedure jListView.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jListView.SetVisibilityGone();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetVisibilityGone');
end;

// Event : Java -> Pascal
procedure jListView.GenEvent_OnClickCaptionItem(Obj: TObject;
  index: integer; Caption: string);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Obj, index, Caption);
end;

//by ADiV
procedure jListView.GenEvent_OnClickTextLeft(Obj: TObject; index: integer;
  Caption: string);
begin
  if Assigned(FOnClickTextLeft) then FOnClickTextLeft(Obj, index, Caption);
end;

//by ADiV
procedure jListView.GenEvent_OnClickTextCenter(Obj: TObject; index: integer;
  Caption: string);
begin
  if Assigned(FOnClickTextCenter) then FOnClickTextCenter(Obj, index, Caption);
end;

//by ADiV
procedure jListView.GenEvent_OnClickTextRight(Obj: TObject; index: integer;
  Caption: string);
begin
  if Assigned(FOnClickTextRight) then FOnClickTextRight(Obj, index, Caption);
end;

procedure jListView.GenEvent_OnWidgeItemLostFocus(Obj: TObject;
  index: integer; Caption: string);
begin
  if Assigned(FOnWidgeItemLostFocus) then FOnWidgeItemLostFocus(Obj, index, Caption);
end;

procedure jListView.GenEvent_OnBeforeDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

procedure jListView.GenEvent_OnAfterDispatchDraw(Obj: TObject;
  canvas: JObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jListView.GenEvent_OnClickWidgetItem(Obj: TObject; index: integer;
  Checked: boolean);
begin
  if Assigned(FOnClickWidgetItem) then FOnClickWidgetItem(Obj, index, Checked);
end;

//by ADiV
procedure jListView.GenEvent_OnClickImageItem(Obj: TObject; index: integer);
begin
  if Assigned(FOnClickImageItem) then FOnClickImageItem(Obj, index);
end;

procedure jListView.GenEvent_OnLongClickCaptionItem(Obj: TObject;
  index: integer; Caption: string);
begin
  if Assigned(FOnLongClickItem) then FOnLongClickItem(Obj, index, Caption);
end;

procedure jListView.GenEvent_OnDrawItemCaptionColor(Obj: TObject;
  index: integer; Caption: string; out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor := colbrDefault;
  color := 0; //default;

  if Assigned(FOnDrawItemTextColor) then
    FOnDrawItemTextColor(Obj, index, Caption, outColor);

  if (outColor <> colbrNone) and (outColor <> colbrDefault) then
    color := GetARGB(FCustomColor, outColor);
end;

procedure jListView.GenEvent_OnListViewDrawItemCustomFont(Sender: TObject;
  position: integer; Caption: string; var outCustomFontName: string);
var
  outFontName: string;
begin
  outFontName := '';

  if Assigned(FOnDrawItemCustomFont) then
    FOnDrawItemCustomFont(Sender, position, Caption, outFontName);

  outCustomFontName := outFontName;

end;

// by ADiV
procedure jListView.GenEvent_OnDrawItemBackgroundColor(Obj: TObject;
  index: integer; out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor := colbrDefault;
  color := 0; //default;
  if Assigned(FOnDrawItemBackColor) then FOnDrawItemBackColor(Obj, index, outColor);
  if (outColor <> colbrNone) and (outColor <> colbrDefault) then
    color := GetARGB(FCustomColor, outColor);
end;

procedure jListView.GenEvent_OnDrawItemWidgetTextColor(Obj: TObject;
  index: integer; Caption: string; out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor := colbrDefault;
  color := 0;    //default;

  if Assigned(FOnDrawItemWidgetTextColor) then
    FOnDrawItemWidgetTextColor(Obj, index, Caption, outColor);

  if (outColor <> colbrNone) and (outColor <> colbrDefault) then
    color := GetARGB(FCustomColor, outColor);

end;

procedure jListView.GenEvent_OnDrawItemWidgetText(Obj: TObject;
  index: integer; Caption: string; out newtext: string);
var
  outText: string;
begin
  outText := '';
  if Assigned(FOnDrawItemWidgetText) then
    FOnDrawItemWidgetText(Obj, index, Caption, outText);
  newtext := outText;
end;

procedure jListView.GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer;
  Caption: string; out bitmap: JObject);
begin
  bitmap := nil;
  if Assigned(FOnDrawItemBitmap) then FOnDrawItemBitmap(Obj, index, Caption, bitmap);
end;

procedure jListView.GenEvent_OnDrawItemWidgetBitmap(Obj: TObject;
  index: integer; Caption: string; out bitmap: JObject);
begin
  bitmap := nil;
  if Assigned(FOnDrawItemWidgetBitmap) then
    FOnDrawItemWidgetBitmap(Obj, index, Caption, bitmap);
end;

procedure jListView.GenEvent_OnScrollStateChanged(Obj: TObject;
  firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer;
  lastItemReached: boolean);
begin
  if Assigned(FOnScrollStateChanged) then
    FOnScrollStateChanged(Obj, firstVisibleItem, visibleItemCount,
      totalItemCount, lastItemReached);
end;

// by ADiV
procedure jListView.SetTextColorInfo(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FTextColorInfo := _color;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextColorInfo',
      GetARGB(FCustomColor, _color));
end;

// by ADiV
procedure jListView.SetTextColorInfoByIndex(Value: TARGBColorBridge; index: integer);
begin
  //FFontColor:= Value;
  if FInitialized and (Value <> colbrDefault) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetTextColorInfoByIndex',
      GetARGB(FCustomColor, Value), index);
end;

procedure jListView.SetHighLightSelectedItemColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHighLightSelectedItemColor := _color;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetHighLightSelectedItemColor',
      GetARGB(FCustomColor, _color));
end;

function jListView.GetItemIndex(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetItemIndex');
end;

function jListView.GetItemCaption(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_t(gApp.jni.jEnv, FjObject, 'GetItemCaption');
end;

procedure jListView.DispatchOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnDrawItemTextColor', _value);
end;

procedure jListView.DispatchOnDrawItemBitmap(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnDrawItemBitmap', _value);
end;

procedure jListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

procedure jListView.SetFontFace(AValue: TFontFace);
begin
  FFontFace := AValue;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontFace', Ord(FFontFace));
end;

procedure jListView.SetItemLayout(_itemLayout: TItemLayout);
begin
  FItemLayout := _itemLayout;

  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetItemLayout', Ord(FItemLayout));
end;

procedure jListView.SetTextAlign(_textAlign: TTextAlign);
begin
  FTextAlign := _textAlign;

  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextAlign', Ord(FTextAlign));
end;

function jListView.GetWidgetText(_index: integer): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetWidgetText', _index);
end;

procedure jListView.SetWidgetCheck(_value: boolean; _index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jListView_setWidgetCheck(gApp.jni.jEnv, FjObject, _value, _index);
end;

function jListView.GetWidgetCheck(_index: integer): boolean;
begin
  Result := False;

  //in designing component state: set value here...
  if FInitialized then
    Result := jni_func_i_out_z(gApp.jni.jEnv, FjObject, 'getWidgetCheck', _index);
end;

procedure jListView.SetItemTagString(_tagString: string; _index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'setItemTagString', _tagString, _index);
end;


function jListView.GetItemTagString(_index: integer): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'getItemTagString', _index);
end;

function jListView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jListView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

function jListView.GetTotalHeight: integer;
begin
  Result := FHeight;
  if FInitialized then
  begin
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getTotalHeight');
  end;
end;

function jListView.GetItemHeight(aItemIndex: integer): integer;
begin
  Result := 0;
  if FInitialized then
  begin
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'getItemHeight', aItemIndex);
  end;
end;

procedure jListView.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageItemIdentifier := _imageResIdentifier;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetImageByResIdentifier', _imageResIdentifier);
end;

procedure jListView.SetLeftDelimiter(_leftDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetLeftDelimiter', _leftDelimiter);
end;

procedure jListView.SetRightDelimiter(_rightDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetRightDelimiter', _rightDelimiter);
end;

function jListView.GetCenterItemCaption(_fullItemCaption: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetCenterItemCaption',
      _fullItemCaption);
end;

function jListView.GetLeftItemCaption(_fullItemCaption: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetLeftItemCaption',
      _fullItemCaption);
end;

function jListView.GetRightItemCaption(_fullItemCaption: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetRightItemCaption',
      _fullItemCaption);
end;

function jListView.GetLongPressSelectedItem(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetLongPressSelectedItem');
end;

procedure jListView.SetAllPartsOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllPartsOnDrawItemTextColor', _value);
end;

procedure jListView.SetItemPaddingTop(_ItemPaddingTop: integer);
begin
  //in designing component state: set value here...
  FItemPaddingTop := _ItemPaddingTop;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetItemPaddingTop', _ItemPaddingTop);
end;

procedure jListView.SetItemPaddingBottom(_itemPaddingBottom: integer);
begin
  //in designing component state: set value here...
  FItemPaddingBottom := _itemPaddingBottom;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetItemPaddingBottom', _itemPaddingBottom);
end;

// by ADiV
procedure jListView.SetItemPaddingLeft(_itemPaddingLeft: integer);
begin
  //in designing component state: set value here...
  FItemPaddingLeft := _itemPaddingLeft;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetItemPaddingLeft', _itemPaddingLeft);
end;

procedure jListView.SetItemPaddingRight(_itemPaddingRight: integer);
begin
  //in designing component state: set value here...
  FItemPaddingRight := _itemPaddingRight;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetItemPaddingRight', _itemPaddingRight);
end;

procedure jListView.SetTextMarginLeft(_left: integer);
begin
  //in designing component state: set value here...
  FTextMarginLeft := _left;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextMarginLeft', _left);
end;

procedure jListView.SetTextMarginRight(_right: integer);
begin
  //in designing component state: set value here...
  FTextMarginRight := _right;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextMarginRight', _right);
end;

procedure jListView.SetTextMarginInner(_inner: integer);
begin
  //in designing component state: set value here...
  FTextMarginInner := _inner;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTextMarginInner', _inner);
end;

procedure jListView.SetWidgetImageSide(_side: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetWidgetImageSide', _side);
end;

procedure jListView.SetTextWordWrap(_value: boolean);
begin
  //in designing component state: set value here...
  FTextWordWrap := _value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetItemCenterWordWrap', _value);
end;

// by ADiV
procedure jListView.SetEnableOnClickTextLeft(_value: boolean);
begin
  //in designing component state: set value here...
  FEnableOnClickTextLeft := _value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnableOnClickTextLeft', _value);
end;

// by ADiV
procedure jListView.SetEnableOnClickTextCenter(_value: boolean);
begin
  //in designing component state: set value here...
  FEnableOnClickTextCenter := _value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnableOnClickTextCenter', _value);
end;

// by ADiV
procedure jListView.SetEnableOnClickTextRight(_value: boolean);
begin
  //in designing component state: set value here...
  FEnableOnClickTextRight := _value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnableOnClickTextRight', _value);
end;

procedure jListView.SetMaxLinesFirstString(_value: integer);
begin
  //in designing component state: set value here...
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetMaxLinesFirstString', _value);
end;

// by ADiV
procedure jListView.SetItemText(txt: string; index: integer);
begin
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'setItemTextByIndex', txt, index);
end;

// by ADiV
procedure jListView.SetWidgetOnTouch(_ontouch: boolean);
begin
  //in designing component state: result value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetWidgetOnTouch', _ontouch);
end;

procedure jListView.SetWidgetTextColor(_textcolor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FWidgetTextColor := _textcolor;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetWidgetTextColor',
    GetARGB(FCustomColor, _textcolor));
end;

procedure jListView.SetDispatchOnDrawItemWidgetTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetDispatchOnDrawItemWidgetTextColor', _value);
end;

procedure jListView.SetDispatchOnDrawItemWidgetText(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetDispatchOnDrawItemWidgetText', _value);
end;

procedure jListView.SetWidgetInputTypeIsCurrency(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetWidgetInputTypeIsCurrency', _value);
end;

procedure jListView.SetWidgetFontFromAssets(_customFontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetWidgetFontFromAssets', _customFontName);
end;

procedure jListView.DispatchOnDrawWidgetItemWidgetTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject,
      'DispatchOnDrawWidgetItemWidgetTextColor', _value);
end;

procedure jListView.DispatchOnDrawItemWidgetImage(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnDrawItemWidgetImage', _value);
end;

procedure jListView.SetBackgroundByResIdentifier(_imgResIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetBackgroundByResIdentifier',
      _imgResIdentifier);
end;

function jListView.SplitCenterItemCaption(_centerItemCaption: string;
  _delimiter: string): TDynArrayOfString;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jListView_SplitCenterItemCaption(gApp.jni.jEnv, FjObject,
      _centerItemCaption, _delimiter);
end;

procedure jListView.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetSelection', _index);
end;

procedure jListView.SmoothScrollToPosition(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SmoothScrollToPosition', _index);
end;

procedure jListView.SetItemChecked(_index: integer; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_iz(gApp.jni.jEnv, FjObject, 'SetItemChecked', _index, _value);
end;

function jListView.GetCheckedItemPosition(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetCheckedItemPosition');
end;

procedure jListView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

procedure jListView.DisableScroll(_disable: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DisableScroll', _disable);
end;

procedure jListView.SetFastScrollEnabled(_enable: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFastScrollEnabled', _enable);
end;

procedure jListView.SaveToFile(_appInternalFileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SaveToFile', _appInternalFileName);
end;

procedure jListView.LoadFromFile(_appInternalFileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jListView_LoadFromFile(gApp.jni.jEnv, FjObject, _appInternalFileName);
end;


procedure jListView.SetFilterQuery(_query: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetFilterQuery', _query);
end;

procedure jListView.SetFilterQuery(_query: string; _filterMode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetFilterQuery', _query, _filterMode);
end;

procedure jListView.SetFilterMode(_filterMode: TFilterMode);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFilterMode', Ord(_filterMode));
end;

procedure jListView.ClearFilterQuery();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ClearFilterQuery');
end;

procedure jListView.SetDrawItemBackColorAlpha(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetDrawItemBackColorAlpha', _alpha);
end;

procedure jListView.DispatchOnDrawItemTextCustomFont(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnDrawItemTextCustomFont', _value);
end;

procedure jListView.SetItemTextEllipsis(_value: boolean);
begin
  //in designing component state: set value here...
  FItemTextEllipsis := _value;
  if FInitialized then
    jListView_SetItemTextEllipsis(gApp.jni.jEnv, FjObject, _value);
end;

//------------------------------------------------------------------------------
// jScrollView
//------------------------------------------------------------------------------

constructor jScrollView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FScrollSize := 800; //to scrolling images this number could be higher....
  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 96;
  FWidth := 100;
  FAcceptChildrenAtDesignTime := True;
  FFillViewportEnabled := False;
end;

destructor jScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jScrollView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jScrollView_jCreate(gApp.jni.jEnv, int64(Self),
      Ord(FInnerLayout), gApp.jni.jThis);

    if FjObject = nil then exit;

    //FjRLayout:= jScrollView_getView(gApp.jni.jEnv, FjObject ); //Self.View

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True;

    SetScrollSize(FScrollSize);

    if FFillViewportEnabled then
      SetFillViewport(FFillViewportEnabled);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;
end;

procedure jScrollView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jScrollView.RemoveFromViewParent;
begin
  //if FInitialized then
  // jScrollView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jScrollView.GetView: jObject;
begin
  Result := nil;
  if FInitialized then
    Result := View_GetViewGroup(gApp.jni.jEnv, FjObject);
end;

procedure jScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jScrollView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setScrollSize', FScrollSize);
end;

procedure jScrollView.SetInnerLayout(layout: TScrollInnerLayout);
begin
  FInnerLayout := layout;
end;

procedure jScrollView.ClearLayout;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jScrollView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jScrollView.SetFillViewport(fillenabled: boolean);
begin
  //in designing component state: set value here...
  FFillViewportEnabled := fillenabled;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setFillViewport', fillenabled);
end;


procedure jScrollView.ScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'ScrollTo', _x, _y);
end;

procedure jScrollView.SmoothScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SmoothScrollTo', _x, _y);
end;

procedure jScrollView.SmoothScrollBy(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SmoothScrollBy', _x, _y);
end;

function jScrollView.GetScrollX(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetScrollX');
end;

function jScrollView.GetScrollY(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetScrollY');
end;

function jScrollView.GetBottom(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetBottom');
end;

function jScrollView.GetTop(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetTop');
end;

function jScrollView.GetLeft(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetLeft');
end;

function jScrollView.GetRight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetRight');
end;

function jScrollView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jScrollView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jScrollView.DispatchOnScrollChangedEvent(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnScrollChangedEvent', _value);
end;

procedure jScrollView.AddView(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jScrollView_AddView(gApp.jni.jEnv, FjObject, _view);
end;

procedure jScrollView.AddImage(_bitmap: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'AddImage', _bitmap);
end;

procedure jScrollView.AddImageFromFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'AddImageFromFile', _path, _filename);
end;

procedure jScrollView.AddImageFromAssets(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AddImageFromAssets', _filename);
end;

procedure jScrollView.AddImage(_bitmap: jObject; _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'AddImage', _bitmap, _itemId);
end;

procedure jScrollView.AddImageFromFile(_path: string; _filename: string;
  _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tti(gApp.jni.jEnv, FjObject, 'AddImageFromFile',
      _path, _filename, _itemId);
end;

procedure jScrollView.AddImageFromAssets(_filename: string; _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'AddImageFromAssets', _filename, _itemId);
end;

procedure jScrollView.AddText(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AddText', _text);
end;

procedure jScrollView.AddImage(_bitmap: jObject; _itemId: integer;
  _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_ii(gApp.jni.jEnv, FjObject, 'AddImage',
      _bitmap, _itemId, Ord(_scaleType));
end;

procedure jScrollView.AddImageFromFile(_path: string; _filename: string;
  _itemId: integer; _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ttii(gApp.jni.jEnv, FjObject, 'AddImageFromFile',
      _path, _filename, _itemId, Ord(_scaleType));
end;

procedure jScrollView.AddImageFromAssets(_filename: string; _itemId: integer;
  _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tii(gApp.jni.jEnv, FjObject, 'AddImageFromAssets',
      _filename, _itemId, Ord(_scaleType));
end;

function jScrollView.GetInnerItemId(_index: integer): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetInnerItemId', _index);
end;

function jScrollView.GetInnerItemIndex(_itemId: integer): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetInnerItemIndex', _itemId);
end;

procedure jScrollView.Delete(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'Delete', _index);
end;

procedure jScrollView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jScrollView.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jScrollView.GenEvent_OnChanged(Obj: TObject; currHor: integer;
  currVerti: integer; prevHor: integer; prevVertical: integer;
  onPosition: integer; scrolldiff: integer);
begin
  if Assigned(FOnScrollChanged) then
    FOnScrollChanged(Obj, currHor, currVerti, prevHor, prevVertical, TScrollPosition(onPosition),
      scrolldiff);
end;

procedure jScrollView.GenEvent_OnScrollViewInnerItemClick(Sender: TObject; itemId: integer);
begin
  if Assigned(FOnInnerItemClick) then FOnInnerItemClick(Sender, itemId);
end;

procedure jScrollView.GenEvent_OnScrollViewInnerItemLongClick(Sender: TObject;
  index: integer; itemId: integer);
begin
  if Assigned(FOnInnerItemLongClick) then FOnInnerItemLongClick(Sender, index, itemId);
end;

//------------------------------------------------------------------------------
// jHorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------

constructor jHorizontalScrollView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FScrollSize := 800; //to scrolling images this number could be higher....

  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 96;
  FWidth := 100;
  FAcceptChildrenAtDesignTime := True;
end;

destructor jHorizontalScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jHorizontalScrollView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jHorizontalScrollView_jCreate(gApp.jni.jEnv, int64(Self)
      , Ord(FInnerLayout), gApp.jni.jThis);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True;

    SetScrollSize(FScrollSize);
    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

end;

procedure jHorizontalScrollView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jHorizontalScrollView.RemoveFromViewParent;
begin
  //if FInitialized then
  // jHorizontalScrollView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jHorizontalScrollView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jHorizontalScrollView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

function jHorizontalScrollView.GetView: jObject;
begin
  Result := nil;
  if FInitialized then
    Result := View_GetViewGroup(gApp.jni.jEnv, FjObject);
end;

procedure jHorizontalScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jHorizontalScrollView.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jHorizontalScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setScrollSize', FScrollSize);
end;

procedure jHorizontalScrollView.SetInnerLayout(layout: TScrollInnerLayout);
begin
  FInnerLayout := layout;
end;

procedure jHorizontalScrollView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jHorizontalScrollView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jHorizontalScrollView.ScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'ScrollTo', _x, _y);
end;

procedure jHorizontalScrollView.SmoothScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SmoothScrollTo', _x, _y);
end;

procedure jHorizontalScrollView.SmoothScrollBy(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SmoothScrollBy', _x, _y);
end;

function jHorizontalScrollView.GetScrollX(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetScrollX');
end;

function jHorizontalScrollView.GetScrollY(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetScrollY');
end;

function jHorizontalScrollView.GetBottom(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetBottom');
end;

function jHorizontalScrollView.GetTop(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetTop');
end;

function jHorizontalScrollView.GetLeft(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetLeft');
end;

function jHorizontalScrollView.GetRight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetRight');
end;

procedure jHorizontalScrollView.DispatchOnScrollChangedEvent(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnScrollChangedEvent', _value);
end;

procedure jHorizontalScrollView.AddView(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_viw(gApp.jni.jEnv, FjObject, 'AddView', _view);
end;

procedure jHorizontalScrollView.AddImage(_bitmap: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'AddImage', _bitmap);
end;

procedure jHorizontalScrollView.AddImageFromFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'AddImageFromFile', _path, _filename);
end;

procedure jHorizontalScrollView.AddImageFromAssets(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AddImageFromAssets', _filename);
end;

procedure jHorizontalScrollView.AddImage(_bitmap: jObject; _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_i(gApp.jni.jEnv, FjObject, 'AddImage', _bitmap, _itemId);
end;

procedure jHorizontalScrollView.AddImageFromFile(_path: string;
  _filename: string; _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tti(gApp.jni.jEnv, FjObject, 'AddImageFromFile',
      _path, _filename, _itemId);
end;

procedure jHorizontalScrollView.AddImageFromAssets(_filename: string; _itemId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'AddImageFromAssets', _filename, _itemId);
end;

procedure jHorizontalScrollView.AddText(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'AddText', _text);
end;

procedure jHorizontalScrollView.AddImage(_bitmap: jObject; _itemId: integer;
  _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_ii(gApp.jni.jEnv, FjObject, 'AddImage',
      _bitmap, _itemId, Ord(_scaleType));
end;

procedure jHorizontalScrollView.AddImageFromFile(_path: string;
  _filename: string; _itemId: integer; _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ttii(gApp.jni.jEnv, FjObject, 'AddImageFromFile',
      _path, _filename, _itemId, Ord(_scaleType));
end;

procedure jHorizontalScrollView.AddImageFromAssets(_filename: string;
  _itemId: integer; _scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tii(gApp.jni.jEnv, FjObject, 'AddImageFromAssets',
      _filename, _itemId, Ord(_scaleType));
end;

function jHorizontalScrollView.GetInnerItemId(_index: integer): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetInnerItemId', _index);
end;

function jHorizontalScrollView.GetInnerItemIndex(_itemId: integer): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetInnerItemIndex', _itemId);
end;

procedure jHorizontalScrollView.Delete(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'Delete', _index);
end;

procedure jHorizontalScrollView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jHorizontalScrollView.GenEvent_OnChanged(Obj: TObject;
  currHor: integer; currVerti: integer; prevHor: integer; prevVertical: integer;
  onPosition: integer; scrolldiff: integer);
begin
  if Assigned(FOnScrollChanged) then
    FOnScrollChanged(Obj, currHor, currVerti, prevHor, prevVertical, TScrollPosition(onPosition),
      scrolldiff);
end;

procedure jHorizontalScrollView.GenEvent_OnScrollViewInnerItemClick(Sender: TObject;
  itemId: integer);
begin
  if Assigned(FOnInnerItemClick) then FOnInnerItemClick(Sender, itemId);
end;

procedure jHorizontalScrollView.GenEvent_OnScrollViewInnerItemLongClick(Sender: TObject;
  index: integer; itemId: integer);
begin
  if Assigned(FOnInnerItemLongClick) then FOnInnerItemLongClick(Sender, index, itemId);
end;

//------------------------------------------------------------------------------
// jWebView
//------------------------------------------------------------------------------

constructor jWebView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FJavaScript := True;
  FZoomControl := True;
  FDomStorage := True;

  FOnStatus := nil;
  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 96;
  FWidth := 100;
end;

destructor jWebView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jWebView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;
    FjObject := jWebView_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    if FJavaScript <> True then
      SetJavaScript(FJavaScript);

    if FDomStorage <> True then
      SetDomStorage(FDomStorage);

    if FZoomControl <> True then
      SetZoomControl(FZoomControl);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

end;

procedure jWebView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jWebView.RemoveFromViewParent;
begin
  //if FInitialized then
  // jWebView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jWebView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jWebView.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jWebView.SetJavaScript(Value: boolean);
begin
  FJavaScript := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'setJavaScript', FJavaScript);
end;

procedure jWebView.SetZoomControl(Value: boolean);
begin
  if (Value <> FZoomControl) then
  begin
    FZoomControl := Value;
    if FjObject = nil then exit;

    jni_proc_z(gApp.jni.jEnv, FjObject, 'setZoomControl', FZoomControl);
  end;
end;

procedure jWebView.Navigate(url: string);
begin
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'loadUrl', url);
end;

procedure jWebView.LoadFromHtmlFile(environmentDirectoryPath: string;
  htmlFileName: string);
begin
  ;
  if FjObject = nil then exit;

  Navigate('file://' + environmentDirectoryPath + '/' + htmlFileName);
end;

procedure jWebView.LoadFromHtmlString(_htmlString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'LoadFromHtmlString', _htmlString);
end;

procedure jWebView.ClearHistory();  // By ADiV
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ClearHistory');
end;

procedure jWebView.ClearCache(_clearDiskFiles: boolean); // By ADiV
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'ClearCache', _clearDiskFiles);
end;

function jWebView.CanGoBack(): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'CanGoBack');
end;

function jWebView.CanGoBackOrForward(_steps: integer): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_z(gApp.jni.jEnv, FjObject, 'CanGoBackOrForward', _steps);
end;

function jWebView.CanGoForward(): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'CanGoForward');
end;

procedure jWebView.GoBack();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'GoBack');
end;

procedure jWebView.GoBackOrForward(steps: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'GoBackOrForward', steps);
end;

procedure jWebView.GoForward();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'GoForward');
end;

procedure jWebView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jWebView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;


procedure jWebView.SetHttpAuthUsernamePassword(_hostName: string;
  _domain: string; _username: string; _password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jWebView_SetHttpAuthUsernamePassword(gApp.jni.jEnv, FjObject,
      _hostName, _domain, _username, _password);
end;

// Event : Java -> Pascal
procedure jWebView.GenEvent_OnLongClick(Obj: TObject);
begin
  if Assigned(FOnLongClick) then FOnLongClick(Obj);
end;

procedure jWebView.ScrollTo(_x, _y: integer);
begin
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'scrollTo', _x, _y);
end;

//LMB
function jWebView.ScrollY: integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getScrollY');
end;

//LMB
procedure jWebView.LoadDataWithBaseURL(s1, s2, s3, s4, s5: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jWebView_LoadDataWithBaseURL(gApp.jni.jEnv, FjObject, s1, s2, s3, s4, s5);
end;

//LMB
procedure jWebView.FindAll(_s: string);
begin
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'findAllAsync', _s);
end;

//LMB
procedure jWebView.FindNext(_forward: boolean);
begin
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'findNext', _forward);
end;

//LMB
procedure jWebView.ClearMatches();
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'clearMatches');
end;

//LMB
function jWebView.GetFindIndex: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getFindIndex');
end;

//LMB
function jWebView.GetFindCount: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getFindCount');
end;

function jWebView.GetWidth: integer;
begin
  Result := fWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getWidth');
end;

function jWebView.GetHeight: integer;
begin
  Result := fHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getHeight');
end;

//by segator
procedure jWebView.CallEvaluateJavascript(_jsInnerCode: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'CallEvaluateJavascript', _jsInnerCode);
end;

procedure jWebView.SetDomStorage(_domStorage: boolean);
begin
  //in designing component state: set value here...
  FDomStorage := _domStorage;

  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetDomStorage', _domStorage);
end;

procedure jWebView.SetLoadWithOverviewMode(_overviewMode: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetLoadWithOverviewMode', _overviewMode);
end;

procedure jWebView.SetUseWideViewPort(_wideViewport: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetUseWideViewPort', _wideViewport);
end;

procedure jWebView.SetAllowContentAccess(_allowContentAccess: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllowContentAccess', _allowContentAccess);
end;

procedure jWebView.SetAllowFileAccess(_allowFileAccess: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllowFileAccess', _allowFileAccess);
end;

procedure jWebView.SetAppCacheEnabled(_cacheEnabled: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAppCacheEnabled', _cacheEnabled);
end;

procedure jWebView.SetDisplayZoomControls(_displayZoomControls: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetDisplayZoomControls', _displayZoomControls);
end;

procedure jWebView.SetGeolocationEnabled(_geolocationEnabled: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetGeolocationEnabled', _geolocationEnabled);
end;

procedure jWebView.SetJavaScriptCanOpenWindowsAutomatically(
  _javaScriptCanOpenWindows: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetJavaScriptCanOpenWindowsAutomatically',
      _javaScriptCanOpenWindows);
end;

procedure jWebView.SetLoadsImagesAutomatically(_loadsImagesAutomatically: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetLoadsImagesAutomatically',
      _loadsImagesAutomatically);
end;

procedure jWebView.SetSupportMultipleWindows(_supportMultipleWindows: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetSupportMultipleWindows',
      _supportMultipleWindows);
end;

procedure jWebView.SetAllowUniversalAccessFromFileURLs(
  _allowUniversalAccessFromFileURLs: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetAllowUniversalAccessFromFileURLs',
      _allowUniversalAccessFromFileURLs);
end;

procedure jWebView.SetMediaPlaybackRequiresUserGesture(
  _mediaPlaybackRequiresUserGesture: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetMediaPlaybackRequiresUserGesture',
      _mediaPlaybackRequiresUserGesture);
end;

procedure jWebView.SetSafeBrowsingEnabled(_safeBrowsingEnabled: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetSafeBrowsingEnabled', _safeBrowsingEnabled);
end;

procedure jWebView.SetSupportZoom(_supportZoom: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetSupportZoom', _supportZoom);
end;

procedure jWebView.SetUserAgent(_userAgent: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetUserAgent', _userAgent);
end;

procedure jWebView.SetInitialScale(_scaleInPercent: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jWebView_SetInitialScale(gApp.jni.jEnv, FjObject, _scaleInPercent);
end;

//by segator
procedure jWebView.GenEvent_OnEvaluateJavascriptResult(Sender: TObject; Data: string);
begin
  if Assigned(FOnEvaluateJavascriptResult) then FOnEvaluateJavascriptResult(Sender, Data);
end;

procedure jWebView.GenEvent_OnWebViewReceivedSslError(Sender: TObject;
  error: string; primaryError: integer; var outReturn: boolean);
begin
  if Assigned(FOnReceivedSslError) then
    FOnReceivedSslError(Sender, error, TWebViewSslError(primaryError), outReturn);
end;

//------------------------------------------------------------------------------
// jBitmap
//------------------------------------------------------------------------------

constructor jBitmap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FWidth := 0;
  FHeight := 0;
  FImageName := '';
  FImageIndex := -1;

  FFilePath := fpathData;

  FjObject := nil;
end;

destructor jBitmap.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jBitmap.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jBitmap_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

  if FjObject = nil then exit;

  FInitialized := True;  //needed here....

  if (FImageIndex < 0) or (FImageList = nil) then
    if FImageName <> '' then
      LoadFromRes(FImageName);

  if FImageList <> nil then
  begin
    FImageList.Init;
    if FImageList.Images.Count > 0 then
    begin
      if FImageIndex >= 0 then SetImageByIndex(FImageIndex);
    end;
  end;

end;

function jBitmap.TryPath(path: string; fileName: string): boolean;
begin
  Result := False;
  if Pos(path, fileName) > 0 then Result := True;
end;

procedure jBitmap.LoadFromFile(fullFileName: string);
var
  path: string;
  knownDir: string;
begin
  if FInitialized then
  begin
    if fullFileName <> '' then
    begin
      path := '';

      if TryPath(gApp.Path.App, fullFileName) then
      begin
        path := gApp.Path.App;
        FFilePath := fpathApp;
      end
      else if TryPath(gApp.Path.Dat, fullFileName) then
      begin
        path := gApp.Path.Dat;
        FFilePath := fpathData;
      end
      else if TryPath(gApp.Path.DCIM, fullFileName) then
      begin
        path := gApp.Path.DCIM;
        FFilePath := fpathDCIM;
      end
      else if TryPath(gApp.Path.Ext, fullFileName) then
      begin
        path := gApp.Path.Ext;
        FFilePath := fpathExt;
      end;

      if path <> '' then
      begin
        knownDir:=GetFilePath(FFilePath) + '/';
        FImageName := Copy(fullFileName, length(knownDir) + 1, length(fullFileName) - length(knownDir));
      end
      else
      begin
        knownDir:='';
        FImageName := fullFileName;
      end;

      jni_proc_t(gApp.jni.jEnv, FjObject, 'loadFile',
         knownDir + FImageName);

      FWidth := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetWidth');
      FHeight := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetHeight');
    end;
  end;
end;


procedure jBitmap.LoadFromRes(imgResIdentifier: string);  // ..res/drawable
begin
  if FInitialized then
  begin
    jni_proc_t(gApp.jni.jEnv, FjObject, 'loadRes', imgResIdentifier);
    FWidth := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetWidth');
    FHeight := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetHeight');
  end;
end;

procedure jBitmap.CreateJavaBitmap(w, h: integer);
begin
  FWidth := 0;
  FHeight := 0;
  if FInitialized then
  begin
    FWidth := w;
    FHeight := h;
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'createBitmap', w, h);
  end;
end;

function jBitmap.GetJavaBitmap: jObject;
begin
  Result := GetImage();
end;

function jBitmap.GetImage(): jObject;
begin
  Result := nil;

  if FInitialized then
    Result := jni_func_out_bmp(gApp.jni.jEnv, FjObject, 'jInstance');

end;

//by Tomash
function jBitmap.GetCanvas(): jObject;
begin
  Result := nil;

  if FInitialized then
    Result := jBitmap_GetCanvas(gApp.jni.jEnv, FjObject);

end;

procedure jBitmap.GetBitmapSizeFromFile(_fullPathFile: string; var w, h: integer);
begin
  if not FInitialized then exit;

  jBitmap_GetBitmapSizeFromFile(gApp.jni.jEnv, FjObject, _fullPathFile, w, h);
end;

function jBitmap.BitmapToArrayOfJByte(var bufferImage: TDynArrayOfJByte): integer;
  //local/self
var
  PJavaPixel: PScanByte; {need by delphi mode!} //PJByte;
  k, row, col: integer;
  w, h: integer;
begin
  Result := 0;

  if not FInitialized then exit;

  if Self.GetInfo then
  begin

    PJavaPixel := nil;
    //point to and lock java bitmap image ...
    Self.LockPixels(PJavaPixel);
    //ok  ... demo API LockPixels - overloaded - paramenter is "PJavaPixel"
    k := 0;
    w := Self.Width;
    h := Self.Height;
    Result := h * w;
    SetLength(bufferImage, Result * 4); //thanks to Prof. Wellington Pinheiro dos Santos
    for row := 0 to h - 1 do  //ok
    begin
      for col := 0 to w - 1 do //ok
      begin
        bufferImage[k * 4] := PJavaPixel^[k * 4]; //delphi mode....
        bufferImage[k * 4 + 1] := PJavaPixel^[k * 4 + 1];
        bufferImage[k * 4 + 2] := PJavaPixel^[k * 4 + 2];
        bufferImage[k * 4 + 3] := PJavaPixel^[k * 4 + 3];
        Inc(k);
      end;
    end;
    Self.UnlockPixels;
  end;
end;

function jBitmap.GetByteArrayFromBitmap(var bufferImage: TDynArrayOfJByte): integer;
begin
  Result := 0;
  if FInitialized then
    Result := jBitmap_GetByteArrayFromBitmap(gApp.jni.jEnv, FjObject, bufferImage);
end;

procedure jBitmap.SetByteArrayToBitmap(var bufferImage: TDynArrayOfJByte; size: integer);
begin
  if FInitialized then
    jBitmap_SetByteArrayToBitmap(gApp.jni.jEnv, FjObject, bufferImage, size);
end;

procedure jBitmap.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FImageList then
    begin
      FImageList := nil;
    end;
  end;
end;

procedure jBitmap.SetImages(Value: jImageList);
begin

  if Value <> FImageList then
  begin
    if FImageList <> nil then
      if Assigned(FImageList) then
        FImageList.RemoveFreeNotification(Self); //remove free notification...

    FImageList := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;

end;

function jBitmap.GetHeight: integer;
begin
  //in designing component state: result value here...
  Result := FHeight;
  if FInitialized then
    Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetHeight');
end;

function jBitmap.GetWidth: integer;
begin
  //in designing component state: result value here...
  Result := FWidth;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetWidth');
end;

procedure jBitmap.SetImageByIndex(Value: integer);
begin
  if FjObject = nil then exit;

  if FImageList = nil then Exit;

  if (Value >= 0) and (Value < FImageList.Images.Count) then
  begin
    FImageName := Trim(FImageList.Images.Strings[Value]);
    if (FImageName <> '') then
    begin
      jni_proc_t(gApp.jni.jEnv, FjObject, 'loadFile',
        GetFilePath(FFilePath) + '/' + FImageName);
      jBitmap_getWH(gApp.jni.jEnv, FjObject, integer(FWidth), integer(FHeight));
    end;
  end;
end;

procedure jBitmap.SetImageIndex(Value: TImageListIndex);
begin
  FImageIndex := Value;

  if FImageList = nil then Exit;

  if FInitialized then
  begin
    if FImageList <> nil then
    begin
      if Value >= FImageList.Images.Count then
        FImageIndex := FImageList.Images.Count - 1;
      if Value < 0 then
        FImageIndex := 0;

      SetImageByIndex(FImageIndex);
    end;
  end;
end;

procedure jBitmap.SetImageIdentifier(Value: string);
begin
  FImageName := Value;
  if FInitialized then LoadFromRes(Value);
end;

procedure jBitmap.LockPixels(var PDWordPixel: PScanLine);
begin
  if FInitialized then
    AndroidBitmap_lockPixels(gApp.jni.jEnv, Self.GetJavaBitmap, @PDWordPixel);
end;

procedure jBitmap.LockPixels(var PBytePixel: PScanByte {delphi mode});
begin
  if FInitialized then
    AndroidBitmap_lockPixels(gApp.jni.jEnv, Self.GetJavaBitmap, @PBytePixel);
end;

procedure jBitmap.LockPixels(var PSJByte: PJByte {FPC mode });
begin
  if FInitialized then
    AndroidBitmap_lockPixels(gApp.jni.jEnv, Self.GetJavaBitmap, @PSJByte);
end;

procedure jBitmap.UnlockPixels;
begin
  if FInitialized then
    AndroidBitmap_unlockPixels(gApp.jni.jEnv, Self.GetJavaBitmap);
end;

function jBitmap.GetInfo: boolean;
var
  rtn: integer;
begin
  Result := False;
  if FInitialized then
  begin
    rtn := AndroidBitmap_getInfo(gApp.jni.jEnv, Self.GetJavaBitmap, @Self.FBitmapInfo);
    case rtn = 0 of
      True: begin
        Result := True;
        FWidth := FBitmapInfo.Width;   //uint32_t
        FHeight := FBitmapInfo.Height;  ////uint32_t
        FStride := FBitmapInfo.stride;  //uint32_t
        FFormat := FBitmapInfo.format;  //int32_t
        FFlags := FBitmapInfo.flags;   //uint32_t      // 0 for now
      end;
      False: Result := False;
    end;
  end;
end;

function jBitmap.GetRatio: single;
begin
  Result := 1;  //dummy

  if FInitialized then
    if Self.GetInfo then Result := Round(Self.Width / Self.Height);
end;

//TODO: http://stackoverflow.com/questions/13583451/how-to-use-scanline-property-for-24-bit-bitmaps
procedure jBitmap.ScanPixel(PBytePixel: PScanByte; notByteIndex: integer);
var
  row, col, k, notFlag: integer;
begin
  if not FInitialized then exit;

  if (notByteIndex < 0) or (notByteIndex > 4) then
    notFlag := 4
  else
    notFlag := notByteIndex;

  //API LockPixels - overloaded - paramenter is PScanByte
  Self.LockPixels(PBytePixel); //ok
  k := 0;
  case notFlag of
    1: begin
      for row := 0 to Self.Height - 1 do  //ok
      begin
        for col := 0 to Self.Width - 1 do //ok
        begin
          PBytePixel^[k * 4 + 0] := not PBytePixel^[k * 4]; //delphi mode....
          PBytePixel^[k * 4 + 1] := PBytePixel^[k * 4 + 1];
          PBytePixel^[k * 4 + 2] := PBytePixel^[k * 4 + 2];
          PBytePixel^[k * 4 + 3] := PBytePixel^[k * 4 + 3];
          Inc(k);
        end;
      end;
    end;
    2: begin
      for row := 0 to Self.Height - 1 do  //ok
      begin
        for col := 0 to Self.Width - 1 do //ok
        begin
          PBytePixel^[k * 4 + 0] := not PBytePixel^[k * 4]; //delphi mode....
          PBytePixel^[k * 4 + 1] := PBytePixel^[k * 4 + 1];
          PBytePixel^[k * 4 + 2] := PBytePixel^[k * 4 + 2];
          PBytePixel^[k * 4 + 3] := PBytePixel^[k * 4 + 3];
          Inc(k);
        end;
      end;
    end;
    3: begin
      for row := 0 to Self.Height - 1 do  //ok
      begin
        for col := 0 to Self.Width - 1 do //ok
        begin
          PBytePixel^[k * 4 + 0] := not PBytePixel^[k * 4]; //delphi mode....
          PBytePixel^[k * 4 + 1] := PBytePixel^[k * 4 + 1];
          PBytePixel^[k * 4 + 2] := PBytePixel^[k * 4 + 2];
          PBytePixel^[k * 4 + 3] := PBytePixel^[k * 4 + 3];
          Inc(k);
        end;
      end;
    end;
    4: begin
      for row := 0 to Self.Height - 1 do  //ok
      begin
        for col := 0 to Self.Width - 1 do //ok
        begin
          PBytePixel^[k * 4 + 0] := not PBytePixel^[k * 4]; //delphi mode....
          PBytePixel^[k * 4 + 1] := PBytePixel^[k * 4 + 1];
          PBytePixel^[k * 4 + 2] := PBytePixel^[k * 4 + 2];
          PBytePixel^[k * 4 + 3] := PBytePixel^[k * 4 + 3];
          Inc(k);
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
begin
  if not FInitialized then exit;

  Self.LockPixels(PDWordPixel); //ok    ...API LockPixels... parameter is "PScanLine"
  for k := 0 to Self.Width * Self.Height - 1 do
    PDWordPixel^[k] := not PDWordPixel^[k];  //ok
  Self.UnlockPixels;
end;

function jBitmap.ClockWise(_bmp: jObject): jObject;
begin
  Result := nil;

  if _bmp = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'ClockWise', _bmp);
end;

function jBitmap.AntiClockWise(_bmp: jObject): jObject;
begin
  Result := nil;

  if _bmp = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_bmp_out_bmp(gApp.jni.jEnv, FjObject, 'AntiClockWise', _bmp);
end;

function jBitmap.SetScale(_bmp: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  Result := nil;

  if _bmp = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_bmp_ff_out_bmp(gApp.jni.jEnv, FjObject, 'SetScale',
      _bmp, _scaleX, _scaleY);
end;

function jBitmap.SetScale(_scaleX: single; _scaleY: single): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_ff_out_bmp(gApp.jni.jEnv, FjObject, 'SetScale', _scaleX, _scaleY);
end;

function jBitmap.LoadFromAssets(fileName: string): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromAssets', fileName);
end;

procedure jBitmap.LoadFromBuffer(buffer: Pointer; size: integer);
begin
  if buffer = nil then exit;

  if FInitialized then
    jBitmap_LoadFromBuffer(gApp.jni.jEnv, FjObject, buffer, size);
end;

function jBitmap.LoadFromBuffer(var buffer: TDynArrayOfJByte): jObject;
begin
  Result := nil;

  if buffer = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_dab_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromBuffer2', buffer);
end;

function jBitmap.GetResizedBitmap(_bmp: jObject; _newWidth: integer;
  _newHeight: integer): jObject;
begin
  Result := nil;

  if _bmp = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetResizedBitmap(gApp.jni.jEnv, FjObject,
      _bmp, _newWidth, _newHeight);
end;

function jBitmap.GetResizedBitmap(_newWidth: integer; _newHeight: integer): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_ii_out_bmp(gApp.jni.jEnv, FjObject, 'GetResizedBitmap',
      _newWidth, _newHeight);
end;

function jBitmap.GetResizedBitmap(_factorScaleX: single; _factorScaleY: single): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_ff_out_bmp(gApp.jni.jEnv, FjObject, 'GetResizedBitmap',
      _factorScaleX, _factorScaleY);
end;

function jBitmap.GetJByteBuffer(_width: integer; _height: integer): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetByteBuffer(gApp.jni.jEnv, FjObject, _width, _height);
end;

function jBitmap.GetBitmapFromJByteBuffer(_jbyteBuffer: jObject;
  _width: integer; _height: integer): jObject;
begin
  Result := nil;

  if _jbyteBuffer = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetBitmapFromByteBuffer(gApp.jni.jEnv, FjObject,
      _jbyteBuffer, _width, _height);
end;

function jBitmap.GetBitmapFromJByteArray(var _image: TDynArrayOfJByte): jObject;
begin
  Result := nil;

  if _image = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_dab_out_bmp(gApp.jni.jEnv, FjObject,
      'GetBitmapFromByteArray', _image);
end;

function jBitmap.GetJByteBufferAddress(jbyteBuffer: jObject): PJByte;
begin
  Result := nil;

  if jbyteBuffer = nil then exit;

  if FInitialized then
    Result := PJByte((gApp.jni.jEnv^).GetDirectBufferAddress(gApp.jni.jEnv, jbyteBuffer));
end;

function jBitmap.GetJByteBufferFromImage(_bmap: jObject): jObject;
begin
  Result := nil;

  if _bmap = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetByteBufferFromBitmap(gApp.jni.jEnv, FjObject, _bmap);
end;

function jBitmap.GetJByteBufferFromImage(): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetByteBufferFromBitmap(gApp.jni.jEnv, FjObject);
end;

function jBitmap.GetImageFromFile(_fullPathFile: string): jObject;
begin
  Result := nil;

  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'LoadFromFile', _fullPathFile);
end;

function jBitmap.GetRoundedShape(_bitmapImage: jObject): jObject;
begin
  Result := nil;

  if _bitmapImage = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetRoundedShape(gApp.jni.jEnv, FjObject, _bitmapImage);
end;

function jBitmap.GetRoundedShape(_bitmapImage: jObject; _diameter: integer): jObject;
begin
  Result := nil;
  if _bitmapImage = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetRoundedShape(gApp.jni.jEnv, FjObject, _bitmapImage, _diameter);
end;

function jBitmap.DrawText(_bitmapImage: jObject; _text: string;
  _left: integer; _top: integer; _fontSize: integer; _color: TARGBColorBridge): jObject;
begin
  Result := nil;
  if _bitmapImage = nil then exit;

  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_DrawText(gApp.jni.jEnv, FjObject,
      _bitmapImage, _text, _left, _top, _fontSize, GetARGB(FCustomColor, _color));
end;

procedure jBitmap.SaveToFileJPG(_fullPathFile: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SaveToFileJPG', _fullPathFile);
end;

procedure jBitmap.SaveToFileJPG(_bitmapImage: jObject; _Path: string);
begin
  if _bitmapImage = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_t(gApp.jni.jEnv, FjObject, 'SaveToFileJPG', _bitmapImage, _Path);
end;

procedure jBitmap.SetImage(_bitmapImage: jObject);
begin
  if _bitmapImage = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
  begin
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'SetImage', _bitmapImage);
    FWidth := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetWidth');
    FHeight := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetHeight');
  end;
end;

function jBitmap.DrawText(_text: string; _left: integer; _top: integer;
  _fontSize: integer; _color: TARGBColorBridge): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_DrawText(gApp.jni.jEnv, FjObject,
      _text, _left, _top, _fontSize, GetARGB(FCustomColor, _color));
end;

function jBitmap.DrawBitmap(_bitmapImageIn: jObject; _left: integer;
  _top: integer): jObject;
begin
  Result := nil;
  if _bitmapImageIn = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_DrawBitmap(gApp.jni.jEnv, FjObject, _bitmapImageIn, _left, _top);
end;

function jBitmap.CreateBitmap(_width: integer; _height: integer;
  _backgroundColor: TARGBColorBridge): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_CreateBitmap(gApp.jni.jEnv, FjObject, _width, _height,
      GetARGB(FCustomColor, _backgroundColor));
end;

function jBitmap.GetThumbnailImage(_fullPathFile: string;
  _thumbnailSize: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_ti_out_bmp(gApp.jni.jEnv, FjObject, 'GetThumbnailImage',
      _fullPathFile, _thumbnailSize);
end;

function jBitmap.GetThumbnailImage(_bitmap: jObject; _thumbnailSize: integer): jObject;
begin
  Result := nil;
  if _bitmap = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetThumbnailImage(gApp.jni.jEnv, FjObject, _bitmap, _thumbnailSize);
end;

function jBitmap.GetThumbnailImage(_bitmap: jObject; _width: integer;
  _height: integer): jObject;
begin
  Result := nil;
  if _bitmap = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetThumbnailImage(gApp.jni.jEnv, FjObject, _bitmap, _width, _height);
end;

function jBitmap.GetThumbnailImageFromAssets(_fileName: string;
  thumbnailSize: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_ti_out_bmp(gApp.jni.jEnv, FjObject,
      'GetThumbnailImageFromAssets', _fileName, thumbnailSize);
end;

function jBitmap.GetThumbnailImage(_fullPathFile: string; _width: integer;
  _height: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tii_out_bmp(gApp.jni.jEnv, FjObject, 'GetThumbnailImage',
      _fullPathFile, _width, _height);
end;

function jBitmap.GetThumbnailImageFromAssets(_filename: string;
  _width: integer; _height: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_tii_out_bmp(gApp.jni.jEnv, FjObject,
      'GetThumbnailImageFromAssets', _filename, _width, _height);
end;

procedure jBitmap.LoadFromStream(Stream: TMemoryStream);
begin
  if Stream = nil then Exit;
  if FInitialized then
    jBitmap_LoadFromBuffer(gApp.jni.jEnv, FjObject, Stream.Memory, Stream.Size);
end;

function jBitmap.GetBase64StringFromImage(_bitmap: jObject;
  _compressFormat: TBitmapCompressFormat): string;
begin
  Result := '';
  if _bitmap = nil then exit;
  //in designing component state: result value here...
  if FInitialized then
    Result := jBitmap_GetBase64StringFromImage(gApp.jni.jEnv, FjObject,
      _bitmap, Ord(_compressFormat));
end;

function jBitmap.GetImageFromBase64String(_imageBase64String: string): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'GetImageFromBase64String',
      _imageBase64String);
end;

function jBitmap.GetBase64StringFromImageFile(_fullPathToImageFile: string): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetBase64StringFromImageFile',
      _fullPathToImageFile);
end;

//------------------------------------------------------------------------------
// jCanvas
//------------------------------------------------------------------------------
constructor jCanvas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjObject := nil;
  FPaintStrokeWidth := 1;
  FPaintStyle := psStroke;
  FPaintTextSize := 12;
  FPaintColor := colbrBlue;
  FInitialized := False;

  FFontFace := ffNormal;
  FTextTypeFace := tfNormal;

end;

destructor jCanvas.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jCanvas.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jCanvas_Create(gApp.jni.jEnv, gApp.jni.jThis, Self); // jSelf !

  if FjObject = nil then exit;

  SetStrokeWidth(FPaintStrokeWidth);
  SetStyle(FPaintStyle);
  SetColor(FPaintColor);
  SetTextSize(FPaintTextSize);
  FInitialized := True;

  //new!
  if (FFontFace <> ffNormal) or (FTextTypeFace <> tfNormal) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetFontAndTextTypeFace',
      Ord(FFontFace), Ord(FTextTypeFace));

  // PaintShader new! //by kordal
  if FPaintShader <> nil then
    FPaintShader.Init(GetPaint);
end;

procedure jCanvas.InitPaintShader;
begin
  if FjObject = nil then exit;
  // PaintShader new! //by kordal
  if FPaintShader <> nil then
    FPaintShader.Init(GetPaint);
end;

procedure jCanvas.SetStrokeWidth(Value: single);
begin
  FPaintStrokeWidth := Value;
  if FjObject = nil then exit;

  jni_proc_f(gApp.jni.jEnv, FjObject, 'setStrokeWidth', FPaintStrokeWidth);
end;

procedure jCanvas.SetStyle(Value: TPaintStyle);
begin
  FPaintStyle := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setStyle', Ord(FPaintStyle));
end;

procedure jCanvas.SetColor(Value: TARGBColorBridge);
begin
  FPaintColor := Value;

  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'setColor', GetARGB(FCustomColor, FPaintColor));
end;

procedure jCanvas.SetTextSize(Value: single);
begin
  FPaintTextSize := Value;
  if FjObject = nil then exit;

  jni_proc_f(gApp.jni.jEnv, FjObject, 'setTextSize', FPaintTextSize);
end;

procedure jCanvas.SetPaintShader(Value: jPaintShader);
begin

  if Value <> FPaintShader then
  begin
    if FPaintShader <> nil then
      if Assigned(FPaintShader) then
        FPaintShader.RemoveFreeNotification(Self); // remove free notification...

    FPaintShader := Value;

    if Value <> nil then  // re- add free notification...
      Value.FreeNotification(Self);
  end;

end;

procedure jCanvas.SetRotation(Value: single);
var
  OldRotation: single;
begin
  OldRotation := FPaintRotation;
  FPaintRotation := Value;
  if FInitialized then
    jni_proc_f(gApp.jni.jEnv, FjObject, 'rotate', FPaintRotation - OldRotation);
end;

procedure jCanvas.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FPaintShader then
    begin
      FPaintShader := nil;
    end;
  end;
end;

procedure jCanvas.drawText(_text: string; x, y: single);
begin
  if FInitialized then
    jCanvas_drawText(gApp.jni.jEnv, FjObject, _text, x, y);
end;

procedure jCanvas.DrawLine(x1, y1, x2, y2: single);
begin
  if FInitialized then
    jni_proc_ffff(gApp.jni.jEnv, FjObject, 'drawLine', x1, y1, x2, y2);
end;

procedure jCanvas.DrawLine(var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_drawLine(gApp.jni.jEnv, FjObject, _points);
end;

procedure jCanvas.DrawPoint(x1, y1: single);
begin
  if FInitialized then
    jni_proc_ff(gApp.jni.jEnv, FjObject, 'drawPoint', x1, y1);
end;

procedure jCanvas.drawCircle(_cx: single; _cy: single; _radius: single);
begin
  if FInitialized then
    jni_proc_fff(gApp.jni.jEnv, FjObject, 'drawCircle', _cx, _cy, _radius);
end;

procedure jCanvas.drawOval(_left, _top, _right, _bottom: single);
begin
  if FInitialized then
    jni_proc_ffff(gApp.jni.jEnv, FjObject, 'drawOval', _left, _top, _right, _bottom);
end;

procedure jCanvas.drawBackground(_color: integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'drawBackground', _color);
end;

procedure jCanvas.drawRect(_left, _top, _right, _bottom: single);
begin
  if FInitialized then
    jni_proc_ffff(gApp.jni.jEnv, FjObject, 'drawRect', _left, _top, _right, _bottom);
end;

procedure jCanvas.drawRoundRect(_left, _top, _right, _bottom, _rx, _ry: single);
begin
  if FInitialized then
    jCanvas_drawRoundRect(gApp.jni.jEnv, FjObject, _left, _top,
      _right, _bottom, _rx, _ry);
end;

procedure jCanvas.DrawBitmap(bmp: jObject; b, l, r, t: integer);
begin
  if FInitialized then
    jCanvas_drawBitmap(gApp.jni.jEnv, FjObject, bmp, b, l, r, t);
end;

procedure jCanvas.DrawBitmap(bmp: jBitmap; b, l, r, t: integer);
begin
  if FInitialized then
    jCanvas_drawBitmap(gApp.jni.jEnv, FjObject, bmp.GetJavaBitmap, b, l, r, t);
end;

procedure jCanvas.DrawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1 := size - 20;
  t1 := Round((size - 20) * (1 / ratio));
  if FInitialized then
    jCanvas_drawBitmap(gApp.jni.jEnv, FjObject, bmp, x1, y1, r1, t1);
end;

procedure jCanvas.DrawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  if bmp = nil then exit;

  r1 := size - 10;
  t1 := Round((size - 10) * (1 / ratio));
  if FInitialized then
    jCanvas_drawBitmap(gApp.jni.jEnv, FjObject, bmp.GetJavaBitmap, x1, y1, r1, t1);
end;

procedure jCanvas.DrawBitmap(_bitmap: jObject; _width: integer; _height: integer);
begin
  if _bitmap = nil then exit;
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_drawBitmap(gApp.jni.jEnv, FjObject, _bitmap, _width, _height);
end;

// by Kordal
procedure jCanvas.DrawBitmap(bitMap: jBitmap; srcL, srcT, srcR, srcB: integer;
  dstL, dstT, dstR, dstB: single);
begin
  if bitMap = nil then exit;

  if FInitialized then
    jCanvas_DrawBitmap(gApp.jni.jEnv, FjObject, bitMap.GetImage, srcL,
      srcT, srcR, srcB, dstL, dstT, dstR, dstB);
end;

procedure jCanvas.DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH: integer;
  X, Y, Wh, Ht, rotateDegree: single);
begin
  if bitMap = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawFrame(gApp.jni.jEnv, FjObject, bitMap, srcX, srcY,
      srcW, srcH, X, Y, Wh, Ht, rotateDegree);
end;

procedure jCanvas.DrawFrame(bitMap: jObject; X, Y: single; Index, Size: integer;
  scaleFactor, rotateDegree: single);
begin
  if bitMap = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawFrame(gApp.jni.jEnv, FjObject, bitMap, X, Y, Index,
      Size, scaleFactor, rotateDegree);
end;

function jCanvas.GetDensity(): single;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_f(gApp.jni.jEnv, FjObject, 'GetDensity');
end;

procedure jCanvas.ClipRect(Left, Top, Right, Bottom: single);
begin
  if FInitialized then
    jni_proc_ffff(gApp.jni.jEnv, FjObject, 'ClipRect', Left, Top, Right, Bottom);
end;

procedure jCanvas.DrawGrid(Left, Top, Width, Height: single; cellsX, cellsY: integer);
begin
  if FInitialized then
    jCanvas_DrawGrid(gApp.jni.jEnv, FjObject, Left, Top, Width, Height, cellsX, cellsY);
end;

procedure jCanvas.SetCanvas(_canvas: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_setCanvas(gApp.jni.jEnv, FjObject, _canvas);
end;

//by CC
procedure jCanvas.DrawTextAligned(_text: string; _left, _top, _right, _bottom: single;
  _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);
var
  alignHor, aligVer: single;
begin
  case _alignHorizontal of
    thLeft: alignHor := 0;
    thRight: alignHor := 1;
    thCenter: alignHor := 0.5;
  end;

  case _alignVertical of
    tvTop: aligVer := 0;
    tvBottom: aligVer := 1;
    tvCenter: aligVer := 0.5
  end;

  if FInitialized then
    jCanvas_drawTextAligned(gApp.jni.jEnv, FjObject, _text, _left,
      _top, _right, _bottom, alignHor, aligVer);

end;

function jCanvas.GetNewPath(var _points: TDynArrayOfSingle): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_GetNewPath(gApp.jni.jEnv, FjObject, _points);
end;

function jCanvas.GetNewPath(_points: array of single): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_GetNewPath(gApp.jni.jEnv, FjObject, _points);
end;

procedure jCanvas.DrawPath(var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawPath(gApp.jni.jEnv, FjObject, _points);
end;

procedure jCanvas.DrawPath(_points: array of single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawPath(gApp.jni.jEnv, FjObject, _points);
end;

procedure jCanvas.DrawPath(_path: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawPath(gApp.jni.jEnv, FjObject, _path);
end;

procedure jCanvas.DrawArc(_leftRectF: single; _topRectF: single;
  _rightRectF: single; _bottomRectF: single; _startAngle: single;
  _sweepAngle: single; _useCenter: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawArc(gApp.jni.jEnv, FjObject, _leftRectF, _topRectF
      , _rightRectF, _bottomRectF, _startAngle, _sweepAngle, _useCenter);
end;

function jCanvas.CreateBitmap(_width: integer; _height: integer;
  _backgroundColor: TARGBColorBridge): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_CreateBitmap(gApp.jni.jEnv, FjObject, _width, _height,
      GetARGB(FCustomColor, _backgroundColor));
end;

function jCanvas.CreateBitmap(_width: integer; _height: integer;
  _backgroundColor: integer): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_CreateBitmap(gApp.jni.jEnv, FjObject, _width, _height,
      _backgroundColor);
end;

function jCanvas.GetBitmap(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmap');
end;

// by Kordal
function jCanvas.GetPaint(): JObject;
begin
  Result := nil;
  if FInitialized then
    Result := jCanvas_GetPaint(gApp.jni.jEnv, FjObject);
end;

procedure jCanvas.DrawBitmap(_left: single; _top: single; _bitmap: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawBitmap(gApp.jni.jEnv, FjObject, _left, _top, _bitmap);
end;

procedure jCanvas.SetDensityScale(_scale: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetDensityScale', _scale);
end;

procedure jCanvas.SetBitmap(_bitmap: jObject);
begin
  if _bitmap = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp(gApp.jni.jEnv, FjObject, 'SetBitmap', _bitmap);
end;

procedure jCanvas.SetBitmap(_bitmap: jObject; _width: integer; _height: integer);
begin
  if _bitmap = nil then exit;

  //in designing component state: set value here...
  if FInitialized then
    jni_proc_bmp_ii(gApp.jni.jEnv, FjObject, 'SetBitmap', _bitmap, _width, _height);
end;

procedure jCanvas.DrawText(_text: string; _x: single; _y: single;
  _angleDegree: single; _rotateCenter: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawText(gApp.jni.jEnv, FjObject,
      _text, _x, _y, _angleDegree, _rotateCenter);
end;

procedure jCanvas.DrawText(_text: string; _x: single; _y: single; _angleDegree: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawText(gApp.jni.jEnv, FjObject, _text, _x, _y, _angleDegree);
end;

procedure jCanvas.DrawRect(_P0x: single; _P0y: single; _P1x: single;
  _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawRect(gApp.jni.jEnv, FjObject,
      _P0x, _P0y, _P1x, _P1y, _P2x, _P2y, _P3x, _P3y);
end;

procedure jCanvas.DrawRect(var _box: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawRect(gApp.jni.jEnv, FjObject, _box);
end;

procedure jCanvas.DrawTextMultiLine(_text: string; _left: single;
  _top: single; _right: single; _bottom: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jCanvas_DrawTextMultiLine(gApp.jni.jEnv, FjObject,
      _text, _left, _top, _right, _bottom);
end;

procedure jCanvas.Clear(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
    Clear(GetARGB(FCustomColor, _color));
end;

procedure jCanvas.Clear(_color: DWord);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'Clear', _color);
end;

function jCanvas.GetJInstance(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_GetJInstance(gApp.jni.jEnv, FjObject);
end;

procedure jCanvas.SaveBitmapJPG(_fullPathFileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SaveBitmapJPG', _fullPathFileName);
end;

function jCanvas.GetTextHeight(_text: string): single;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_GetTextHeight(gApp.jni.jEnv, FjObject, _text);
end;

function jCanvas.GetTextWidth(_text: string): single;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jCanvas_GetTextWidth(gApp.jni.jEnv, FjObject, _text);
end;

procedure jCanvas.SetFontAndTextTypeFace(_fontFace: integer; _fontStyle: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetFontAndTextTypeFace',
      _fontFace, _fontStyle);
end;

procedure jCanvas.SetFontFace(AValue: TFontFace);
begin
  FFontFace := AValue;
  if (FInitialized) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetFontAndTextTypeFace',
      Ord(FFontFace), Ord(FTextTypeFace));
end;

{  //deprecated
procedure jCanvas.SetTypeface(Value: TFontFace); //deprecated
begin
  //in designing component state: set value here...
  FTypeFace:= Value; //deprecated
  if(FInitialized) then
   jCanvas_SetFontAndTextTypeFace(gApp.jni.jEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;
}

procedure jCanvas.SetTextTypeFace(AValue: TTextTypeFace);
begin
  FTextTypeFace := AValue;
  if (FInitialized) then
    jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetFontAndTextTypeFace',
      Ord(FFontFace), Ord(FTextTypeFace));
end;


//------------------------------------------------------------------------------
// jView
//------------------------------------------------------------------------------

constructor jView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start := False;
  FMouches.Mouch.Zoom := 1.0;
  FMouches.Mouch.Angle := 0.0;
  FFilePath := fpathData;

  FLParamWidth := lpWrapContent; //lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight := 96;
  FWidth := 96;
end;

destructor jView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;

    FjObject := jView_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

    if FjObject = nil then exit;

    if FjCanvas <> nil then
    begin
      FjCanvas.Init;
      jView_setjCanvas(gApp.jni.jEnv, FjObject, FjCanvas.jSelf); //JavaObj
    end;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;
  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

end;

procedure jView.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jView.RemoveFromViewParent;
begin
  //if FInitialized then
  // jView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;


procedure jView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

// LORDMAN 2013-08-14
procedure jView.SaveToFile(fullFileName: string);
var
  str: string;
begin
  str := fullFileName;
  if str = '' then str := 'null';
  if FInitialized then
  begin
    if str <> 'null' then
    begin
      if Pos('/', str) > 0 then
        jni_proc_t(gApp.jni.jEnv, FjObject, 'saveView', str)
      else
        jni_proc_t(gApp.jni.jEnv, FjObject, 'saveView',
          GetFilePath(FFilePath) + '/' + str);
      //intern app
    end;
  end;
end;

procedure jView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

// Event : Java Event -> Pascal
procedure jView.GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer; X1, Y1, X2, Y2: single);
begin
  case Act of
    cTouchDown: VHandler_touchesBegan_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchDown, FMouches);
    cTouchMove: VHandler_touchesMoved_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchMove, FMouches);
    cTouchUp: VHandler_touchesEnded_withEvent(Obj, Cnt, fXY(X1, Y1),
        fXY(X2, Y2), FOnTouchUp, FMouches);
  end;
end;

// Event : Java Event -> Pascal
procedure jView.GenEvent_OnDraw(Obj: TObject);
begin
  if Assigned(FOnDraw) then FOnDraw(Obj);
end;

procedure jView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jView.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

function jView.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jView.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FjCanvas then
    begin
      FjCanvas := nil;
    end;
  end;
end;

procedure jView.SetjCanvas(Value: jCanvas);
begin

  if Value <> FjCanvas then
  begin
    if FjCanvas <> nil then
      if Assigned(FjCanvas) then
        FjCanvas.RemoveFreeNotification(Self); //remove free notification...

    FjCanvas := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;

end;

function jView.GetDrawingCache(): jObject;
begin
  Result := GetImage();
end;

function jView.GetImage(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_bmp(gApp.jni.jEnv, FjObject, 'GetBitmap');
end;


procedure jView.SetLayerType(Value: TLayerType);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetLayerType', byte(Value));
end;

procedure jView.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

//------------------------------------------------------------------------------
// jTimer
//------------------------------------------------------------------------------

constructor jTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FEnabled := False;
  FInterval := 20;
  FOnTimer := nil;
  FjParent := jForm(AOwner);
  FjObject := nil;
end;

destructor jTimer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jTimer.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jTimer_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

  if FjObject = nil then exit;

  SetInterval(FInterval);
  FInitialized := True;
end;

procedure jTimer.SetEnabled(Value: boolean);
begin
  FEnabled := False;
  if not (csDesigning in ComponentState) then FEnabled := Value;
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetEnabled', Value);
end;

procedure jTimer.SetInterval(Value: integer);
begin
  FInterval := Value;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetInterval', FInterval);
end;

//------------------------------------------------------------------------------
// jDialog YN
//------------------------------------------------------------------------------

constructor jDialogYN.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FTitle := 'jDialogYesNo';
  FMsg := 'Accept ?';
  FYes := 'Yes';
  FNo := 'No';
  FParent := jForm(AOwner);
  FjObject := nil;
end;

destructor jDialogYN.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogYN.Init;
begin
  if FInitialized then Exit;
  inherited Init;

  FjObject := jDialogYN_Create(gApp.jni.jEnv, gApp.jni.jThis, Self,
    FTitle, FMsg, FYes, FNo);

  if FjObject = nil then exit;

  if FTitleAlign <> alLeft then
    SetTitleAlign(FTitleAlign);

  FInitialized := True;
end;

procedure jDialogYN.Show;
begin
  //Fixed to show text if it is changed, when "Show" is called
  Show(FTitle, FMsg, FYes, FNo);
end;

procedure jDialogYN.Show(titleText, msgText, yesText, noText, neutralText: string);
begin
  if FInitialized then
    jni_proc_ttttt(gApp.jni.jEnv, FjObject, 'show', titleText, msgText,
      yesText, noText, neutralText);
end;

procedure jDialogYN.Show(titleText, msgText, yesText, noText: string);
begin
  if FInitialized then
    jni_proc_tttt(gApp.jni.jEnv, FjObject, 'show', titleText, msgText, yesText, noText);
end;

procedure jDialogYN.Show(titleText, msgText: string);
begin
  //Fixed to show text if it is changed, when "Show" is called
  Show(titleText, msgText, FYes, FNo);
end;

procedure jDialogYN.ShowOK(titleText: string; msgText: string; _OkText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ttt(gApp.jni.jEnv, FjObject, 'ShowOK', titleText, msgText, _OkText);
end;

// by ADiV
procedure jDialogYN.SetFontSize(fontSize: integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSize', fontSize);
end;

procedure jDialogYN.SetTitleAlign(_titleAlign: TTextAlign);
begin
  FTitleAlign := _titleAlign;

  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetTitleAlign', Ord(FTitleAlign));
end;

procedure jDialogYN.SetColorBackground(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorBackground',
      GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorBackgroundTitle(_color: TARGBColorBridge); // by ADiV
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorBackgroundTitle',
      GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorTitle(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorTitle', GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorText(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorText', GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorNegative(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorNegative',
      GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorPositive(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorPositive',
      GetARGB(FCustomColor, _color));
end;

procedure jDialogYN.SetColorNeutral(_color: TARGBColorBridge);
begin

  if (FInitialized = True) then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetColorNeutral',
      GetARGB(FCustomColor, _color));
end;

// Event : Java -> Pascal
procedure jDialogYN.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if not Assigned(FOnDialogYN) then Exit;
  case Value of
    cjClick_Yes: FOnDialogYN(Obj, ClickYes);
    cjClick_No: FOnDialogYN(Obj, ClickNo);
  end;
end;

//------------------------------------------------------------------------------
// jDialog Progress
//------------------------------------------------------------------------------
constructor jDialogProgress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FParent := jForm(AOwner);
  FjObject := nil;
  FTitle := 'Lamw: Lazarus Android Module Wizard';
  FMsg := 'Please, wait...';
  FInitialized := False;
end;

destructor jDialogProgress.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogProgress.Init;
begin
  if (gApp.Jni.jEnv = nil) or (gApp.Jni.jThis = nil) then exit;

  if FInitialized then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jDialogProgress_Create(gApp.jni.jEnv, gApp.Jni.jThis, Self, FTitle, FMsg);

  if FjObject = nil then exit;

  FInitialized := True;
end;

procedure jDialogProgress.Stop;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Stop');
end;


procedure jDialogProgress.Close;
begin
  Stop;
end;

procedure jDialogProgress.Start;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'Show');

end;

procedure jDialogProgress.Show();
begin
  //in designing component state: set value here...
  Start;
end;

procedure jDialogProgress.Show(_title: string; _msg: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'Show', _title, _msg);
end;

procedure jDialogProgress.Show(_layout: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDialogProgress_Show(gApp.jni.jEnv, FjObject, _layout);
end;

procedure jDialogProgress.SetMessage(_msg: string);
begin
  //in designing component state: set value here...
  FMsg := _msg;
  if not FInitialized then  Exit;

  if FjObject <> nil then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetMessage', _msg);
end;

procedure jDialogProgress.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FTitle := _title;
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTitle', _title);
end;

procedure jDialogProgress.SetCancelable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetCancelable', _value);
end;

//------------------------------------------------------------------------------
// jImageBtn
//------------------------------------------------------------------------------

// Event : Java -> Pascal by ADiV
procedure jImageBtn.GenEvent_OnDown(Obj: TObject);
begin
  if Assigned(FOnDown) then FOnDown(Obj);
end;

procedure jImageBtn.GenEvent_OnUp(Obj: TObject);
begin
  if Assigned(FOnUp) then FOnUp(Obj);
end;

constructor jImageBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FImageUpName := '';
  FImageDownName := '';
  FImageUpIndex := -1;
  FImageDownIndex := -1;

  FLParamWidth := lpWrapContent;
  FLParamHeight := lpWrapContent;

  FFilePath := fpathData;
  FMarginLeft := 5;
  FMarginTop := 5;
  FMarginBottom := 5;
  FMarginRight := 5;
  FWidth := 72;
  FHeight := 72;
  FSleepDown := 150;
  FAlpha := 255;

  FAnimationMode := animNone;
  FAnimationDurationIn := 1500;
  FAnimationDurationOut := 1500;
end;

destructor jImageBtn.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.Jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jImageBtn.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;
    FjObject := jImageBtn_Create(gApp.Jni.jEnv, gApp.Jni.jThis, Self);

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    if FGravityInParent <> lgNone then
      View_SetLGravity(gApp.Jni.jEnv, FjObject, Ord(FGravityInParent));

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.Jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.Jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.Jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.Jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.Jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  if not FInitialized then
    SetEnabled(FEnabled);

  if (FImageDownIndex < 0) or (FImageList = nil) then
    if (FImageDownName <> '') then
      SetImageDownByRes(FImageDownName);

  if (FImageUpIndex < 0) or (FImageList = nil) then
    if (FImageUpName <> '') then
      SetImageUpByRes(FImageUpName);

  if FImageList <> nil then
  begin
    FImageList.Init;   //must have!
    if FImageList.Images.Count > 0 then
    begin
      if FImageDownIndex >= 0 then SetImageDownByIndex(FImageDownIndex);
      if FImageUpIndex >= 0 then SetImageUpByIndex(FImageUpIndex);
    end;
  end;

  View_SetLayoutAll(gApp.Jni.jEnv, FjObject, Self.AnchorId);

  if FSleepDown > 0 then
    SetSleepDown(FSleepDown);

  if not FInitialized then
  begin
    FInitialized := True;

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.Jni.jEnv, gApp.jni.jThis, FjObject,
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.Jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

  if FAnimationDurationIn <> 1500 then
    SetAnimationDurationIn(FAnimationDurationIn);

  if FAnimationDurationOut <> 1500 then
    SetAnimationDurationOut(FAnimationDurationOut);

  if FAnimationMode <> animNone then
    SetAnimationMode(FAnimationMode);

  if FAlpha <> 255 then
    SetAlpha(FAlpha);
end;

procedure jImageBtn.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.Jni.jEnv, FjObject, FjPRLayout);
end;

procedure jImageBtn.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.Jni.jEnv, FjObject);
end;

// by ADiV
procedure jImageBtn.SetAlpha(Value: integer);
begin
  FAlpha := Value;

  if not FInitialized then exit;

  jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetAlpha', FAlpha);
end;

// by ADiV
procedure jImageBtn.SetSaturation(Value: single);
begin

  if not FInitialized then exit;

  jni_proc_f(gApp.Jni.jEnv, FjObject, 'SetSaturation', Value);
end;

// by ADiV
procedure jImageBtn.SetColorScale(_red, _green, _blue, _alpha: single);
begin

  if not FInitialized then exit;

  jni_proc_ffff(gApp.Jni.jEnv, FjObject, 'SetColorScale', _red, _green, _blue, _alpha);
end;

procedure jImageBtn.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.Jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

// LORDMAN 2013-08-16
procedure jImageBtn.SetEnabled(Value: boolean);
begin
  FEnabled := Value;
  if FjObject = nil then exit;

  jni_proc_z(gApp.Jni.jEnv, FjObject, 'setEnabled', FEnabled);
end;

procedure jImageBtn.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.Jni.jEnv, FjObject);
end;

procedure jImageBtn.SetAnimationDurationIn(_animationDurationIn: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationIn := _animationDurationIn;
  if FInitialized then
    jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetAnimationDurationIn', _animationDurationIn);
end;

procedure jImageBtn.SetAnimationDurationOut(_animationDurationOut: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationOut := _animationDurationOut;
  if FInitialized then
    jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetAnimationDurationOut',
      _animationDurationOut);
end;

procedure jImageBtn.SetAnimationMode(_animationMode: TAnimationMode);
begin
  //in designing component state: set value here...
  FAnimationMode := _animationMode;
  if FInitialized then
    jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetAnimationMode', Ord(_animationMode));
end;

procedure jImageBtn.Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_zii(gApp.Jni.jEnv, FjObject, 'Animate', _animateIn, _xFromTo, yFromTo);
end;

procedure jImageBtn.AnimateRotate(_angleFrom, _angleTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_ii(gApp.Jni.jEnv, FjObject, 'AnimateRotate', _angleFrom, _angleTo);
end;

procedure jImageBtn.SetRotation(_angle: integer);
begin
  if FjObject = nil then exit;

  jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetRotation', _angle);
end;

// by ADiV
procedure jImageBtn.SetImageUp(_bmp: jObject);
begin
  if FjObject = nil then exit;

  SetImageUpByRes('');
  SetImageUpByIndex(-1);

  jni_proc_bmp(gApp.Jni.jEnv, FjObject, 'SetImageUp', _bmp);
end;

// by ADiV
procedure jImageBtn.SetImageDown(_bmp: jObject);
begin
  if FjObject = nil then exit;

  SetImageDownByRes('');
  SetImageDownByIndex(-1);

  jni_proc_bmp(gApp.Jni.jEnv, FjObject, 'SetImageDown', _bmp);
end;

// by ADiV
procedure jImageBtn.SetImageDownScale(Value: single);
begin

  if FjObject = nil then exit;

  if (Value > 0) then
  begin
    if Value > 1 then Value := 1;

    SetImageDownByRes('');
    SetImageDownByIndex(-1);

    jni_proc_f(gApp.Jni.jEnv, FjObject, 'SetImageDownScale', Value);
  end;

end;

procedure jImageBtn.SetImageDownByIndex(Value: integer);
begin
  FImageDownIndex := Value;

  if FjObject = nil then exit;
  if FImageList = nil then exit;

  if (Value >= 0) and (Value < FImageList.Images.Count) then
  begin
    FImageDownName := Trim(FImageList.Images.Strings[Value]);
    if FImageDownName <> '' then
    begin
      jni_proc_t(gApp.Jni.jEnv, FjObject, 'setButtonDown',
        GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} + '/' + FImageDownName);
    end;
  end;

end;

procedure jImageBtn.SetImageUpByIndex(Value: integer);
begin

  FImageUpIndex := Value;

  if FjObject = nil then exit;
  if FImageList = nil then exit;

  if (Value >= 0) and (Value < FImageList.Images.Count) then
  begin
    FImageUpName := Trim(FImageList.Images.Strings[Value]);
    if FImageUpName <> '' then
    begin
      jni_proc_t(gApp.Jni.jEnv, FjObject, 'setButtonUp',
        GetFilePath(FFilePath){jForm(Owner).App.Path.Dat} + '/' + FImageUpName);
    end;
  end;

end;

procedure jImageBtn.SetImageDownByRes(imgResIdentifief: string);
begin
  FImageDownName := imgResIdentifief;

  if FjObject = nil then exit;

  jni_proc_t(gApp.Jni.jEnv, FjObject, 'setButtonDownByRes', imgResIdentifief);
end;

procedure jImageBtn.SetImageUpByRes(imgResIdentifief: string);
begin
  FImageUpName := imgResIdentifief;

  if FjObject = nil then exit;

  jni_proc_t(gApp.Jni.jEnv, FjObject, 'setButtonUpByRes', imgResIdentifief);
end;

// by ADiV
procedure jImageBtn.SetImageUpIndex(Value: TImageListIndex);
begin
  FImageUpIndex := Value;

  if FjObject = nil then exit;

  SetImageUpByIndex(Value);
end;

// by ADiV
procedure jImageBtn.SetImageDownIndex(Value: TImageListIndex);
begin
  FImageDownIndex := Value;

  if FjObject = nil then exit;

  SetImageDownByIndex(Value);
end;

function jImageBtn.GetLParamWidth(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetLParamWidth(gApp.Jni.jEnv, FjObject);
end;

function jImageBtn.GetLParamHeight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetLParamHeight(gApp.Jni.jEnv, FjObject);
end;

procedure jImageBtn.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.Jni.jEnv, FjObject);
  end;
end;

procedure jImageBtn.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.Jni.jEnv, FjObject);
    for rToP := rpBottom to rpCenterVertical do
    begin
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.Jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));
    end;
    for rToA := raAbove to raAlignRight do
    begin
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.Jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
    end;
  end;
end;

procedure jImageBtn.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jImageBtn.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FImageList then
    begin
      FImageList := nil;
    end;
  end;
end;

procedure jImageBtn.SetImages(Value: jImageList);
begin

  if Value <> FImageList then
  begin
    if FImageList <> nil then
      if Assigned(FImageList) then
        FImageList.RemoveFreeNotification(Self); //remove free notification...

    FImageList := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;

end;


// Event : Java -> Pascal
procedure jImageBtn.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jImageBtn.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent := _value;
  if FInitialized then
    View_SetLGravity(gApp.Jni.jEnv, FjObject, Ord(FGravityInParent));
end;

procedure jImageBtn.SetSleepDown(_sleepMiliSeconds: integer);
begin
  if _sleepMiliSeconds <= 0 then exit;

  //in designing component state: set value here...
  FSleepDown := _sleepMiliSeconds;

  if FjObject = nil then exit;

  jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetSleepDown', _sleepMiliSeconds);
end;


procedure jImageBtn.SetImageState(_imageState: TImageBtnState);
begin
  //in designing component state: set value here...
  if FjObject = nil then exit;

  jni_proc_i(gApp.Jni.jEnv, FjObject, 'SetImageState', Ord(_imageState));
end;

//------------------------------------------------------------------------------
// jAsyncTask
// http://stackoverflow.com/questions/5517641/publishprogress-from-inside-a-function-in-doinbackground
//------------------------------------------------------------------------------


constructor jAsyncTask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjObject := nil;
  FRunning := False;
end;

destructor jAsyncTask.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jAsyncTask.Init;
begin
  if FInitialized then Exit;
  inherited Init;

  FjObject := jAsyncTask_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

  if FjObject = nil then exit;

  FInitialized := True;
end;

procedure jAsyncTask.Done;
begin
  FRunning := False;
end;

procedure jAsyncTask.Execute;
begin
  if (FInitialized = True) and (FRunning = False) then
  begin
    FRunning := True;
    jni_proc(gApp.jni.jEnv, FjObject, 'Execute');
  end;
end;

procedure jAsyncTask.GenEvent_OnAsyncEventDoInBackground(Obj: TObject;
  progress: integer; out keepInBackground: boolean);
begin
  keepInBackground := True;
  if Assigned(FOnDoInBackground) then FOnDoInBackground(Obj, progress, keepInBackground);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventProgressUpdate(Obj: TObject;
  progress: integer; out progressUpdate: integer);
begin
  progressUpdate := progress + 1;
  if Assigned(FOnProgressUpdate) then FOnProgressUpdate(Obj, progress, progressUpdate);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventPreExecute(Obj: TObject;
  out startProgress: integer);
begin
  startProgress := 0;
  if Assigned(FOnPreExecute) then FOnPreExecute(Obj, startProgress);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventPostExecute(Obj: TObject; progress: integer);
begin
  if Assigned(FOnPostExecute) then FOnPostExecute(Obj, progress);
end;

//------------------------------------------------------------------------------
// jGLViewEvent
//------------------------------------------------------------------------------

constructor jGLViewEvent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FOnGLCreate := nil;
  FOnGLChange := nil;
  FOnGLDraw := nil;
  FOnGLDestroy := nil;
  FOnGLPause := nil;
  FOnGLResume := nil;

  FOnGLDown := nil;
  FOnGLMove := nil;
  FOnGLUp := nil;

  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start := False;
  FMouches.Mouch.Zoom := 1.0;
  FMouches.Mouch.Angle := 0.0;
  FInitialized := False;
end;

destructor jGLViewEvent.Destroy;
begin
  FOnGLCreate := nil;
  FOnGLChange := nil;
  FOnGLDraw := nil;
  FOnGLDestroy := nil;
  FOnGLPause := nil;
  FOnGLResume := nil;

  FOnGLDown := nil;
  FOnGLMove := nil;
  FOnGLUp := nil;

  inherited Destroy;
end;

procedure jGLViewEvent.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FInitialized := True;
end;

//Event : Java Event -> Pascal
procedure jGLViewEvent.GenEvent_OnTouch(Obj: TObject; Act, Cnt: integer;
  X1, Y1, X2, Y2: single);
begin
  if not FInitialized then Exit;
  gApp.Lock := True;
  case Act of
    cTouchDown: VHandler_touchesBegan_withEvent(Obj, Cnt, fXY(X1, Y1), fXY(X2, Y2),
        FOnGLDown, FMouches);
    cTouchMove: VHandler_touchesMoved_withEvent(Obj, Cnt, fXY(X1, Y1), fXY(X2, Y2),
        FOnGLMove, FMouches);
    cTouchUp: VHandler_touchesEnded_withEvent(Obj, Cnt, fXY(X1, Y1), fXY(X2, Y2),
        FOnGLUp, FMouches);
  end;
  gApp.Lock := False;
end;

procedure jGLViewEvent.GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
begin
  if not FInitialized then Exit;
  gApp.Lock := True;
  case EventType of
    cRenderer_onGLCreate: if Assigned(FOnGLCreate) then FOnGLCreate(Obj);
    cRenderer_onGLChange: if Assigned(FOnGLChange) then FOnGLChange(Obj, w, h);
    cRenderer_onGLDraw: if Assigned(FOnGLDraw) then FOnGLDraw(Obj);
    cRenderer_onGLDestroy: if Assigned(FOnGLDestroy) then FOnGLDestroy(Obj);
    cRenderer_onGLThread: if Assigned(FOnGLThread) then FOnGLThread(Obj);
    cRenderer_onGLPause: if Assigned(FOnGLPause) then FOnGLPause(Obj);
    cRenderer_onGLResume: if Assigned(FOnGLResume) then FOnGLResume(Obj);
  end;
  gApp.Lock := False;
end;

{jSqliteCursor}

constructor jSqliteCursor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //FjObject  := nil;
  SetLength(FObservers, MAXOBSERVERS);
  FObserverCount := 0;
end;

destructor jSqliteCursor.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  SetLength(FObservers, 0);
  inherited Destroy;
end;

procedure jSqliteCursor.Init;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jSqliteCursor_Create(gApp.jni.jEnv, gApp.jni.jThis, Self);

  if FjObject = nil then exit;

  FInitialized := True;
end;

function jSqliteCursor.GetCursor: jObject;
begin
  Result := nil;
  if FInitialized then
    Result := jSqliteCursor_GetCursor(gApp.jni.jEnv, FjObject);
end;

function jSqliteCursor.GetEOF: boolean;
var
  rowCount: integer;
begin
  Result := True;

  if (not FInitialized) then exit;

  rowCount := GetRowCount;

  if (rowCount = POSITION_UNKNOWN) or (rowCount = 0) then Exit;

  Result := (GetPosition = rowCount);
end;

function jSqliteCursor.GetBOF: boolean;
var
  rowCount: integer;
begin
  Result := True;

  if (not FInitialized) then exit;

  rowCount := GetRowCount;

  if (rowCount = POSITION_UNKNOWN) or (rowCount = 0) then Exit;

  Result := (GetPosition = -1);
end;

procedure jSqliteCursor.UnRegisterObserver(AObserver: jVisualControl);
var
  i: integer = 0;
begin
  if FObservers = nil then exit;

  while i < FObserverCount do
  begin
    if AObserver = FObservers[i] then break;
    Inc(i);
  end;
  if i = FObserverCount then Exit;                      // AObserver not found!
  while i < FObserverCount - 1 do
  begin
    FObservers[i] := FObservers[i + 1];
    Inc(i);
  end;
  FObservers[i] := nil;
  Dec(FObserverCount);
end;

procedure jSqliteCursor.RegisterObserver(AObserver: jVisualControl);
var
  i: integer = 0;
begin
  if FObservers = nil then exit;

  if FObserverCount < MAXOBSERVERS then
  begin
    while i < FObserverCount do
    begin
      if AObserver = FObservers[i] then break;
      Inc(i);
    end;
    if i = FObserverCount then
    begin
      FObservers[i] := AObserver;
      Inc(FObserverCount);
    end;
  end;
end;

procedure jSqliteCursor.SetCursor(Value: jObject);
var
  i: integer;
begin
  if not FInitialized then Exit;
  if FObservers = nil then exit;

  jSqliteCursor_SetCursor(gApp.jni.jEnv, FjObject, Value);

  if FObserverCount > 0 then
  begin
    for i := 0 to FObserverCount - 1 do
    begin
      //DBListView_Log ('Calling ' +  FObservers[i].Name + '.ChangeCursor() ...');
      (FObservers[i] as jDBListView).ChangeCursor(Self);
      //DBListView_Log ('... Done');
    end;
  end;
end;

procedure jSqliteCursor.MoveToFirst;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToFirst');
end;

procedure jSqliteCursor.MoveToNext;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToNext');
end;

procedure jSqliteCursor.MoveToPrev;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToPrev');
end;

procedure jSqliteCursor.MoveToLast;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToLast');
end;

procedure jSqliteCursor.MoveToPosition(position: integer);
begin
  if not FInitialized then Exit;
  jni_proc_i(gApp.jni.jEnv, FjObject, 'MoveToPosition', position);
end;

function jSqliteCursor.GetRowCount: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetRowCount');
end;

function jSqliteCursor.GetColumnCount: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetColumnCount');
end;

function jSqliteCursor.GetColumnIndex(colName: string): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'GetColumnIndex', colName);
end;

function jSqliteCursor.GetColumName(columnIndex: integer): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetColumName', columnIndex);
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
  Result := ftNull;

  if not FInitialized then Exit;

  colType := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetColType', columnIndex);

  case colType of
    0: Result := ftNull;
    1: Result := ftInteger;
    2: Result := ftFloat;
    3: Result := ftString;
    4: Result := ftBlob;
  end;
end;

function jSqliteCursor.GetValueAsString(columnIndex: integer): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetValueAsString', columnIndex);
end;

function jSqliteCursor.GetValueAsString(colName: string): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetValueAsString', colName);
end;

function jSqliteCursor.GetValueAsBitmap(columnIndex: integer): jObject;
begin
  Result := nil;
  if FInitialized then
    Result := jni_func_i_out_bmp(gApp.jni.jEnv, FjObject, 'GetValueAsBitmap', columnIndex);
end;

function jSqliteCursor.GetValueAsBitmap(colName: string): jObject;
begin

  Result := nil;
  if FInitialized then
    Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'GetValueAsBitmap', colName);
end;

function jSqliteCursor.GetValueAsInteger(columnIndex: integer): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetValueAsInteger', columnIndex);
end;

function jSqliteCursor.GetValueAsInteger(colName: string): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'GetValueAsInteger', colName);
end;

function jSqliteCursor.GetValueAsDouble(columnIndex: integer): double;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_d(gApp.jni.jEnv, FjObject, 'GetValueAsDouble', columnIndex);
end;

function jSqliteCursor.GetValueAsDouble(colName: string): double;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_d(gApp.jni.jEnv, FjObject, 'GetValueAsDouble', colName);
end;

function jSqliteCursor.GetValueAsFloat(columnIndex: integer): real;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_f(gApp.jni.jEnv, FjObject, 'GetValueAsFloat', columnIndex);
end;

function jSqliteCursor.GetValueAsFloat(colName: string): real;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_f(gApp.jni.jEnv, FjObject, 'GetValueAsFloat', colName);
end;

function jSqliteCursor.GetValueToString(columnIndex: integer): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetValueToString', columnIndex);
end;

function jSqliteCursor.GetValueToString(colName: string): string;
begin
  Result := '';
  if FInitialized then
    Result := GetValueToString(GetColumnIndex(colName));
end;

function jSqliteCursor.GetPosition(): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetPosition');
end;

{jSqliteDataAccess}

constructor jSqliteDataAccess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColDelimiter := '|';
  FRowDelimiter := '#';
  FDataBaseName := 'myData.db';
  FCreateTableQuery := TStringList.Create;
  FTableName := TStringList.Create;
  FReturnHeaderOnSelect := True;
  FInitialized := False;
end;

destructor jSqliteDataAccess.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;

  if FTableName <> nil then FTableName.Free;
  if FCreateTableQuery <> nil then FCreateTableQuery.Free;

  inherited Destroy;
end;

procedure jSqliteDataAccess.Init;
var
  i: integer;
begin
  if FInitialized then Exit;
  inherited Init;
  FjObject := jSqliteDataAccess_Create(gApp.jni.jEnv, gApp.jni.jThis,
    Self, FDataBaseName, FColDelimiter, FRowDelimiter);

  if FjObject = nil then exit;

  FInitialized := True;

  if FTableName <> nil then
    for i := 0 to FTableName.Count - 1 do
      jni_proc_t(gApp.jni.jEnv, FjObject, 'AddTableName', FTableName.Strings[i]);

  if FCreateTableQuery <> nil then
    for i := 0 to FCreateTableQuery.Count - 1 do
      jni_proc_t(gApp.jni.jEnv, FjObject, 'AddCreateTableQuery',
        FCreateTableQuery.Strings[i]);

  if not FReturnHeaderOnSelect then
    SetReturnHeaderOnSelect(FReturnHeaderOnSelect);

  FFullPathDataBaseName := GetFilePath(fpathDataBase) + '/' + FDataBaseName;

end;

function jSqliteDataAccess.Insert(_tableName: string): int64;
begin
  Result := -1;

  if FInitialized then
    Result := jni_func_t_out_j(gApp.jni.jEnv, FjObject, 'Insert', _tableName);
end;

function jSqliteDataAccess.Update(_tableName, _whereClause: string;
  _whereArgs: array of string): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_tt_ars_out_i(gApp.jni.jEnv, FjObject, 'Update',
      _tableName, _whereClause, _whereArgs);
end;

function jSqliteDataAccess.UpdateAll(_tableName: string): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'UpdateAll', _tableName);
end;

function jSqliteDataAccess.Delete(_tableName, _whereClause: string;
  _whereArgs: array of string): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_tt_ars_out_i(gApp.jni.jEnv, FjObject, 'Delete',
      _tableName, _whereClause, _whereArgs);
end;

function jSqliteDataAccess.DeleteAll(_tableName: string): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'DeleteAll', _tableName);
end;

procedure jSqliteDataAccess.ContentValuesClear;
begin
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'ContentValuesClear');
end;

procedure jSqliteDataAccess.PutString(_colum: string; _value: string);
begin
  if FInitialized then
    jni_proc_tt(gApp.jni.jEnv, FjObject, 'PutString', _colum, _value);
end;

procedure jSqliteDataAccess.PutShort(_colum: string; _value: smallint);
begin
  if FInitialized then
    jSqliteDataAccess_PutShort(gApp.jni.jEnv, FjObject, _colum, _value);
end;

procedure jSqliteDataAccess.PutLong(_colum: string; _value: int64);
begin
  if FInitialized then
    jni_proc_tj(gApp.jni.jEnv, FjObject, 'PutLong', _colum, _value);
end;

procedure jSqliteDataAccess.PutDouble(_colum: string; _value: double);
begin
  if FInitialized then
    jSqliteDataAccess_PutDouble(gApp.jni.jEnv, FjObject, _colum, _value);
end;

procedure jSqliteDataAccess.PutInteger(_colum: string; _value: integer);
begin
  if FInitialized then
    jni_proc_ti(gApp.jni.jEnv, FjObject, 'PutInteger', _colum, _value);
end;

procedure jSqliteDataAccess.PutBoolean(_colum: string; _value: boolean);
begin
  if FInitialized then
    jni_proc_tz(gApp.jni.jEnv, FjObject, 'PutBoolean', _colum, _value);
end;

procedure jSqliteDataAccess.PutFloat(_colum: string; _value: single);
begin
  if FInitialized then
    jni_proc_tf(gApp.jni.jEnv, FjObject, 'PutFloat', _colum, _value);
end;

procedure jSqliteDataAccess.PutByte(_colum: string; _value: byte);
begin
  if FInitialized then
    jSqliteDataAccess_PutByte(gApp.jni.jEnv, FjObject, _colum, _value);
end;

function jSqliteDataAccess.DBExport(_dbExportDir, _dbExportFileName: string)
: boolean;
begin

  Result := False;

  if FInitialized then
    Result := jni_func_tt_out_z(gApp.jni.jEnv, FjObject, 'DBExport',
      _dbExportDir, _dbExportFileName);

end;

function jSqliteDataAccess.DBExport(_dbExportUri: jObject): boolean;
begin

  Result := False;

  if FInitialized then
    Result := jni_func_uri_out_z(gApp.jni.jEnv, FjObject, 'DBExport', _dbExportUri);

end;

function jSqliteDataAccess.DBImport(_dbImportFileFull: string): boolean;
begin

  Result := False;

  if FInitialized then
    Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'DBImport', _dbImportFileFull);

end;

function jSqliteDataAccess.DBImport(_dbImportUri: jObject): boolean;
begin

  Result := False;

  if FInitialized then
    Result := jni_func_uri_out_z(gApp.jni.jEnv, FjObject, 'DBImport', _dbImportUri);

end;

// Do not use 'SELECT' in this function
function jSqliteDataAccess.ExecSQL(execQuery: string): boolean;
begin
  Result := False;
  if FInitialized then
    Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'ExecSQL', execQuery);
end;

//"data/data/com.data.pack/databases/" + myData.db;
function jSqliteDataAccess.CheckDataBaseExists(databaseName: string): boolean;
var
  fullPathDB: string;
begin                      {/data/data/com.example.program/databases}
  Result := False;

  if not FInitialized then Exit;

  fullPathDB := GetFilePath(fpathDataBase) + '/' + databaseName;
  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'CheckDataBaseExists', fullPathDB);
end;

procedure jSqliteDataAccess.OpenOrCreate(dataBaseName: string);
begin
  if not FInitialized then Exit;
  FDataBaseName := dataBaseName;
  if dataBaseName = '' then Exit;
  jni_proc_t(gApp.jni.jEnv, FjObject, 'OpenOrCreate', FDataBaseName);
end;

procedure jSqliteDataAccess.SetVersion(version: integer); //renabor
begin
  if not FInitialized then Exit;
  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetVersion', version);
end;

function jSqliteDataAccess.GetVersion(): integer; // renabor
begin
  Result := -1;
  if not FInitialized then Exit;
  Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetVersion');
end;

procedure jSqliteDataAccess.AddTable(tableName: string; createTableQuery: string);
begin
  if not FInitialized then Exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'AddTableName', tableName);
  jni_proc_t(gApp.jni.jEnv, FjObject, 'AddCreateTableQuery', createTableQuery);
end;

procedure jSqliteDataAccess.CreateAllTables;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'CreateAllTables');
end;

function jSqliteDataAccess.Select(selectQuery: string): string;
begin
  Result := '';

  if not FInitialized then Exit;

  Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'Select', selectQuery);
  //Restult: True or false must select the cursor to maintain consistency
  if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

function jSqliteDataAccess.Select(selectQuery: string; moveToLast: boolean): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_tz_out_z(gApp.jni.jEnv, FjObject, 'Select', selectQuery, moveToLast);

  if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

function jSqliteDataAccess.Select(_tableName, _sortOrder: string): integer; overload;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_tt_out_i(gApp.jni.jEnv, FjObject, 'Select',
      _tableName, _sortOrder);
end;

function jSqliteDataAccess.Select(_tableName, _selection: string;
  _selectionArgs: array of string; _sortOrder: string): integer;
begin
  Result := 0;

  if FInitialized then
    Result := jni_func_tt_ars_t_out_i(gApp.jni.jEnv, FjObject, 'Select',
      _tableName, _selection, _selectionArgs, _sortOrder);
end;

function jSqliteDataAccess.GetCursor: jObject;
begin
  Result := nil;

  if not FInitialized then Exit;

  Result := jSqliteDataAccess_GetCursor(gApp.jni.jEnv, FjObject);
  //DBListView_Log('Internal cursor is ' + BoolToStr(result = nil, 'INVALID', 'VALID'));
end;

procedure jSqliteDataAccess.SetSelectDelimiters(coldelim: char; rowdelim: char);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_SetSelectDelimiters(gApp.jni.jEnv, FjObject, coldelim, rowdelim);
end;

function jSqliteDataAccess.CreateTable(createQuery: string): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'ExecSQL', createQuery);
end;

function jSqliteDataAccess.DropTable(tableName: string): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'DropTable', tableName);
end;

//ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('BRASILIA','CENTRO OESTE')"
function jSqliteDataAccess.InsertIntoTable(insertQuery: string): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'InsertIntoTable', insertQuery);
end;

//ex: "DELETE FROM TABLE1  WHERE PLACE = 'BR'";
function jSqliteDataAccess.DeleteFromTable(deleteQuery: string): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'DeleteFromTable', deleteQuery);
end;

//ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'BR'"
function jSqliteDataAccess.UpdateTable(updateQuery: string): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'UpdateTable', updateQuery);
end;

function jSqliteDataAccess.UpdateImage(tableName: string; imageFieldName: string;
  keyFieldName: string; imageValue: jObject; keyValue: integer): boolean;
begin
  Result := False;

  if not FInitialized then Exit;

  Result := jSqliteDataAccess_UpdateImage(gApp.jni.jEnv, FjObject,
    tableName, imageFieldName, keyFieldName,
    imageValue, keyValue);
end;

procedure jSqliteDataAccess.Close;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'Close');
end;

procedure jSqliteDataAccess.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FjSqliteCursor then
    begin
      FjSqliteCursor := nil;
    end;
  end;
end;

procedure jSqliteDataAccess.SetjSqliteCursor(Value: jSqliteCursor);
begin

  if Value <> FjSqliteCursor then
  begin
    if FjSqliteCursor <> nil then
      if Assigned(FjSqliteCursor) then
        FjSqliteCursor.RemoveFreeNotification(Self); //remove free notification...

    FjSqliteCursor := Value;

    if Value <> nil then  //re- add free notification...
      Value.FreeNotification(self);
  end;

end;

procedure jSqliteDataAccess.SetForeignKeyConstraintsEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetForeignKeyConstraintsEnabled', _value);
end;

procedure jSqliteDataAccess.SetDefaultLocale();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetDefaultLocale');
end;

procedure jSqliteDataAccess.DeleteDatabase(_dbName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'DeleteDatabase', _dbName);
end;

function jSqliteDataAccess.UpdateImage(_tabName: string; _imageFieldName: string;
  _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer): boolean;
begin
  Result := False;

  //in designing component state: set value here...
  if not FInitialized then exit;

  Result := jSqliteDataAccess_UpdateImage(gApp.jni.jEnv, FjObject,
    _tabName, _imageFieldName, _keyFieldName, _imageResIdentifier, _keyValue);
end;

(*
procedure jSqliteDataAccess.InsertIntoTableBatch(var _insertQueries: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_InsertIntoTableBatch(gApp.jni.jEnv, FjObject, _insertQueries);
end;

procedure jSqliteDataAccess.UpdateTableBatch(var _updateQueries: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_UpdateTableBatch(gApp.jni.jEnv, FjObject, _updateQueries);
end;
*)

function jSqliteDataAccess.InsertIntoTableBatch(
  var _insertQueries: TDynArrayOfString): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jSqliteDataAccess_InsertIntoTableBatch(gApp.jni.jEnv,
      FjObject, _insertQueries);
end;

function jSqliteDataAccess.UpdateTableBatch(
  var _updateQueries: TDynArrayOfString): boolean;
begin
  Result := False;
  //in designing component state: result value here...
  if FInitialized then
    Result := jSqliteDataAccess_UpdateTableBatch(gApp.jni.jEnv, FjObject, _updateQueries);
end;

function jSqliteDataAccess.CheckDataBaseExistsByName(_dbName: string): boolean;
begin
  //in designing component state: result value here...
  Result := False;

  if not FInitialized then exit;

  Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject,
    'CheckDataBaseExistsByName', _dbName);
end;

procedure jSqliteDataAccess.UpdateImageBatch(
  var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jSqliteDataAccess_UpdateImageBatch(gApp.jni.jEnv, FjObject,
      _imageResIdentifierDataArray, _delimiter);
end;

procedure jSqliteDataAccess.SetDataBaseName(_dbName: string);
begin
  //in designing component state: set value here...
  FDatabaseName := _dbName;
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetDataBaseName', _dbName);
end;

function jSqliteDataAccess.GetFullPathDataBaseName(): string;
begin
  Result := '';

  if not FInitialized then exit;

  FFullPathDataBaseName := GetFilePath(fpathDataBase) + '/' + FDataBaseName;

  Result := FFullPathDataBaseName;
end;

function jSqliteDataAccess.DatabaseExists(_databaseName: string): boolean;
begin
  //in designing component state: result value here...
  Result := False;
  if FInitialized then
    Result := jni_func_t_out_z(gApp.jni.jEnv, FjObject, 'DatabaseExists', _databaseName);
end;

procedure jSqliteDataAccess.SetAssetsSearchFolder(_folderName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_t(gApp.jni.jEnv, FjObject, 'SetAssetsSearchFolder', _folderName);
end;

procedure jSqliteDataAccess.SetReturnHeaderOnSelect(_returnHeader: boolean);
begin
  //in designing component state: set value here...
  FReturnHeaderOnSelect := _returnHeader;
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetReturnHeaderOnSelect', _returnHeader);
end;

procedure jSqliteDataAccess.SetBatchAsyncTaskType(_batchAsyncTaskType:
  TBatchAsyncTaskType);
begin
  //in designing component state: set value here...
  FBatchAsyncTaskType := _batchAsyncTaskType;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetBatchAsyncTaskType',
      Ord(_batchAsyncTaskType));
end;

procedure jSqliteDataAccess.ExecSQLBatchAsync(var _execSql: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
    jSqliteDataAccess_ExecSQLBatchAsync(gApp.jni.jEnv, FjObject, _execSql);
end;

function jSqliteDataAccess.GetEOF: boolean;
var
  rowCount: integer;
begin
  Result := True;

  if (not FInitialized) then exit;

  rowCount := GetRowCount;

  if (rowCount = POSITION_UNKNOWN) or (rowCount = 0) then Exit;

  Result := (GetPosition = rowCount);
end;

function jSqliteDataAccess.GetBOF: boolean;
var
  rowCount: integer;
begin
  Result := True;

  if (not FInitialized) then exit;

  rowCount := GetRowCount;

  if (rowCount = POSITION_UNKNOWN) or (rowCount = 0) then Exit;

  Result := (GetPosition = -1);
end;

procedure jSqliteDataAccess.MoveToFirst;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToFirst');
end;

procedure jSqliteDataAccess.MoveToNext;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToNext');
end;

procedure jSqliteDataAccess.MoveToPrev;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToPrev');
end;

procedure jSqliteDataAccess.MoveToLast;
begin
  if not FInitialized then Exit;
  jni_proc(gApp.jni.jEnv, FjObject, 'MoveToLast');
end;

procedure jSqliteDataAccess.MoveToPosition(position: integer);
begin
  if not FInitialized then Exit;
  jni_proc_i(gApp.jni.jEnv, FjObject, 'MoveToPosition', position);
end;

function jSqliteDataAccess.GetRowCount: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetRowCount');
end;

function jSqliteDataAccess.GetColumnCount: integer;
begin
  Result := 0;
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetColumnCount');
end;

function jSqliteDataAccess.GetColumnIndex(colName: string): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'GetColumnIndex', colName);
end;

function jSqliteDataAccess.GetColumName(columnIndex: integer): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetColumName', columnIndex);
end;

{
Cursor.FIELD_TYPE_NULL    //0
Cursor.FIELD_TYPE_INTEGER //1
Cursor.FIELD_TYPE_FLOAT   //2
Cursor.FIELD_TYPE_STRING  //3
Cursor.FIELD_TYPE_BLOB;   //4
}
function jSqliteDataAccess.GetColType(columnIndex: integer): TSqliteFieldType;
var
  colType: integer;
begin
  Result := ftNull;

  if not FInitialized then Exit;

  colType := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetColType', columnIndex);

  case colType of
    0: Result := ftNull;
    1: Result := ftInteger;
    2: Result := ftFloat;
    3: Result := ftString;
    4: Result := ftBlob;
  end;
end;

function jSqliteDataAccess.GetValueAsString(columnIndex: integer): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetValueAsString', columnIndex);
end;

function jSqliteDataAccess.GetValueAsString(colName: string): string;
begin
  Result := '';
  if FInitialized then
    Result := jni_func_t_out_t(gApp.jni.jEnv, FjObject, 'GetValueAsString', colName);
end;

function jSqliteDataAccess.GetValueAsBitmap(columnIndex: integer): jObject;
begin
  Result := nil;
  if FInitialized then
    Result := jni_func_i_out_bmp(gApp.jni.jEnv, FjObject, 'GetValueAsBitmap', columnIndex);
end;

function jSqliteDataAccess.GetValueAsBitmap(colName: string): jObject;
begin

  Result := nil;
  if FInitialized then
    Result := jni_func_t_out_bmp(gApp.jni.jEnv, FjObject, 'GetValueAsBitmap', colName);
end;

function jSqliteDataAccess.GetValueAsInteger(columnIndex: integer): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_i(gApp.jni.jEnv, FjObject, 'GetValueAsInteger', columnIndex);
end;

function jSqliteDataAccess.GetValueAsInteger(colName: string): integer;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'GetValueAsInteger', colName);
end;

function jSqliteDataAccess.GetValueAsDouble(columnIndex: integer): double;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_d(gApp.jni.jEnv, FjObject, 'GetValueAsDouble', columnIndex);
end;

function jSqliteDataAccess.GetValueAsDouble(colName: string): double;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_d(gApp.jni.jEnv, FjObject, 'GetValueAsDouble', colName);
end;

function jSqliteDataAccess.GetValueAsFloat(columnIndex: integer): real;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_i_out_f(gApp.jni.jEnv, FjObject, 'GetValueAsFloat', columnIndex);
end;

function jSqliteDataAccess.GetValueAsFloat(colName: string): real;
begin
  Result := -1;
  if FInitialized then
    Result := jni_func_t_out_f(gApp.jni.jEnv, FjObject, 'GetValueAsFloat', colName);
end;

function jSqliteDataAccess.GetValueToString(columnIndex: integer): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_i_out_t(gApp.jni.jEnv, FjObject, 'GetValueToString', columnIndex);
end;

function jSqliteDataAccess.GetValueToString(colName: string): string;
begin
  Result := '';
  if FInitialized then
    Result := GetValueToString(GetColumnIndex(colName));
end;

function jSqliteDataAccess.GetPosition(): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetPosition');
end;

procedure jSqliteDataAccess.GenEvent_OnSqliteDataAccessAsyncPostExecute(Sender: TObject;
  Count: integer; msgResult: string);
begin
  if Assigned(FOnAsyncPostExecute) then FOnAsyncPostExecute(Sender, Count, msgResult);
end;

{jPanel}

constructor jPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FLParamWidth := lpMatchParent;
  FLParamHeight := lpWrapContent;
  FAcceptChildrenAtDesignTime := True;
  FMarginTop := 0;
  FMarginLeft := 0;
  FMarginRight := 0;
  FMarginBottom := 0;
  FMinZoomFactor := 1 / 4;
  FMaxZoomFactor := 8 / 2;
  FHeight := 48;
  FWidth := 300;

  FAnimationMode := animNone;
  FAnimationDurationIn := 1500;
  FAnimationDurationOut := 1500;
end;

destructor jPanel.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jni_free(gApp.jni.jEnv, FjObject);
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jPanel.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized then
  begin
    inherited Init;
    FjObject := jPanel_Create(gApp.jni.jEnv, gApp.jni.jThis, Self); //jSelf !

    if FjObject = nil then exit;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  FWidth := sysGetLayoutParams(FWidth, FLParamWidth, Self.Parent,
    sdW, fmarginLeft + fmarginRight);
  FHeight := sysGetLayoutParams(FHeight, FLParamHeight, Self.Parent,
    sdH, fMargintop + fMarginbottom);

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    FWidth, FHeight);

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1;

  if not FInitialized then
  begin
    if FMinZoomFactor <> 0.25 then SetMinZoomFactor(FMinZoomFactor);
    if FMaxZoomFactor <> 4.00 then SetMaxZoomFactor(FMaxZoomFactor);
  end;

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin

    FInitialized := True; //needed here! ... fixed !!!

    if FAnimationMode <> animNone then //default
      SetAnimationMode(FAnimationMode);

    if FAnimationDurationIn <> 1500 then //default
      SetAnimationDurationIn(FAnimationDurationIn);

    if FAnimationDurationOut <> 1500 then
      SetAnimationDurationOut(FAnimationDurationOut);

    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, gApp.jni.jThis, FjObject{FjRLayout}{!},
        GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, gApp.jni.jThis, FjObject, FVisible);
  end;

end;

procedure jPanel.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject{FjRLayout}{view!},
      GetARGB(FCustomColor, FColor)); //@@
end;

procedure jPanel.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jPanel.SetParamWidth(Value: TLayoutParams);
begin
  inherited SetParamWidth(Value);
  if FInitialized then
  begin

  end;
end;

procedure jPanel.SetParamHeight(Value: TLayoutParams);
begin
  inherited SetParamHeight(Value);
  if FInitialized then
  begin

  end;
end;

// By ADiV
function jPanel.GetTop: integer;
begin
  Result := 0;
  if not FInitialized then exit;

  Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getTop');
end;

// By ADiV
function jPanel.GetLeft: integer;
begin
  Result := 0;
  if not FInitialized then exit;

  Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getLeft');
end;

// By ADiV
function jPanel.GetBottom: integer;
begin
  Result := 0;
  if not FInitialized then exit;

  Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getBottom');
end;

// By ADiV
function jPanel.GetRight: integer;
begin
  Result := 0;
  if not FInitialized then exit;

  Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'getRight');
end;

function jPanel.GetWidth: integer;
begin
  Result := FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
    Result := sysGetWidthOfParent(FParent)
  else
    Result := View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jPanel.GetHeight: integer;
begin
  Result := FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
    Result := sysGetHeightOfParent(FParent)
  else
    Result := View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jPanel.ClearLayout;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  jni_proc(gApp.jni.jEnv, FjObject, 'resetLParamsRules');

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
  end;
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jPanel.UpdateLayout();
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jPanel.SetViewParent(Value: jObject);
begin
  FjPRLayout := Value;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jPanel.RemoveFromViewParent;
begin
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jPanel.ResetViewParent();
begin
  FjPRLayout := FjPRLayoutHome;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
end;

procedure jPanel.RemoveView(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_viw(gApp.jni.jEnv, FjObject, 'RemoveView', _view);
end;

procedure jPanel.RemoveAllViews();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'RemoveAllViews');
end;

function jPanel.GetChildCount(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetChildCount');
end;

procedure jPanel.BringChildToFront(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_viw(gApp.jni.jEnv, FjObject, 'BringChildToFront', _view);
end;

procedure jPanel.BringToFront;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    FVisible := True;
    View_BringToFront(gApp.jni.jEnv, FjObject);
  end;
end;

procedure jPanel.SetVisibilityGone();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetVisibilityGone');
end;

procedure jPanel.SetAnimationDurationIn(_animationDurationIn: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationIn := _animationDurationIn;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationDurationIn', _animationDurationIn);
end;

procedure jPanel.SetAnimationDurationOut(_animationDurationOut: integer);
begin
  //in designing component state: set value here...
  FAnimationDurationOut := _animationDurationOut;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationDurationOut',
      _animationDurationOut);
end;

procedure jPanel.SetAnimationMode(_animationMode: TAnimationMode);
begin
  //in designing component state: set value here...
  FAnimationMode := _animationMode;
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetAnimationMode', Ord(_animationMode));
end;

procedure jPanel.Animate(_animateIn: boolean; _xFromTo, yFromTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_zii(gApp.jni.jEnv, FjObject, 'Animate', _animateIn, _xFromTo, yFromTo);
end;

procedure jPanel.AnimateRotate(_angleFrom, _angleTo: integer);
begin
  if FjObject = nil then exit;

  jni_proc_ii(gApp.jni.jEnv, FjObject, 'AnimateRotate', _angleFrom, _angleTo);
end;

// Event : Java -> Pascal
procedure jPanel.GenEvent_OnDown(Obj: TObject);
begin
  if Assigned(FOnDown) then FOnDown(Obj);
end;

procedure jPanel.GenEvent_OnUp(Obj: TObject);
begin
  if Assigned(FOnUp) then FOnUp(Obj);
end;

procedure jPanel.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jPanel.GenEvent_OnLongClick(Obj: TObject);
begin
  if Assigned(FOnLongClick) then FOnLongClick(Obj);
end;

procedure jPanel.GenEvent_OnDoubleClick(Obj: TObject);
begin
  if Assigned(FOnDoubleClick) then FOnDoubleClick(Obj);
end;

procedure jPanel.GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
begin
  if Assigned(FOnFling) then  FOnFling(Obj, TFlingGesture(direction));
end;

procedure Java_Event_pOnFlingGestureDetected(env: PJNIEnv; this: jobject;
  Obj: TObject; direction: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnFlingGestureDetected(Obj, direction);
  end;
  if Obj is jViewFlipper then
  begin
    jViewFlipper(Obj).GenEvent_OnFlingGestureDetected(Obj, direction);
  end;
end;

procedure jPanel.GenEvent_OnPinchZoomGestureDetected(Obj: TObject;
  scaleFactor: single; state: integer);
begin
  if Assigned(FOnPinchGesture) then
    FOnPinchGesture(Obj, scaleFactor, TPinchZoomScaleState(state));
end;

procedure Java_Event_pOnPinchZoomGestureDetected(env: PJNIEnv;
  this: jobject; Obj: TObject; scaleFactor: single; state: integer);
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jPanel then
  begin
    jPanel(Obj).GenEvent_OnPinchZoomGestureDetected(Obj, scaleFactor, state);
  end;
end;


procedure jPanel.SetMinZoomFactor(_minZoomFactor: single);
begin
  //in designing component state: set value here...
  FMinZoomFactor := _minZoomFactor;
  if FjObject = nil then exit;

  jni_proc_f(gApp.jni.jEnv, FjObject, 'SetMinZoomFactor', _minZoomFactor);
end;

procedure jPanel.SetMaxZoomFactor(_maxZoomFactor: single);
begin
  //in designing component state: set value here...
  FMaxZoomFactor := _maxZoomFactor;
  if FjObject = nil then exit;

  jni_proc_f(gApp.jni.jEnv, FjObject, 'SetMaxZoomFactor', _maxZoomFactor);
end;

procedure jPanel.CenterInParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'CenterInParent');
end;

procedure jPanel.MatchParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'MatchParent');
end;

procedure jPanel.WrapContent();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'WrapContent');
end;

procedure jPanel.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc(gApp.jni.jEnv, FjObject, 'SetRoundCorner');
end;

procedure jPanel.SetRoundCorners(_TopLeftRadius, _TopRightRadius,
  _BottomRightRadius, _BottomLeftRadius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_ffff(gApp.jni.jEnv, FjObject, 'SetRoundCorners',
      _TopLeftRadius, _TopRightRadius, _BottomRightRadius, _BottomLeftRadius);
end;

procedure jPanel.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetRadiusRoundCorner', _radius);
end;

procedure jPanel.SetBackgroundAlpha(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetBackgroundAlpha', _alpha);
end;

procedure jPanel.SetMarginLeftTopRightBottom(_left, _top, _right, _bottom: integer);
begin
  FMarginLeft := _left;
  FMarginTop := _top;
  FMarginRight := _right;
  FMarginBottom := _bottom;
  if FInitialized then
    jni_proc_iiii(gApp.jni.jEnv, FjObject, 'SetMarginLeftTopRightBottom',
      _left, _top, _right, _bottom);
end;

function jPanel.GetViewParent(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetParent(gApp.jni.jEnv, FjObject);
end;

(*
procedure jPanel.AddView(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_AddView(gApp.jni.jEnv, FjObject, _view);
end;
*)
procedure jPanel.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

{---------  jDBListView  --------------}

constructor jDBListView.Create(AOwner: TComponent);

begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FMarginLeft := 10;
  FMarginTop := 10;
  FMarginBottom := 10;
  FMarginRight := 10;
  FLParamWidth := lpMatchParent;
  FLParamHeight := lpMatchParent;
  FHeight := 160; //??
  FWidth := 96; //??
  FAcceptChildrenAtDesignTime := False;
  //your code here....
  FColWeights := TStringList.Create;
  FColNames := TStringList.Create;
  FjSqliteCursor := nil;
end;

destructor jDBListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject <> nil then
    begin
      jFree();
      FjObject := nil;
    end;
  end;
  //you others free code here...'
  if FjSqliteCursor <> nil then FjSqliteCursor.UnRegisterObserver(self);
  if FColNames <> nil then FColNames.Free;
  if FColWeights <> nil then FColWeights.Free;

  inherited Destroy;
end;

procedure jDBListView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  i: integer;
  weights: TDynArrayOfSingle;
  names: TDynArrayOfString;
begin
  if not FInitialized then
  begin
    inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
    //your code here: set/initialize create params....
    FjObject := jCreate();  //jSelf !

    if FjObject = nil then exit;

    if FFontColor <> colbrDefault then
      SetFontColor(FFontColor);

    if FFontSizeUnit <> unitDefault then
      SetFontSizeUnit(FFontSizeUnit);

    if FFontSize > 0 then
      SetFontSize(FFontSize);

    weights := nil;

    if FColWeights.Count > 0 then
    begin
      SetLength(weights, FColWeights.Count);
      for i := 0 to FColWeights.Count - 1 do
        weights[i] := StrToFloat(FColWeights[i]);
      jDBListView_SetColumnWeights(gApp.jni.jEnv, FjObject, weights{FColWeights});
    end;

    names := nil;

    if FColNames.Count > 0 then
    begin
      SetLength(names, FColNames.Count);
      for i := 0 to FColNames.Count - 1 do
        names[i] := FColNames[i];
      jDBListView_SetColumnNames(gApp.jni.jEnv, FjObject, names{FColNames});
    end;

    if FParent <> nil then
      sysTryNewParent(FjPRLayout, FParent);

    FjPRLayoutHome := FjPRLayout;

    View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
    View_setId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
    FMarginLeft, FMarginTop,
    FMarginRight, FMarginBottom,
    sysGetLayoutParams(
    FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight),
    sysGetLayoutParams(
    FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom));

  //if FColNames.Count > 0 then
  //begin
  //  SetLength(names, FColNames.Count);
  //  for i := 0 to FColNames.Count-1 do
  //    names[i] := FColNames[i];
  //  jDBListView_SetColumnNames(gApp.jni.jEnv, FjObject, names{FColNames});
  //end;


  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
        GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then
    Self.AnchorId := Self.Anchor.Id
  else
    Self.AnchorId := -1; //dummy

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;
    if FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jDBListView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jDBListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FjSqliteCursor then
    begin
      FjSqliteCursor := nil;
    end;
  end;
end;

procedure jDBListView.SetColumnWeights(Value: TStrings);
var
  i: integer;
  weights: TDynArrayOfSingle;
begin
  if Value = nil then exit;
  if FColWeights = nil then exit;

  if FColWeights <> Value then
    FColWeights.Assign(Value);

  weights := nil;

  if FInitialized and (Value.Count <> 0) then
  begin
    SetLength(weights, Value.Count);
    for i := 0 to Value.Count - 1 do
      weights[i] := StrToFloat(Value[i]);
    jDBListView_SetColumnWeights(gApp.jni.jEnv, FjObject, weights);
  end;
end;

procedure jDBListView.SetColumnNames(Value: TStrings);
var
  i: integer;
  names: TDynArrayOfString;
begin
  if Value = nil then exit;
  if FColNames = nil then exit;

  if FColNames <> Value then
    FColNames.Assign(Value);

  names := nil;

  if FInitialized {and (Value.Count <> 0)} then
  begin
    SetLength(names, Value.Count);
    if (Value.Count <> 0) then
      for i := 0 to Value.Count - 1 do
        names[i] := Value[i];
    jDBListView_SetColumnNames(gApp.jni.jEnv, FjObject, names);
  end;
end;

procedure jDBListView.SetCursor(Value: jSqliteCursor);
begin

  //DBListView_Log ('Entering SetCursor ...');
  if Value <> FjSqliteCursor then
  begin
    if FjSqliteCursor <> nil then
      if Assigned(FjSqliteCursor) then
      begin
        //DBListView_Log ('... phase 1 ...');
        FjSqliteCursor.UnRegisterObserver(Self);
        FjSqliteCursor.RemoveFreeNotification(Self); //remove free notification...
      end;

    //DBListView_Log ('... phase 2 ...');
    FjSqliteCursor := Value;

    if Value <> nil then  //re- add free notification...
    begin
      //DBListView_Log ('... phase 3 ...');
      Value.RegisterObserver(self);
      Value.FreeNotification(self);
      ChangeCursor(Value);
    end;
  end;
  //DBListView_Log ('Exiting SetCursor');
end;

procedure jDBListView.SetVisible(Value: boolean);
begin
  FVisible := Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jDBListView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jDBListView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jDBListView.GenEvent_OnClickDBListItem(Obj: TObject;
  position: integer; itemCaption: string);
begin
  if Assigned(FOnClickDBListItem) then
    FOnClickDBListItem(Obj, position, itemCaption);
end;

procedure jDBListView.GenEvent_OnLongClickDBListItem(Obj: TObject;
  position: integer; itemCaption: string);
begin
  if Assigned(FOnLongClickDBListItem) then
    FOnLongClickDBListItem(Obj, position, itemCaption);
end;

function jDBListView.jCreate(): jObject;
begin
  //in designing component state: result value here...
  Result := jDBListView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jDBListView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_free(gApp.jni.jEnv, FjObject);
end;

function jDBListView.GetView(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jDBListView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  FjPRLayout := _viewgroup;
  if FInitialized then
    View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

procedure jDBListView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
    View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jDBListView.GetParent(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
    Result := View_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jDBListView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jDBListView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

procedure jDBListView.setLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jDBListView.setLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jDBListView.SetLeftTopRightBottomWidthHeight(_left: integer;
  _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
      _left, _top, _right, _bottom, _w, _h);
end;

procedure jDBListView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jDBListView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jDBListView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jDBListView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
    View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

    for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        View_AddLParamsParentRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToParent(rToP));

    for rToA := raAbove to raAlignRight do
      if rToA in FPositionRelativeToAnchor then
        View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject,
          GetPositionRelativeToAnchor(rToA));
  end;
end;

{
procedure jDBListView.UpdateView();
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_UpdateView(gApp.jni.jEnv, FjObject);
end;
}
(*
procedure jDBListView.SetItemsLayout(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_SetItemsLayout(gApp.jni.jEnv, FjObject, _value);
end;
*)
function jDBListView.GetItemIndex(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetItemIndex');
end;

function jDBListView.GetItemCaption(): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
    Result := jni_func_out_t(gApp.jni.jEnv, FjObject, 'GetItemCaption');
end;

procedure jDBListView.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetSelection', _index);
end;

procedure jDBListView.SetFontSize(_size: DWord);
begin
  //in designing component state: set value here...
  FFontSize := _size;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSize', _size);
end;

procedure jDBListView.SetFontColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor := _color;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontColor', GetARGB(FCustomColor, _color));
end;

procedure jDBListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit := _unit;
  if FjObject = nil then exit;

  jni_proc_i(gApp.jni.jEnv, FjObject, 'SetFontSizeUnit', Ord(_unit));
end;

procedure jDBListView.ChangeCursor(NewCursor: jSqliteCursor);
begin
  //in designing component state: set value here...
  if FInitialized then
    jDBListView_ChangeCursor(gApp.jni.jEnv, FjObject, NewCursor.Cursor);
end;

procedure Java_Event_pOnClickDBListItem(env: PJNIEnv; this: jobject;
  Obj: TObject; position: integer; Caption: JString);
var
  pascaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jDBListView then
  begin
    pascaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pascaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jDBListView(Obj).GenEvent_OnClickDBListItem(Obj, position, pascaption);
  end;
end;

procedure Java_Event_pOnLongClickDBListItem(env: PJNIEnv; this: jobject;
  Obj: TObject; position: integer; Caption: JString);
var
  pascaption: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv := env;
  if this <> nil then gApp.Jni.jThis := this;

  if Obj is jDBListView then
  begin
    pascaption := '';
    if Caption <> nil then
    begin
      _jBoolean := JNI_False;
      pascaption := string(env^.GetStringUTFChars(env, Caption, @_jBoolean));
    end;
    jDBListView(Obj).GenEvent_OnLongClickDBListItem(Obj, position, pascaption);
  end;
end;


end.
