//------------------------------------------------------------------------------
//
//   Native Android Controls for Pascal
//
//   Compiler   Free Pascal Compiler FPC 2.7.1, ( XE5 in near future )
//
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
  And_lib_Unzip, And_bitmap_h,
  AndroidWidget;

type

  //by jmpessoa
  TSqliteFieldType = (ftNull,ftInteger,ftFloat,ftString,ftBlob);
  TWidgetItem = (wgNone,wgCheckBox,wgRadioButton,wgButton,wgTextView);

  jCanvas = class;

  TOnDraw  = Procedure(Sender: TObject; Canvas: jCanvas) of object;

  jPanel = class;



 jPanel = class(jVisualControl)
   private
     FjRLayout: jObject; // Java : Self Layout
     Procedure SetColor(Value : TARGBColorBridge); //background
     procedure UpdateLParamHeight;
     procedure UpdateLParamWidth;

   protected
     function GetWidth: integer;  override;
     function GetHeight: integer; override;
     procedure SetjParent(Value: jObject);
     Procedure SetVisible  (Value : Boolean);

   public
     constructor Create(AOwner: TComponent); override;
     Destructor  Destroy; override;
     Procedure Refresh;
     Procedure UpdateLayout; override;
     procedure Init(refApp: jApp);  override;

     procedure ResetAllRules;

     // Property
     property View: jObject read FjRLayout write FjRLayout;
   published
     property BackgroundColor     : TARGBColorBridge read FColor write SetColor;
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
   procedure Init(refApp: jApp) override;
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
   procedure Init(refApp: jApp) override;
   procedure TakePhoto;
   // Property
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

    Procedure SetEnabled(Value: boolean);
    Procedure SetInterval(Value: integer);
    //Procedure SetOnTimer(Value: TOnNotify);
  protected
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
    FWidth  : integer; //Cardinal;  //uint32_t;; //
    FHeight : integer; //Cardinal; ////uint32_t;
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
    procedure Init(refApp: jApp) override;

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

    //property  JavaObj : jObject   read FjObject;
    property ImageName: string read FImageName write SetImageName;
  published
    property FilePath: TFilePath read FFilePath write FFilePath;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
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
    procedure Init(refApp: jApp) override;
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
    procedure Init(refApp: jApp) override;
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
    procedure Init(refApp: jApp) override;
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
    function  GetCursor: jObject; overload;
  published
    property Cursor    : jSqliteCursor read FjSqliteCursor write SetjSqliteCursor;
    property ColDelimiter: char read FColDelimiter write FColDelimiter;
    property RowDelimiter: char read FRowDelimiter write FRowDelimiter;
    property DataBaseName: string read FDataBaseName write FDataBaseName;
    property CreateTableQuery: TStrings read FCreateTableQuery write FCreateTableQuery;
    property TableName: TStrings read FTableName write FTableName;
  end;

  //http://startandroid.ru/en/lessons/complete-list/
  //http://startandroid.ru/en/lessons/complete-list/224-lesson-18-changing-layoutparams-in-a-running-application.html
  //http://stackoverflow.com/questions/13557387/align-radiobuttons-with-text-at-right-and-button-at-left-programmatically?rq=1

  jTextView = class(jVisualControl)
  private
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Procedure SetEnabled  (Value : Boolean);
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Procedure SetTextAlignment(Value: TTextAlignment);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    Procedure SetText(Value: string ); override;
    Function  GetText: string;
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
  published
    property Alignment : TTextAlignment read FTextAlignment write SetTextAlignment;
    property Enabled   : Boolean read FEnabled   write SetEnabled;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property FontSize  : DWord   read FFontSize  write SetFontSize;
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

    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    Procedure SetHint     (Value : String );

    Procedure SetInputTypeEx(Value : TInputTypeEx);
    Procedure SetLineMaxLength(Value     : DWord     );
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
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnEnter (Obj: TObject);
    Procedure GenEvent_OnChange(Obj: TObject; EventType : Integer);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;

    procedure SetMovementMethod;
    procedure SetScrollBarFadingEnabled(Value: boolean);
    //
    Procedure SetFocus;
    Procedure immShow;
    Procedure immHide;
    Procedure UpdateLayout; override;
    // Property
    property CursorPos : TXY        read GetCursorPos  write SetCursorPos;
    //property Scroller: boolean  read FScroller write SetScroller;
  published
    property Alignment: TTextAlignment read FTextAlignment write SetTextAlignment;
    property InputTypeEx : TInputTypeEx read FInputTypeEx write SetInputTypeEx;
    property LineMaxLength : DWord read FLineMaxLength write SetLineMaxLength;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
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
    property OnEnter: TOnNotify  read FOnEnter write FOnEnter;
    property OnChange: TOnChange  read FOnChange write FOnChange;
  end;

  jButton = class(jVisualControl)
  private
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    Function  GetText            : string;
    Procedure SetText     (Value   : string );
    Procedure SetFontColor(Value : TARGBColorBridge);
    Procedure SetFontSize (Value : DWord  );
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout; override;

    //property jParent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    //property Text      : string    read GetText    write SetText;
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout; override;

    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    //property Text      : string    read GetText    write SetText;
    property Checked   : boolean   read GetChecked write SetChecked;
    // Event
    property OnClick   : TOnNotify read FOnClick   write FOnClick;
  end;

  jRadioButton = class(jVisualControl)
  private
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

  protected
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    Procedure UpdateLayout; override;

    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible   : boolean   read FVisible   write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor     write SetColor;
    property FontColor : TARGBColorBridge read FFontColor write SetFontColor;
    property FontSize  : DWord     read FFontSize  write SetFontSize;
    //property Text      : string    read GetText    write SetText;
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp); override;
    procedure Stop;
    procedure Start;
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property Style     : TProgressBarStyle read FStyle write SetStyle;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
    property Progress  : integer read GetProgress write SetProgress;
    property Max       : integer read GetMax write SetMax;
    //property Visible   : Boolean read FVisible    write SetVisible;
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

    procedure SetImages(Value: jImageList);   //by jmpessoa
    function GetCount: integer;
    procedure SetImageName(Value: string);
    procedure SetImageIndex(Value: integer);
    function  GetImageName       : string;
    function  GetImageIndex      : integer;
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
    function GetHeight: integer;
    function GetWidth: integer;
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;

      //by jmpessoa
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp); override;
    Procedure SetImageByName(Value : string);
    Procedure SetImageByIndex(Value : integer);
    procedure SetImageBitmap(bitmap: jObject);
    // Property
    //property Width: integer Read GetWidth;
    //property Height: integer Read GetHeight;

    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property Count: integer read GetCount;
    property ImageName : string read GetImageName write SetImageName;
  published
    property ImageIndex: integer read GetImageIndex write SetImageIndex;
    property Images    : jImageList read FImageList write SetImages;     //by jmpessoa
    //property Visible   : Boolean   read FVisible     write SetVisible;
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
    FOnClickCaptionItem: TOnClickCaptionItem;

    FItems        : TStrings;
    FWidgetItem   : TWidgetItem;
    FWidgetText   : string;
    FDelimiter    : string;
    FImageItem    : jBitmap;
    FTextDecorated: TTextDecorated;
    FTextSizeDecorated: TTextSizeDecorated;
    FItemLayout   : TItemLayout;
    FTextAlign     : TTextAlign;

    FHighLightSelectedItem: boolean;
    FHighLightSelectedItemColor: TARGBColorBridge;

    procedure SetHighLightSelectedItem(_value: boolean);
    procedure SetHighLightSelectedItemColor(_color: TARGBColorBridge);

    Procedure SetVisible      (Value : Boolean);
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
  protected
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject; Value: integer);
    procedure GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
    procedure GenEvent_OnClickCaptionItem(Obj: TObject; index: integer; caption: string);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure Init(refApp: jApp);  override;
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
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java: Parent Relative Layout
    property View      : jObject   read FjRLayout  write FjRLayout; //self View
    property setItemIndex: TXY write SetItemPosition;
    property Count: integer read GetCount;
  published
    property Items: TStrings read FItems write SetItems;
    //property Visible: Boolean   read FVisible   write SetVisible;
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
    property OnClickCaptionItem: TOnClickCaptionItem read FOnClickCaptionItem write FOnClickCaptionItem;

    property HighLightSelectedItem: boolean read FHighLightSelectedItem write SetHighLightSelectedItem;
    property HighLightSelectedItemColor: TARGBColorBridge read FHighLightSelectedItemColor write SetHighLightSelectedItemColor;

  end;

  jScrollView = class(jVisualControl)
  private
    FjRLayout    : jObject; // Java : Self Layout
    FScrollSize : integer;
    Procedure SetVisible    (Value : Boolean);
    Procedure SetColor      (Value : TARGBColorBridge);
    Procedure SetScrollSize (Value : integer);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp);  override;
    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View      : jObject read FjRLayout   write FjRLayout;
  published
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    //property Visible   : Boolean read FVisible    write SetVisible;
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp);  override;
    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
    property View      : jObject read FjRLayout   write FjRLayout;
  published
    property ScrollSize: integer read FScrollSize write SetScrollSize;
    //property Visible   : Boolean read FVisible    write SetVisible;
    property BackgroundColor     : TARGBColorBridge read FColor      write SetColor;
  end;

  // ------------------------------------------------------------------
  jViewFlipper = class(jVisualControl)
  private
    //FOnClick  : TOnNotify;
    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp);  override;
    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible   : Boolean read FVisible   write SetVisible;
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    Procedure Refresh;
    Procedure UpdateLayout; override;

    Procedure Navigate(url: string);
    //Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    property JavaScript: Boolean          read FJavaScript write SetJavaScript;
    //property Visible   : Boolean          read FVisible    write SetVisible;
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
    FFilePath    : TFilePath;

    Procedure SetVisible  (Value : Boolean);
    Procedure SetColor    (Value : TARGBColorBridge);
    procedure SetjCanvas(Value: jCanvas);
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
    function GetWidth: integer;  override;
    function GetHeight: integer; override;
    Procedure GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: single);
    Procedure GenEvent_OnDraw (Obj: TObject; jCanvas: jObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp); override;
    Procedure SaveToFile(fileName:String);
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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  protected
    procedure SetjParent(Value: jObject);
    Procedure GenEvent_OnClick(Obj: TObject);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor  Destroy; override;
    Procedure Refresh;
    Procedure UpdateLayout; override;
    procedure Init(refApp: jApp); override;
    // Property
    //property Parent: jObject  read  FjPRLayout write SetParent; // Java : Parent Relative Layout
  published
    //property Visible : Boolean   read FVisible   write SetVisible;
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

    procedure Init(refApp: jApp); override;
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
    procedure Init(refApp: jApp); override;
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
  //by jmpessoa: support to Option Menu
  procedure Java_Event_pAppOnCreateOptionsMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);
  Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                 itemID: integer; itemCaption: JString; checked: boolean);
  //by jmpessoa: support to Context Menu
  Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: boolean);
  procedure Java_Event_pAppOnCreateContextMenu(env: PJNIEnv; this: jobject; jObjMenu: jObject);

  // Control Event
  Procedure Java_Event_pOnDraw                   (env: PJNIEnv; this: jobject; Obj: TObject; jCanvas: jObject);


  Procedure Java_Event_pOnClick                  (env: PJNIEnv; this: jobject; Obj: TObject; Value: integer);

  //by jmpessoa
  Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);
  Procedure Java_Event_pOnClickCaptionItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; caption: JString);


  Procedure Java_Event_pOnChange                 (env: PJNIEnv; this: jobject; Obj: TObject; EventType : integer);
  Procedure Java_Event_pOnEnter                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTimer                  (env: PJNIEnv; this: jobject; Obj: TObject);
  Procedure Java_Event_pOnTouch                  (env: PJNIEnv; this: jobject; Obj: TObject;act,cnt: integer; x1,y1,x2,y2: single);

  // Control GLSurfaceView.Renderer Event
  Procedure Java_Event_pOnGLRenderer             (env: PJNIEnv;  this: jobject; Obj: TObject; EventType, w, h: integer);

  // WebView Event
  Function  Java_Event_pOnWebViewStatus          (env: PJNIEnv; this: jobject; WebView : TObject; EventType : integer; URL : jString) : Integer;

  // AsyncTask Event & Task
  Procedure Java_Event_pOnAsyncEvent             (env: PJNIEnv; this: jobject; Obj : TObject; EventType,Progress : integer);

  procedure Java_Event_pAppOnViewClick(env: PJNIEnv; this: jobject; jObjView: jObject; id: integer);
  procedure Java_Event_pAppOnListItemClick(env: PJNIEnv; this: jobject;jObjAdapterView: jObject; jObjView: jObject; position: integer; id: integer);

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
  rstRotate : Integer;
begin

  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;

  rstRotate:= 0; //rotate; //just initialize [var] param...

  Result := rotate;

  Form := gApp.Forms.Stack[gApp.TopIndex].Form;

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
  Form:= gApp.Forms.Stack[gApp.TopIndex].Form;
  if not Assigned(Form) then Exit;
  Form.UpdateJNI(gApp);
  if Assigned(Form.OnActivityRst) then Form.OnActivityRst(Form,requestCode,resultCode,jData);
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

//by jmpessoa: support to Option Menu
Procedure Java_Event_pAppOnClickOptionMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: boolean);
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

  if Assigned(Form.OnClickOptionMenuItem) then Form.OnClickOptionMenuItem(Form,jObjMenuItem,itemID,pasStr,checked);
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

//by jmpessoa: support to Context Menu
Procedure Java_Event_pAppOnClickContextMenuItem(env: PJNIEnv; this: jobject; jObjMenuItem: jObject;
                                                itemID: integer; itemCaption: JString; checked: boolean);
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

  if Assigned(Form.OnClickContextMenuItem) then Form.OnClickContextMenuItem(Form,jObjMenuItem,itemID,pasStr,checked);
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
    jImageView(Obj).GenEvent_OnClick(Obj);  Exit;
  end;
end;

Procedure Java_Event_pOnClickWidgetItem(env: PJNIEnv; this: jobject; Obj: TObject;index: integer; checked: boolean);
begin
  gApp.Jni.jEnv:= env;
  gApp.Jni.jThis:= this;
  if Obj is jListView then
  begin
    jForm(jListVIew(Obj).Owner).UpdateJNI(gApp);
    jListVIew(Obj).GenEvent_OnClickWidgetItem(Obj, index, checked); Exit;
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

Procedure Java_Event_pOnChange(env: PJNIEnv; this: jobject;
                               Obj: TObject; EventType : integer);
begin {0:beforeTextChanged ; 1:onTextChanged ; 2: afterTextChanged}
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


//------------------------------------------------------------------------------
// jTextView
//------------------------------------------------------------------------------

constructor jTextView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextAlignment:= taLeft;
  FText:= '';
  //FFontColor:= colbrDefault; //colbrSilver;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FLParamWidth  := lpWrapContent;
  FLParamHeight := lpWrapContent;
  FEnabled:= True;
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
        if FjObject  <> nil then
        begin
          jTextView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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
  FjObject := jTextView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView(FParent).View;
  end;

  jTextView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);

  jTextView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
         {
  if FLParamWidth = lpDesigner then FLParamWidth:= GetLayoutParamsName(FOrdLParamWidth);
  if FLParamHeight = lpDesigner then FLParamHeight:= GetLayoutParamsName(FOrdLParamHeight);
          }
  jTextView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  (* TODO
  for gvt := gvBottom  to gvFillVertical do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addGravity(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetGravity(gvt));
    end;
  end;
  *)

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTextView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jTextView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jTextView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  jTextView_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);

  if  FFontColor <> colbrDefault then
     jTextView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

  if FFontSize > 0 then
     jTextView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

  jTextView_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Ord(FTextAlignment));

  if  FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jTextView_setEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FEnabled);

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

Procedure jTextView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jTextView_setParent3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jTextView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jTextView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jTextView.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
  if FInitialized then
    jTextView_setEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FEnabled);
end;

Function jTextView.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jTextView_getText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jTextView.SetText(Value: string);
begin
  inherited SetText(Value);
  if FInitialized then
    jTextView_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

Procedure jTextView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
    jTextView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));
end;

Procedure jTextView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and  (FFontSize > 0) then
    jTextView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);
end;

{
procedure jTextView.UpdateLParamWidth;
var
   side: TSide;
begin
   if jForm(Owner).Orientation = jForm(Owner).App.Orientation then
      side:= sdW
   else
      side:= sdH;

   if FInitialized then
      jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jTextView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jTextView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jTextView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jTextView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jTextView.UpdateLayout;
begin
  if FInitialized then
  begin
   inherited UpdateLayout;
   UpdateLParamWidth;
   UpdateLParamHeight;
   jTextView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

// LORDMAN 2013-08-12
Procedure jTextView.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
    jTextView_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Ord(FTextAlignment));
end;

Procedure jTextView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
  FText      :='';
  FColor     := colbrDefault; //colbrWhite;
  FOnEnter   := nil;
  FOnChange  := nil;
  FInputTypeEx := itxText;
  FHint      := '';
  FLineMaxLength := 300;
  FSingleLine:= True;
  FMaxLines:= 1;

  FScrollBarStyle:= scrNone;
  FVerticalScrollBar:= False;
  FHorizontalScrollBar:= True;

  FWrappingLine:= False;

  FMarginBottom := 10;
  FMarginLeft   := 5;
  FMarginRight  := 5;
  FMarginTop    := 10;

  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;

end;

Destructor jEditText.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jEditText_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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

  FjObject := jEditText_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView(FParent).View;
  end;

  jEditText_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);

  jEditText_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jEditText_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jEditText_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jEditText_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jEditText_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  if  FHint <> '' then
    jEditText_setHint(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FHint);

  if FFontColor <> colbrDefault then
    jEditText_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

  if FFontSize > 0 then
    jEditText_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

  jEditText_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Ord(FTextAlignment));

  jEditText_maxLength(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FLineMaxLength);

  jEditText_setScroller2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );

  jEditText_setHorizontalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FHorizontalScrollBar);
  jEditText_setVerticalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVerticalScrollBar);

  (*
  if FInputTypeEx <> itxMultiLine then FInputTypeEx:= itxMultiLine; //hard code to by pass a BUG!

  jEditText_editInputType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , InputTypeToStrEx(FInputTypeEx));

  if FInputTypeEx = itxMultiLine then
  begin
    jEditText_setSingleLine(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , False);
    jEditText_setMaxLines(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FMaxLines);
    jEditText_setHorizontallyScrolling(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FWrappingLine);
    if (FVerticalScrollBar = True) or  (FHorizontalScrollBar = True) then
    begin
      jEditText_setScrollbarFadingEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , False);
      jEditText_setMovementMethod(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
      if FScrollBarStyle <> scrNone then
         jEditText_setScrollBarStyle(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetScrollBarStyle(FScrollBarStyle));
    end;
  end;
   *)

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor))
  else  jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(colbrWhite));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

  if  FText <> '' then
    jEditText_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);

end;

Procedure jEditText.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jEditText_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jEditText.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jEditText.setColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jEditText.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

function jEditText.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jEditText_getText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jEditText.SetText(Value: string);
begin
  //FText:= Value;
  inherited SetText(Value);
  if FInitialized then
     jEditText_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jEditText_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));
end;

Procedure jEditText.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jEditText_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);
end;

Procedure jEditText.SetHint(Value : String);
begin
  FHint:= Value;
  if FInitialized then
     jEditText_setHint2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FHint);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetFocus;
begin
  if FInitialized then
     jEditText_SetFocus2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject  );
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
     jEditText_immShow2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject  );
end;

// LORDMAN - 2013-07-26
Procedure jEditText.immHide;
begin
  if FInitialized then
      jEditText_immHide2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject  );
end;

//by jmpessoa
Procedure jEditText.SetInputTypeEx(Value : TInputTypeEx);
begin
  FInputTypeEx:= Value;
  if FInitialized then
     jEditText_editInputType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,InputTypeToStrEx(FInputTypeEx));
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetLineMaxLength(Value: DWord);
begin
  FLineMaxLength:= Value;
  if FInitialized then
     jEditText_maxLength(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

//by jmpessoa
Procedure jEditText.SetMaxLines(Value: DWord);
begin
  FMaxLines:= Value;
  if FInitialized then
     jEditText_setMaxLines(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetSingleLine(Value: boolean);
begin
  FSingleLine:= Value;
  if FInitialized then
     jEditText_setSingleLine(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetScrollBarStyle(Value: TScrollBarStyle);
begin
  FScrollBarStyle:= Value;
  if FInitialized then
  begin
    if Value <> scrNone then
    begin
       jEditText_setScrollBarStyle(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetScrollBarStyle(Value));
    end;
  end;
end;

procedure jEditText.SetHorizontalScrollBar(Value: boolean);
begin
  FHorizontalScrollBar:= Value;
  if FInitialized then
    jEditText_setHorizontalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetVerticalScrollBar(Value: boolean);
begin
  FVerticalScrollBar:= Value;
  if FInitialized then
    jEditText_setVerticalScrollBarEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetScrollBarFadingEnabled(Value: boolean);
begin
  if FInitialized then
    jEditText_setScrollbarFadingEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;

procedure jEditText.SetMovementMethod;
begin
  if FInitialized then ;
    jEditText_setMovementMethod(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

// LORDMAN - 2013-07-26
Function jEditText.GetCursorPos: TXY;
begin
  Result.x := 0;
  Result.y := 0;
  if FInitialized then
     jEditText_GetCursorPos2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,Result.x,Result.y);
end;

// LORDMAN - 2013-07-26
Procedure jEditText.SetCursorPos(Value: TXY);
begin
  if FInitialized then
     jEditText_SetCursorPos2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value.X,Value.Y);
end;

// LORDMAN 2013-08-12
Procedure jEditText.setTextAlignment(Value: TTextAlignment);
begin
  FTextAlignment:= Value;
  if FInitialized then
     jEditText_setTextAlignment(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Ord(FTextAlignment));
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

{
procedure jEditText.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
    jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jEditText.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  if FInitialized then
     jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jEditText.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jEditText_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jEditText_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jEditText.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jEditText_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

//------------------------------------------------------------------------------
// jButton
//------------------------------------------------------------------------------
constructor jButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FText:= '';
  FMarginLeft   := 2;
  FMarginTop    := 4;
  FMarginBottom := 4;
  FMarginRight  := 2;
  FLParamWidth  := lpHalfOfParent;
  FLParamHeight := lpWrapContent;
end;

destructor jButton.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if jForm(Owner).App <> nil then
     begin
       if jForm(Owner).App.Initialized then
       begin
         if FjObject  <> nil then
         begin
           jButton_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
           FjObject := nil;
         end;
       end;
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

  FjObject := jButton_Create2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,Self);

  if FParent is jPanel then
  begin
     jPanel(FParent).Init(refApp);
     FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
     jScrollView(FParent).Init(refApp);
     FjPRLayout:= jScrollView(FParent).View;
  end;

  jButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);

  jButton_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jButton_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                            FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                            GetLayoutParams(gApp, FLParamWidth, sdW),
                                            GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
       jButton_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jButton_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jButton_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  jButton_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);

  if FFontColor <> colbrDefault then
     jButton_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

  if FFontSize > 0 then //not default...
     jButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

Procedure jButton.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jButton_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jButton.Refresh;
begin
  if not FInitialized then Exit;
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Function jButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jButton_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
    jButton_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);
end;

Procedure jButton.SetFontColor(Value : TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jButton_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));
end;

Procedure jButton.SetFontSize (Value : DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);
end;

procedure jButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jButton.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jButton_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
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
  FText      := '';
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FFontColor    := colbrDefault;
  FLParamWidth:= lpWrapContent;
  FLParamHeight:= lpWrapContent;
end;

destructor jCheckBox.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jCheckBox_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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

  FjObject  := jCheckBox_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, self);
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView(FParent).View;
  end;

  jCheckBox_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jCheckBox_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jCheckBox_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCheckBox_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jCheckBox_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= 0;

  jCheckBox_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jCheckBox_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);

  if FFontColor <> colbrDefault then
     jCheckBox_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

  if FFontSize > 0 then
     jCheckBox_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

Procedure jCheckBox.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jCheckBox_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jCheckBox.SetVisible(Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jCheckBox.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jCheckBox.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Function jCheckBox.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jCheckBox_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jCheckBox.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jCheckBox_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);
end;

Procedure jCheckBox.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jCheckBox_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));
end;

Procedure jCheckBox.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jCheckBox_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);
end;

Function jCheckBox.GetChecked: boolean;
begin
  Result := FChecked;
  if FInitialized then
     Result:= jCheckBox_isChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jCheckBox.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jCheckBox_setChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FChecked);
end;

{
procedure jCheckBox.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  if FInitialized then
     jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jCheckBox.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
    jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jCheckBox.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jCheckBox_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jCheckBox_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jCheckBox.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jCheckBox_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
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
  FText      := '';
  FChecked   := False;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FFontColor    := colbrDefault;
  FLParamWidth:= lpWrapContent;
  FLParamHeight:= lpWrapContent;
end;

destructor jRadioButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jRadioButton_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jRadioButton.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jRadioButton_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView(FParent).View;
  end;

  jRadioButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jRadioButton_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jRadioButton_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jRadioButton_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jRadioButton_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jRadioButton_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jRadioButton_setText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);

  if FFontColor <> colbrDefault then
     jRadioButton_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

  if FFontSize > 0 then
     jRadioButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

  jRadioButton_setChecked(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FChecked);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

Procedure jRadioButton.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jRadioButton_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jRadioButton.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jRadioButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jRadioButton.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Function jRadioButton.GetText: string;
begin
  Result:= FText;
  if FInitialized then
     Result:= jRadioButton_getText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jRadioButton.SetText(Value: string);
begin
  FText:= Value;
  if FInitialized then
     jRadioButton_setText2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FText);
end;

Procedure jRadioButton.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jRadioButton_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));
end;

Procedure jRadioButton.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  if FInitialized and (FFontSize > 0) then
     jRadioButton_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);
end;

Function jRadioButton.GetChecked: boolean;
begin
  Result:= FChecked;
  if FInitialized then
     Result:= jRadioButton_isChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jRadioButton.SetChecked(Value: boolean);
begin
  FChecked:= Value;
  if FInitialized then
     jRadioButton_setChecked2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FChecked);
end;
{
procedure jRadioButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
     jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jRadioButton.UpdateLParamHeight;
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jRadioButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jRadioButton_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jRadioButton_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jRadioButton.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jRadioButton_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
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
  FEnabled:= False;

  FLParamWidth  := lpMatchParent;
  FLParamHeight := lpWrapContent;

end;

Destructor jProgressBar.Destroy;
begin
   if not (csDesigning in ComponentState) then
   begin
     if jForm(Owner).App <> nil then
     begin
       if jForm(Owner).App.Initialized then
       begin
         if FjObject  <> nil then
         begin
           jProgressBar_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
           FjObject := nil;
         end;
       end;
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
  FjObject := jProgressBar_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, GetProgressBarStyle(FStyle));
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jProgressBar_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jProgressBar_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jProgressBar_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jProgressBar_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jProgressBar_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jProgressBar_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jProgressBar_setProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FProgress);
  jProgressBar_setMax(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FMax);  //by jmpessoa

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
  FInitialized:= True;
end;

Procedure jProgressBar.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jProgressBar_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
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
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jProgressBar.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jProgressBar.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Function jProgressBar.GetProgress: integer;
begin
  Result:= FProgress;
  if FInitialized then
     Result:= jProgressBar_getProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jProgressBar.SetProgress(Value: integer);
begin
  if Value >= 0 then FProgress:= Value
  else FProgress:= 0;
  if FInitialized then
     jProgressBar_setProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FProgress);
end;

//by jmpessoa
Procedure jProgressBar.SetMax(Value: integer);
begin
  if Value > FProgress  then FMax:= Value;
  if FInitialized then
     jProgressBar_setMax2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FMax);
end;

//by jmpessoa
Function jProgressBar.GetMax: integer;
begin
  Result:= FMax;
  if FInitialized then
     Result:= jProgressBar_getMax2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

{
procedure jProgressBar.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
     jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jProgressBar.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}
procedure jProgressBar.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
        jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jProgressBar_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jProgressBar_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jProgressBar.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jProgressBar_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
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
         if FjObject  <> nil then
         begin
           jImageView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
           FjObject := nil;
         end;
       end;
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
  FjObject := jImageView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end;
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView(FParent).View;
  end;

  jImageView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FjPRLayout);
  jImageView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jImageView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  if FColor <> colbrDefault then
      jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  if FImageList <> nil then
  begin
    FImageList.Init(refApp);
    if FImageList.Images.Count > 0 then
    begin
       if FImageIndex >=0 then SetImageByIndex(FImageIndex);
    end;
  end;

  jImageView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

procedure jImageView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jImageView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FjPRLayout);
end;

Procedure jImageView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jImageView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
      jImageView_setImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
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
        jImageView_setImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
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
     jImageView_setBitmapImage2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , bitmap);
end;

{
procedure jImageView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
     jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jImageView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
    jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jImageView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jImageView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jImageView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

function jImageView.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
   Result:= jImageView_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject )
end;

function jImageView.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
    Result:= jImageView_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jImageView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jImageView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
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

procedure jImageList.Init(refApp: jApp);
var
  i: integer;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
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

procedure jHttpClient.Init(refApp: jApp);
begin
 if FInitialized  then Exit;
 inherited Init(refApp);
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
  FFontColor:= colbrDefault; //colbrRed;
  FWidgetItem:= wgNone;

  FDelimiter:= '|';

  FTextDecorated:= txtNormal;
  FItemLayout:= layImageTextWidget;
  FTextSizeDecorated:= sdNone;
  FTextAlign:= alLeft;

  FItems:= TStringList.Create;
  TStringList(FItems).OnChange:= ListViewChange;  //event handle

  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;

  FHighLightSelectedItem:= True;
  FHighLightSelectedItemColor:= colbrRed;

end;

destructor jListView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jListView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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

  //if Self.Items.Count = 0 then Self.Items.Add('------Select------');  Items//FWidgetItem:= wgNone;

  if FImageItem <> nil then
  begin
     FImageItem.Init(refApp);
     FjObject := jListView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
                               Ord(FWidgetItem), FWidgetText, FImageItem.GetJavaBitmap,
                               Ord(FTextDecorated),Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));
    if FFontColor <> colbrDefault then
       jListView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

    if FFontSize > 0 then
       jListView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

    if FColor <> colbrDefault then
       jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

     for i:= 0 to Self.Items.Count-1 do
     begin
       FImageItem.ImageIndex:= i;
       jListView_add22(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Items.Strings[i], FDelimiter, FImageItem.GetJavaBitmap);
     end;
  end
  else
  begin
     FjObject := jListView_Create3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
                               Ord(FWidgetItem), FWidgetText,
                               Ord(FTextDecorated),Ord(FItemLayout), Ord(FTextSizeDecorated), Ord(FTextAlign));
     if FFontColor <> colbrDefault then
        jListView_setTextColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor));

     if FFontSize > 0 then
        jListView_setTextSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize);

     if FColor <> colbrDefault then
        jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

     for i:= 0 to Self.Items.Count-1 do
        jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Items.Strings[i], FDelimiter);
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jListView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jListView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jListView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jListView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jListView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jListView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

  Self.SetHighLightSelectedItem(FHighLightSelectedItem);
  Self.SetHighLightSelectedItemColor(FHighLightSelectedItemColor);

end;

procedure jListView.SetWidget(Value: TWidgetItem);
begin
  FWidgetItem:= Value;
  //if FInitialized then
  //jListView_setHasWidgetItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(FHasWidgetItem));
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(Value), index);
end;

procedure jListView.SetWidgetByIndex(Value: TWidgetItem; txt: string; index: integer);
begin
    if FInitialized then
     jListView_setWidgetItem3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(Value), txt, index);
end;

procedure jListView.SetWidgetTextByIndex(txt: string; index: integer);
begin
   if FInitialized then
      jListView_setWidgetText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject ,txt,index);
end;

procedure jListView.SetTextDecoratedByIndex(Value: TTextDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextDecorated(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(Value), index);
end;

procedure jListView.SetTextSizeDecoratedByIndex(value: TTextSizeDecorated; index: integer);
begin
  if FInitialized then
   jListView_setTextSizeDecorated(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Ord(value), index);
end;

procedure jListView.SetLayoutByIndex(Value: TItemLayout; index: integer);
begin
  if FInitialized then
   jListView_setItemLayout(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(Value), index);
end;

procedure jListView.SetImageByIndex(Value: jObject; index: integer);
begin
  //FHasWidgetItem:= Value;
  if FInitialized then
     jListView_SetImageItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value, index);
end;

procedure jListView.SetTextAlignByIndex(Value: TTextAlign; index: integer);
begin
  if FInitialized then
    jListView_setTextAlign(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , ord(Value), index);
end;


function jListView.IsItemChecked(index: integer): boolean;
begin
  if FInitialized then
    Result:= jListView_IsItemChecked(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , index);
end;

procedure jListView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jListView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jListView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jListView.SetColor (Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jListView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jListView.SetFontColor(Value: TARGBColorBridge);
begin
  FFontColor:= Value;
  //if (FInitialized = True) and (FFontColor <> colbrDefault ) then
    // jListView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FFontColor), index);
end;

Procedure jListView.SetFontColorByIndex(Value: TARGBColorBridge; index: integer);
begin
  //FFontColor:= Value;
  if FInitialized  and (Value <> colbrDefault) then
     jListView_setTextColor2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(Value), index);
end;

Procedure jListView.SetFontSize(Value: DWord);
begin
  FFontSize:= Value;
  //if FInitialized and (FFontSize > 0) then
   //  jListView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FFontSize, index);
end;

Procedure jListView.SetFontSizeByIndex(Value: DWord; index: integer);
begin
  //FFontSize:= Value;
  if FInitialized and (Value > 0) then
     jListView_setTextSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value, index);
end;

// LORDMAN 2013-08-07
Procedure jListView.SetItemPosition(Value: TXY);
begin
  if FInitialized then
     jListView_setItemPosition2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value.X, Value.Y);
end;

//
Procedure jListView.Add(item: string; delim: string);
begin
  if FInitialized then
  begin
     if delim = '' then delim:= '+';
     if item = '' then item:= 'item_dummy';
     jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , item,delim);
     Self.Items.Add(item);
  end;
end;

Procedure jListView.Add(item: string);
begin
  if FInitialized then
  begin
     if item = '' then item:= 'item_dummy';
     jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , item,'+');
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
     jListView_add3(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , item,
     delim, GetARGB(fColor), fSize, Ord(hasWidget), widgetText, image);
     Self.Items.Add(item);
  end;
end;

function jListView.GetText(index: Integer): string;
begin
  if FInitialized then
    Result:= jListView_GetItemText(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , index);
end;

function jListView.GetCount: integer;
begin
  Result:= Self.Items.Count;
  if FInitialized then
    Result:= jListView_GetCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

//
Procedure jListView.Delete(index: Integer);
begin
  if FInitialized then
  begin
     if (index >= 0) and (index < Self.Items.Count) then    //bug fix 27-april-2014
     begin
       jListView_delete2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , index);
       Self.Items.Delete(index);
     end;
  end;
end;

//
Procedure jListView.Clear;
begin
  if FInitialized then
  begin
    jListView_clear2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
    jListView_clear2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
    for i:= 0 to FItems.Count - 1 do
    begin
       jListView_add2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FItems.Strings[i],
                                    FDelimiter, GetARGB(FFontColor), FFontSize, FWidgetText, Ord(FWidgetItem));
    end;
  end; }
end;

{
procedure jListView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  if FInitialized then
    jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jListView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
    jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jListView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jListView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jListView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jListView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jListView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
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
Procedure jListView.GenEvent_OnClick(Obj: TObject; Value: integer);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Obj,Value);
end;

//by jmpessoa
procedure jListView.GenEvent_OnClickWidgetItem(Obj: TObject; index: integer; checked: boolean);
begin
  if Assigned(FOnClickWidgetItem) then FOnClickWidgetItem(Obj,index,checked);
end;

procedure jListView.GenEvent_OnClickCaptionItem(Obj: TObject; index: integer; caption: string);
begin
  if Assigned(FOnClickCaptionItem) then FOnClickCaptionItem(Obj,index,caption);
end;

procedure jListView.SetHighLightSelectedItem(_value: boolean);
begin
  //in designing component state: set value here...
  FHighLightSelectedItem:= _value;
  if FInitialized then
     jListView_SetHighLightSelectedItem(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _value);
end;

procedure jListView.SetHighLightSelectedItemColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHighLightSelectedItemColor:= _color;
  if FInitialized then
     jListView_SetHighLightSelectedItemColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(_color));
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
  //FAcceptChildsAtDesignTime:= True;
  FAcceptChildrenAtDesignTime:= True;
end;

Destructor jScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jScrollView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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

  FjObject := jScrollView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FjRLayout:= jScrollView_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ); // Java : Self Layout
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jScrollView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jScrollView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jScrollView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jScrollView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jScrollView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  jScrollView_setScrollSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FScrollSize);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
  FInitialized:= True;
end;

procedure jScrollView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jScrollView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jScrollView.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jScrollView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize:= Value;
  if FInitialized then
     jScrollView_setScrollSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FScrollSize);
end;

{
procedure jScrollView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
     jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jScrollView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jScrollView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jScrollView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jScrollView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
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

  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;

 end;

Destructor jHorizontalScrollView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jHorizontalScrollView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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
  FjObject  := jHorizontalScrollView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FjRLayout:= jHorizontalScrollView_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ); //self layout!
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jHorizontalScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jHorizontalScrollView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jHorizontalScrollView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jHorizontalScrollView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jHorizontalScrollView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jHorizontalScrollView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jHorizontalScrollView_setScrollSize(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FScrollSize);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
  FInitialized:= True;
end;

procedure jHorizontalScrollView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jHorizontalScrollView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jHorizontalScrollView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jHorizontalScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jHorizontalScrollView.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jHorizontalScrollView.SetScrollSize(Value: integer);
begin
  FScrollSize := Value;
  if FInitialized then
     jHorizontalScrollView_setScrollSize2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FScrollSize);
end;

{
procedure jHorizontalScrollView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;
  if FInitialized then
     jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jHorizontalScrollView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jHorizontalScrollView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jHorizontalScrollView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jHorizontalScrollView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jHorizontalScrollView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jHorizontalScrollView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

//------------------------------------------------------------------------------
// jViewFlipper
//------------------------------------------------------------------------------

Constructor jViewFlipper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
end;

Destructor jViewFlipper.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jViewFlipper_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jViewFlipper.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject  := jViewFlipper_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jViewFlipper_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jViewFlipper_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jViewFlipper_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jViewFlipper_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jViewFlipper_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jViewFlipper_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
  FInitialized:= True;
end;

procedure jViewFlipper.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jViewFlipper_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jViewFlipper.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jViewFlipper.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jViewFlipper.Refresh;
begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

{
procedure jViewFlipper.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
    jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jViewFlipper.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;
  jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jViewFlipper.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jViewFlipper_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
  end;
end;

procedure jViewFlipper.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jViewFlipper_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jViewFlipper.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jViewFlipper_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

//------------------------------------------------------------------------------
// jWebView
//------------------------------------------------------------------------------

constructor jWebView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJavaScript := False;
  FOnStatus   := nil;
  FLParamWidth:= lpMatchParent;
  FLParamHeight:= lpWrapContent;
end;

destructor jWebView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jWebView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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
  FjObject := jWebView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jWebView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jWebView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jWebView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jWebView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jWebView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jWebView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  jWebView_SetJavaScript(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FJavaScript);
  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
  FInitialized:= True;
end;

procedure jWebView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jWebView_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jWebView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jWebView.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;

Procedure jWebView.Refresh;
 begin
  if not FInitialized then Exit;
  jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
 end;

Procedure jWebView.SetJavaScript(Value : Boolean);
begin
  FJavaScript:= Value;
  if FInitialized then
     jWebView_SetJavaScript2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FJavaScript);
end;

Procedure jWebView.Navigate(url: string);
begin
  if not FInitialized then Exit;
  jWebView_loadURL2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , url);
end;

{
procedure jWebView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
     jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jWebView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
     jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jWebView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jWebView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jWebView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jWebView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jWebView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
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
  FjObject   := nil;
end;

Destructor jBitmap.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jBitmap_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jBitmap.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject  := jBitmap_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FInitialized:= True;  //neded here....
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

       jBitmap_loadFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath)+'/'+FImageName);
       //jBitmap_getWH2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,FWidth,FHeight);
       FWidth:= jBitmap_GetWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
       FHeight:= jBitmap_GetHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
    jBitmap_createBitmap2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FWidth, FHeight);
  end;
end;

Function jBitmap.GetJavaBitmap: jObject;
begin
  if FInitialized then
  begin
     Result:= jBitmap_jInstance2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis, FjObject );
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
                                    FjObject , bufferImage);
end;

procedure jBitmap.SetByteArrayToBitmap(var bufferImage: TArrayOfByte; size: integer);
begin
  if FInitialized then
    jBitmap_SetByteArrayToBitmap(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,
                                    FjObject , bufferImage, size);
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
        jBitmap_loadFile2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
        jBitmap_getWH2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , integer(FWidth),integer(FHeight));
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
     jBitmap_loadFile2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageName);
     jBitmap_getWH2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,integer(FWidth),integer(FHeight));
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
  FjObject  := nil;
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
        if FjObject  <> nil then
        begin
          jCanvas_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jCanvas.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jCanvas_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  jCanvas_setStrokeWidth2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,FPaintStrokeWidth);
  jCanvas_setStyle2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,ord(FPaintStyle));
  jCanvas_setColor2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,GetARGB(FPaintColor));
  jCanvas_setTextSize2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,FPaintTextSize);
  FInitialized:= True;
end;

Procedure jCanvas.SetStrokeWidth(Value : single );
begin
  FPaintStrokeWidth:= Value;
  if FInitialized then
     jCanvas_setStrokeWidth2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,FPaintStrokeWidth);
end;

Procedure jCanvas.SetStyle(Value : TPaintStyle{integer});
begin
  FPaintStyle:= Value;
  if FInitialized then
     jCanvas_setStyle2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,Ord(FPaintStyle));
end;

Procedure jCanvas.SetColor(Value : TARGBColorBridge);
begin
  FPaintColor:= Value;
  if FInitialized then
     jCanvas_setColor2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,GetARGB(FPaintColor));
end;

Procedure jCanvas.SetTextSize(Value: single);
begin
  FPaintTextSize:= Value;
  if FInitialized then
     jCanvas_setTextSize2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,FPaintTextSize);
end;

Procedure jCanvas.DrawLine(x1,y1,x2,y2 : single);
begin
  if FInitialized then
     jCanvas_drawLine2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,x1,y1,x2,y2);
end;

Procedure jCanvas.DrawPoint(x1,y1 : single);
begin
  if FInitialized then
     jCanvas_drawPoint2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,x1,y1);
end;

Procedure jCanvas.drawText(Text: string; x,y: single);
begin
  if FInitialized then
     jCanvas_drawText2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,text,x,y);
end;

Procedure jCanvas.drawBitmap(bmp: jObject; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,bmp, b, l, r, t);
end;

Procedure jCanvas.drawBitmap(bmp: jBitmap; b,l,r,t: integer);
begin
  if FInitialized then
     jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject ,bmp.GetJavaBitmap, b, l, r, t);
end;


Procedure jCanvas.drawBitmap(bmp: jObject; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-20);
  t1:= Round((size-20)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject , bmp, x1, y1, r1, t1);
end;


Procedure jCanvas.drawBitmap(bmp: jBitmap; x1, y1, size: integer; ratio: single);
var
  r1, t1: integer;
begin
  r1:= Round(size-10);
  t1:= Round((size-10)*(1/ratio));
  if FInitialized then
    jCanvas_drawBitmap2(jForm(Owner).App.Jni.jEnv,jForm(Owner).App.Jni.jThis,FjObject , bmp.GetJavaBitmap, x1, y1, r1, t1);
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

end;

Destructor jView.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jView_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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

  FjObject  := jView_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  FjCanvas.Init(refApp);
  jView_setjCanvas(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self.FjObject , FjCanvas.JavaObj);
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;
  jView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FjPRLayout);
  jView_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jView_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jView_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jView_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jView_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

procedure jView.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
    jView_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis,FjObject , FjPRLayout);
end;

Procedure jView.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
    jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
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
        jView_viewSave2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath)+'/'+str);
     end;
  end;
end;

Procedure jView.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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

{
procedure jView.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdW
  else
     side:= sdH;

  if FInitialized then
    jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jView.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
     side:= sdH
  else
     side:= sdW;

  if FInitialized then
    jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jView_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jView_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jView_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

function jView.GetWidth: integer;
begin
   Result:= FWidth;
   if FInitialized then
   begin
      Result:= jView_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
      Result:= jView_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
           jTimer_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
           FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jTimer.Init(refApp: jApp);
begin
  if FInitialized then Exit;
  inherited Init(refApp);
  FjObject := jTimer_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  jTimer_SetInterval(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FInterval);
  FInitialized:= True;
end;

Procedure jTimer.SetEnabled(Value: boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jTimer_SetEnabled2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FEnabled);
end;

Procedure jTimer.SetInterval(Value: integer);
begin
  FInterval:= Value;
  if FInitialized then
     jTimer_SetInterval2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FInterval);
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
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jDialogYN_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jDialogYN.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jDialogYN_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, FTitle, FMsg, FYes, FNo);
  FInitialized:= True;
end;

Procedure jDialogYN.Show;
begin
  if FInitialized then
     jDialogYN_Show2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
  FjObject  := nil;
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
        if FjObject  <> nil then
        begin
          jDialogProgress_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
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
        if FjObject  <> nil then
        begin
           jDialogProgress_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
           FjObject := nil;
        end;
      end;
    end;
end;

procedure jDialogProgress.Start;
begin
  if (FjObject  = nil) and (FInitialized = True) then
     FjObject := jDialogProgress_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self, FTitle, FMsg);
end;

procedure jDialogProgress.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
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
  FLParamHeight:= lpWrapContent;

  FFilePath := fpathData;
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
end;

Destructor jImageBtn.Destroy;
 begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jImageBtn_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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
  FjObject := jImageBtn_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;

  jImageBtn_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jImageBtn_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);
  jImageBtn_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           GetLayoutParams(gApp, FLParamWidth, sdW),
                                           GetLayoutParams(gApp, FLParamHeight, sdH));

  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageBtn_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jImageBtn_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jImageBtn_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  if FImageList <> nil then
  begin
    FImageList.Init(refApp);   //must have!
    if FImageList.Images.Count > 0 then
    begin
       if FImageDownIndex >=0 then SetImageDownByIndex(FImageDownIndex);
       if FImageUpIndex >=0 then SetImageUpByIndex(FImageUpIndex);
    end;
  end;

  jImageBtn_SetEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,FEnabled);

  if FColor <> colbrDefault then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

procedure jImageBtn.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
     jImageBtn_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jImageBtn.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
     jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
end;

Procedure jImageBtn.SetColor(Value: TARGBColorBridge);
begin
  FColor := Value;
  if (FInitialized = True) and (FColor <> colbrDefault) then
     jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetARGB(FColor));
end;
 
// LORDMAN 2013-08-16
procedure jImageBtn.SetEnabled(Value : Boolean);
begin
  FEnabled:= Value;
  if FInitialized then
     jImageBtn_SetEnabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FEnabled);
end;

procedure jImageBtn.Refresh;
begin
  if FInitialized then
     jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

Procedure jImageBtn.SetImageDownByIndex(Value: integer);
begin
   if not FInitialized then Exit;
   if (Value >= 0) and (Value < FImageList.Images.Count) then
   begin
      FImageDownName:= Trim(FImageList.Images.Strings[Value]);
      if  FImageDownName <> '' then
      begin
        jImageBtn_setButtonDown2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageDownName);
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
        jImageBtn_setButtonUp2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,GetFilePath(FFilePath){jForm(Owner).App.Path.Dat}+'/'+FImageUpName);
      end;
   end;
end;

{
procedure jImageBtn.UpdateLParamWidth;
var
   side: TSide;
begin
   if jForm(Owner).Orientation = gApp.Orientation then
      side:= sdW
   else
      side:= sdH;

  if FInitialized then
     jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jImageBtn.UpdateLParamHeight;
var
   side: TSide;
begin
   if jForm(Owner).Orientation = gApp.Orientation then
      side:= sdH
   else
      side:= sdW;

   if FInitialized then
     jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;
}

procedure jImageBtn.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jImageBtn_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jImageBtn_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jImageBtn.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jImageBtn_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
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
  // Init
  FOnAsyncEvent := nil;
  FjObject       := nil;
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
        if FjObject  <> nil then
        begin
          jAsyncTask_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

procedure jAsyncTask.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FInitialized:= True;
end;

procedure jAsyncTask.Done;
begin
  if jForm(Owner).App <> nil then
  begin
    if jForm(Owner).App.Initialized then
    begin
      if FjObject  <> nil then
      begin
        jAsyncTask_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
        FjObject := nil;
        FRunning:= False;
      end;
    end;
  end;
end;

Procedure jAsyncTask.Execute;
begin
  if (FjObject  = nil) and (FInitialized = True) and (FRunning = False) then
  begin
    FjObject := jAsyncTask_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
    jAsyncTask_SetAutoPublishProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FAutoPublishProgress);
    jAsyncTask_Execute2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
    FRunning:= True;
  end;
end;

Procedure jAsyncTask.UpdateUI(Progress : Integer);
begin
  if FInitialized then
  begin
    jAsyncTask_setProgress2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,Progress);
  end;
end;

procedure jAsyncTask.SetAutoPublishProgress(Value: boolean);
begin
  FAutoPublishProgress:= Value;
  if FInitialized then
  begin
    jAsyncTask_SetAutoPublishProgress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
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
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject  <> nil then
        begin
          jSqliteCursor_Free(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
    end;
  end;
  inherited Destroy;
end;

Procedure jSqliteCursor.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject := jSqliteCursor_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);
  FInitialized:= True;
end;

procedure jSqliteCursor.SetCursor(Value: jObject);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_SetCursor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Value);
end;


procedure jSqliteCursor.MoveToFirst;
begin
   if not FInitialized  then Exit;
   jSqliteCursor_MoveToFirst(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jSqliteCursor.MoveToNext;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToNext(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jSqliteCursor.MoveToLast;
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToLast(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jSqliteCursor.MoveToPosition(position: integer);
begin
  if not FInitialized  then Exit;
  jSqliteCursor_MoveToPosition(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , position);
end;

function jSqliteCursor.GetRowCount: integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetRowCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

function jSqliteCursor.GetColumnCount: integer;
begin
  if not FInitialized  then Exit;
  Result:= jSqliteCursor_GetColumnCount(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

function jSqliteCursor.GetColumnIndex(colName: string): integer;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumnIndex(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , colName);
end;

function jSqliteCursor.GetColumName(columnIndex: integer): string;
begin
   if not FInitialized  then Exit;
   Result:= jSqliteCursor_GetColumName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
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
   colType:= jSqliteCursor_GetColType(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
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
   Result:= jSqliteCursor_GetValueAsString(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsBitmap(columnIndex: integer): jObject;
begin
  if not FInitialized  then Exit;
    Result:= jSqliteCursor_GetValueAsBitmap(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsInteger(columnIndex: integer): integer;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsInteger(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
end;

function jSqliteCursor.GetValueAsDouble(columnIndex: integer): double;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsDouble(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
end;


function jSqliteCursor.GetValueAsFloat(columnIndex: integer): real;
begin
  if not FInitialized  then Exit;
    Result:=  jSqliteCursor_GetValueAsFloat(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , columnIndex);
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
        if FjObject  <> nil then
        begin
          jSqliteDataAccess_Free(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
          FjObject := nil;
        end;
      end;
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
  FjObject := jSqliteDataAccess_Create(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self,
  FDataBaseName, FColDelimiter, FRowDelimiter);

  FInitialized:= True;

  for i:= 0 to FTableName.Count-1 do
  begin
     jSqliteDataAccess_AddTableName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FTableName.Strings[i]);
  end;

  for i:= 0 to FCreateTableQuery.Count-1 do
  begin
     jSqliteDataAccess_AddCreateTableQuery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FCreateTableQuery.Strings[i]);
  end;

  {
  if FjSqliteCursor <> nil then
  begin
    FjSqliteCursor.Init(refApp: jApp);
    FjSqliteCursor.SetCursor(Self.GetCursor);
  end;
  }

end;

Procedure jSqliteDataAccess.ExecSQL(execQuery: string);
begin
   if not FInitialized then Exit;
   jSqliteDataAccess_ExecSQL(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , execQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

////"data/data/com.data.pack/databases/" + myData.db;
function jSqliteDataAccess.CheckDataBaseExists(databaseName: string): boolean;
var
  fullPathDB: string;
begin                      {/data/data/com.example.program/databases}
  if not FInitialized then Exit;
  fullPathDB:=  GetFilePath(fpathDataBase) + '/' + databaseName;
  Result:= jSqliteDataAccess_CheckDataBaseExists(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , fullPathDB);
end;

procedure jSqliteDataAccess.OpenOrCreate(dataBaseName: string);
begin
  if not FInitialized then Exit;
  if dataBaseName <> '' then FDataBaseName:= dataBaseName;
  jSqliteDataAccess_OpenOrCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FDataBaseName);
end;

procedure jSqliteDataAccess.AddTable(tableName: string; createTableQuery: string);
begin
  if not FInitialized then Exit;
   jSqliteDataAccess_AddTableName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , tableName);
   jSqliteDataAccess_AddCreateTableQuery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , createTableQuery);
end;

procedure jSqliteDataAccess.CreateAllTables;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateAllTables(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

function jSqliteDataAccess.Select(selectQuery: string) : string;
begin
   if not FInitialized then Exit;
   Result:= jSqliteDataAccess_Select(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , selectQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;

procedure jSqliteDataAccess.Select(selectQuery: string);
begin
   if not FInitialized then Exit;
   jSqliteDataAccess_Select(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,  selectQuery);
   if FjSqliteCursor <> nil then FjSqliteCursor.SetCursor(Self.GetCursor);
end;


function jSqliteDataAccess.GetCursor: jObject;
begin
  if not FInitialized then Exit;
  Result:= jSqliteDataAccess_GetCursor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

procedure jSqliteDataAccess.SetSelectDelimiters(coldelim: char; rowdelim: char);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_SetSelectDelimiters(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , coldelim, rowdelim);
end;

//ex. "CREATE TABLE IF NOT EXISTS TABLE1  (_ID INTEGER PRIMARY KEY, NAME TEXT, PLACE TEXT);"
procedure jSqliteDataAccess.CreateTable(createQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_CreateTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , createQuery);
end;

procedure jSqliteDataAccess.DropTable(tableName: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DropTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , tableName);
end;

//ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('BRASILIA','CENTRO OESTE')"
procedure jSqliteDataAccess.InsertIntoTable(insertQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_InsertIntoTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , insertQuery);
end;

//ex: "DELETE FROM TABLE1  WHERE PLACE = 'BR'";
procedure jSqliteDataAccess.DeleteFromTable(deleteQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_DeleteFromTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , deleteQuery);
end;

//ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'BR'"
procedure jSqliteDataAccess.UpdateTable(updateQuery: string);
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_UpdateTable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , updateQuery);
end;

procedure jSqliteDataAccess.UpdateImage(tableName: string;imageFieldName: string;keyFieldName: string;imageValue: jObject;keyValue: integer);
begin
  jSqliteDataAccess_UpdateImage(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                 tableName,imageFieldName,keyFieldName,imageValue,keyValue);
end;

procedure jSqliteDataAccess.Close;
begin
  if not FInitialized then Exit;
  jSqliteDataAccess_Close(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
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
end;

destructor jPanel.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
   if jForm(Owner).App <> nil then
   begin
     if jForm(Owner).App.Initialized then
     begin
       if FjObject  <> nil then
       begin
         jPanel_Free2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
         FjObject := nil;
       end;
     end;
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

  FjObject := jPanel_Create2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, Self);

  FjRLayout{View}:= jPanel_getView(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ); // Java : Self Layout

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
      FjPRLayout:= jScrollView(FParent).View;
    end;
  end;

  jPanel_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
  jPanel_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.Id);

  jPanel_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject ,
                                          FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                          GetLayoutParams(gApp, FLParamWidth, sdW),
                                          GetLayoutParams(gApp, FLParamHeight, sdH));
  FInitialized:= True;
  if FParent is jPanel then
  begin
     Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
   if rToA in FPositionRelativeToAnchor then
   begin
     jPanel_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jPanel_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;

  jPanel_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);

  if FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjRLayout{!}, GetARGB(FColor));

  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);

end;

procedure jPanel.SetjParent(Value: jObject);
begin
  FjPRLayout:= Value;
  if FInitialized then
   jPanel_setParent2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FjPRLayout);
end;

Procedure jPanel.SetVisible  (Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
   jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , FVisible);
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
    jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
end;

(*
procedure jPanel.UpdateLParamWidth;
var
  side: TSide;
begin
  //FLParamWidth:= Value;
  if FInitialized then
  begin
    if jForm(Owner).Orientation = gApp.Orientation then side:= sdW
    else side:= sdH;
    jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
  end;
end;

procedure jPanel.UpdateLParamHeight;
var
  side: TSide;
begin
  //FLParamHeight:= Value;
  if FInitialized then
  begin
    if jForm(Owner).Orientation = gApp.Orientation then side:= sdH
    else side:= sdW;
    jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
  end;
end;
*)

procedure jPanel.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jPanel_setLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
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
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jPanel_setLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

function jPanel.GetWidth: integer;
begin
  Result:= FWidth;
  if FInitialized then
  begin
     Result:= jPanel_getLParamWidth2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
     if Result = -1 then //lpMatchParent
     begin
       if FParent is jForm then Result:= (FParent as jForm).ScreenWH.Width
       else Result:= Self.Parent.Width;
     end;
  end;
end;

function jPanel.GetHeight: integer;
begin
  Result:= FHeight;
  if FInitialized then
  begin
     Result:= jPanel_getLParamHeight2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
     if Result = -1 then //lpMatchParent
     begin
        if FParent is jForm then Result:= (FParent as jForm).ScreenWH.Height
        else Result:= Self.Parent.Height;
     end;
  end;
end;

procedure jPanel.ResetAllRules;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  jPanel_resetLParamsRules2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject );
  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
       jPanel_addlParamsParentRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToParent(rToP));
  end;
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
      jPanel_addlParamsAnchorRule2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jPanel.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    //ResetAllRules;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jPanel_setLayoutAll2(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject , Self.AnchorId);
  end;
end;

end.
