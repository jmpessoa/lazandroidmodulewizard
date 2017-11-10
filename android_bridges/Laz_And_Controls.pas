//------------------------------------------------------------------------------
//
//   Native Android Controls for Pascal

//   [Lazarus Support by jmpessoa@hotmail.com - december 2013]
//    https://github.com/jmpessoa/lazandroidmodulewizard

//   Compiler   Free Pascal Compiler FPC 2.7.1, ( XE5 in near future )
//
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

unit Laz_And_Controls;

//A modified and expanded version of the simonsayz's "And_Controls.pas"
//for Lazarus Android Module Wizard: Form Designer and Components development model!
//Author: jmpessoa@hotmail.com
//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.0.html

//Start:  - 26-october-2013
//Ver_0.1 - 08-december-2013
//Ver_0.2 - 08-february-2014: Added support to Android API > 13

{$mode delphi}

interface

uses
  SysUtils, Classes,
  And_jni, And_jni_Bridge,
  And_lib_Unzip, And_bitmap_h,
  AndroidWidget;

type

  TImageListIndex = type Integer;

  jCanvas = class;

  TOnDraw  = Procedure(Sender: TObject) of object;

  TSqliteFieldType = (ftNull,ftInteger,ftFloat,ftString,ftBlob);

 jPanel = class(jVisualControl)
   private
     FOnFling: TOnFling;
     FOnPinchGesture: TOnPinchZoom;
     FMinZoomFactor: single;
     FMaxZoomFactor: single;

     Procedure SetColor(Value : TARGBColorBridge); //background
     procedure UpdateLParamHeight;
     procedure UpdateLParamWidth;
   protected

     procedure SetViewParent(Value: jObject); override;
     procedure SetParamHeight(Value: TLayoutParams); override;
      procedure SetParamWidth(Value: TLayoutParams); override;
   public
     constructor Create(AOwner: TComponent); override;
     Destructor  Destroy; override;
     Procedure Refresh;
     Procedure UpdateLayout; override;
     procedure Init(refApp: jApp);  override;

     function GetWidth: integer;  override;
     function GetHeight: integer; override;

     procedure ResetAllRules;
     procedure RemoveParent;
     procedure GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
     procedure GenEvent_OnPinchZoomGestureDetected(Obj: TObject; scaleFactor: single; state: integer);

     procedure SetMinZoomFactor(_minZoomFactor: single);
     procedure SetMaxZoomFactor(_maxZoomFactor: single);

     procedure CenterInParent();
     procedure MatchParent();
     procedure WrapContent();
     procedure SetRoundCorner();
     procedure SetRadiusRoundCorner(_radius: integer);
     procedure SetBackgroundAlpha(_alpha: integer); //You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
     procedure SetMarginLeftTopRightBottom(_left,_top,_right,_bottom: integer);

   published
     property BackgroundColor     : TARGBColorBridge read FColor write SetColor;
     property MinPinchZoomFactor: single read FMinZoomFactor write FMinZoomFactor;
     property MaxPinchZoomFactor: single read FMaxZoomFactor write FMaxZoomFactor;

     property OnFlingGesture: TOnFling read FOnFling write FOnFling;
     property OnPinchZoomGesture: TOnPinchZoom read FOnPinchGesture write FOnPinchGesture;

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

    procedure Init(refApp: jApp) override;
    function jCreate(): jObject;
    procedure jFree();

    function GetImageByIndex(index: integer): string;
    function GetImageExByIndex(index: integer): string;
    function GetBitmap(imageIndex: integer): jObject;

    // Property
    property Count: integer read  GetCount;
  published
    property Images: TStrings read FImages write SetImages;
  end;

  THttpClientAuthenticationMode = (autNone, autBasic{, autOAuth}); //TODO: autOAuth
  TOnHttpClientContentResult = procedure(Sender: TObject; content: string) of Object;
  TOnHttpClientCodeResult = procedure(Sender: TObject; code: integer) of Object;

  //NEW by jmpessoa

  { jHttpClient }

  jHttpClient = class(jControl)
  private
    FUrl : string;
    FUrls: TStrings;
    FIndexUrl: integer;
    FCharSet: string;
    FAuthenticationMode: THttpClientAuthenticationMode;

    FOnContentResult: TOnHttpClientContentResult;
    FOnCodeResult: TOnHttpClientCodeResult;

    FResponseTimeout: integer;
    FConnectionTimeout: integer;

    procedure SetCharSet(AValue: string);
    procedure SetIndexUrl(Value: integer);
    procedure SetUrlByIndex(Value: integer);
    procedure SetUrls(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure GetAsync(_stringUrl: string); overload;
    procedure GetAsync; overload;

    //thanks to Fatih KILIÇ
    function Get(_stringUrl: string): string;  overload;
    function Get(): string;   overload;

    procedure SetAuthenticationUser(_userName: string; _password: string);
    procedure SetAuthenticationMode(_authenticationMode: THttpClientAuthenticationMode);
    procedure SetAuthenticationHost(_hostName: string; _port: integer);

    procedure PostNameValueDataAsync(_stringUrl: string); overload;
    procedure PostNameValueDataAsync(_stringUrl: string; _name: string; _value: string); overload;
    procedure PostNameValueDataAsync(_stringUrl: string; _listNameValue: string);  overload;

    //thanks to Fatih KILIÇ
    procedure ClearNameValueData; //ClearPost2Values;
    procedure AddNameValueData(_name, _value: string); //AddValueForPost2;
    function Post(_stringUrl: string): string; overload;

    function GetCookiesCount(): integer;
    function GetCookieByIndex(_index: integer): jObject;
    function GetCookieAttributeValue(_cookie: jObject; _fieldName: string): string;
    procedure ClearCookieStore();
    function AddCookie(_name: string; _value: string): jObject;  overload;
    function IsExpired(_cookie: jObject): boolean;
    function GetStateful(_url: string): string;
    function PostStateful(_url: string): string;
    function IsCookiePersistent(_cookie: jObject): boolean;
    procedure SetCookieValue(_cookie: jObject; _value: string);
    function GetCookieByName(_cookieName: string): jObject;
    procedure SetCookieAttributeValue(_cookie: jObject; _attribute: string; _value: string);
    function GetCookieValue(_cookie: jObject): string;
    function GetCookieName(_cookie: jObject): string;

    function GetCookies(_nameValueSeparator: string): TDynArrayOfString;  overload;

    procedure AddClientHeader(_name: string; _value: string);
    procedure ClearClientHeader(_name: string; _value: string);
    function DeleteStateful(_url: string; _value:string): string;  //thanks to @renabor

    function UrlExist(_urlString: string): boolean;

    function GetCookies(_urlString: string; _nameValueSeparator: string): TDynArrayOfString;  overload;

    function AddCookie(_urlString: string; _name: string; _value: string): jObject;  overload;

    function OpenConnection(_urlString: string): jObject;
    function SetRequestProperty(_httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
    //function Connect(_httpConnection: jObject): jObject;

    function GetHeaderField(_httpConnection: jObject; _headerName: string): string;
    function GetHeaderFields(_httpConnection: jObject): TDynArrayOfString;

    procedure Disconnect(_httpConnection: jObject);
    function Get(_httpConnection: jObject): string; overload;
    function AddRequestProperty(_httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
    function Post(_httpConnection: jObject): string; overload;
    function GetResponseCode(): integer;
    function GetDefaultConnection(): jObject;
    procedure SetResponseTimeout(_timeoutMilliseconds: integer);
    procedure SetConnectionTimeout(_timeoutMilliseconds: integer);
    function GetResponseTimeout(): integer;
    function GetConnectionTimeout(): integer;

    procedure GenEvent_OnHttpClientContentResult(Obj: TObject; content: string);
    procedure GenEvent_OnHttpClientCodeResult(Obj: TObject; code: integer);

    // Property
    property Url: string read FUrl;
  published
    property CharSet: string read FCharSet write SetCharSet;
    property IndexUrl: integer read  FIndexUrl write SetIndexUrl;
    property Urls: TStrings read FUrls write SetUrls;
    property AuthenticationMode: THttpClientAuthenticationMode read FAuthenticationMode write SetAuthenticationMode;
    property ResponseTimeout: integer read GetResponseTimeout write SetResponseTimeout;
    property ConnectionTimeout: integer read GetConnectionTimeout write SetConnectionTimeout;

    property OnContentResult: TOnHttpClientContentResult read FOnContentResult write FOnContentResult;
    property OnCodeResult: TOnHttpClientCodeResult read FOnCodeResult write FOnCodeResult;
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
   procedure Init(refApp: jApp) override;
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
   procedure Init(refApp: jApp) override;
   function Send(multipartMessage: Boolean = False): integer; overload;

   function Send(toNumber: string;  msg: string; multipartMessage: Boolean = False): integer; overload;
   function Send(toNumber: string;  msg: string; packageDeliveredAction: string; multipartMessage: Boolean = False): integer; overload;
   function Send(toName: string; multipartMessage: Boolean = False): integer; overload;

   function Read(intentReceiver: jObject; addressBodyDelimiter: string): string;
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
   FRequestCode: integer;
  public
   FullPathToBitmapFile: string;
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   procedure Init(refApp: jApp) override;
   procedure TakePhoto; overload;
   procedure TakePhoto(_filename: string ; _requestCode: integer); overload;

   // Property
   property RequestCode: integer read FRequestCode write FRequestCode;
  published
    property Filename: string read FFilename write FFilename;
    property FilePath: TFilePath read FFilePath write FFilePath;
  end;

  jTimer = class(jControl)
  private
    // Java
    FjParent   : jForm;
    FInterval : integer;
    FOnTimer  : TOnNotify;
    Procedure SetInterval(Value: integer);
    //Procedure SetOnTimer(Value: TOnNotify);
  protected
      Procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init(refApp: jApp) override;
    //Property
    property jParent   : jForm     read FjParent   write FjParent;
  published
    property Enabled  : boolean   read FEnabled  write SetEnabled;
    property Interval : integer   read FInterval write SetInterval;
    //Event
    property OnTimer: TOnNotify read FOnTimer write FOnTimer;//SetOnTimer;
  end;

  jBitmap = class(jControl)
  private
    FWidth  : integer;
    FHeight : integer;
    FStride : Cardinal;
    FFormat : Integer;
    FFlags  : Cardinal;

    FImageName: string;
    FImageIndex: TImageListIndex;
    FImageList : jImageList;  //by jmpessoa

    { TFilePath = (fpathApp, fpathData, fpathExt, fpathDCIM); }
    FFilePath: TFilePath;

    FBitmapInfo : AndroidBitmapInfo;
    procedure SetImages(Value: jImageList);   //by jmpessoa

    procedure SetImageIndex(Value: TImageListIndex);

    procedure SetImageByIndex(Value: integer);

    procedure SetImageIdentifier(Value: string);  // ...res/drawable

    function TryPath(path: string; fileName: string): boolean;

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp) override;

    Procedure LoadFromFile(fullFileName : String);
    Procedure LoadFromRes( imgResIdenfier: String);  // ..res/drawable

    Procedure CreateJavaBitmap(w,h : Integer);
    Function  GetJavaBitmap: jObject;  //deprecated ..
    Function  GetImage(): jObject;

    function BitmapToArrayOfJByte(var bufferImage: TDynArrayOfJByte): integer;  //local/self

    function GetByteArrayFromBitmap(var bufferImage: TDynArrayOfJByte): integer;

    procedure SetByteArrayToBitmap(var bufferImage: TDynArrayOfJByte; size: integer);

    procedure LockPixels(var PDWordPixel: PScanLine); overload;
    procedure LockPixels(var PBytePixel: PScanByte {delphi mode} ); overload;
    procedure LockPixels(var PSJByte: PJByte{fpc mode}); overload;
    procedure UnlockPixels;

    procedure ScanPixel(PBytePixel: PScanByte; notByteIndex: integer); overload;   //TODO - just draft
    procedure ScanPixel(PDWordPixel: PScanLine);  overload;                        //TODO - just draft

    function GetInfo: boolean;
    function GetRatio: Single;

    function ClockWise(_bmp: jObject; _imageView: jObject): jObject;
    function AntiClockWise(_bmp: jObject; _imageView: jObject): jObject;
    function SetScale(_bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject; overload;
    function SetScale(_imageView: jObject; _scaleX: single; _scaleY: single): jObject; overload;
    function LoadFromAssets(strName: string): jObject;
    function GetResizedBitmap(_bmp: jObject; _newWidth: integer; _newHeight: integer): jObject; overload;
    function GetResizedBitmap(_newWidth: integer; _newHeight: integer): jObject; overload;
    function GetResizedBitmap(_factorScaleX: single; _factorScaleY: single): jObject; overload;

    function GetByteBuffer(_width: integer; _height: integer): jObject;
    function GetBitmapFromByteBuffer(_byteBuffer: jObject; _width: integer; _height: integer): jObject; overload;
    function GetBitmapFromByteArray(var _image: TDynArrayOfJByte): jObject;

    function GetByteBufferFromBitmap(_bmap: jObject): jObject; overload;
    function GetByteBufferFromBitmap(): jObject; overload;
    function GetDirectBufferAddress(byteBuffer: jObject): PJByte;
    function GetImageFromFile(_fullFilename: string): jObject;
    function GetRoundedShape(_bitmapImage: jObject): jObject;   overload;
    function GetRoundedShape(_bitmapImage: jObject; _diameter: integer): jObject; overload;

  published
    property FilePath: TFilePath read FFilePath write FFilePath;
    property ImageIndex: TImageListIndex read FImageIndex write SetImageIndex default -1;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    property ImageIdentifier: string read FImageName write SetImageIdentifier;
    //property ImageName: string read FImageName write SetImageName;
    property  Width   : integer           read FWidth      write FWidth;
    property  Height  : integer           read FHeight     write FHeight;
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
    procedure Init(refApp: jApp)  override;

    Procedure Show;   overload;
    Procedure Show(titleText: string; msgText: string; yesText: string; noText: string); overload;
    Procedure Show(titleText: string; msgText: string); overload;
    procedure ShowOK(titleText: string; msgText: string; _OkText: string);

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
    procedure Init(refApp: jApp) override;
    procedure Start;
    procedure Stop;
    procedure Close;

    procedure Show();   overload;
    procedure Show(_title: string; _msg: string);   overload;
    procedure Show(_layout: jObject);   overload;

    procedure SetMessage(_msg: string);
    procedure SetTitle(_title: string);

    procedure SetCancelable(_value: boolean);

    property Parent: jForm read FParent write FParent;
  published
    property Title: string read FTitle write SetTitle;
    property Msg: string read FMsg write SetMessage;
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
    Procedure GenEvent_OnAsyncEventDoInBackground(Obj: TObject; progress: Integer; out keepInBackground: boolean);
    procedure GenEvent_OnAsyncEventProgressUpdate(Obj: TObject; progress: Integer; out progressUpdate: integer);
    procedure GenEvent_OnAsyncEventPreExecute(Obj: TObject; out startProgress: integer);
    procedure GenEvent_OnAsyncEventPostExecute(Obj: TObject; progress: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp) override;
    procedure Done;    //by jmpessoa
    Procedure Execute;
    property Running: boolean read FRunning  write FRunning;
    property AsyncTaskState: TAsyncTaskState read FAsyncTaskState write FAsyncTaskState;
  published
    // Event
    property OnDoInBackground : TOnAsyncEventDoInBackground read FOnDoInBackground write FOnDoInBackground;
    property OnProgressUpdate: TOnAsyncEventProgressUpdate read FOnProgressUpdate write FOnProgressUpdate;
    property OnPreExecute: TOnAsyncEventPreExecute read FOnPreExecute write FOnPreExecute;
    property OnPostExecute: TOnAsyncEventPostExecute read FOnPostExecute write FOnPostExecute;
  end;

  //NEW by jmpessoa
  jSqliteCursor = class(jControl)
   private
      //
   protected
   public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     procedure Init(refApp: jApp) override;

     procedure MoveToFirst;
     procedure MoveToNext;
     procedure MoveToLast;
     procedure MoveToPosition(position: integer);
     function GetRowCount: integer;

     function GetColumnCount: integer;
     function GetColumnIndex(colName: string): integer;
     function GetColumName(columnIndex: integer): string;
     function GetColType(columnIndex: integer): TSqliteFieldType;
     function GetValueAsString(columnIndex: integer): string;   overload;
     function GetValueAsBitmap(columnIndex: integer): jObject;
     function GetValueAsInteger(columnIndex: integer): integer;
     function GetValueAsDouble(columnIndex: integer): double;
     function GetValueAsFloat(columnIndex: integer): real;

     procedure SetCursor(Value: jObject);
     //position = -1 --> Last Row !
     function GetValueAsString(position: integer; columnName: string): string; overload;

   published
   end;

  //NEW by jmpessoa
  jSqliteDataAccess = class(jControl)
  private
    FjSqliteCursor    : jSqliteCursor;
    FColDelimiter: char;
    FRowDelimiter: char;
    FDataBaseName: string;
    FFullPathDataBaseName: string;
    FCreateTableQuery: TStrings;
    FTableName: TStrings;
    FReturnHeaderOnSelect: boolean;
    procedure SetjSqliteCursor(Value: jSqliteCursor);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp) override;
    Procedure ExecSQL(execQuery: string);
    function CheckDataBaseExists(dataBaseName: string): boolean;
    procedure OpenOrCreate(dataBaseName: string);

    procedure SetVersion(version :integer); //renabor
    function GetVersion():integer; // renabor

    procedure AddTable(tableName: string; createTableQuery: string);
    procedure CreateAllTables;

    function Select(selectQuery: string): string;   overload;  //set cursor and return selected rows
    function Select(selectQuery: string; moveToLast: boolean): boolean;   overload;

    procedure SetSelectDelimiters(coldelim: char; rowdelim: char);
    procedure CreateTable(createQuery: string);
    procedure DropTable(tableName: string);
    procedure InsertIntoTable(insertQuery: string);
    procedure DeleteFromTable(deleteQuery: string);
    procedure UpdateTable(updateQuery: string);
    procedure UpdateImage(tableName: string;imageFieldName: string;keyFieldName: string; imageValue: jObject;keyValue: integer); overload;
    procedure Close;
    function  GetCursor: jObject; overload;

    procedure SetForeignKeyConstraintsEnabled(_value: boolean);
    procedure SetDefaultLocale();
    procedure DeleteDatabase(_dbName: string);
    procedure UpdateImage(_tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer); overload;
    procedure InsertIntoTableBatch(var _insertQueries: TDynArrayOfString);
    procedure UpdateTableBatch(var _updateQueries: TDynArrayOfString);
    function CheckDataBaseExistsByName(_dbName: string): boolean;
    procedure UpdateImageBatch(var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);

    procedure SetDataBaseName(_dbName: string);
    function GetFullPathDataBaseName(): string;

    function DatabaseExists(_databaseName: string): boolean;
    procedure SetAssetsSearchFolder(_folderName: string);
    procedure SetReturnHeaderOnSelect(_returnHeader: boolean);

    property FullPathDataBaseName: string read GetFullPathDataBaseName;

  published
    property Cursor    : jSqliteCursor read FjSqliteCursor write SetjSqliteCursor;
    property ColDelimiter: char read FColDelimiter write FColDelimiter;
    property RowDelimiter: char read FRowDelimiter write FRowDelimiter;
    property DataBaseName: string read FDataBaseName write SetDataBaseName;
    property CreateTableQuery: TStrings read FCreateTableQuery write FCreateTableQuery;
    property TableName: TStrings read FTableName write FTableName;
    property ReturnHeaderOnSelect: boolean read FReturnHeaderOnSelect write SetReturnHeaderOnSelect;
  end;

  //http://startandroid.ru/en/lessons/complete-list/
  //http://startandroid.ru/en/lessons/complete-list/224-lesson-18-changing-layoutparams-in-a-running-application.html
  //http://stackoverflow.com/questions/13557387/align-radiobuttons-with-text-at-right-and-button-at-left-programmatically?rq=1

  { jTextView }

  jTextView = class(jVisualControl)
  private
    // FFontFace: TFontFace;
    //FOnClick: TOnNotify;
    FTextAlignment: TTextAlignment;
    FTextTypeFace: TTextTypeFace;

    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );

    Procedure SetTextAlignment(Value: TTextAlignment);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    Procedure SetEnabled  (Value : Boolean); override;
    Function  GetText: string;   override;

    procedure SetFontFace(AValue: TFontFace); //override;
    procedure SetTextTypeFace(Value: TTextTypeFace); //override;

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetViewParent(Value: jObject);  override;
    Procedure GenEvent_OnClick(Obj: TObject);

    Procedure GenEvent_OnLOngClick(Obj: TObject);

    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Append(_txt: string);
    procedure AppendLn(_txt: string);
    procedure CopyToClipboard();
    procedure PasteFromClipboard();

    Procedure SetText(Value: string ); override;
    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide); overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide); overload;
    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetShadowLayer(_radius: single; _dx: single; _dy: single; _color: TARGBColorBridge);
    procedure SetShaderLinearGradient(_startColor: TARGBColorBridge; _endColor: TARGBColorBridge);
    procedure SetShaderRadialGradient(_centerColor: TARGBColorBridge; _edgeColor: TARGBColorBridge);
    procedure SetShaderSweepGradient(_color1: TARGBColorBridge; _color2: TARGBColorBridge);
    procedure SetTextDirection(_textDirection: TTextDirection);
    procedure SetFontFromAssets(_fontName: string);
    procedure SetTextIsSelectable(_value: boolean);
    procedure SetScrollingText();
    procedure SetTextAsLink(_linkText: string);
    procedure SetBackgroundAlpha(_alpha: integer); //You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
    procedure MatchParent();
    procedure WrapParent();
    procedure ResetAllRules();

  published
    property Text: string read GetText write SetText;
    property Alignment : TTextAlignment read FTextAlignment write SetTextAlignment;
    property Enabled   : Boolean read FEnabled   write SetEnabled;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property FontSize  : DWord   read FFontSize  write SetFontSize;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;

    // Event - if enabled!
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnLongClick: TOnNotify read FOnLongClick write FOnLongClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnLayouting: TOnLayouting read FOnLayouting write FOnLayouting;
  end;

  jEditText = class(jVisualControl)
  private
    FInputTypeEx: TInputTypeEx;
    FHint     : string;
    FMaxTextLength : integer;
    FSingleLine: boolean;
    FMaxLines:  DWord;  //visibles lines!

    FScrollBarStyle: TScrollBarStyle;
    FHorizontalScrollBar: boolean;
    FVerticalScrollBar: boolean;
    FWrappingLine: boolean;

    FOnLostFocus: TOnEditLostFocus;
    FOnEnter  : TOnNotify;
    FOnChange : TOnChange;
    FOnChanged : TOnChange;
    FEditable: boolean;

    FTextAlignment: TTextAlignment;
    FCloseSoftInputOnEnter: boolean;
    FCapSentence: boolean;

    Procedure SetColor    (Value : TARGBColorBridge);

    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Procedure SetHint     (Value : String );

    Procedure SetInputTypeEx(Value : TInputTypeEx);
    Procedure SetTextMaxLength(Value     : integer     );
    Function  GetCursorPos           : TXY;
    Procedure SetCursorPos(Value     : TXY       );
    Procedure SetTextAlignment(Value: TTextAlignment);

    procedure SetSingleLine(Value: boolean);
    procedure SetScrollBarStyle(Value: TScrollBarStyle);

    Procedure SetMaxLines(Value : DWord);
    procedure SetVerticalScrollBar(Value: boolean);
    procedure SetHorizontalScrollBar(Value: boolean);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    Procedure SetText(Value: string ); override;
    Function  GetText: string; override;
    procedure SetViewParent(Value: jObject);  override;

    procedure SetFontFace(AValue: TFontFace);
    procedure SetTextTypeFace(Value: TTextTypeFace);
    procedure SetEditable(enabled: boolean);
    procedure SetHintTextColor(Value: TARGBColorBridge);

    Procedure GenEvent_OnEnter (Obj: TObject);
    Procedure GenEvent_OnChange(Obj: TObject; txt: string; count : Integer);
    Procedure GenEvent_OnChanged(Obj: TObject; txt : string; count: integer);
    Procedure GenEvent_OnClick(Obj: TObject);
    Procedure GenEvent_OnOnLostFocus(Obj: TObject; txt: string);

    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);

  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    procedure SetMovementMethod;
    procedure SetScrollBarFadingEnabled(Value: boolean);
    //
    Procedure SetFocus;
    Procedure ImmShow;
    Procedure ImmHide;
    procedure HideSoftInput();
    Procedure ShowSoftInput();

    Procedure UpdateLayout; override;
    procedure AllCaps;
    procedure DispatchOnChangeEvent(value: boolean);
    procedure DispatchOnChangedEvent(value: boolean);

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
    procedure SetSelectAllOnFocus(_value: boolean);
    procedure SelectAll();
    procedure SetBackgroundByResIdentifier(_imgResIdentifier: string);
    procedure SetBackgroundByImage(_image: jObject);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide); overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide); overload;
    procedure SetTextDirection(_textDirection: TTextDirection);
    procedure SetFontFromAssets(_fontName: string);
    procedure RequestFocus();
    procedure SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
    procedure SetCapSentence(_capSentence: boolean);

    procedure LoadFromFile(_path: string; _filename: string);  overload;
    procedure LoadFromFile(_filename: string);  overload;
    procedure SaveToFile(_path: string; _filename: string);  overload;
    procedure SaveToFile(_filename: string); overload;
    procedure ResetAllRules();

    // Property
    property CursorPos : TXY        read GetCursorPos  write SetCursorPos;
    //property Scroller: boolean  read FScroller write SetScroller;
  published
    property Text: string read GetText write SetText;
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;

    property InputTypeEx : TInputTypeEx read FInputTypeEx write SetInputTypeEx;
    property MaxTextLength : integer read FMaxTextLength write SetTextMaxLength;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontColor : TARGBColorBridge      read FFontColor    write SetFontColor;
    property FontSize  : DWord      read FFontSize     write SetFontSize;

    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal; 
    property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace default tfNormal;
    property Hint      : string     read FHint         write SetHint;
    property HintTextColor: TARGBColorBridge read FHintTextColor write SetHintTextColor;
    property ScrollBarStyle: TScrollBarStyle read FScrollBarStyle write SetScrollBarStyle;
    //Max visible lines!
    property MaxLines: DWord read FMaxLines write SetMaxLines;
    property HorScrollBar: boolean read FHorizontalScrollBar write SetHorizontalScrollBar;
    property VerScrollBar: boolean read FVerticalScrollBar write SetVerticalScrollBar;
    property WrappingLine: boolean read FWrappingLine write FWrappingLine;
    property Editable: boolean read FEditable write SetEditable;

    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property CloseSoftInputOnEnter: boolean read FCloseSoftInputOnEnter write SetCloseSoftInputOnEnter;
    property CapSentence: boolean read FCapSentence write SetCapSentence;
    // Event
    property OnLostFocus: TOnEditLostFocus read FOnLostFocus write FOnLostFocus;
    property OnEnter: TOnNotify  read FOnEnter write FOnEnter;
    property OnChange: TOnChange read FOnChange write FOnChange;
    property OnChanged: TOnChange read FOnChanged write FOnChanged;
    property OnClick : TOnNotify read FOnClick   write FOnClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnLayouting: TOnLayouting read FOnLayouting write FOnLayouting;

  end;

  jButton = class(jVisualControl)
  private
    Procedure SetColor    (Value : TARGBColorBridge);

    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject);  override;

    Procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);

    function  GetText: string; override;
    Procedure SetText(Value: string ); override;
    Procedure SetEnabled(Value: boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure PerformClick();
    procedure PerformLongClick();
    procedure SetBackgroundByResIdentifier(_imgResIdentifier: string);
    procedure SetBackgroundByImage(_image: jObject);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide); overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide); overload;
    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);
    procedure SetFontFromAssets(_fontName: string);
    procedure ResetAllRules();

  published
    property Text: string read GetText write SetText;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property Enabled: boolean read FEnabled write SetEnabled;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnBeforeDispatchDraw read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
  end;

  jCheckBox = class(jVisualControl)
  private
    FChecked   : boolean;
    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Function  GetChecked         : boolean;
    Procedure SetChecked  (Value : boolean);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    procedure SetViewParent(Value: jObject);  override;
    Procedure GenEvent_OnClick(Obj: TObject);
    Function  GetText            : string;    override;   //by thierry
    Procedure SetText     (Value   : string );   override; //by thierry

    Procedure SetFontColor(Value : TARGBColorBridge);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide); overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide); overload;
    procedure SetFontFromAssets(_fontName: string);
    procedure ResetAllRules();

  published
    property Text: string read GetText write SetText;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    property Checked   : boolean   read GetChecked write SetChecked;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jRadioButton = class(jVisualControl)
  private
    FChecked   : Boolean;
    //FOnClick   : TOnNotify;
    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Function  GetChecked         : boolean;
    Procedure SetChecked  (Value : boolean);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    procedure SetViewParent(Value: jObject);  override;
    Procedure GenEvent_OnClick(Obj: TObject);
    Function  GetText            : string; override;
    Procedure SetText     (Value : string ); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

    procedure SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide); overload;
    procedure SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide); overload;
    procedure SetFontFromAssets(_fontName: string);
    procedure ResetAllRules();
  published
    property Text: string read GetText write SetText;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    property Checked   : boolean   read GetChecked write SetChecked;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jProgressBar = class(jVisualControl)
  private
    FProgress  : integer;
    FMax       : integer;
    FStyle     : TProgressBarStyle;
    Procedure SetColor    (Value : TARGBColorBridge);

    function  GetProgress: integer;
    Procedure SetProgress (Value : integer);
    function  GetMax: integer;   //by jmpessoa
    procedure SetMax (Value : integer);  //by jmpessoa

    Procedure SetStyle(Value : TProgressBarStyle);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject);  override;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp); override;
    procedure Stop;
    procedure Start;
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Style: TProgressBarStyle read FStyle write SetStyle;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Progress: integer read GetProgress write SetProgress;
    property Max: integer read GetMax write SetMax;

  end;

  jImageView = class(jVisualControl)
  private
    FImageName : string;
    FImageIndex: TImageListIndex;
    FImageList : jImageList;  //by jmpessoa
    FFilePath: TFilePath;
    FImageScaleType: TImageScaleType;

    Procedure SetColor    (Value : TARGBColorBridge);

    procedure SetImages(Value: jImageList);   //by jmpessoa
    function GetCount: integer;
    procedure SetImageName(Value: string);
    procedure SetImageIndex(Value: TImageListIndex);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject);  override;
    procedure SetParamWidth(Value: TLayoutParams); override;
    procedure SetParamHeight(Value: TLayoutParams); override;

    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

      //by jmpessoa
    function GetHeight: integer;   override;
    function GetWidth: integer;     override;

    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp); override;
    Procedure SetImageByName(Value : string);
    Procedure SetImageByIndex(Value : integer);

    procedure SetImageBitmap(bitmap: jObject); overload;  //deprecated
    procedure SetImage(bitmap: jObject); overload;

    procedure SetImageByResIdentifier(_imageResIdentifier: string);    // ../res/drawable

    function GetBitmapHeight: integer;
    function GetBitmapWidth: integer;
    procedure SetImageMatrixScale(_scaleX: single; _scaleY: single);
    procedure SetScaleType(_scaleType: TImageScaleType);

    function GetBitmapImage(): jObject;  //deprecated ..
    function GetImage(): jObject;

    procedure SetImageFromURI(_uri: jObject);
    procedure SetImageFromIntentResult(_intentData: jObject);
    procedure SetImageThumbnailFromCamera(_intentData: jObject);
    procedure SetImageFromJByteArray(var _image: TDynArrayOfJByte);
    procedure SetImageBitmap(_bitmap: jObject; _width: integer; _height: integer); overload; //deprecated
    procedure SetImage(_bitmap: jObject; _width: integer; _height: integer); overload;
    Procedure SetImage(_fullFilename: string); overload;
    procedure SetRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);

    property Count: integer read GetCount;
  published
    property ImageIndex: TImageListIndex read FImageIndex write SetImageIndex default -1;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa

    property BackgroundColor     : TARGBColorBridge read FColor       write SetColor;
    property ImageIdentifier : string read FImageName write SetImageByResIdentifier;
    property ImageScaleType: TImageScaleType read FImageScaleType write SetScaleType;
     // Event
     property OnClick: TOnNotify read FOnClick write FOnClick;
  end;

  jListView = class(jVisualControl)
  private
    FOnClickItem  : TOnClickCaptionItem;
    FOnClickWidgetItem: TOnClickWidgetItem;
    FOnLongClickItem:  TOnClickCaptionItem;
    FOnDrawItemTextColor: TOnDrawItemTextColor;
    FOnDrawItemWidgetTextColor: TOnDrawItemWidgetTextColor;
    FOnDrawItemBitmap: TOnDrawItemBitmap;
    FOnWidgeItemLostFocus: TOnWidgeItemLostFocus;
    FOnScrollStateChanged: TOnScrollStateChanged;
    FOnDrawItemWidgetBitmap: TOnDrawItemWidgetBitmap;

    FItems        : TStrings;
    FWidgetItem   : TWidgetItem;
    FWidgetText   : string;
    FDelimiter    : string;
    FImageItem    : jBitmap;
    FTextDecorated: TTextDecorated;
    FTextSizeDecorated: TTextSizeDecorated;
    FItemLayout   : TItemLayout;
    FTextAlign     : TTextAlign;

    FHighLightSelectedItemColor: TARGBColorBridge;
    FImageItemIdentifier: string;

    FItemPaddingTop: integer;
    FItemPaddingBottom: integer;

    FWidgetTextColor: TARGBColorBridge;

    procedure SetHighLightSelectedItemColor(_color: TARGBColorBridge);

    Procedure SetColor        (Value : TARGBColorBridge);
    Procedure SetItemPosition (Value : TXY);
    procedure ListViewChange  (Sender: TObject);

    procedure SetItems(Value: TStrings);

    Procedure SetFontColor    (Value : TARGBColorBridge);
    Procedure SetFontSize     (Value : DWord);
    procedure SetWidget(Value: TWidgetItem);
    procedure SetImage(Value: jBitmap);
    function GetCount: integer;
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);
    procedure SetFontFace(AValue: TFontFace);

  protected
    procedure SetViewParent(Value: jObject);  override;
    procedure GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
    procedure GenEvent_OnClickCaptionItem(Obj: TObject; index: integer; caption: string);
    procedure GenEvent_OnLongClickCaptionItem(Obj: TObject; index: integer; caption: string);

    procedure GenEvent_OnDrawItemCaptionColor(Obj: TObject; index: integer; caption: string;  out color: dword);
    procedure GenEvent_OnDrawItemWidgetTextColor(Obj: TObject; index: integer; caption: string;  out color: dword);

    procedure GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer; caption: string;  out bitmap: JObject);
    procedure GenEvent_OnDrawItemWidgetBitmap(Obj: TObject; index: integer; caption: string;  out bitmap: JObject);

    procedure GenEvent_OnWidgeItemLostFocus(Obj: TObject; index: integer; caption: string);
    procedure GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
    procedure GenEvent_OnScrollStateChanged(Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: boolean);

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure UpdateLayout(); override;
    procedure Init(refApp: jApp);  override;

    function GetWidth: integer;  override;
    function GetHeight: integer; override;

    function IsItemChecked(index: integer): boolean;
    procedure Add(item: string); overload;
    procedure Add(item: string; delim: string); overload;
    procedure Add(item: string; delim: string; fontColor: TARGBColorBridge;
                  fontSize: integer; hasWidget: TWidgetItem; widgetText: string; image: jObject); overload;
    Procedure Delete(index: Integer);
    function GetItemText(index: integer): string;
    Procedure Clear;
    Procedure SetFontColorByIndex(Value : TARGBColorBridge; index: integer);
    Procedure SetFontSizeByIndex(Value : DWord; index: integer  );

    procedure SetWidgetByIndex(Value: TWidgetItem; index: integer); overload;
    procedure SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer); overload;
    procedure SetWidgetTextByIndex(txt: string; index: integer);

    procedure SetImageByIndex(Value: jObject; index: integer);  overload;

    procedure SetImageByIndex(imgResIdentifier: string; index: integer);  overload; // ..res/drawable

    procedure SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
    procedure SetTextSizeDecoratedByIndex(value: TTextSizeDecorated; index: integer);
    procedure SetTextAlignByIndex(Value: TTextAlign; index: integer);

    procedure SetLayoutByIndex(Value: TItemLayout; index: integer);

    function GetTotalHeight: integer;
    function GetItemHeight(aItemIndex:integer): integer;

    function GetItemIndex(): integer;
    function GetItemCaption(): string;
    procedure DispatchOnDrawItemTextColor(_value: boolean);
    procedure DispatchOnDrawItemBitmap(_value: boolean);
    function GetWidgetText(_index: integer): string;

    procedure SetWidgetCheck(_value: boolean; _index: integer);
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
    procedure SetWidgetTextColor(_textcolor: TARGBColorBridge);
    procedure SetDispatchOnDrawItemWidgetTextColor(_value: boolean);
    procedure SetWidgetFontFromAssets(_customFontName: string);
    procedure DispatchOnDrawWidgetItemWidgetTextColor(_value: boolean);
    procedure DispatchOnDrawItemWidgetImage(_value: boolean);
    function SplitCenterItemCaption(_centerItemCaption: string; _delimiter: string): TDynArrayOfString;
    procedure SetSelection(_index: integer);
    procedure SmoothScrollToPosition(_index: integer);
    procedure SetItemChecked(_index: integer; _value: boolean);
    function GetCheckedItemPosition(): integer;


    //Property
    property setItemIndex: TXY write SetItemPosition;
    property Count: integer read GetCount;

    property OnWidgeItemLostFocus: TOnWidgeItemLostFocus read FOnWidgeItemLostFocus write FOnWidgeItemLostFocus;
  published
    property Items: TStrings read FItems write SetItems;
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
    property HighLightSelectedItemColor: TARGBColorBridge read FHighLightSelectedItemColor write SetHighLightSelectedItemColor;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;
    property FontFace: TFontFace read FFontFace write SetFontFace default ffNormal;

    property ImageItemIdentifier: string read FImageItemIdentifier write SetImageByResIdentifier;
    property ItemPaddingTop: integer read FItemPaddingTop write SetItemPaddingTop;
    property ItemPaddingBottom: integer read FItemPaddingBottom write SetItemPaddingBottom;
    property WidgetTextColor: TARGBColorBridge read FWidgetTextColor write SetWidgetTextColor;

    // Event
    property OnClickItem : TOnClickCaptionItem read FOnClickItem write FOnClickItem;
    property OnClickWidgetItem: TOnClickWidgetItem read FOnClickWidgetItem write FOnClickWidgetItem;
    property OnLongClickItem: TOnClickCaptionItem read FOnLongClickItem write FOnLongClickItem;
    property OnDrawItemTextColor: TOnDrawItemTextColor read FOnDrawItemTextColor write FOnDrawItemTextColor;
    property OnDrawItemWidgetTextColor: TOnDrawItemWidgetTextColor read FOnDrawItemWidgetTextColor write FOnDrawItemWidgetTextColor;
    property OnDrawItemBitmap: TOnDrawItemBitmap  read FOnDrawItemBitmap write FOnDrawItemBitmap;
    property OnDrawItemWidgetBitmap: TOnDrawItemWidgetBitmap read FOnDrawItemWidgetBitmap write FOnDrawItemWidgetBitmap;

    property OnBeforeDispatchDraw: TOnBeforeDispatchDraw read FOnBeforeDispatchDraw write FOnBeforeDispatchDraw;
    property OnAfterDispatchDraw: TOnAfterDispatchDraw read FOnAfterDispatchDraw write FOnAfterDispatchDraw;
    property OnScrollStateChanged: TOnScrollStateChanged read FOnScrollStateChanged write FOnScrollStateChanged;

  end;

  TScrollPosition = (spIntermediary, spBegin, spEnd);

  TOnScrollChanged = procedure(Sender: TObject; currHor: Integer; currVerti: Integer; prevHor: Integer; prevVertical: Integer; position:  TScrollPosition; scrolldiff: integer) of Object;

  jScrollView = class(jVisualControl)
  private
    FScrollSize : integer;
    FFillViewportEnabled: boolean;
    FOnScrollChanged: TOnScrollChanged;

    Procedure SetColor      (Value : TARGBColorBridge);
    Procedure SetScrollSize (Value : integer);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject);  override;
    function GetView: jObject; override;
    //procedure SetParamWidth(Value: TLayoutParams); override; TODO
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp);  override;
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
    procedure DispatchOnScrollChangedEvent(_value: boolean);
    procedure GenEvent_OnChanged(Obj: TObject; currHor: Integer; currVerti: Integer; prevHor: Integer; prevVertical: Integer; onPosition: Integer; scrolldiff: integer);

  published
    property FillViewportEnabled: boolean read FFillViewportEnabled write SetFillViewport;
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property BackgroundColor: TARGBColorBridge read FColor  write SetColor;
    property OnScrollChanged: TOnScrollChanged read FOnScrollChanged write FOnScrollChanged;
  end;

  jHorizontalScrollView = class(jVisualControl)
  private
    FScrollSize : integer;
    FOnScrollChanged: TOnScrollChanged;

    Procedure SetColor      (Value : TARGBColorBridge);
    Procedure SetScrollSize (Value : integer);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject); override;
    function GetView: jObject; override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp);  override;
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
    procedure GenEvent_OnChanged(Obj: TObject; currHor: Integer; currVerti: Integer; prevHor: Integer; prevVertical: Integer; onPosition: Integer; scrolldiff: integer);

    // Property
  published
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
    property OnScrollChanged: TOnScrollChanged read FOnScrollChanged write FOnScrollChanged;
  end;

  //------------------------------------------------------------------

  jWebView = class(jVisualControl)
  private
    FJavaScript : Boolean;
    //
    FOnStatus   : TOnWebViewStatus;

    // Fatih - ZoomControl
    FZoomControl : Boolean;

    Procedure SetColor     (Value : TARGBColorBridge);
    Procedure SetZoomControl(Value : Boolean);
    Procedure SetJavaScript(Value : Boolean);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetViewParent(Value: jObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;

    Procedure Navigate(url: string);
    Procedure LoadFromHtmlFile(environmentDirectoryPath: string; htmlFileName: string);
    procedure LoadFromHtmlString(_htmlString: string); //thanks to Anton!

    procedure SetHttpAuthUsernamePassword(_hostName: string; _domain: string; _username: string; _password: string);
    Procedure GenEvent_OnLongClick(Obj: TObject);

  published
    property JavaScript: Boolean          read FJavaScript write SetJavaScript;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
    property ZoomControl: Boolean read FZoomControl write SetZoomControl;
    // Event
    property OnStatus  : TOnWebViewStatus read FOnStatus   write FOnStatus;
    property OnLongClick: TOnNotify read FOnLongClick write FOnLongClick;
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
    FTypeface: TFontFace;

    Procedure setStrokeWidth       (Value : single );
    Procedure setStyle             (Value : TPaintStyle);
    Procedure setColor             (Value : TARGBColorBridge);
    Procedure setTextSize          (Value : single );
    Procedure setTypeface          (Value : TFontFace);

  protected
  public
    //constructor Create;
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;

    procedure Init(refApp: jApp); override;
    //
    Procedure drawLine             (x1,y1,x2,y2 : single);
    // LORDMAN 2013-08-13
    Procedure drawPoint            (x1,y1 : single);
    Procedure drawText             (Text : String; x,y : single);

    procedure drawCircle(_cx: single; _cy: single; _radius: single);
    procedure drawOval(_left, _top, _right, _bottom: single);
    procedure drawBackground(_color: integer);
    procedure drawRect(_left, _top, _right, _bottom: single);
    procedure drawRoundRect(_left, _top, _right, _bottom, _rx, _ry: single);

    Procedure DrawBitmap(bmp: jObject; b,l,r,t: integer); overload;
    Procedure DrawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single); overload;
    Procedure DrawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single); overload;
    Procedure DrawBitmap(bmp: jBitmap; b,l,r,t: integer); overload;
    procedure DrawBitmap(_bitmap: jObject; _width: integer; _height: integer); overload;

    procedure SetCanvas(_canvas: jObject);
    //procedure drawTextAligned(Text: string; _left, _top, _right, _bottom, _alignhorizontal, _alignvertical: single);
    procedure DrawTextAligned(_text: string; _left, _top, _right, _bottom: single; _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);

    // Property
    property  JavaObj : jObject read FjObject;

  published
    property PaintStrokeWidth: single read FPaintStrokeWidth write setStrokeWidth;
    property PaintStyle: TPaintStyle read FPaintStyle write setStyle;
    property PaintTextSize: single read FPaintTextSize write setTextSize;
    property PaintColor: TARGBColorBridge read FPaintColor write setColor;
    property Typeface: TFontFace read FTypeFace write setTypeFace;

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
    FFilePath    : TFilePath;

    Procedure SetColor    (Value : TARGBColorBridge);
    procedure SetjCanvas(Value: jCanvas);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    Procedure GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnDraw(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Refresh;
    function GetWidth: integer;  override;
    function GetHeight: integer; override;
    procedure SetViewParent(Value: jObject);   override;
    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp); override;
    Procedure SaveToFile(fileName:String);
    function GetDrawingCache(): jObject;
    function GetImage(): jObject;

    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Canvas      : jCanvas read FjCanvas write SetjCanvas; // Java : jCanvas
    //property Visible     : Boolean read FVisible write SetVisible;
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
    FImageUpIndex: TImageListIndex;
    FImageDownIndex: TImageListIndex;

    FImageList : jImageList;
    FFilePath: TFilePath;

    procedure SetImages(Value: jImageList);
    Procedure SetColor    (Value : TARGBColorBridge);

    procedure SetImageDownByIndex(Value: integer);
    procedure SetImageUpByIndex(Value: integer);

    procedure SetImageDownByRes(imgResIdentifief: string); //  ../res/drawable
    procedure SetImageUpByRes(imgResIdentifief: string);   //  ../res/drawable

    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    Procedure SetEnabled  (Value : Boolean); override;
    procedure SetViewParent(Value: jObject); override;
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout(); override;
    procedure Init(refApp: jApp); override;
    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible : Boolean   read FVisible   write SetVisible;
    property BackgroundColor   : TARGBColorBridge read FColor     write SetColor;
    property Enabled : Boolean   read FEnabled   write SetEnabled;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    property IndexImageUp: TImageListIndex read FImageUpIndex write FImageUpIndex default -1;
    property IndexImageDown: TImageListIndex read FImageDownIndex write FImageDownIndex default -1;

    property ImageUpIdentifier: string read FImageUpName write SetImageUpByRes;
    property ImageDownIdentifier: string read FImageDownName write SetImageDownByRes;
    // Event
    property OnClick : TOnNotify read FOnClick   write FOnClick;
  end;

  jGLViewEvent = class(jVisualControl)
  private
   // FInitialized : boolean;
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
    //
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    //
    Procedure GenEvent_OnTouch (Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnRender(Obj: TObject; EventType, w, h: integer);
    //property Initialized : boolean read FInitialized;
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
  Function  Java_Event_pAppOnScreenStyle         (env: PJNIEnv; this: jobject): JInt;
  Procedure Java_Event_pAppOnNewIntent           (env: PJNIEnv; this: jobject; intent: jobject);
  Procedure Java_Event_pAppOnDestroy             (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnPause               (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnRestart             (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnResume              (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnStart              (env: PJNIEnv; this: jobject); //old OnActive
  Procedure Java_Event_pAppOnStop                (env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnBackPressed         (env: PJNIEnv; this: jobject);

  function Java_Event_pAppOnSpecialKeyDown              (env: PJNIEnv; this: jobject; keyChar: JChar; keyCode: integer; keyCodeString: JString): jBoolean;

  Function  Java_Event_pAppOnRotate              (env: PJNIEnv; this: jobject; rotate : Integer) : integer;
  Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
  Procedure Java_Event_pAppOnActivityResult      (env: PJNIEnv; this: jobject; requestCode, resultCode: Integer; intentData : jObject);

  //by jmpessoa: support to Option Menu
  procedure Java_Event_pAppOnCreateOptionsMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);
  Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                 itemID: integer; itemCaption: JString; checked: jboolean); overload;

  Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                 itemID: integer; itemCaption: JString; checked: boolean); overload; //deprecated..

  function Java_Event_pAppOnPrepareOptionsMenuItem(env: PJNIEnv; this: jobject; jObjMenu: jObject;  jObjMenuItem: jObject; itemIndex: integer): jBoolean;
  function Java_Event_pAppOnPrepareOptionsMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject; menuSize: integer): jBoolean;

  //by jmpessoa: support to Context Menu
  Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: jboolean); overload;

  Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: boolean);  overload; //deprecated

  procedure Java_Event_pAppOnCreateContextMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);

  // Control Event
  Procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject; Obj: TObject);


  Procedure Java_Event_pOnClick                  (env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
  Procedure Java_Event_pOnLongClick              (env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);

  //by jmpessoa
  Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: jboolean);  overload;
  Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);  overload; //deprecated

  Procedure Java_Event_pOnClickCaptionItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
  Procedure Java_Event_pOnListViewLongClickCaptionItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
  function  Java_Event_pOnListViewDrawItemCaptionColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
  function Java_Event_pOnListViewDrawItemWidgetTextColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
  function  Java_Event_pOnListViewDrawItemBitmap(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;
  procedure Java_Event_pOnWidgeItemLostFocus(env: PJNIEnv; this: jobject; Obj: TObject; index: integer;  caption: JString);
  procedure Java_Event_pOnListViewScrollStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: JBoolean);
  function Java_Event_pOnListViewDrawItemWidgetImage(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;

  procedure Java_Event_pOnBeforeDispatchDraw(env: PJNIEnv; this: jobject; Obj: TObject; canvas: JObject; tag: integer);
  procedure Java_Event_pOnAfterDispatchDraw(env: PJNIEnv; this: jobject; Obj: TObject; canvas: JObject; tag: integer);

  procedure Java_Event_pOnLayouting(env: PJNIEnv; this: jobject; Obj: TObject; changed: JBoolean);

  Procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject; Obj: TObject; txt: JString; count : integer);
  Procedure Java_Event_pOnChanged(env: PJNIEnv; this: jobject; Obj: TObject; txt: JString; count : integer);

  Procedure Java_Event_pOnEnter                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTimer                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTouch                  (env: PJNIEnv; this: jobject; Obj: TObject;act,cnt: integer; x1,y1,x2,y2: single);

  // Control GLSurfaceView.Renderer Event
  Procedure Java_Event_pOnGLRenderer            (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);
  Procedure Java_Event_pOnGLRenderer1             (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);
  Procedure Java_Event_pOnGLRenderer2             (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);

  // WebView Event
  Function  Java_Event_pOnWebViewStatus          (env: PJNIEnv; this: jobject; WebView : TObject; EventType : integer; URL : jString) : Integer;

  // AsyncTask Event & Task
 // procedure Java_Event_pOnAsyncEvent(env: PJNIEnv; this: jobject; Obj : TObject; EventType,Progress: integer);
  function Java_Event_pOnAsyncEventDoInBackground(env: PJNIEnv; this: jobject; Obj: TObject; Progress: integer): JBoolean;

  function Java_Event_pOnAsyncEventProgressUpdate(env: PJNIEnv; this: jobject; Obj: TObject; Progress: integer): JInt;
  function Java_Event_pOnAsyncEventPreExecute(env: PJNIEnv; this: jobject; Obj: TObject): JInt;
  procedure Java_Event_pOnAsyncEventPostExecute(env: PJNIEnv; this: jobject; Obj: TObject; Progress: integer);

  procedure Java_Event_pAppOnViewClick(env: PJNIEnv; this: jobject; jObjView: jObject; id: integer);
  procedure Java_Event_pAppOnListItemClick(env: PJNIEnv; this: jobject;jObjAdapterView: jObject; jObjView: jObject; position: integer; id: integer);

  Procedure Java_Event_pOnFlingGestureDetected(env: PJNIEnv; this: jobject; Obj: TObject; direction: integer);
  Procedure Java_Event_pOnPinchZoomGestureDetected(env: PJNIEnv; this: jobject; Obj: TObject; scaleFactor: single; state: integer);
  procedure Java_Event_pOnHttpClientContentResult(env: PJNIEnv; this: jobject; Obj: TObject; content: jString);
  procedure Java_Event_pOnHttpClientCodeResult(env: PJNIEnv; this: jobject; Obj: TObject; code: integer);

  Procedure Java_Event_pOnLostFocus(env: PJNIEnv; this: jobject; Obj: TObject; content: JString);

  procedure Java_Event_pOnScrollViewChanged(env: PJNIEnv; this: jobject; Obj: TObject;  currenthorizontal: integer;
                                                                                      currentVertical: integer;
                                                                                      previousHorizontal: integer;
                                                                                      previousVertical: integer;
                                                                                      onPosition: integer; scrolldiff: integer);


  procedure Java_Event_pOnHorScrollViewChanged(env: PJNIEnv; this: jobject; Obj: TObject;  currenthorizontal: integer;
                                                                                      currentVertical: integer;
                                                                                      previousHorizontal: integer;
                                                                                      previousVertical: integer;
                                                                                      onPosition: integer; scrolldiff: integer);

  // Asset Function (P : Pascal Native)
  Function  Asset_SaveToFile (srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;
  Function  Asset_SaveToFileP(srcFile,outFile : String; SkipExists : Boolean = False) : Boolean;


implementation


uses
  customdialog, radiogroup, autocompletetextview, viewflipper, comboedittext, toolbar;

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
//-----------
Function IntToWebViewStatus( EventType : Integer ) : TWebViewStatus;
 begin
  Case EventType of
   cjWebView_OnBefore : Result := wvOnBefore;
   cjWebView_OnFinish : Result := wvOnFinish;
   cjWebView_OnError  : Result := wvOnError;
   else                 Result := wvOnUnknown;
  end;
 end;

//------------------------------------------------------------------------------
//  Activity Event
//------------------------------------------------------------------------------

Function Java_Event_pAppOnScreenStyle(env: PJNIEnv; this: jobject): JInt;
begin
  Result:= 1;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  case gApp.Screen.Style of
    ssSensor    : Result := 0;
    ssPortrait  : Result := 1;
    ssLandScape : Result := 2;
  end;
end;

Procedure Java_Event_pAppOnNewIntent(env: PJNIEnv; this: jObject; intent: jobject);
{var
  Form: jForm;}
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  { //TODO
  Form := gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnNewIntent) then Form.OnNewIntent(Form, intent);
  }
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
  Form : jForm;
  CanClose: boolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= jForm(gApp.Forms.Stack[gApp.TopIndex].Form);
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  // Event : OnCloseQuery
  if Assigned(Form.OnCloseQuery)  then
  begin
   // Form.ShowMessage('Back Pressed: OnCloseQuery: '+ IntTostr(gApp.TopIndex));
    canClose := True;
    Form.OnCloseQuery(Form, canClose);
    if canClose = False then Exit;
  end;
  if Assigned(Form.OnBackButton) then
  begin
    // Form.ShowMessage('Back Pressed: OnBackButton: '+ IntTostr(gApp.TopIndex));
     Form.OnBackButton(Form);
  end;
  Form.Close;
end;

// Event : OnRotate -> Form OnRotate
Function Java_Event_pAppOnRotate(env: PJNIEnv; this: jobject; rotate : integer) : Integer;
var                   {rotate=1 --> device vertical/default position ; 2: device horizontal position}
  Form      : jForm;
  rotOrientation: TScreenStyle;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  Result := rotate;

  Form := gApp.Forms.Stack[gApp.TopIndex].Form;

  if not Assigned(Form) then Exit;

  Form.UpdateJNI(gApp);

  if rotate = 1 then
     rotOrientation:= ssPortrait
  else if rotate = 2 then
     rotOrientation:=ssLandscape
  else if rotate = 4 then rotOrientation:= ssSensor
      else
        rotOrientation:=ssUnknown;

  Form.ScreenStyle:= rotOrientation;

  if Assigned(Form.OnRotate) then Form.OnRotate(Form, rotOrientation);

end;

Procedure Java_Event_pAppOnConfigurationChanged(env: PJNIEnv; this: jobject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
end;

Procedure Java_Event_pAppOnActivityResult(env: PJNIEnv; this: jobject;
                                                requestCode, resultCode : Integer;
                                               intentData : jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnActivityResult) then Form.OnActivityResult(Form,requestCode,TAndroidResult(resultCode),intentData);
end;

//
procedure Java_Event_pAppOnViewClick(env: PJNIEnv; this: jobject; jObjView: jObject; id: integer);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnViewClick) then Form.GenEvent_OnViewClick(jObjView, id);
end;

procedure Java_Event_pAppOnListItemClick(env: PJNIEnv; this: jobject; jObjAdapterView: jObject; jObjView: jObject; position: integer; id: integer);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnListItemClick) then Form.GenEvent_OnListItemClick(jObjAdapterView, jObjView, position, id);
end;

//by jmpessoa: support to Option Menu
procedure Java_Event_pAppOnCreateOptionsMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnCreateOptionMenu) then Form.OnCreateOptionMenu(Form, jObjMenu);
end;

function Java_Event_pAppOnPrepareOptionsMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject; menuSize: integer): jBoolean;
var
  Form: jForm;
  prepareItems: boolean;
begin
  prepareItems:= False;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnPrepareOptionsMenu) then Form.OnPrepareOptionsMenu(Form, jObjMenu, menuSize, prepareItems);
  Result:= JBool(prepareItems);
end;

function Java_Event_pAppOnPrepareOptionsMenuItem(env: PJNIEnv; this: jobject; jObjMenu: jObject;  jObjMenuItem: jObject; itemIndex: integer): jBoolean;
var
  Form: jForm;
  prepareMoreItems: boolean;
begin
  prepareMoreItems:= True;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnPrepareOptionsMenuItem) then Form.OnPrepareOptionsMenuItem(Form, jObjMenu, jObjMenuItem, itemIndex, prepareMoreItems);
  Result:= JBool(prepareMoreItems);
end;

function Java_Event_pAppOnSpecialKeyDown(env: PJNIEnv; this: jobject; keyChar: JChar; keyCode: integer; keyCodeString: JString): jBoolean;
var
  Form: jForm;
  mute: boolean;
  pasStr: string;
  _jBoolean:  JBoolean;
begin
  mute:= False;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;

  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);

  pasStr := '';
  if keyCodeString <> nil then
  begin
      _jBoolean := JNI_False;
      pasStr    := String( env^.GetStringUTFChars(Env,keyCodeString,@_jBoolean) );
  end;

  if Assigned(Form.OnSpecialKeyDown) then Form.OnSpecialKeyDown(Form, char(keyChar), keyCode, pasStr, mute);
  Result:= JBool(mute);

end;

Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                               itemID: integer; itemCaption: JString; checked: boolean);//deprecated..
begin
  Java_Event_pAppOnClickOptionMenuItem(env,this,jObjMenuItem,
                                                 itemID,itemCaption,JBoolean(checked));
end;

//by jmpessoa: support to Option Menu
Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: jboolean);
var
  Form: jForm;
  pasStr: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);

  pasStr := '';
  if itemCaption <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr    := String( env^.GetStringUTFChars(Env,itemCaption,@_jBoolean) );
  end;

  if Assigned(Form.OnClickOptionMenuItem) then Form.OnClickOptionMenuItem(Form,jObjMenuItem,itemID,pasStr,Boolean(checked));
end;


//by jmpessoa: support to Context Menu
procedure Java_Event_pAppOnCreateContextMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);
var
  Form: jForm;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnCreateContextMenu) then Form.OnCreateContextMenu(Form, jObjMenu);
end;


Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                              itemID: integer; itemCaption: JString; checked: boolean);//deprecated
begin
 Java_Event_pAppOnClickContextMenuItem(env,this,jObjMenuItem,itemID,itemCaption,JBoolean(checked));
end;

//by jmpessoa: support to Context Menu
Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: jboolean);
var
  Form: jForm;
  pasStr: string;
  _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);

  pasStr := '';
  if itemCaption <> nil then
  begin
    _jBoolean := JNI_False;
    pasStr    := String( env^.GetStringUTFChars(Env,itemCaption,@_jBoolean) );
  end;

  if Assigned(Form.OnClickContextMenuItem) then Form.OnClickContextMenuItem(Form,jObjMenuItem,itemID,pasStr, Boolean(checked));
end;

//------------------------------------------------------------------------------
//  Control Event
//------------------------------------------------------------------------------

Procedure Java_Event_pOnDraw(env: PJNIEnv; this: jobject;
                             Obj: TObject);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jView  then
  begin
    jView(Obj).UpdateJNI(gApp);
    jForm(jView(Obj).Owner).UpdateJNI(gApp);
    jView(Obj).GenEvent_OnDraw(Obj);
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
    jForm(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jButton then
  begin
    jForm(jButton(Obj).Owner).UpdateJNI(gApp);
    jButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jCheckBox then
  begin
    jForm(jCheckBox(Obj).Owner).UpdateJNI(gApp);
    jCheckBox(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jRadioButton then
  begin
    jForm(jRadioButton(Obj).Owner).UpdateJNI(gApp);
    jRadioButton(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jDialogYN then
  begin
    jDialogYN(Obj).GenEvent_OnClick(Obj,Value);
    Exit;
  end;
  if Obj is jImageBtn then
  begin
    jForm(jImageBtn(Obj).Owner).UpdateJNI(gApp);
    jImageBtn(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
  if Obj is jImageView then
  begin
    jForm(jImageView(Obj).Owner).UpdateJNI(gApp);
    jImageView(Obj).GenEvent_OnClick(Obj);
    Exit;
  end;
end;

Procedure Java_Event_pOnLongClick(env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);
begin

  //----update global "gApp": to whom it may concern------
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  //------------------------------------------------------

  if not (Assigned(Obj)) then Exit;

  if Obj is jWebView then  //need fix here ... handling long clicked!
  begin
    jForm(jWebView(Obj).Owner).UpdateJNI(gApp);
    jWebView(Obj).GenEvent_OnLongClick(Obj);
    Exit;
  end;

  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnLongClick(Obj);
    Exit;
  end;

end;

Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);//deprecated
begin
  Java_Event_pOnClickWidgetItem(env,this,Obj,index,JBoolean(checked));
end;

Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: jboolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnClickWidgetItem(Obj, index, Boolean(checked)); Exit;
  end;
end;

procedure Java_Event_pOnBeforeDispatchDraw(env: PJNIEnv; this: jobject; Obj: TObject; canvas: JObject; tag: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jButton then
  begin
    jForm(jButton(Obj).Owner).UpdateJNI(gApp);
    jButton(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jAutoTextView then
  begin
    jForm(jAutoTextView(Obj).Owner).UpdateJNI(gApp);
    jAutoTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
  end;
end;

procedure Java_Event_pOnAfterDispatchDraw(env: PJNIEnv; this: jobject; Obj: TObject; canvas: JObject; tag: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jEditText then
  begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jButton then
  begin
    jForm(jButton(Obj).Owner).UpdateJNI(gApp);
    jButton(Obj).GenEvent_OnAfterDispatchDraw(Obj, canvas, tag);
    Exit;
  end;
  if Obj is jAutoTextView then
  begin
    jForm(jAutoTextView(Obj).Owner).UpdateJNI(gApp);
    jAutoTextView(Obj).GenEvent_OnBeforeDispatchDraw(Obj, canvas, tag);
  end;
end;

procedure Java_Event_pOnLayouting(env: PJNIEnv; this: jobject; Obj: TObject; changed: JBoolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jTextView then
  begin
    jForm(jTextView(Obj).Owner).UpdateJNI(gApp);
    jTextView(Obj).GenEvent_OnOnLayouting(Obj, Boolean(changed));
    Exit;
  end;
  if Obj is jEditText then
  begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnOnLayouting(Obj, Boolean(changed));
    Exit;
  end;
end;

Procedure Java_Event_pOnClickCaptionItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
var
   pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnClickCaptionItem(Obj, index, pasCaption);
  end;
end;

//...
procedure Java_Event_pOnWidgeItemLostFocus(env: PJNIEnv; this: jobject; Obj: TObject; index: integer;  caption: JString);
var
   pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnWidgeItemLostFocus(Obj, index, pasCaption);
  end;
end;

function  Java_Event_pOnListViewDrawItemCaptionColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outColor: dword;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  outColor:= 0;
  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnDrawItemCaptionColor(Obj, index, pasCaption, outColor);
  end;
  Result:= outColor;
end;

function Java_Event_pOnListViewDrawItemWidgetTextColor(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JInt;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outColor: dword;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  outColor:= 0;
  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnDrawItemWidgetTextColor(Obj, index, pasCaption, outColor);
  end;
  Result:= outColor;
end;


function Java_Event_pOnListViewDrawItemBitmap(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outBitmap: JObject;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  outBitmap:= nil;
  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnDrawItemBitmap(Obj, index, pasCaption, outBitmap);
  end;
  Result:= outBitmap;
end;

function Java_Event_pOnListViewDrawItemWidgetImage(env: PJNIEnv; this: jobject; Obj: TObject; index: integer; caption: JString): JObject;
var
  pasCaption: string;
  _jBoolean: JBoolean;
  outBitmap: JObject;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  outBitmap:= nil;
  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnDrawItemWidgetBitmap(Obj, index, pasCaption, outBitmap);
  end;
  Result:= outBitmap;
end;

procedure Java_Event_pOnListViewScrollStateChanged(env: PJNIEnv; this: jobject; Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: JBoolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnScrollStateChanged(Obj, firstVisibleItem, visibleItemCount, totalItemCount, Boolean(lastItemReached) );
  end;
end;

Procedure Java_Event_pOnListViewLongClickCaptionItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);
var
   pasCaption: string;
 _jBoolean: JBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if Obj is jListVIew then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    pasCaption := '';
    if caption <> nil then
    begin
      _jBoolean:= JNI_False;
      pasCaption:= string( env^.GetStringUTFChars(env,caption,@_jBoolean) );
    end;
    jListVIew(Obj).GenEvent_OnLongClickCaptionItem(Obj, index, pasCaption);
  end;
end;

Procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject; Obj: TObject; txt: JString; count : integer);
var
 pasTxt: string;
 _jBoolean: jBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  pasTxt:='';
  if txt <> nil then
  begin
  _jBoolean := JNI_False;
    pasTxt:= string( env^.GetStringUTFChars(Env,txt,@_jBoolean) );
  end;
  if Obj is jEditText then
  begin
     jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
     jEditText(Obj).GenEvent_OnChange(Obj, pasTxt, count);
  end;
end;

Procedure Java_Event_pOnChanged(env: PJNIEnv; this: jobject; Obj: TObject; txt: JString; count: integer);
var
  pasTxt: string;
  _jBoolean: jBoolean;
begin
 gApp.Jni.jEnv:= env;
 gApp.Jni.jThis:= this;
 if not Assigned(Obj) then Exit;
 pasTxt:='';
 if txt <> nil then
 begin
 _jBoolean := JNI_False;
   pasTxt:= string( env^.GetStringUTFChars(Env,txt,@_jBoolean) );
 end;
 if Obj is jEditText then
 begin
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnChanged(Obj, pasTxt, count);
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
    Exit;
  end;

  if Obj is jComboEditText then
  begin
    jForm(jComboEditText(Obj).Owner).UpdateJNI(gApp);
    jComboEditText(Obj).GenEvent_OnEnter(Obj);
    Exit;
  end;

  if Obj is jAutoTextView then
  begin
    jForm(jAutoTextView(Obj).Owner).UpdateJNI(gApp);
    jAutoTextView(Obj).GenEvent_OnEnter(Obj);
    Exit;
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

  Timer.jParent.UpdateJNI(gApp);

  if Timer.jParent.FormState = fsFormClose then Exit;

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

procedure Java_Event_pOnGLRenderer(env: PJNIEnv; this: jobject; Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent  then
  begin
    jForm(jGLViewEvent(Obj).Owner).UpdateJNI(gApp);
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
  end;
end;

procedure Java_Event_pOnGLRenderer1(env: PJNIEnv; this: jobject; Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent  then
  begin
    jForm(jGLViewEvent(Obj).Owner).UpdateJNI(gApp);
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
  end;
end;

procedure Java_Event_pOnGLRenderer2(env: PJNIEnv; this: jobject; Obj: TObject; EventType, w, h: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jGLViewEvent  then
  begin
    jForm(jGLViewEvent(Obj).Owner).UpdateJNI(gApp);
    jGLViewEvent(Obj).GenEvent_OnRender(Obj, EventType, w, h);
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

{
procedure Java_Event_pOnAsyncEvent(env: PJNIEnv; this: jobject;
                                      Obj: TObject; EventType,Progress : integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
     case EventType of
       cjTask_Before: jAsyncTask(Obj).AsyncTaskState:= atsBefore;
       cjTask_Progress: jAsyncTask(Obj).AsyncTaskState:= atsProgress;
       cjTask_Post: jAsyncTask(Obj).AsyncTaskState:= atsPost ;
       cjTask_BackGround: jAsyncTask(Obj).AsyncTaskState:= atsInBackground;
     end;
     jAsyncTask(Obj).UpdateJNI(gApp);
     jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
     jAsyncTask(Obj).GenEvent_OnAsyncEvent(Obj,EventType,Progress);
  end
end;
 }

function Java_Event_pOnAsyncEventDoInBackground(env: PJNIEnv; this: jobject; Obj : TObject; Progress : integer): JBoolean;
var
  doing: boolean;
begin
  doing:= True;  //doing!
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
     jAsyncTask(Obj).AsyncTaskState:= atsInBackground;
     jAsyncTask(Obj).UpdateJNI(gApp);
     jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
     jAsyncTask(Obj).GenEvent_OnAsyncEventDoInBackground(Obj, Progress, doing);
     Result:=  JBool(doing);
  end
end;

function Java_Event_pOnAsyncEventProgressUpdate(env: PJNIEnv; this: jobject; Obj : TObject; Progress : integer): JInt;
var
  progressUpdate: integer;
begin
  progressUpdate:= Progress + 1;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
     jAsyncTask(Obj).AsyncTaskState:= atsProgress;
     jAsyncTask(Obj).UpdateJNI(gApp);
     jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
     jAsyncTask(Obj).GenEvent_OnAsyncEventProgressUpdate(Obj, Progress, progressUpdate);
     Result:=  progressUpdate;
  end
end;

function Java_Event_pOnAsyncEventPreExecute(env: PJNIEnv; this: jobject; Obj: TObject): JInt;
var
  startProgress: integer;
begin
  startProgress:= 0;
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
     jAsyncTask(Obj).AsyncTaskState:= atsBefore;
     jAsyncTask(Obj).UpdateJNI(gApp);
     jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
     jAsyncTask(Obj).GenEvent_OnAsyncEventPreExecute(Obj, startProgress);
     Result:= startProgress;
  end
end;

procedure Java_Event_pOnAsyncEventPostExecute(env: PJNIEnv; this: jobject; Obj: TObject; Progress: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if not Assigned(Obj) then Exit;
  if Obj is jAsyncTask then
  begin
     jAsyncTask(Obj).AsyncTaskState:= atsPost ;
     jAsyncTask(Obj).UpdateJNI(gApp);
     jForm(jAsyncTask(Obj).Owner).UpdateJNI(gApp);
     jAsyncTask(Obj).GenEvent_OnAsyncEventPostExecute(Obj, Progress);
  end
end;

procedure Java_Event_pOnHttpClientContentResult(env: PJNIEnv; this: jobject; Obj: TObject; content: jString);
var
  pascontent    : String;
  _jBoolean  : jBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  //
  if not Assigned(Obj) then Exit;

  if Obj is jHttpClient then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent    := String( env^.GetStringUTFChars(Env,content,@_jBoolean) );
    end;
    jForm(jHttpClient(Obj).Owner).UpdateJNI(gApp);
    jHttpClient(Obj).GenEvent_OnHttpClientContentResult(Obj, pascontent);
  end;

end;

Procedure Java_Event_pOnLostFocus(env: PJNIEnv; this: jobject; Obj: TObject; content: JString);
var
  pascontent    : String;
  _jBoolean  : jBoolean;
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  //
  if not Assigned(Obj) then Exit;

  if Obj is jEditText then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent    := String( env^.GetStringUTFChars(Env,content,@_jBoolean) );
    end;
    jForm(jEditText(Obj).Owner).UpdateJNI(gApp);
    jEditText(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;

  if Obj is jComboEditText then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent    := String( env^.GetStringUTFChars(Env,content,@_jBoolean) );
    end;
    jForm(jComboEditText(Obj).Owner).UpdateJNI(gApp);
    jComboEditText(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;

  if Obj is jAutoTextView then
  begin
    pascontent := '';
    if content <> nil then
    begin
      _jBoolean := JNI_False;
      pascontent    := String( env^.GetStringUTFChars(Env,content,@_jBoolean) );
    end;
    jForm(jAutoTextView(Obj).Owner).UpdateJNI(gApp);
    jAutoTextView(Obj).GenEvent_OnOnLostFocus(Obj, pascontent);
  end;
end;

procedure Java_Event_pOnHttpClientCodeResult(env: PJNIEnv; this: jobject; Obj: TObject; code: integer);

begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  //
  if not Assigned(Obj) then Exit;
  if Obj is jHttpClient then
  begin
    jForm(jHttpClient(Obj).Owner).UpdateJNI(gApp);
    jHttpClient(Obj).GenEvent_OnHttpClientCodeResult(Obj, code);
  end;
end;

procedure Java_Event_pOnScrollViewChanged(env: PJNIEnv; this: jobject; Obj: TObject;  currenthorizontal: integer;
                                                                                      currentVertical: integer;
                                                                                      previousHorizontal: integer;
                                                                                      previousVertical: integer;
                                                                                      onPosition: integer;scrolldiff: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jScrollView then
  begin
    jForm(jScrollView(Obj).Owner).UpdateJNI(gApp);
    jScrollView(Obj).GenEvent_OnChanged(Obj, currenthorizontal, currentVertical, previousHorizontal, previousVertical, onPosition, scrolldiff);
  end;
end;

procedure Java_Event_pOnHorScrollViewChanged(env: PJNIEnv; this: jobject; Obj: TObject;  currenthorizontal: integer;
                                                                                      currentVertical: integer;
                                                                                      previousHorizontal: integer;
                                                                                      previousVertical: integer;
                                                                                      onPosition: integer;scrolldiff: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jHorizontalScrollView then
  begin
    jForm(jHorizontalScrollView(Obj).Owner).UpdateJNI(gApp);
    jHorizontalScrollView(Obj).GenEvent_OnChanged(Obj, currenthorizontal, currentVertical, previousHorizontal, previousVertical, onPosition, scrolldiff);
  end;
end;
//------------------------------------------------------------------------------
// jTextView
//------------------------------------------------------------------------------

constructor jTextView.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  FTextAlignment:= taLeft;
  FText:= '';

  FFontFace := ffNormal;
  FTextTypeFace:= tfNormal;

  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FHeight       := 25;
  FWidth        := 51;
  FLParamWidth  := lpWrapContent;
  FLParamHeight := lpWrapContent;
  FEnabled:= True;
end;

//
destructor jTextView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jTextView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jTextView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  //gvt: TGravity;     TODO
begin
  if FInitialized  then Exit;

  inherited Init(refApp);

  FjObject := jTextView_Create(FjEnv, FjThis, Self);

  FInitialized:= True;

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;

  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end;

  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end;

  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  jTextView_setParent(FjEnv, FjObject , FjPRLayout);

  jTextView_setId(FjEnv, FjObject, Self.Id);

  jTextView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  (* TODO
  for gvt := gvBottom  to gvFillVertical do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addGravity(FjEnv, FjThis, FjObject , GetGravity(gvt));
    end;
  end;
  *)

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jTextView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jTextView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if  FFontColor <> colbrDefault then
    jTextView_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
     jTextView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
    jTextView_setTextSize(FjEnv, FjObject , FFontSize);

  jTextView_setText(FjEnv, FjObject , FText);

  jTextView_setTextAlignment(FjEnv, FjObject , Ord(FTextAlignment));

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  if FEnabled =  False then
     jTextView_setEnabled(FjEnv, FjObject , False);

  jTextView_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

end;

procedure jTextView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jTextView_setParent(FjEnv, FjObject, FjPRLayout);
end;

procedure jTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

procedure jTextView.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  if FInitialized then
    jTextView_setEnabled(FjEnv, FjObject , FEnabled);
end;

function jTextView.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jTextView_getText(FjEnv, FjObject );
end;

procedure jTextView.SetText(Value: string);
begin
  inherited SetText(Value);
  if FInitialized then
    jTextView_setText(FjEnv, FjObject , Value);
end;

procedure jTextView.SetFontColor(Value: TARGBColorBridge);
begin
 FFontColor:= Value;
 if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jTextView_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor))
end;

procedure jTextView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and  (FFontSize > 0) then
    jTextView_setTextSize(FjEnv, FjObject , FFontSize);
end;

procedure jTextView.SetFontFace(AValue: TFontFace); 
begin
 FFontFace:= AValue;
 if(FInitialized) then 
   jTextView_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace)); 
end;

procedure jTextView.SetTextTypeFace(Value: TTextTypeFace);
begin
  FTextTypeFace:= Value ;
  if(FInitialized) then 
    jTextView_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jTextView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jTextView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jTextView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jTextView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jTextView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jTextView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jTextView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jTextView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jTextView.UpdateLayout();
begin
  if FInitialized then
  begin
   inherited UpdateLayout();
   UpdateLParamWidth;
   UpdateLParamHeight;
   jTextView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

// LORDMAN 2013-08-12
procedure jTextView.SetTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
    jTextView_setTextAlignment(FjEnv, FjObject , Ord(FTextAlignment));
end;

procedure jTextView.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
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
     jTextView_Append(FjEnv, FjObject, _txt);
end;

procedure jTextView.AppendLn(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_AppendLn(FjEnv, FjObject, _txt);
end;

procedure jTextView.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_CopyToClipboard(FjEnv, FjObject);
end;

procedure jTextView.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_PasteFromClipboard(FjEnv, FjObject);
end;

procedure jTextView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jTextView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

Procedure jTextView.GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

Procedure jTextView.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jTextView.GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);
begin
  if Assigned(FOnLayouting) then FOnLayouting(Obj, changed);
end;

function jTextView.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jTextView_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
           Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jTextView.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jTextView_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jTextView.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetCompoundDrawables(FjEnv, FjObject, _image, Ord(_side));
end;

procedure jTextView.SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetCompoundDrawables(FjEnv, FjObject, _imageResIdentifier, Ord(_side));
end;

procedure jTextView.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetRoundCorner(FjEnv, FjObject);
end;

procedure jTextView.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;

procedure jTextView.SetShadowLayer(_radius: single; _dx: single; _dy: single; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetShadowLayer(FjEnv, FjObject, _radius ,_dx ,_dy , GetARGB(FCustomColor, _color));
end;


procedure jTextView.SetShaderLinearGradient(_startColor: TARGBColorBridge; _endColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetShaderLinearGradient(FjEnv, FjObject, GetARGB(FCustomColor, _startColor) ,GetARGB(FCustomColor, _endColor));
end;

procedure jTextView.SetShaderRadialGradient(_centerColor: TARGBColorBridge; _edgeColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetShaderRadialGradient(FjEnv, FjObject, GetARGB(FCustomColor, _centerColor) ,GetARGB(FCustomColor, _edgeColor));
end;

procedure jTextView.SetShaderSweepGradient(_color1: TARGBColorBridge; _color2: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetShaderSweepGradient(FjEnv, FjObject, GetARGB(FCustomColor, _color1) ,GetARGB(FCustomColor, _color2));
end;

procedure jTextView.SetTextDirection(_textDirection: TTextDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetTextDirection(FjEnv, FjObject, Ord(_textDirection));
end;

procedure jTextView.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

procedure jTextView.SetTextIsSelectable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetTextIsSelectable(FjEnv, FjObject, _value);
end;

procedure jTextView.SetScrollingText();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetScrollingText(FjEnv, FjObject);
end;

procedure jTextView.SetTextAsLink(_linkText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetTextAsLink(FjEnv, FjObject, _linkText);
end;

procedure jTextView.SetBackgroundAlpha(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_SetBackgroundAlpha(FjEnv, FjObject, _alpha);
end;

procedure jTextView.MatchParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_MatchParent(FjEnv, FjObject);
end;

procedure jTextView.WrapParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextView_WrapParent(FjEnv, FjObject);
end;

procedure jTextView.ResetAllRules();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jTextView_ClearLayoutAll(FjEnv, FjObject);
     for rToP := rpBottom to rpCenterVertical do
     begin
        if rToP in FPositionRelativeToParent then
          jTextView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
     for rToA := raAbove to raAlignRight do
     begin
       if rToA in FPositionRelativeToAnchor then
         jTextView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
     end;
  end;
end;

//------------------------------------------------------------------------------
// jEditText
//------------------------------------------------------------------------------

constructor jEditText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText      :='';
  //FColor     := colbrDefault; //colbrWhite;
  FOnLostFocus:= nil;
  FOnEnter   := nil;
  FOnChange  := nil;
  FEditable := True;
  FInputTypeEx := itxText;
  FHint      := '';
  FMaxTextLength := -1; //300;
  FSingleLine:= True;
  FMaxLines:= 1;

  FScrollBarStyle:= scrNone;
  FVerticalScrollBar:= True;
  FHorizontalScrollBar:= True;

  FWrappingLine:= False;

  FMarginBottom := 5;
  FMarginLeft   := 5;
  FMarginRight  := 5;
  FMarginTop    := 5;
  FHeight       := 40;
  FWidth        := 100;

  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
  FCloseSoftInputOnEnter:= True;
  FCapSentence  := false;
end;

Destructor jEditText.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jEditText_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jEditText.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init(refApp);

  FjObject := jEditText_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;

  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end;

  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end;
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  jEditText_setParent(FjEnv, FjObject , FjPRLayout);

  jEditText_setId(FjEnv, FjObject , Self.Id);

  jEditText_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jEditText_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jEditText_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jEditText_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  jEditText_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

  if  FHint <> '' then
    jEditText_setHint(FjEnv, FjObject , FHint);

  if FFontColor <> colbrDefault then
    jEditText_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
     jEditText_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
    jEditText_setTextSize(FjEnv, FjObject , FFontSize);


  jEditText_setTextAlignment(FjEnv, FjObject , Ord(FTextAlignment));

  //
  if FMaxTextLength >= 0 then
    jEditText_maxLength(FjEnv, FjObject , FMaxTextLength);

  jEditText_setScroller(FjEnv, FjObject );

  jEditText_setHorizontalScrollBarEnabled(FjEnv, FjObject , FHorizontalScrollBar);
  jEditText_setVerticalScrollBarEnabled(FjEnv, FjObject , FVerticalScrollBar);

  jEditText_setHorizontallyScrolling(FjEnv, FjObject , FWrappingLine);

  if FCapSentence then
    jEditText_SetCapSentence(FjEnv, FjObject, FCapSentence);

  jEditText_editInputType2(FjEnv, FjObject , InputTypeToStrEx(FInputTypeEx));

  jEditText_setSingleLine(FjEnv, FjObject , True);

  if FInputTypeEx = itxMultiLine then
  begin
    jEditText_setSingleLine(FjEnv, FjObject , False);
    if FMaxLines = 1 then  FMaxLines:= 3;   // visibles lines!
    jEditText_setMaxLines(FjEnv, FjObject , FMaxLines); //visibles lines!

    if FScrollBarStyle <> scrNone then
         jEditText_setScrollBarStyle(FjEnv, FjObject , GetScrollBarStyle(FScrollBarStyle));

    (*bug
    if (FVerticalScrollBar = True) or  (FHorizontalScrollBar = True) then
    begin
      jEditText_setScrollbarFadingEnabled(FjEnv, FjObject , False);
      jEditText_setMovementMethod(FjEnv, FjObject );
    end;
    *)

  end;

  //thierrydijoux - if SetBackGroundColor to black, no theme
  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv,  FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

  if  FText <> '' then
    jEditText_setText(FjEnv, FjObject , FText);

  if FEditable = False then
     jEditText_SetEditable(FjEnv, FjObject, FEditable);

  if FHintTextColor <> colbrDefault then
     jEditText_setHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));

  if not FCloseSoftInputOnEnter then
    jEditText_SetCloseSoftInputOnEnter(FjEnv, FjObject, FCloseSoftInputOnEnter);

  jEditText_DispatchOnChangeEvent(FjEnv, FjObject , True);
  jEditText_DispatchOnChangedEvent(FjEnv, FjObject , True);

end;

Procedure jEditText.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jEditText_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jEditText.setColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jEditText.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
end;

function jEditText.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jEditText_getText(FjEnv, FjObject );
end;

procedure jEditText.SetText(Value: string);
begin
  inherited SetText(Value);
  if FInitialized then
     jEditText_setText(FjEnv, FjObject , Value);
end;

procedure jEditText.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jEditText_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

Procedure jEditText.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jEditText_setTextSize(FjEnv, FjObject , FFontSize);
end;

procedure jEditText.SetFontFace(AValue: TFontFace); 
begin 
  //inherited SetFontFace(AValue);
  FFontFace:= AValue;
  if(FInitialized) then 
   jEditText_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace)); 
end; 

procedure jEditText.SetTextTypeFace(Value: TTextTypeFace); 
begin 
 //inherited SetTextTypeFace(Value);
 FTextTypeFace:= Value;
 if(FInitialized) then 
   jEditText_setFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace)); 
end; 

procedure jEditText.SetHintTextColor(Value: TARGBColorBridge);
begin
 //inherited SetHintTextColor(Value);
 FHintTextColor:= Value;
 if FInitialized then
    jEditText_setHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));
end;

Procedure jEditText.SetHint(Value : String);
begin
  FHint:= Value;
  if FInitialized then
     jEditText_setHint(FjEnv, FjObject , FHint);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetFocus;
begin
  if FInitialized then
     jEditText_SetFocus(FjEnv, FjObject  );
end;

{
//InputMethodManager
mgr = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
mgr.hideSoftInputFromWindow(myView.getWindowToken(), 0);
}

// LORDMAN - 2013-07-26
Procedure jEditText.ImmShow;
begin
  if FInitialized then
     jEditText_immShow(FjEnv, FjObject  );
end;

// LORDMAN - 2013-07-26
Procedure jEditText.ImmHide;
begin
  if FInitialized then
      jEditText_immHide(FjEnv, FjObject  );
end;

Procedure jEditText.ShowSoftInput();
begin
  Self.ImmShow();
end;

procedure jEditText.HideSoftInput();
begin
  Self.ImmHide();
end;

//by jmpessoa
Procedure jEditText.SetInputTypeEx(Value : TInputTypeEx);
begin
  FInputTypeEx:= Value;
  if FInitialized then
     jEditText_editInputType2(FjEnv, FjObject ,InputTypeToStrEx(FInputTypeEx));
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetTextMaxLength(Value: integer);
begin
  FMaxTextLength:= Value;
  if FMaxTextLength < -1 then  FMaxTextLength:= -1; // reset/default: no limited !!
  if FInitialized then
        jEditText_maxLength(FjEnv, FjObject , FMaxTextLength);
end;

//by jmpessoa
Procedure jEditText.SetMaxLines(Value: DWord);
begin
  FMaxLines:= Value;
  if FInitialized then
  begin
     jEditText_setMaxLines(FjEnv, FjObject , Value);
     if FMaxLines < 2 then
        jEditText_setSingleLine(FjEnv, FjObject , True);
  end;
end;

procedure jEditText.SetSingleLine(Value: boolean);
begin
  FSingleLine:= Value;
  if FInitialized then
  begin
     jEditText_setSingleLine(FjEnv, FjObject , Value);
     jEditText_setMaxLines(FjEnv, FjObject , 1);
  end;
end;

procedure jEditText.SetScrollBarStyle(Value: TScrollBarStyle);
begin
  FScrollBarStyle:= Value;
  if FInitialized then
  begin
    if Value <> scrNone then
    begin
       jEditText_setScrollBarStyle(FjEnv, FjObject , GetScrollBarStyle(Value));
    end;
  end;
end;

procedure jEditText.SetHorizontalScrollBar(Value: boolean);
begin
  FHorizontalScrollBar:= Value;
  if FInitialized then
    jEditText_setHorizontalScrollBarEnabled(FjEnv, FjObject , Value);
end;

procedure jEditText.SetVerticalScrollBar(Value: boolean);
begin
  FVerticalScrollBar:= Value;
  if FInitialized then
    jEditText_setVerticalScrollBarEnabled(FjEnv, FjObject , Value);
end;

procedure jEditText.SetScrollBarFadingEnabled(Value: boolean);
begin
  if FInitialized then
    jEditText_setScrollbarFadingEnabled(FjEnv, FjObject , Value);
end;

procedure jEditText.SetMovementMethod;
begin
  if FInitialized then ;
    jEditText_setMovementMethod(FjEnv, FjObject );
end;

// LORDMAN - 2013-07-26
Function jEditText.GetCursorPos: TXY;
begin
  Result.x := 0;
  Result.y := 0;
  if FInitialized then
     jEditText_GetCursorPos(FjEnv, FjObject ,Result.x,Result.y);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetCursorPos(Value: TXY);
begin
  if FInitialized then
     jEditText_SetCursorPos(FjEnv, FjObject , Value.X,Value.Y);
end;

// LORDMAN 2013-08-12
Procedure jEditText.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
     jEditText_setTextAlignment(FjEnv, FjObject , Ord(FTextAlignment));
end;

// Event : Java -> Pascal
// LORDMAN - 2013-07-26
Procedure jEditText.GenEvent_OnEnter(Obj: TObject);
begin
  if Assigned(FOnEnter) then FOnEnter(Obj);
end;

Procedure jEditText.GenEvent_OnChange(Obj: TObject; txt: string; count : Integer);
begin
  if jForm(Owner).FormState = fsFormClose then Exit;
  if Assigned(FOnChange) then FOnChange(Obj, txt, count);
end;

Procedure jEditText.GenEvent_OnChanged(Obj: TObject; txt : string; count: integer);
begin
  if jForm(Owner).FormState = fsFormClose then Exit;
  if Assigned(FOnChanged) then FOnChanged(Obj, txt, count);
end;

// Event : Java -> Pascal
Procedure jEditText.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

Procedure jEditText.GenEvent_OnOnLostFocus(Obj: TObject; txt: string);
begin
  if Assigned(FOnLostFocus) then FOnLostFocus(Obj, txt);
end;

procedure jEditText.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jEditText_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
       begin
          jEditText_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       end
       else //lpMatchParent or others
       begin
          jEditText_setLParamWidth(FjEnv,FjObject, GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
       end;
    end;
  end;
end;

procedure jEditText.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jEditText_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jEditText_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jEditText_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jEditText.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jEditText_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jEditText.AllCaps;
begin
  if FInitialized then
    jEditText_AllCaps(FjEnv, FjObject);
end;

procedure jEditText.DispatchOnChangeEvent(value: boolean);
begin
  if FInitialized then
    jEditText_DispatchOnChangeEvent(FjEnv, FjObject, value);
end;

procedure jEditText.DispatchOnChangedEvent(value: boolean);
begin
  if FInitialized then
    jEditText_DispatchOnChangedEvent(FjEnv, FjObject, value);
end;

procedure jEditText.Append(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_Append(FjEnv, FjObject, _txt);
end;

procedure jEditText.AppendLn(_txt: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_AppendLn(FjEnv, FjObject, _txt);
end;

procedure jEditText.AppendTab();
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_AppendTab(FjEnv, FjObject);
end;


procedure jEditText.SetImeOptions(_imeOption: TImeOptions);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetImeOptions(FjEnv, FjObject, Ord(_imeOption));
end;

procedure jEditText.SetSoftInputOptions(_imeOption: TImeOptions);
begin
   Self.SetImeOptions(_imeOption);
end;

procedure jEditText.SetEditable(enabled: boolean);
begin
  //in designing component state: set value here...
  FEditable:= enabled;
  if FInitialized then
     jEditText_SetEditable(FjEnv, FjObject, enabled);
end;

procedure jEditText.SetAcceptSuggestion(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetAcceptSuggestion(FjEnv, FjObject, _value);
end;

procedure jEditText.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_CopyToClipboard(FjEnv, FjObject);
end;

procedure jEditText.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_PasteFromClipboard(FjEnv, FjObject);
end;

procedure jEditText.Clear;
begin
  jEditText_setText(FjEnv, FjObject , '');
end;

procedure jEditText.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:= _unit;
  if FInitialized then
     jEditText_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jEditText.SetSelectAllOnFocus(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetSelectAllOnFocus(FjEnv, FjObject, _value);
end;

procedure jEditText.SelectAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SelectAll(FjEnv, FjObject);
end;

procedure jEditText.SetBackgroundByResIdentifier(_imgResIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetBackgroundByResIdentifier(FjEnv, FjObject, _imgResIdentifier);
end;

procedure jEditText.SetBackgroundByImage(_image: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetBackgroundByImage(FjEnv, FjObject, _image);
end;

procedure jEditText.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetCompoundDrawables(FjEnv, FjObject, _image,Ord(_side));
end;

procedure jEditText.SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetCompoundDrawables(FjEnv, FjObject, _imageResIdentifier, Ord(_side));
end;

procedure jEditText.SetTextDirection(_textDirection: TTextDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetTextDirection(FjEnv, FjObject, Ord(_textDirection));
end;

Procedure jEditText.GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

Procedure jEditText.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jEditText.GenEvent_OnOnLayouting(Obj: TObject; changed: boolean);
begin
  if Assigned(FOnLayouting) then FOnLayouting(Obj, changed);
end;

function jEditText.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jEditText_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jEditText.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jEditText_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jEditText.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

procedure jEditText.RequestFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_RequestFocus(FjEnv, FjObject);
end;

procedure jEditText.SetCloseSoftInputOnEnter(_closeSoftInput: boolean);
begin
  //in designing component state: set value here...
   FCloseSoftInputOnEnter:= _closeSoftInput;
  if FInitialized then
     jEditText_SetCloseSoftInputOnEnter(FjEnv, FjObject, _closeSoftInput);
end;

procedure jEditText.SetCapSentence(_capSentence: boolean);
begin
  //in designing component state: set value here...
   FCapSentence:= _capSentence;
  if FInitialized then
     jEditText_SetCapSentence(FjEnv, FjObject, _capSentence);
  // activate above setting
  SetInputTypeEx(FInputTypeEx);
end;

procedure jEditText.LoadFromFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_LoadFromFile(FjEnv, FjObject, _path, _filename);
end;

procedure jEditText.LoadFromFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_LoadFromFile(FjEnv, FjObject, _filename);
end;

procedure jEditText.SaveToFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SaveToFile(FjEnv, FjObject, _path ,_filename);
end;

procedure jEditText.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jEditText_SaveToFile(FjEnv, FjObject, _filename);
end;

procedure jEditText.ResetAllRules();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jEditText_ClearLayoutAll(FjEnv, FjObject);
     for rToP := rpBottom to rpCenterVertical do
     begin
        if rToP in FPositionRelativeToParent then
          jEditText_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
     for rToA := raAbove to raAlignRight do
     begin
       if rToA in FPositionRelativeToAnchor then
         jEditText_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
     end;
  end;
end;

//------------------------------------------------------------------------------
// jButton
//------------------------------------------------------------------------------
constructor jButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= '';
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FHeight       := 40;
  FWidth        := 100;
  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
  FEnabled:= True;
end;

destructor jButton.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if FjObject  <> nil then
     begin
       jButton_Free(FjEnv, FjObject );
       FjObject := nil;
     end;
   end;
   inherited Destroy;
end;

procedure jButton.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init(refApp); // set FjPRLayout:= jForm.View [default] ...

  FjObject := jButton_Create(FjEnv,FjThis,Self);
  FInitialized:= True;

  if FParent is jPanel then
  begin
     jPanel(FParent).Init(refApp);
     FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
     jScrollView(FParent).Init(refApp);
     FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end;
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  jButton_setParent(FjEnv, FjObject , FjPRLayout);

  jButton_setId(FjEnv, FjObject , Self.Id);

  jButton_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                            FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                            GetLayoutParams(gApp, FLParamWidth, sdW),
                                            GetLayoutParams(gApp, FLParamHeight, sdH));
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
       jButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jButton_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if FFontColor <> colbrDefault then
     jButton_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
     jButton_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then //not default...
     jButton_setTextSize(FjEnv, FjObject , FFontSize);

  jButton_setText(FjEnv, FjObject , FText);

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

  if FEnabled = False then
     jButton_SetEnabled(FjEnv, FjObject , False);

end;

Procedure jButton.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jButton_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jButton.Refresh;
begin
  if not FInitialized then Exit;
     View_Invalidate(FjEnv, FjObject );
end;

Function jButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jButton_getText(FjEnv, FjObject );
end;

Procedure jButton.SetText(Value: string);
begin
  inherited SetText(Value); //by thierry
  if FInitialized then
    jButton_setText(FjEnv, FjObject , Value{FText}); //by thierry
end;

Procedure jButton.SetFontColor(Value : TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jButton_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

Procedure jButton.SetFontSize (Value : DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jButton_setTextSize(FjEnv, FjObject , FFontSize);
end;

procedure jButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
         jButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
         jButton_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jButton.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jButton_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jButton.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jButton_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jButton.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jButton_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;


procedure jButton.PerformClick();
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_PerformClick(FjEnv, FjObject);
end;

procedure jButton.PerformLongClick();
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_PerformLongClick(FjEnv, FjObject);
end;

procedure jButton.SetBackgroundByResIdentifier(_imgResIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetBackgroundByResIdentifier(FjEnv, FjObject, _imgResIdentifier);
end;

procedure jButton.SetBackgroundByImage(_image: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetBackgroundByImage(FjEnv, FjObject, _image);
end;

// Event : Java -> Pascal
Procedure jButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

Procedure jButton.GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

Procedure jButton.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: jObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

function jButton.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jButton_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
           Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jButton.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jButton_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jButton.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetCompoundDrawables(FjEnv, FjObject, _image, Ord(_side));
end;

procedure jButton.SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetCompoundDrawables(FjEnv, FjObject, _imageResIdentifier, Ord(_side));
end;

procedure jButton.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetRoundCorner(FjEnv, FjObject);
end;

procedure jButton.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;

procedure jButton.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jButton_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

Procedure jButton.SetEnabled(Value: boolean);
begin
    //in designing component state: set value here...
  FEnabled:= Value;
  if FInitialized then
     jButton_SetEnabled(FjEnv, FjObject, Value);
end;

procedure jButton.ResetAllRules();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jButton_ClearLayoutAll(FjEnv, FjObject);
     for rToP := rpBottom to rpCenterVertical do
     begin
        if rToP in FPositionRelativeToParent then
          jButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
     for rToA := raAbove to raAlignRight do
     begin
       if rToA in FPositionRelativeToAnchor then
         jButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
     end;
  end;
end;

//------------------------------------------------------------------------------
// jCheckBox
//------------------------------------------------------------------------------

constructor jCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText      := '';
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FHeight       := 25;
  FWidth        := 100;
  FLParamWidth:= lpWrapContent;
  FLParamHeight:= lpWrapContent;
end;

destructor jCheckBox.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jCheckBox_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jCheckBox.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init(refApp);

  FjObject  := jCheckBox_Create(FjEnv, FjThis, self);
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end;
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end;
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  jCheckBox_setParent(FjEnv, FjObject , FjPRLayout);
  jCheckBox_setId(FjEnv, FjObject , Self.Id);
  jCheckBox_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCheckBox_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jCheckBox_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= 0;

  jCheckBox_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  jCheckBox_setText(FjEnv, FjObject , FText);

  if FFontColor <> colbrDefault then
     jCheckBox_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
      jCheckBox_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
     jCheckBox_setTextSize(FjEnv, FjObject , FFontSize);

  jCheckBox_setText(FjEnv, FjObject , FText);

  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);
  jCheckBox_setChecked(FjEnv, FjObject, FChecked);
end;

Procedure jCheckBox.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jCheckBox_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jCheckBox.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jCheckBox.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(FjEnv, FjObject );
end;

Function jCheckBox.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jCheckBox_getText(FjEnv, FjObject );
end;

Procedure jCheckBox.SetText(Value: string);
begin
  inherited SetText(Value);
  if FInitialized then //by thierry
     jCheckBox_setText(FjEnv, FjObject , Value);
end;

Procedure jCheckBox.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jCheckBox_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

Procedure jCheckBox.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jCheckBox_setTextSize(FjEnv, FjObject , FFontSize);
end;

Function jCheckBox.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
     Result:= jCheckBox_isChecked(FjEnv, FjObject );
end;

Procedure jCheckBox.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jCheckBox_setChecked(FjEnv, FjObject , FChecked);
end;

procedure jCheckBox.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jCheckBox_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jCheckBox_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jCheckBox_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jCheckBox.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jCheckBox_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jCheckBox_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jCheckBox_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jCheckBox.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jCheckBox_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jCheckBox.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jCheckBox_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

// Event Java -> Pascal
Procedure jCheckBox.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jCheckBox.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCheckBox_SetCompoundDrawables(FjEnv, FjObject, _image, Ord(_side));
end;

procedure jCheckBox.SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCheckBox_SetCompoundDrawables(FjEnv, FjObject, _imageResIdentifier, Ord(_side));
end;

procedure jCheckBox.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCheckBox_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

procedure jCheckBox.ResetAllRules();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
    //in designing component state: set value here...
  if FInitialized then
  begin
     jCheckBox_ClearLayoutAll(FjEnv, FjObject);
     for rToP := rpBottom to rpCenterVertical do
     begin
        if rToP in FPositionRelativeToParent then
          jCheckBox_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
     for rToA := raAbove to raAlignRight do
     begin
       if rToA in FPositionRelativeToAnchor then
         jCheckBox_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
     end;
  end;
end;

//------------------------------------------------------------------------------
// jRadioButton
//------------------------------------------------------------------------------

constructor jRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText      := '';
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FHeight       := 25;
  FWidth        := 100;
  FLParamWidth:= lpWrapContent;
  FLParamHeight:= lpWrapContent;
end;

destructor jRadioButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jRadioButton_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jRadioButton.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  flag: boolean;
begin
  flag:= False;
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jRadioButton_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end;
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end;

  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jRadioGroup then
  begin
    jRadioGroup(FParent).Init(refApp);
    //FjPRLayout:= jRadioGroup(FParent).View;
    FjPRLayout:= jRadioGroup_GetView(FjEnv, jRadioGroup(FParent).jSelf);
    flag:= True;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  if not flag then
  begin
    jRadioButton_setParent(FjEnv, FjObject , FjPRLayout);
  end
  else
  begin
    jRadioButton_setParent2(FjEnv, FjObject , FjPRLayout);
  end;

  // tk
  if (Self.Id = 0) or Self.IDExistsInParent then
    Self.AssignNewId;
  //if  Self.Id = 0 then Self.Id:= Random(10000000);
  // end tk

  jRadioButton_setId(FjEnv, FjObject , Self.Id);

  jRadioButton_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jRadioButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jRadioButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

   if not flag then
     jRadioButton_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if FFontColor <> colbrDefault then
     jRadioButton_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
      jRadioButton_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize > 0 then
     jRadioButton_setTextSize(FjEnv, FjObject , FFontSize);

  jRadioButton_setText(FjEnv, FjObject , FText);

  jRadioButton_setChecked(FjEnv, FjObject , FChecked);

  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

end;

Procedure jRadioButton.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jRadioButton_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jRadioButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jRadioButton.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(FjEnv, FjObject );
end;

Function jRadioButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jRadioButton_getText(FjEnv, FjObject );
end;

Procedure jRadioButton.SetText(Value: string);
begin
   inherited SetText(Value);
  if FInitialized then   //by thierry
     jRadioButton_setText(FjEnv, FjObject ,Value{ FText});
end;

Procedure jRadioButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jRadioButton_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

Procedure jRadioButton.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jRadioButton_setTextSize(FjEnv, FjObject , FFontSize);
end;

Function jRadioButton.GetChecked: boolean;
begin
  Result:= FChecked;
  if FInitialized then
     Result:= jRadioButton_isChecked(FjEnv, FjObject );
end;

Procedure jRadioButton.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jRadioButton_setChecked(FjEnv, FjObject , FChecked);
end;

procedure jRadioButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jRadioButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jRadioButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jRadioButton_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jRadioButton.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jRadioButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jRadioButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jRadioButton_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jRadioButton.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jRadioButton_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jRadioButton.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jRadioButton_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

// Event Java -> Pascal
Procedure jRadioButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jRadioButton.SetCompoundDrawables(_image: jObject; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioButton_SetCompoundDrawables(FjEnv, FjObject, _image, Ord(_side));
end;

procedure jRadioButton.SetCompoundDrawables(_imageResIdentifier: string; _side: TCompoundDrawablesSide);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioButton_SetCompoundDrawables(FjEnv, FjObject, _imageResIdentifier, Ord(_side));
end;

procedure jRadioButton.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRadioButton_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

procedure jRadioButton.ResetAllRules();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
    //in designing component state: set value here...
  if FInitialized then
  begin
     jRadioButton_ClearLayoutAll(FjEnv, FjObject);
     for rToP := rpBottom to rpCenterVertical do
     begin
        if rToP in FPositionRelativeToParent then
          jRadioButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
     for rToA := raAbove to raAlignRight do
     begin
       if rToA in FPositionRelativeToAnchor then
         jRadioButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
     end;
  end;
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
  FVisible   := True;
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 30;
  FWidth        := 100;
  FEnabled:= False;

  FLParamWidth  := lpMatchParent;
  FLParamHeight := lpWrapContent;

end;

Destructor jProgressBar.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if FjObject  <> nil then
     begin
       jProgressBar_Free(FjEnv, FjObject );
       FjObject := nil;
     end;
   end;
   inherited Destroy;
end;

Procedure jProgressBar.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jProgressBar_Create(FjEnv, FjThis, Self, GetProgressBarStyle(FStyle));
  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;

  jProgressBar_setParent(FjEnv, FjObject , FjPRLayout);
  jProgressBar_setId(FjEnv, FjObject , Self.Id);

  jProgressBar_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jProgressBar_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jProgressBar_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jProgressBar_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  jProgressBar_setProgress(FjEnv, FjObject , FProgress);
  jProgressBar_setMax(FjEnv, FjObject , FMax);  //by jmpessoa

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);
  FInitialized:= True;
end;

Procedure jProgressBar.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jProgressBar_setParent(FjEnv, FjObject , FjPRLayout);
end;

procedure jProgressBar.Stop;
begin
  FProgress:= 0;
  FVisible:= False;
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

Procedure jProgressBar.SetStyle(Value : TProgressBarStyle);
begin
  if csDesigning in ComponentState then FStyle:= Value;
end;

Procedure jProgressBar.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jProgressBar.Refresh;
begin
  if not FInitialized then Exit;
     View_Invalidate(FjEnv, FjObject );
end;

Function jProgressBar.GetProgress: integer;
begin
  Result:= FProgress;
  if FInitialized then
     Result:= jProgressBar_getProgress(FjEnv, FjObject );
end;

Procedure jProgressBar.SetProgress(Value: integer);
begin
  if Value >= 0 then
    FProgress:= Value
  else
    FProgress:= 0;

  if not FInitialized then Exit;

  if  FjObject <> nil then
     jProgressBar_setProgress(FjEnv, FjObject , FProgress);
end;

//by jmpessoa
Procedure jProgressBar.SetMax(Value: integer);
begin
  if Value > FProgress  then FMax:= Value;
  if FInitialized then
     jProgressBar_setMax(FjEnv, FjObject , FMax);
end;

//by jmpessoa
Function jProgressBar.GetMax: integer;
begin
  Result:= FMax;
  if FInitialized then
     Result:= jProgressBar_getMax(FjEnv, FjObject );
end;

procedure jProgressBar.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
        jProgressBar_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin

      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
         jProgressBar_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
         jProgressBar_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jProgressBar.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jProgressBar_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jProgressBar_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jProgressBar_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jProgressBar.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jProgressBar_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
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
  FLParamWidth := lpWrapContent; //lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 48;
  FWidth:= 48;
  //FIsBackgroundImage:= False;
  FFilePath:= fpathData;
  FImageScaleType:= scaleCenter;
end;

destructor jImageView.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if FjObject  <> nil then
     begin
       jImageView_Free(FjEnv, FjObject );
       FjObject := nil;
     end;
   end;
   inherited Destroy;
end;

Procedure jImageView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);

  FjObject := jImageView_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);//jScrollView(FParent).View;
  end;
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);//jHorizontalScrollView(FParent).View;
  end;
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end;

  if FParent is jViewFlipper then
  begin
    jViewFlipper(FParent).Init(refApp);
    FjPRLayout:= jViewFlipper(FParent).View;
  end;

  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end;

  jImageView_setParent(FjEnv,FjObject , FjPRLayout);
  jImageView_setId(FjEnv, FjObject , Self.Id);

  jImageView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  if FColor <> colbrDefault then
      View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  if FImageName <> '' then
     jImageView_SetImageByResIdentifier(FjEnv, FjObject , FImageName);

  if FImageList <> nil then
  begin
    FImageList.Init(refApp);
    if FImageList.Images.Count > 0 then
    begin
       if FImageIndex >=0 then SetImageByIndex(FImageIndex);
    end;
  end;

  if  FImageScaleType <> scaleCenter  then
     jImageView_SetScaleType(FjEnv, FjObject, Ord(FImageScaleType));;

  jImageView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);
end;

procedure jImageView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jImageView_setParent(FjEnv,FjObject , FjPRLayout);
end;

Procedure jImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jImageView.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
end;

Procedure jImageView.SetImageByName(Value: string);
var
  i: integer;
  foundIndex: integer;
begin
   If not Self.Initialized then Exit;
   if FImageList = nil then Exit;
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
      jImageView_setImage(FjEnv, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
   end;
end;

Procedure jImageView.SetImage(_fullFilename: string);
begin
   if Initialized then
      jImageView_setImage(FjEnv, FjObject , _fullFilename);
end;

Procedure jImageView.SetImageByIndex(Value: integer);
begin
   if not Self.Initialized then Exit;
   if FImageList = nil then Exit;

   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageName:= Trim(FImageList.Images.Strings[Value]);
      if  (FImageName <> '') and (FImageName <> 'null') then
      begin
        jImageView_setImage(FjEnv, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
      end;
   end;
end;

function jImageView.GetCount: integer;
begin
  Result:= FImageList.Images.Count;
end;

Procedure jImageView.SetImageName(Value: string);
begin
  FImageName:= Value;
  if FInitialized then SetImageByName(Value);
end;

procedure jImageView.SetImageIndex(Value: TImageListIndex);
begin
  FImageIndex:= Value;

  if FImageList <> nil then
  begin
    if FInitialized then
    begin
      if Value > FImageList.Images.Count then FImageIndex:= FImageList.Images.Count;
      if Value < 0 then FImageIndex:= 0;
      SetImageByIndex(Value);
    end;
  end;

end;

procedure jImageView.SetImageBitmap(bitmap: jObject); //deprecated..
begin
  if FInitialized then
     jImageView_setBitmapImage(FjEnv, FjObject , bitmap);
end;

procedure jImageView.SetImage(bitmap: jObject);
begin
  if FInitialized then
     jImageView_setBitmapImage(FjEnv, FjObject , bitmap);
end;

procedure jImageView.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  FImageName:= _imageResIdentifier;
  if FInitialized then
     jImageView_SetImageByResIdentifier(FjEnv, FjObject , _imageResIdentifier);
end;

procedure jImageView.SetParamHeight(Value: TLayoutParams);
begin
   inherited SetParamHeight(Value);
   if FInitialized then
   begin
      //
   end;
end;

procedure jImageView.SetParamWidth(Value: TLayoutParams);
begin
   inherited SetParamWidth(Value);     //FLParamWidth
   if FInitialized then
   begin
      //
   end;
end;

procedure jImageView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jImageView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
         jImageView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jImageView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jImageView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdH else side:= sdW;
      jImageView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jImageView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent is jPanel) then //lpMatchParent and others
             jImageView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jPanel), FLParamHeight, sdH))
           else
             jImageView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

function jImageView.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jImageView_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
           Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jImageView.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jImageView_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jImageView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jImageView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
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

function jImageView.GetBitmapHeight: integer;
begin
 Result:= 0;
 if FInitialized then
   Result:= jImageView_GetBitmapHeight(FjEnv, FjObject );
end;

function jImageView.GetBitmapWidth: integer;
begin
 Result:= 0;
 if FInitialized then
   Result:= jImageView_GetBitmapWidth(FjEnv, FjObject );
end;

procedure jImageView.SetImageMatrixScale(_scaleX: single; _scaleY: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetImageMatrixScale(FjEnv, FjObject, _scaleX ,_scaleY);
end;

procedure jImageView.SetScaleType(_scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  FImageScaleType:= _scaleType;
  if FInitialized then
     jImageView_SetScaleType(FjEnv, FjObject, Ord(_scaleType));
end;

function jImageView.GetBitmapImage(): jObject; //deprecated ...
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageView_GetBitmapImage(FjEnv, FjObject);
end;

function jImageView.GetImage(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageView_GetBitmapImage(FjEnv, FjObject);
end;


procedure jImageView.SetImageFromURI(_uri: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetImageFromURI(FjEnv, FjObject, _uri);
end;

procedure jImageView.SetImageFromIntentResult(_intentData: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetImageFromIntentResult(FjEnv, FjObject, _intentData);
end;

procedure jImageView.SetImageThumbnailFromCamera(_intentData: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetImageThumbnailFromCamera(FjEnv, FjObject, _intentData);
end;


procedure jImageView.SetImageFromJByteArray(var _image: TDynArrayOfJByte);
begin
if FInitialized then
   jImageView_SetImageFromByteArray(FjEnv, FjObject, _image);
end;

procedure jImageView.SetImageBitmap(_bitmap: jObject; _width: integer; _height: integer); //deprecated
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetBitmapImage(FjEnv, FjObject, _bitmap ,_width ,_height);
end;

procedure jImageView.SetImage(_bitmap: jObject; _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetBitmapImage(FjEnv, FjObject, _bitmap ,_width ,_height);
end;

procedure jImageView.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetRoundCorner(FjEnv, FjObject);
end;

procedure jImageView.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageView_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;


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
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...
  FImages.Free;
  inherited Destroy;
end;

procedure jImageList.Init(refApp: jApp);
var
  i: integer;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  for i:= 0 to FImages.Count - 1 do
  begin
     if Trim(FImages.Strings[i]) <> '' then
        Asset_SaveToFile(Trim(FImages.Strings[i]),GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[i]));
  end;
end;

function jImageList.jCreate(): jObject;
begin
   Result:= jImageList_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jImageList.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageList_jFree(FjEnv, FjObject);
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

function jImageList.GetBitmap(imageIndex: integer): jObject;
var
  path: string;
begin
  if Initialized then
  begin
     if (imageIndex < FImages.Count) and (imageIndex >= 0) then
     begin
         path:= GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+Trim(FImages.Strings[imageIndex]);
         Result:= jImageList_LoadFromFile(FjEnv, FjObject, path);
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
  FUrls:= TStringList.Create;
  FUrl:= '';
  FCharSet := 'UTF-8';
  FIndexUrl:= -1;
  FAuthenticationMode:= autNone;

  FResponseTimeout:= 15000;
  FConnectionTimeout:= 15000;

end;

destructor jHttpClient.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  FUrls.Free;
  inherited Destroy;
end;

procedure jHttpClient.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !

  if FResponseTimeout <> 15000 then
     jHttpClient_SetResponseTimeout(FjEnv, FjObject, FResponseTimeout);

  if FConnectionTimeout <> 15000 then
     jHttpClient_SetConnectionTimeout(FjEnv, FjObject, FConnectionTimeout);

  FInitialized:= True;
  SetUrlByIndex(FIndexUrl);
end;

function jHttpClient.jCreate(): jObject;
begin
   Result:= jHttpClient_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jHttpClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_jFree(FjEnv, FjObject);
end;

procedure jHttpClient.SetAuthenticationUser(_userName: string; _password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_SetAuthenticationUser(FjEnv, FjObject, _userName ,_password);
end;

procedure jHttpClient.SetAuthenticationMode(_authenticationMode: THttpClientAuthenticationMode);
begin
  //in designing component state: set value here...
  FAuthenticationMode:= _authenticationMode;
  if FInitialized then
     jHttpClient_SetAuthenticationMode(FjEnv, FjObject, Ord(_authenticationMode));
end;


procedure jHttpClient.SetAuthenticationHost(_hostName: string; _port: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_SetAuthenticationHost(FjEnv, FjObject, _hostName ,_port);
end;

procedure jHttpClient.SetUrls(Value: TStrings);
begin
  FUrls.Assign(Value);
end;

procedure jHttpClient.SetUrlByIndex(Value: integer);
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

procedure jHttpClient.SetCharSet(AValue: string);
begin

  FCharSet := AValue;
end;

procedure jHttpClient.GetAsync;
begin
 if not FInitialized then Exit;
 if  FUrl <> '' then
   jHttpClient_GetAsync(FjEnv, FjObject, FUrl);
end;

procedure jHttpClient.GetAsync(_stringUrl: string);
begin
  //in designing component state: result value here...
  if FInitialized then
      jHttpClient_GetAsync(FjEnv, FjObject, _stringUrl);
end;

function jHttpClient.Get(_stringUrl: string): string;
begin

  if FInitialized then
  begin
    jHttpClient_SetCharSet(FjEnv, FjObject, FCharSet);
    Result := jHTTPClient_Get(FjEnv, FjObject, _stringUrl)
  end else Result := '';
end;

function jHttpClient.Get: string;
begin
  Result := '';
  if not FInitialized then Exit;

  if  FUrl <> '' then
    Result := jHTTPClient_Get(FjEnv, FjObject, FUrl)
end;

procedure jHttpClient.ClearNameValueData; //ClearPost2Values;
begin
  if(FInitialized) then jHTTPClient_ClearPost2Values(FjEnv, FjObject);
end;

procedure jHttpClient.AddNameValueData(_name, _value: string); //AddValueForPost2
begin
  if(FInitialized) then jHTTPClient_AddValueForPost2(FjEnv, FjObject, _name, _value);
end;

function jHttpClient.Post(_stringUrl: string): string;
begin

  if(FInitialized) then
  begin

    jHttpClient_SetCharSet(FjEnv, FjObject, FCharSet);
    Result := jHTTPClient_Post(FjEnv, FjObject, _stringUrl)
  end else Result := '';
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jHttpClient_PostNameValueDataAsync(FjEnv, FjObject, _stringUrl);
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string; _name: string; _value: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jHttpClient_PostNameValueDataAsync(FjEnv, FjObject, _stringUrl ,_name ,_value);
end;

procedure jHttpClient.PostNameValueDataAsync(_stringUrl: string; _listNameValue: string);
begin
  //in designing component state: result value here...
  if FInitialized then
    jHttpClient_PostNameValueDataAsync(FjEnv, FjObject, _stringUrl ,_listNameValue);
end;

function jHttpClient.GetCookiesCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookiesCount(FjEnv, FjObject);
end;

function jHttpClient.GetCookieByIndex(_index: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookieByIndex(FjEnv, FjObject, _index);
end;

function jHttpClient.GetCookieAttributeValue(_cookie: jObject; _fieldName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookieAttributeValue(FjEnv, FjObject, _cookie ,_fieldName);
end;

procedure jHttpClient.ClearCookieStore();
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_ClearCookieStore(FjEnv, FjObject);
end;

function jHttpClient.AddCookie(_name: string; _value: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_AddCookie(FjEnv, FjObject, _name ,_value);
end;

function jHttpClient.IsExpired(_cookie: jObject): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_IsExpired(FjEnv, FjObject, _cookie);
end;

function jHttpClient.GetStateful(_url: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetStateful(FjEnv, FjObject, _url);
end;

function jHttpClient.PostStateful(_url: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_PostStateful(FjEnv, FjObject, _url);
end;


function jHttpClient.IsCookiePersistent(_cookie: jObject): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_IsCookiePersistent(FjEnv, FjObject, _cookie);
end;

procedure jHttpClient.SetCookieValue(_cookie: jObject; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_SetCookieValue(FjEnv, FjObject, _cookie ,_value);
end;

function jHttpClient.GetCookieByName(_cookieName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookieByName(FjEnv, FjObject, _cookieName);
end;

procedure jHttpClient.SetCookieAttributeValue(_cookie: jObject; _attribute: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_SetCookieAttributeValue(FjEnv, FjObject, _cookie ,_attribute ,_value);
end;

function jHttpClient.GetCookieValue(_cookie: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookieValue(FjEnv, FjObject, _cookie);
end;

function jHttpClient.GetCookieName(_cookie: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookieName(FjEnv, FjObject, _cookie);
end;

function jHttpClient.GetCookies(_nameValueSeparator: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookies(FjEnv, FjObject, _nameValueSeparator);
end;

procedure jHttpClient.AddClientHeader(_name: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_AddClientHeader(FjEnv, FjObject, _name ,_value);
end;

procedure jHttpClient.ClearClientHeader(_name: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_ClearClientHeader(FjEnv, FjObject, _name ,_value);
end;

function jHttpClient.DeleteStateful(_url: string; _value:string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_DeleteStateful(FjEnv, FjObject, _url, _value);
end;

procedure jHttpClient.GenEvent_OnHttpClientContentResult(Obj: TObject; content: string);
begin
   if Assigned(FOnContentResult) then FOnContentResult(Obj, content);
end;

procedure jHttpClient.GenEvent_OnHttpClientCodeResult(Obj: TObject; code: integer);
begin
   if Assigned(FOnCodeResult) then FOnCodeResult(Obj, code);
end;

function jHttpClient.UrlExist(_urlString: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_UrlExist(FjEnv, FjObject, _urlString);
end;

function jHttpClient.GetCookies(_urlString: string; _nameValueSeparator: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetCookies(FjEnv, FjObject, _urlString ,_nameValueSeparator);
end;

function jHttpClient.AddCookie(_urlString: string; _name: string; _value: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_AddCookie(FjEnv, FjObject, _urlString ,_name ,_value);
end;


// _cookieList format: 'userId=igbrown; sessionId=SID77689211949; isAuthenticated=true';

function jHttpClient.OpenConnection(_urlString: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_OpenConnection(FjEnv, FjObject, _urlString);
end;

function jHttpClient.SetRequestProperty(_httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_SetRequestProperty(FjEnv, FjObject, _httpConnection ,_headerName, _headerValue);
end;

(*
function jHttpClient.Connect(_httpConnection: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_Connect(FjEnv, FjObject, _httpConnection);
end;
*)

function jHttpClient.GetHeaderField(_httpConnection: jObject; _headerName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetHeaderField(FjEnv, FjObject, _httpConnection ,_headerName);
end;

function jHttpClient.GetHeaderFields(_httpConnection: jObject): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetHeaderFields(FjEnv, FjObject, _httpConnection);
end;


procedure jHttpClient.Disconnect(_httpConnection: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHttpClient_Disconnect(FjEnv, FjObject, _httpConnection);
end;

function jHttpClient.Get(_httpConnection: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_Get(FjEnv, FjObject, _httpConnection);
end;

function jHttpClient.AddRequestProperty(_httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_AddRequestProperty(FjEnv, FjObject, _httpConnection ,_headerName ,_headerValue);
end;

function jHttpClient.Post(_httpConnection: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_Post(FjEnv, FjObject, _httpConnection);
end;


function jHttpClient.GetResponseCode(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetResponseCode(FjEnv, FjObject);
end;

function jHttpClient.GetDefaultConnection(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHttpClient_GetDefaultConnection(FjEnv, FjObject);
end;

procedure jHttpClient.SetResponseTimeout(_timeoutMilliseconds: integer);
begin
  //in designing component state: set value here...
  FResponseTimeout:= _timeoutMilliseconds;
  if FInitialized then
     jHttpClient_SetResponseTimeout(FjEnv, FjObject, _timeoutMilliseconds);
end;

procedure jHttpClient.SetConnectionTimeout(_timeoutMilliseconds: integer);
begin
  //in designing component state: set value here...
  FConnectionTimeout:= _timeoutMilliseconds;
  if FInitialized then
     jHttpClient_SetConnectionTimeout(FjEnv, FjObject, _timeoutMilliseconds);
end;

function jHttpClient.GetResponseTimeout(): integer;
begin
  //in designing component state: result value here...
  Result:= FResponseTimeout;
  if FInitialized then
   Result:= jHttpClient_GetResponseTimeout(FjEnv, FjObject);
end;

function jHttpClient.GetConnectionTimeout(): integer;
begin
  //in designing component state: result value here...
  Result:= FConnectionTimeout;
  if FInitialized then
   Result:= jHttpClient_GetConnectionTimeout(FjEnv, FjObject);
end;

{ jSMTPClient }

//by jmpessoa: warning: not tested!

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
   //
 end;
 FMails.Free;
 FMailMessage.Free;
 inherited Destroy;
end;

procedure jSMTPClient.Init(refApp: jApp);
begin
 if FInitialized  then Exit;
 inherited Init(refApp);
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
    jSend_Email(gApp.Jni.jEnv, gApp.Jni.jThis,
                FMailTo,              //to
                FMailCc,              //cc
                FMailBcc,             //bcc
                FMailSubject,         //subject
                FMailMessage.Text);   //message
end;

procedure jSMTPClient.Send(mTo: string; subject: string; msg: string);
begin
  if FInitialized then
     jSend_Email(gApp.Jni.jEnv, gApp.Jni.jThis,
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
     //
 end;
 FSMSMessage.Free;
 FContactList.Free;
 inherited Destroy;
end;

procedure jSMS.Init(refApp: jApp);
begin
 if FInitialized  then Exit;
 inherited Init(refApp);
 if FLoadMobileContacts then GetContactList;
 FInitialized:= True;
end;

function jSMS.GetContactList: string;
begin
 if FInitialized then
   FContactList.DelimitedText:= jContact_getDisplayNameList(gApp.Jni.jEnv, gApp.Jni.jThis, FContactListDelimiter);
  Result:=FContactList.DelimitedText;
end;

procedure jSMS.SetSMSMessage(Value: TStrings);
begin
  FSMSMessage.Assign(Value);
end;

function jSMS.Send(multipartMessage: Boolean): integer;
begin
  if FInitialized then
  begin
    if (FMobileNumber = '') and (FContactName <> '') then
      FMobileNumber:= jContact_getMobileNumberByDisplayName(gApp.Jni.jEnv, gApp.Jni.jThis, FContactName);
    if FMobileNumber <> '' then
        Result:= jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
                  FMobileNumber,     //to
                  FSMSMessage.Text,  //message
				  multipartMessage);
  end;
end;

function jSMS.Send(toName: string; multipartMessage: Boolean): integer;
begin
  if FInitialized then
  begin
    if toName<> '' then
      FMobileNumber:= jContact_getMobileNumberByDisplayName(gApp.Jni.jEnv, gApp.Jni.jThis,
                                                            toName);
    if FMobileNumber <> '' then
        Result:= jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
                  FMobileNumber,     //to
                  FSMSMessage.Text,  //message
				  multipartMessage);
  end;
end;

function jSMS.Send(toNumber: string;  msg: string; multipartMessage: Boolean): integer;
begin
 if FInitialized then
 begin
    if toNumber <> '' then
        Result:= jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
                  toNumber,     //to
                  msg,  //message
				  multipartMessage);
  end;
end;

function jSMS.Send(toNumber: string;  msg: string; packageDeliveredAction: string; multipartMessage: Boolean): integer;
begin
 if FInitialized then
 begin
    if toNumber <> '' then
        Result:= jSend_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,
                  toNumber,     //to
                  msg,  //message
				  packageDeliveredAction,
				  multipartMessage);
  end;
end;

function jSMS.Read(intentReceiver: jObject; addressBodyDelimiter: string): string;
begin
if FInitialized then
   Result:= jRead_SMS(gApp.Jni.jEnv, gApp.Jni.jThis,intentReceiver, addressBodyDelimiter);  //message
end;

  {jCamera warning by jmpessoa: not tested!}
constructor jCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FFilePath:= fpathDCIM;
  FFilename:= 'photo1.jpg';
  FRequestCode:= 12345;
end;

destructor jCamera.Destroy;
begin
 if not (csDesigning in ComponentState) then
 begin
    //
 end;
 inherited Destroy;
end;

procedure jCamera.Init(refApp: jApp);
begin
 if FInitialized  then Exit;
 inherited Init(refApp);
 FInitialized:= True;
end;

procedure jCamera.TakePhoto;
var
  strExt: string;
begin
  if FInitialized then
  begin
     if FFileName = '' then FFileName:= 'photo1.jpg';
     if Pos('.', FFileName) < 0 then
          FFileName:= FFileName + '.jpg'
     else if Pos('.jpg', FFileName)  < 0 then
     begin
       //force jpg extension....
       strExt:= FFileName;
       FFileName:= SplitStr(strExt, '.');
       FFileName:= FFileName + '.jpg';
     end;
     Self.UpdateJNI(gApp);
     Self.FullPathToBitmapFile:= jCamera_takePhoto(FjEnv, FjThis,
                                                   GetFilePath(FFilePath), FFileName, FRequestCode);
  end;
end;

procedure jCamera.TakePhoto(_filename: string ; _requestCode: integer);
var
  strExt: string;
begin
  if FInitialized then
  begin
     FRequestCode:= _requestCode;
     if Pos('.', _filename) < 0 then
          _filename:= _filename + '.jpg'
     else if Pos('.jpg', _filename)  < 0 then
     begin
       //force jpg extension....
       strExt:= _filename;
       _filename:= SplitStr(strExt, '.');
       _filename:= _filename + '.jpg';
     end;
     Self.UpdateJNI(gApp);
     Self.FullPathToBitmapFile:= jCamera_takePhoto(FjEnv, FjThis,
                                                   GetFilePath(FFilePath), _filename, _requestCode);
  end;
end;

//------------------------------------------------------------------------------
// jListlView
//------------------------------------------------------------------------------

constructor jListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWidgetItem:= wgNone;
  FDelimiter:= '|';
  FTextDecorated:= txtNormal;
  FItemLayout:= layText;  //layImageTextWidget;
  FTextSizeDecorated:= sdNone;
  FTextAlign:= alLeft;
  FItems:= TStringList.Create;
  TStringList(FItems).OnChange:= ListViewChange;  //event handle

  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 96;
  FWidth:= 100;

  FHighLightSelectedItemColor:= colbrDefault;
  FImageItemIdentifier:= '';

  FItemPaddingTop:= 40;
  FItemPaddingBottom:= 40;

  FWidgetTextColor:= colbrDefault;

end;

destructor jListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jListView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  FItems.Free;
  inherited Destroy;
end;

procedure jListView.Init(refApp: jApp);
var
  i: integer;
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  if FImageItem <> nil then
  begin
    FImageItem.Init(refApp);

    FjObject := jListView_Create2(FjEnv, FjThis, Self,
                               Ord(FWidgetItem), FWidgetText, FImageItem.GetImage,
                               Ord(FTextDecorated), Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));

    if FWidgetTextColor <> colbrDefault then
        jListView_SetWidgetTextColor(FjEnv, FjObject,  GetARGB(FCustomColor, FWidgetTextColor));

    if FFontColor <> colbrDefault then
       jListView_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

    if FFontSizeUnit <> unitDefault then
        jListView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

    if FFontSize > 0 then
       jListView_setTextSize(FjEnv, FjObject , FFontSize);

    if FFontFace <> ffNormal then
       jListView_SetFontFace(FjEnv, FjObject, Ord(FFontFace));

    if FColor <> colbrDefault then
       View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

    if FItemPaddingTop <> 40 then
      jListView_SetItemPaddingTop(FjEnv, FjObject, FItemPaddingTop);

    if FItemPaddingBottom <> 40 then
      jListView_SetItemPaddingBottom(FjEnv, FjObject, FItemPaddingBottom);

    for i:= 0 to FItems.Count-1 do
    begin
      if FItems.Strings[i] <> '' then
        jListView_add22(FjEnv, FjObject , FItems.Strings[i], FDelimiter, FImageItem.GetImage);
    end;

  end
  else
  begin
    FjObject := jListView_Create3(FjEnv, FjThis, Self,
                               Ord(FWidgetItem), FWidgetText,
                               Ord(FTextDecorated),Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));

   if FWidgetTextColor <> colbrDefault then
      jListView_SetWidgetTextColor(FjEnv, FjObject,  GetARGB(FCustomColor, FWidgetTextColor));

    if FFontColor <> colbrDefault then
      jListView_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));

    if FFontSizeUnit <> unitDefault then
      jListView_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

    if FFontSize > 0 then
      jListView_setTextSize(FjEnv, FjObject , FFontSize);

    if FFontFace <> ffNormal then
      jListView_SetFontFace(FjEnv, FjObject, Ord(FFontFace));

    if FColor <> colbrDefault then
      View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

    if FImageItemIdentifier <> '' then    //ic_launcher
        jListView_SetImageByResIdentifier(FjEnv, FjObject, FImageItemIdentifier);

    if FItemPaddingTop <> 40 then
       jListView_SetItemPaddingTop(FjEnv, FjObject, FItemPaddingTop);

    if FItemPaddingBottom <> 40 then
       jListView_SetItemPaddingBottom(FjEnv, FjObject, FItemPaddingBottom);

    for i:= 0 to FItems.Count-1 do
    begin
       if FItems.Strings[i] <> '' then
         jListView_add2(FjEnv, FjObject , FItems.Strings[i], FDelimiter);
    end;

  end;

  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;

  jListView_setParent(FjEnv, FjObject , FjPRLayout);
  jListView_setId(FjEnv, FjObject , Self.Id);

  jListView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jListView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jListView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jListView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

  if FHighLightSelectedItemColor <> colbrDefault then
  begin
    jListView_SetHighLightSelectedItemColor(FjEnv, FjObject, GetARGB(FCustomColor, FHighLightSelectedItemColor));
  end;

end;

procedure jListView.SetWidget(Value: TWidgetItem);
begin
  FWidgetItem:= Value;
  //if FInitialized then
  //jListView_setHasWidgetItem(FjEnv, FjObject , Ord(FHasWidgetItem));
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem2(FjEnv, FjObject , ord(Value), index);
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem3(FjEnv, FjObject , ord(Value), txt, index);
end;

procedure jListView.SetWidgetTextByIndex(txt: string; index: integer);
begin
   if FInitialized then
      jListView_setWidgetText(FjEnv,FjObject ,txt,index);
end;

procedure jListView.SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextDecorated(FjEnv, FjObject , ord(Value), index);
end;

procedure jListView.SetTextSizeDecoratedByIndex(value: TTextSizeDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextSizeDecorated(FjEnv, FjObject , Ord(value), index);
end;

procedure jListView.SetLayoutByIndex(Value: TItemLayout; index: integer);
begin
  if FInitialized then
   jListView_setItemLayout(FjEnv, FjObject , ord(Value), index);
end;

procedure jListView.SetImageByIndex(Value: jObject; index: integer);
begin
  if FInitialized then
     jListView_SetImageItem(FjEnv, FjObject , Value, index);
end;

procedure jListView.SetImageByIndex(imgResIdentifier: string; index: integer);  overload;
begin
  if FInitialized then
     jListView_SetImageItem(FjEnv, FjObject , imgResIdentifier, index);
end;


procedure jListView.SetTextAlignByIndex(Value: TTextAlign; index: integer);
begin
  if FInitialized then
    jListView_setTextAlign(FjEnv, FjObject , ord(Value), index);
end;


function jListView.IsItemChecked(index: integer): boolean;
begin
  if FInitialized then
    Result:= jListView_IsItemChecked(FjEnv, FjObject , index);
end;

procedure jListView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jListView_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jListView.SetColor (Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jListView.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
end;

Procedure jListView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  //if (FInitialized = True) and (FFontColor <> colbrDefault ) then
    // jListView_setTextColor2(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor), index);
    //jListView_setTextColor(FjEnv, FjObject , GetARGB(FCustomColor, FFontColor));
end;

Procedure jListView.SetFontColorByIndex(Value: TARGBColorBridge; index: integer);
begin
  //FFontColor:= Value;
  if FInitialized  and (Value <> colbrDefault) then
     jListView_setTextColor2(FjEnv, FjObject , GetARGB(FCustomColor, Value), index);
end;

Procedure jListView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  //if FInitialized and (FFontSize > 0) then
   //  jListView_setTextSize2(FjEnv, FjObject , FFontSize, index);
end;

Procedure jListView.SetFontSizeByIndex(Value: DWord; index: integer);
begin
  //FFontSize:= Value;
  if FInitialized and (Value > 0) then
     jListView_setTextSize2(FjEnv, FjObject , Value, index);
end;

// LORDMAN 2013-08-07
Procedure jListView.SetItemPosition(Value: TXY);
begin
  if FInitialized then
     jListView_setItemPosition(FjEnv, FjObject , Value.X, Value.Y);
end;

Procedure jListView.Add(item: string; delim: string);
begin
  if item <> '' then
  begin
    FItems.Add(item);
    if FInitialized then
      jListView_add2(FjEnv, FjObject, item, delim);
  end;
end;

Procedure jListView.Add(item: string);
begin
  if item <> '' then
  begin
    FItems.Add(item);
    if FInitialized then
       jListView_add2(FjEnv, FjObject , item, FDelimiter);
  end;
end;

Procedure jListView.Add(item: string; delim: string; fontColor: TARGBColorBridge; fontSize: integer; hasWidget:
                                      TWidgetItem; widgetText: string; image: jObject);
begin
  if item <> '' then
  begin
     FItems.Add(item);
     if FInitialized then
       jListView_add3(FjEnv, FjObject , item,
          delim, GetARGB(FCustomColor, fontColor), fontSize, Ord(hasWidget), widgetText, image);
  end;
end;

function jListView.GetItemText(index: Integer): string;
begin
  if FInitialized then
    Result:= jListView_GetItemText(FjEnv, FjObject , index);
end;

function jListView.GetCount: integer;
begin
  Result:= Self.Items.Count;
  if FInitialized then
    Result:= jListView_GetCount(FjEnv, FjObject );
end;

Procedure jListView.Delete(index: Integer);
begin
  if (index >= 0) and (index < FItems.Count) then
  begin
     FItems.Delete(index);
     if FInitialized then
       jListView_delete(FjEnv, FjObject , index);
  end;
end;

Procedure jListView.Clear;
begin
  FItems.Clear;
  if FInitialized then
    jListView_clear(FjEnv, FjObject );
end;

procedure jListView.SetItems(Value: TStrings);
var
  i: integer;
begin
  FItems.Assign(Value);

  if FInitialized then
  begin
    for i:= 0 to FItems.Count - 1 do
    begin
       if FItems.Strings[i] <> '' then
         jListView_add2(FjEnv, FjObject , FItems.Strings[i], FDelimiter);
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
    jListView_clear(FjEnv, FjObject );
    for i:= 0 to FItems.Count - 1 do
    begin
       jListView_add2(FjEnv, FjObject , FItems.Strings[i],
                                    FDelimiter, GetARGB(FCustomColor, FFontColor), FFontSize, FWidgetText, Ord(FWidgetItem));
    end;
  end; }
end;


procedure jListView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jListView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jListView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jListView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jListView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jListView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jListView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jListView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jListView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jListView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
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
Procedure jListView.GenEvent_OnClickCaptionItem(Obj: TObject; index: integer;  caption: string);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Obj,index, caption);
end;

procedure jListView.GenEvent_OnWidgeItemLostFocus(Obj: TObject; index: integer; caption: string);
begin
  if Assigned(FOnWidgeItemLostFocus) then FOnWidgeItemLostFocus(Obj,index, caption);
end;

procedure jListView.GenEvent_OnBeforeDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
begin
  if Assigned(FOnBeforeDispatchDraw) then FOnBeforeDispatchDraw(Obj, canvas, tag);
end;

procedure jListView.GenEvent_OnAfterDispatchDraw(Obj: TObject; canvas: JObject; tag: integer);
begin
  if Assigned(FOnAfterDispatchDraw) then FOnAfterDispatchDraw(Obj, canvas, tag);
end;

procedure jListView.GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
begin
  if Assigned(FOnClickWidgetItem) then FOnClickWidgetItem(Obj,index,checked);
end;

procedure jListView.GenEvent_OnLongClickCaptionItem(Obj: TObject; index: integer; caption: string);
begin
  if Assigned(FOnLongClickItem) then FOnLongClickItem(Obj,index,caption);
end;

procedure jListView.GenEvent_OnDrawItemCaptionColor(Obj: TObject; index: integer; caption: string;  out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor:= Self.FontColor;
  color:= 0; //default;
  if Assigned(FOnDrawItemTextColor) then FOnDrawItemTextColor(Obj,index,caption, outColor);
  if (outColor <> colbrNone) and  (outColor <> colbrDefault) then
      color:= GetARGB(FCustomColor, outColor);
end;

procedure jListView.GenEvent_OnDrawItemWidgetTextColor(Obj: TObject; index: integer; caption: string;  out color: dword);
var
  outColor: TARGBColorBridge;
begin
  outColor:= Self.FontColor;
  color:= 0; //default;
  if Assigned(FOnDrawItemWidgetTextColor) then FOnDrawItemWidgetTextColor(Obj,index,caption, outColor);
  if (outColor <> colbrNone) and  (outColor <> colbrDefault) then
      color:= GetARGB(FCustomColor, outColor);
end;

procedure jListView.GenEvent_OnDrawItemBitmap(Obj: TObject; index: integer; caption: string;  out bitmap: JObject);
begin
  bitmap:=  nil;
  if Assigned(FOnDrawItemBitmap) then FOnDrawItemBitmap(Obj,index,caption, bitmap);
end;

procedure jListView.GenEvent_OnDrawItemWidgetBitmap(Obj: TObject; index: integer; caption: string;  out bitmap: JObject);
begin
  bitmap:=  nil;
  if Assigned(FOnDrawItemWidgetBitmap) then FOnDrawItemWidgetBitmap(Obj,index,caption, bitmap);
end;

procedure jListView.GenEvent_OnScrollStateChanged(Obj: TObject; firstVisibleItem: integer; visibleItemCount: integer; totalItemCount: integer; lastItemReached: boolean);
begin
  if Assigned(FOnScrollStateChanged) then FOnScrollStateChanged(Obj, firstVisibleItem, visibleItemCount, totalItemCount, lastItemReached);
end;

procedure jListView.SetHighLightSelectedItemColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHighLightSelectedItemColor:= _color;
  if FInitialized then
     jListView_SetHighLightSelectedItemColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

function jListView.GetItemIndex(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetItemIndex(FjEnv, FjObject);
end;

function jListView.GetItemCaption(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetItemCaption(FjEnv, FjObject);
end;

procedure jListView.DispatchOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetDispatchOnDrawItemTextColor(FjEnv, FjObject, _value);
end;

procedure jListView.DispatchOnDrawItemBitmap(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_DispatchOnDrawItemBitmap(FjEnv, FjObject, _value);
end;

procedure jListView.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:=_unit;
  if FInitialized then
     jListView_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

procedure jListView.SetFontFace(AValue: TFontFace);
begin
 FFontFace:= AValue;
 if(FInitialized) then
   jListView_SetFontFace(FjEnv, FjObject, Ord(FFontFace));
end;

function jListView.GetWidgetText(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetWidgetText(FjEnv, FjObject, _index);
end;

procedure jListView.SetWidgetCheck(_value: boolean; _index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_setWidgetCheck(FjEnv, FjObject, _value ,_index);
end;

procedure jListView.SetItemTagString(_tagString: string; _index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_setItemTagString(FjEnv, FjObject, _tagString ,_index);
end;


function jListView.GetItemTagString(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_getItemTagString(FjEnv, FjObject, _index);
end;

function jListView.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jListView_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
           Result:= (FParent as jForm).ScreenWH.Width
         else
           Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
           Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jListView.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jListView_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height   //take from start!
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

function jListView.GetTotalHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
    result:=jListView_getTotalHeight(FjEnv, FjObject);
  end;
end;

function jListView.GetItemHeight(aItemIndex:integer): integer;
begin
  result:=0;
  if FInitialized then
  begin
    result:=jListView_getItemHeight(FjEnv, FjObject, aItemIndex);
  end;
end;

procedure jListView.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageItemIdentifier:= _imageResIdentifier;
  if FInitialized then
     jListView_SetImageByResIdentifier(FjEnv, FjObject, _imageResIdentifier);
end;

procedure jListView.SetLeftDelimiter(_leftDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetLeftDelimiter(FjEnv, FjObject, _leftDelimiter);
end;

procedure jListView.SetRightDelimiter(_rightDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetRightDelimiter(FjEnv, FjObject, _rightDelimiter);
end;

function jListView.GetCenterItemCaption(_fullItemCaption: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetCenterItemCaption(FjEnv, FjObject, _fullItemCaption);
end;

function jListView.GetLeftItemCaption(_fullItemCaption: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetLeftItemCaption(FjEnv, FjObject, _fullItemCaption);
end;

function jListView.GetRightItemCaption(_fullItemCaption: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetRightItemCaption(FjEnv, FjObject, _fullItemCaption);
end;

function jListView.GetLongPressSelectedItem(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetLongPressSelectedItem(FjEnv, FjObject);
end;

procedure jListView.SetAllPartsOnDrawItemTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetAllPartsOnDrawItemTextColor(FjEnv, FjObject, _value);
end;

procedure jListView.SetItemPaddingTop(_ItemPaddingTop: integer);
begin
  //in designing component state: set value here...
  FItemPaddingTop:= _ItemPaddingTop;
  if FInitialized then
     jListView_SetItemPaddingTop(FjEnv, FjObject, _ItemPaddingTop);
end;

procedure jListView.SetItemPaddingBottom(_itemPaddingBottom: integer);
begin
  //in designing component state: set value here...
  FItemPaddingBottom:= _itemPaddingBottom;
  if FInitialized then
     jListView_SetItemPaddingBottom(FjEnv, FjObject, _itemPaddingBottom);
end;

procedure jListView.SetWidgetTextColor(_textcolor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FWidgetTextColor:= _textcolor;
  if FInitialized then
      jListView_SetWidgetTextColor(FjEnv, FjObject,  GetARGB(FCustomColor, _textcolor));
end;

procedure jListView.SetDispatchOnDrawItemWidgetTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetDispatchOnDrawItemWidgetTextColor(FjEnv, FjObject, _value);
end;

procedure jListView.SetWidgetFontFromAssets(_customFontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetWidgetFontFromAssets(FjEnv, FjObject, _customFontName);
end;

procedure jListView.DispatchOnDrawWidgetItemWidgetTextColor(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_DispatchOnDrawWidgetItemWidgetTextColor(FjEnv, FjObject, _value);
end;

procedure jListView.DispatchOnDrawItemWidgetImage(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_DispatchOnDrawItemWidgetImage(FjEnv, FjObject, _value);
end;

function jListView.SplitCenterItemCaption(_centerItemCaption: string; _delimiter: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_SplitCenterItemCaption(FjEnv, FjObject, _centerItemCaption ,_delimiter);
end;

procedure jListView.SetSelection(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetSelection(FjEnv, FjObject, _index);
end;

procedure jListView.SmoothScrollToPosition(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SmoothScrollToPosition(FjEnv, FjObject, _index);
end;

procedure jListView.SetItemChecked(_index: integer; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jListView_SetItemChecked(FjEnv, FjObject, _index ,_value);
end;

function jListView.GetCheckedItemPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jListView_GetCheckedItemPosition(FjEnv, FjObject);
end;

//------------------------------------------------------------------------------
// jScrollView
//------------------------------------------------------------------------------

constructor jScrollView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScrollSize := 800; //to scrolling images this number could be higher....
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 96;
  FWidth:= 100;
  //FAcceptChildsAtDesignTime:= True;
  FAcceptChildrenAtDesignTime:= True;
  FFillViewportEnabled:= False;
end;

Destructor jScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jScrollView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jScrollView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);

  FjObject := jScrollView_Create(FjEnv,  FjThis, Self); //View  !!!
  FInitialized:= True;
  //FjRLayout:= jScrollView_getView(FjEnv, FjObject ); //Self.View

  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:=  jScrollView_getView(FjEnv, jScrollView(FParent).jSelf); //jScrollView(FParent).View;
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;
  jScrollView_setParent(FjEnv, FjObject , FjPRLayout);
  jScrollView_setId(FjEnv, FjObject , Self.Id);
  jScrollView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jScrollView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jScrollView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jScrollView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  jScrollView_setScrollSize(FjEnv,FjObject , FScrollSize);

  if FFillViewportEnabled then
      jScrollView_setFillViewport(FjEnv, FjObject, FFillViewportEnabled);

  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

end;

procedure jScrollView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jScrollView_setParent(FjEnv, FjObject , FjPRLayout);
end;

function jScrollView.GetView: jObject;
begin
    if FInitialized then
       Result:= jScrollView_getView(FjEnv, FjObject);
end;

(* TODO
procedure jScrollView.SetParamWidth(Value: TLayoutParams);
begin
  //
end;
*)

Procedure jScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jScrollView.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
end;

Procedure jScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize:= Value;
  if FInitialized then
     jScrollView_setScrollSize(FjEnv,FjObject , FScrollSize);
end;

procedure jScrollView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jScrollView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jScrollView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jScrollView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jScrollView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jScrollView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jScrollView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jScrollView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jScrollView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jScrollView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jScrollView.SetFillViewport(fillenabled: boolean);
begin
  //in designing component state: set value here...
  FFillViewportEnabled:= fillenabled;
  if FInitialized then
     jScrollView_setFillViewport(FjEnv, FjObject, fillenabled);
end;


procedure jScrollView.ScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jScrollView_ScrollTo(FjEnv, FjObject, _x ,_y);
end;

procedure jScrollView.SmoothScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jScrollView_SmoothScrollTo(FjEnv, FjObject, _x ,_y);
end;

procedure jScrollView.SmoothScrollBy(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jScrollView_SmoothScrollBy(FjEnv, FjObject, _x ,_y);
end;

function jScrollView.GetScrollX(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetScrollX(FjEnv, FjObject);
end;

function jScrollView.GetScrollY(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetScrollY(FjEnv, FjObject);
end;

function jScrollView.GetBottom(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetBottom(FjEnv, FjObject);
end;

function jScrollView.GetTop(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetTop(FjEnv, FjObject);
end;

function jScrollView.GetLeft(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetLeft(FjEnv, FjObject);
end;

function jScrollView.GetRight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jScrollView_GetRight(FjEnv, FjObject);
end;

procedure jScrollView.DispatchOnScrollChangedEvent(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jScrollView_DispatchOnScrollChangedEvent(FjEnv, FjObject, _value);
end;

procedure jScrollView.GenEvent_OnChanged(Obj: TObject; currHor: Integer; currVerti: Integer; prevHor: Integer; prevVertical: Integer; onPosition: Integer; scrolldiff: integer);
begin
   if Assigned(FOnScrollChanged) then FOnScrollChanged(Obj,currHor,currVerti,prevHor,prevVertical,TScrollPosition(onPosition), scrolldiff);
end;

//--------

//------------------------------------------------------------------------------
// jHorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------

Constructor jHorizontalScrollView.Create(AOwner: TComponent);
 begin
  inherited Create(AOwner);
  FScrollSize := 800; //to scrolling images this number could be higher....

  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 96;
  FWidth:= 100;
  //FAcceptChildsAtDesignTime:= True;
  FAcceptChildrenAtDesignTime:= True;
 end;

Destructor jHorizontalScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jHorizontalScrollView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jHorizontalScrollView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);                   //fix create
  FjObject  := jHorizontalScrollView_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;

    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf ) //jScrollView(FParent).View;
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;

    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;

    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;

  end;
  jHorizontalScrollView_setParent(FjEnv, FjObject , FjPRLayout);
  jHorizontalScrollView_setId(FjEnv, FjObject , Self.Id);
  jHorizontalScrollView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jHorizontalScrollView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jHorizontalScrollView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jHorizontalScrollView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  jHorizontalScrollView_setScrollSize(FjEnv,FjObject , FScrollSize);
  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));
  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

end;

procedure jHorizontalScrollView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jHorizontalScrollView_setParent(FjEnv, FjObject , FjPRLayout);
end;

function jHorizontalScrollView.GetView: jObject;
begin
    if FInitialized then
       Result:= jHorizontalScrollView_getView(FjEnv, FjObject);
end;

Procedure jHorizontalScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jHorizontalScrollView.Refresh;
begin
  if not FInitialized then Exit;
  View_Invalidate(FjEnv, FjObject );
end;

Procedure jHorizontalScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FInitialized then
     jHorizontalScrollView_setScrollSize(FjEnv,FjObject , FScrollSize);
end;

procedure jHorizontalScrollView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jHorizontalScrollView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jHorizontalScrollView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jHorizontalScrollView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jHorizontalScrollView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jHorizontalScrollView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jHorizontalScrollView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jHorizontalScrollView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jHorizontalScrollView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jHorizontalScrollView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jHorizontalScrollView.ScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHorizontalScrollView_ScrollTo(FjEnv, FjObject, _x ,_y);
end;

procedure jHorizontalScrollView.SmoothScrollTo(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHorizontalScrollView_SmoothScrollTo(FjEnv, FjObject, _x ,_y);
end;

procedure jHorizontalScrollView.SmoothScrollBy(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHorizontalScrollView_SmoothScrollBy(FjEnv, FjObject, _x ,_y);
end;

function jHorizontalScrollView.GetScrollX(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetScrollX(FjEnv, FjObject);
end;

function jHorizontalScrollView.GetScrollY(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetScrollY(FjEnv, FjObject);
end;

function jHorizontalScrollView.GetBottom(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetBottom(FjEnv, FjObject);
end;

function jHorizontalScrollView.GetTop(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetTop(FjEnv, FjObject);
end;

function jHorizontalScrollView.GetLeft(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetLeft(FjEnv, FjObject);
end;

function jHorizontalScrollView.GetRight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHorizontalScrollView_GetRight(FjEnv, FjObject);
end;

procedure jHorizontalScrollView.DispatchOnScrollChangedEvent(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jHorizontalScrollView_DispatchOnScrollChangedEvent(FjEnv, FjObject, _value);
end;

procedure jHorizontalScrollView.GenEvent_OnChanged(Obj: TObject; currHor: Integer; currVerti: Integer; prevHor: Integer; prevVertical: Integer; onPosition: Integer;  scrolldiff: integer);
begin
   if Assigned(FOnScrollChanged) then FOnScrollChanged(Obj,currHor,currVerti,prevHor,prevVertical,TScrollPosition(onPosition), scrolldiff);
end;

//------------------------------------------------------------------------------
// jWebView
//------------------------------------------------------------------------------

constructor jWebView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJavaScript:= True;
  FZoomControl:= True;
  FOnStatus:= nil;
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 96;
  FWidth:= 100;
end;

destructor jWebView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jWebView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jWebView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jWebView_Create(FjEnv, FjThis, Self);
  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf )
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;
  jWebView_setParent(FjEnv, FjObject , FjPRLayout);
  jWebView_setId(FjEnv, FjObject , Self.Id);
  jWebView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  jWebView_SetZoomControl(FjEnv, FjObject, FZoomControl);

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jWebView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jWebView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jWebView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  jWebView_SetJavaScript(FjEnv, FjObject , FJavaScript);

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

  FInitialized:= True;
end;

procedure jWebView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jWebView_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jWebView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;

Procedure jWebView.Refresh;
 begin
  if not FInitialized then Exit;
  View_Invalidate(FjEnv, FjObject );
 end;

Procedure jWebView.SetJavaScript(Value : Boolean);
begin
  FJavaScript:= Value;
  if FInitialized then
     jWebView_SetJavaScript(FjEnv, FjObject , FJavaScript);
end;

procedure jWebView.SetZoomControl(Value: Boolean);
begin
  if(Value <> FZoomControl) then
  begin
    FZoomControl := Value;
    if FInitialized then jWebView_SetZoomControl(FjEnv, FjObject, FZoomControl);
  end;
end;

Procedure jWebView.Navigate(url: string);
begin
  if not FInitialized then Exit;
  jWebView_loadURL(FjEnv, FjObject , url);
end;

Procedure jWebView.LoadFromHtmlFile(environmentDirectoryPath: string; htmlFileName: string);
begin;
   Navigate('file://'+environmentDirectoryPath+'/'+htmlFileName);
end;

procedure jWebView.LoadFromHtmlString(_htmlString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWebView_LoadFromHtmlString(FjEnv, FjObject, _htmlString);
end;

procedure jWebView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jWebView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jWebView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jWebView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jWebView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jWebView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jWebView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jWebView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jWebView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jWebView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;


procedure jWebView.SetHttpAuthUsernamePassword(_hostName: string; _domain: string; _username: string; _password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWebView_SetHttpAuthUsernamePassword(FjEnv, FjObject, _hostName ,_domain ,_username ,_password);
end;

// Event : Java -> Pascal
procedure jWebView.GenEvent_OnLongClick(Obj: TObject);
begin
  if Assigned(FOnLongClick) then FOnLongClick(Obj);
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

  FFilePath:= fpathData;
  //
  FjObject   := nil;
end;

Destructor jBitmap.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jBitmap_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jBitmap.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject  := jBitmap_Create(FjEnv, FjThis, Self);
  FInitialized:= True;  //neded here....

  if FImageName <> '' then LoadFromRes(FImageName);

  if FImageList <> nil then
  begin
    FImageList.Init(refApp);
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

procedure jBitmap.LoadFromFile(fullFileName : string);
var
  path: string;
begin
  if FInitialized then
  begin
     if fullFileName <> '' then
     begin
       path:='';

       if TryPath(gApp.Path.Dat,fullFileName) then begin path:= gApp.Path.Dat; FFilePath:= fpathApp end
       else if TryPath(gApp.Path.Dat,fullFileName) then begin path:= gApp.Path.Dat; FFilePath:= fpathData  end
       else if TryPath(gApp.Path.DCIM,fullFileName) then begin path:= gApp.Path.DCIM; FFilePath:= fpathDCIM end
       else if TryPath(gApp.Path.Ext,fullFileName) then begin path:= gApp.Path.Ext; FFilePath:= fpathExt end;

       if path <> '' then FImageName:= ExtractFileName(fullFileName)
       else  FImageName:= fullFileName;

       jBitmap_loadFile(FjEnv, FjObject, GetFilePath(FFilePath)+'/'+FImageName);

       FWidth:= jBitmap_GetWidth(FjEnv, FjObject );
       FHeight:= jBitmap_GetHeight(FjEnv, FjObject );
     end;
  end;
end;

Procedure jBitmap.LoadFromRes(imgResIdenfier: String);  // ..res/drawable
begin
   if FInitialized then
   begin
       jBitmap_loadRes(FjEnv, FjObject , imgResIdenfier);
       FWidth:= jBitmap_GetWidth(FjEnv, FjObject );
       FHeight:= jBitmap_GetHeight(FjEnv, FjObject );
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
    jBitmap_createBitmap(FjEnv, FjObject , FWidth, FHeight);
  end;
end;

Function jBitmap.GetJavaBitmap: jObject;
begin
  if FInitialized then
  begin
     Result:= jBitmap_jInstance(FjEnv, FjObject );
  end;
end;

Function jBitmap.GetImage(): jObject;
begin
  if FInitialized then
  begin
     Result:= jBitmap_jInstance(FjEnv, FjObject );
  end;
end;


function jBitmap.BitmapToArrayOfJByte(var bufferImage: TDynArrayOfJByte): integer; //local/self
var
  PJavaPixel: PScanByte; {need by delphi mode!} //PJByte;
  k, row, col: integer;
  w, h: integer;
begin
  Result:= 0;
  if Self.GetInfo then
  begin

    PJavaPixel:= nil;
    //point to and lock java bitmap image ...
    Self.LockPixels(PJavaPixel); //ok  ... demo API LockPixels - overloaded - paramenter is "PJavaPixel"
    k:= 0;
    w:= Self.Width;
    h:= Self.Height;
    Result:=  h*w;
    SetLength(bufferImage,Result*4); //thanks to Prof. Wellington Pinheiro dos Santos
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

function jBitmap.GetByteArrayFromBitmap(var bufferImage: TDynArrayOfJByte): integer;
begin
  if FInitialized then
   Result:= jBitmap_GetByteArrayFromBitmap(FjEnv, FjObject , bufferImage);
end;

procedure jBitmap.SetByteArrayToBitmap(var bufferImage: TDynArrayOfJByte; size: integer);
begin
  if FInitialized then
    jBitmap_SetByteArrayToBitmap(FjEnv, FjObject , bufferImage, size);
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

   if FImageList = nil then Exit;

   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageName:= Trim(FImageList.Images.Strings[Value]);
      if  (FImageName <> '') then
      begin
        jBitmap_loadFile(FjEnv, FjObject, GetFilePath(FFilePath)+'/'+FImageName);
        jBitmap_getWH(FjEnv, FjObject , integer(FWidth),integer(FHeight));
      end;
   end;
end;

procedure jBitmap.SetImageIndex(Value: TImageListIndex);
begin
  FImageIndex:= Value;
  if FInitialized then
  begin
    if  FImageList <> nil then
    begin
      if Value >= FImageList.Images.Count then
        FImageIndex:= FImageList.Images.Count - 1;
      if Value < 0 then
        FImageIndex:= 0;

       SetImageByIndex(FImageIndex);
    end;
  end;
end;

procedure jBitmap.SetImageIdentifier(Value: string);
begin
    FImageName:= Value;
    if FInitialized then LoadFromRes(Value);
end;

procedure jBitmap.LockPixels(var PDWordPixel : PScanLine);
begin
  if FInitialized then
    AndroidBitmap_lockPixels(FjEnv, Self.GetJavaBitmap, @PDWordPixel);
end;

procedure jBitmap.LockPixels(var PBytePixel : PScanByte {delphi mode});
begin
  if FInitialized then
    AndroidBitmap_lockPixels(FjEnv, Self.GetJavaBitmap, @PBytePixel);
end;

procedure jBitmap.LockPixels(var PSJByte: PJByte {FPC mode });
begin
  if FInitialized then
    AndroidBitmap_lockPixels(FjEnv, Self.GetJavaBitmap, @PSJByte);
end;

procedure jBitmap.UnlockPixels;
begin
  if FInitialized then
     AndroidBitmap_unlockPixels(FjEnv, Self.GetJavaBitmap);
end;

function jBitmap.GetInfo: boolean;
var
  rtn: integer;
begin
  Result:= False;
  if FInitialized then
  begin
    rtn:= AndroidBitmap_getInfo(FjEnv,Self.GetJavaBitmap,@Self.FBitmapInfo);
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
begin
    Self.LockPixels(PDWordPixel); //ok    ...API LockPixels... parameter is "PScanLine"
    for k:= 0 to Self.Width*Self.Height-1 do
        PDWordPixel^[k]:= not PDWordPixel^[k];  //ok
    Self.UnlockPixels;
end;

function jBitmap.ClockWise(_bmp: jObject; _imageView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_ClockWise(FjEnv, FjObject, _bmp ,_imageView);
end;

function jBitmap.AntiClockWise(_bmp: jObject; _imageView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_AntiClockWise(FjEnv, FjObject, _bmp ,_imageView);
end;

function jBitmap.SetScale(_bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_SetScale(FjEnv, FjObject, _bmp ,_imageView ,_scaleX ,_scaleY);
end;

function jBitmap.SetScale(_imageView: jObject; _scaleX: single; _scaleY: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_SetScale(FjEnv, FjObject, _imageView ,_scaleX ,_scaleY);
end;

function jBitmap.LoadFromAssets(strName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_LoadFromAssets(FjEnv, FjObject, strName);
end;

function jBitmap.GetResizedBitmap(_bmp: jObject; _newWidth: integer; _newHeight: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetResizedBitmap(FjEnv, FjObject, _bmp ,_newWidth ,_newHeight);
end;

function jBitmap.GetResizedBitmap(_newWidth: integer; _newHeight: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetResizedBitmap(FjEnv, FjObject,_newWidth ,_newHeight);
end;

function jBitmap.GetResizedBitmap(_factorScaleX: single; _factorScaleY: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetResizedBitmap(FjEnv, FjObject, _factorScaleX ,_factorScaleY);
end;

function jBitmap.GetByteBuffer(_width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetByteBuffer(FjEnv, FjObject, _width ,_height);
end;

function jBitmap.GetBitmapFromByteBuffer(_byteBuffer: jObject; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetBitmapFromByteBuffer(FjEnv, FjObject, _byteBuffer ,_width ,_height);
end;

function jBitmap.GetBitmapFromByteArray(var _image: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetBitmapFromByteArray(FjEnv, FjObject, _image);
end;

function jBitmap.GetDirectBufferAddress(byteBuffer: jObject): PJByte;
begin
   Result:= PJByte((FjEnv^).GetDirectBufferAddress(FjEnv,byteBuffer));
end;

function jBitmap.GetByteBufferFromBitmap(_bmap: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetByteBufferFromBitmap(FjEnv, FjObject, _bmap);
end;

function jBitmap.GetByteBufferFromBitmap(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetByteBufferFromBitmap(FjEnv, FjObject);
end;

function jBitmap.GetImageFromFile(_fullFilename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_LoadFromFile(FjEnv, FjObject, _fullFilename);
end;

function jBitmap.GetRoundedShape(_bitmapImage: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetRoundedShape(FjEnv, FjObject, _bitmapImage);
end;

function jBitmap.GetRoundedShape(_bitmapImage: jObject; _diameter: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBitmap_GetRoundedShape(FjEnv, FjObject, _bitmapImage ,_diameter);
end;

//------------------------------------------------------------------------------
// jCanvas
//------------------------------------------------------------------------------
constructor jCanvas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FjObject  := nil;
  FPaintStrokeWidth:= 1;
  FPaintStyle:= psStroke;
  FPaintTextSize:= 20;
  FPaintColor:= colbrBlue;
  FInitialized:= False;
end;

destructor jCanvas.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jCanvas_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jCanvas.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jCanvas_Create(FjEnv, FjThis, Self);
  jCanvas_setStrokeWidth(FjEnv, FjObject ,FPaintStrokeWidth);
  jCanvas_setStyle(FjEnv, FjObject ,ord(FPaintStyle));
  jCanvas_setColor(FjEnv, FjObject ,GetARGB(FCustomColor, FPaintColor));
  jCanvas_setTextSize(FjEnv, FjObject ,FPaintTextSize);
  FInitialized:= True;
end;

Procedure jCanvas.SetStrokeWidth(Value : single );
begin
  FPaintStrokeWidth:= Value;
  if FInitialized then
     jCanvas_setStrokeWidth(FjEnv, FjObject ,FPaintStrokeWidth);
end;

Procedure jCanvas.SetStyle(Value : TPaintStyle);
begin
  FPaintStyle:= Value;
  if FInitialized then
     jCanvas_setStyle(FjEnv, FjObject ,Ord(FPaintStyle));
end;

Procedure jCanvas.SetColor(Value : TARGBColorBridge);
begin
  FPaintColor:= Value;
  if FInitialized then
     jCanvas_setColor(FjEnv, FjObject ,GetARGB(FCustomColor, FPaintColor));
end;

Procedure jCanvas.SetTextSize(Value: single);
begin
  FPaintTextSize:= Value;
  if FInitialized then
     jCanvas_setTextSize(FjEnv, FjObject ,FPaintTextSize);
end;

procedure jCanvas.SetTypeface(Value: TFontFace);
begin
  //in designing component state: set value here...
  FTypeFace:= Value;
  if FInitialized then
     jCanvas_SetTypeface(FjEnv, FjObject, Ord(FTypeFace));
end;

Procedure jCanvas.drawText(Text: string; x,y: single);
begin
  if FInitialized then
     jCanvas_drawText(FjEnv, FjObject ,text,x,y);
end;

Procedure jCanvas.DrawLine(x1,y1,x2,y2 : single);
begin
  if FInitialized then
     jCanvas_drawLine(FjEnv, FjObject ,x1,y1,x2,y2);
end;

Procedure jCanvas.DrawPoint(x1,y1 : single);
begin
  if FInitialized then
     jCanvas_drawPoint(FjEnv, FjObject ,x1,y1);
end;

procedure jCanvas.drawCircle(_cx: single; _cy: single; _radius: single);
begin
  if FInitialized then
     jCanvas_drawCircle(FjEnv, FjObject , _cx, _cy, _radius);
end;

procedure jCanvas.drawOval(_left, _top, _right, _bottom: single);
begin
  if FInitialized then
     jCanvas_drawOval(FjEnv, FjObject , _left, _top, _right, _bottom);
end;

procedure jCanvas.drawBackground(_color: integer);
begin
  if FInitialized then
     jCanvas_drawBackground(FjEnv, FjObject ,_color);
end;

procedure jCanvas.drawRect(_left, _top, _right, _bottom: single);
begin
  if FInitialized then
     jCanvas_drawRect(FjEnv, FjObject , _left, _top, _right, _bottom);
end;

procedure jCanvas.drawRoundRect(_left, _top, _right, _bottom, _rx, _ry: single);
begin
  if FInitialized then
     jCanvas_drawRoundRect(FjEnv, FjObject , _left, _top, _right, _bottom, _rx, _ry);
end;


Procedure jCanvas.DrawBitmap(bmp: jObject; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap(FjEnv, FjObject ,bmp, b, l, r, t);
end;

Procedure jCanvas.DrawBitmap(bmp: jBitmap; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap(FjEnv, FjObject ,bmp.GetJavaBitmap, b, l, r, t);
end;


Procedure jCanvas.DrawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-20);
  t1:= Round((size-20)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap(FjEnv, FjObject , bmp, x1, y1, r1, t1);
end;


Procedure jCanvas.DrawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-10);
  t1:= Round((size-10)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap(FjEnv, FjObject , bmp.GetJavaBitmap, x1, y1, r1, t1);
end;

procedure jCanvas.DrawBitmap(_bitmap: jObject; _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCanvas_drawBitmap(FjEnv, FjObject, _bitmap ,_width ,_height);
end;

procedure jCanvas.SetCanvas(_canvas: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCanvas_setCanvas(FjEnv, FjObject, _canvas);
end;

//by CC
procedure jCanvas.DrawTextAligned(_text: string; _left, _top, _right, _bottom: single; _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);
var
  alignHor, aligVer: single;
begin
  case _alignHorizontal of
    thLeft: alignHor:= 0;
    thRight: alignHor:= 1;
    thCenter:  alignHor:= 0.5;
  end;

  case _alignVertical of
     tvTop: aligVer:= 0;
     tvBottom: aligVer:= 1;
     tvCenter: aligVer:= 0.5
  end;

  if FInitialized then
  begin
     jCanvas_drawTextAligned(FjEnv, FjObject, _text, _left, _top, _right, _bottom, alignHor, aligVer );
  end;
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

  FLParamWidth:= lpWrapContent; //lpMatchParent;
  FLParamHeight:= lpWrapContent;
  FHeight:= 96;
  FWidth:= 96;
end;

Destructor jView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jView_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);

  FjObject  := jView_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

  if  FjCanvas <> nil then
  begin
    FjCanvas.Init(refApp);
    jView_setjCanvas(FjEnv,FjObject ,FjCanvas.JavaObj);
  end;

  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;

  jView_setParent(FjEnv,FjObject , FjPRLayout);

  jView_setId(FjEnv, FjObject , Self.Id);
  jView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));
  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

end;

procedure jView.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jView_setParent(FjEnv,FjObject , FjPRLayout);
end;

Procedure jView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
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
        jView_viewSave(FjEnv, FjObject , GetFilePath(FFilePath)+'/'+str);
     end;
  end;
end;

Procedure jView.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
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
Procedure jView.GenEvent_OnDraw(Obj: TObject);
begin
  if Assigned(FOnDraw) then FOnDraw(Obj);
end;

procedure jView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jView.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

function jView.GetWidth: integer;
begin
   Result:= FWidth;
   if FInitialized then
   begin
      Result:= jView_getLParamWidth(FjEnv, FjObject );
      if Result = -1 then //lpMatchParent
      begin
          if FParent is jForm then Result:= (FParent as jForm).ScreenWH.Width
          else Result:= Self.Parent.Width;
      end;
   end;
end;

function jView.GetHeight: integer;
begin
   Result:= FHeight;
   if FInitialized then
      Result:= jView_getLParamHeight(FjEnv, FjObject );
   if Result = -1 then //lpMatchParent
   begin
       if FParent is jForm then Result:= (FParent as jForm).ScreenWH.Height
       else Result:= Self.Parent.Height;
   end;
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

function jView.GetDrawingCache(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jView_GetBitmap(FjEnv, FjObject);
end;

function jView.GetImage(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jView_GetBitmap(FjEnv, FjObject);
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
  FjParent   := jForm(AOwner);
  FjObject   := nil;
end;

destructor jTimer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
       jTimer_Free(FjEnv, FjObject );
       FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jTimer.Init(refApp: jApp);
begin
  if FInitialized then Exit;
  inherited Init(refApp);
  FjObject := jTimer_Create(FjEnv, FjThis, Self);
  jTimer_SetInterval(FjEnv, FjObject , FInterval);
  FInitialized:= True;
end;

Procedure jTimer.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jTimer_SetEnabled(FjEnv, FjObject , FEnabled);
end;

Procedure jTimer.SetInterval(Value: integer);
begin
  FInterval:= Value;
  if FInitialized then
     jTimer_SetInterval(FjEnv, FjObject , FInterval);
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
  FjObject := nil;
end;

Destructor jDialogYN.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jDialogYN_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogYN.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jDialogYN_Create(FjEnv, FjThis, Self, FTitle, FMsg, FYes, FNo);
  FInitialized:= True;
end;

Procedure jDialogYN.Show;
begin
  if FInitialized then
     jDialogYN_Show(FjEnv, FjObject );
end;

Procedure jDialogYN.Show(titleText: string; msgText: string; yesText: string; noText: string);
begin
  if FInitialized then
     jDialogYN_Show(FjEnv, FjObject, titleText, msgText, yesText, noText);
end;

Procedure jDialogYN.Show(titleText: string; msgText: string);
begin
  if FInitialized then
     jDialogYN_Show(FjEnv, FjObject, titleText, msgText);
end;

procedure jDialogYN.ShowOK(titleText: string; msgText: string; _OkText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDialogYN_ShowOK(FjEnv, FjObject, titleText ,msgText ,_OkText);
end;

// Event : Java -> Pascal
Procedure jDialogYN.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if not Assigned(FOnDialogYN) then Exit;
  case Value of
     cjClick_Yes : FOnDialogYN(Obj, ClickYes);
     cjClick_No  : FOnDialogYN(Obj, ClickNo);
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
  FjObject  := nil;
  FTitle:= 'Lamw: Lazarus Android Module Wizard';
  FMsg:= 'Please, wait...';
  FInitialized:= False;
end;

Destructor jDialogProgress.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jDialogProgress_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogProgress.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jDialogProgress_Create(FjEnv, gApp.Jni.jThis, Self, FTitle, FMsg);
  FInitialized:= True;
end;

procedure jDialogProgress.Stop;
begin
  if FInitialized then
     jDialogProgress_Stop(FjEnv, FjObject);
end;


procedure jDialogProgress.Close;
begin
  if FInitialized then
     jDialogProgress_Stop(FjEnv, FjObject);
end;

procedure jDialogProgress.Start;
begin
  if FInitialized then
     jDialogProgress_Show(FjEnv, FjObject)

end;

procedure jDialogProgress.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDialogProgress_Show(FjEnv, FjObject);
end;

procedure jDialogProgress.Show(_title: string; _msg: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDialogProgress_Show(FjEnv, FjObject, _title ,_msg);
end;

procedure jDialogProgress.Show(_layout: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDialogProgress_Show(FjEnv, FjObject, _layout);
end;

procedure jDialogProgress.SetMessage(_msg: string);
begin
  //in designing component state: set value here...
  FMsg:= _msg;
  if not FInitialized then  Exit;
     if FjObject <> nil then
        jDialogProgress_SetMessage(FjEnv, FjObject, _msg);
end;

procedure jDialogProgress.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FTitle:= _title;
  if FInitialized then
     jDialogProgress_SetTitle(FjEnv, FjObject, _title);
end;

procedure jDialogProgress.SetCancelable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDialogProgress_SetCancelable(FjEnv, FjObject, _value);
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
  FLParamHeight:= lpWrapContent;

  FFilePath := fpathData;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FWidth        := 48;
  FHeight       := 48;
end;

Destructor jImageBtn.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jImageBtn_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jImageBtn.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jImageBtn_Create(FjEnv, FjThis, Self);
  FInitialized:= True;

    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf )
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;

  jImageBtn_setParent(FjEnv, FjObject , FjPRLayout);
  jImageBtn_setId(FjEnv, FjObject , Self.Id);
  jImageBtn_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageBtn_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageBtn_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jImageBtn_SetEnabled(FjEnv, FjObject ,FEnabled);

  if FImageDownName <> '' then
      jImageBtn_setButtonDownByRes(FjEnv, FjObject , FImageDownName);

  if FImageUpName <> '' then
     jImageBtn_setButtonUpByRes(FjEnv, FjObject , FImageUpName);

  if FImageList <> nil then
  begin
    FImageList.Init(refApp);   //must have!
    if FImageList.Images.Count > 0 then
    begin
       if FImageDownIndex >=0 then SetImageDownByIndex(FImageDownIndex);
       if FImageUpIndex >=0 then SetImageUpByIndex(FImageUpIndex);
    end;
  end;

  jImageBtn_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if FColor <> colbrDefault then
     View_SetBackGroundColor(FjEnv, FjThis, FjObject , GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);
end;

procedure jImageBtn.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jImageBtn_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jImageBtn.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     View_SetBackGroundColor(FjEnv, FjObject , GetARGB(FCustomColor, FColor));
end;
 
// LORDMAN 2013-08-16
procedure jImageBtn.SetEnabled(Value : Boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jImageBtn_SetEnabled(FjEnv, FjObject , FEnabled);
end;

procedure jImageBtn.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject );
end;

Procedure jImageBtn.SetImageDownByIndex(Value: integer);
begin
   if not FInitialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageDownName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageDownName <> '' then
      begin
        jImageBtn_setButtonDown(FjEnv, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageDownName);
      end;
   end;
end;

Procedure jImageBtn.SetImageUpByIndex(Value: integer);
begin
   if not FInitialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageUpName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageUpName <> '' then
      begin
        jImageBtn_setButtonUp(FjEnv, FjObject ,GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageUpName);
      end;
   end;
end;

procedure jImageBtn.SetImageDownByRes(imgResIdentifief: string);
begin
   FImageDownName:= imgResIdentifief;
   if FInitialized then
     jImageBtn_setButtonDownByRes(FjEnv, FjObject , imgResIdentifief);
end;

procedure jImageBtn.SetImageUpByRes(imgResIdentifief: string);
begin
  FImageUpName:=  imgResIdentifief;
  if FInitialized then
    jImageBtn_setButtonUpByRes(FjEnv, FjObject , imgResIdentifief);
end;

procedure jImageBtn.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jImageBtn_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
           jImageBtn_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
           jImageBtn_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jImageBtn.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jImageBtn_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jImageBtn_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
          jImageBtn_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jImageBtn.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jImageBtn_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
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
  FjObject:= nil;
  FRunning:= False;
end;

destructor jAsyncTask.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jAsyncTask_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

procedure jAsyncTask.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FInitialized:= True;
  FjObject := jAsyncTask_Create(FjEnv, FjThis, Self);
end;

procedure jAsyncTask.Done;
begin
   FRunning:= False;
end;

Procedure jAsyncTask.Execute;
begin
  if  (FInitialized = True) and (FRunning = False) then
  begin
    Self.UpdateJNI(gApp);
    FRunning:= True;
    jAsyncTask_Execute(FjEnv, FjObject);
  end;
end;

procedure jAsyncTask.GenEvent_OnAsyncEventDoInBackground(Obj: TObject; progress: integer; out keepInBackground: boolean);
begin
  keepInBackground:= True;
  if Assigned(FOnDoInBackground) then FOnDoInBackground(Obj,progress,keepInBackground);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventProgressUpdate(Obj: TObject; progress: integer; out progressUpdate: integer);
begin
  progressUpdate:= progress + 1;
  if Assigned(FOnProgressUpdate) then FOnProgressUpdate(Obj,progress, progressUpdate);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventPreExecute(Obj: TObject; out startProgress: integer);
begin
  startProgress:= 0;
  if Assigned(FOnPreExecute) then FOnPreExecute(Obj, startProgress);
end;

procedure jAsyncTask.GenEvent_OnAsyncEventPostExecute(Obj: TObject; progress: Integer);
begin
  if Assigned(FOnPostExecute) then FOnPostExecute(Obj,progress);
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

procedure jGLViewEvent.Init(refApp: jApp);
begin
  if FInitialized then Exit;
  inherited Init(refApp);
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
  //FjObject  := nil;
end;

destructor jSqliteCursor.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jSqliteCursor_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  inherited Destroy;
end;

Procedure jSqliteCursor.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jSqliteCursor_Create(FjEnv, FjThis, Self);
  FInitialized:= True;
end;

procedure jSqliteCursor.SetCursor(Value: jObject);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_SetCursor(FjEnv, FjObject , Value);
end;


procedure jSqliteCursor.MoveToFirst;
begin
   if not FInitialized  then Exit;
   jSqliteCursor_MoveToFirst(FjEnv, FjObject );
end;

procedure jSqliteCursor.MoveToNext;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToNext(FjEnv, FjObject );
end;

procedure jSqliteCursor.MoveToLast;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToLast(FjEnv, FjObject );
end;

procedure jSqliteCursor.MoveToPosition(position: integer);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToPosition(FjEnv, FjObject , position);
end;

function jSqliteCursor.GetRowCount: integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetRowCount(FjEnv, FjObject );
end;

function jSqliteCursor.GetColumnCount: integer;
begin
  if not FInitialized  then Exit;
  Result:= jSqliteCursor_GetColumnCount(FjEnv, FjObject );
end;

function jSqliteCursor.GetColumnIndex(colName: string): integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumnIndex(FjEnv, FjObject , colName);
end;

function jSqliteCursor.GetColumName(columnIndex: integer): string;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumName(FjEnv, FjObject , columnIndex);
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
   colType:= jSqliteCursor_GetColType(FjEnv, FjObject , columnIndex);
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
   Result:= jSqliteCursor_GetValueAsString(FjEnv, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsBitmap(columnIndex: integer): jObject;
begin
  if not FInitialized  then Exit;
    Result:= jSqliteCursor_GetValueAsBitmap(FjEnv, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsInteger(columnIndex: integer): integer;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsInteger(FjEnv, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsDouble(columnIndex: integer): double;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsDouble(FjEnv, FjObject , columnIndex);
end;


function jSqliteCursor.GetValueAsFloat(columnIndex: integer): real;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsFloat(FjEnv, FjObject , columnIndex);
end;

//position = -1 --->> Last Row !!!
function jSqliteCursor.GetValueAsString(position: integer; columnName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSqliteCursor_GetValueAsString(FjEnv, FjObject, position ,columnName);
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
  FReturnHeaderOnSelect:= True;
  FInitialized:= False;
end;

Destructor jSqliteDataAccess.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if FjObject  <> nil then
    begin
      jSqliteDataAccess_Free(FjEnv, FjObject );
      FjObject := nil;
    end;
  end;
  FTableName.Free;
  FCreateTableQuery.Free;
  inherited Destroy;
end;

procedure jSqliteDataAccess.Init(refApp: jApp);
var
  i: integer;
begin
  if FInitialized then Exit;
  inherited Init(refApp);
  FjObject := jSqliteDataAccess_Create(FjEnv, FjThis, Self, FDataBaseName, FColDelimiter, FRowDelimiter);

  FInitialized:= True;

  for i:= 0 to FTableName.Count-1 do
  begin
     jSqliteDataAccess_AddTableName(FjEnv, FjObject , FTableName.Strings[i]);
  end;

  for i:= 0 to FCreateTableQuery.Count-1 do
  begin
     jSqliteDataAccess_AddCreateTableQuery(FjEnv, FjObject , FCreateTableQuery.Strings[i]);
  end;

  if not FReturnHeaderOnSelect then
      jSqliteDataAccess_SetReturnHeaderOnSelect(FjEnv, FjObject, FReturnHeaderOnSelect);

  FFullPathDataBaseName:= GetFilePath(fpathDataBase) + '/' + FDataBaseName;

end;

Procedure jSqliteDataAccess.ExecSQL(execQuery: string);
begin
   if not FInitialized then Exit;
   jSqliteDataAccess_ExecSQL(FjEnv, FjObject , execQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

//"data/data/com.data.pack/databases/" + myData.db;
function jSqliteDataAccess.CheckDataBaseExists(databaseName: string): boolean;
var
  fullPathDB: string;
begin                      {/data/data/com.example.program/databases}
  if not FInitialized then Exit;
  fullPathDB:=  GetFilePath(fpathDataBase) + '/' + databaseName;
  Result:= jSqliteDataAccess_CheckDataBaseExists(FjEnv, FjObject , fullPathDB);
end;

procedure jSqliteDataAccess.OpenOrCreate(dataBaseName: string);
begin
  if not FInitialized then Exit;
  if dataBaseName <> '' then FDataBaseName:= dataBaseName;
  jSqliteDataAccess_OpenOrCreate(FjEnv, FjObject , FDataBaseName);
end;

procedure jSqliteDataAccess.SetVersion(version :integer); //renabor
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_SetVersion(FjEnv, FjObject , version);
end;

function jSqliteDataAccess.GetVersion():integer; // renabor
begin
  if not FInitialized then Exit;
  Result:=jSqliteDataAccess_GetVersion(FjEnv, FjObject);
end;

procedure jSqliteDataAccess.AddTable(tableName: string; createTableQuery: string);
begin
  if not FInitialized then Exit;
   jSqliteDataAccess_AddTableName(FjEnv, FjObject , tableName);
   jSqliteDataAccess_AddCreateTableQuery(FjEnv, FjObject , createTableQuery);
end;

procedure jSqliteDataAccess.CreateAllTables;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateAllTables(FjEnv, FjObject );
end;

function jSqliteDataAccess.Select(selectQuery: string): string;
begin
   if not FInitialized then Exit;
   Result:= jSqliteDataAccess_Select(FjEnv, FjObject, selectQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

function jSqliteDataAccess.Select(selectQuery: string; moveToLast: boolean): boolean;
begin
  if not FInitialized then Exit;
  Result:= jSqliteDataAccess_Select(FjEnv, FjObject, selectQuery ,moveToLast);
  if Result then
     if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;


function jSqliteDataAccess.GetCursor: jObject;
begin
  if not FInitialized then Exit;
  Result:= jSqliteDataAccess_GetCursor(FjEnv, FjObject );
end;

procedure jSqliteDataAccess.SetSelectDelimiters(coldelim: char; rowdelim: char);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_SetSelectDelimiters(FjEnv, FjObject , coldelim, rowdelim);
end;

//ex. "CREATE TABLE IF NOT EXISTS TABLE1  (_ID INTEGER PRIMARY KEY, NAME TEXT, PLACE TEXT);"
procedure jSqliteDataAccess.CreateTable(createQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateTable(FjEnv, FjObject , createQuery);
end;

procedure jSqliteDataAccess.DropTable(tableName: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DropTable(FjEnv, FjObject , tableName);
end;

//ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('BRASILIA','CENTRO OESTE')"
procedure jSqliteDataAccess.InsertIntoTable(insertQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_InsertIntoTable(FjEnv, FjObject , insertQuery);
end;

//ex: "DELETE FROM TABLE1  WHERE PLACE = 'BR'";
procedure jSqliteDataAccess.DeleteFromTable(deleteQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DeleteFromTable(FjEnv, FjObject , deleteQuery);
end;

//ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'BR'"
procedure jSqliteDataAccess.UpdateTable(updateQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_UpdateTable(FjEnv, FjObject , updateQuery);
end;

procedure jSqliteDataAccess.UpdateImage(tableName: string;imageFieldName: string;keyFieldName: string;imageValue: jObject;keyValue: integer);
begin
  jSqliteDataAccess_UpdateImage(FjEnv, FjObject ,
                                 tableName,imageFieldName,keyFieldName,imageValue,keyValue);
end;

procedure jSqliteDataAccess.Close;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_Close(FjEnv, FjObject );
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

procedure jSqliteDataAccess.SetForeignKeyConstraintsEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_SetForeignKeyConstraintsEnabled(FjEnv, FjObject, _value);
end;

procedure jSqliteDataAccess.SetDefaultLocale();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_SetDefaultLocale(FjEnv, FjObject);
end;

procedure jSqliteDataAccess.DeleteDatabase(_dbName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_DeleteDatabase(FjEnv, FjObject, _dbName);
end;

procedure jSqliteDataAccess.UpdateImage(_tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_UpdateImage(FjEnv, FjObject, _tabName ,_imageFieldName ,_keyFieldName ,_imageResIdentifier ,_keyValue);
end;

procedure jSqliteDataAccess.InsertIntoTableBatch(var _insertQueries: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_InsertIntoTableBatch(FjEnv, FjObject, _insertQueries);
end;

procedure jSqliteDataAccess.UpdateTableBatch(var _updateQueries: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_UpdateTableBatch(FjEnv, FjObject, _updateQueries);
end;

function jSqliteDataAccess.CheckDataBaseExistsByName(_dbName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jSqliteDataAccess_CheckDataBaseExistsByName(FjEnv, FjObject, _dbName);
end;

procedure jSqliteDataAccess.UpdateImageBatch(var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_UpdateImageBatch(FjEnv, FjObject, _imageResIdentifierDataArray ,_delimiter);
end;

procedure jSqliteDataAccess.SetDataBaseName(_dbName: string);
begin
  //in designing component state: set value here...
  FDatabaseName:= _dbName;
  if FInitialized then
     jSqliteDataAccess_SetDataBaseName(FjEnv, FjObject, _dbName);
end;

function jSqliteDataAccess.GetFullPathDataBaseName(): string;
begin
  if FInitialized then
  begin
     FFullPathDataBaseName:= GetFilePath(fpathDataBase) + '/' + FDataBaseName;
  end;
  Result:= FFullPathDataBaseName;
end;

function jSqliteDataAccess.DatabaseExists(_databaseName: string): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jSqliteDataAccess_DatabaseExists(FjEnv, FjObject, _databaseName);
end;

procedure jSqliteDataAccess.SetAssetsSearchFolder(_folderName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSqliteDataAccess_SetAssetsSearchFolder(FjEnv, FjObject, _folderName);
end;

procedure jSqliteDataAccess.SetReturnHeaderOnSelect(_returnHeader: boolean);
begin
  //in designing component state: set value here...
  FReturnHeaderOnSelect:= _returnHeader;
  if FInitialized then
     jSqliteDataAccess_SetReturnHeaderOnSelect(FjEnv, FjObject, _returnHeader);
end;

   {jPanel}

constructor jPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLParamWidth:= lpMatchParent;
  FLParamHeight:=lpWrapContent;
  FAcceptChildrenAtDesignTime:= True;
  FMarginTop:= 4;
  FMarginLeft:= 4;
  FMarginRight:= 4;
  FMarginBottom:= 4;
  FMinZoomFactor:= 1/4;
  FMaxZoomFactor:= 8/2;
  FHeight:= 48;
  FWidth:= 96;
end;

destructor jPanel.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
   if FjObject  <> nil then
   begin
     jPanel_Free(FjEnv, FjObject);
     FjObject := nil;
   end;
  end;
  inherited Destroy;
end;

procedure jPanel.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);

  FjObject := jPanel_Create(FjEnv, FjThis, Self); //jSelf !
  FInitialized:= True;

  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;

    if FParent is jViewFlipper then
    begin
      jViewFlipper(FParent).Init(refApp);
      FjPRLayout:= jViewFlipper(FParent).View;
    end;

    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;

  end;

  jPanel_setParent(FjEnv, FjObject , FjPRLayout);

  jPanel_setId(FjEnv, FjObject , Self.Id);

  jPanel_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                          FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                          GetLayoutParams(gApp, FLParamWidth, sdW),
                                          GetLayoutParams(gApp, FLParamHeight, sdH));
  if FParent is jPanel then
  begin
     Self.UpdateLayout();
  end;

  for rToA := raAbove to raAlignRight do
  begin
   if rToA in FPositionRelativeToAnchor then
   begin
     jPanel_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jPanel_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  if FMinZoomFactor <> 0.25 then jPanel_SetMinZoomFactor(FjEnv, FjObject, FMinZoomFactor);
  if FMaxZoomFactor <> 4.00 then jPanel_SetMaxZoomFactor(FjEnv, FjObject, FMaxZoomFactor);

  jPanel_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjThis, FjObject{FjRLayout}{!}, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjThis, FjObject, FVisible);

end;

procedure jPanel.SetViewParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
   jPanel_setParent(FjEnv, FjObject , FjPRLayout);
end;

Procedure jPanel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
    View_SetBackGroundColor(FjEnv, FjObject{FjRLayout}{view!}, GetARGB(FCustomColor, FColor)); //@@
end;

Procedure jPanel.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject );
end;

procedure jPanel.SetParamWidth(Value: TLayoutParams);
begin
   inherited  SetParamWidth(Value);
   if FInitialized then
   begin
     //
   end;
end;

procedure jPanel.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jPanel_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
      begin
         jPanel_setLParamWidth(FjEnv, FjObject ,GetLayoutParams(gApp, FLParamWidth, sdW));
      end
      else //lpMatchParent or others
      begin
         jPanel_setLParamWidth(FjEnv,FjObject, GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
      end;
    end;
  end;
end;

procedure jPanel.SetParamHeight(Value: TLayoutParams);
begin
   inherited SetParamHeight(Value);
   if FInitialized then
   begin
     //
   end;
end;

procedure jPanel.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
       if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
       jPanel_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
       if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jPanel_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
       else //lpMatchParent and others
         jPanel_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

function jPanel.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jPanel_getLParamWidth(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
         if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Width
         else
             Result:= (FParent as jForm).ScreenWH.Height;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetWidth;
       end;
     end;
  end;
end;

function jPanel.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jPanel_getLParamHeight(FjEnv, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then
       begin
          if (FParent as jForm).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then
             Result:= (FParent as jForm).ScreenWH.Height
          else
             Result:= (FParent as jForm).ScreenWH.Width;
       end
       else
       begin
          Result:= (FParent as jVisualControl).GetHeight;
       end;
     end;
  end;
end;

procedure jPanel.ResetAllRules;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  jPanel_resetLParamsRules(FjEnv, FjObject );

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
       jPanel_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
  end;
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
      jPanel_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jPanel.UpdateLayout();
begin
  if FInitialized then
  begin
    inherited UpdateLayout();
    UpdateLParamWidth;
    UpdateLParamHeight;
    jPanel_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
  end;
end;

procedure jPanel.RemoveParent;
begin
if FInitialized then
   jPanel_RemoveParent(FjEnv, FjObject);
end;

procedure jPanel.GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
begin
  if Assigned(FOnFling) then  FOnFling(Obj, TFlingGesture(direction));
end;

Procedure Java_Event_pOnFlingGestureDetected(env: PJNIEnv; this: jobject; Obj: TObject; direction: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jPanel then
  begin
    jPanel(Obj).UpdateJNI(gApp);
    jPanel(Obj).GenEvent_OnFlingGestureDetected(Obj, direction);
  end;
  if Obj is jViewFlipper then
  begin
    jViewFlipper(Obj).UpdateJNI(gApp);
    jViewFlipper(Obj).GenEvent_OnFlingGestureDetected(Obj, direction);
  end;
end;

procedure jPanel.GenEvent_OnPinchZoomGestureDetected(Obj: TObject; scaleFactor: single; state: integer);
begin
  if Assigned(FOnPinchGesture) then  FOnPinchGesture(Obj, scaleFactor, TPinchZoomScaleState(state));
end;

Procedure Java_Event_pOnPinchZoomGestureDetected(env: PJNIEnv; this: jobject; Obj: TObject; scaleFactor: single; state: integer);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jPanel then
  begin
    jPanel(Obj).UpdateJNI(gApp);
    jPanel(Obj).GenEvent_OnPinchZoomGestureDetected(Obj,  scaleFactor, state);
  end;
end;


procedure jPanel.SetMinZoomFactor(_minZoomFactor: single);
begin
  //in designing component state: set value here...
  FMinZoomFactor:= _minZoomFactor;
  if FInitialized then
     jPanel_SetMinZoomFactor(FjEnv, FjObject, _minZoomFactor);
end;

procedure jPanel.SetMaxZoomFactor(_maxZoomFactor: single);
begin
  //in designing component state: set value here...
  FMaxZoomFactor:= _maxZoomFactor;
  if FInitialized then
     jPanel_SetMaxZoomFactor(FjEnv, FjObject, _maxZoomFactor);
end;

procedure jPanel.CenterInParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_CenterInParent(FjEnv, FjObject);
end;

procedure jPanel.MatchParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_MatchParent(FjEnv, FjObject);
end;

procedure jPanel.WrapContent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_WrapContent(FjEnv, FjObject);
end;

procedure jPanel.SetRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_SetRoundCorner(FjEnv, FjObject);
end;

procedure jPanel.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;

procedure jPanel.SetBackgroundAlpha(_alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPanel_SetBackgroundAlpha(FjEnv, FjObject, _alpha);
end;

procedure jPanel.SetMarginLeftTopRightBottom(_left,_top,_right,_bottom: integer);
begin
  FMarginTop:= _left;
  FMarginLeft:= _top;
  FMarginRight:= _right;
  FMarginBottom:= _bottom;
  if FInitialized then
      jPanel_SetMarginLeftTopRightBottom(FjEnv, FjObject ,
                                          _left,_top,_right,_bottom);
end;

end.
