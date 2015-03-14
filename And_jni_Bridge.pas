//------------------------------------------------------------------------------
//
// Android JNI Interface for Pascal/Delphi

//   [Lazarus Support by jmpessoa@hotmail.com - december 2013]
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

// System
Procedure jSystem_GC                   (env:PJNIEnv;this:jobject);

//by jmpessoa
Procedure jSystem_GC2                   (env:PJNIEnv;this:jobject);


// Class
Procedure jClass_setNull               (env:PJNIEnv;this:jobject; ClassObj : jClass);
Procedure jClass_chkNull               (env:PJNIEnv;this:jobject; ClassObj : jClass);

// Asset
Function  jAsset_SaveToFile            (env:PJNIEnv; this:jobject; src,dst:String) : Boolean;
//
//

// Image
Function  jImage_getWH                 (env:PJNIEnv;this:jobject; filename : String ) : TWH;
Function  jImage_resample              (env:PJNIEnv;this:jobject; filename : String; size : integer ) : jObject;
Procedure jImage_save                  (env:PJNIEnv;this:jobject; Bitmap : jObject; filename : String);

//------------------------
// TextView   :: changed by jmpessoa [support Api > 13]
//-----------------------

Function  jTextView_Create(env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;
Procedure jTextView_Free(env:PJNIEnv; TextView : jObject);

Procedure jTextView_setEnabled(env:PJNIEnv; TextView : jObject; enabled : Boolean);
Procedure jTextView_setParent(env:PJNIEnv; TextView : jObject; ViewGroup : jObject);

Function  jTextView_getText(env:PJNIEnv; TextView : jObject) : String;
Procedure jTextView_setText(env:PJNIEnv; TextView : jObject; Str : String);

Procedure jTextView_setTextColor(env:PJNIEnv; TextView : jObject; color : DWord);
Procedure jTextView_setTextSize(env:PJNIEnv; TextView : jObject; size  : DWord);

Procedure jTextView_SetTextTypeFace(env:PJNIEnv; TextView : jObject; textStyle: DWord);

procedure jTextView_setFontAndTextTypeFace(env: PJNIEnv; TextView: jObject; FontFace, TextTypeFace: DWord); 

Procedure jTextView_setTextAlignment(env:PJNIEnv; TextView : jObject; align : DWord);

Procedure jTextView_setLParamWidth(env:PJNIEnv; TextView : jObject; w: DWord);
Procedure jTextView_setLParamHeight(env:PJNIEnv; TextView : jObject; h: DWord);

Procedure jTextView_addLParamsParentRule(env:PJNIEnv; TextView : jObject; rule: DWord);
Procedure jTextView_addLParamsAnchorRule(env:PJNIEnv; TextView : jObject; rule: DWord);

Procedure jTextView_setLayoutAll(env:PJNIEnv; TextView : jObject; idAnchor: DWord);

Procedure jTextView_setId(env:PJNIEnv; TextView : jObject; id: DWord);

Procedure jTextView_setLeftTopRightBottomWidthHeight(env:PJNIEnv; TextView : jObject; ml,mt,mr,mb,w,h: integer);

procedure jTextView_Append(env: PJNIEnv; _jtextview: JObject; _txt: string);

//-----------------------------------
// EditText  :: changed by jmpessoa [support Api > 13]
//--------------------------------------

Function  jEditText_Create             (env:PJNIEnv; this:jobject; SelfObj: TObject ): jObject;
Procedure jEditText_Free               (env:PJNIEnv; EditText: jObject);

Procedure jEditText_setParent(env:PJNIEnv;  EditText: jObject; ViewGroup: jObject);

Function  jEditText_getText            (env:PJNIEnv; EditText : jObject) : String;

Procedure jEditText_setText            (env:PJNIEnv; EditText : jObject; Str : String);

Procedure jEditText_setTextColor       (env:PJNIEnv; EditText : jObject; color : DWord);
Procedure jEditText_setTextSize        (env:PJNIEnv; EditText : jObject; size  : DWord);

Procedure jEditText_setHint            (env:PJNIEnv; EditText : jObject; Str : String);

procedure jEditText_setHintTextColor(env: PJNIEnv; _jedittext: JObject; _color: integer);

Procedure jEditText_SetFocus          (env:PJNIEnv; EditText : jObject);

Procedure jEditText_immShow            (env:PJNIEnv; EditText : jObject );
Procedure jEditText_immHide            (env:PJNIEnv; EditText : jObject );

Procedure jEditText_editInputType2      (env:PJNIEnv; EditText : jObject; Str : String);

Procedure jEditText_setInputType(env:PJNIEnv;  EditText: jObject; itType: DWord);

Procedure jEditText_maxLength          (env:PJNIEnv; EditText : jObject; size  : integer);

Procedure jEditText_AllCaps(env:PJNIEnv; EditText : jObject);

Procedure jEditText_DispatchOnChangeEvent(env:PJNIEnv; EditText : jObject; value: boolean);
Procedure jEditText_DispatchOnChangedEvent(env:PJNIEnv; EditText : jObject; value: boolean);

Procedure jEditText_setMaxLines(env:PJNIEnv; EditText : jObject; max: DWord);

Procedure jEditText_setLParamWidth(env:PJNIEnv; EditText : jObject; w: DWord);
Procedure jEditText_setLParamHeight(env:PJNIEnv; EditText : jObject; h: DWord);
Procedure jEditText_addLParamsParentRule(env:PJNIEnv; EditText : jObject; rule: DWord);
Procedure jEditText_addLParamsAnchorRule(env:PJNIEnv; EditText : jObject; rule: DWord);
Procedure jEditText_setLayoutAll(env:PJNIEnv; EditText : jObject; idAnchor: DWord);
Procedure jEditText_setId(env:PJNIEnv; EditText : jObject; id: DWord);

Procedure jEditText_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        EditText : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jEditText_setSingleLine(env:PJNIEnv; EditText : jObject; isSingle  : boolean);

Procedure jEditText_setHorizontallyScrolling(env:PJNIEnv; EditText : jObject; wrapping: boolean);
Procedure jEditText_setVerticalScrollBarEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
Procedure jEditText_setHorizontalScrollBarEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
Procedure jEditText_setScrollbarFadingEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
Procedure  jEditText_setScroller(env:PJNIEnv;  EditText: jObject);
Procedure jEditText_setScrollBarStyle(env:PJNIEnv; EditText : jObject; style  : DWord);
Procedure jEditText_setMovementMethod(env:PJNIEnv; EditText : jObject);

Procedure jEditText_GetCursorPos       (env:PJNIEnv; EditText : jObject; Var x,y : Integer);
Procedure jEditText_SetCursorPos       (env:PJNIEnv; EditText : jObject; startPos, endPos : Integer);

Procedure jEditText_setTextAlignment   (env:PJNIEnv; EditText : jObject; align : DWord);

Procedure jEditText_SetEnabled         (env:PJNIEnv; EditText : jObject; enabled : Boolean);
Procedure jEditText_SetEditable        (env:PJNIEnv; EditText : jObject; enabled : Boolean);
procedure jEditText_Append(env: PJNIEnv; _jedittext: JObject; _txt: string);

procedure jEditText_SetImeOptions(env: PJNIEnv; _jedittext: JObject; _imeOption: integer);

procedure jEditText_setFontAndTextTypeFace(env: PJNIEnv; EditText: jObject; FontFace, TextTypeFace: DWord); 

procedure jEditText_SetAcceptSuggestion(env: PJNIEnv; _jedittext: JObject; _value: boolean);
procedure jEditText_CopyToClipboard(env: PJNIEnv; _jedittext: JObject);
procedure jEditText_PasteFromClipboard(env: PJNIEnv; _jedittext: JObject);

// Button
Function jButton_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject): jObject;
Procedure jButton_Free(env:PJNIEnv; Button : jObject);

Procedure jButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        Button : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jButton_setParent(env:PJNIEnv; Button : jObject;ViewGroup : jObject);
//by jmpessoa
Procedure jButton_setText(env:PJNIEnv; Button : jObject; Str : String);

Function jButton_getText(env:PJNIEnv; Button : jObject) : String;


Procedure jButton_setTextColor(env:PJNIEnv; Button : jObject; color : DWord);
Procedure jButton_setTextSize(env:PJNIEnv; Button : jObject; size  : DWord);

//by jmpessoa
Procedure jButton_addLParamsParentRule(env:PJNIEnv; Button : jObject; rule: DWord);
Procedure jButton_addLParamsAnchorRule(env:PJNIEnv; Button : jObject; rule: DWord);

Procedure jButton_setLayoutAll(env:PJNIEnv; Button : jObject;  idAnchor: DWord);

Procedure jButton_setLParamWidth(env:PJNIEnv; Button : jObject; w: DWord);

Procedure jButton_setLParamHeight(env:PJNIEnv; Button : jObject; h: DWord);

Procedure jButton_setId(env:PJNIEnv; Button : jObject; id: DWord);
Procedure jButton_setFocusable(env:PJNIEnv; Button : jObject; enabled: boolean);


// CheckBox
Function  jCheckBox_Create            (env:PJNIEnv;  this:jobject; SelfObj: TObject ): jObject;
Procedure jCheckBox_Free               (env:PJNIEnv; CheckBox : jObject);
Procedure jCheckBox_setParent          (env:PJNIEnv;
                                        CheckBox : jObject; ViewGroup : jObject);
Function  jCheckBox_getText            (env:PJNIEnv; CheckBox : jObject) : String;

Procedure jCheckBox_setText            (env:PJNIEnv; CheckBox : jObject; Str : String);

Procedure jCheckBox_setTextColor       (env:PJNIEnv; CheckBox : jObject; color : DWord);

Procedure jCheckBox_setTextSize(env:PJNIEnv; CheckBox : jObject; size : DWord);

Function  jCheckBox_isChecked(env:PJNIEnv; CheckBox : jObject) : Boolean;
Procedure jCheckBox_setChecked(env:PJNIEnv; CheckBox : jObject; value : Boolean);

Procedure jCheckBox_setId(env:PJNIEnv;  CheckBox : jObject; id: DWord);

Procedure jCheckBox_setLParamWidth(env:PJNIEnv; CheckBox : jObject; w: DWord);
Procedure jCheckBox_setLParamHeight(env:PJNIEnv; CheckBox : jObject; h: DWord);
Procedure jCheckBox_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        CheckBox : jObject; ml,mt,mr,mb,w,h: integer);
Procedure jCheckBox_addLParamsParentRule(env:PJNIEnv; CheckBox : jObject; rule: DWord);
Procedure jCheckBox_addLParamsAnchorRule(env:PJNIEnv; CheckBox : jObject; rule: DWord);
Procedure jCheckBox_setLayoutAll(env:PJNIEnv; CheckBox : jObject;  idAnchor: DWord);

// RadioButton

Function  jRadioButton_Create(env:PJNIEnv; this:jobject; SelfObj: TObject ): jObject;
Procedure jRadioButton_Free(env:PJNIEnv; RadioButton : jObject);
Procedure jRadioButton_setParent(env:PJNIEnv; RadioButton : jObject;ViewGroup : jObject);

Function  jRadioButton_getText(env:PJNIEnv; RadioButton : jObject) : String;

Procedure jRadioButton_setText(env:PJNIEnv; RadioButton : jObject; Str : String);

Procedure jRadioButton_setTextColor(env:PJNIEnv; RadioButton : jObject; color : DWord);
Procedure jRadioButton_setTextSize(env:PJNIEnv; RadioButton : jObject; size  : DWord);

Function  jRadioButton_isChecked(env:PJNIEnv; RadioButton : jObject) : Boolean;
Procedure jRadioButton_setChecked(env:PJNIEnv; RadioButton : jObject; value : Boolean);

Procedure jRadioButton_setId(env:PJNIEnv; RadioButton : jObject; id: DWord);

Procedure jRadioButton_setLParamWidth(env:PJNIEnv; RadioButton : jObject; w: DWord);
Procedure jRadioButton_setLParamHeight(env:PJNIEnv; RadioButton : jObject; h: DWord);

Procedure jRadioButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        RadioButton : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jRadioButton_addLParamsParentRule(env:PJNIEnv; RadioButton : jObject; rule: DWord);
Procedure jRadioButton_addLParamsAnchorRule(env:PJNIEnv; RadioButton : jObject; rule: DWord);
Procedure jRadioButton_setLayoutAll(env:PJNIEnv; RadioButton : jObject;  idAnchor: DWord);

// ProgressBar

//by jmpessoa
Function  jProgressBar_Create          (env:PJNIEnv;  this:jobject; SelfObj: TObject; Style: DWord ): jObject;

Procedure jProgressBar_Free            (env:PJNIEnv; ProgressBar : jObject);
//
Procedure jProgressBar_setParent       (env:PJNIEnv;
                                        ProgressBar : jObject;ViewGroup : jObject);


//by jmpessoa
Function  jProgressBar_getProgress     (env:PJNIEnv; ProgressBar : jObject) : Integer;

//by jmpessoa
Procedure jProgressBar_setProgress     (env:PJNIEnv; ProgressBar : jObject; value : integer);

//by jmpessoa
Procedure jProgressBar_setMax          (env:PJNIEnv; ProgressBar : jObject; value : integer);
Function  jProgressBar_getMax          (env:PJNIEnv; ProgressBar : jObject) : Integer;


//by jmpessoa
Procedure jProgressBar_setId(env:PJNIEnv; ProgressBar : jObject; id: DWord);


Procedure jProgressBar_setLParamWidth(env:PJNIEnv; ProgressBar : jObject; w: DWord);
Procedure jProgressBar_setLParamHeight(env:PJNIEnv; ProgressBar : jObject; h: DWord);

Procedure jProgressBar_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ProgressBar : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jProgressBar_addLParamsParentRule(env:PJNIEnv; ProgressBar : jObject; rule: DWord);
Procedure jProgressBar_addLParamsAnchorRule(env:PJNIEnv; ProgressBar : jObject; rule: DWord);
Procedure jProgressBar_setLayoutAll(env:PJNIEnv; ProgressBar : jObject;  idAnchor: DWord);

//JImageView
Function  jImageView_Create            (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

Procedure jImageView_Free              (env:PJNIEnv; ImageView : jObject);
//
Procedure jImageView_setParent         (env:PJNIEnv;
                                        ImageView : jObject;ViewGroup : jObject);

Procedure jImageView_setImage          (env:PJNIEnv;
                                        ImageView : jObject; Str : String);

Procedure jImageView_setBitmapImage(env:PJNIEnv;
                                    ImageView : jObject; bitmap : jObject);

Procedure jImageView_SetImageByResIdentifier(env:PJNIEnv; ImageView : jObject; _imageResIdentifier: string);

//by jmpessoa
Procedure jImageView_setLParamWidth(env:PJNIEnv; ImageView : jObject; w: DWord);
Procedure jImageView_setLParamHeight(env:PJNIEnv; ImageView : jObject; h: DWord);

//by jmpessoa
Procedure jImageView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ImageView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jImageView_addLParamsParentRule(env:PJNIEnv; ImageView : jObject; rule: DWord);
Procedure jImageView_addLParamsAnchorRule(env:PJNIEnv; ImageView : jObject; rule: DWord);

Procedure jImageView_setLayoutAll(env:PJNIEnv; ImageView : jObject;  idAnchor: DWord);

//by jmpessoa
function jImageView_getLParamHeight(env:PJNIEnv; ImageView : jObject ): integer;
function jImageView_getLParamWidth(env:PJNIEnv; ImageView : jObject): integer;

function jImageView_GetBitmapHeight(env:PJNIEnv; ImageView : jObject ): integer;
function jImageView_GetBitmapWidth(env:PJNIEnv; ImageView : jObject): integer;

Procedure jImageView_setId(env:PJNIEnv; ImageView : jObject; id: DWord);

procedure jImageView_SetImageMatrixScale(env: PJNIEnv; _jimageview: JObject; _scaleX: single; _scaleY: single);

procedure jImageView_SetScaleType(env: PJNIEnv; _jimageview: JObject; _scaleType: integer);

function jImageView_GetBitmapImage(env: PJNIEnv; _jimageview: JObject): jObject;

// ListView
Function  jListView_Create2             (env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string; image: jObject;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer; txtAlign: integer): jObject;

Function  jListView_Create3             (env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer; txtAlign: integer): jObject;


Procedure jListView_Free               (env:PJNIEnv; ListView : jObject);
//


Procedure jListView_setParent          (env:PJNIEnv;
                                        ListView : jObject;ViewGroup : jObject);

Procedure jListView_setTextColor2       (env:PJNIEnv; ListView : jObject; color : DWord; index: integer);
Procedure jListView_setTextColor       (env:PJNIEnv; ListView : jObject; color : DWord);

Procedure jListView_setTextSize2        (env:PJNIEnv; ListView : jObject; size  : DWord; index: integer);
Procedure jListView_setTextSize        (env:PJNIEnv; ListView : jObject; size  : DWord);

Procedure jListView_setItemPosition    (env:PJNIEnv;
                                        ListView : jObject; Pos: integer; y:Integer );
//
Procedure jListView_add                (env:PJNIEnv;  this:jobject;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer; hasWidgetItem: integer);
//by jmpessoa
Procedure jListView_add2(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string);

Procedure jListView_add22(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string; image: jObject);

Procedure jListView_add3                (env:PJNIEnv;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer;
                                        widgetItem: integer; widgetText: string; image: jObject);

Procedure jListView_add4                (env:PJNIEnv;
                                        ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer;
                                        widgetItem: integer; widgetText: string);

//by jmpessoa
Procedure jListView_clear              (env:PJNIEnv;
                                        ListView : jObject);

//by jmpessoa
Procedure jListView_delete             (env:PJNIEnv;
                                        ListView : jObject; index : integer);

//by jmpessoa
Procedure jListView_setId(env:PJNIEnv; ListView : jObject; id: DWord);

Procedure jListView_setWidgetItem(env:PJNIEnv; ListView : jObject; value: integer);

Procedure jListView_setWidgetItem2(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
Procedure jListView_setWidgetItem3(env:PJNIEnv; ListView : jObject; value: integer; txt: string; index: integer);

Procedure jListView_setWidgetText(env:PJNIEnv; ListView : jObject; txt: string; index: integer);

Procedure jListView_setTextDecorated(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
Procedure jListView_setTextSizeDecorated(env:PJNIEnv; ListView : jObject; value: integer; index:integer);

Procedure jListView_setItemLayout(env:PJNIEnv; ListView : jObject; value: integer; index: integer);


Procedure jListView_setImageItem(env:PJNIEnv; ListView : jObject; bitmap: jObject; index: integer); overload;
Procedure jListView_setImageItem(env:PJNIEnv; ListView : jObject; imgResIdentifier: string; index: integer); overload;

Procedure jListView_setTextAlign(env:PJNIEnv; ListView : jObject; value: integer; index: integer);

function jListView_IsItemChecked(env:PJNIEnv; ListView : jObject; index: integer): boolean;

function jListView_GetItemText(env:PJNIEnv; ListView : jObject; index: integer): string;
function jListView_GetCount(env:PJNIEnv; ListView : jObject): integer;

Procedure jListView_setLParamWidth(env:PJNIEnv; ListView : jObject; w: DWord);
Procedure jListView_setLParamHeight(env:PJNIEnv; ListView : jObject; h: DWord);

Procedure jListView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ListView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jListView_addLParamsParentRule(env:PJNIEnv; ListView : jObject; rule: DWord);
Procedure jListView_addLParamsAnchorRule(env:PJNIEnv; ListView : jObject; rule: DWord);

Procedure jListView_setLayoutAll(env:PJNIEnv; ListView : jObject;  idAnchor: DWord);

procedure jListView_SetHighLightSelectedItem(env: PJNIEnv; _jlistview: JObject; _value: boolean);
procedure jListView_SetHighLightSelectedItemColor(env: PJNIEnv;  _jlistview: JObject; _color: integer);


// ScrollView
Function  jScrollView_Create           (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

Procedure jScrollView_Free           (env:PJNIEnv; ScrollView : jObject);
//
Procedure jScrollView_setParent        (env:PJNIEnv;
                                        ScrollView : jObject;ViewGroup : jObject);

Procedure jScrollView_setScrollSize    (env:PJNIEnv;
                                        ScrollView : jObject; size : integer);

Function  jScrollView_getView          (env:PJNIEnv;
                                        ScrollView : jObject) : jObject;
//by jmpessoa
Procedure jScrollView_setId(env:PJNIEnv; ScrollView : jObject; id: DWord);

Procedure jScrollView_setLParamWidth(env:PJNIEnv; ScrollView : jObject; w: DWord);
Procedure jScrollView_setLParamHeight(env:PJNIEnv; ScrollView : jObject; h: DWord);

Procedure jScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jScrollView_addLParamsParentRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
Procedure jScrollView_addLParamsAnchorRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
Procedure jScrollView_setLayoutAll(env:PJNIEnv; ScrollView : jObject;  idAnchor: DWord);
//---------------

// jPanel by jmpessoa
Function  jPanel_Create           (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;
Procedure jPanel_Free             (env:PJNIEnv; Panel : jObject);
Procedure jPanel_setParent        (env:PJNIEnv;
                                        Panel : jObject;ViewGroup : jObject);

Function  jPanel_getView          (env:PJNIEnv;
                                        Panel : jObject) : jObject;

//by jmpessoa
Procedure jPanel_setId(env:PJNIEnv; Panel : jObject; id: DWord);

Procedure jPanel_setLParamWidth(env:PJNIEnv; Panel : jObject; w: DWord);
Procedure jPanel_setLParamHeight(env:PJNIEnv; Panel : jObject; h: DWord);

Procedure jPanel_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        Panel : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jPanel_resetLParamsRules(env:PJNIEnv; Panel : jObject);

Procedure jPanel_addLParamsParentRule(env:PJNIEnv; Panel : jObject; rule: DWord);

Procedure jPanel_addLParamsAnchorRule(env:PJNIEnv; Panel : jObject; rule: DWord);

Procedure jPanel_setLayoutAll(env:PJNIEnv; Panel : jObject;  idAnchor: DWord);

Procedure jPanel_RemoveParent(env:PJNIEnv; Panel : jObject);

function jPanel_getLParamHeight(env:PJNIEnv; Panel : jObject ): integer;
function jPanel_getLParamWidth(env:PJNIEnv; Panel : jObject): integer;

procedure jPanel_SetMinZoomFactor(env: PJNIEnv; _jpanel: JObject; _minZoomFactor: single);
procedure jPanel_SetMaxZoomFactor(env: PJNIEnv; _jpanel: JObject; _maxZoomFactor: single);

//-----------------
// HorizontalScrollView
//by jmpessoa
function jHorizontalScrollView_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject): jObject;

Procedure jHorizontalScrollView_Free          (env:PJNIEnv; ScrollView : jObject);
Procedure jHorizontalScrollView_setParent     (env:PJNIEnv;
                                               ScrollView : jObject;ViewGroup : jObject);

Procedure jHorizontalScrollView_setScrollSize (env:PJNIEnv;
                                               ScrollView : jObject; size : integer);

Function  jHorizontalScrollView_getView       (env:PJNIEnv;
                                               ScrollView : jObject) : jObject;

//by jmpessoa
Procedure jHorizontalScrollView_setId(env:PJNIEnv; ScrollView : jObject; id: DWord);

Procedure jHorizontalScrollView_setLParamWidth(env:PJNIEnv; ScrollView : jObject; w: DWord);
Procedure jHorizontalScrollView_setLParamHeight(env:PJNIEnv; ScrollView : jObject; h: DWord);

Procedure jHorizontalScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jHorizontalScrollView_addLParamsParentRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
Procedure jHorizontalScrollView_addLParamsAnchorRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
Procedure jHorizontalScrollView_setLayoutAll(env:PJNIEnv; ScrollView : jObject;  idAnchor: DWord);

// ViewFlipper
Function  jViewFlipper_Create          (env:PJNIEnv;  this:jobject; SelfObj: TObject ): jObject;

Procedure jViewFlipper_Free            (env:PJNIEnv; ViewFlipper : jObject);
Procedure jViewFlipper_setParent       (env:PJNIEnv;
                                        ViewFlipper : jObject;ViewGroup : jObject);

//by jmpessoa
Procedure jViewFlipper_setId(env:PJNIEnv; ViewFlipper : jObject; id: DWord);

Procedure jViewFlipper_setLParamWidth(env:PJNIEnv; ViewFlipper : jObject; w: DWord);
Procedure jViewFlipper_setLParamHeight(env:PJNIEnv; ViewFlipper : jObject; h: DWord);

Procedure jViewFlipper_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ViewFlipper : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jViewFlipper_addLParamsParentRule(env:PJNIEnv; ViewFlipper : jObject; rule: DWord);
Procedure jViewFlipper_addLParamsAnchorRule(env:PJNIEnv; ViewFlipper : jObject; rule: DWord);

Procedure jViewFlipper_setLayoutAll(env:PJNIEnv; ViewFlipper : jObject;  idAnchor: DWord);

// WebView
Function  jWebView_Create              (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

Procedure jWebView_Free               (env:PJNIEnv; WebView : jObject);

Procedure jWebView_setParent           (env:PJNIEnv;
                                        WebView : jObject;ViewGroup : jObject);

Procedure jWebView_setJavaScript       (env:PJNIEnv;
                                        WebView : jObject; javascript : boolean);

procedure jWebView_SetZoomControl(env: PJNIEnv; WebView: jObject; ZoomControl: Boolean);

Procedure jWebView_loadURL(env:PJNIEnv; WebView : jObject; Str : String);

Procedure jWebView_setId(env:PJNIEnv; WebView : jObject; id: DWord);

Procedure jWebView_setLParamWidth(env:PJNIEnv; WebView : jObject; w: DWord);
Procedure jWebView_setLParamHeight(env:PJNIEnv; WebView : jObject; h: DWord);

Procedure jWebView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        WebView: jObject; ml,mt,mr,mb,w,h: integer);

Procedure jWebView_addLParamsParentRule(env:PJNIEnv; WebView : jObject; rule: DWord);
Procedure jWebView_addLParamsAnchorRule(env:PJNIEnv; WebView : jObject; rule: DWord);
Procedure jWebView_setLayoutAll(env:PJNIEnv; WebView : jObject;  idAnchor: DWord);
procedure jWebView_SetHttpAuthUsernamePassword(env: PJNIEnv; _jwebview: JObject; _hostName: string; _hostDomain: string; _username: string; _password: string);


// Canvas
Function  jCanvas_Create               (env:PJNIEnv;
                                        this:jobject; SelfObj : TObject) : jObject;

Procedure jCanvas_Free                 (env:PJNIEnv; Canv : jObject);
//
Procedure jCanvas_setStrokeWidth      (env:PJNIEnv;
                                        Canv : jObject;width : single);

Procedure jCanvas_setStyle             (env:PJNIEnv;
                                        Canv : jObject; style : integer);

Procedure jCanvas_setColor             (env:PJNIEnv;
                                        Canv : jObject; color : DWord  );

Procedure jCanvas_setTextSize          (env:PJNIEnv;
                                        Canv : jObject; textsize : single);
Procedure jCanvas_drawLine             (env:PJNIEnv;
                                        Canv : jObject; x1,y1,x2,y2 : single);
// LORDMAN 2013-08-13
Procedure jCanvas_drawPoint           (env:PJNIEnv; Canv:jObject; x1,y1:single);

Procedure jCanvas_drawText             (env:PJNIEnv;
                                        Canv : jObject; const text : string; x,y : single);

Procedure jCanvas_drawBitmap           (env:PJNIEnv;
                                        Canv : jObject; bmp : jObject; b,l,r,t : integer);
// Bitmap
Function  jBitmap_Create               (env:PJNIEnv;
                                        this:jobject; SelfObj : TObject) : jObject;

Procedure jBitmap_Free                 (env:PJNIEnv; bmap : jObject);

Procedure jBitmap_loadRes             (env:PJNIEnv;
                                        bmap : jObject; imgResIdentifier : String);
Procedure jBitmap_loadFile             (env:PJNIEnv;
                                        bmap : jObject; filename : String);

Procedure jBitmap_createBitmap         (env:PJNIEnv;
                                        bmap : jObject; w,h : integer);

//by jmpessoa
Procedure jBitmap_getWH                (env:PJNIEnv;
                                        bmap : jObject; var w,h : integer);

function jBitmap_GetWidth(env: PJNIEnv; bmap: JObject): integer;
function jBitmap_GetHeight(env: PJNIEnv; bmap: JObject): integer;

Function  jBitmap_jInstance(env:PJNIEnv;  bmap: jObject): jObject;

function jBitmap_ClockWise(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject): jObject;
function jBitmap_AntiClockWise(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject): jObject;

function jBitmap_SetScale(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject; overload;
function jBitmap_SetScale(env: PJNIEnv; _jbitmap: JObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject; overload;
function jBitmap_LoadFromAssets(env: PJNIEnv; _jbitmap: JObject; strName: string): jObject;
//by jmpessoa
function jBitmap_GetByteArrayFromBitmap(env:PJNIEnv;  bmap: jObject;
                                                   var bufferImage: TArrayOfByte): integer;
//by jmpessoa
procedure jBitmap_SetByteArrayToBitmap(env:PJNIEnv;  bmap: jObject; var bufferImage: TArrayOfByte; size: integer);

function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _newWidth: integer; _newHeight: integer): jObject; overload;
function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _newWidth: integer; _newHeight: integer): jObject; overload;
function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _factorScaleX: single; _factorScaleY: single): jObject; overload;

//GLSurfaceView
Function  jGLSurfaceView_Create       (env:PJNIEnv;  this:jobject; SelfObj: TObject; version: integer): jObject;
Procedure jGLSurfaceView_Free          (env:PJNIEnv; GLSurfaceView : jObject);
//
Procedure jGLSurfaceView_setParent     (env:PJNIEnv;
                                        GLSurfaceView: jObject;ViewGroup : jObject);

Procedure jGLSurfaceView_SetAutoRefresh(env:PJNIEnv; glView : jObject; Active : Boolean);

Procedure jGLSurfaceView_Refresh       (env:PJNIEnv; glView : jObject);

Procedure jGLSurfaceView_deleteTexture (env:PJNIEnv; glView : jObject; id : Integer);

Procedure jGLSurfaceView_getBmpArray   (env:PJNIEnv; this:jobject;filename: String);

Procedure jGLSurfaceView_requestGLThread(env:PJNIEnv; glView : jObject);

//by jmpessoa
Procedure jGLSurfaceView_setId(env:PJNIEnv; GLSurfaceView : jObject; id: DWord);

Procedure jGLSurfaceView_setLParamWidth(env:PJNIEnv; GLSurfaceView : jObject; w: DWord);
Procedure jGLSurfaceView_setLParamHeight(env:PJNIEnv; GLSurfaceView : jObject; h: DWord);

function jGLSurfaceView_getLParamHeight(env:PJNIEnv; GLSurfaceView : jObject): integer;
function jGLSurfaceView_getLParamWidth(env:PJNIEnv; GLSurfaceView : jObject): integer;

Procedure jGLSurfaceView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        GLSurfaceView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jGLSurfaceView_addLParamsParentRule(env:PJNIEnv; GLSurfaceView : jObject; rule: DWord);
Procedure jGLSurfaceView_addLParamsAnchorRule(env:PJNIEnv; GLSurfaceView : jObject; rule: DWord);
Procedure jGLSurfaceView_setLayoutAll(env:PJNIEnv; GLSurfaceView : jObject;  idAnchor: DWord);


//by jmpessoa
Function  jView_Create                 (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;


//View
Procedure jView_Free                   (env:PJNIEnv; View : jObject);



Procedure jView_setParent              (env:PJNIEnv;
                                        View : jObject;ViewGroup : jObject);

Procedure jView_setjCanvas             (env:PJNIEnv;
                                        View : jObject;jCanv   : jObject);

Procedure jView_viewSave               (env:PJNIEnv;
                                        View : jObject; Filename: String );
//by jmpessoa
Procedure jView_setId(env:PJNIEnv; View : jObject; id: DWord);

Procedure jView_setLParamWidth(env:PJNIEnv; View : jObject; w: DWord);
Procedure jView_setLParamHeight(env:PJNIEnv; View : jObject; h: DWord);

Procedure jView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        View : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jView_addLParamsParentRule(env:PJNIEnv; View : jObject; rule: DWord);
Procedure jView_addLParamsAnchorRule(env:PJNIEnv; View : jObject; rule: DWord);

Procedure jView_setLayoutAll(env:PJNIEnv; View : jObject;  idAnchor: DWord);

function jView_getLParamHeight(env:PJNIEnv; View : jObject ): integer;
function jView_getLParamWidth(env:PJNIEnv; View : jObject): integer;



// Timer
Function  jTimer_Create                (env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;

Procedure jTimer_Free                  (env:PJNIEnv; Timer  : jObject);

Procedure jTimer_SetInterval         (env:PJNIEnv; Timer  : jObject; Interval : Integer);

Procedure jTimer_SetEnabled            (env:PJNIEnv; Timer  : jObject; Active   : Boolean);

// Dialog YN
Function  jDialogYN_Create             (env:PJNIEnv; this:jobject; SelfObj : TObject;
                                        title,msg,y,n : string ): jObject;
Procedure jDialogYN_Free               (env:PJNIEnv; DialogYN: jObject);

Procedure jDialogYN_Show               (env:PJNIEnv; DialogYN: jObject);

// Dialog Progress
Function  jDialogProgress_Create       (env:PJNIEnv; this:jobject; SelfObj : TObject;
                                        title,msg : string ): jObject;

Procedure jDialogProgress_Free         (env:PJNIEnv; DialogProgress : jObject);

// Toast
Procedure jToast                       (env:PJNIEnv; this:jobject;Str : String);

// ImageBtn
Function  jImageBtn_Create             (env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;

Procedure jImageBtn_Free               (env:PJNIEnv; ImageBtn : jObject);

Procedure jImageBtn_setParent          (env:PJNIEnv;
                                        ImageBtn : jObject;ViewGroup : jObject);
Procedure jImageBtn_setButton          (env:PJNIEnv;
                                        ImageBtn : jObject;up,dn : String);
//by jmpessoa
Procedure jImageBtn_setButtonUp        (env:PJNIEnv;
                                        ImageBtn : jObject; up: String);

//by jmpessoa
Procedure jImageBtn_setButtonDown       (env:PJNIEnv;
                                        ImageBtn : jObject; dn: String);

//by jmpessoa
Procedure jImageBtn_setButtonDownByRes       (env:PJNIEnv;
                                        ImageBtn : jObject; imgResIdentifief: String);
//by jmpessoa
Procedure jImageBtn_setButtonUpByRes       (env:PJNIEnv;
                                        ImageBtn : jObject; imgResIdentifief: String);


Procedure jImageBtn_SetEnabled         (env:PJNIEnv;
                                        ImageBtn : jObject; Active : Boolean);
//by jmpessoa
Procedure jImageBtn_setId(env:PJNIEnv; ImageBtn : jObject; id: DWord);

Procedure jImageBtn_setLParamWidth(env:PJNIEnv; ImageBtn : jObject; w: DWord);
Procedure jImageBtn_setLParamHeight(env:PJNIEnv; ImageBtn : jObject; h: DWord);

Procedure jImageBtn_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ImageBtn : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jImageBtn_addLParamsParentRule(env:PJNIEnv; ImageBtn : jObject; rule: DWord);
Procedure jImageBtn_addLParamsAnchorRule(env:PJNIEnv; ImageBtn : jObject; rule: DWord);
Procedure jImageBtn_setLayoutAll(env:PJNIEnv; ImageBtn : jObject;  idAnchor: DWord);

//AsyncTask
function jAsyncTask_Create             (env: PJNIEnv;    this:jobject; SelfObj: TObject): jObject;

Procedure jAsyncTask_Free              (env:PJNIEnv; AsyncTask : jObject);

Procedure jAsyncTask_Execute           (env:PJNIEnv; AsyncTask : jObject);

Procedure jAsyncTask_setProgress       (env:PJNIEnv; AsyncTask : jObject; Progress : Integer);

//by jmpessoa
Procedure jAsyncTask_SetAutoPublishProgress(env:PJNIEnv; AsyncTask : jObject; Value : boolean);

//jSqliteCursor : by jmpessoa}
Function  jSqliteCursor_Create(env:PJNIEnv;  this:jobject; SelfObj: TObject): jObject;
Procedure jSqliteCursor_Free(env:PJNIEnv; SqliteCursor: jObject);

procedure jSqliteCursor_SetCursor(env:PJNIEnv;  SqliteCursor: jObject; Cursor: jObject);

Function  jSqliteCursor_GetCursor(env:PJNIEnv;  SqliteCursor: jObject): jObject;

procedure jSqliteCursor_MoveToFirst(env:PJNIEnv;  SqliteCursor: jObject);
procedure jSqliteCursor_MoveToNext(env:PJNIEnv;  SqliteCursor: jObject);
procedure jSqliteCursor_MoveToLast(env:PJNIEnv;  SqliteCursor: jObject);
procedure jSqliteCursor_MoveToPosition(env:PJNIEnv;  SqliteCursor: jObject; position: integer);

Function jSqliteCursor_GetRowCount(env:PJNIEnv;  SqliteCursor: jObject): integer;

Function jSqliteCursor_GetColumnCount(env:PJNIEnv;  SqliteCursor: jObject):  integer;
Function jSqliteCursor_GetColumnIndex(env:PJNIEnv;  SqliteCursor: jObject; colName: string): integer;
Function jSqliteCursor_GetColumName(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): string;

Function jSqliteCursor_GetColType(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): integer;

Function jSqliteCursor_GetValueAsString(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): string;
function jSqliteCursor_GetValueAsBitmap(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): jObject;

function jSqliteCursor_GetValueAsDouble (env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): double;
function jSqliteCursor_GetValueAsFloat (env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): real;

function jSqliteCursor_GetValueAsInteger(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): integer;
{jSqliteDataAccess: by jmpessoa}

Function  jSqliteDataAccess_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject;
                                        dataBaseName: string; colDelimiter: char; rowDelimiter: char): jObject;

Procedure jSqliteDataAccess_Free(env:PJNIEnv; SqliteDataBase : jObject);

function jSqliteDataAccess_CheckDataBaseExists(env:PJNIEnv;  SqliteDataBase: jObject; fullPathDB: string): boolean;
Procedure jSqliteDataAccess_ExecSQL(env:PJNIEnv; SqliteDataBase: jObject; execQuery: string);

Procedure jSqliteDataAccess_OpenOrCreate(env:PJNIEnv; SqliteDataBase: jObject; dataBaseName: string);
Procedure jSqliteDataAccess_AddTableName(env:PJNIEnv; SqliteDataBase: jObject; tableName: string);

Procedure jSqliteDataAccess_AddCreateTableQuery(env:PJNIEnv; SqliteDataBase: jObject; createTableQuery: string);

procedure jSqliteDataAccess_CreateAllTables(env:PJNIEnv; SqliteDataBase: jObject);
procedure jSqliteDataAccess_DropAllTables(env:PJNIEnv; SqliteDataBase: jObject; recreate: boolean);

function jSqliteDataAccess_Select(env:PJNIEnv;  SqliteDataBase:jObject; selectQuery: string): string; overload;
procedure jSqliteDataAccess_Select(env:PJNIEnv;  SqliteDataBase: jObject; selectQuery: string); overload;

function jSqliteDataAccess_GetCursor(env:PJNIEnv;  SqliteDataBase: jObject): jObject;

procedure jSqliteDataAccess_SetSelectDelimiters(env:PJNIEnv; SqliteDataBase: jObject; coldelim: char; rowdelim: char);
procedure jSqliteDataAccess_CreateTable(env:PJNIEnv; SqliteDataBase: jObject; createQuery: string);
procedure jSqliteDataAccess_DropTable(env:PJNIEnv; SqliteDataBase: jObject; tableName: string);
procedure jSqliteDataAccess_InsertIntoTable(env:PJNIEnv; SqliteDataBase: jObject; insertQuery: string);

procedure jSqliteDataAccess_DeleteFromTable(env:PJNIEnv; SqliteDataBase: jObject; deleteQuery: string);

procedure jSqliteDataAccess_UpdateTable(env:PJNIEnv; SqliteDataBase: jObject; updateQuery: string);
procedure jSqliteDataAccess_UpdateImage(env:PJNIEnv; SqliteDataBase: jObject;
                                        tableName: string; imageFieldName: string; keyFieldName: string; imageValue: jObject; keyValue: integer); overload;

procedure jSqliteDataAccess_Close(env:PJNIEnv; SqliteDataBase: jObject);

procedure jSqliteDataAccess_SetForeignKeyConstraintsEnabled(env: PJNIEnv; _jsqlitedataaccess: JObject; _value: boolean);
procedure jSqliteDataAccess_SetDefaultLocale(env: PJNIEnv; _jsqlitedataaccess: JObject);
procedure jSqliteDataAccess_DeleteDatabase(env: PJNIEnv; _jsqlitedataaccess: JObject; _dbName: string);
procedure jSqliteDataAccess_UpdateImage(env: PJNIEnv; _jsqlitedataaccess: JObject; _tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer); overload;
procedure jSqliteDataAccess_InsertIntoTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _insertQueries: TDynArrayOfString);
procedure jSqliteDataAccess_UpdateTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _updateQueries: TDynArrayOfString);
function jSqliteDataAccess_CheckDataBaseExistsByName(env: PJNIEnv; _jsqlitedataaccess: JObject; _dbName: string): boolean;

procedure jSqliteDataAccess_UpdateImageBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);

// Http
//Function  jHttp_Get(env:PJNIEnv;  this:jobject; URL: String) : String;

function jHttpClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jHttpClient_jFree(env: PJNIEnv; _jhttpclient: JObject);
function jHttpClient_Get(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string): string; overload;
//procedure jHttpClient_Get(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string); overload;
procedure jHttpClient_SetAuthenticationUser(env: PJNIEnv; _jhttpclient: JObject; _userName: string; _password: string);
procedure jHttpClient_SetAuthenticationMode(env: PJNIEnv; _jhttpclient: JObject; _authenticationMode: integer);
procedure jHttpClient_SetAuthenticationHost(env: PJNIEnv; _jhttpclient: JObject; _hostName: string; _port: integer);
function jHttpClient_PostNameValueData(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string; _name: string; _value: string): integer; overload;
function jHttpClient_PostNameValueData(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string; _listNameValue: string): integer; overload;


//by jmpessoa
procedure jSend_Email(env:PJNIEnv; this:jobject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
//by jmpessoa
function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage:string): integer;

//by jmpessoa
function jContact_getMobileNumberByDisplayName(env:PJNIEnv; this:jobject;
                                               contactName: string): string;
//by jmpessoa
function jContact_getDisplayNameList(env:PJNIEnv; this:jobject; delimiter: char): string;

// Camera
Procedure jTakePhoto(env:PJNIEnv;  this:jobject; filename : String);

//by jmpessoa
function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String): string; overload;
function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer): string; overload;

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

function JBool( Bool : Boolean ) : byte;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End;
 end;

//------------------------------------------------------------------------------
// Base Conversion
//------------------------------------------------------------------------------

//by jmpessoa: try fix this BUG....

// ref. http://android-developers.blogspot.cz/2011/11/jni-local-reference-changes-in-ics.html

// http://stackoverflow.com/questions/14765776/jni-error-app-bug-accessed-stale-local-reference-0xbc00021-index-8-in-a-tabl

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

Function  jgetTick (env:PJNIEnv;this:jobject) : LongInt;
Const
 _cFuncName = 'getTick';
 _cFuncSig  = '()J';
Var
 _jMethod : jMethodID = nil;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 Result     := env^.CallLongMethod(env,this,_jMethod);
end;

//------------------------------------------------------------------------------
// System
//------------------------------------------------------------------------------

// Garbage Collection
Procedure jSystem_GC(env:PJNIEnv;this:jobject);
const
  _cFuncName = 'systemGC';
  _cFuncSig  = '()V';
var
  _jMethod : jMethodID = nil;
begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  env^.CallVoidMethod(env,this,_jMethod);
end;

//by jmpessoa
Procedure jSystem_GC2(env:PJNIEnv; this:jobject);
var
  cls: jClass;
  method: jmethodID;
begin
  cls := env^.GetObjectClass(env, this);
  method:= env^.GetMethodID(env, cls, 'systemGC', '()V');
  env^.CallVoidMethod(env, this, method);
end;


//------------------------------------------------------------------------------
// Class
//------------------------------------------------------------------------------

Procedure jClass_setNull(env:PJNIEnv; this:jobject; ClassObj : jClass);
Const
 _cFuncName = 'classSetNull';
 _cFuncSig  = '(Ljava/lang/Class;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := ClassObj;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

Procedure jClass_chkNull(env:PJNIEnv; this:jobject; ClassObj : jObject);
Const
 _cFuncName = 'classChkNull';
 _cFuncSig  = '(Ljava/lang/Class;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := ClassObj;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;


//------------------------------------------------------------------------------
// Asset
//------------------------------------------------------------------------------

//  src     'test.txt'
//  outFile '/data/data/com/kredix/files/test.txt'
//            App.Path.Dat+'/image01.png'
Function  jAsset_SaveToFile(env:PJNIEnv;  this:jobject; src,dst:String) : Boolean;
 Const
  _cFuncName = 'assetSaveToFile';
  _cFuncSig  = '(Ljava/lang/String;Ljava/lang/String;)Z';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 // _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := env^.NewStringUTF(env, pchar(src) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(dst) );
  _jBoolean  := env^.CallBooleanMethodA(env,this,_jMethod,@_jParams);
  Result     := Boolean(_jBoolean);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;


//------------------------------------------------------------------------------
// Image Info
//------------------------------------------------------------------------------

Function  jImage_getWH(env:PJNIEnv; this:jobject; filename : String ) : TWH;
 Const
  _cFuncName = 'Image_getWH';
  _cFuncSig  = '(Ljava/lang/String;)I';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
  _wh      : Integer;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l  := env^.NewStringUTF(env, pchar(filename) );
  _wh        := env^.CallIntMethodA(env,this,_jMethod,@_jParam);
  env^.DeleteLocalRef(env,_jParam.l);
  //
  Result.Width  := (_wh shr 16);
  Result.Height := (_wh and $0000FFFF);
  dbg('Image : ' + IntToStr(Result.Width) + 'x' + IntTostr(Result.Height));
 end;

//
Function  jImage_resample(env:PJNIEnv; this:jobject; filename : String; size : integer ) : jObject;
 Const
  _cFuncName = 'Image_resample';
  _cFuncSig  = '(Ljava/lang/String;I)Landroid/graphics/Bitmap;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
  _jObject : jObject;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := env^.NewStringUTF(env, pchar(filename) );
  _jParams[1].i := size;
  _jObject      := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  Result := _jObject;
  dbg('resampling');
 end;

Procedure jImage_save                  (env:PJNIEnv; this:jobject; Bitmap : jObject; filename : String);
 Const
  _cFuncName = 'Image_save';
  _cFuncSig  = '(Landroid/graphics/Bitmap;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 // _jObject : jObject;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Bitmap;;
  _jParams[1].l := env^.NewStringUTF(env, pchar(filename) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//------------------------------------------------------------------------------
// TextView
//------------------------------------------------------------------------------

Function jTextView_Create(env: PJNIEnv;   this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jTextView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jTextView_Free(env:PJNIEnv; TextView : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, TextView);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,TextView,_jMethod);
 env^.DeleteGlobalRef(env,TextView);
end;

//
Procedure jTextView_setEnabled (env:PJNIEnv; TextView : jObject; enabled : Boolean);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].z := JBool(enabled);
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setEnabled', '(Z)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_setLeftTopRightBottomWidthHeight(env:PJNIEnv; TextView : jObject; ml,mt,mr,mb,w,h: integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
  cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, TextView);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setParent(env:PJNIEnv; TextView: jObject; ViewGroup : jObject);
 var
    cls: jClass;
    method: jmethodID;
    _jParams : array[0..0] of jValue;
 begin
     _jParams[0].l := ViewGroup;
     cls := env^.GetObjectClass(env, TextView);
     method:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
     env^.CallVoidMethodA(env, TextView, method, @_jParams);
 end;

Function jTextView_getText(env:PJNIEnv; TextView : jObject) : String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'getText', '()Ljava/lang/CharSequence;');
  _jString   := env^.CallObjectMethod(env,TextView,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(env,_jString,@_jBoolean) );
          end;
  end;
end;

//by jmpessoa
Procedure jTextView_setText(env: PJNIEnv; TextView : jObject; Str : String);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str));
  cls := env^.GetObjectClass(env, TextView);
  method:= env^.GetMethodID(env, cls, 'setText', '(Ljava/lang/CharSequence;)V');
  env^.CallVoidMethodA(env, TextView, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jTextView_setTextColor(env:PJNIEnv; TextView: jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jTextView_setTextSize(env:PJNIEnv; TextView : jObject; size : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].f := size;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_SetTextTypeFace(env:PJNIEnv; TextView : jObject; textStyle  : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := textStyle;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'SetTextTypeFace', '(I)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

procedure jTextView_setFontAndTextTypeFace(env: PJNIEnv; TextView: jObject; FontFace, TextTypeFace: DWord); 
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
  cls: jClass;
begin
  _jParams[0].i := FontFace;
  _jParams[1].i := TextTypeFace;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setTextAlignment(env:PJNIEnv; TextView : jObject; align : DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := align;
  cls := env^.GetObjectClass(env, TextView);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextAlignment', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_addLParamsParentRule(env:PJNIEnv; TextView : jObject; rule: DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, TextView);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_addLParamsAnchorRule(env:PJNIEnv; TextView : jObject; rule: DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_setLayoutAll(env:PJNIEnv; TextView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_setLParamWidth(env:PJNIEnv; TextView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_setLParamHeight(env:PJNIEnv; TextView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
 cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

Procedure jTextView_setId(env:PJNIEnv; TextView : jObject; id: DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
  cls := env^.GetObjectClass(env, TextView);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,TextView,_jMethod,@_jParams);
end;

procedure jTextView_Append(env: PJNIEnv; _jtextview: JObject; _txt: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txt));
  jCls:= env^.GetObjectClass(env, _jtextview);
  jMethod:= env^.GetMethodID(env, jCls, 'Append', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

//------------------------------------------------------------------------------
// EditText
//------------------------------------------------------------------------------
Function jEditText_Create(env: PJNIEnv;  this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env);{global}           {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jEditText_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

//by jmpessoa
Procedure jEditText_Free(env:PJNIEnv; EditText : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
   cls := env^.GetObjectClass(env, EditText);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,EditText,_jMethod);
   env^.DeleteGlobalRef(env,EditText);
end;

Procedure jEditText_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        EditText : jObject; ml,mt,mr,mb,w,h: integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
  cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env, EditText, _jMethod, @_jParams);
end;

//by jmpessoa
Procedure jEditText_setParent(env:PJNIEnv;
                              EditText : jObject;ViewGroup : jObject);
 var
    cls: jClass;
    method: jmethodID;
    _jParams : array[0..0] of jValue;
 begin
     _jParams[0].l := ViewGroup;
     cls := env^.GetObjectClass(env, EditText);
     method:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
     env^.CallVoidMethodA(env, EditText, method, @_jParams);
 end;

//by jmpessoa
Function jEditText_getText(env:PJNIEnv; EditText : jObject) : String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'GetText', '()Ljava/lang/String;');
  _jString   := env^.CallObjectMethod(env,EditText,_jMethod);
  case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := string(env^.GetStringUTFChars(env,_jString,@_jBoolean));
          end;
  end;
end;

Procedure jEditText_setText(env:PJNIEnv;  EditText: jObject; Str: String);
var
  _jParams : array[0..0] of jValue;
   cls: jClass;
   method: jmethodID;
begin
  cls := env^.GetObjectClass(env, EditText);
  if Str <> '' then
  begin
    _jParams[0].l:= env^.NewStringUTF(env, PChar(Str));
    method:= env^.GetMethodID(env, cls, 'setText', '(Ljava/lang/CharSequence;)V');
    env^.CallVoidMethodA(env, EditText,method, @_jParams);
    env^.DeleteLocalRef(env, _jParams[0].l);
  end
  else
  begin
    method:= env^.GetMethodID(env, cls, 'Clear', '()V');
    env^.CallVoidMethod(env, EditText,method);
  end;
end;

Procedure jEditText_setTextColor(env:PJNIEnv;
                                  EditText : jObject; color : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := color;
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jEditText_setTextSize(env:PJNIEnv;
                                 EditText : jObject; size : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].f := size;
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setHint(env:PJNIEnv; EditText : jObject;
                                 Str : String);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
 cls := env^.GetObjectClass(env, EditText);
 // Changed: String -> CharSequence - Fatih
 //_jMethod:= env^.GetMethodID(env, cls, 'setHint', '(Ljava/lang/String;)V');
 _jMethod:= env^.GetMethodID(env, cls, 'setHint', '(Ljava/lang/CharSequence;)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jEditText_setHintTextColor(env: PJNIEnv; _jedittext: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'setHintTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jedittext, jMethod, @jParams);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_SetFocus(env:PJNIEnv; EditText : jObject );
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setFocus2', '()V');
 env^.CallVoidMethod(env,EditText,_jMethod);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_immShow(env:PJNIEnv; EditText : jObject );
Var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'immShow2', '()V');
 env^.CallVoidMethod(env,EditText,_jMethod);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_immHide(env:PJNIEnv; EditText : jObject );
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'immHide2', '()V');
 env^.CallVoidMethod(env,EditText,_jMethod);
end;

// LORDMAN - 2013-07-26
//by jmpessoa
Procedure jEditText_editInputType2(env:PJNIEnv; EditText : jObject; Str : String);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
 cls:= env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setInputTypeEx', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
Procedure jEditText_setInputType(env:PJNIEnv;  EditText: jObject; itType: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := itType;
  cls:= env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setInputType', '(I)V');
  env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//force edits not to make the length of the text greater than the specified length
// LORDMAN - 2013-07-26
Procedure jEditText_maxLength(env:PJNIEnv; EditText : jObject; size  : integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := size;
 cls:= env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'maxLength', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_AllCaps(env:PJNIEnv; EditText : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls:= env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'AllCaps', '()V');
 env^.CallVoidMethod(env,EditText,_jMethod);
end;


Procedure jEditText_DispatchOnChangeEvent(env:PJNIEnv; EditText : jObject; value: boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
_jParams[0].z := JBool(value);
 cls:= env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'DispatchOnChangeEvent', '(Z)V');
 env^.CallVoidMethodA(env,EditText,_jMethod, @_jParams);
end;

Procedure jEditText_DispatchOnChangedEvent(env:PJNIEnv; EditText : jObject; value: boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
_jParams[0].z := JBool(value);
 cls:= env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'DispatchOnChangedEvent', '(Z)V');
 env^.CallVoidMethodA(env,EditText,_jMethod, @_jParams);
end;
//by jmpessoa
//The attribute maxLines corresponds to the maximum height of the EditText,
//it controls the outer boundaries and not inner text lines.
Procedure jEditText_setMaxLines(env: PJNIEnv; EditText: jObject; max:DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  cls:= env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'setMaxLines', '(I)V');
 _jParams[0].i := max;
  env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setSingleLine(env:PJNIEnv; EditText : jObject; isSingle: boolean);
var
 _jMethod: jMethodID = nil;
 _jParams: array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].z:= JBool(isSingle);
  cls:= env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setSingleLine', '(Z)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setHorizontallyScrolling(env:PJNIEnv; EditText : jObject; wrapping: boolean);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  _jParams[0].z := JBool(wrapping);
   cls:= env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setHorizontallyScrolling', '(Z)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_addLParamsParentRule(env:PJNIEnv; EditText : jObject; rule: DWord);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
   cls:= env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
    env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_addLParamsAnchorRule(env:PJNIEnv; EditText : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
   cls:= env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLayoutAll(env:PJNIEnv; EditText : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLParamWidth(env:PJNIEnv; EditText : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
  cls := env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLParamHeight(env:PJNIEnv; EditText : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setId(env:PJNIEnv; EditText : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
  cls := env^.GetObjectClass(env, EditText);
_jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setVerticalScrollBarEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].z := JBool(value);
   cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setVerticalScrollBarEnabled', '(Z)V');
  env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setHorizontalScrollBarEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
begin
   _jParams[0].z := JBool(value);
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setHorizontalScrollBarEnabled', '(Z)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setScrollbarFadingEnabled(env:PJNIEnv; EditText : jObject; value  : boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
begin
   _jParams[0].z := JBool(value);
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setScrollbarFadingEnabled', '(Z)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setScrollBarStyle(env:PJNIEnv; EditText : jObject; style  : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
begin
   _jParams[0].i := style;
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setScrollBarStyle', '(I)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

Procedure jEditText_setMovementMethod(env:PJNIEnv; EditText : jObject);
var
  _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'SetMovementMethod', '()V');
   env^.CallVoidMethod(env,EditText,_jMethod);
end;

Procedure jEditText_setScroller(env:PJNIEnv;   EditText : jObject);
var
  _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setScrollerEx', '()V');
   env^.CallVoidMethod(env,EditText,_jMethod);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_GetCursorPos(env:PJNIEnv; EditText : jObject; Var x,y : Integer);
var
 _jMethod   : jMethodID = nil;
 _jIntArray : jintArray;
 _jBoolean  : jBoolean;
 //
 PInt    : PInteger;
 PIntSav : PInteger;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'getCursorPos', '()[I');
 _jIntArray := env^.CallObjectMethod(env,EditText,_jMethod);
 //
 _jBoolean  := JNI_False;
 PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
 PIntSav    := PInt;
 x := PInt^; Inc(PInt);
 y := PInt^; Inc(PInt);
 env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_SetCursorPos(env:PJNIEnv; EditText : jObject; startPos,endPos : Integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
begin
 _jParams[0].i := startPos;
 _jParams[1].i := endPos;
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setCursorPos', '(II)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

// LORDMAN - 2013-08-12
Procedure jEditText_setTextAlignment (env:PJNIEnv; EditText : jObject; align : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := align;
 cls := env^.GetObjectClass(env, EditText);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextAlignment', '(I)V');
 env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;


// LORDMAN 2013-08-27
Procedure jEditText_SetEnabled (env:PJNIEnv;
                                EditText : jObject; enabled : Boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
begin
   _jParams[0].z := JBool(enabled);
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'SetEnabled', '(Z)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-27
Procedure jEditText_SetEditable (env:PJNIEnv;
                                 EditText : jObject; enabled : Boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
begin
   _jParams[0].z := JBool(enabled);
    cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'SetEditable', '(Z)V');
   env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

procedure jEditText_Append(env: PJNIEnv; _jedittext: JObject; _txt: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txt));
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'Append', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jedittext, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jEditText_SetImeOptions(env: PJNIEnv; _jedittext: JObject; _imeOption: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _imeOption;
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImeOptions', '(I)V');
  env^.CallVoidMethodA(env, _jedittext, jMethod, @jParams);
end;

procedure jEditText_setFontAndTextTypeFace(env: PJNIEnv; EditText: jObject; FontFace, TextTypeFace: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
  cls: jClass;
begin
  _jParams[0].i := FontFace;
  _jParams[1].i := TextTypeFace;
  cls := env^.GetObjectClass(env, EditText);
  _jMethod:= env^.GetMethodID(env, cls, 'setFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env,EditText,_jMethod,@_jParams);
end;

procedure jEditText_SetAcceptSuggestion(env: PJNIEnv; _jedittext: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAcceptSuggestion', '(Z)V');
  env^.CallVoidMethodA(env, _jedittext, jMethod, @jParams);
end;


procedure jEditText_CopyToClipboard(env: PJNIEnv; _jedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '()V');
  env^.CallVoidMethod(env, _jedittext, jMethod);
end;


procedure jEditText_PasteFromClipboard(env: PJNIEnv; _jedittext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jedittext);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()V');
  env^.CallVoidMethod(env, _jedittext, jMethod);
end;

//------------------------------------------------------------------------------
// Button
//------------------------------------------------------------------------------

//by jmpessoa
Function jButton_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jButton_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

//by jmpessoa
Procedure jButton_Free(env:PJNIEnv; Button : jObject);
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls:= env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env, Button, _jMethod);
  env^.DeleteGlobalRef(env, Button);
end;

procedure jButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        Button : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
  cls:= env^.GetObjectClass(env, Button);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

Procedure jButton_setParent(env:PJNIEnv;
                            Button : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setText(env:PJNIEnv;
                          Button : jObject; Str : String);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'setText', '(Ljava/lang/CharSequence;)V');
  env^.CallVoidMethodA(env, Button,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

//
Function jButton_getText(env:PJNIEnv;
                         Button : jObject) : String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'getText', '()Ljava/lang/CharSequence;');
  _jString   := env^.CallObjectMethod(env,Button,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

Procedure jButton_setTextColor(env:PJNIEnv;
                                Button : jObject; color : DWord);
var
    _jMethod : jMethodID = nil;
    _jParams : array[0..0] of jValue;
    cls: jClass;
begin
    _jParams[0].i := color;
    cls := env^.GetObjectClass(env, Button);
    _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
    env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//Font Height (Pixel)
Procedure jButton_setTextSize (env:PJNIEnv;
                               Button : jObject; size : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].f := size;
 cls := env^.GetObjectClass(env, Button);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_addLParamsParentRule(env:PJNIEnv; Button : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, Button);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_addLParamsAnchorRule(env:PJNIEnv; Button : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, Button);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

Procedure jButton_setLayoutAll(env:PJNIEnv; Button : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, Button);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setLParamWidth(env:PJNIEnv; Button : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

Procedure jButton_setLParamHeight(env:PJNIEnv; Button : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, Button);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

Procedure jButton_setId(env:PJNIEnv; Button : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

Procedure jButton_setFocusable(env:PJNIEnv; Button : jObject; enabled: boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].z := JBool(enabled);
  cls := env^.GetObjectClass(env, Button);
  _jMethod:= env^.GetMethodID(env, cls, 'SetFocusable', '(Z)V');
 env^.CallVoidMethodA(env,Button,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// CheckBox
//------------------------------------------------------------------------------
Function jCheckBox_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
   _jParams[0].j := Int64(SelfObj);
  cls:= Get_gjClass(env); {global}

  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jCheckBox_Create', '(J)Ljava/lang/Object;');

  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jCheckBox_Free(env:PJNIEnv; CheckBox : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls := env^.GetObjectClass(env, CheckBox);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,CheckBox,_jMethod);
   env^.DeleteGlobalRef(env,CheckBox);
end;

Procedure jCheckBox_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        CheckBox : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
 begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, CheckBox);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

Procedure jCheckBox_setParent(env:PJNIEnv;
                              CheckBox : jObject;ViewGroup : jObject);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
 end;

// Java Function
Function jCheckBox_getText(env:PJNIEnv; CheckBox : jObject) : String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'getText', '()Ljava/lang/CharSequence;');
  _jString   := env^.CallObjectMethod(env,CheckBox,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

Procedure jCheckBox_setText(env:PJNIEnv;
                            CheckBox : jObject; Str : String);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
   cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'setText', '(Ljava/lang/CharSequence;)V');
  env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

//
Procedure jCheckBox_setTextColor(env:PJNIEnv;
                                  CheckBox : jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

Function  jCheckBox_isChecked(env:PJNIEnv; CheckBox : jObject) : Boolean;
var
 _jMethod : jMethodID = nil;
 _jBool   : jBoolean;
 cls: jClass;
begin
  cls := env^.GetObjectClass(env, CheckBox);
 _jMethod:= env^.GetMethodID(env, cls, 'isChecked', '()Z');
 _jBool:= env^.CallBooleanMethod(env,CheckBox,_jMethod);
 Result:= Boolean(_jBool);
end;

Procedure jCheckBox_setChecked(env:PJNIEnv;
                                        CheckBox : jObject; value : Boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  _jParams[0].z := JBool(value);
  cls := env^.GetObjectClass(env, CheckBox);
 _jMethod:= env^.GetMethodID(env, cls, 'setChecked', '(Z)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jCheckBox_setTextSize(env:PJNIEnv;
                                  CheckBox : jObject; size : DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  _jParams[0].f := size;
  cls := env^.GetObjectClass(env, CheckBox);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setId(env:PJNIEnv;  CheckBox : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, CheckBox);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setLParamWidth(env:PJNIEnv; CheckBox : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

Procedure jCheckBox_setLParamHeight(env:PJNIEnv; CheckBox : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, CheckBox);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_addLParamsParentRule(env:PJNIEnv; CheckBox : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_addLParamsAnchorRule(env:PJNIEnv; CheckBox : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, CheckBox);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

Procedure jCheckBox_setLayoutAll(env:PJNIEnv; CheckBox : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, CheckBox);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,CheckBox,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// RadioButton
//------------------------------------------------------------------------------
function jRadioButton_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jRadioButton_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jRadioButton_Free(env:PJNIEnv; RadioButton : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,RadioButton,_jMethod);
  env^.DeleteGlobalRef(env,RadioButton);
end;

Procedure jRadioButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        RadioButton : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i:= ml;
 _jParams[1].i:= mt;
 _jParams[2].i:= mr;
 _jParams[3].i:= mb;
 _jParams[4].i:= w;
 _jParams[5].i:= h;
 cls := env^.GetObjectClass(env, RadioButton);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

//
Procedure jRadioButton_setParent(env:PJNIEnv;
                              RadioButton : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
   cls: jClass;
 begin
    _jParams[0].l := ViewGroup;
   cls := env^.GetObjectClass(env, RadioButton);
    _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
 end;

// Java Function
Function jRadioButton_getText(env:PJNIEnv; RadioButton : jObject) : String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
   cls: jClass;
 begin
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'getText', '()Ljava/lang/CharSequence;');
  _jString   := env^.CallObjectMethod(env,RadioButton,_jMethod);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

Procedure jRadioButton_setText(env:PJNIEnv;
                            RadioButton : jObject; Str : String);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  cls := env^.GetObjectClass(env, RadioButton);
 _jMethod:= env^.GetMethodID(env, cls, 'setText', '(Ljava/lang/CharSequence;)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

Procedure jRadioButton_setTextColor(env:PJNIEnv;
                                  RadioButton : jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;
//

Function  jRadioButton_isChecked(env:PJNIEnv; RadioButton : jObject) : Boolean;
var
 _jMethod : jMethodID = nil;
 _jBool   : jBoolean;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, RadioButton);
 _jMethod:= env^.GetMethodID(env, cls, 'isChecked', '()Z');
 _jBool:= env^.CallBooleanMethod(env,RadioButton,_jMethod);
 Result:= Boolean(_jBool);
end;

Procedure jRadioButton_setChecked(env:PJNIEnv;
                                        RadioButton : jObject; value : Boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].z := JBool(value);
   cls := env^.GetObjectClass(env, RadioButton);
 _jMethod:= env^.GetMethodID(env, cls, 'setChecked', '(Z)V');
 env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jRadioButton_setTextSize (env:PJNIEnv;
                                  RadioButton : jObject; size : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].f := size;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setId(env:PJNIEnv; RadioButton : jObject; id: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

Procedure jRadioButton_setLParamWidth(env:PJNIEnv; RadioButton : jObject; w: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := w;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

Procedure jRadioButton_setLParamHeight(env:PJNIEnv; RadioButton : jObject; h: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := h;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_addLParamsParentRule(env:PJNIEnv; RadioButton : jObject; rule: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_addLParamsAnchorRule(env:PJNIEnv; RadioButton : jObject; rule: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, RadioButton);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

Procedure jRadioButton_setLayoutAll(env:PJNIEnv; RadioButton : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, RadioButton);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,RadioButton,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// ProgressBar
//------------------------------------------------------------------------------
function jProgressBar_Create(env: PJNIEnv; this:jobject; SelfObj: TObject; Style: DWord): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jProgressBar_Create', '(JI)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  _jParams[1].i := Style;
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;


Procedure jProgressBar_Free(env:PJNIEnv; ProgressBar : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
   cls := env^.GetObjectClass(env, ProgressBar);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,ProgressBar,_jMethod);
   env^.DeleteGlobalRef(env,ProgressBar);
end;


Procedure jProgressBar_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ProgressBar : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
  cls: jClass;
begin
  _jParams[0].i := ml;
  _jParams[1].i := mt;
  _jParams[2].i := mr;
  _jParams[3].i := mb;
  _jParams[4].i := w;
  _jParams[5].i := h;
  cls := env^.GetObjectClass(env, ProgressBar);
  _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

Procedure jProgressBar_setParent(env:PJNIEnv;
                                 ProgressBar : jObject;ViewGroup : jObject);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
    cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
 end;

//by jmpessoa
Function  jProgressBar_getProgress(env:PJNIEnv; ProgressBar : jObject) : Integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, ProgressBar);
  _jMethod:= env^.GetMethodID(env, cls, 'getProgress', '()I');
 Result     := env^.CallIntMethod(env,ProgressBar,_jMethod);
end;


Procedure jProgressBar_setProgress(env:PJNIEnv;
                                    ProgressBar : jObject; value : Integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := value;
  cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'setProgress', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jProgressBar_setMax(env:PJNIEnv;
                                    ProgressBar : jObject; value : Integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := value;
  cls := env^.GetObjectClass(env, ProgressBar);
  _jMethod:= env^.GetMethodID(env, cls, 'setMax', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

//by jmpessoa
Function  jProgressBar_getMax(env:PJNIEnv;  ProgressBar : jObject): Integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls:= env^.GetObjectClass(env, ProgressBar);
  _jMethod:= env^.GetMethodID(env, cls, 'getMax', '()I');
 Result:= env^.CallIntMethod(env,ProgressBar,_jMethod);
end;

//by jmpessoa
Procedure jProgressBar_setId(env:PJNIEnv; ProgressBar : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := id;
  cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setLParamWidth(env:PJNIEnv; ProgressBar : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := w;
  cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

Procedure jProgressBar_setLParamHeight(env:PJNIEnv; ProgressBar : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ProgressBar);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_addLParamsParentRule(env:PJNIEnv; ProgressBar : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_addLParamsAnchorRule(env:PJNIEnv; ProgressBar : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i :=  rule;
  cls := env^.GetObjectClass(env, ProgressBar);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

Procedure jProgressBar_setLayoutAll(env:PJNIEnv; ProgressBar : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ProgressBar);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ProgressBar,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// ImageView
//------------------------------------------------------------------------------

//by jmpessoa
function jImageView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jImageView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jImageView_Free(env:PJNIEnv; ImageView : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls:= env^.GetObjectClass(env, ImageView);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,ImageView,_jMethod);
   env^.DeleteGlobalRef(env,ImageView);
end;

Procedure jImageView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ImageView : jObject; ml,mt,mr,mb,w,h: integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
  cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls:= env^.GetObjectClass(env, ImageView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;

Procedure jImageView_setParent(env:PJNIEnv;
                               ImageView : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
  cls:= env^.GetObjectClass(env, ImageView);
   _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
 end;
 

Procedure jImageView_setImage(env:PJNIEnv;
                              ImageView : jObject; Str : String);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
    cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'setImage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

Procedure jImageView_setBitmapImage(env:PJNIEnv;
                                    ImageView : jObject; bitmap : jObject);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := bitmap;
    cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'setBitmapImage', '(Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
 end;

Procedure jImageView_SetImageByResIdentifier(env:PJNIEnv; ImageView : jObject; _imageResIdentifier: string);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, PChar(_imageResIdentifier) );
  cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'SetImageByResIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

//by jmpessoa
Procedure jImageView_setId(env:PJNIEnv; ImageView : jObject; id: DWord);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := id;
   cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jImageView_setLParamWidth(env:PJNIEnv; ImageView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ImageView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;

Procedure jImageView_setLParamHeight(env:PJNIEnv; ImageView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ImageView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_addLParamsParentRule(env:PJNIEnv; ImageView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ImageView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_addLParamsAnchorRule(env:PJNIEnv; ImageView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ImageView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;

Procedure jImageView_setLayoutAll(env:PJNIEnv; ImageView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ImageView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ImageView,_jMethod,@_jParams);
end;


function jImageView_getLParamHeight(env:PJNIEnv; ImageView : jObject ): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'getLParamHeight', '()I');
 Result:= env^.CallIntMethod(env,ImageView,_jMethod);
end;

function jImageView_getLParamWidth(env:PJNIEnv; ImageView : jObject): integer;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'getLParamWidth', '()I');
  Result:= env^.CallIntMethod(env,ImageView,_jMethod);
end;

function jImageView_GetBitmapHeight(env:PJNIEnv; ImageView : jObject ): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'GetBitmapHeight', '()I');
 Result:= env^.CallIntMethod(env,ImageView,_jMethod);
end;

function jImageView_GetBitmapWidth(env:PJNIEnv; ImageView : jObject): integer;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, ImageView);
 _jMethod:= env^.GetMethodID(env, cls, 'GetBitmapWidth', '()I');
  Result:= env^.CallIntMethod(env,ImageView,_jMethod);
end;

procedure jImageView_SetImageMatrixScale(env: PJNIEnv; _jimageview: JObject; _scaleX: single; _scaleY: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _scaleX;
  jParams[1].f:= _scaleY;
  jCls:= env^.GetObjectClass(env, _jimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageMatrixScale', '(FF)V');
  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);
end;

procedure jImageView_SetScaleType(env: PJNIEnv; _jimageview: JObject; _scaleType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _scaleType;
  jCls:= env^.GetObjectClass(env, _jimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScaleType', '(I)V');
  env^.CallVoidMethodA(env, _jimageview, jMethod, @jParams);
end;

function jImageView_GetBitmapImage(env: PJNIEnv; _jimageview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBitmapImage', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jimageview, jMethod);
end;
//------------------------------------------------------------------------------
// ListView
//------------------------------------------------------------------------------
//

//by jmpessoa
function jListView_Create2(env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string; image: jObject;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer; txtAlign: integer): jObject;
var
 _jMethod: jMethodID = nil;
 _jParams: array[0..7] of jValue;
 cls: jClass;
begin
 _jParams[0].j := Int64(SelfObj);
 _jParams[1].i := widget;
 _jParams[2].l := env^.NewStringUTF(env, PChar(widgetText));
 _jParams[3].l := image;
 _jParams[4].i := txtDecorated;
 _jParams[5].i := itemLay;
 _jParams[6].i := txtSizeDec;
 _jParams[7].i := txtAlign;
  cls:= Get_gjClass(env); {global}
  {jmpessoa/warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 _jMethod:= env^.GetMethodID(env, cls, 'jListView_Create2',
                                       '(JILjava/lang/String;Landroid/graphics/Bitmap;IIII)Ljava/lang/Object;');
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[2].l);
end;


//by jmpessoa
function jListView_Create3(env:PJNIEnv;  this:jobject; SelfObj: TObject;
                                         widget: integer;
                                         widgetText: string;
                                         txtDecorated: integer; itemLay: integer; txtSizeDec: integer; txtAlign: integer): jObject;
var
 _jMethod: jMethodID = nil;
 _jParams: array[0..6] of jValue;
 cls: jClass;
begin
 _jParams[0].j := Int64(SelfObj);
 _jParams[1].i := widget;
 _jParams[2].l := env^.NewStringUTF(env, pchar(widgetText) );
 _jParams[3].i := txtDecorated;
 _jParams[4].i := itemLay;
 _jParams[5].i := txtSizeDec;
 _jParams[6].i := txtAlign;
  cls:= Get_gjClass(env); {global}

  {jmpessoa/warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 _jMethod:= env^.GetMethodID(env, cls, 'jListView_Create3',
                                       '(JILjava/lang/String;IIII)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result:= env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[2].l);
end;

Procedure jListView_Free(env:PJNIEnv; ListView : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
   cls:= env^.GetObjectClass(env, ListView);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,ListView,_jMethod);
   env^.DeleteGlobalRef(env, ListView);
end;

Procedure jListView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ListView : jObject; ml,mt,mr,mb,w,h: integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls:= env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setParent(env:PJNIEnv;
                              ListView : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := ViewGroup;
    cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//
Procedure jListView_setTextColor(env:PJNIEnv;
                                  ListView : jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
 end;

Procedure jListView_setTextColor2(env:PJNIEnv;
                                  ListView : jObject; color : DWord; index: integer);
 var
   _jMethod : jMethodID = nil;
   _jParams : array[0..1] of jValue;
   cls: jClass;
 begin
   _jParams[0].i := color;
   _jParams[1].i := index;
   cls := env^.GetObjectClass(env, ListView);
   _jMethod:= env^.GetMethodID(env, cls, 'setTextColor2', '(II)V');
   env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
 end;

//
Procedure jListView_setTextSize(env:PJNIEnv; ListView : jObject; size  : DWord);
 var
   _jMethod : jMethodID = nil;
   _jParams : array[0..0] of jValue;
   cls: jClass;
 begin
   _jParams[0].i := size;
   cls := env^.GetObjectClass(env, ListView);
   _jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(I)V');
   env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setTextSize2  (env:PJNIEnv;
                                  ListView : jObject; size  : DWord; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
begin
 _jParams[0].i := size;
 _jParams[1].i := index;
   cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextSize2', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setItemPosition(env:PJNIEnv;
                                        ListView : jObject; Pos: integer; y:Integer );

var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
begin
 _jParams[0].i := Pos;
 _jParams[1].i := y;
   cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setItemPosition', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

// Java Function
Procedure jListView_add(env:PJNIEnv; this:jobject; ListView : jObject; Str : string;
                                        delimiter: string; fontColor: integer; fontSize: integer; hasWidgetItem: integer);
const
  _cFuncName = 'jListView_add';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;III)V';
var
  _jMethod: jMethodID = nil;
  _jParams: array[0..5] of jValue;
begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ListView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[3].i := fontColor;
  _jParams[4].i := fontSize;
  _jParams[5].i := hasWidgetItem;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);

end;

//by jmpessoa
Procedure jListView_add2(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string);
var
  _jMethod: jMethodID = nil;
  _jParams: array[0..1] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  cls:= env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'add2', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env, cls);  // <---- Added this for bug fix! 09-Sept-2014 [thanks to @Fatih!]
end;

Procedure jListView_add22(env:PJNIEnv; ListView: jObject; Str: string; delimiter: string; image: jObject);
var
  _jMethod: jMethodID = nil;
  _jParams: array[0..2] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].l := image;
  cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'add22', '(Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env, cls);  // <---- Added this for bug fix! 09-Sept-2014
end;

//by jmpessoa
Procedure jListView_add3(env:PJNIEnv; ListView : jObject; Str : string;
       delimiter: string; fontColor: integer; fontSize: integer; widgetItem: integer; widgetText: string;  image: jObject);
var
  _jMethod: jMethodID = nil;
  _jParams: array[0..6] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].i := fontColor;
  _jParams[3].i := fontSize;
  _jParams[4].i := widgetItem;
  _jParams[5].l := env^.NewStringUTF(env, pchar(widgetText) );
  _jParams[6].l := image;
  cls:= env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'add3', '(Ljava/lang/String;Ljava/lang/String;IIILjava/lang/String;Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[5].l);
  env^.DeleteLocalRef(env, cls);  // <---- Added this for bug fix! 09-Sept-2014
end;


//by jmpessoa
Procedure jListView_add4(env:PJNIEnv; ListView : jObject; Str : string;
       delimiter: string; fontColor: integer; fontSize: integer; widgetItem: integer; widgetText: string);
var
  _jMethod: jMethodID = nil;
  _jParams: array[0..5] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
  _jParams[1].l := env^.NewStringUTF(env, pchar(delimiter) );
  _jParams[2].i := fontColor;
  _jParams[3].i := fontSize;
  _jParams[4].i := widgetItem;
  _jParams[5].l := env^.NewStringUTF(env, pchar(widgetText) );
  cls:= env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'add4', '(Ljava/lang/String;Ljava/lang/String;IIILjava/lang/String;)V');
  env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[5].l);
  env^.DeleteLocalRef(env, cls);  // <---- Added this for bug fix! 09-Sept-2014
end;


//by jmpessoa
Procedure jListView_clear(env:PJNIEnv;  ListView: jObject);
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'clear', '()V');
  env^.CallVoidMethod(env,ListView,_jMethod);
end;

//by jmpessoa
Procedure jListView_delete(env:PJNIEnv; ListView : jObject; index : integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
   cls: jClass;
begin
 _jParams[0].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'delete', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setImageItem(env:PJNIEnv; ListView : jObject; bitmap: jObject; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].l := bitmap;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setImageItem', '(Landroid/graphics/Bitmap;I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setImageItem(env:PJNIEnv; ListView : jObject; imgResIdentifier: string; index: integer); overload;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, PChar(imgResIdentifier) );;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setImageItem', '(Ljava/lang/String;I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
   env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
Procedure jListView_setId(env:PJNIEnv; ListView : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setTextSizeDecorated(env:PJNIEnv; ListView : jObject; value: integer; index:integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextSizeDecorated', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setTextDecorated(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextDecorated', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setTextAlign(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setTextAlign', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setItemLayout(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setItemLayout', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setWidgetItem(env:PJNIEnv; ListView : jObject; value: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setWidgetItem', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setWidgetItem2(env:PJNIEnv; ListView : jObject; value: integer; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setWidgetItem', '(II)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setWidgetItem3(env:PJNIEnv; ListView : jObject; value: integer; txt: string; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
   cls: jClass;
begin
 _jParams[0].i := value;
 _jParams[1].l := env^.NewStringUTF(env, pchar(txt) );
 _jParams[2].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setWidgetItem', '(ILjava/lang/String;I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

Procedure jListView_setWidgetText(env:PJNIEnv; ListView : jObject; txt: string; index: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
   cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(txt) );
 _jParams[1].i := index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'setWidgetText', '(Ljava/lang/String;I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

function jListView_IsItemChecked(env:PJNIEnv; ListView : jObject; index: integer): boolean;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
 _jBool: jBoolean;
begin
 _jParams[0].i:= index;
 cls := env^.GetObjectClass(env, ListView);
 _jMethod:= env^.GetMethodID(env, cls, 'isItemChecked', '(I)Z');
 _jBool:= env^.CallBooleanMethodA(env,ListView,_jMethod,@_jParams);
 Result:= Boolean(_jBool);
end;

function jListView_GetItemText(env:PJNIEnv; ListView : jObject; index: integer): String;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  cls: jClass;
   _jParams : array[0..0] of jValue;
begin
   _jParams[0].i:= index;
  cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'getItemText', '(I)Ljava/lang/String;');
  _jString   := env^.CallObjectMethodA(env,ListView,_jMethod, @_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
            _jBoolean := JNI_False;
            Result    := String( env^.GetStringUTFChars(env,_jString,@_jBoolean) );
          end;
  end;
end;

function jListView_GetCount(env:PJNIEnv;  ListView : jObject): integer;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'GetSize', '()I');
  Result:= env^.CallIntMethod(env,ListView,_jMethod);
end;

//by jmpessoa
Procedure jListView_setLParamWidth(env:PJNIEnv; ListView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ListView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setLParamHeight(env:PJNIEnv; ListView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ListView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_addLParamsParentRule(env:PJNIEnv; ListView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ListView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_addLParamsAnchorRule(env:PJNIEnv; ListView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ListView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

Procedure jListView_setLayoutAll(env:PJNIEnv; ListView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ListView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ListView,_jMethod,@_jParams);
end;

procedure jListView_SetHighLightSelectedItem(env: PJNIEnv; _jlistview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jlistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHighLightSelectedItem', '(Z)V');
  env^.CallVoidMethodA(env, _jlistview, jMethod, @jParams);
end;


procedure jListView_SetHighLightSelectedItemColor(env: PJNIEnv; _jlistview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jlistview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHighLightSelectedItemColor', '(I)V');
  env^.CallVoidMethodA(env, _jlistview, jMethod, @jParams);
end;

//------------------------------------------------------------------------------
// ScrollView
//------------------------------------------------------------------------------
function jScrollView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jScrollView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jScrollView_Free(env:PJNIEnv; ScrollView : jObject);
var
   _jMethod: jMethodID = nil;
   cls: jClass;
begin
 cls:= env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env, ScrollView, _jMethod);
 env^.DeleteGlobalRef(env, ScrollView);
end;

Procedure jScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
  cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

Procedure jScrollView_setParent(env:PJNIEnv;
                                ScrollView : jObject;ViewGroup : jObject);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
    cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;
  

Procedure jScrollView_setScrollSize(env:PJNIEnv;
                                    ScrollView : jObject; size : integer);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := size;
    cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'setScrollSize', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//
Function jScrollView_getView(env:PJNIEnv;
                             ScrollView : jObject) : jObject;
 var
  _jMethod : jMethodID = nil;
  cls: jClass;
 begin
   cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'getView', '()Landroid/widget/RelativeLayout;');
  Result := env^.CallObjectMethod(env,ScrollView,_jMethod);
 end;

//by jmpessoa
Procedure jScrollView_setId(env:PJNIEnv; ScrollView : jObject; id: DWord);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, ScrollView);
   _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jScrollView_setLParamWidth(env:PJNIEnv; ScrollView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ScrollView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

Procedure jScrollView_setLParamHeight(env:PJNIEnv; ScrollView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_addLParamsParentRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_addLParamsAnchorRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

Procedure jScrollView_setLayoutAll(env:PJNIEnv; ScrollView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;
//----------------------------------------
//Panel - new by jmpessoa
//----------------------------------------
function jPanel_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jPanel_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jPanel_Free(env:PJNIEnv; Panel : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, Panel);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,Panel,_jMethod);
  env^.DeleteGlobalRef(env,Panel);
end;

//by jmpessoa
Procedure jPanel_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        Panel : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

Procedure jPanel_setParent(env:PJNIEnv;
                                Panel : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
    cls := env^.GetObjectClass(env, Panel);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
 end;

//by jmpessoa
Function jPanel_getView(env:PJNIEnv;
                             Panel : jObject) : jObject;
var
  _jMethod : jMethodID = nil;
   cls: jClass;
 begin
   cls := env^.GetObjectClass(env, Panel);
   _jMethod:= env^.GetMethodID(env, cls, 'getView', '()Landroid/widget/RelativeLayout;');
  Result := env^.CallObjectMethod(env,Panel,_jMethod);
 end;

//by jmpessoa
Procedure jPanel_setId(env:PJNIEnv; Panel : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setLParamWidth(env:PJNIEnv; Panel : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, Panel);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

Procedure jPanel_setLParamHeight(env:PJNIEnv; Panel : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

//by jmpessoa
function jPanel_getLParamHeight(env:PJNIEnv; Panel : jObject ): integer;
var
 _jMethod : jMethodID = nil;
 cls : jClass;
begin
 cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'getLParamHeight', '()I');
 Result:= env^.CallIntMethod(env,Panel,_jMethod);
end;

function jPanel_getLParamWidth(env:PJNIEnv; Panel : jObject): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'getLParamWidth', '()I');
 Result     := env^.CallIntMethod(env,Panel,_jMethod);
end;

//by jmpessoa
Procedure jPanel_resetLParamsRules(env:PJNIEnv; Panel : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
   cls := env^.GetObjectClass(env, Panel);
 _jMethod:= env^.GetMethodID(env, cls, 'resetLParamsRules', '()V');
 env^.CallVoidMethod(env,Panel,_jMethod);
end;

//by jmpessoa
Procedure jPanel_addLParamsParentRule(env:PJNIEnv; Panel : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, Panel);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_addLParamsAnchorRule(env:PJNIEnv; Panel : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, Panel);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

Procedure jPanel_setLayoutAll(env:PJNIEnv; Panel : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,Panel,_jMethod,@_jParams);
end;

Procedure jPanel_RemoveParent(env:PJNIEnv; Panel : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, Panel);
_jMethod:= env^.GetMethodID(env, cls, 'RemoveParent', '()V');
 env^.CallVoidMethod(env,Panel,_jMethod);
end;


procedure jPanel_SetMinZoomFactor(env: PJNIEnv; _jpanel: JObject; _minZoomFactor: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _minZoomFactor;
  jCls:= env^.GetObjectClass(env, _jpanel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinZoomFactor', '(F)V');
  env^.CallVoidMethodA(env, _jpanel, jMethod, @jParams);
end;


procedure jPanel_SetMaxZoomFactor(env: PJNIEnv; _jpanel: JObject; _maxZoomFactor: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _maxZoomFactor;
  jCls:= env^.GetObjectClass(env, _jpanel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxZoomFactor', '(F)V');
  env^.CallVoidMethodA(env, _jpanel, jMethod, @jParams);
end;

//------------------------------------------------------------------------------
// HorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------

//by jmpessoa
function jHorizontalScrollView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jHorizontalScrollView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;
//
Procedure jHorizontalScrollView_Free(env:PJNIEnv; ScrollView : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
   cls:= env^.GetObjectClass(env, ScrollView);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,ScrollView,_jMethod);
   env^.DeleteGlobalRef(env,ScrollView);
end;
//

Procedure jHorizontalScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

//
Procedure jHorizontalScrollView_setParent(env:PJNIEnv;
                                          ScrollView : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//
Procedure jHorizontalScrollView_setScrollSize(env:PJNIEnv;
                                              ScrollView : jObject; size : integer);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := size;
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'setScrollSize', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//
Function jHorizontalScrollView_getView(env:PJNIEnv;
                                       ScrollView : jObject) : jObject;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
 begin
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'getView', '()Landroid/view/ViewGroup;');
  Result := env^.CallObjectMethod(env,ScrollView,_jMethod);
 end;

//by jmpessoa
Procedure jHorizontalScrollView_setId(env:PJNIEnv; ScrollView : jObject; id: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jHorizontalScrollView_setLParamWidth(env:PJNIEnv; ScrollView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ScrollView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

Procedure jHorizontalScrollView_setLParamHeight(env:PJNIEnv;
                                       ScrollView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_addLParamsParentRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jHorizontalScrollView_addLParamsAnchorRule(env:PJNIEnv; ScrollView : jObject; rule: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, ScrollView);
 _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
 end;

Procedure jHorizontalScrollView_setLayoutAll(env:PJNIEnv; ScrollView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ScrollView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ScrollView,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// ViewFlipper
//------------------------------------------------------------------------------
function jViewFlipper_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jViewFlipper_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jViewFlipper_Free(env:PJNIEnv; ViewFlipper : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, ViewFlipper);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,ViewFlipper,_jMethod);
 env^.DeleteGlobalRef(env,ViewFlipper);
end;

Procedure jViewFlipper_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ViewFlipper : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, ViewFlipper);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setParent       (env:PJNIEnv;
                                        ViewFlipper : jObject;ViewGroup : jObject);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := ViewGroup;
   cls := env^.GetObjectClass(env, ViewFlipper);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setId(env:PJNIEnv; ViewFlipper : jObject; id: DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, ViewFlipper);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jViewFlipper_setLParamWidth(env:PJNIEnv; ViewFlipper : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ViewFlipper);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setLParamHeight(env:PJNIEnv; ViewFlipper : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ViewFlipper);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

Procedure jViewFlipper_addLParamsParentRule(env:PJNIEnv; ViewFlipper : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ViewFlipper);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_addLParamsAnchorRule(env:PJNIEnv; ViewFlipper : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ViewFlipper);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setLayoutAll(env:PJNIEnv; ViewFlipper : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ViewFlipper);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ViewFlipper,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// WebView
//------------------------------------------------------------------------------
function jWebView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jWebView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jWebView_Free(env:PJNIEnv; WebView : jObject);
var
   _jMethod: jMethodID = nil;
   cls: jClass;
begin
   cls:= env^.GetObjectClass(env, WebView);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,WebView,_jMethod);
   env^.DeleteGlobalRef(env,WebView);
end;

Procedure jWebView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        WebView : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

Procedure jWebView_setParent(env:PJNIEnv;
                             WebView : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
   cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
 end;

Procedure jWebView_setJavaScript(env:PJNIEnv;
                                        WebView : jObject; javascript : boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].z := JBool(JavaScript);
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setJavaScript', '(Z)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

procedure jWebView_SetZoomControl(env: PJNIEnv; WebView: jObject; ZoomControl: Boolean);
  var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].z := JBool(ZoomControl);
  cls := env^.GetObjectClass(env, WebView);
  _jMethod:= env^.GetMethodID(env, cls, 'setZoomControl', '(Z)V');
  env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

Procedure jWebView_loadURL(env:PJNIEnv;
                           WebView : jObject; Str : String);
Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(Str) );
   cls := env^.GetObjectClass(env, WebView);
  _jMethod:= env^.GetMethodID(env, cls, 'loadUrl', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
Procedure jWebView_setId(env:PJNIEnv; WebView : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setLParamWidth(env:PJNIEnv; WebView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, WebView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

Procedure jWebView_setLParamHeight(env:PJNIEnv; WebView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_addLParamsParentRule(env:PJNIEnv; WebView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_addLParamsAnchorRule(env:PJNIEnv; WebView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;

Procedure jWebView_setLayoutAll(env:PJNIEnv; WebView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, WebView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,WebView,_jMethod,@_jParams);
end;


procedure jWebView_SetHttpAuthUsernamePassword(env: PJNIEnv; _jwebview: JObject; _hostName: string; _hostDomain: string; _username: string; _password: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hostName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_hostDomain));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_username));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jwebview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHttpAuthUsernamePassword', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jwebview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
end;

//------------------------------------------------------------------------------
// Canvas
//------------------------------------------------------------------------------
Function jCanvas_Create(env:PJNIEnv; this:jobject; SelfObj : TObject) : jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jCanvas_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jCanvas_Free(env:PJNIEnv; Canv : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls:= env^.GetObjectClass(env, Canv);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,Canv,_jMethod);
 env^.DeleteGlobalRef(env,Canv);
end;

//

Procedure jCanvas_setStrokeWidth(env:PJNIEnv;
                                        Canv : jObject;width : single);
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].f:= width;
 cls := env^.GetObjectClass(env, Canv);
_jMethod:= env^.GetMethodID(env, cls, 'setStrokeWidth', '(F)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

Procedure jCanvas_setStyle             (env:PJNIEnv;
                                        Canv : jObject; style : integer);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := style;
 cls := env^.GetObjectClass(env, Canv);
_jMethod:= env^.GetMethodID(env, cls, 'setStyle', '(I)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

Procedure jCanvas_setColor(env:PJNIEnv;
                                        Canv : jObject; color : DWord  );
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
   cls: jClass;
begin
 _jParams[0].i := color;
 cls := env^.GetObjectClass(env, Canv);
_jMethod:= env^.GetMethodID(env, cls, 'setColor', '(I)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;


Procedure jCanvas_setTextSize(env:PJNIEnv;
                                        Canv : jObject; textsize : single );
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
    cls: jClass;
begin
 _jParams[0].f := textsize;
 cls := env^.GetObjectClass(env, Canv);
_jMethod:= env^.GetMethodID(env, cls, 'setTextSize', '(F)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

Procedure jCanvas_drawLine(env:PJNIEnv;
                                        Canv : jObject; x1,y1,x2,y2 : single);
var
 _jMethod: jMethodID = nil;
 _jParams: Array[0..3] of jValue;
 cls: jClass;
begin
 _jParams[0].F := x1;
 _jParams[1].F := y1;
 _jParams[2].F := x2;
 _jParams[3].F := y2;
 cls := env^.GetObjectClass(env, Canv);
 _jMethod:= env^.GetMethodID(env, cls, 'drawLine', '(FFFF)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-13

Procedure jCanvas_drawPoint(env:PJNIEnv; Canv:jObject; x1,y1:single);
var
_jMethod : jMethodID = nil;
_jParams : Array[0..1] of jValue;
cls: jClass;
begin
_jParams[0].F := x1;
_jParams[1].F := y1;
cls := env^.GetObjectClass(env, Canv);
_jMethod:= env^.GetMethodID(env, cls, 'drawPoint', '(FF)V');
env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

Procedure jCanvas_drawText             (env:PJNIEnv;
                                        Canv : jObject; const text : string; x,y : single);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..2] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(text) );
 _jParams[1].F := x;
 _jParams[2].F := y;
 cls := env^.GetObjectClass(env, Canv);
 _jMethod:= env^.GetMethodID(env, cls, 'drawText', '(Ljava/lang/String;FF)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;


Procedure jCanvas_drawBitmap(env:PJNIEnv; Canv : jObject; bmp : jObject; b,l,r,t : integer);
var
 _jMethod: jMethodID = nil;
 _jParams: Array[0..4] of jValue;
 cls: jClass;
begin
 _jParams[0].l := bmp;
 _jParams[1].i := b;
 _jParams[2].i := l;
 _jParams[3].i := r;
 _jParams[4].i := t;
 cls:= env^.GetObjectClass(env, Canv);
 _jMethod:= env^.GetMethodID(env, cls, 'drawBitmap', '(Landroid/graphics/Bitmap;IIII)V');
 env^.CallVoidMethodA(env,Canv,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// Bitmap
//------------------------------------------------------------------------------

Function  jBitmap_Create(env:PJNIEnv; this:jobject; SelfObj : TObject) : jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jBitmap_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jBitmap_Free(env:PJNIEnv; bmap : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,bmap,_jMethod);
  env^.DeleteGlobalRef(env,bmap);
end;

Procedure jBitmap_loadFile(env:PJNIEnv; bmap: jObject; filename : String);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, PChar(filename) );
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls, 'loadFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,bmap,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

//by jmpessoa
Procedure jBitmap_loadRes(env:PJNIEnv; bmap : jObject; imgResIdentifier : String);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(imgResIdentifier) );
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls, 'loadRes', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,bmap,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

Procedure jBitmap_createBitmap(env:PJNIEnv; bmap : jObject; w,h : integer);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
  cls: jClass;
begin
  _jParams[0].i:= w;
  _jParams[1].i:= h;
  cls := env^.GetObjectClass(env, bmap);
   _jMethod:= env^.GetMethodID(env, cls, 'createBitmap', '(II)V');
  env^.CallVoidMethodA(env,bmap,_jMethod,@_jParams);
end;

Procedure jBitmap_getWH(env:PJNIEnv; bmap : jObject; var w,h : integer);
var
  _jMethod   : jMethodID = nil;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  //
  PInt       : PInteger;
  PIntSav    : PInteger;
  cls: jClass;
 begin
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls, 'getWH', '()[I');
  _jIntArray := env^.CallObjectMethod(env,bmap,_jMethod);
  //
  _jBoolean  := JNI_False;
  PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
  PIntSav    := PInt;
  w          := PInt^; Inc(PInt);
  h          := PInt^; Inc(PInt);
  env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
 end;

//by jmpessoa
function jBitmap_GetWidth(env: PJNIEnv; bmap: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, bmap);
  jMethod:= env^.GetMethodID(env, jCls, 'GetWidth', '()I');
  Result:= env^.CallIntMethod(env, bmap, jMethod);
end;

//by jmpessoa
function jBitmap_GetHeight(env: PJNIEnv; bmap: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, bmap);
  jMethod:= env^.GetMethodID(env, jCls, 'GetHeight', '()I');
  Result:= env^.CallIntMethod(env, bmap, jMethod);
end;

//by jmpessoa
Function  jBitmap_jInstance(env:PJNIEnv; bmap: jObject): jObject;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls,'jInstance', '()Landroid/graphics/Bitmap;');
  Result := env^.CallObjectMethod(env,bmap,_jMethod);
end;

function jBitmap_ClockWise(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bmp;
  jParams[1].l:= _imageView;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'ClockWise', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;


function jBitmap_AntiClockWise(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bmp;
  jParams[1].l:= _imageView;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'AntiClockWise', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;

function jBitmap_SetScale(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bmp;
  jParams[1].l:= _imageView;
  jParams[2].f:= _scaleX;
  jParams[3].f:= _scaleY;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScale', '(Landroid/graphics/Bitmap;Landroid/widget/ImageView;FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;


function jBitmap_SetScale(env: PJNIEnv; _jbitmap: JObject; _imageView: jObject; _scaleX: single; _scaleY: single): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _imageView;
  jParams[1].f:= _scaleX;
  jParams[2].f:= _scaleY;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScale', '(Landroid/widget/ImageView;FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;


function jBitmap_LoadFromAssets(env: PJNIEnv; _jbitmap: JObject; strName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(strName));
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssets', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

//by jmpessoa
procedure jBitmap_SetByteArrayToBitmap(env:PJNIEnv;  bmap: jObject; var bufferImage: TArrayOfByte; size: integer);
var
  _jMethod: jMethodID = nil;
  cls: jClass;
  _jParam: array[0..0] of jValue;
  _jbyteArray : jByteArray;
begin
   //Convert the Pascal's Native array[] of jbyte to JNI jbytearray
  _jbyteArray:= env^.NewByteArray(env, size);  // allocate
  env^.SetByteArrayRegion(env, _jbyteArray, 0 , size, @bufferImage[0] {source});  // copy
  _jParam[0].l:= _jbyteArray;
  cls := env^.GetObjectClass(env, bmap);
  _jMethod:= env^.GetMethodID(env, cls, 'SetByteArrayToBitmap', '([B)V');
  env^.CallVoidMethodA(env,bmap,_jMethod, @_jParam);
  env^.DeleteLocalRef(env,_jParam[0].l);
end;

//by jmpessoa
function jBitmap_GetByteArrayFromBitmap(env:PJNIEnv;  bmap: jObject;  var bufferImage: TArrayOfByte): integer;
var
  _jMethod: jMethodID = nil;
  _jbyteArray: jbyteArray;
  cls: jClass;
begin
 cls := env^.GetObjectClass(env, bmap);
 _jMethod:= env^.GetMethodID(env, cls, 'GetByteArrayFromBitmap', '()[B');
  _jbyteArray := env^.CallObjectMethod(env,bmap,_jMethod);
  Result:= env^.GetArrayLength(env,_jbyteArray);
  SetLength(bufferImage, Result);
  env^.GetByteArrayRegion(env, _jbyteArray, 0, Result, @bufferImage[0] {target});
end;

function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _bmp: jObject; _newWidth: integer; _newHeight: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bmp;
  jParams[1].i:= _newWidth;
  jParams[2].i:= _newHeight;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResizedBitmap', '(Landroid/graphics/Bitmap;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;

function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _newWidth: integer; _newHeight: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _newWidth;
  jParams[1].i:= _newHeight;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResizedBitmap', '(II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;

function jBitmap_GetResizedBitmap(env: PJNIEnv; _jbitmap: JObject; _factorScaleX: single; _factorScaleY: single): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _factorScaleX;
  jParams[1].f:= _factorScaleY;
  jCls:= env^.GetObjectClass(env, _jbitmap);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResizedBitmap', '(FF)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbitmap, jMethod, @jParams);
end;

//------------------------------------------------------------------------------
// jGLSurfaceView
//------------------------------------------------------------------------------
function jGLSurfaceView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject; version : integer): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jGLSurfaceView_Create', '(JI)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  _jParams[1].i := version;
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jGLSurfaceView_Free   (env:PJNIEnv; GLSurfaceView : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,GLSurfaceView,_jMethod);
  env^.DeleteGlobalRef(env,GLSurfaceView);
end;

Procedure jGLSurfaceView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        GLSurfaceView : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
   cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, GLSurfaceView);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

Procedure jGLSurfaceView_setParent(env:PJNIEnv;
                                   GLSurfaceView : jObject;ViewGroup : jObject);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
 end;

Procedure jGLSurfaceView_SetAutoRefresh(env:PJNIEnv; glView : jObject; Active : Boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].z := JBool(Active);
  cls := env^.GetObjectClass(env, glView);
   _jMethod:= env^.GetMethodID(env, cls, 'SetAutoRefresh', '(Z)V');
  env^.CallVoidMethodA(env,glView,_jMethod,@_jParams);
end;


Procedure jGLSurfaceView_getBmpArray(env:PJNIEnv; this: jobject;filename : String);
var
  _jMethod   : jMethodID = nil;
  _jParam    : jValue;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  //
  Size : Integer;
  PInt : PInteger;
  PIntS: PInteger;
 // i    : Integer;
 cls: jClass;
begin
  _jParam.l  := env^.NewStringUTF( env, pchar(filename));
  cls:= Get_gjClass(env);
  _jMethod:= env^.GetMethodID(env, cls, 'getBmpArray', '(Ljava/lang/String;)[I');
  _jIntArray := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);

  env^.DeleteLocalRef(env,_jParam.l);
  Size := env^.GetArrayLength(env,_jIntArray);

  //dbg('Size: ' + IntToStr(Size) );
  _jBoolean  := JNI_False;
  PInt := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
  PIntS:= PInt;
  Inc(PIntS,Size-2);
  //dbg('width:'  + IntToStr(PintS^)); Inc(PintS);
  //dbg('height:' + IntToStr(PintS^));
  env^.ReleaseIntArrayElements(env,_jIntArray,PInt,0);
  //dbg('Here...');
 end;

procedure jGLSurfaceView_Refresh(env:PJNIEnv; glView : jObject);
var
  _jMethod: jMethodID = nil;
  cls: jClass;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil); //<<-- (un)commented by by jmpessoa
  cls:= env^.GetObjectClass(env, glView);
  _jMethod:= env^.GetMethodID(env, cls, 'Refresh', '()V');
  env^.CallVoidMethod(env,glView,_jMethod);
end;

procedure jGLSurfaceView_deleteTexture(env:PJNIEnv; glView : jObject; id : Integer);
var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, glView);
  _jMethod:= env^.GetMethodID(env, cls, 'deleteTexture', '(I)V');
  env^.CallVoidMethodA(env,glView,_jMethod,@_jParams);
end;

Procedure jGLSurfaceView_requestGLThread(env: PJNIEnv; glView : jObject);
var
  _jMethod : jMethodID = nil;
   cls: jClass;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  cls := env^.GetObjectClass(env, glView);
   _jMethod:= env^.GetMethodID(env, cls, 'glThread', '()V');
  env^.CallVoidMethod(env,glView,_jMethod);
end;

//by jmpessoa
Procedure jGLSurfaceView_setId(env:PJNIEnv; GLSurfaceView : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setLParamWidth(env:PJNIEnv; GLSurfaceView : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

Procedure jGLSurfaceView_setLParamHeight(env:PJNIEnv; GLSurfaceView : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, GLSurfaceView);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

function jGLSurfaceView_getLParamHeight(env:PJNIEnv; GLSurfaceView : jObject ): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'getLParamHeight', '()I');
 Result:= env^.CallIntMethod(env,GLSurfaceView,_jMethod);
end;

function jGLSurfaceView_getLParamWidth(env:PJNIEnv; GLSurfaceView : jObject): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'getLParamWidth', '()I');
 Result:= env^.CallIntMethod(env,GLSurfaceView,_jMethod);
end;

//by jmpessoa
Procedure jGLSurfaceView_addLParamsParentRule(env:PJNIEnv; GLSurfaceView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_addLParamsAnchorRule(env:PJNIEnv; GLSurfaceView : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, GLSurfaceView);
  _jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

Procedure jGLSurfaceView_setLayoutAll(env:PJNIEnv; GLSurfaceView : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, GLSurfaceView);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,GLSurfaceView,_jMethod,@_jParams);
end;

//----------------------------
//View
//----------------------------------

function jView_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jView_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jView_Free(env:PJNIEnv; View : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
    cls := env^.GetObjectClass(env, View);
   _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
   env^.CallVoidMethod(env,View,_jMethod);
   env^.DeleteGlobalRef(env,View);
end;

function jView_getLParamHeight(env:PJNIEnv; View : jObject ): integer;
var
 _jMethod: jMethodID = nil;
 cls: jClass;
begin
  cls:= env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'getLParamHeight', '()I');
 Result:= env^.CallIntMethod(env,View,_jMethod);
end;

function jView_getLParamWidth(env:PJNIEnv; View : jObject): integer;
Var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'getLParamWidth', '()I');
 Result     := env^.CallIntMethod(env,View,_jMethod);
end;

Procedure jView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        View : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
 _jParams[0].i := ml;
 _jParams[1].i := mt;
 _jParams[2].i := mr;
 _jParams[3].i := mb;
 _jParams[4].i := w;
 _jParams[5].i := h;
 cls := env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;
//
Procedure jView_setParent(env:PJNIEnv;
                          View : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, View);
   _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

Procedure jView_setjCanvas(env:PJNIEnv;
                           View : jObject;jCanv : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].l := jCanv;
   cls := env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'setjCanvas', '(Ljava/lang/Object;)V');
  env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-14
Procedure jView_viewSave(env:PJNIEnv;
                          View : jObject; Filename : String);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(Filename) );
   cls := env^.GetObjectClass(env, View);
 _jMethod:= env^.GetMethodID(env, cls, 'saveView', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
Procedure jView_setId(env:PJNIEnv; View : jObject; id: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := id;
 cls := env^.GetObjectClass(env, View);
  _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jView_setLParamWidth(env:PJNIEnv; View : jObject; w: DWord);
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

Procedure jView_setLParamHeight(env:PJNIEnv; View : jObject; h: DWord);
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
Procedure jView_addLParamsParentRule(env:PJNIEnv; View : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

//by jmpessoa
procedure jView_addLParamsAnchorRule(env:PJNIEnv; View : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
  cls := env^.GetObjectClass(env, View);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,View,_jMethod,@_jParams);
end;

procedure jView_setLayoutAll(env:PJNIEnv; View : jObject;  idAnchor: DWord);
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

//------------------------------------------------------------------------------
// Timer
//------------------------------------------------------------------------------

Function jTimer_Create (env:PJNIEnv; this:jobject; SelfObj : TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jTimer_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jTimer_Free(env:PJNIEnv; Timer : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
 cls := env^.GetObjectClass(env, Timer);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,Timer,_jMethod);
 env^.DeleteGlobalRef(env,Timer);
end;

Procedure jTimer_SetInterval(env:PJNIEnv; Timer  : jObject; Interval : Integer);
var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..0] of jValue;
   cls: jClass;
begin
  _jParams[0].i:= Interval;
  cls := env^.GetObjectClass(env, Timer);
  _jMethod:= env^.GetMethodID(env, cls, 'SetInterval', '(I)V');
  env^.CallVoidMethodA(env,Timer,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTimer_SetEnabled(env: PJNIEnv; Timer: jObject; Active: Boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..0] of jValue;
   cls: jClass;
begin
  _jParams[0].z := JBool(Active);
  cls := env^.GetObjectClass(env, Timer);
  _jMethod:= env^.GetMethodID(env, cls, 'SetEnabled', '(Z)V');
  env^.CallVoidMethodA(env,Timer,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// jDialog YN
//------------------------------------------------------------------------------

Function jDialogYN_Create (env:PJNIEnv; this:jobject; SelfObj : TObject;
                           title,msg,y,n : string ): jObject;

var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..4] of jValue;
 cls: jClass;
begin
 cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 _jMethod:= env^.GetMethodID(env, cls, 'jDialogYN_Create', '(JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;');
 _jParams[0].j := Int64(SelfObj);
 _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(Msg  ) );
 _jParams[3].l := env^.NewStringUTF(env, pchar(y    ) );
 _jParams[4].l := env^.NewStringUTF(env, pchar(n    ) );

 Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
 Result := env^.NewGlobalRef(env,Result);

 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,_jParams[3].l);
 env^.DeleteLocalRef(env,_jParams[4].l);
end;


Procedure jDialogYN_Free(env:PJNIEnv; DialogYN : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, DialogYN);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,DialogYN,_jMethod);
  env^.DeleteGlobalRef(env,DialogYN);
end;

Procedure jDialogYN_Show(env:PJNIEnv; DialogYN: jObject);
var
 _jMethod: jMethodID = nil;
 _jParam: jValue;
 cls: jClass;
begin
 cls:= env^.GetObjectClass(env, DialogYN);
 _jMethod:= env^.GetMethodID(env, cls, 'show', '()V');
 env^.CallVoidMethodA(env,DialogYN,_jMethod,@_jParam);
end;

//------------------------------------------------------------------------------
// jDialog Progress
//------------------------------------------------------------------------------

Function jDialogProgress_Create(env:PJNIEnv; this:jobject; SelfObj : TObject;
                                 title, msg: string ): jObject;
var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..2] of jValue;
  cls: jClass;
 begin
  cls:= Get_gjClass(env); {global}
   {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jDialogProgress_Create', '(JLjava/lang/String;Ljava/lang/String;)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(Msg  ) );

  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);

  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
end;

Procedure jDialogProgress_Free(env:PJNIEnv; DialogProgress : jObject);
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls:= env^.GetObjectClass(env, DialogProgress);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,DialogProgress,_jMethod);
  env^.DeleteGlobalRef(env,DialogProgress);
end;

//------------------------------------------------------------------------------
// MessageBox , Dialog
//------------------------------------------------------------------------------

Procedure jToast (env:PJNIEnv; this:jobject; Str : String);
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
 cls: jClass;
begin
 cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
 _jMethod:= env^.GetMethodID(env, cls, 'jToast', '(Ljava/lang/String;)V');
 _jParam.l := env^.NewStringUTF(env, pchar(Str) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 env^.DeleteLocalRef(env,_jParam.l);
end;

//------------------------------------------------------------------------------
// jImageBtn
//------------------------------------------------------------------------------
//by jmpessoa
function jImageBtn_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}
  {jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jImageBtn_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jImageBtn_Free(env:PJNIEnv; ImageBtn : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
 cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,ImageBtn,_jMethod);
 env^.DeleteGlobalRef(env,ImageBtn);
end;

Procedure jImageBtn_setLeftTopRightBottomWidthHeight(env:PJNIEnv;
                                        ImageBtn : jObject; ml,mt,mr,mb,w,h: integer);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
 cls: jClass;
begin
  _jParams[0].i := ml;
  _jParams[1].i := mt;
  _jParams[2].i := mr;
  _jParams[3].i := mb;
  _jParams[4].i := w;
  _jParams[5].i := h;
 cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setLeftTopRightBottomWidthHeight', '(IIIIII)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;

Procedure jImageBtn_setParent(env:PJNIEnv;
                               ImageBtn : jObject;ViewGroup : jObject);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := ViewGroup;
  cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'setParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 end;

//
Procedure jImageBtn_setButton(env:PJNIEnv;
                              ImageBtn: jObject; up,dn : string);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..2] of jValue;
  cls: jClass;
 begin
  _jParams[1].l := env^.NewStringUTF(env, pchar(up) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(dn) );
  cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'setButton', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
 end;

Procedure jImageBtn_setButtonUp(env:PJNIEnv;
                              ImageBtn: jObject; up: string);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(up) );
   cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'setButtonUp', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
 end;

Procedure jImageBtn_setButtonDown(env:PJNIEnv;
                             ImageBtn: jObject; dn: string);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(dn) );
  cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setButtonDown', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jImageBtn_setButtonDownByRes(env:PJNIEnv;
                                        ImageBtn : jObject; imgResIdentifief: String);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(imgResIdentifief) );
  cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setButtonDownByRes', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jImageBtn_setButtonUpByRes(env:PJNIEnv;
                                        ImageBtn : jObject; imgResIdentifief: String);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].l := env^.NewStringUTF(env, pchar(imgResIdentifief) );
  cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setButtonUpByRes', '(Ljava/lang/String;)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
end;


// LORDMAN 2013-08-16
Procedure jImageBtn_SetEnabled (env:PJNIEnv;
                                ImageBtn : jObject; Active   : Boolean);
var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].z := JBool(Active);
  cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'setEnabled', '(Z)V');
  env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 end; 

Procedure jImageBtn_setId(env:PJNIEnv; ImageBtn : jObject; id: DWord);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i := id;
  cls := env^.GetObjectClass(env, ImageBtn);
 _jMethod:= env^.GetMethodID(env, cls, 'setId', '(I)V');
  env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
 end;

Procedure jImageBtn_setLParamWidth(env:PJNIEnv; ImageBtn : jObject; w: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := w;
 cls := env^.GetObjectClass(env, ImageBtn);
  _jMethod:= env^.GetMethodID(env, cls, 'setLParamWidth', '(I)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;

Procedure jImageBtn_setLParamHeight(env:PJNIEnv; ImageBtn : jObject; h: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := h;
  cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setLParamHeight', '(I)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_addLParamsParentRule(env:PJNIEnv; ImageBtn : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsParentRule', '(I)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jImageBtn_addLParamsAnchorRule(env:PJNIEnv; ImageBtn : jObject; rule: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := rule;
 cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'addLParamsAnchorRule', '(I)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;


Procedure jImageBtn_setLayoutAll(env:PJNIEnv; ImageBtn : jObject;  idAnchor: DWord);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
 _jParams[0].i := idAnchor;
 cls := env^.GetObjectClass(env, ImageBtn);
_jMethod:= env^.GetMethodID(env, cls, 'setLayoutAll', '(I)V');
 env^.CallVoidMethodA(env,ImageBtn,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// jAsyncTask
//------------------------------------------------------------------------------
//by jmpessoa
function jAsyncTask_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env); {global}          {warning: a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jAsyncTask_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jAsyncTask_Free(env:PJNIEnv; AsyncTask : jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, AsyncTask);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env,AsyncTask,_jMethod);
  env^.DeleteGlobalRef(env,AsyncTask);
end;

procedure jAsyncTask_Execute(env:PJNIEnv; AsyncTask : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
  cls := env^.GetObjectClass(env, AsyncTask); //GetObjectClass
  _jMethod:= env^.GetMethodID(env, cls, 'Execute', '()V');
 env^.CallVoidMethod(env,AsyncTask,_jMethod);
end;

Procedure jAsyncTask_setProgress(env:PJNIEnv; AsyncTask : jObject; Progress : Integer);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].i := progress;
  cls := env^.GetObjectClass(env, AsyncTask);
  _jMethod:= env^.GetMethodID(env, cls, 'setProgress', '(I)V');
 env^.CallVoidMethodA(env,AsyncTask,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jAsyncTask_SetAutoPublishProgress(env:PJNIEnv; AsyncTask : jObject; Value : boolean);
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..0] of jValue;
  cls: jClass;
begin
 _jParams[0].z := JBool(Value);
  cls := env^.GetObjectClass(env, AsyncTask);
 _jMethod:= env^.GetMethodID(env, cls, 'SetAutoPublishProgress', '(Z)V');
 env^.CallVoidMethodA(env, AsyncTask,_jMethod,@_jParams);
end;

{jSqliteCursor by jmpessoa}

Function jSqliteCursor_Create(env: PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env);           {a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jSqliteCursor_Create', '(J)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
end;

Procedure jSqliteCursor_Free(env:PJNIEnv; SqliteCursor: jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
begin
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
  env^.CallVoidMethod(env, SqliteCursor,_jMethod);
  env^.DeleteGlobalRef(env,SqliteCursor);
end;

procedure jSqliteCursor_SetCursor(env:PJNIEnv; SqliteCursor: jObject; Cursor: jObject);
var
   _jMethod : jMethodID = nil;
   cls: jClass;
   _jParam: array[0..0] of jValue;
begin
  _jParam[0].l:= Cursor;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'SetCursor', '(Landroid/database/Cursor;)V');
  env^.CallVoidMethodA(env, SqliteCursor,_jMethod, @_jParam);
end;

Function jSqliteCursor_GetCursor (env:PJNIEnv;  SqliteCursor: jObject) : jObject;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetCursor', '()Landroid/database/Cursor;');
 Result := env^.CallObjectMethod(env,SqliteCursor,_jMethod);
end;

procedure jSqliteCursor_MoveToFirst(env:PJNIEnv;  SqliteCursor: jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'MoveToFirst', '()V');
 env^.CallVoidMethod(env,SqliteCursor,_jMethod);
end;

procedure jSqliteCursor_MoveToNext(env:PJNIEnv;  SqliteCursor: jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'MoveToNext', '()V');
 env^.CallVoidMethod(env,SqliteCursor,_jMethod);
end;

procedure jSqliteCursor_MoveToLast(env:PJNIEnv;  SqliteCursor: jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'MoveToLast', '()V');
 env^.CallVoidMethod(env,SqliteCursor,_jMethod);
end;

procedure jSqliteCursor_MoveToPosition(env:PJNIEnv;  SqliteCursor: jObject; position: integer);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _lparam: array[0..0] of jValue;
begin
 _lparam[0].i := position;
 cls := env^.GetObjectClass(env, SqliteCursor);
   _jMethod:= env^.GetMethodID(env, cls, 'MoveToPosition', '(I)V');
 env^.CallVoidMethodA(env,SqliteCursor,_jMethod, @_lparam);
end;

Function jSqliteCursor_GetRowCount(env:PJNIEnv;  SqliteCursor: jObject): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetRowCount', '()I');
 Result := env^.CallIntMethod(env,SqliteCursor,_jMethod);
end;

Function jSqliteCursor_GetColumnCount(env:PJNIEnv;  SqliteCursor: jObject):  integer;
var
  _jMethod : jMethodID = nil;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetColumnCount', '()I');
  Result:= env^.CallIntMethod(env,SqliteCursor,_jMethod);
end;

Function jSqliteCursor_GetColumName(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): string;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
 _jString  : jString;
 _jBoolean : jBoolean;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetColumName', '(I)Ljava/lang/String;');
  _jString   := env^.CallObjectMethodA(env,SqliteCursor,_jMethod,@_jParam);
  case _jString = nil of
    True : Result    := '';
    False: begin
            _jBoolean := JNI_False;
            Result    := String( env^.GetStringUTFChars(env,_jString,@_jBoolean) );
           end;
  end;
end;

Function jSqliteCursor_GetColumnIndex(env:PJNIEnv;  SqliteCursor: jObject; colName: string): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
 _jParam[0].l := env^.NewStringUTF(env, pchar(colName));
 cls := env^.GetObjectClass(env, SqliteCursor);
 _jMethod:= env^.GetMethodID(env, cls, 'GetColumnIndex', '(Ljava/lang/String;)I');
 Result := env^.CallIntMethodA(env,SqliteCursor,_jMethod, @_jParam);
 env^.DeleteLocalRef(env,_jParam[0].l);
end;

Function jSqliteCursor_GetColType(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): integer;
var
 _jMethod: jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
 _jParam[0].i:= columnIndex;
 cls:= env^.GetObjectClass(env, SqliteCursor);
 _jMethod:= env^.GetMethodID(env, cls, 'GetColType', '(I)I');
 Result := env^.CallIntMethodA(env,SqliteCursor,_jMethod, @_jParam);
end;

Function jSqliteCursor_GetValueAsString(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): string;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
  _jString  : jString;
 _jBoolean : jBoolean;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetValueAsString', '(I)Ljava/lang/String;');
  _jString   := env^.CallObjectMethodA(env,SqliteCursor,_jMethod,@_jParam);
  case _jString = nil of
    True : Result    := '';
    False: begin
            _jBoolean := JNI_False;
            Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
end;

function jSqliteCursor_GetValueAsBitmap(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): jObject;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetValueAsBitmap', '(I)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env,SqliteCursor,_jMethod,@_jParam);
end;

function jSqliteCursor_GetValueAsInteger(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): integer;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetValueAsInteger', '(I)I');
  Result:= env^.CallIntMethodA(env,SqliteCursor,_jMethod,@_jParam);
end;

function jSqliteCursor_GetValueAsDouble(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): double;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetValueAsDouble', '(I)D');
  Result:= env^.CallDoubleMethodA(env,SqliteCursor,_jMethod,@_jParam);
end;

function jSqliteCursor_GetValueAsFloat(env:PJNIEnv;  SqliteCursor: jObject; columnIndex: integer): real;
var
 _jMethod : jMethodID = nil;
 cls: jClass;
 _jParam: array[0..0] of jValue;
begin
  _jParam[0].i := columnIndex;
  cls := env^.GetObjectClass(env, SqliteCursor);
  _jMethod:= env^.GetMethodID(env, cls, 'GetValueAsFloat', '(I)F');
  Result:= env^.CallDoubleMethodA(env,SqliteCursor,_jMethod,@_jParam);
end;

 {jSqliteDataAccess - by jmpessoa}

Function  jSqliteDataAccess_Create(env: PJNIEnv; this:jobject; SelfObj: TObject;
                                         dataBaseName: string; colDelimiter: char; rowDelimiter: char): jObject;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..3] of jValue;
 cls: jClass;
begin
  cls:= Get_gjClass(env);           {a jmethodID is not an object. So don't need to convert it to a GlobalRef!}
  _jMethod:= env^.GetMethodID(env, cls, 'jSqliteDataAccess_Create', '(JLjava/lang/String;CC)Ljava/lang/Object;');
  _jParams[0].j := Int64(SelfObj);
  _jParams[1].l := env^.NewStringUTF(env, pchar(dataBaseName));
  _jParams[2].c := jChar(colDelimiter);
  _jParams[3].c := jChar(rowDelimiter);
  Result := env^.CallObjectMethodA(env, this, _jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[1].l);
end;

//by jmpessoa
Procedure jSqliteDataAccess_Free(env:PJNIEnv; SqliteDataBase : jObject);
var
 _jMethod : jMethodID = nil;
 cls: jClass;
begin
 cls := env^.GetObjectClass(env, SqliteDataBase);
 _jMethod:= env^.GetMethodID(env, cls, 'Free', '()V');
 env^.CallVoidMethod(env,SqliteDataBase,_jMethod);
 env^.DeleteGlobalRef(env,SqliteDataBase);
end;

//java: public void ExecSQL(String execQuery)
Procedure jSqliteDataAccess_ExecSQL(env:PJNIEnv; SqliteDataBase : jObject; execQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(execQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'ExecSQL', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jSqliteDataAccess_OpenOrCreate(env:PJNIEnv; SqliteDataBase : jObject; dataBaseName: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(dataBaseName));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'OpenOrCreate', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jSqliteDataAccess_AddTableName(env:PJNIEnv; SqliteDataBase: jObject; tableName: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(tableName));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'AddTableName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jSqliteDataAccess_AddCreateTableQuery(env:PJNIEnv; SqliteDataBase: jObject; createTableQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(createTableQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'AddCreateTableQuery', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jSqliteDataAccess_CreateTable(env:PJNIEnv; SqliteDataBase: jObject; createQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(createQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'ExecSQL', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

Procedure jSqliteDataAccess_DropTable(env:PJNIEnv;  SqliteDataBase: jObject; tableName: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(tableName));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'ExecSQL', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

function jSqliteDataAccess_Select(env:PJNIEnv;  SqliteDataBase:jObject; selectQuery: string): string;
var
  _jMethod : jMethodID = nil;
  _jString : jString;
  _jBoolean: jBoolean;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  cls := env^.GetObjectClass(env, SqliteDataBase);
  _jMethod:= env^.GetMethodID(env, cls, 'SelectS', '(Ljava/lang/String;)Ljava/lang/String;');
  _jParams[0].l:= env^.NewStringUTF(env, pchar(selectQuery));
  _jString:= env^.CallObjectMethodA(env,SqliteDataBase,_jMethod, @_jParams);
  case _jString = nil of
    True : Result    := '';
    False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(env,_jString,@_jBoolean) );
          end;
  end;
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jSqliteDataAccess_Select(env:PJNIEnv;  SqliteDataBase: jObject; selectQuery: string);
var
  cls: jClass;
  _methodID: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, PChar(selectQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'SelectV', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, _methodID,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

function jSqliteDataAccess_GetCursor(env:PJNIEnv;  SqliteDataBase: jObject): jObject;
var
  cls: jClass;
  _methodID: jmethodID;
begin
  cls := env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'GetCursor', '()Landroid/database/Cursor;');
  Result  := env^.CallObjectMethod(env, SqliteDataBase, _methodID);
end;

//java:  public boolean CheckDataBase(String pathDB)
function jSqliteDataAccess_CheckDataBaseExists(env:PJNIEnv;  SqliteDataBase: jObject; fullPathDB: string): boolean;
var
  cls: jClass;
  _methodID: jmethodID;
  _jParams : array[0..0] of jValue;
  _jBoolean: jBoolean;
begin
  _jParams[0].l := env^.NewStringUTF(env, PChar(fullPathDB));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'CheckDataBaseExists', '(Ljava/lang/String;)V');
  _jBoolean  := env^.CallBooleanMethodA(env, SqliteDataBase, _methodID,@_jParams);
  Result     := boolean(_jBoolean);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jSqliteDataAccess_CreateAllTables(env:PJNIEnv; SqliteDataBase: jObject);
var
  cls: jClass;
  _methodID: jmethodID;
begin
  cls := env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'CreateAllTables', '()V');
  env^.CallVoidMethod(env, SqliteDataBase, _methodID);
end;

procedure jSqliteDataAccess_DropAllTables(env:PJNIEnv; SqliteDataBase: jObject; recreate: boolean);
var
   cls: jClass;
  _methodID: jmethodID;
  _jParams: array[0..0] of jValue;
begin
  _jParams[0].z:= jBool(recreate);
  cls:= env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'DropAllTables', '(Z)V');
  env^.CallVoidMethodA(env, SqliteDataBase, _methodID,@_jParams);
end;

procedure jSqliteDataAccess_SetSelectDelimiters(env:PJNIEnv; SqliteDataBase: jObject;
                              coldelim: char; rowdelim: char);
var
   cls: jClass;
  _methodID: jmethodID;
  _jParams: array[0..1] of jValue;
begin
 _jParams[0].c := jChar(coldelim);
 _jParams[1].c := jChar(rowdelim);
   cls:= env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'SetSelectDelimiters', '(CC)V');
  env^.CallVoidMethodA(env, SqliteDataBase, _methodID,@_jParams);
end;


procedure jSqliteDataAccess_InsertIntoTable(env:PJNIEnv; SqliteDataBase: jObject; insertQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(insertQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'InsertIntoTable', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jSqliteDataAccess_UpdateImage(env:PJNIEnv; SqliteDataBase: jObject;
                                          tableName: string;
                                          imageFieldName: string;
                                          keyFieldName: string;
                                          imageValue: jObject;
                                          keyValue: integer);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..4] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(tableName));
  _jParams[1].l := env^.NewStringUTF(env, pchar(imageFieldName));
  _jParams[2].l := env^.NewStringUTF(env, pchar(keyFieldName));
  _jParams[3].l:= imageValue;
  _jParams[4].i := keyValue;
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'UpdateImage',
                                      '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;I)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
end;


procedure jSqliteDataAccess_DeleteFromTable(env:PJNIEnv; SqliteDataBase: jObject; deleteQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(deleteQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'DeleteFromTable', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jSqliteDataAccess_UpdateTable(env:PJNIEnv; SqliteDataBase: jObject; updateQuery: string);
var
  cls: jClass;
  method: jmethodID;
  _jParams : array[0..0] of jValue;
begin
  _jParams[0].l := env^.NewStringUTF(env, pchar(updateQuery));
  cls := env^.GetObjectClass(env, SqliteDataBase);
  method:= env^.GetMethodID(env, cls, 'UpdateTable', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, SqliteDataBase, method,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
end;

procedure jSqliteDataAccess_Close(env:PJNIEnv; SqliteDataBase: jObject);
var
   cls: jClass;
  _methodID: jmethodID;
begin
   cls:= env^.GetObjectClass(env, SqliteDataBase);
  _methodID:= env^.GetMethodID(env, cls, 'Close', '()V');
  env^.CallVoidMethod(env, SqliteDataBase, _methodID);
end;

procedure jSqliteDataAccess_SetForeignKeyConstraintsEnabled(env: PJNIEnv; _jsqlitedataaccess: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'SetForeignKeyConstraintsEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
end;


procedure jSqliteDataAccess_SetDefaultLocale(env: PJNIEnv; _jsqlitedataaccess: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDefaultLocale', '()V');
  env^.CallVoidMethod(env, _jsqlitedataaccess, jMethod);
end;


procedure jSqliteDataAccess_DeleteDatabase(env: PJNIEnv; _jsqlitedataaccess: JObject; _dbName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dbName));
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'DeleteDatabase', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jSqliteDataAccess_UpdateImage(env: PJNIEnv; _jsqlitedataaccess: JObject; _tabName: string; _imageFieldName: string; _keyFieldName: string; _imageResIdentifier: string; _keyValue: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_tabName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_imageFieldName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_keyFieldName));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jParams[4].i:= _keyValue;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateImage', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
end;


procedure jSqliteDataAccess_InsertIntoTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _insertQueries: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_insertQueries);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_insertQueries[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'InsertIntoTableBatch', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jSqliteDataAccess_UpdateTableBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _updateQueries: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_updateQueries);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_updateQueries[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateTableBatch', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


function jSqliteDataAccess_CheckDataBaseExistsByName(env: PJNIEnv; _jsqlitedataaccess: JObject; _dbName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dbName));
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'CheckDataBaseExistsByName', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
  Result:= boolean(jBoo);
   env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jSqliteDataAccess_UpdateImageBatch(env: PJNIEnv; _jsqlitedataaccess: JObject; var _imageResIdentifierDataArray: TDynArrayOfString; _delimiter: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_imageResIdentifierDataArray);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_imageResIdentifierDataArray[i])));
  end;
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jsqlitedataaccess);
  jMethod:= env^.GetMethodID(env, jCls, 'UpdateImageBatch', '([Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsqlitedataaccess, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

{-------- jHttpClient_JNI_Bridge ----------}

function jHttpClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jHttpClient_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jHttpClient_jCreate(long _Self) {
      return (java.lang.Object)(new jHttpClient(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jHttpClient_jFree(env: PJNIEnv; _jhttpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jhttpclient, jMethod);
end;


function  jHttpClient_Get(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_stringUrl));
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Get', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jhttpclient, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jHttpClient_SetAuthenticationUser(env: PJNIEnv; _jhttpclient: JObject; _userName: string; _password: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_userName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAuthenticationUser', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;


procedure jHttpClient_SetAuthenticationMode(env: PJNIEnv; _jhttpclient: JObject; _authenticationMode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _authenticationMode;
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAuthenticationMode', '(I)V');
  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);
end;

procedure jHttpClient_SetAuthenticationHost(env: PJNIEnv; _jhttpclient: JObject; _hostName: string; _port: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hostName));
  jParams[1].i:= _port;
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAuthenticationHost', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jhttpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

function jHttpClient_PostNameValueData(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string; _name: string; _value: string): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_stringUrl));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_value));
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'PostNameValueData', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jhttpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

function jHttpClient_PostNameValueData(env: PJNIEnv; _jhttpclient: JObject; _stringUrl: string; _listNameValue: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_stringUrl));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_listNameValue));
  jCls:= env^.GetObjectClass(env, _jhttpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'PostNameValueData', '(Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jhttpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

//by jmpessoa
procedure jSend_Email(env:PJNIEnv; this:jobject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..4] of jValue;
 jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jSend_Email', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');

 _jParams[0].l := env^.NewStringUTF(env, pchar(sto) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(scc) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(sbcc) );
 _jParams[3].l := env^.NewStringUTF(env, pchar(ssubject) );
 _jParams[4].l := env^.NewStringUTF(env, pchar(smessage) );

 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);

 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,_jParams[3].l);
 env^.DeleteLocalRef(env,_jParams[4].l);
end;


//by jmpessoa
function jSend_SMS(env:PJNIEnv; this:jobject;
                       toNumber: string;
                       smessage:string): integer;
var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jSend_SMS', '(Ljava/lang/String;Ljava/lang/String;)I');
 _jParams[0].l := env^.NewStringUTF(env, pchar(toNumber) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(smessage) );
 Result:= env^.CallIntMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

//by jmpessoa
function jContact_getMobileNumberByDisplayName(env:PJNIEnv; this:jobject;
                                               contactName: string): string;
var
 _jMethod  : jMethodID = nil;
 _jString  : jString;
 _jBoolean : jBoolean;
 _jParams : array[0..0] of jValue;
 jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jContact_getMobileNumberByDisplayName', '(Ljava/lang/String;)Ljava/lang/String;');
 _jParams[0].l := env^.NewStringUTF(env, pchar(contactName) );
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParams[0].l);
end;

//by jmpessoa
function jContact_getDisplayNameList(env:PJNIEnv; this:jobject; delimiter: char): string;
var
 _jMethod  : jMethodID = nil;
 _jString  : jString;
 _jBoolean : jBoolean;
 _jParams : array[0..0] of jValue;
 jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jContact_getDisplayNameList', '(C)Ljava/lang/String;');
 _jParams[0].c := jChar(delimiter);
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
end;

//------------------------------------------------------------------------------
// jCamera               - //Use: filename = App.Path.DCIM + '/test.jpg
//------------------------------------------------------------------------------
Procedure jTakePhoto(env:PJNIEnv;  this:jobject; filename : String);
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
 jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'takePhoto', '(Ljava/lang/String;)V');
 _jParam.l:= env^.NewStringUTF(env, pchar(filename) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 env^.DeleteLocalRef(env,_jParam.l);
end;

//by jmpessoa   - //Use: path =  App.Path.DCIM
                  //     filename = '/test.jpg'
function jCamera_takePhoto(env:PJNIEnv;  this:jobject; path: string; filename : String): string;
var
 _jMethod  : jMethodID = nil;
 _jParams : array[0..1] of jValue;
 _jString  : jString;
 _jBoolean : jBoolean;
  jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jCamera_takePhoto', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
 _jParams[0].l := env^.NewStringUTF(env, pchar(path) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(filename) );
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

function jCamera_takePhoto(env:PJNIEnv; this:jobject;  path: string;  filename : String; requestCode: integer): string;
var
 _jMethod  : jMethodID = nil;
 _jParams : array[0..2] of jValue;
 _jString  : jString;
 _jBoolean : jBoolean;
  jCls: jClass=nil;
begin
 jCls:= Get_gjClass(env);
 _jMethod:= env^.GetMethodID(env, jCls, 'jCamera_takePhoto', '(Ljava/lang/String;Ljava/lang/String;I)Ljava/lang/String;');
 _jParams[0].l := env^.NewStringUTF(env, pchar(path) );
 _jParams[1].l := env^.NewStringUTF(env, pchar(filename) );
 _jParams[2].i := requestCode;
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParams[0].l);
 env^.DeleteLocalRef(env,_jParams[1].l);
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
Const
 _cFuncName = 'benchMark1';
 _cFuncSig  = '()[F';
Var
 _jMethod      : jMethodID = nil;
 _jFloatArray  : jFloatArray;
 _jBoolean     : jBoolean;
 PFloat        : PSingle;
 PFloatSav     : PSingle;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jFloatArray := env^.CallObjectMethod(env,this,_jMethod);
 _jBoolean    := JNI_False;
 PFloat       := env^.GetFloatArrayElements(env,_jFloatArray,_jBoolean);
 PFloatSav    := PFloat;
 mSec         := Round(PFloat^); Inc(PFloat);
 value        := Round(PFloat^); Inc(PFloat);
 env^.ReleaseFloatArrayElements(env,_jFloatArray,PFloatSav,0);
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
