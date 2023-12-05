//------------------------------------------------------------------------------
//
// Android JNI Interface for Pascal/Delphi

//   [Added Lazarus Support by jmpessoa@hotmail.com - december 2013]
//    https://github.com/jmpessoa/lazandroidmodulewizard

//   Developer
//              Simon,Choi / Choi,Won-sik ,
//                           simonsayz@naver.com   
//                           http://blog.naver.com/simonsayz
//
//              LoadMan    / Jang,Yang-Ho ,
//                           wkddidgh@naver.com    
//                           http://blog.naver.com/wkddidgh 
//
//
//   History    2012.02.24 Started
//              2012.03.01 added unZip,ImageView
//              2012.07.27 fixed _jString null
//
//              see the And_Controls.pas for full history
//
//   Reference  https://github.com/alrieckert/lazarus/tree/master/lcl/interfaces/customdrawn/android
//------------------------------------------------------------------------------

unit And_jni_Bridge;

{$mode delphi}
{$packrecords c}

{$SMARTLINK ON}

interface

uses
  SysUtils,Classes, And_jni, AndroidWidget;

  //{$linklib jnigraphics}   {commented by jmpessoa}

(*
Const
 libjnigraphics  ='libjnigraphics.so'; {commented by jmpessoa}
 ANDROID_BITMAP_RESUT_SUCCESS            =  0;
 ANDROID_BITMAP_RESULT_BAD_PARAMETER     = -1;
 ANDROID_BITMAP_RESULT_JNI_EXCEPTION     = -2;
 ANDROID_BITMAP_RESULT_ALLOCATION_FAILED = -3;

Type
 AndroidBitmapFormat = (ANDROID_BITMAP_FORMAT_NONE      = 0,
                        ANDROID_BITMAP_FORMAT_RGBA_8888 = 1,
                        ANDROID_BITMAP_FORMAT_RGB_565   = 4,
                        ANDROID_BITMAP_FORMAT_RGBA_4444 = 7,
                        ANDROID_BITMAP_FORMAT_A_8       = 8);
 AndroidBitmapInfo   = record
                        width  : Cardinal; //uint32_t;
                        height : Cardinal; //uint32_t
                        stride : Cardinal; //uint32_t
                        format : Integer;  //int32_t
                        flags  : Cardinal; //uint32_t      // 0 for now
                       end;
 PAndroidBitmapInfo = ^AndroidBitmapInfo;
 *)

type


 TWH = Record
        Width : Integer;
        Height: Integer;
       End;

 {
     jboolean=byte;        // unsigned 8 bits
     jbyte=shortint;       // signed 8 bits
     jchar=word;           // unsigned 16 bits
     jshort=smallint;      // signed 16 bits
     jint=longint;         // signed 32 bits
     jlong=int64;          // signed 64 bits
     jfloat=single;        // 32-bit IEEE 754
     jdouble=double;       // 64-bit IEEE 754
 }


// Utility

procedure dbg(str : String); overload;
procedure dbg(obj : jObject; objName : String); overload;

// Jni
//function  JNI_OnLoad                   (vm:PJavaVM;reserved:pointer):jint; cdecl;
//procedure JNI_OnUnload                 (vm:PJavaVM;reserved:pointer); cdecl;

// Base
//Please, use jForm_getLength [jmpessoa]
//Function  jStr_getLength               (env:PJNIEnv;this:jobject; Str : String): Integer;


Function  jgetTick                     (env:PJNIEnv;this:jobject) : LongInt;

//------------------------
// TextView
//-----------------------

function  jTextView_Create(env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;

procedure jTextView_SetShadowLayer(env: PJNIEnv; _jtextview: JObject; _radius: single; _dx: single; _dy: single; _color: integer);
procedure jTextView_SetSingleLine(env: PJNIEnv; _jtextview: JObject; _value: boolean);
procedure jTextView_SetHorizontallyScrolling(env: PJNIEnv; _jtextview: JObject; _value: boolean);
procedure jTextView_SetEllipsize(env: PJNIEnv; _jtextview: JObject; _mode: integer);
procedure jTextView_SetTextAllCaps(env: PJNIEnv; _jtextview: JObject; _text: string);

//-----------------------------------
// EditText  :: changed by jmpessoa [support Api > 13]
//--------------------------------------

function  jEditText_Create(env:PJNIEnv; this:jobject; SelfObj: TObject ): jObject;

procedure jEditText_GetCursorPos(env:PJNIEnv; EditText : jObject; Var x,y : Integer);
procedure jEditText_SetImeKeyEnterLabel(env: PJNIEnv; _jedittext: JObject; _label: string);

// Button
function jButton_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject): jObject;
procedure jButton_Append(env: PJNIEnv; _jbutton: JObject; _txt: string);

// CheckBox
function  jCheckBox_Create(env:PJNIEnv;  this:jobject; SelfObj: TObject ): jObject;

// RadioButton
function  jRadioButton_Create(env:PJNIEnv; this:jobject; SelfObj: TObject ): jObject;

// ProgressBar
function  jProgressBar_Create(env:PJNIEnv;  this:jobject; SelfObj: TObject; Style: DWord ): jObject;

 { jImageView }

function  jImageView_Create(env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

procedure jImageView_SetImageFromIntentResult(env: PJNIEnv; _jimageview: JObject; _intentData: jObject);
procedure jImageView_SetImageThumbnailFromCamera(env: PJNIEnv; _jimageview: JObject; _intentData: jObject);
procedure jImageView_SetImageFromByteArray(env: PJNIEnv; _jimageview: JObject; var _image: TDynArrayOfJByte);

function  jImageView_GetByteBuffer(env: PJNIEnv; _jimageview: JObject; _width: integer; _height: integer): jObject;
function  jImageView_GetBitmapFromByteBuffer(env: PJNIEnv; _jimageview: JObject; _byteBuffer: jObject; _width: integer; _height: integer): jObject;
procedure jImageView_SetImageFromByteBuffer(env: PJNIEnv; _jimageview: JObject; _jbyteBuffer: jObject; _width: integer; _height: integer);
procedure jImageView_ShowPopupMenu(env: PJNIEnv; _jimageview: JObject; var _items: TDynArrayOfString); overload;
procedure jImageView_ShowPopupMenu(env: PJNIEnv; _jimageview: JObject; _items: array of string); overload;

procedure jImageView_SetImageDrawable(env: PJNIEnv; _jimageview: JObject; _imageAnimation: jObject);
procedure jImageView_SetRoundCorner(env: PJNIEnv; _jimageview: JObject; _cornersRadius: integer);

// ListView
Function  jListView_Create2             (env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string; image: jObject;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer;
                                         txtAlign: integer; txtPosition : integer): jObject;

Function  jListView_Create3             (env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer;
                                         txtAlign: integer; txtPosition : integer): jObject;

Procedure jListView_add                (env:PJNIEnv;  this:jobject;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer; hasWidgetItem: integer);
Procedure jListView_add2(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string);
procedure jListView_Insert(env: PJNIEnv; _jlistview: JObject; _index: integer; item: string; _delimiter: string);

Procedure jListView_add22(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string; image: jObject);
Procedure jListView_add3                (env:PJNIEnv;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer;
                                        widgetItem: integer; widgetText: string; image: jObject);

Procedure jListView_add4                (env:PJNIEnv;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer;
                                        widgetItem: integer; widgetText: string);

Procedure jListView_setWidgetItem3(env:PJNIEnv; ListView : jObject; value: integer; txt: string; index: integer);

procedure jListView_setWidgetCheck(env: PJNIEnv; _jlistview: JObject; _value: boolean; _index: integer);
function  jListView_SplitCenterItemCaption(env: PJNIEnv; _jlistview: JObject; _centerItemCaption: string; _delimiter: string): TDynArrayOfString;
function  jListView_LoadFromFile(env: PJNIEnv; _jlistview: JObject; _appInternalFileName: string): TDynArrayOfString;
procedure jListView_SetItemTextEllipsis(env: PJNIEnv; _jlistview: JObject; _value: boolean);

// ScrollView
Function  jScrollView_Create           (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;
function  jScrollView_jCreate(env: PJNIEnv;_Self: int64; _innerLayout: integer; this: jObject): jObject;

//thanks to DonAlfredo
procedure jScrollView_AddView(env: PJNIEnv; _jscrollview: JObject; _view: jObject);

{ jPanel }
Function  jPanel_Create           (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;

// HorizontalScrollView

function jHorizontalScrollView_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject): jObject;
function jHorizontalScrollView_jCreate(env: PJNIEnv;_Self: int64; _innerLayout: integer; this: jObject): jObject;

// WebView
Function  jWebView_Create              (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

procedure jWebView_SetHttpAuthUsernamePassword(env: PJNIEnv; _jwebview: JObject; _hostName: string; _hostDomain: string; _username: string; _password: string);

procedure jWebView_LoadDataWithBaseURL(env: PJNIEnv; _jwebview: JObject; _s1,_s2,_s3,_s4,_s5: string);//LMB
procedure jWebView_SetInitialScale(env: PJNIEnv; _jwebview: JObject; _scaleInPercent: integer);

// Canvas
Function  jCanvas_Create               (env:PJNIEnv;
                                        this:jobject; SelfObj : TObject) : jObject;

Procedure jCanvas_drawText             (env:PJNIEnv;
                                        Canv : jObject; const text : string; x, y : single); overload;
procedure jCanvas_drawLine(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle);
// LORDMAN 2013-08-13

Procedure jCanvas_drawRoundRect        (env:PJNIEnv;
                                        Canv : jObject; _left, _top, _right, _bottom, _rx, _ry : single);
Procedure jCanvas_drawBitmap           (env:PJNIEnv;
                                        Canv : jObject; bmp : jObject; left, top, right, bottom : integer); overload;
procedure jCanvas_drawBitmap           (env: PJNIEnv;
                                        _jcanvas: JObject; _bitmap: jObject; _width: integer; _height: integer); overload;
procedure jCanvas_setCanvas(env: PJNIEnv; _jcanvas: JObject; _canvas: jObject);
procedure jCanvas_drawTextAligned(env: PJNIEnv; Canv: jObject; const _text: string; _left, _top, _right, _bottom, _alignhorizontal , _alignvertical: single);
function jCanvas_GetNewPath(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle): jObject; overload;
function jCanvas_GetNewPath(env: PJNIEnv; _jcanvas: JObject; _points: array of single): jObject; overload;
procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle); overload;
procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; _points: array of single); overload;
procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; _path: jObject);  overload;
procedure jCanvas_DrawArc(env: PJNIEnv; _jcanvas: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);

function jCanvas_CreateBitmap(env: PJNIEnv; _jcanvas: JObject; _width: integer; _height: integer; _backgroundColor: integer): jObject;
procedure jCanvas_DrawBitmap(env: PJNIEnv; _jcanvas: JObject; _left: single; _top: single; _bitmap: jObject);overload;

function jCanvas_GetTextHeight(env: PJNIEnv; _jcanvas: JObject; _text: string): single;
function jCanvas_GetTextWidth(env: PJNIEnv; _jcanvas: JObject; _text: string): single;

// by Kordal
function jCanvas_GetPaint(env: PJNIEnv; _jcanvas: JObject): JObject; // uses JPaintShader

procedure jCanvas_DrawText(env: PJNIEnv; _jcanvas: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean);overload;
procedure jCanvas_DrawText(env: PJNIEnv; _jcanvas: JObject; _text: string; _x: single; _y: single; _angleDegree: single);overload;
procedure jCanvas_DrawRect(env: PJNIEnv; _jcanvas: JObject; _P0x: single; _P0y: single; _P1x: single; _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single);overload;
procedure jCanvas_DrawRect(env: PJNIEnv; _jcanvas: JObject; var _box: TDynArrayOfSingle);overload;
procedure jCanvas_DrawTextMultiLine(env: PJNIEnv; _jcanvas: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single);
function jCanvas_GetJInstance(env: PJNIEnv; _jcanvas: JObject): jObject;

//by Kordal
procedure jCanvas_DrawGrid  (env: PJNIEnv; _jcanvas: JObject; _Left, _Top, _Width, _Height: Single; _cellsX, _cellsY: Integer);
procedure jCanvas_DrawBitmap(env: PJNIEnv; _jcanvas: JObject; _bitMap: JObject; _srcL, _srcT, _srcR, _srcB: Integer; _dstL, _dstT, _dstR, _dstB: Single); overload;
procedure jCanvas_DrawFrame (env: PJNIEnv; _jcanvas: JObject; _bitMap: JObject; _srcX, _srcY, _srcW, _srcH: Integer; _X, _Y, _Wh, _Ht, _rotateDegree: Single); overload;
procedure jCanvas_DrawFrame (env: PJNIEnv; _jcanvas: JObject; _bitMap: JObject; _X, _Y: Single; _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single); overload;

// Bitmap
Function  jBitmap_Create               (env:PJNIEnv;
                                        this:jobject; SelfObj : TObject) : jObject;
Procedure jBitmap_getWH                (env:PJNIEnv;
                                        bmap : jObject; var w,h : integer);
Function  jBitmap_GetCanvas(env:PJNIEnv; bmap: jObject): jObject;//by Tomash
procedure jBitmap_GetBitmapSizeFromFile(env:PJNIEnv; bmap: jObject; _fullPathFile: string; var w, h :integer);//by Tomash
procedure jBitmap_LoadFromBuffer(env: PJNIEnv; _jbitmap: JObject; buffer: PJByte; size: Integer);overload;//by Kordal
function jBitmap_GetByteArrayFromBitmap(env:PJNIEnv;  bmap: jObject;
                                                   var bufferImage: TDynArrayOfJByte): integer;
procedure jBitmap_SetByteArrayToBitmap(env:PJNIEnv;  bmap: jObject; var bufferImage: TDynArrayOfJByte; size: integer);
function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _newWidth: integer; _newHeight: integer): jObject; overload;
function jBitmap_GetByteBuffer(env: PJNIEnv; _jbitmap: JObject; _width: integer; _height: integer): jObject;
function jBitmap_GetBitmapFromByteBuffer(env: PJNIEnv; _jbitmap: JObject; _byteBuffer: jObject; _width: integer; _height: integer): jObject;
function jBitmap_GetByteBufferFromBitmap(env: PJNIEnv; _jbitmap: JObject; _bmap: jObject): jObject; overload;
function jBitmap_GetByteBufferFromBitmap(env: PJNIEnv; _jbitmap: JObject): jObject; overload;
function jBitmap_GetRoundedShape(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject): jObject; overload;
function jBitmap_GetRoundedShape(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject; _diameter: integer): jObject; overload;
function jBitmap_DrawText(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject; _text: string; _x: integer; _y: integer; _fontSize: integer; _color: integer): jObject;overload;
function jBitmap_DrawText(env: PJNIEnv; _jbitmap: JObject; _text: string; _left: integer; _top: integer; _fontSize: integer; _color: integer): jObject;overload;
function jBitmap_DrawBitmap(env: PJNIEnv; _jbitmap: JObject; _bitmapImageIn: jObject; _left: integer; _top: integer): jObject;
function jBitmap_CreateBitmap(env: PJNIEnv; _jbitmap: JObject; _width: integer; _height: integer; _backgroundColor: integer): jObject; overload;
function jBitmap_GetThumbnailImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _thumbnailSize: integer): jObject; overload;
function jBitmap_GetThumbnailImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _width: integer; _height: integer): jObject;overload;

function jBitmap_GetBase64StringFromImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _compressFormat: integer): string;

//GLSurfaceView
Function  jGLSurfaceView_Create1       (env:PJNIEnv;  this:jobject; SelfObj: TObject; version: integer): jObject;
Function  jGLSurfaceView_Create2       (env:PJNIEnv;  this:jobject; SelfObj: TObject; version: integer): jObject;

Procedure jGLSurfaceView_getBmpArray   (env:PJNIEnv; this:jobject;filename: String);

//View

Function  jView_Create                 (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;

Procedure jView_setjCanvas             (env:PJNIEnv;
                                        View : jObject;jCanv   : jObject);

// Timer
Function  jTimer_Create                (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;

// Dialog YN
Function  jDialogYN_Create             (env:PJNIEnv; this:jobject; SelfObj : TObject;
                                        title,msg,y,n : string ): jObject;
// Dialog Progress
Function  jDialogProgress_Create       (env:PJNIEnv; this:jobject; SelfObj : TObject;
                                        title,msg : string ): jObject;
procedure jDialogProgress_Show(env: PJNIEnv; _jdialogprogress: JObject; _layout: jObject);   overload;

// ImageBtn
Function  jImageBtn_Create             (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

 { AsyncTask }
function jAsyncTask_Create             (env: PJNIEnv;    this:jobject; SelfObj: TObject): jObject;

 { jSqliteCursor by jmpessoa }

Function  jSqliteCursor_Create(env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

procedure jSqliteCursor_SetCursor(env:PJNIEnv;  SqliteCursor: jObject; Cursor: jObject);
Function  jSqliteCursor_GetCursor(env:PJNIEnv;  SqliteCursor: jObject): jObject;

{jSqliteDataAccess: by jmpessoa}

Function  jSqliteDataAccess_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject;
                                        dataBaseName: string; colDelimiter: char; rowDelimiter: char): jObject;

function  jSqliteDataAccess_GetCursor(env:PJNIEnv;  SqliteDataBase: jObject): jObject;
procedure jSqliteDataAccess_SetSelectDelimiters(env:PJNIEnv; SqliteDataBase: jObject; coldelim: char; rowdelim: char);
function  jSqliteDataAccess_UpdateImage(env:PJNIEnv; SqliteDataBase: jObject;
                                        tableName: string; imageFieldName: string; keyFieldName: string; imageValue: jObject; keyValue: integer) : boolean; overload;
function  jSqliteDataAccess_UpdateImage(env: PJNIEnv; _jsqlitedataaccess: JObject; _tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer) : boolean; overload;

procedure jSqliteDataAccess_PutDouble(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: double);
procedure jSqliteDataAccess_PutShort(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: smallint);
procedure jSqliteDataAccess_PutByte(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: byte);

//procedure jSqliteDataAccess_InsertIntoTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _insertQueries: TDynArrayOfString);
//procedure jSqliteDataAccess_UpdateTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _updateQueries: TDynArrayOfString);
function jSqliteDataAccess_InsertIntoTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _insertQueries: TDynArrayOfString): boolean;
function jSqliteDataAccess_UpdateTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _updateQueries: TDynArrayOfString): boolean;

procedure jSqliteDataAccess_UpdateImageBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);
procedure jSqliteDataAccess_ExecSQLBatchAsync(env: PJNIEnv; _jsqlitedataaccess: JObject; var _execSql: TDynArrayOfString);



     { jDBListView by Martin Lowry}

function jDBListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;

procedure jDBListView_ChangeCursor(env: PJNIEnv; _jdblistview: JObject; Cursor: jObject);
procedure jDBListView_SetColumnWeights(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfSingle);
procedure jDBListView_SetColumnNames(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfString);

{ Http }

function jHttpClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

function jHttpClient_GetCookies(env: PJNIEnv; _jhttpclient: JObject;  _nameValueSeparator: string): TDynArrayOfString; overload;
function jHttpClient_GetCookieByIndex(env: PJNIEnv; _jhttpclient: JObject; _index: integer): jObject;
function jHttpClient_GetCookieAttributeValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _attribute: string): string;
function jHttpClient_AddCookie(env: PJNIEnv; _jhttpclient: JObject; _name: string; _value: string): jObject;  overload;
function jHttpClient_IsExpired(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): boolean;
function jHttpClient_IsCookiePersistent(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): boolean;
procedure jHttpClient_SetCookieValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _value: string);
function jHttpClient_GetCookieByName(env: PJNIEnv; _jhttpclient: JObject; _cookieName: string): jObject;
procedure jHttpClient_SetCookieAttributeValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _attribute: string; _value: string);
function jHttpClient_GetCookieValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): string;
function jHttpClient_GetCookieName(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): string;
function jHttpClient_GetCookies(env: PJNIEnv; _jhttpclient: JObject; _urlString: string; _nameValueSeparator: string): TDynArrayOfString; overload;
function jHttpClient_AddCookie(env: PJNIEnv; _jhttpclient: JObject; _urlString: string; _name: string; _value: string): jObject;  overload;
function jHttpClient_OpenConnection(env: PJNIEnv; _jhttpclient: JObject; _urlString: string): jObject;
function jHttpClient_SetRequestProperty(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
function jHttpClient_GetHeaderField(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string): string;
function jHttpClient_GetHeaderFields(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): TDynArrayOfString;
procedure jHttpClient_Disconnect(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject);
function jHttpClient_Get(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): string; overload;
function jHttpClient_AddRequestProperty(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
function jHttpClient_Post(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): string; overload;
function jHttpClient_GetDefaultConnection(env: PJNIEnv; _jhttpclient: JObject): jObject;
//function jHttpClient_PostJSONData(env: PJNIEnv; _jhttpclient: JObject; _strURI: string; _jsonData: string): string;
procedure jHttpClient_SetFollowRedirects(env: PJNIEnv; _jhttpclient: JObject; _followRedirects: boolean);

{ImageList}

function jImageList_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

{Send Mail}

procedure jSend_Email(env:PJNIEnv; this:jobject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
{Send SMS}
function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage: string;
					   multipartMessage: Boolean): integer; overload;
function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage: string; 
					   packageDeliveredAction: string;
					   multipartMessage: Boolean): integer; overload;
function jRead_SMS(env:PJNIEnv; this:jobject; intentReceiver: jObject; addressBodyDelimiter: string): string;  //message

{Contact Manager}

function jContact_getMobileNumberByDisplayName(env:PJNIEnv; this:jobject;
                                               contactName: string): string;
function jContact_getDisplayNameList(env:PJNIEnv; this:jobject; delimiter: char): string;

 {Camera}

function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String): string; overload;
function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer): string; overload;
function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer; addToGallery: boolean): string; overload;

// BenchMark
Procedure jBenchMark1_Java             (env:PJNIEnv; this:jobject; var mSec : Integer;var value : single);
Procedure jBenchMark1_Pascal           (env:PJNIEnv; this:jobject; var mSec : Integer;var value : single);

implementation

(* {commented by jmpessoa}
const
 NDKLibLog        = 'liblog.so'; // NDK Log
 ANDROID_LOG_INFO = 4;

function __android_log_write(prio:longint;tag,text:pchar):longint; cdecl; external NDKLibLog; 

procedure dbg(str : String); overload;
 begin
  If Not(gDbgMode) then Exit;
   __android_log_write(ANDROID_LOG_INFO,'JNI_Pascal',Pchar(str));
 end;

procedure dbg(obj : jObject; objName : String); overload;
 begin
  If Not(gDbgMode) then Exit;
  If obj = nil then dbg(objName + ' nil')
               else dbg(objName + ' not nil');
 end;
  *)

//just dummies .... by jmpessoa
procedure dbg(str : String); overload;
begin
  //If Not(gDbgMode) then Exit;
  // __android_log_write(ANDROID_LOG_INFO,'JNI_Pascal',Pchar(str));
end;

procedure dbg(obj : jObject; objName : String); overload;
 begin
  If Not(gDbgMode) then Exit;
  If obj = nil then dbg(objName + ' nil')
               else dbg(objName + ' not nil');
 end;

//------------------------------------------------------------------------------
// Base Conversion
//------------------------------------------------------------------------------

//by jmpessoa: try fix this BUG....

// ref. http://android-developers.blogspot.cz/2011/11/jni-local-reference-changes-in-ics.html

// http://stackoverflow.com/questions/14765776/jni-error-app-bug-accessed-stale-local-reference-0xbc00021-index-8-in-a-tabl

Function  jgetTick (env:PJNIEnv;this:jobject) : LongInt;
begin
 Result     := jni_func_out_j( env, this, 'getTick');
end;

//------------------------------------------------------------------------------
// TextView
//------------------------------------------------------------------------------

Function jTextView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jTextView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jTextView_SetShadowLayer(env: PJNIEnv; _jtextview: JObject; _radius: single; _dx: single; _dy: single; _color: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jtextview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jtextview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetShadowLayer', '(FFFI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _radius;
  jParams[1].f:= _dx;
  jParams[2].f:= _dy;
  jParams[3].i:= _color;

  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jTextView_SetSingleLine(env: PJNIEnv; _jtextview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jtextview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jtextview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetSingleLine', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTextView_SetHorizontallyScrolling(env: PJNIEnv; _jtextview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jtextview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jtextview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetHorizontallyScrolling', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTextView_SetEllipsize(env: PJNIEnv; _jtextview: JObject; _mode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jtextview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jtextview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetEllipsize', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _mode;

  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

  procedure jTextView_SetTextAllCaps(env: PJNIEnv; _jtextview: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jtextview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jtextview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextAllCaps', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));

  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//------------------------------------------------------------------------------
// EditText
//------------------------------------------------------------------------------
Function jEditText_Create(env: PJNIEnv;  this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env);{global}           {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jEditText_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

// LORDMAN - 2013-07-26
Procedure jEditText_GetCursorPos(env:PJNIEnv; EditText : jObject; Var x,y : Integer);
var
 jMethod   : jMethodID = nil;
 _jIntArray : jintArray;
 _jBoolean  : jBoolean;
 //
 PInt    : PInteger;
 PIntSav : PInteger;
 cls: jClass;
label
  _exceptionOcurred;
begin

 if (env = nil) or (EditText = nil) then exit;

 cls := env^.GetObjectClass(env, EditText);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'getCursorPos', '()[I');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jIntArray := env^.CallObjectMethod(env,EditText,jMethod);

 if _jIntArray = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 //
 _jBoolean  := JNI_False;
 PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
 PIntSav    := PInt;
 x := PInt^; Inc(PInt);
 y := PInt^; Inc(PInt);

 env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);

 env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jEditText_SetImeKeyEnterLabel(env: PJNIEnv; _jedittext: JObject; _label: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jedittext = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jedittext);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImeKeyEnterLabel', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_label));

  env^.CallVoidMethodA(env, _jedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//------------------------------------------------------------------------------
// Button
//------------------------------------------------------------------------------

//by jmpessoa
Function jButton_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jButton_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jButton_Append(env: PJNIEnv; _jbutton: JObject; _txt: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jbutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Append', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_txt));

  env^.CallVoidMethodA(env, _jbutton, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//------------------------------------------------------------------------------
// CheckBox
//------------------------------------------------------------------------------
Function jCheckBox_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jCheckBox_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// RadioButton
//------------------------------------------------------------------------------

function jRadioButton_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jRadioButton_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// ProgressBar
//------------------------------------------------------------------------------

function jProgressBar_Create(env: PJNIEnv; this:jobject; SelfObj: TObject; Style: DWord): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jProgressBar_Create', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);
  _jParams[1].i := Style;

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// ImageView
//------------------------------------------------------------------------------

function jImageView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jImageView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jImageView_SetImageFromIntentResult(env: PJNIEnv; _jimageview: JObject; _intentData: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jimageview = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageFromIntentResult', '(Landroid/content/Intent;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _intentData;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageView_SetImageThumbnailFromCamera(env: PJNIEnv; _jimageview: JObject; _intentData: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jimageview = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageThumbnailFromCamera', '(Landroid/content/Intent;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _intentData;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageView_SetImageFromByteArray(env: PJNIEnv; _jimageview: JObject; var _image: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jimageview = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageFromByteArray', '([B)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_image);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_image[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jImageView_GetByteBuffer(env: PJNIEnv; _jimageview: JObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBuffer', '(II)Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _width;
  jParams[1].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jImageView_GetBitmapFromByteBuffer(env: PJNIEnv; _jimageview: JObject; _byteBuffer: jObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapFromByteBuffer', '(Ljava/nio/ByteBuffer;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _byteBuffer;
  jParams[1].i:= _width;
  jParams[2].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jImageView_SetImageFromByteBuffer(env: PJNIEnv; _jimageview: JObject; _jbyteBuffer: jObject; _width: integer; _height: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageFromByteBuffer', '(Ljava/nio/ByteBuffer;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _jbyteBuffer;
  jParams[1].i:= _width;
  jParams[2].i:= _height;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageView_ShowPopupMenu(env: PJNIEnv; _jimageview: JObject; var _items: TDynArrayOfString);
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
  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ShowPopupMenu', '([Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_items);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_items[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageView_ShowPopupMenu(env: PJNIEnv; _jimageview: JObject; _items: array of string);
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
  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ShowPopupMenu', '([Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_items);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_items[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageView_SetImageDrawable(env: PJNIEnv; _jimageview: JObject; _imageAnimation: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageDrawable', '(Landroid/graphics/drawable/AnimationDrawable;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _imageAnimation;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageView_SetRoundCorner(env: PJNIEnv; _jimageview: JObject; _cornersRadius: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimageview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimageview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetRoundCorner', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _cornersRadius;

  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// ListView
//------------------------------------------------------------------------------

function jListView_Create2(env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string; image: jObject;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer;
                                         txtAlign: integer; txtPosition : integer): jObject;
var
 jMethod: jMethodID = nil;
 _jParams: array[0..8] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 result := nil;

 if (env = nil) or (this = nil) then exit;
 cls:= Get_gjClass(env); {global}
 if cls = nil then goto _exceptionOcurred;
  {jmpessoa/warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 jMethod:= env^.GetMethodID(env, cls, 'jListView_Create2',
                                       '(JILjava/lang/String;Landroid/graphics/Bitmap;IIIII)Ljava/lang/Object;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].j := Int64(SelfObj);
 _jParams[1].i := widget;
 _jParams[2].l := env^.NewStringUTF(env, PChar(widgetText));
 _jParams[3].l := image;
 _jParams[4].i := txtDecorated;
 _jParams[5].i := itemLay;
 _jParams[6].i := txtSizeDec;
 _jParams[7].i := txtAlign;
 _jParams[8].i := txtPosition;

 Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

 Result := env^.NewGlobalRef(env,Result);
 env^.DeleteLocalRef(env,_jParams[2].l);

 _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jListView_Create3(env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer;
                                         txtAlign: integer; txtPosition : integer): jObject;
var
 jMethod: jMethodID = nil;
 _jParams: array[0..7] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 result := nil;

 if (env = nil) or (this = nil) then exit;
 cls:= Get_gjClass(env); {global}
 if cls = nil then goto _exceptionOcurred;
 {jmpessoa/warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 jMethod:= env^.GetMethodID(env, cls, 'jListView_Create3',
                                       '(JILjava/lang/String;IIIII)Ljava/lang/Object;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].j := Int64(SelfObj);
 _jParams[1].i := widget;
 _jParams[2].l := env^.NewStringUTF(env, pchar(widgetText) );
 _jParams[3].i := txtDecorated;
 _jParams[4].i := itemLay;
 _jParams[5].i := txtSizeDec;
 _jParams[6].i := txtAlign;
 _jParams[7].i := txtPosition;

 Result:= env^.CallObjectMethodA(env, this, jMethod,@_jParams);

 Result:= env^.NewGlobalRef(env,Result);
 env^.DeleteLocalRef(env,_jParams[2].l);

 _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

// Java Function
Procedure jListView_add(env:PJNIEnv; this:jobject; ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer; hasWidgetItem: integer);
var
  jMethod: jMethodID = nil;
  _jParams: array[0..5] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (ListView = nil) then exit;
  cls := env^.GetObjectClass(env, ListView);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jListView_add', '(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;III)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  _jParams[0].l := ListView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[3].i := fontColor;
  _jParams[4].i := fontSize;
  _jParams[5].i := hasWidgetItem;

  if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[2].l = nil) then begin env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,this,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
  env^.DeleteLocalRef(env,cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure jListView_add2(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string);
var
  jMethod: jMethodID = nil;
  _jParams: array[0..1] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (ListView = nil) then exit;
  cls:= env^.GetObjectClass(env, ListView);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'add2', '(Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );

  if (_jParams[0].l = nil) then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,ListView,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env, cls);  // <---- bug fix! 09-Sept-2014 [thanks to @Fatih!]

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jListView_Insert(env: PJNIEnv; _jlistview: JObject; _index: integer; item: string; _delimiter: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jlistview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jlistview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Insert', '(ILjava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(item));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_delimiter));

  env^.CallVoidMethodA(env, _jlistview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


Procedure jListView_add22(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string; image: jObject);
var
  jMethod: jMethodID = nil;
  _jParams: array[0..2] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (ListView = nil) then exit;
  cls := env^.GetObjectClass(env, ListView);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'add22', '(Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].l := image;

  if (_jParams[0].l = nil) then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,ListView,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env, cls);  // <---- bug fix! 09-Sept-2014

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by jmpessoa
Procedure jListView_add3(env:PJNIEnv; ListView : jObject; Str : string;
       delimiter: string; fontColor: integer; fontSize: integer; widgetItem: integer; widgetText: string;  image: jObject);
var
  jMethod: jMethodID = nil;
  _jParams: array[0..6] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (ListView = nil) then exit;
  cls:= env^.GetObjectClass(env, ListView);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'add3', '(Ljava/lang/String;Ljava/lang/String;IIILjava/lang/String;Landroid/graphics/Bitmap;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].i := fontColor;
  _jParams[3].i := fontSize;
  _jParams[4].i := widgetItem;
  _jParams[5].l := env^.NewStringUTF(env, pchar(widgetText) );
  _jParams[6].l := image;

  if (_jParams[0].l = nil) then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[5].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,ListView,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[5].l);
  env^.DeleteLocalRef(env, cls);  // <---- bug fix! 09-Sept-2014

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//by jmpessoa
Procedure jListView_add4(env:PJNIEnv; ListView : jObject; Str : string;
       delimiter: string; fontColor: integer; fontSize: integer; widgetItem: integer; widgetText: string);
var
  jMethod: jMethodID = nil;
  _jParams: array[0..5] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (ListView = nil) then exit;
  cls:= env^.GetObjectClass(env, ListView);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'add4', '(Ljava/lang/String;Ljava/lang/String;IIILjava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].i := fontColor;
  _jParams[3].i := fontSize;
  _jParams[4].i := widgetItem;
  _jParams[5].l := env^.NewStringUTF(env, pchar(widgetText) );

  if (_jParams[0].l = nil) then begin env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[1].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;
  if (_jParams[5].l = nil) then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,ListView,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[5].l);
  env^.DeleteLocalRef(env, cls);  // <---- bug fix! 09-Sept-2014

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure jListView_setWidgetItem3(env:PJNIEnv; ListView : jObject; value: integer; txt: string; index: integer);
var
 jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
   cls: jClass;
 label
   _exceptionOcurred;
begin
 if (env = nil) or (ListView = nil) then exit;
 cls := env^.GetObjectClass(env, ListView);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'setWidgetItem', '(ILjava/lang/String;I)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].i := value;
 _jParams[1].l := env^.NewStringUTF(env, pchar(txt) );
 _jParams[2].i := index;

 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethodA(env,ListView,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jListView_setWidgetCheck(env: PJNIEnv; _jlistview: JObject; _value: boolean; _index: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jlistview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jlistview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'setWidgetCheck', '(ZI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);
  jParams[1].i:= _index;

  env^.CallVoidMethodA(env, _jlistview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jListView_SplitCenterItemCaption(env: PJNIEnv; _jlistview: JObject; _centerItemCaption: string; _delimiter: string): TDynArrayOfString;
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
  Result := nil;

  if (env = nil) or (_jlistview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jlistview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SplitCenterItemCaption', '(Ljava/lang/String;Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_centerItemCaption));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jlistview, jMethod,  @jParams);

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
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jListView_LoadFromFile(env: PJNIEnv; _jlistview: JObject; _appInternalFileName: string): TDynArrayOfString;
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

  if (env = nil) or (_jlistview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jlistview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_appInternalFileName));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jlistview, jMethod,  @jParams);

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

procedure jListView_SetItemTextEllipsis(env: PJNIEnv; _jlistview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jlistview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jlistview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTextEllipsis', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jlistview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//------------------------------------------------------------------------------
// ScrollView
//------------------------------------------------------------------------------
function jScrollView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jScrollView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jScrollView_jCreate(env: PJNIEnv;_Self: int64; _innerLayout: integer; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jScrollView_jCreate', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].i:= _innerLayout;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jScrollView_AddView(env: PJNIEnv; _jscrollview: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jscrollview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jscrollview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddView', '(Landroid/view/View;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _view;

  env^.CallVoidMethodA(env, _jscrollview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//----------------------------------------
//Panel
//----------------------------------------
function jPanel_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jPanel_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// HorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------

//by jmpessoa
function jHorizontalScrollView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jHorizontalScrollView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;
//
function jHorizontalScrollView_jCreate(env: PJNIEnv;_Self: int64; _innerLayout: integer; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jHorizontalScrollView_jCreate', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].i:= _innerLayout;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


//------------------------------------------------------------------------------
// WebView
//------------------------------------------------------------------------------
function jWebView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jWebView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jWebView_SetHttpAuthUsernamePassword(env: PJNIEnv; _jwebview: JObject; _hostName: string; _hostDomain: string; _username: string; _password: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jwebview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jwebview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetHttpAuthUsernamePassword', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_hostName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_hostDomain));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_username));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_password));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[3].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jwebview, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//LMB
procedure jWebView_LoadDataWithBaseURL(env: PJNIEnv; _jwebview: JObject; _s1,_s2,_s3,_s4,_s5: string);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID;
  jCls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jwebview = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jwebview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'callLoadDataWithBaseURL',
    '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_s1));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_s2));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_s3));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_s4));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_s5));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[3].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[4].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jParams[3].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jwebview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jParams[2].l);
  env^.DeleteLocalRef(env, jParams[3].l);
  env^.DeleteLocalRef(env, jParams[4].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jWebView_SetInitialScale(env: PJNIEnv; _jwebview: JObject; _scaleInPercent: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jwebview = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jwebview);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetInitialScale', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _scaleInPercent;

  env^.CallVoidMethodA(env, _jwebview, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// Canvas
//------------------------------------------------------------------------------

Function jCanvas_Create(env:PJNIEnv; this:jobject; SelfObj : TObject) : jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jCanvas_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod, @_jParams);
  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

Procedure jCanvas_drawText(env:PJNIEnv; Canv : jObject; const text : string; x,y : single);
var
 jMethod : jMethodID = nil;
 _jParams : Array[0..2] of jValue;
 cls: jClass;
 label
   _exceptionOcurred;
begin
 if (env = nil) or (Canv = nil) then exit;

 cls := env^.GetObjectClass(env, Canv);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'drawText', '(Ljava/lang/String;FF)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].l := env^.NewStringUTF(env, pchar(text) );
 _jParams[1].F := x;
 _jParams[2].F := y;

 if _jParams[0].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 env^.CallVoidMethodA(env,Canv,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_drawLine(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'drawLine', '([F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure jCanvas_drawRoundRect(env:PJNIEnv; Canv : jObject; _left, _top, _right, _bottom, _rx, _ry : single);
var
 jMethod : jMethodID = nil;
 _jParams : Array[0..5] of jValue;
 cls: jClass;
 label
   _exceptionOcurred;
begin
 if (env = nil) or (Canv = nil) then exit;

 cls := env^.GetObjectClass(env, Canv);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'drawRoundRect', '(FFFFFF)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].F := _left;
 _jParams[1].F := _top;
 _jParams[2].F := _right;
 _jParams[3].F := _bottom;
 _jParams[4].F := _rx;
 _jParams[5].F := _ry;

 env^.CallVoidMethodA(env,Canv,jMethod,@_jParams);

 env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure jCanvas_drawBitmap(env:PJNIEnv; Canv : jObject; bmp : jObject; left, top, right, bottom: integer);
var
 jMethod: jMethodID = nil;
 _jParams: Array[0..4] of jValue;
 cls: jClass;
 label
   _exceptionOcurred;
begin
 if (env = nil) or (Canv = nil) then exit;

 cls:= env^.GetObjectClass(env, Canv);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'drawBitmap', '(Landroid/graphics/Bitmap;IIII)V');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 _jParams[0].l := bmp;
 _jParams[1].i := left;
 _jParams[2].i := top;
 _jParams[3].i := right;
 _jParams[4].i := bottom;

 env^.CallVoidMethodA(env,Canv,jMethod,@_jParams);

 env^.DeleteLocalRef(env, cls); 

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_drawBitmap(env: PJNIEnv; _jcanvas: JObject; _bitmap: jObject; _width: integer; _height: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'drawBitmap', '(Landroid/graphics/Bitmap;II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _width;
  jParams[2].i:= _height;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_setCanvas(env: PJNIEnv; _jcanvas: JObject; _canvas: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'setCanvas', '(Landroid/graphics/Canvas;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _canvas;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_drawTextAligned(env: PJNIEnv; Canv: jObject; const _text: string;
  _left, _top, _right, _bottom, _alignhorizontal , _alignvertical: single);
var
  jMethod : jMethodID = nil;
  _jParams : Array[0..6] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
 begin
  if (env = nil) or (Canv = nil) then exit;

  cls := env^.GetObjectClass(env, Canv);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'drawTextAligned', '(Ljava/lang/String;FFFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(_text) );
  _jParams[1].f := _left;
  _jParams[2].f := _top;
  _jParams[3].f := _right;
  _jParams[4].f := _bottom;
  _jParams[5].f := _alignhorizontal;
  _jParams[6].f := _alignvertical;

  if _jParams[0].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env,Canv,jMethod,@_jParams);

  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jCanvas_GetNewPath(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetNewPath', '([F)Landroid/graphics/Path;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;

  Result:= env^.CallObjectMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jCanvas_GetNewPath(env: PJNIEnv; _jcanvas: JObject; _points: array of single): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetNewPath', '([F)Landroid/graphics/Path;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;

  Result:= env^.CallObjectMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; var _points: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '([F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; _points: array of single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '([F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_DrawPath(env: PJNIEnv; _jcanvas: JObject; _path: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '(Landroid/graphics/Path;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _path;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_DrawArc(env: PJNIEnv; _jcanvas: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawArc', '(FFFFFFZ)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _leftRectF;
  jParams[1].f:= _topRectF;
  jParams[2].f:= _rightRectF;
  jParams[3].f:= _bottomRectF;
  jParams[4].f:= _startAngle;
  jParams[5].f:= _sweepAngle;
  jParams[6].z:= JBool(_useCenter);

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jCanvas_CreateBitmap(env: PJNIEnv; _jcanvas: JObject; _width: integer; _height: integer; _backgroundColor: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'CreateBitmap', '(III)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jParams[2].i:= _backgroundColor;

  Result:= env^.CallObjectMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jCanvas_DrawBitmap(env: PJNIEnv; _jcanvas: JObject; _left: single; _top: single; _bitmap: jObject);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(FFLandroid/graphics/Bitmap;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _left;
  jParams[1].f:= _top;
  jParams[2].l:= _bitmap;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jCanvas_GetPaint(env: PJNIEnv; _jcanvas: JObject): JObject;
var
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetPaint', '()Landroid/graphics/Paint;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jcanvas, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jCanvas_DrawText(env: PJNIEnv; _jcanvas: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FFFZ)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jParams[4].z:= JBool(_rotateCenter);

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jCanvas_DrawText(env: PJNIEnv; _jcanvas: JObject; _text: string; _x: single; _y: single; _angleDegree: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jCanvas_DrawRect(env: PJNIEnv; _jcanvas: JObject; _P0x: single; _P0y: single; _P1x: single; _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single);
var
  jParams: array[0..7] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '(FFFFFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _P0x;
  jParams[1].f:= _P0y;
  jParams[2].f:= _P1x;
  jParams[3].f:= _P1y;
  jParams[4].f:= _P2x;
  jParams[5].f:= _P2y;
  jParams[6].f:= _P3x;
  jParams[7].f:= _P3y;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jCanvas_DrawRect(env: PJNIEnv; _jcanvas: JObject; var _box: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '([F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_box);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_box[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jCanvas_DrawTextMultiLine(env: PJNIEnv; _jcanvas: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextMultiLine', '(Ljava/lang/String;FFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _left;
  jParams[2].f:= _top;
  jParams[3].f:= _right;
  jParams[4].f:= _bottom;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jCanvas_GetJInstance(env: PJNIEnv; _jcanvas: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '()Landroid/graphics/Canvas;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jcanvas, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jCanvas_DrawGrid(env: PJNIEnv; _jcanvas: JObject; _Left, _Top, _Width, _Height: Single; _cellsX, _cellsY: Integer);
var
  jParams: array[0..5] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls := env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'DrawGrid', '(FFFFII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _Left;
  jParams[1].f := _Top;
  jParams[2].f := _Width;
  jParams[3].f := _Height;
  jParams[4].i := _cellsX;
  jParams[5].i := _cellsY;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jCanvas_DrawBitmap(env: PJNIEnv; _jcanvas: JObject; _bitMap: JObject; _srcL, _srcT, _srcR, _srcB: Integer; _dstL, _dstT, _dstR, _dstB: Single);
var
  jParams: array [0..8] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls := env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;IIIIFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := _bitMap;
  jParams[1].i := _srcL;
  jParams[2].i := _srcT;
  jParams[3].i := _srcR;
  jParams[4].i := _srcB;
  jParams[5].f := _dstL;
  jParams[6].f := _dstT;
  jParams[7].f := _dstR;
  jParams[8].f := _dstB;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by Kordal
procedure jCanvas_DrawFrame(env: PJNIEnv; _jcanvas: JObject; _bitMap: jObject; _srcX, _srcY, _srcW, _srcH: Integer; _X, _Y, _Wh, _Ht, _rotateDegree: Single);
var
  jParams: array[0..9] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;IIIIFFFFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitMap;
  jParams[1].i:= _srcX;
  jParams[2].i:= _srcY;
  jParams[3].i:= _srcW;
  jParams[4].i:= _srcH;
  jParams[5].f:= _X;
  jParams[6].f:= _Y;
  jParams[7].f:= _Wh;
  jParams[8].f:= _Ht;
  jParams[9].f:= _rotateDegree;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by Kordal
procedure jCanvas_DrawFrame(env: PJNIEnv; _jcanvas: JObject; _bitMap: JObject; _X, _Y: Single; _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;FFIIFF)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitMap;
  jParams[1].f:= _X;
  jParams[2].f:= _Y;
  jParams[3].i:= _Index;
  jParams[4].i:= _Size;
  jParams[5].f:= _scaleFactor;
  jParams[6].f:= _rotateDegree;

  env^.CallVoidMethodA(env, _jcanvas, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jCanvas_GetTextHeight(env: PJNIEnv; _jcanvas: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextHeight', '(Ljava/lang/String;)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallFloatMethodA(env, _jcanvas, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jCanvas_GetTextWidth(env: PJNIEnv; _jcanvas: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := 0;

  if (env = nil) or (_jcanvas = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jcanvas);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextWidth', '(Ljava/lang/String;)F');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallFloatMethodA(env, _jcanvas, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// Bitmap
//------------------------------------------------------------------------------

Function  jBitmap_Create(env:PJNIEnv; this:jobject; SelfObj : TObject) : jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jBitmap_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

Procedure jBitmap_getWH(env:PJNIEnv; bmap : jObject; var w,h : integer);
var
  jMethod   : jMethodID = nil;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  //
  PInt       : PInteger;
  PIntSav    : PInteger;
  cls: jClass;
 label
   _exceptionOcurred;
 begin
  if (env = nil) or (bmap = nil) then exit;

  cls := env^.GetObjectClass(env, bmap);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'getWH', '()[I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jIntArray := env^.CallObjectMethod(env,bmap,jMethod);

  if _jIntArray = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;
  //
  _jBoolean  := JNI_False;
  PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
  PIntSav    := PInt;
  w          := PInt^; Inc(PInt);
  h          := PInt^; Inc(PInt);

  env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
 end;

//by Tomash
Function  jBitmap_GetCanvas(env:PJNIEnv; bmap: jObject): jObject;
var
  jMethod : jMethodID = nil;
  cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (bmap = nil) then exit;

  cls := env^.GetObjectClass(env, bmap);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls,'GetCanvas', '()Landroid/graphics/Canvas;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result := env^.CallObjectMethod(env,bmap,jMethod);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//by Tomash
procedure jBitmap_GetBitmapSizeFromFile(env:PJNIEnv; bmap: jObject; _fullPathFile: string; var w, h :integer);
var
  jParams: array[0..0] of jValue;
  jMethod   : jMethodID = nil;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  PInt       : PInteger;
  PIntSav    : PInteger;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (bmap = nil) then exit;

  cls := env^.GetObjectClass(env, bmap);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetBitmapSizeFromFile', '(Ljava/lang/String;)[I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullPathFile));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jIntArray:= env^.CallObjectMethodA(env,bmap,jMethod, @jParams);

  if _jIntArray <> nil then
  begin
   _jBoolean  := JNI_False;
   PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
   PIntSav    := PInt;
   w          := PInt^; Inc(PInt);
   h          := PInt^; Inc(PInt);

   env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
  end;

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jBitmap_LoadFromBuffer(env: PJNIEnv; _jbitmap: JObject; buffer: PJByte; size: Integer); //by Kordal
var
  jMethod: jMethodID = nil;
  jCls: jClass;
  jParam: array[0..0] of jValue;
  byteArray: jByteArray;
 label
   _exceptionOcurred;
begin

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls := env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromBuffer', '([B)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

   //Convert the Pascal's Native array[] of jbyte to JNI jbytearray
  byteArray:= env^.NewByteArray(env, size);  // allocate

  if byteArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.SetByteArrayRegion(env, byteArray, 0, size, buffer);
  jParam[0].l := byteArray;

  env^.CallVoidMethodA(env, _jbitmap, jMethod, @jParam);

  env^.DeleteLocalRef(env, jParam[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jBitmap_SetByteArrayToBitmap(env:PJNIEnv;  bmap: jObject; var bufferImage: TDynArrayOfJByte; size: integer);
var
  jMethod: jMethodID = nil;
  cls: jClass;
  _jParam: array[0..0] of jValue;
  _jbyteArray : jByteArray;
 label
   _exceptionOcurred;
begin

  if (env = nil) or (bmap = nil) then exit;

  cls := env^.GetObjectClass(env, bmap);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'SetByteArrayToBitmap', '([B)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

   //Convert the Pascal's Native array[] of jbyte to JNI jbytearray
  _jbyteArray:= env^.NewByteArray(env, size);  // allocate

  if _jbyteArray = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  env^.SetByteArrayRegion(env, _jbyteArray, 0 , size, @bufferImage[0] {source});  // copy
  _jParam[0].l:= _jbyteArray;

  env^.CallVoidMethodA(env,bmap,jMethod, @_jParam);

  env^.DeleteLocalRef(env,_jParam[0].l);
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jBitmap_GetByteArrayFromBitmap(env:PJNIEnv;  bmap: jObject;  var bufferImage: TDynArrayOfJByte): integer;
var
  jMethod: jMethodID = nil;
  _jbyteArray: jbyteArray;
  cls: jClass;
label
  _exceptionOcurred;
begin

  result := 0;

  if (env = nil) or (bmap = nil) then exit;

  cls := env^.GetObjectClass(env, bmap);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetByteArrayFromBitmap', '()[B');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jbyteArray := env^.CallObjectMethod(env,bmap,jMethod);

  Result:= env^.GetArrayLength(env,_jbyteArray);
  SetLength(bufferImage, Result);
  env^.GetByteArrayRegion(env, _jbyteArray, 0, Result, @bufferImage[0] {target});
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _newWidth: integer; _newHeight: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetResizedBitmap', '(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bmp;
  jParams[1].i:= _newWidth;
  jParams[2].i:= _newHeight;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jBitmap_GetByteBuffer(env: PJNIEnv; _jbitmap: JObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBuffer', '(II)Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls);  goto _exceptionOcurred; end;

  jParams[0].i:= _width;
  jParams[1].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jBitmap_GetBitmapFromByteBuffer(env: PJNIEnv; _jbitmap: JObject; _byteBuffer: jObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapFromByteBuffer', '(Ljava/nio/ByteBuffer;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _byteBuffer;
  jParams[1].i:= _width;
  jParams[2].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetByteBufferFromBitmap(env: PJNIEnv; _jbitmap: JObject; _bmap: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBufferFromBitmap', '(Landroid/graphics/Bitmap;)Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bmap;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetByteBufferFromBitmap(env: PJNIEnv; _jbitmap: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBufferFromBitmap', '()Ljava/nio/ByteBuffer;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jbitmap, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetRoundedShape(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetRoundedShape', '(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmapImage;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetRoundedShape(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject; _diameter: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetRoundedShape', '(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmapImage;
  jParams[1].i:= _diameter;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_DrawText(env: PJNIEnv; _jbitmap: JObject; _bitmapImage: jObject; _text: string; _x: integer; _y: integer; _fontSize: integer; _color: integer): jObject;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Landroid/graphics/Bitmap;Ljava/lang/String;IIII)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmapImage;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[2].i:= _x;
  jParams[3].i:= _y;
  jParams[4].i:= _fontSize;
  jParams[5].i:= _color;

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_DrawText(env: PJNIEnv; _jbitmap: JObject; _text: string; _left: integer; _top: integer; _fontSize: integer; _color: integer): jObject;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;IIII)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].i:= _left;
  jParams[2].i:= _top;
  jParams[3].i:= _fontSize;
  jParams[4].i:= _color;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jBitmap_DrawBitmap(env: PJNIEnv; _jbitmap: JObject; _bitmapImageIn: jObject; _left: integer; _top: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmapImageIn;
  jParams[1].i:= _left;
  jParams[2].i:= _top;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_CreateBitmap(env: PJNIEnv; _jbitmap: JObject; _width: integer; _height: integer; _backgroundColor: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'CreateBitmap', '(III)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jParams[2].i:= _backgroundColor;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetThumbnailImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _thumbnailSize: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetThumbnailImage', '(Landroid/graphics/Bitmap;I)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _thumbnailSize;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetThumbnailImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetThumbnailImage', '(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _width;
  jParams[2].i:= _height;

  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jBitmap_GetBase64StringFromImage(env: PJNIEnv; _jbitmap: JObject; _bitmap: jObject; _compressFormat: integer): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jbitmap = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jbitmap);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBase64StringFromImage', '(Landroid/graphics/Bitmap;I)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _bitmap;
  jParams[1].i:= _compressFormat;

  jStr:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//------------------------------------------------------------------------------
// jGLSurfaceView
//------------------------------------------------------------------------------

function jGLSurfaceView_Create1(env: PJNIEnv; this:jobject; SelfObj: TObject; version : integer): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jCanvasES1_Create', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);
  _jParams[1].i := version;

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jGLSurfaceView_Create2(env: PJNIEnv; this:jobject; SelfObj: TObject; version : integer): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jCanvasES2_Create', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);
  _jParams[1].i := version;

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


Procedure jGLSurfaceView_getBmpArray(env:PJNIEnv; this: jobject;filename : String);
var
  jMethod   : jMethodID = nil;
  _jParam    : jValue;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  Size : Integer;
  PInt : PInteger;
  PIntS: PInteger;
 cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'getBmpArray', '(Ljava/lang/String;)[I');
  if jMethod = nil then goto _exceptionOcurred;

  _jParam.l  := env^.NewStringUTF( env, pchar(filename));

  _jIntArray := env^.CallObjectMethodA(env,this,jMethod,@_jParam);

  if _jIntArray <> nil then
  begin
   Size := env^.GetArrayLength(env,_jIntArray);

   //dbg('Size: ' + IntToStr(Size) );
   _jBoolean  := JNI_False;
   PInt := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
   PIntS:= PInt;
   Inc(PIntS,Size-2);
   //dbg('width:'  + IntToStr(PintS^)); Inc(PintS);
   //dbg('height:' + IntToStr(PintS^));
   env^.ReleaseIntArrayElements(env,_jIntArray,PInt,0);
  end;

  //dbg('Here...');
  env^.DeleteLocalRef(env,_jParam.l);

  _exceptionOcurred: jni_ExceptionOccurred(env);
 end;

//----------------------------
//View
//----------------------------------

function jView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jView_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

Procedure jView_setjCanvas(env:PJNIEnv;
                           View : jObject;jCanv : jObject);
var
  jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (View = nil) then exit;

  cls := env^.GetObjectClass(env, View);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'SetjCanvas', '(Ljava/lang/Object;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].l := jCanv;

  env^.CallVoidMethodA(env,View,jMethod,@_jParams);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// Timer
//------------------------------------------------------------------------------

Function jTimer_Create (env:PJNIEnv; this:jobject; SelfObj : TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jTimer_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// jDialog YN
//------------------------------------------------------------------------------

Function jDialogYN_Create (env:PJNIEnv; this:jobject; SelfObj : TObject;
                           title,msg,y,n : string ): jObject;

var
 jMethod : jMethodID = nil;
 _jParams : Array[0..4] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
 result := nil;

 if (env = nil) or (this = nil) then exit;

 cls:= Get_gjClass(env); {global}
 if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 jMethod:= env^.GetMethodID(env, cls, 'jDialogYN_Create', '(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].j := Int64(SelfObj);
 _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(Msg  ) );
 _jParams[3].l := env^.NewStringUTF(env, pchar(y    ) );
 _jParams[4].l := env^.NewStringUTF(env, pchar(n    ) );

 if _jParams[1].l = nil then goto _exceptionOcurred;
 if _jParams[2].l = nil then begin env^.DeleteLocalRef(env,_jParams[1].l); goto _exceptionOcurred; end;
 if _jParams[3].l = nil then begin env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,_jParams[2].l); goto _exceptionOcurred; end;
 if _jParams[4].l = nil then begin env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,_jParams[2].l); env^.DeleteLocalRef(env,_jParams[3].l); goto _exceptionOcurred; end;

 Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

 Result := env^.NewGlobalRef(env,Result);

 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,_jParams[3].l);
 env^.DeleteLocalRef(env,_jParams[4].l);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// jDialog Progress
//------------------------------------------------------------------------------

Function jDialogProgress_Create(env:PJNIEnv; this:jobject; SelfObj : TObject;
                                 title, msg: string ): jObject;
var
  jMethod : jMethodID = nil;
  _jParams : Array[0..2] of jValue;
  cls: jClass;
label
  _exceptionOcurred;
 begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
   {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jDialogProgress_Create', '(JLjava/lang/String;Ljava/lang/String;)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);
  _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(Msg) );

  if _jParams[1].l = nil then goto _exceptionOcurred;
  if _jParams[2].l = nil then begin env^.DeleteLocalRef(env,_jParams[1].l); goto _exceptionOcurred; end;

  Result := env^.CallObjectMethodA(env,this,jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jDialogProgress_Show(env: PJNIEnv; _jdialogprogress: JObject; _layout: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (_jdialogprogress = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jdialogprogress);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Landroid/widget/RelativeLayout;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _layout;

  env^.CallVoidMethodA(env, _jdialogprogress, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//------------------------------------------------------------------------------
// jImageBtn
//------------------------------------------------------------------------------

function jImageBtn_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}
  if cls = nil then goto _exceptionOcurred;
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  jMethod:= env^.GetMethodID(env, cls, 'jImageBtn_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//------------------------------------------------------------------------------
// jAsyncTask
//------------------------------------------------------------------------------

function jAsyncTask_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jAsyncTask_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

{ jSqliteCursor by jmpessoa }

Function jSqliteCursor_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env);           {a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jSqliteCursor_Create', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jSqliteCursor_SetCursor(env:PJNIEnv; SqliteCursor: jObject; Cursor: jObject);
var
   jMethod : jMethodID = nil;
   cls: jClass;
   _jParam: array[0..0] of jValue;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (SqliteCursor = nil) then exit;

  cls := env^.GetObjectClass(env, SqliteCursor);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'SetCursor', '(Landroid/database/Cursor;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParam[0].l:= Cursor;

  env^.CallVoidMethodA(env, SqliteCursor,jMethod, @_jParam);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Function jSqliteCursor_GetCursor (env:PJNIEnv;  SqliteCursor: jObject) : jObject;
var
 jMethod : jMethodID = nil;
 cls: jClass;
label
  _exceptionOcurred;
begin
 result := nil;

 if (env = nil) or (SqliteCursor = nil) then exit;

 cls := env^.GetObjectClass(env, SqliteCursor);
 if cls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, cls, 'GetCursor', '()Landroid/database/Cursor;');
 if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

 Result := env^.CallObjectMethod(env,SqliteCursor,jMethod);

 env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


 {jSqliteDataAccess - by jmpessoa}

Function  jSqliteDataAccess_Create(env: PJNIEnv; this:jobject; SelfObj: TObject;
                                         dataBaseName: string; colDelimiter: char; rowDelimiter: char): jObject;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..3] of jValue;
 cls: jClass;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  cls:= Get_gjClass(env);           {a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'jSqliteDataAccess_Create', '(JLjava/lang/String;CC)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  _jParams[0].j := Int64(SelfObj);
  _jParams[1].l := env^.NewStringUTF(env, pchar(dataBaseName));
  _jParams[2].c := jChar(colDelimiter);
  _jParams[3].c := jChar(rowDelimiter);

  Result := env^.CallObjectMethodA(env, this, jMethod,@_jParams);

  Result := env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[1].l);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jSqliteDataAccess_GetCursor(env:PJNIEnv;  SqliteDataBase: jObject): jObject;
var
  cls: jClass;
  jMethod: jmethodID;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (SqliteDataBase = nil) then exit;

  cls := env^.GetObjectClass(env, SqliteDataBase);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'GetCursor', '()Landroid/database/Cursor;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  Result  := env^.CallObjectMethod(env, SqliteDataBase, jMethod);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jSqliteDataAccess_SetSelectDelimiters(env:PJNIEnv; SqliteDataBase: jObject;
                              coldelim: char; rowdelim: char);
var
   cls: jClass;
  jMethod: jmethodID;
  _jParams: array[0..1] of jValue;
 label
   _exceptionOcurred;
begin
  if (env = nil) or (SqliteDataBase = nil) then exit;

  cls:= env^.GetObjectClass(env, SqliteDataBase);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'SetSelectDelimiters', '(CC)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].c := jChar(coldelim);
  _jParams[1].c := jChar(rowdelim);

  env^.CallVoidMethodA(env, SqliteDataBase, jMethod,@_jParams);

  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jSqliteDataAccess_UpdateImage(env:PJNIEnv; SqliteDataBase: jObject;
                                          tableName: string;
                                          imageFieldName: string;
                                          keyFieldName: string;
                                          imageValue: jObject;
                                          keyValue: integer) : boolean;
var
  jBoo: JBoolean;
  cls: jClass;
  jMethod: jmethodID;
  _jParams : array[0..4] of jValue;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (SqliteDataBase = nil) then exit;

  cls := env^.GetObjectClass(env, SqliteDataBase);
  if cls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, cls, 'UpdateImage',
                                      '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;I)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  _jParams[0].l := env^.NewStringUTF(env, pchar(tableName));
  _jParams[1].l := env^.NewStringUTF(env, pchar(imageFieldName));
  _jParams[2].l := env^.NewStringUTF(env, pchar(keyFieldName));
  _jParams[3].l:= imageValue;
  _jParams[4].i := keyValue;

  if _jParams[0].l = nil then begin env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;
  if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;
  if _jParams[2].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env, cls); goto _exceptionOcurred; end;

  jBoo   := env^.CallBooleanMethodA(env, SqliteDataBase, jMethod,@_jParams);

  Result := boolean(jBoo);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
  env^.DeleteLocalRef(env, cls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jSqliteDataAccess_PutDouble(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutDouble', '(Ljava/lang/String;D)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_colum));
  jParams[1].d:= _value;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jSqliteDataAccess_PutShort(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: smallint);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutShort', '(Ljava/lang/String;S)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_colum));
  jParams[1].s:= _value;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jSqliteDataAccess_PutByte(env: PJNIEnv; _jsqlitedataaccess: JObject; _colum: string; _value: byte);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PutByte', '(Ljava/lang/String;B)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_colum));
  jParams[1].b:= _value;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jSqliteDataAccess_UpdateImage(env: PJNIEnv; _jsqlitedataaccess: JObject; _tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer) : boolean;
var
  jBoo: JBoolean;
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateImage', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_tabName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_imageFieldName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_keyFieldName));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jParams[4].i:= _keyValue;

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[3].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env,jParams[2].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jBoo   := env^.CallBooleanMethodA(env, _jsqlitedataaccess, jMethod, @jParams);

  Result := boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//fixed by Martin Lowry

function jSqliteDataAccess_InsertIntoTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _insertQueries: TDynArrayOfString): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
  jStrings: array of jObject;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'InsertIntoTableBatch', '([Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStrings := nil;
  newSize0:= Length(_insertQueries);
  SetLength(jStrings, newSize0+1);
  jStrings[newSize0] := env^.NewStringUTF(env, PChar(''));
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'), jStrings[newSize0]);

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
    jStrings[i] := env^.NewStringUTF(env, PChar(_insertQueries[i]));
    env^.SetObjectArrayElement(env,jNewArray0,i,jStrings[i]);
  end;
  jParams[0].l:= jNewArray0;

  jBoo:= env^.CallBooleanMethodA(env, _jsqlitedataaccess, jMethod, @jParams);

  Result:= boolean(jBoo);
  for i:= 0 to newSize0 do
  begin
     env^.DeleteLocalRef(env,jStrings[i]);
  end;

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
  SetLength(jStrings, 0);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jSqliteDataAccess_UpdateTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _updateQueries: TDynArrayOfString): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (_jsqlitedataaccess = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateTableBatch', '([Ljava/lang/String;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_updateQueries);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_updateQueries[i])));
  end;
  jParams[0].l:= jNewArray0;

  jBoo:= env^.CallBooleanMethodA(env, _jsqlitedataaccess, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jSqliteDataAccess_UpdateImageBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);
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
  if (env = nil) or (_jsqlitedataaccess = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateImageBatch', '([Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls);  goto _exceptionOcurred; end;

  newSize0:= Length(_imageResIdentifierDataArray);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls);  goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_imageResIdentifierDataArray[i])));
  end;
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls);  goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jSqliteDataAccess_ExecSQLBatchAsync(env: PJNIEnv; _jsqlitedataaccess: JObject; var _execSql: TDynArrayOfString);
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
  if (env = nil) or (_jsqlitedataaccess = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ExecSQLBatchAsync', '([Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_execSql);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));

  if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_execSql[i])));
  end;
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


   { jDBListView}

   function jDBListView_jCreate(env: PJNIEnv; _Self: int64; this: JObject): jObject;
   var
     jParams: array[0..0] of jValue;
     jMethod: jMethodID = nil;
     jCls: jClass = nil;
   label
    _exceptionOcurred;
   begin
     result := nil;

     if (env = nil) or (this = nil) then exit;

     jCls := Get_gjClass(env);
     if jCls = nil then goto _exceptionOcurred;
     jMethod := env^.GetMethodID(env, jCls, 'jDBListView_jCreate', '(J)Ljava/lang/Object;');
     if jMethod = nil then goto _exceptionOcurred;

     jParams[0].j := _Self;

     Result := env^.CallObjectMethodA(env, this, jMethod, @jParams);

     Result := env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
   end;

   procedure jDBListView_ChangeCursor(env:PJNIEnv; _jdblistview: jObject; Cursor: jObject);
   var
     jParams: array[0..0] of jValue;
     jMethod: jMethodID = nil;
     jCls: jClass = nil;
   label
    _exceptionOcurred;
   begin
     if (env = nil) or (_jdblistview = nil) then exit;

     jCls := env^.GetObjectClass(env, _jdblistview);
     if jCls = nil then goto _exceptionOcurred;
     jMethod := env^.GetMethodID(env, jCls, 'SetCursor', '(Landroid/database/Cursor;)V');
     if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     jParams[0].l:= Cursor;

     env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);

     env^.DeleteLocalRef(env, jCls);

     _exceptionOcurred: jni_ExceptionOccurred(env);
   end;

   procedure jDBListView_SetColumnWeights(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfSingle);
   var
     jParams: array[0..0] of jValue;
     jMethod: jMethodID = nil;
     jCls: jClass = nil;
     newSize0: integer;
     jNewArray0: jObject=nil;
   label
    _exceptionOcurred;
   begin
     if (env = nil) or (_jdblistview = nil) then exit;

     jCls := env^.GetObjectClass(env, _jdblistview);
     if jCls = nil then goto _exceptionOcurred;
     jMethod := env^.GetMethodID(env, jCls, 'SetColumnWeights', '([F)V');
     if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     newSize0:= Length(_value);
     jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate

     if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     env^.SetFloatArrayRegion(env, jNewArray0, 0, newSize0, @_value[0] {source});
     jParams[0].l:= jNewArray0;
     //DBListView_Log('Calling SetColumnWeights ... (last=' + FloatToStr(_value[newSize0-1]) + ')');

     env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);

     env^.DeleteLocalRef(env,jParams[0].l);
     env^.DeleteLocalRef(env, jCls); 

     _exceptionOcurred: jni_ExceptionOccurred(env);
   end;

   procedure jDBListView_SetColumnNames(env:PJNIEnv; _jdblistview: jObject; _value: TDynArrayOfString);
   var
     jParams: array[0..0] of jValue;
     jMethod: jMethodID=nil;
     jCls: jClass=nil;
     newSize0: integer;
     jNewArray0: jObject=nil;
     jStrings: array of jObject;
     i: integer;
   label
    _exceptionOcurred;
   begin
     if (env = nil) or (_jdblistview = nil) then exit;

     jCls:= env^.GetObjectClass(env, _jdblistview);
     if jCls = nil then goto _exceptionOcurred;
     jMethod:= env^.GetMethodID(env, jCls, 'SetColumnNames', '([Ljava/lang/String;)V');
     if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     jStrings := nil;
     newSize0:= Length(_value);
     SetLength(jStrings, newSize0+1);
     jStrings[newSize0] := env^.NewStringUTF(env, PChar(''));
     jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'), jStrings[newSize0]);

     if jNewArray0 = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

     for i:= 0 to newSize0 - 1 do
     begin
       jStrings[i] := env^.NewStringUTF(env, PChar(_value[i]));
       env^.SetObjectArrayElement(env,jNewArray0,i,jStrings[i]);
     end;
     jParams[0].l:= jNewArray0;

     env^.CallVoidMethodA(env, _jdblistview, jMethod, @jParams);

     for i:= 0 to newSize0 do
     begin
        env^.DeleteLocalRef(env,jStrings[i]);
     end;
     env^.DeleteLocalRef(env,jParams[0].l);
     env^.DeleteLocalRef(env, jCls);
     SetLength(jStrings, 0);

     _exceptionOcurred: jni_ExceptionOccurred(env);
   end;

{-------- jHttpClient_JNI_Bridge ----------}

function jHttpClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jHttpClient_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_GetCookieByIndex(env: PJNIEnv; _jhttpclient: JObject; _index: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookieByIndex', '(I)Ljava/net/HttpCookie;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _index;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_GetCookieAttributeValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _attribute: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookieAttributeValue', '(Ljava/net/HttpCookie;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_attribute));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_AddCookie(env: PJNIEnv; _jhttpclient: JObject; _name: string; _value: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddCookie', '(Ljava/lang/String;Ljava/lang/String;)Ljava/net/HttpCookie;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_value));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_IsExpired(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsExpired', '(Ljava/net/HttpCookie;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;

  jBoo:= env^.CallBooleanMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_IsCookiePersistent(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := false;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsCookiePersistent', '(Ljava/net/HttpCookie;)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;

  jBoo:= env^.CallBooleanMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jHttpClient_SetCookieValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _value: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetCookieValue', '(Ljava/net/HttpCookie;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_value));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_GetCookieByName(env: PJNIEnv; _jhttpclient: JObject; _cookieName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookieByName', '(Ljava/lang/String;)Ljava/net/HttpCookie;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_cookieName));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jHttpClient_SetCookieAttributeValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject; _attribute: string; _value: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetCookieAttributeValue', '(Ljava/net/HttpCookie;Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_attribute));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_value));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_GetCookieValue(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookieValue', '(Ljava/net/HttpCookie;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_GetCookieName(env: PJNIEnv; _jhttpclient: JObject; _cookie: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookieName', '(Ljava/net/HttpCookie;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _cookie;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_GetCookies(env: PJNIEnv; _jhttpclient: JObject; _nameValueSeparator: string): TDynArrayOfString;
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

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookies', '(Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_nameValueSeparator));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jhttpclient, jMethod,  @jParams);

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

function jHttpClient_GetCookies(env: PJNIEnv; _jhttpclient: JObject; _urlString: string; _nameValueSeparator: string): TDynArrayOfString;
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
  Result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCookies', '(Ljava/lang/String;Ljava/lang/String;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_urlString));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_nameValueSeparator));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jResultArray:= env^.CallObjectMethodA(env, _jhttpclient, jMethod,  @jParams);

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
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_AddCookie(env: PJNIEnv; _jhttpclient: JObject; _urlString: string; _name: string; _value: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddCookie', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/net/HttpCookie;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_urlString));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_value));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[1].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[0].l); env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_OpenConnection(env: PJNIEnv; _jhttpclient: JObject; _urlString: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'OpenConnection', '(Ljava/lang/String;)Ljava/net/HttpURLConnection;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_urlString));

  if jParams[0].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


function jHttpClient_SetRequestProperty(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetRequestProperty', '(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;)Ljava/net/HttpURLConnection;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_headerName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_headerValue));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env, jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_GetHeaderField(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetHeaderField', '(Ljava/net/HttpURLConnection;Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_headerName));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jParams[1].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_GetHeaderFields(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): TDynArrayOfString;
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

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetHeaderFields', '(Ljava/net/HttpURLConnection;)[Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;

  jResultArray:= env^.CallObjectMethodA(env, _jhttpclient, jMethod,  @jParams);

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


procedure jHttpClient_Disconnect(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '(Ljava/net/HttpURLConnection;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;

  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jHttpClient_Get(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Get', '(Ljava/net/HttpURLConnection;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jHttpClient_AddRequestProperty(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject; _headerName: string; _headerValue: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddRequestProperty', '(Ljava/net/HttpURLConnection;Ljava/lang/String;Ljava/lang/String;)Ljava/net/HttpURLConnection;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_headerName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_headerValue));

  if jParams[1].l = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  if jParams[2].l = nil then begin env^.DeleteLocalRef(env,jParams[1].l); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jHttpClient_Post(env: PJNIEnv; _jhttpclient: JObject; _httpConnection: jObject): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := '';

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Post', '(Ljava/net/HttpURLConnection;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _httpConnection;

  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jHttpClient_GetDefaultConnection(env: PJNIEnv; _jhttpclient: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (_jhttpclient = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetDefaultConnection', '()Ljava/net/HttpURLConnection;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jhttpclient, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jHttpClient_SetFollowRedirects(env: PJNIEnv; _jhttpclient: JObject; _followRedirects: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jhttpclient = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetFollowRedirects', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_followRedirects);
  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


  {-------jImageList-------}

function jImageList_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jImageList_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

//by jmpessoa
procedure jSend_Email(env:PJNIEnv; this:jobject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
var
 jMethod : jMethodID = nil;
 _jParams : array[0..4] of jValue;
 jCls: jClass=nil;
label
 _exceptionOcurred;
begin

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jSend_Email', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l := env^.NewStringUTF(env, pchar(sto) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(scc) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(sbcc) );
 _jParams[3].l := env^.NewStringUTF(env, pchar(ssubject) );
 _jParams[4].l := env^.NewStringUTF(env, pchar(smessage) );

 if _jParams[0].l = nil then begin goto _exceptionOcurred; end;
 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); goto _exceptionOcurred; end;
 if _jParams[2].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); goto _exceptionOcurred; end;
 if _jParams[3].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,_jParams[2].l); goto _exceptionOcurred; end;
 if _jParams[4].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); env^.DeleteLocalRef(env,_jParams[2].l); env^.DeleteLocalRef(env,_jParams[3].l); goto _exceptionOcurred; end;

 env^.CallVoidMethodA(env,this,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,_jParams[3].l);
 env^.DeleteLocalRef(env,_jParams[4].l);

 _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//by jmpessoa
function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage: string;
					   multipartMessage: Boolean): integer;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
 jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := 0;

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jSend_SMS', '(Ljava/lang/String;Ljava/lang/String;Z)I');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l := env^.NewStringUTF(env, pchar(toNumber) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(smessage) );
 _jParams[2].z := JBool(multipartMessage);

 if _jParams[0].l = nil then begin goto _exceptionOcurred; end;
 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); goto _exceptionOcurred; end;

 Result:= env^.CallIntMethodA(env,this,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage: string; 
					   packageDeliveredAction: string;
					   multipartMessage: Boolean): integer;
var
 jMethod : jMethodID = nil;
 _jParams : array[0..3] of jValue;
 jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := 0;

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jSend_SMS', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)I');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l := env^.NewStringUTF(env, pchar(toNumber) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(smessage) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(packageDeliveredAction) );
 _jParams[3].z := JBool(multipartMessage);

 if _jParams[0].l = nil then begin goto _exceptionOcurred; end;
 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); goto _exceptionOcurred; end;
 if _jParams[2].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); env^.DeleteLocalRef(env,_jParams[1].l); goto _exceptionOcurred; end;

 Result:= env^.CallIntMethodA(env,this,jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);;

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jRead_SMS(env:PJNIEnv; this:jobject; intentReceiver: jObject; addressBodyDelimiter: string): string;  //message
var
 jMethod  : jMethodID = nil;
 _jString  : jString;
 _jParams : array[0..1] of jValue;
 jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := '';

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jRead_SMS', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l :=  intentReceiver;
 _jParams[1].l := env^.NewStringUTF(env, pchar(addressBodyDelimiter) );

 if _jParams[1].l = nil then begin goto _exceptionOcurred; end;

 _jString   := env^.CallObjectMethodA(env,this,jMethod,@_jParams);

 Result:= GetPStringAndDeleteLocalRef(env, _jString);
 env^.DeleteLocalRef(env,_jParams[1].l);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


//by jmpessoa
function jContact_getMobileNumberByDisplayName(env:PJNIEnv; this:jobject;
                                               contactName: string): string;
begin
 Result:= jni_func_t_out_t(env, this, 'jContact_getMobileNumberByDisplayName', contactName);
end;

//by jmpessoa
function jContact_getDisplayNameList(env:PJNIEnv; this:jobject; delimiter: char): string;
var
 jMethod  : jMethodID = nil;
 _jString  : jString;
 _jParams : array[0..0] of jValue;
 jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := '';

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jContact_getDisplayNameList', '(C)Ljava/lang/String;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].c := jChar(delimiter);

 _jString   := env^.CallObjectMethodA(env,this,jMethod,@_jParams);

 Result:= GetPStringAndDeleteLocalRef(env, _jString);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

//by jmpessoa   - //Use: path =  App.Path.DCIM
                  //     filename = '/test.jpg'
function jCamera_takePhoto(env:PJNIEnv;  this:jobject; path: string; filename : String): string;
var
 jMethod: jMethodID = nil;
 _jParams: array[0..1] of jValue;
 _jString: jString;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := '';

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jCamera_takePhoto', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l:= env^.NewStringUTF(env, pchar(path) );
 _jParams[1].l:= env^.NewStringUTF(env, pchar(filename) );
 _jString:= env^.CallObjectMethodA(env,this,jMethod,@_jParams);

 if _jParams[0].l = nil then goto _exceptionOcurred;
 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); goto _exceptionOcurred; end;

 Result:= GetPStringAndDeleteLocalRef(env, _jString);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer; addToGallery: boolean): string; overload;
var
 jMethod: jMethodID = nil;
 _jParams: array[0..3] of jValue;
 _jString: jString;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 result := '';

 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'jCamera_takePhoto', '(Ljava/lang/String;Ljava/lang/String;IZ)Ljava/lang/String;');
 if jMethod = nil then goto _exceptionOcurred;

 _jParams[0].l := env^.NewStringUTF(env, pchar(path) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(filename) );
 _jParams[2].i := requestCode;
 _jParams[3].z := JBool(addToGallery);

 if _jParams[0].l = nil then goto _exceptionOcurred;
 if _jParams[1].l = nil then begin env^.DeleteLocalRef(env,_jParams[0].l); goto _exceptionOcurred; end;

 _jString:= env^.CallObjectMethodA(env,this,jMethod,@_jParams);

 Result:= GetPStringAndDeleteLocalRef(env, _jString);
 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer): string;
begin
  Result:= jCamera_takePhoto(env, this, path, filename, requestCode, True);
end;

//------------------------------------------------------------------------------
// jBenchMark
//------------------------------------------------------------------------------

//
// public float[] benchMark1 () {
// 	long start_time;
// 	long end_time;
// 	start_time = System.currentTimeMillis();
// 	//
// 	float value =3;
// 	int i = 0;
// 	for ( i = 0; i < 100000000; i++) {
// 		value = value * 2 / 3 + 5 - 1;
// 	};
// 	end_time = System.currentTimeMillis();
// 	Log.e("BenchMark1","Java : " + (end_time - start_time) + ", result" + value);
// 	//
// 	float[] vals = new float[2];
// 	vals[0] = end_time - start_time;
// 	vals[1] = value;
// 	return ( vals );
// }
Procedure jBenchMark1_Java  (env:PJNIEnv; this:jobject; var mSec : Integer;var value : single);
Var
 jMethod      : jMethodID = nil;
 _jFloatArray  : jFloatArray;
 _jBoolean     : jBoolean;
 PFloat        : PSingle;
 PFloatSav     : PSingle;
 jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 if (env = nil) or (this = nil) then exit;

 jCls:= Get_gjClass(env);
 if jCls = nil then goto _exceptionOcurred;
 jMethod:= env^.GetMethodID(env, jCls, 'benchMark1', '()[F');
 if jMethod = nil then goto _exceptionOcurred;

 _jFloatArray := env^.CallObjectMethod(env,this,jMethod);
 _jBoolean    := JNI_False;
 PFloat       := env^.GetFloatArrayElements(env,_jFloatArray,_jBoolean);
 PFloatSav    := PFloat;
 mSec         := Round(PFloat^); Inc(PFloat);
 value        := Round(PFloat^); Inc(PFloat);
 env^.ReleaseFloatArrayElements(env,_jFloatArray,PFloatSav,0);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

Procedure jBenchMark1_Pascal (env:PJNIEnv; this:jobject; var mSec : Integer;var value : single);
 Var
  StartTime,EndTime : LongInt;
  i                 : Integer;
 begin
  StartTime := jgetTick(env,this);
  value     := 30;
  i         := 0;
  for i := 0 to 100000000-1 do
   value := value * 2/ 3 + 5 - 1;
  EndTime   := jgetTick(env,this);
  dbg( IntToStr( EndTime - StartTime) + ' Result:' + FloatToStr(value) );
  //
  mSec := EndTime - StartTime;
 end;

initialization    //commented by jmpessoa
{ gDbgMode    := True;
 gjAppName   := 'com.example.appx';
 gjClassName := 'com/example/appx/Controls';
 }
end.
