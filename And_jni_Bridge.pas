//------------------------------------------------------------------------------
//
// Android JNI Interface for Pascal/Delphi
//
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

interface

uses
  SysUtils,Classes,ctypes,
  And_jni, And_bitmap_h;

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

// Utility

procedure dbg(str : String); overload;
procedure dbg(obj : jObject; objName : String); overload;

// Jni
//function  JNI_OnLoad                   (vm:PJavaVM;reserved:pointer):jint; cdecl;
//procedure JNI_OnUnload                 (vm:PJavaVM;reserved:pointer); cdecl;

// Base 
Function  jStr_getLength               (env:PJNIEnv;this:jobject; Str : String): Integer;
Function  jStr_getDateTime             (env:PJNIEnv;this:jobject): String;
Function  jgetTick                     (env:PJNIEnv;this:jobject) : LongInt;

// System
Procedure jSystem_GC                   (env:PJNIEnv;this:jobject);
Procedure jSystem_SetOrientation       (env:PJNIEnv;this:jobject; orientation : Integer);

//by jmpessoa
function jSystem_GetOrientation        (env:PJNIEnv;this:jobject; context: jObject): integer;

// Class
Procedure jClass_setNull               (env:PJNIEnv;this:jobject; ClassObj : jClass);
Procedure jClass_chkNull               (env:PJNIEnv;this:jobject; ClassObj : jClass);

// App - Activity
Procedure jApp_Finish                  (env:PJNIEnv;this:jobject);
Procedure jApp_KillProcess             (env:PJNIEnv;this:jobject);
Procedure jApp_ScreenStyle             (env:PJNIEnv;this:jobject; screenstyle : integer);
// Asset
Function  jAsset_SaveToFile            (env:PJNIEnv; this:jobject; src,dst:String) : Boolean;
//
//
Function  jForm_Create                 (env:PJNIEnv;this:jobject; SelfObj : TObject) : jObject;
Procedure jForm_Free                   (env:PJNIEnv;this:jobject; Form    : jObject);
Procedure jForm_Show                   (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);
Procedure jForm_Close                  (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);
Function  jForm_GetLayout              (env:PJNIEnv;this:jobject; Form    : jObject) : jObject;
Procedure jForm_SetVisibility          (env:PJNIEnv;this:jobject; Form    : jObject; visible : Boolean);
Procedure jForm_SetEnabled             (env:PJNIEnv;this:jobject; Form    : jObject; enabled : Boolean);

// System Info
Function  jSysInfo_ScreenWH            (env:PJNIEnv;this:jobject;context : jObject) : TWH;
Function  jSysInfo_PathApp             (env:PJNIEnv;this:jobject;context : jObject; AppName : String) : String;
Function  jSysInfo_PathDat             (env:PJNIEnv;this:jobject;context : jObject) : String;
Function  jSysInfo_PathExt             (env:PJNIEnv;this:jobject) : String;
Function  jSysInfo_PathDCIM            (env:PJNIEnv;this:jobject) : String;


// Device Info
Function  jSysInfo_DevicePhoneNumber   (env:PJNIEnv;this:jobject) : String;
Function  jSysInfo_DeviceID            (env:PJNIEnv;this:jobject) : String;

// Image
Function  jImage_getWH                 (env:PJNIEnv;this:jobject; filename : String ) : TWH;
Function  jImage_resample              (env:PJNIEnv;this:jobject; filename : String; size : integer ) : jObject;
Procedure jImage_save                  (env:PJNIEnv;this:jobject; Bitmap : jObject; filename : String);

// View
Procedure jView_SetVisible             (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean);
Procedure jView_SetBackGroundColor     (env:PJNIEnv;this:jobject; view : jObject; color   : DWord  );
Procedure jView_Invalidate             (env:PJNIEnv;this:jobject; view : jObject);

//Function  jView_getID                  (env:PJNIEnv;this:jobject; View : jObject) : Integer;
//Procedure jView_setID                  (env:PJNIEnv;this:jobject; View : jObject; id : Integer);
//Function  jView_getTag                 (env:PJNIEnv;this:jobject; View : jObject) : Integer;

Function  jView_Create                 (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jView_Free                   (env:PJNIEnv;this:jobject; View : jObject);
//
Procedure jView_setXYWH                (env:PJNIEnv;this:jobject;
                                        View : jObject;x,y,w,h : integer);
Procedure jView_setParent              (env:PJNIEnv;this:jobject;
                                        View : jObject;ViewGroup : jObject);
Procedure jView_setjCanvas             (env:PJNIEnv;this:jobject;
                                        View : jObject;jCanvas   : jObject);
Procedure jView_viewSave               (env:PJNIEnv;this:jobject;
                                        View : jObject; Filename: String );
//by jmpessoa
Procedure jView_setId(env:PJNIEnv;this:jobject; View : jObject; id: DWord);
Procedure jView_setMarginLeft(env:PJNIEnv;this:jobject; View : jObject; x: DWord);
Procedure jView_setMarginTop(env:PJNIEnv;this:jobject; View : jObject; y: DWord);
Procedure jView_setMarginRight(env:PJNIEnv;this:jobject; View : jObject; x: DWord);
Procedure jView_setMarginBottom(env:PJNIEnv;this:jobject; View : jObject; y: DWord);
Procedure jView_setLParamWidth(env:PJNIEnv;this:jobject; View : jObject; w: DWord);
Procedure jView_setLParamHeight(env:PJNIEnv;this:jobject; View : jObject; h: DWord);

Procedure jView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        View : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jView_addLParamsParentRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Procedure jView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Procedure jView_setLayoutAll(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);


function jView_getLParamHeight(env:PJNIEnv;this:jobject; View : jObject ): integer;
function jView_getLParamWidth(env:PJNIEnv;this:jobject; View : jObject): integer;


// TextView 
Function  jTextView_Create             (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jTextView_Free               (env:PJNIEnv;this:jobject; TextView : jObject);
//
Procedure jTextView_setEnabled         (env:PJNIEnv;this:jobject;
                                        TextView : jObject; enabled : Boolean);
Procedure jTextView_setXYWH            (env:PJNIEnv;this:jobject;
                                        TextView : jObject;x,y,w,h : integer);
Procedure jTextView_setParent          (env:PJNIEnv;this:jobject;
                                        TextView : jObject;ViewGroup : jObject);
Procedure jTextView_setParent2         (env:PJNIEnv;this:jobject;
                                        TextView : jObject;ViewGroup : jObject);

Function  jTextView_getText            (env:PJNIEnv;this:jobject; TextView : jObject) : String;
Procedure jTextView_setText            (env:PJNIEnv;this:jobject; TextView : jObject; Str : String);
Procedure jTextView_setTextColor       (env:PJNIEnv;this:jobject; TextView : jObject; color : DWord);
Procedure jTextView_setTextSize        (env:PJNIEnv;this:jobject; TextView : jObject; size  : DWord);
Procedure jTextView_setTextAlignment   (env:PJNIEnv;this:jobject; TextView : jObject; align : DWord);
//by jmpessoa
Procedure jTextView_setLParamWidth(env:PJNIEnv;this:jobject; TextView : jObject; w: DWord);
Procedure jTextView_setLParamHeight(env:PJNIEnv;this:jobject; TextView : jObject; h: DWord);


Procedure jTextView_addLParamsParentRule(env:PJNIEnv;this:jobject; TextView : jObject; rule: DWord);
Procedure jTextView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; TextView : jObject; rule: DWord);
Procedure jTextView_setLayoutAll(env:PJNIEnv;this:jobject; TextView : jObject; idAnchor: DWord);
Procedure jTextView_setId(env:PJNIEnv;this:jobject; TextView : jObject; id: DWord);
Procedure jTextView_setMarginLeft(env:PJNIEnv;this:jobject; TextView : jObject; x: DWord);
Procedure jTextView_setMarginTop(env:PJNIEnv;this:jobject; TextView : jObject; y: DWord);
Procedure jTextView_setMarginRight(env:PJNIEnv;this:jobject; TextView : jObject; x: DWord);
Procedure jTextView_setMarginBottom(env:PJNIEnv;this:jobject; TextView : jObject; y: DWord);
Procedure jTextView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        TextView : jObject; ml,mt,mr,mb,w,h: integer);


// EditText
Function  jEditText_Create             (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jEditText_Free               (env:PJNIEnv;this:jobject; EditText : jObject);
//
Procedure jEditText_setXYWH            (env:PJNIEnv;this:jobject;
                                        EditText : jObject;x,y,w,h : integer);
Procedure jEditText_setParent          (env:PJNIEnv;this:jobject;
                                        EditText : jObject;ViewGroup : jObject);

Function  jEditText_getText            (env:PJNIEnv;this:jobject; EditText : jObject) : String;
Procedure jEditText_setText            (env:PJNIEnv;this:jobject; EditText : jObject; Str : String);
Procedure jEditText_setTextColor       (env:PJNIEnv;this:jobject; EditText : jObject; color : DWord);
Procedure jEditText_setTextSize        (env:PJNIEnv;this:jobject; EditText : jObject; size  : DWord);
Procedure jEditText_setHint            (env:PJNIEnv;this:jobject; EditText : jObject; Str : String);
Procedure jEditText_SetFocus           (env:PJNIEnv;this:jobject; EditText : jObject);
Procedure jEditText_immShow            (env:PJNIEnv;this:jobject; EditText : jObject );
Procedure jEditText_immHide            (env:PJNIEnv;this:jobject; EditText : jObject );
Procedure jEditText_editInputType      (env:PJNIEnv;this:jobject; EditText : jObject; Str : String);

Procedure jEditText_editInputTypeEx   (env:PJNIEnv;this:jobject; EditText : jObject; itType : DWord);

Procedure jEditText_maxLength          (env:PJNIEnv;this:jobject; EditText : jObject; size  : DWord);

//by jmpessoa
Procedure jEditText_setMaxLines        (env:PJNIEnv;this:jobject; EditText : jObject; max  : DWord);
Procedure jEditText_setLParamWidth(env:PJNIEnv;this:jobject; EditText : jObject; w: DWord);
Procedure jEditText_setLParamHeight(env:PJNIEnv;this:jobject; EditText : jObject; h: DWord);
Procedure jEditText_addLParamsParentRule(env:PJNIEnv;this:jobject; EditText : jObject; rule: DWord);
Procedure jEditText_addLParamsAnchorRule(env:PJNIEnv;this:jobject; EditText : jObject; rule: DWord);
Procedure jEditText_setLayoutAll(env:PJNIEnv;this:jobject; EditText : jObject; idAnchor: DWord);
Procedure jEditText_setId(env:PJNIEnv;this:jobject; EditText : jObject; id: DWord);
Procedure jEditText_setMarginLeft(env:PJNIEnv;this:jobject; EditText : jObject; x: DWord);
Procedure jEditText_setMarginTop(env:PJNIEnv;this:jobject; EditText : jObject; y: DWord);
Procedure jEditText_setMarginRight(env:PJNIEnv;this:jobject; EditText : jObject; x: DWord);
Procedure jEditText_setMarginBottom(env:PJNIEnv;this:jobject; EditText : jObject; y: DWord);
Procedure jEditText_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        EditText : jObject; ml,mt,mr,mb,w,h: integer);
//
Procedure jEditText_setSingleLine(env:PJNIEnv;this:jobject; EditText : jObject; isSingle  : boolean);
Procedure jEditText_setHorizontallyScrolling(env:PJNIEnv;this:jobject; EditText : jObject; wrapping: boolean);

Procedure jEditText_setVerticalScrollBarEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);
Procedure jEditText_setHorizontalScrollBarEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);
Procedure jEditText_setScrollbarFadingEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);

Procedure jEditText_setScroller(env:PJNIEnv; this:jobject; context : jObject; EditText : jObject);
Procedure jEditText_setScrollBarStyle(env:PJNIEnv;this:jobject; EditText : jObject; style  : DWord);
Procedure jEditText_setMovementMethod(env:PJNIEnv;this:jobject; EditText : jObject);

Procedure jEditText_GetCursorPos       (env:PJNIEnv;this:jobject; EditText : jObject; Var x,y : Integer);
Procedure jEditText_SetCursorPos       (env:PJNIEnv;this:jobject; EditText : jObject; startPos, endPos : Integer);
Procedure jEditText_setTextAlignment   (env:PJNIEnv;this:jobject; EditText : jObject; align : DWord);
Procedure jEditText_SetEnabled         (env:PJNIEnv;this:jobject; EditText : jObject; enabled : Boolean);
Procedure jEditText_SetEditable        (env:PJNIEnv;this:jobject; EditText : jObject; enabled : Boolean);


// Button
Function  jButton_Create               (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jButton_Free                 (env:PJNIEnv;this:jobject; Button : jObject);
//

Procedure jButton_setXYWH              (env:PJNIEnv;this:jobject;
                                        Button : jObject;x,y,w,h : integer);

Procedure jButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        Button : jObject; ml,mt,mr,mb,w,h: integer);


Procedure jButton_setParent            (env:PJNIEnv;this:jobject;
                                        Button : jObject;ViewGroup : jObject);
Function  jButton_getText              (env:PJNIEnv;this:jobject; Button : jObject) : String;
Procedure jButton_setText              (env:PJNIEnv;this:jobject; Button : jObject; Str : String);
Procedure jButton_setTextColor         (env:PJNIEnv;this:jobject; Button : jObject; color : DWord);
Procedure jButton_setTextSize          (env:PJNIEnv;this:jobject; Button : jObject; size  : DWord);

//by jmpessoa
Procedure jButton_addLParamsParentRule(env:PJNIEnv;this:jobject; Button : jObject; rule: DWord);
Procedure jButton_addLParamsAnchorRule(env:PJNIEnv;this:jobject; Button : jObject; rule: DWord);
Procedure jButton_setLayoutAll(env:PJNIEnv;this:jobject; Button : jObject;  idAnchor: DWord);
Procedure jButton_setLParamWidth(env:PJNIEnv;this:jobject; Button : jObject; w: DWord);
Procedure jButton_setLParamHeight(env:PJNIEnv;this:jobject; Button : jObject; h: DWord);
Procedure jButton_setId(env:PJNIEnv;this:jobject; Button : jObject; id: DWord);
Procedure jButton_setMarginLeft(env:PJNIEnv;this:jobject; Button : jObject; x: DWord);
Procedure jButton_setMarginTop(env:PJNIEnv;this:jobject; Button : jObject; y: DWord);
Procedure jButton_setMarginRight(env:PJNIEnv;this:jobject; Button : jObject; x: DWord);
Procedure jButton_setMarginBottom(env:PJNIEnv;this:jobject; Button : jObject; y: DWord);

Procedure jButton_setFocusable(env:PJNIEnv;this:jobject; Button : jObject; enabled: boolean);

//
Procedure jButton_setOnClick           (env:PJNIEnv;this:jobject; Button : jObject);


// CheckBox
Function  jCheckBox_Create             (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jCheckBox_Free               (env:PJNIEnv;this:jobject; CheckBox : jObject);
//
Procedure jCheckBox_setXYWH            (env:PJNIEnv;this:jobject;
                                        CheckBox : jObject;x,y,w,h : integer);
Procedure jCheckBox_setParent          (env:PJNIEnv;this:jobject;
                                        CheckBox : jObject;ViewGroup : jObject);
Function  jCheckBox_getText            (env:PJNIEnv;this:jobject; CheckBox : jObject) : String;
Procedure jCheckBox_setText            (env:PJNIEnv;this:jobject; CheckBox : jObject; Str : String);
Procedure jCheckBox_setTextColor       (env:PJNIEnv;this:jobject; CheckBox : jObject; color : DWord);
Procedure jCheckBox_setTextSize        (env:PJNIEnv;this:jobject; CheckBox : jObject; size  : DWord);
Function  jCheckBox_isChecked          (env:PJNIEnv;this:jobject; CheckBox : jObject) : Boolean;
Procedure jCheckBox_setChecked         (env:PJNIEnv;this:jobject; CheckBox : jObject; value : Boolean);

//by jmpessoa
Procedure jCheckBox_setId(env:PJNIEnv;this:jobject; CheckBox : jObject; id: DWord);
Procedure jCheckBox_setMarginLeft(env:PJNIEnv;this:jobject; CheckBox : jObject; x: DWord);
Procedure jCheckBox_setMarginTop(env:PJNIEnv;this:jobject; CheckBox : jObject; y: DWord);
Procedure jCheckBox_setMarginRight(env:PJNIEnv;this:jobject; CheckBox : jObject; x: DWord);
Procedure jCheckBox_setMarginBottom(env:PJNIEnv;this:jobject; CheckBox : jObject; y: DWord);
Procedure jCheckBox_setLParamWidth(env:PJNIEnv;this:jobject; CheckBox : jObject; w: DWord);
Procedure jCheckBox_setLParamHeight(env:PJNIEnv;this:jobject; CheckBox : jObject; h: DWord);

Procedure jCheckBox_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        CheckBox : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jCheckBox_addLParamsParentRule(env:PJNIEnv;this:jobject; CheckBox : jObject; rule: DWord);
Procedure jCheckBox_addLParamsAnchorRule(env:PJNIEnv;this:jobject; CheckBox : jObject; rule: DWord);
Procedure jCheckBox_setLayoutAll(env:PJNIEnv;this:jobject; CheckBox : jObject;  idAnchor: DWord);

// RadioButton
Function  jRadioButton_Create          (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jRadioButton_Free            (env:PJNIEnv;this:jobject; RadioButton : jObject);
//
Procedure jRadioButton_setXYWH         (env:PJNIEnv;this:jobject;
                                        RadioButton : jObject;x,y,w,h : integer);
Procedure jRadioButton_setParent       (env:PJNIEnv;this:jobject;
                                        RadioButton : jObject;ViewGroup : jObject);
Function  jRadioButton_getText         (env:PJNIEnv;this:jobject; RadioButton : jObject) : String;
Procedure jRadioButton_setText         (env:PJNIEnv;this:jobject; RadioButton : jObject; Str : String);
Procedure jRadioButton_setTextColor    (env:PJNIEnv;this:jobject; RadioButton : jObject; color : DWord);
Procedure jRadioButton_setTextSize     (env:PJNIEnv;this:jobject; RadioButton : jObject; size  : DWord);
Function  jRadioButton_isChecked       (env:PJNIEnv;this:jobject; RadioButton : jObject) : Boolean;
Procedure jRadioButton_setChecked      (env:PJNIEnv;this:jobject; RadioButton : jObject; value : Boolean);


//====================================

//by jmpessoa
Procedure jRadioButton_setId(env:PJNIEnv;this:jobject; RadioButton : jObject; id: DWord);
Procedure jRadioButton_setMarginLeft(env:PJNIEnv;this:jobject; RadioButton : jObject; x: DWord);
Procedure jRadioButton_setMarginTop(env:PJNIEnv;this:jobject; RadioButton : jObject; y: DWord);
Procedure jRadioButton_setMarginRight(env:PJNIEnv;this:jobject; RadioButton : jObject; x: DWord);
Procedure jRadioButton_setMarginBottom(env:PJNIEnv;this:jobject; RadioButton : jObject; y: DWord);
Procedure jRadioButton_setLParamWidth(env:PJNIEnv;this:jobject; RadioButton : jObject; w: DWord);
Procedure jRadioButton_setLParamHeight(env:PJNIEnv;this:jobject; RadioButton : jObject; h: DWord);

Procedure jRadioButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        RadioButton : jObject; ml,mt,mr,mb,w,h: integer);


Procedure jRadioButton_addLParamsParentRule(env:PJNIEnv;this:jobject; RadioButton : jObject; rule: DWord);
Procedure jRadioButton_addLParamsAnchorRule(env:PJNIEnv;this:jobject; RadioButton : jObject; rule: DWord);
Procedure jRadioButton_setLayoutAll(env:PJNIEnv;this:jobject; RadioButton : jObject;  idAnchor: DWord);


// ProgressBar
Function  jProgressBar_Create          (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject; Style : DWord ) : jObject;
Procedure jProgressBar_Free            (env:PJNIEnv;this:jobject; ProgressBar : jObject);
//
Procedure jProgressBar_setXYWH         (env:PJNIEnv;this:jobject;
                                        ProgressBar : jObject;x,y,w,h : integer);
Procedure jProgressBar_setParent       (env:PJNIEnv;this:jobject;
                                        ProgressBar : jObject;ViewGroup : jObject);
Function  jProgressBar_getProgress     (env:PJNIEnv;this:jobject; ProgressBar : jObject) : Integer;
Procedure jProgressBar_setProgress     (env:PJNIEnv;this:jobject; ProgressBar : jObject; value : integer);

//by jmpessoa
Procedure jProgressBar_setMax          (env:PJNIEnv;this:jobject; ProgressBar : jObject; value : integer);
Function  jProgressBar_getMax          (env:PJNIEnv;this:jobject; ProgressBar : jObject) : Integer;

//by jmpessoa
Procedure jProgressBar_setId(env:PJNIEnv;this:jobject; ProgressBar : jObject; id: DWord);
Procedure jProgressBar_setMarginLeft(env:PJNIEnv;this:jobject; ProgressBar : jObject; x: DWord);
Procedure jProgressBar_setMarginTop(env:PJNIEnv;this:jobject; ProgressBar : jObject; y: DWord);
Procedure jProgressBar_setMarginRight(env:PJNIEnv;this:jobject; ProgressBar : jObject; x: DWord);
Procedure jProgressBar_setMarginBottom(env:PJNIEnv;this:jobject; ProgressBar : jObject; y: DWord);
Procedure jProgressBar_setLParamWidth(env:PJNIEnv;this:jobject; ProgressBar : jObject; w: DWord);
Procedure jProgressBar_setLParamHeight(env:PJNIEnv;this:jobject; ProgressBar : jObject; h: DWord);

Procedure jProgressBar_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ProgressBar : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jProgressBar_addLParamsParentRule(env:PJNIEnv;this:jobject; ProgressBar : jObject; rule: DWord);
Procedure jProgressBar_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ProgressBar : jObject; rule: DWord);
Procedure jProgressBar_setLayoutAll(env:PJNIEnv;this:jobject; ProgressBar : jObject;  idAnchor: DWord);

// ImageView
Function  jImageView_Create            (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jImageView_Free              (env:PJNIEnv;this:jobject; ImageView : jObject);
//
Procedure jImageView_setXYWH           (env:PJNIEnv;this:jobject;
                                        ImageView : jObject;x,y,w,h : integer);
Procedure jImageView_setParent         (env:PJNIEnv;this:jobject;
                                        ImageView : jObject;ViewGroup : jObject);
Procedure jImageView_setImage          (env:PJNIEnv;this:jobject; 
                                        ImageView : jObject; Str : String);

//by jmpessoa
Procedure jImageView_setBitmapImage(env:PJNIEnv;this:jobject;
                                    ImageView : jObject; bitmap : jObject);


//by jmpessoa
Procedure jImageView_setId(env:PJNIEnv;this:jobject; ImageView : jObject; id: DWord);
Procedure jImageView_setMarginLeft(env:PJNIEnv;this:jobject; ImageView : jObject; x: DWord);
Procedure jImageView_setMarginTop(env:PJNIEnv;this:jobject; ImageView : jObject; y: DWord);
Procedure jImageView_setMarginRight(env:PJNIEnv;this:jobject; ImageView : jObject; x: DWord);
Procedure jImageView_setMarginBottom(env:PJNIEnv;this:jobject; ImageView : jObject; y: DWord);
Procedure jImageView_setLParamWidth(env:PJNIEnv;this:jobject; ImageView : jObject; w: DWord);
Procedure jImageView_setLParamHeight(env:PJNIEnv;this:jobject; ImageView : jObject; h: DWord);

Procedure jImageView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ImageView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jImageView_addLParamsParentRule(env:PJNIEnv;this:jobject; ImageView : jObject; rule: DWord);
Procedure jImageView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ImageView : jObject; rule: DWord);
Procedure jImageView_setLayoutAll(env:PJNIEnv;this:jobject; ImageView : jObject;  idAnchor: DWord);

// ListView
Function  jListView_Create             (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jListView_Free               (env:PJNIEnv;this:jobject; ListView : jObject);
//
Procedure jListView_setXYWH            (env:PJNIEnv;this:jobject;
                                        ListView : jObject;x,y,w,h : integer);
Procedure jListView_setParent          (env:PJNIEnv;this:jobject;
                                        ListView : jObject;ViewGroup : jObject);
Procedure jListView_setTextColor       (env:PJNIEnv;this:jobject; ListView : jObject; color : DWord);
Procedure jListView_setTextSize        (env:PJNIEnv;this:jobject; ListView : jObject; size  : DWord);
Procedure jListView_setItemPosition    (env:PJNIEnv;this:jobject;
                                        ListView : jObject; Pos: integer; y:Integer );
//
Procedure jListView_add                (env:PJNIEnv;this:jobject;
                                        ListView : jObject; Str : String);
Procedure jListView_clear              (env:PJNIEnv;this:jobject;
                                        ListView : jObject);
Procedure jListView_delete             (env:PJNIEnv;this:jobject;
                                        ListView : jObject; index : integer);

//by jmpessoa
Procedure jListView_setId(env:PJNIEnv;this:jobject; ListView : jObject; id: DWord);
Procedure jListView_setMarginLeft(env:PJNIEnv;this:jobject; ListView : jObject; x: DWord);
Procedure jListView_setMarginTop(env:PJNIEnv;this:jobject; ListView : jObject; y: DWord);
Procedure jListView_setMarginRight(env:PJNIEnv;this:jobject; ListView : jObject; x: DWord);
Procedure jListView_setMarginBottom(env:PJNIEnv;this:jobject; ListView : jObject; y: DWord);
Procedure jListView_setLParamWidth(env:PJNIEnv;this:jobject; ListView : jObject; w: DWord);
Procedure jListView_setLParamHeight(env:PJNIEnv;this:jobject; ListView : jObject; h: DWord);

Procedure jListView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ListView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jListView_addLParamsParentRule(env:PJNIEnv;this:jobject; ListView : jObject; rule: DWord);
Procedure jListView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ListView : jObject; rule: DWord);
Procedure jListView_setLayoutAll(env:PJNIEnv;this:jobject; ListView : jObject;  idAnchor: DWord);

// ScrollView
Function  jScrollView_Create           (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jScrollView_Free             (env:PJNIEnv;this:jobject; ScrollView : jObject);
//
Procedure jScrollView_setXYWH          (env:PJNIEnv;this:jobject;
                                        ScrollView : jObject;x,y,w,h : integer);
Procedure jScrollView_setParent        (env:PJNIEnv;this:jobject;
                                        ScrollView : jObject;ViewGroup : jObject);
Procedure jScrollView_setScrollSize    (env:PJNIEnv;this:jobject;
                                        ScrollView : jObject; size : integer);
Function  jScrollView_getView          (env:PJNIEnv;this:jobject;
                                        ScrollView : jObject) : jObject;
//by jmpessoa
Procedure jScrollView_setId(env:PJNIEnv;this:jobject; ScrollView : jObject; id: DWord);
Procedure jScrollView_setMarginLeft(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Procedure jScrollView_setMarginTop(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Procedure jScrollView_setMarginRight(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Procedure jScrollView_setMarginBottom(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Procedure jScrollView_setLParamWidth(env:PJNIEnv;this:jobject; ScrollView : jObject; w: DWord);
Procedure jScrollView_setLParamHeight(env:PJNIEnv;this:jobject; ScrollView : jObject; h: DWord);

Procedure jScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jScrollView_addLParamsParentRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Procedure jScrollView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Procedure jScrollView_setLayoutAll(env:PJNIEnv;this:jobject; ScrollView : jObject;  idAnchor: DWord);
//---------------

// jPanel by jmpessoa
Function  jPanel_Create           (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jPanel_Free             (env:PJNIEnv;this:jobject; Panel : jObject);
//
Procedure jPanel_setXYWH          (env:PJNIEnv;this:jobject;
                                        Panel : jObject;x,y,w,h : integer);
Procedure jPanel_setParent        (env:PJNIEnv;this:jobject;
                                        Panel : jObject;ViewGroup : jObject);
Function  jPanel_getView          (env:PJNIEnv; this:jobject;
                                        Panel : jObject) : jObject;

//by jmpessoa
Procedure jPanel_setId(env:PJNIEnv;this:jobject; Panel : jObject; id: DWord);
Procedure jPanel_setMarginLeft(env:PJNIEnv;this:jobject; Panel : jObject; x: DWord);
Procedure jPanel_setMarginTop(env:PJNIEnv;this:jobject; Panel : jObject; y: DWord);
Procedure jPanel_setMarginRight(env:PJNIEnv;this:jobject; Panel : jObject; x: DWord);
Procedure jPanel_setMarginBottom(env:PJNIEnv;this:jobject; Panel : jObject; y: DWord);
Procedure jPanel_setLParamWidth(env:PJNIEnv;this:jobject; Panel : jObject; w: DWord);
Procedure jPanel_setLParamHeight(env:PJNIEnv;this:jobject; Panel : jObject; h: DWord);

Procedure jPanel_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        Panel : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jPanel_resetLParamsRules(env:PJNIEnv;this:jobject; Panel : jObject);

Procedure jPanel_addLParamsParentRule(env:PJNIEnv;this:jobject; Panel : jObject; rule: DWord);
Procedure jPanel_addLParamsAnchorRule(env:PJNIEnv;this:jobject; Panel : jObject; rule: DWord);
Procedure jPanel_setLayoutAll(env:PJNIEnv;this:jobject; Panel : jObject;  idAnchor: DWord);

function jPanel_getLParamHeight(env:PJNIEnv;this:jobject; Panel : jObject ): integer;
function jPanel_getLParamWidth(env:PJNIEnv;this:jobject; Panel : jObject): integer;



//-----------------
// HorizontalScrollView
Function  jHorizontalScrollView_Create        (env:PJNIEnv;this:jobject;
                                               context : jObject; SelfObj : TObject) : jObject;
Procedure jHorizontalScrollView_Free          (env:PJNIEnv;this:jobject; ScrollView : jObject);
Procedure jHorizontalScrollView_setXYWH       (env:PJNIEnv;this:jobject;
                                               ScrollView : jObject;x,y,w,h : integer);
Procedure jHorizontalScrollView_setParent     (env:PJNIEnv;this:jobject;
                                               ScrollView : jObject;ViewGroup : jObject);
Procedure jHorizontalScrollView_setScrollSize (env:PJNIEnv;this:jobject;
                                               ScrollView : jObject; size : integer);
Function  jHorizontalScrollView_getView       (env:PJNIEnv;this:jobject;
                                               ScrollView : jObject) : jObject;

//by jmpessoa
Procedure jHorizontalScrollView_setId(env:PJNIEnv;this:jobject; ScrollView : jObject; id: DWord);
Procedure jHorizontalScrollView_setMarginLeft(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Procedure jHorizontalScrollView_setMarginTop(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Procedure jHorizontalScrollView_setMarginRight(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Procedure jHorizontalScrollView_setMarginBottom(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Procedure jHorizontalScrollView_setLParamWidth(env:PJNIEnv;this:jobject; ScrollView : jObject; w: DWord);
Procedure jHorizontalScrollView_setLParamHeight(env:PJNIEnv;this:jobject; ScrollView : jObject; h: DWord);

Procedure jHorizontalScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jHorizontalScrollView_addLParamsParentRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Procedure jHorizontalScrollView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Procedure jHorizontalScrollView_setLayoutAll(env:PJNIEnv;this:jobject; ScrollView : jObject;  idAnchor: DWord);

// ViewFlipper
Function  jViewFlipper_Create          (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Procedure jViewFlipper_Free            (env:PJNIEnv;this:jobject; ViewFlipper : jObject);
//
Procedure jViewFlipper_setXYWH         (env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject;x,y,w,h : integer);
Procedure jViewFlipper_setParent       (env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject;ViewGroup : jObject);

//by jmpessoa
Procedure jViewFlipper_setId(env:PJNIEnv;this:jobject; ViewFlipper : jObject; id: DWord);
Procedure jViewFlipper_setMarginLeft(env:PJNIEnv;this:jobject; ViewFlipper : jObject; x: DWord);
Procedure jViewFlipper_setMarginTop(env:PJNIEnv;this:jobject; ViewFlipper : jObject; y: DWord);
Procedure jViewFlipper_setMarginRight(env:PJNIEnv;this:jobject; ViewFlipper : jObject; x: DWord);
Procedure jViewFlipper_setMarginBottom(env:PJNIEnv;this:jobject; ViewFlipper : jObject; y: DWord);
Procedure jViewFlipper_setLParamWidth(env:PJNIEnv;this:jobject; ViewFlipper : jObject; w: DWord);
Procedure jViewFlipper_setLParamHeight(env:PJNIEnv;this:jobject; ViewFlipper : jObject; h: DWord);

Procedure jViewFlipper_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jViewFlipper_addLParamsParentRule(env:PJNIEnv;this:jobject; ViewFlipper : jObject; rule: DWord);
Procedure jViewFlipper_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ViewFlipper : jObject; rule: DWord);
Procedure jViewFlipper_setLayoutAll(env:PJNIEnv;this:jobject; ViewFlipper : jObject;  idAnchor: DWord);

// WebView
Function  jWebView_Create              (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jWebView_Free                (env:PJNIEnv;this:jobject; WebView : jObject);
//
Procedure jWebView_setXYWH             (env:PJNIEnv;this:jobject;
                                        WebView : jObject;x,y,w,h : integer);
Procedure jWebView_setParent           (env:PJNIEnv;this:jobject;
                                        WebView : jObject;ViewGroup : jObject);
Procedure jWebView_setJavaScript       (env:PJNIEnv;this:jobject;
                                        WebView : jObject; javascript : boolean);
Procedure jWebView_loadURL             (env:PJNIEnv;this:jobject;
                                        WebView : jObject; Str : String);
//by jmpessoa
Procedure jWebView_setId(env:PJNIEnv;this:jobject; WebView : jObject; id: DWord);
Procedure jWebView_setMarginLeft(env:PJNIEnv;this:jobject; WebView : jObject; x: DWord);
Procedure jWebView_setMarginTop(env:PJNIEnv;this:jobject; WebView : jObject; y: DWord);
Procedure jWebView_setMarginRight(env:PJNIEnv;this:jobject; WebView : jObject; x: DWord);
Procedure jWebView_setMarginBottom(env:PJNIEnv;this:jobject; WebView : jObject; y: DWord);
Procedure jWebView_setLParamWidth(env:PJNIEnv;this:jobject; WebView : jObject; w: DWord);
Procedure jWebView_setLParamHeight(env:PJNIEnv;this:jobject; WebView : jObject; h: DWord);

Procedure jWebView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        WebView: jObject; ml,mt,mr,mb,w,h: integer);

Procedure jWebView_addLParamsParentRule(env:PJNIEnv;this:jobject; WebView : jObject; rule: DWord);
Procedure jWebView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; WebView : jObject; rule: DWord);
Procedure jWebView_setLayoutAll(env:PJNIEnv;this:jobject; WebView : jObject;  idAnchor: DWord);

// Canvas
Function  jCanvas_Create               (env:PJNIEnv;this:jobject;
                                        SelfObj : TObject) : jObject;
Procedure jCanvas_Free                 (env:PJNIEnv;this:jobject; jCanvas : jObject);
//
Procedure jCanvas_setStrokeWidth       (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject;width : single);
Procedure jCanvas_setStyle             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; style : integer);
Procedure jCanvas_setColor             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; color : DWord  );
Procedure jCanvas_setTextSize          (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; textsize : single);
Procedure jCanvas_drawLine             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; x1,y1,x2,y2 : single);
// LORDMAN 2013-08-13
Procedure jCanvas_drawPoint            (env:PJNIEnv;this:jobject; jCanvas:jObject; x1,y1:single);

Procedure jCanvas_drawText             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; const text : string; x,y : single);
Procedure jCanvas_drawBitmap           (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; bmp : jObject; b,l,r,t : integer);
// Bitmap
Function  jBitmap_Create               (env:PJNIEnv;this:jobject;
                                        SelfObj : TObject) : jObject;
Procedure jBitmap_Free                 (env:PJNIEnv;this:jobject; jbitmap : jObject);
Procedure jBitmap_loadFile             (env:PJNIEnv;this:jobject;
                                        jbitmap : jObject; filename : String);
Procedure jBitmap_createBitmap         (env:PJNIEnv;this:jobject;
                                        jbitmap : jObject; w,h : integer);
Procedure jBitmap_getWH                (env:PJNIEnv;this:jobject;
                                        jbitmap : jObject; var w,h : integer);
Function  jBitmap_getJavaBitmap        (env:PJNIEnv;this:jobject;
                                        jbitmap : jObject) : jObject;
// GLSurfaceView
Function  jGLSurfaceView_Create        (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject; version : integer) : jObject;
Procedure jGLSurfaceView_Free          (env:PJNIEnv;this:jobject; GLSurfaceView : jObject);
//
Procedure jGLSurfaceView_setXYWH       (env:PJNIEnv;this:jobject;
                                        GLSurfaceView: jObject;x,y,w,h : integer);
Procedure jGLSurfaceView_setParent     (env:PJNIEnv;this:jobject;
                                        GLSurfaceView: jObject;ViewGroup : jObject);
                                        
Procedure jGLSurfaceView_SetAutoRefresh(env:PJNIEnv;this:jobject; glView : jObject; Active : Boolean);
Procedure jGLSurfaceView_Refresh       (env:PJNIEnv;this:jobject; glView : jObject);
Procedure jGLSurfaceView_deleteTexture (env:PJNIEnv;this:jobject; glView : jObject; id : Integer);
Procedure jGLSurfaceView_getBmpArray   (env:PJNIEnv;this:jobject;filename : String);
Procedure jGLSurfaceView_requestGLThread(env:PJNIEnv;this:jobject; glView : jObject);

//by jmpessoa
Procedure jGLSurfaceView_setId(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; id: DWord);
Procedure jGLSurfaceView_setMarginLeft(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; x: DWord);
Procedure jGLSurfaceView_setMarginTop(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; y: DWord);
Procedure jGLSurfaceView_setMarginRight(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; x: DWord);
Procedure jGLSurfaceView_setMarginBottom(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; y: DWord);
Procedure jGLSurfaceView_setLParamWidth(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; w: DWord);
Procedure jGLSurfaceView_setLParamHeight(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; h: DWord);
function jGLSurfaceView_getLParamHeight(env:PJNIEnv;this:jobject; GLSurfaceView : jObject): integer;
function jGLSurfaceView_getLParamWidth(env:PJNIEnv;this:jobject; GLSurfaceView : jObject): integer;

Procedure jGLSurfaceView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        GLSurfaceView : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jGLSurfaceView_addLParamsParentRule(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; rule: DWord);
Procedure jGLSurfaceView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; rule: DWord);
Procedure jGLSurfaceView_setLayoutAll(env:PJNIEnv;this:jobject; GLSurfaceView : jObject;  idAnchor: DWord);

// Timer
Function  jTimer_Create                (env:PJNIEnv;this:jobject; SelfObj: TObject): jObject;
Procedure jTimer_Free                  (env:PJNIEnv;this:jobject; Timer  : jObject);
Procedure jTimer_SetInterval           (env:PJNIEnv;this:jobject; Timer  : jObject; Interval : Integer);
Procedure jTimer_SetEnabled            (env:PJNIEnv;this:jobject; Timer  : jObject; Active   : Boolean);

// Dialog YN
Function  jDialogYN_Create             (env:PJNIEnv;this:jobject; SelfObj : TObject;
                                        title,msg,y,n : string ): jObject;
Procedure jDialogYN_Free               (env:PJNIEnv;this:jobject; DialogYN: jObject);
//
Procedure jDialogYN_Show               (env:PJNIEnv;this:jobject; DialogYN: jObject);

// Dialog Progress
Function  jDialogProgress_Create       (env:PJNIEnv;this:jobject; SelfObj : TObject;
                                        title,msg : string ): jObject;
Procedure jDialogProgress_Free         (env:PJNIEnv;this:jobject; DialogProgress : jObject);

// Toast
Procedure jToast                       (env:PJNIEnv;this:jobject; Str : String);

// View
Function  jImageBtn_Create             (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject) : jObject;
Procedure jImageBtn_Free               (env:PJNIEnv;this:jobject; ImageBtn : jObject);
Procedure jImageBtn_setXYWH            (env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject;x,y,w,h : integer);
Procedure jImageBtn_setParent          (env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject;ViewGroup : jObject);
Procedure jImageBtn_setButton          (env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject;up,dn : String);
//by jmpessoa
Procedure jImageBtn_setButtonUp        (env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject; up: String);
//by jmpessoa
Procedure jImageBtn_setButtonDown       (env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject; dn: String);

Procedure jImageBtn_SetEnabled         (env:PJNIEnv;this:jobject; 
                                        ImageBtn : jObject; Active : Boolean);
//by jmpessoa
Procedure jImageBtn_setId(env:PJNIEnv;this:jobject; ImageBtn : jObject; id: DWord);
Procedure jImageBtn_setMarginLeft(env:PJNIEnv;this:jobject; ImageBtn : jObject; x: DWord);
Procedure jImageBtn_setMarginTop(env:PJNIEnv;this:jobject; ImageBtn : jObject; y: DWord);
Procedure jImageBtn_setMarginRight(env:PJNIEnv;this:jobject; ImageBtn : jObject; x: DWord);
Procedure jImageBtn_setMarginBottom(env:PJNIEnv;this:jobject; ImageBtn : jObject; y: DWord);
Procedure jImageBtn_setLParamWidth(env:PJNIEnv;this:jobject; ImageBtn : jObject; w: DWord);
Procedure jImageBtn_setLParamHeight(env:PJNIEnv;this:jobject; ImageBtn : jObject; h: DWord);

Procedure jImageBtn_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject; ml,mt,mr,mb,w,h: integer);

Procedure jImageBtn_addLParamsParentRule(env:PJNIEnv;this:jobject; ImageBtn : jObject; rule: DWord);
Procedure jImageBtn_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ImageBtn : jObject; rule: DWord);
Procedure jImageBtn_setLayoutAll(env:PJNIEnv;this:jobject; ImageBtn : jObject;  idAnchor: DWord);

//
Function  jAsyncTask_Create            (env:PJNIEnv;this:jobject;
                                        SelfObj : TObject) : jObject;
Procedure jAsyncTask_Free              (env:PJNIEnv;this:jobject; AsyncTask : jObject);
Procedure jAsyncTask_Execute           (env:PJNIEnv;this:jobject; AsyncTask : jObject);
Procedure jAsyncTask_setProgress       (env:PJNIEnv;this:jobject; AsyncTask : jObject; Progress : Integer);

// Http
Function  jHttp_Get                    (env:PJNIEnv; this:jobject; URL: String) : String;

//by jmpessoa
procedure jSend_Email(env:PJNIEnv; this:jobject; context: jObject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
//by jmpessoa
function jSend_SMS(env:PJNIEnv;this:jobject; context: jObject;
                       toNumber: string;
                       smessage:string): integer;
//by jmpessoa
function jContact_getMobileNumberByDisplayName(env:PJNIEnv;this:jobject; context: jObject;
                                               contactName: string): string;
//by jmpessoa
function jContact_getDisplayNameList(env:PJNIEnv; this:jobject; context: jObject; delimiter: char): string;

// Camera
Procedure jTakePhoto                   (env:PJNIEnv; this:jobject; filename : String);

function jCamera_takePhoto(env:PJNIEnv; this:jobject; context: jObject; path: string;  filename : String): string;

// BenchMark
Procedure jBenchMark1_Java             (env:PJNIEnv;this:jobject;var mSec : Integer;var value : single);
Procedure jBenchMark1_Pascal           (env:PJNIEnv;this:jobject;var mSec : Integer;var value : single);

Var
  gVM         : PJavaVM;
  gjClass     : jClass = nil;
  gDbgMode    : Boolean;
  gjAppName   : PChar; // Ex 'com.kredix';
  gjClassName : PChar; // Ex 'com/kredix/Controls';

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

function JBool ( Bool : Boolean ) : Integer;
 begin
  Case Bool of
   True  : Result := 1;
   False : Result := 0;
  End; 
 end;

//------------------------------------------------------------------------------
// JNI_OnLoad, Unload
//------------------------------------------------------------------------------

//
(*  {commented by jmpessoa}
function JNI_OnLoad(vm:PJavaVM;reserved:pointer):jint; cdecl;
 begin
  dbg('JNI_OnLoad called');
  gVM := vm;
  result:=JNI_VERSION_1_6;
 end;

procedure JNI_OnUnload(vm:PJavaVM;reserved:pointer); cdecl;
 begin
  dbg('JNI_OnUnload called');
 end;

 *)

//------------------------------------------------------------------------------
// Base Conversion
//------------------------------------------------------------------------------

// http://stackoverflow.com/questions/14765776/jni-error-app-bug-accessed-stale-local-reference-0xbc00021-index-8-in-a-tabl
// http://android-developers.blogspot.cz/2011/11/jni-local-reference-changes-in-ics.html
Procedure jClassMethod(FuncName, FuncSig : PChar;
                       env : PJNIEnv; var Class_ : jClass; Var Method_ : jMethodID);
{ var
   tmp: jClass; }
 begin
  if Class_  = nil then
  begin
     Class_   := env^.FindClass(env, gjClassName);  //jmpessoa fix 1:  change Manifest to targetSdkVersion="11"
     //Class_ := jClass (env^.NewGlobalRef(env, tmp)); //jmpessoa try fix 2: why not ?
  end;
  if Method_ = nil then
  begin
      Method_ := env^.GetMethodID( env, Class_, FuncName, FuncSig);
  end;
  //Class_  := env^.FindClass  ( env, gjClassName );
  //Method_ := env^.GetMethodID( env, Class_, FuncName, FuncSig);
 end;

// LORDMAN - 2013-07-28
Function jStr_getLength (env:PJNIEnv;this:jobject; Str : String): Integer;
 Const
  _cFuncName = 'getStrLength';
  _cFuncSig  = '(Ljava/lang/String;)I';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := env^.NewStringUTF(env, pchar(Str) );
  Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
 end;
 
// LORDMAN - 2013-07-30
Function  jStr_GetDateTime (env:PJNIEnv;this:jobject): String;
 Const
  _cFuncName = 'getStrDateTime';
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

//
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
// View
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// System
//------------------------------------------------------------------------------

// Garbage Collection
Procedure jSystem_GC(env:PJNIEnv;this:jobject);
Const
 _cFuncName = 'systemGC';
 _cFuncSig  = '()V';
Var
 _jMethod : jMethodID = nil;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 env^.CallVoidMethod(env,this,_jMethod);
end;

Procedure jSystem_SetOrientation(env:PJNIEnv; this:jobject; orientation : Integer);
Const
 _cFuncName = 'systemSetOrientation';
 _cFuncSig  = '(I)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.i := orientation;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 dbg('loasdf');
end;

//by jmpessoa
function jSystem_GetOrientation (env:PJNIEnv;this:jobject; context: jObject): integer;
 Const
  _cFuncName = 'systemGetOrientation';
  _cFuncSig  = '(Landroid/content/Context;)I';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
  _wh      : Integer;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l     := context;
  Result        := env^.CallIntMethodA(env,this,_jMethod,@_jParam);
 end;


//------------------------------------------------------------------------------
// Class
//------------------------------------------------------------------------------

Procedure jClass_setNull(env:PJNIEnv;this:jobject; ClassObj : jClass);
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

Procedure jClass_chkNull(env:PJNIEnv;this:jobject; ClassObj : jObject);
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
// App
//------------------------------------------------------------------------------

Procedure jApp_Finish (env:PJNIEnv;this:jobject);
Const
 _cFuncName = 'appFinish';
 _cFuncSig  = '()V';
 _jMethod   : jMethodID = nil;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 env^.CallVoidMethod(env,this,_jMethod);
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


Procedure jApp_ScreenStyle    (env:PJNIEnv;this:jobject; screenstyle : integer);
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

//------------------------------------------------------------------------------
// Asset
//------------------------------------------------------------------------------

//  src     'test.txt'
//  outFile '/data/data/com/kredix/files/test.txt'
//            App.Path.Dat+'/image01.png'
Function  jAsset_SaveToFile(env:PJNIEnv; this:jobject; src,dst:String) : Boolean;
 Const
  _cFuncName = 'assetSaveToFile';
  _cFuncSig  = '(Ljava/lang/String;Ljava/lang/String;)Z';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
  _jString : jString;
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
// View
//------------------------------------------------------------------------------

//
Procedure jView_SetVisible (env:PJNIEnv;this:jobject; view : jObject; visible : Boolean);
Const
 _cFuncName = 'view_SetVisible';
 _cFuncSig  = '(Landroid/view/View;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := view;
 Case Visible of
   True  : _jParams[1].i := 0; //
   False : _jParams[1].i := 4; //
 end;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
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

//------------------------------------------------------------------------------
// Form
//------------------------------------------------------------------------------

//
Function  jForm_Create (env:PJNIEnv;this:jobject; SelfObj : TObject) : jObject;
const
 _cFuncName = 'jForm_Create';
 _cFuncSig  = '(I)Ljava/lang/Object;';
var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := SelfObj;
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Result := env^.NewGlobalRef(env,Result);
end;

//
Procedure jForm_Free (env:PJNIEnv;this:jobject; Form    : jObject);
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

//
Procedure jForm_Close (env:PJNIEnv;this:jobject; Form    : jObject; effect : Integer);
Const
 _cFuncName = 'jForm_Close';
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

//
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

//
Procedure jForm_SetVisibility (env:PJNIEnv;this:jobject; Form : jObject; visible : Boolean);
Const
 _cFuncName = 'jForm_SetVisible';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Form;
 _jParams[1].z := Byte(visible);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
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
 _jParams[1].z := Byte(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
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
  dbg('Screen : ' + IntToStr(Result.Width) + 'x' + IntTostr(Result.Height));
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
  dbg('PathApp:'+ Result);
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
  dbg('PathDat:'+ Result);
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
  dbg('PathExt:'+ Result);
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
  dbg('PathDCIM:'+ Result);
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
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
  dbg('PhoneNumber:'+ Result);
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
  dbg('DeviceID:'+ Result);
 end;


//------------------------------------------------------------------------------
// Image Info
//------------------------------------------------------------------------------

Function  jImage_getWH                 (env:PJNIEnv;this:jobject; filename : String ) : TWH;
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
Function  jImage_resample              (env:PJNIEnv;this:jobject; filename : String; size : integer ) : jObject;
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

Procedure jImage_save                  (env:PJNIEnv;this:jobject; Bitmap : jObject; filename : String);
 Const
  _cFuncName = 'Image_save';
  _cFuncSig  = '(Landroid/graphics/Bitmap;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
  _jObject : jObject;
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

//
Function jTextView_Create(env:PJNIEnv;this:jobject;
                          context : jObject; SelfObj : TObject ) : jObject;
 Const
  _cFuncName = 'jTextView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jTextView_Free        (env:PJNIEnv;this:jobject; TextView : jObject);
Const
 _cFuncName = 'jTextView_Free';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := TextView;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteGlobalRef(env,TextView);
end;

//
Procedure jTextView_setEnabled (env:PJNIEnv;this:jobject;
                                TextView : jObject; enabled : Boolean);
Const
 _cFuncName = 'jTextView_setEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].z := Byte(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// 
Procedure jTextView_setXYWH(env:PJNIEnv;this:jobject;
                            TextView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jTextView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jTextView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        TextView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jTextView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// 
Procedure jTextView_setParent(env:PJNIEnv;this:jobject;
                              TextView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jTextView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jTextView_setParent2(env:PJNIEnv;this:jobject;
                               TextView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jTextView_setParent2';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  dbg('jTextView_setParent2');
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

// Java Function
Function jTextView_getText(env:PJNIEnv;this:jobject; TextView : jObject) : String;
 Const
  _cFuncName = 'jTextView_getText';
  _cFuncSig  = '(Ljava/lang/Object;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := TextView;
  _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

// Java Function
Procedure jTextView_setText(env:PJNIEnv;this:jobject;
                            TextView : jObject; Str : String);
 Const
  _cFuncName = 'jTextView_setText';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Procedure jTextView_setTextColor (env:PJNIEnv;this:jobject;
                                  TextView : jObject; color : DWord);
Const
  _cFuncName = 'jTextView_setTextColor';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].i := color;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

// Font Height ( Pixel )
Procedure jTextView_setTextSize (env:PJNIEnv;this:jobject;
                                  TextView : jObject; size : DWord);
 Const
  _cFuncName = 'jTextView_setTextSize';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := TextView;
  _jParams[1].i := size;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

// LORDMAN - 2013-08-12
Procedure jTextView_setTextAlignment (env:PJNIEnv;this:jobject; TextView : jObject; align : DWord);
Const
 _cFuncName = 'jTextView_setTextAlignment';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := align;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_addLParamsParentRule(env:PJNIEnv;this:jobject; TextView : jObject; rule: DWord);
Const
 _cFuncName = 'jTextView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; TextView : jObject; rule: DWord);
Const
 _cFuncName = 'jTextView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setLayoutAll(env:PJNIEnv;this:jobject; TextView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jTextView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setLParamWidth(env:PJNIEnv;this:jobject; TextView : jObject; w: DWord);
Const
 _cFuncName = 'jTextView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setLParamHeight(env:PJNIEnv;this:jobject; TextView : jObject; h: DWord);
Const
 _cFuncName = 'jTextView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setId(env:PJNIEnv;this:jobject; TextView : jObject; id: DWord);
Const
 _cFuncName = 'jTextView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jTextView_setMarginLeft(env:PJNIEnv;this:jobject; TextView : jObject; x: DWord);
Const
 _cFuncName = 'jTextView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setMarginTop(env:PJNIEnv;this:jobject; TextView : jObject; y: DWord);
Const
 _cFuncName = 'jTextView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jTextView_setMarginRight(env:PJNIEnv;this:jobject; TextView : jObject; x: DWord);
Const
 _cFuncName = 'jTextView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jTextView_setMarginBottom(env:PJNIEnv;this:jobject; TextView : jObject; y: DWord);
Const
 _cFuncName = 'jTextView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := TextView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// EditText
//------------------------------------------------------------------------------

//
Function jEditText_Create(env:PJNIEnv;this:jobject;
                          context : jObject; SelfObj : TObject ) : jObject;
 Const
  _cFuncName = 'jEditText_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jEditText_Free (env:PJNIEnv;this:jobject; EditText : jObject);
  Const
   _cFuncName = 'jEditText_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := EditText;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,EditText);
  end;

//
Procedure jEditText_setXYWH(env:PJNIEnv;this:jobject;
                            EditText : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jEditText_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := EditText;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jEditText_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        EditText : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jEditText_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jEditText_setParent(env:PJNIEnv;this:jobject;
                              EditText : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jEditText_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := EditText;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;


// Java Function
Function jEditText_getText(env:PJNIEnv;this:jobject; EditText : jObject) : String;
 Const
  _cFuncName = 'jEditText_getText';
  _cFuncSig  = '(Ljava/lang/Object;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := EditText;
  _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

// Java Function
Procedure jEditText_setText(env:PJNIEnv;this:jobject;
                            EditText : jObject; Str : String);
 Const
  _cFuncName = 'jEditText_setText';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := EditText;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Procedure jEditText_setTextColor (env:PJNIEnv;this:jobject;
                                  EditText : jObject; color : DWord);
Const
 _cFuncName = 'jEditText_setTextColor';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jEditText_setTextSize (env:PJNIEnv;this:jobject;
                                 EditText : jObject; size : DWord);
Const
 _cFuncName = 'jEditText_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Hint, PlaceHolder
Procedure jEditText_setHint     (env:PJNIEnv;this:jobject; EditText : jObject;
                                 Str : String);
Const
 _cFuncName = 'jEditText_setHint';
 _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_SetFocus (env:PJNIEnv;this:jobject; EditText : jObject );
Const
 _cFuncName = 'jEditText_SetFocus';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_immShow (env:PJNIEnv;this:jobject; EditText : jObject );
Const
 _cFuncName = 'jEditText_immShow';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_immHide (env:PJNIEnv;this:jobject; EditText : jObject );
Const
 _cFuncName = 'jEditText_immHide';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_editInputType(env:PJNIEnv;this:jobject; EditText : jObject; Str : String);
Const
 _cFuncName = 'jEditText_InputType';
 _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

//by jmpessoa
Procedure jEditText_editInputTypeEx(env:PJNIEnv;this:jobject; EditText : jObject; itType : DWord);
Const
 _cFuncName = 'jEditText_InputTypeEx';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := itType;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_maxLength(env:PJNIEnv;this:jobject; EditText : jObject; size  : DWord);
Const
 _cFuncName = 'jEditText_maxLength';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setMaxLines(env:PJNIEnv;this:jobject; EditText : jObject; max  : DWord);
Const
 _cFuncName = 'jEditText_setMaxLines';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := max;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setSingleLine(env:PJNIEnv;this:jobject; EditText : jObject; isSingle: boolean);
Const
 _cFuncName = 'jEditText_setSingleLine';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := Byte(isSingle);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;
//by jmpessoa
Procedure jEditText_setHorizontallyScrolling(env:PJNIEnv;this:jobject; EditText : jObject; wrapping: boolean);
Const
 _cFuncName = 'jEditText_setHorizontallyScrolling';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := Byte(wrapping);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_addLParamsParentRule(env:PJNIEnv;this:jobject; EditText : jObject; rule: DWord);
Const
 _cFuncName = 'jEditText_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_addLParamsAnchorRule(env:PJNIEnv;this:jobject; EditText : jObject; rule: DWord);
Const
 _cFuncName = 'jEditText_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLayoutAll(env:PJNIEnv;this:jobject; EditText : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jEditText_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLParamWidth(env:PJNIEnv;this:jobject; EditText : jObject; w: DWord);
Const
 _cFuncName = 'jEditText_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setLParamHeight(env:PJNIEnv;this:jobject; EditText : jObject; h: DWord);
Const
 _cFuncName = 'jEditText_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setId(env:PJNIEnv;this:jobject; EditText : jObject; id: DWord);
Const
 _cFuncName = 'jEditText_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setMarginLeft(env:PJNIEnv;this:jobject; EditText : jObject; x: DWord);
Const
 _cFuncName = 'jEditText_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setMarginTop(env:PJNIEnv;this:jobject; EditText : jObject; y: DWord);
Const
 _cFuncName = 'jEditText_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setMarginRight(env:PJNIEnv;this:jobject; EditText : jObject; x: DWord);
Const
 _cFuncName = 'jEditText_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jEditText_setMarginBottom(env:PJNIEnv;this:jobject; EditText : jObject; y: DWord);
Const
 _cFuncName = 'jEditText_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setVerticalScrollBarEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);
Const
 _cFuncName = 'jEditText_setVerticalScrollBarEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := Byte(value);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setHorizontalScrollBarEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);
Const
 _cFuncName = 'jEditText_setHorizontalScrollBarEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := Byte(value);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


Procedure jEditText_setScrollbarFadingEnabled(env:PJNIEnv;this:jobject; EditText : jObject; value  : boolean);
Const
 _cFuncName = 'jEditText_setHorizontalScrollBarEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := Byte(value);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setScrollBarStyle(env:PJNIEnv;this:jobject; EditText : jObject; style  : DWord);
Const
 _cFuncName = 'jEditText_setScrollBarStyle';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := style;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


Procedure jEditText_setMovementMethod(env:PJNIEnv;this:jobject; EditText : jObject);
Const
 _cFuncName = 'jEditText_setMovementMethod';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jEditText_setScroller(env:PJNIEnv; this:jobject; context : jObject; EditText : jObject);
Const
 _cFuncName = 'jEditText_setScroller';
 _cFuncSig  = '(Landroid/content/Context;Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := EditText;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


// LORDMAN - 2013-07-26
Procedure jEditText_GetCursorPos       (env:PJNIEnv;this:jobject; EditText : jObject; Var x,y : Integer);
Const
 _cFuncName = 'jEditText_GetCursorPos';
 _cFuncSig  = '(Ljava/lang/Object;)[I';
Var
 _jMethod   : jMethodID = nil;
 _jParam    : jValue;
 _jIntArray : jintArray;
 _jBoolean  : jBoolean;
 //
 PInt    : PInteger;
 PIntSav : PInteger;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l  := EditText;
 _jIntArray := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 //
 _jBoolean  := JNI_False;
 PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
 PIntSav    := PInt;
 x := PInt^; Inc(PInt);
 y := PInt^; Inc(PInt);
 env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
end;

// LORDMAN - 2013-07-26
Procedure jEditText_SetCursorPos(env:PJNIEnv;this:jobject; EditText : jObject; startPos,endPos : Integer);
Const
 _cFuncName = 'jEditText_SetCursorPos';
 _cFuncSig  = '(Ljava/lang/Object;II)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := startPos;
 _jParams[2].i := endPos;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN - 2013-08-12
Procedure jEditText_setTextAlignment (env:PJNIEnv;this:jobject; EditText : jObject; align : DWord);
Const
 _cFuncName = 'jEditText_setTextAlignment';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].i := align;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-27
Procedure jEditText_SetEnabled (env:PJNIEnv;this:jobject;
                                EditText : jObject; enabled : Boolean);
Const
 _cFuncName = 'jEditText_setEnabled';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := jBool(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-27
Procedure jEditText_SetEditable (env:PJNIEnv;this:jobject;
                                 EditText : jObject; enabled : Boolean);
Const
 _cFuncName = 'jEditText_setEditable';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := EditText;
 _jParams[1].z := jBool(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// Button
//------------------------------------------------------------------------------

//
Function jButton_Create(env:PJNIEnv;this:jobject;
                        context : jObject; SelfObj: TObject) : jObject;
 Const
  _cFuncName = 'jButton_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jButton_Free (env:PJNIEnv;this:jobject; Button : jObject);
  Const
   _cFuncName = 'jButton_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   Dbg('jButton_Free #1');
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := Button;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,Button);
  end;

//
Procedure jButton_setXYWH(env:PJNIEnv;this:jobject;
                          Button : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jButton_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Button;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        Button : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jButton_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jButton_setParent(env:PJNIEnv;this:jobject;
                            Button : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jButton_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Button;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jButton_setText(env:PJNIEnv;this:jobject;
                          Button : jObject; Str : String);
 Const
  _cFuncName = 'jButton_setText';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Button;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );

  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Function jButton_getText(env:PJNIEnv;this:jobject;
                         Button : jObject) : String;
 Const
  _cFuncName = 'jButton_getText';
  _cFuncSig  = '(Ljava/lang/Object;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := Button;
  _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

//
Procedure jButton_setTextColor (env:PJNIEnv;this:jobject;
                                Button : jObject; color : DWord);
Const
 _cFuncName = 'jButton_setTextColor';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jButton_setTextSize (env:PJNIEnv;this:jobject;
                               Button : jObject; size : DWord);
Const
 _cFuncName = 'jButton_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_addLParamsParentRule(env:PJNIEnv;this:jobject; Button : jObject; rule: DWord);
Const
 _cFuncName = 'jButton_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_addLParamsAnchorRule(env:PJNIEnv;this:jobject; Button : jObject; rule: DWord);
Const
 _cFuncName = 'jButton_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setLayoutAll(env:PJNIEnv;this:jobject; Button : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jButton_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setLParamWidth(env:PJNIEnv;this:jobject; Button : jObject; w: DWord);
Const
 _cFuncName = 'jButton_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setLParamHeight(env:PJNIEnv;this:jobject; Button : jObject; h: DWord);
Const
 _cFuncName = 'jButton_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jButton_setId(env:PJNIEnv;this:jobject; Button : jObject; id: DWord);
Const
 _cFuncName = 'jButton_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jButton_setMarginLeft(env:PJNIEnv;this:jobject; Button : jObject; x: DWord);
Const
 _cFuncName = 'jButton_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setMarginTop(env:PJNIEnv;this:jobject; Button : jObject; y: DWord);
Const
 _cFuncName = 'jButton_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jButton_setMarginRight(env:PJNIEnv;this:jobject; Button : jObject; x: DWord);
Const
 _cFuncName = 'jButton_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jButton_setMarginBottom(env:PJNIEnv;this:jobject; Button : jObject; y: DWord);
Const
 _cFuncName = 'jButton_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jButton_setOnClick(env:PJNIEnv;this:jobject;
                             Button : jObject);
 Const
  _cFuncName = 'Button_setOnClick';
  _cFuncSig  = '(Landroid/widget/Button;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := Button;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jButton_setFocusable(env:PJNIEnv;this:jobject; Button : jObject; enabled: boolean);
Const
 _cFuncName = 'jButton_setFocusable';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Button;
 _jParams[1].z := Byte(enabled);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// CheckBox
//------------------------------------------------------------------------------

//
Function jCheckBox_Create(env:PJNIEnv;this:jobject;
                          context : jObject; SelfObj : TObject ) : jObject;
 Const
  _cFuncName = 'jCheckBox_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jCheckBox_Free (env:PJNIEnv;this:jobject; CheckBox : jObject);
  Const
   _cFuncName = 'jCheckBox_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := CheckBox;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,CheckBox);
  end;

//
Procedure jCheckBox_setXYWH(env:PJNIEnv;this:jobject;
                            CheckBox : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jCheckBox_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := CheckBox;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jCheckBox_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        CheckBox : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jCheckBox_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jCheckBox_setParent(env:PJNIEnv;this:jobject;
                              CheckBox : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jCheckBox_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := CheckBox;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;


// Java Function
Function jCheckBox_getText(env:PJNIEnv;this:jobject; CheckBox : jObject) : String;
 Const
  _cFuncName = 'jCheckBox_getText';
  _cFuncSig  = '(Ljava/lang/Object;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := CheckBox;
  _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

// Java Function
Procedure jCheckBox_setText(env:PJNIEnv;this:jobject;
                            CheckBox : jObject; Str : String);
 Const
  _cFuncName = 'jCheckBox_setText';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := CheckBox;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Procedure jCheckBox_setTextColor (env:PJNIEnv;this:jobject;
                                  CheckBox : jObject; color : DWord);
Const
 _cFuncName = 'jCheckBox_setTextColor';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Function  jCheckBox_isChecked          (env:PJNIEnv;this:jobject; CheckBox : jObject) : Boolean;
Const
 _cFuncName = 'jCheckBox_isChecked';
 _cFuncSig  = '(Ljava/lang/Object;)Z';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
 _jBool   : jBoolean;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := CheckBox;
 _jBool     := env^.CallBooleanMethodA(env,this,_jMethod,@_jParams);
 Result     := Boolean(_jBool);
end;

//
Procedure jCheckBox_setChecked         (env:PJNIEnv;this:jobject;
                                        CheckBox : jObject; value : Boolean);
Const
 _cFuncName = 'jCheckBox_setChecked';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].z := Byte(value);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jCheckBox_setTextSize (env:PJNIEnv;this:jobject;
                                  CheckBox : jObject; size : DWord);
Const
 _cFuncName = 'jCheckBox_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setId(env:PJNIEnv;this:jobject; CheckBox : jObject; id: DWord);
Const
 _cFuncName = 'jCheckBox_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCheckBox_setMarginLeft(env:PJNIEnv;this:jobject; CheckBox : jObject; x: DWord);
Const
 _cFuncName = 'jCheckBox_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setMarginTop(env:PJNIEnv;this:jobject; CheckBox : jObject; y: DWord);
Const
 _cFuncName = 'jCheckBox_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCheckBox_setMarginRight(env:PJNIEnv;this:jobject; CheckBox : jObject; x: DWord);
Const
 _cFuncName = 'jCheckBox_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setMarginBottom(env:PJNIEnv;this:jobject; CheckBox : jObject; y: DWord);
Const
 _cFuncName = 'jCheckBox_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setLParamWidth(env:PJNIEnv;this:jobject; CheckBox : jObject; w: DWord);
Const
 _cFuncName = 'jCheckBox_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setLParamHeight(env:PJNIEnv;this:jobject; CheckBox : jObject; h: DWord);
Const
 _cFuncName = 'jCheckBox_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jCheckBox_addLParamsParentRule(env:PJNIEnv;this:jobject; CheckBox : jObject; rule: DWord);
Const
 _cFuncName = 'jCheckBox_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_addLParamsAnchorRule(env:PJNIEnv;this:jobject; CheckBox : jObject; rule: DWord);
Const
 _cFuncName = 'jCheckBox_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jCheckBox_setLayoutAll(env:PJNIEnv;this:jobject; CheckBox : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jCheckBox_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := CheckBox;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// RadioButton
//------------------------------------------------------------------------------

//
Function jRadioButton_Create(env:PJNIEnv;this:jobject;
                          context : jObject; SelfObj : TObject ) : jObject;
 Const
  _cFuncName = 'jRadioButton_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jRadioButton_Free (env:PJNIEnv;this:jobject; RadioButton : jObject);
  Const
   _cFuncName = 'jRadioButton_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := RadioButton;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,RadioButton);
  end;

//
Procedure jRadioButton_setXYWH(env:PJNIEnv;this:jobject;
                            RadioButton : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jRadioButton_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := RadioButton;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jRadioButton_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        RadioButton : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jRadioButton_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jRadioButton_setParent(env:PJNIEnv;this:jobject;
                              RadioButton : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jRadioButton_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := RadioButton;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;


// Java Function
Function jRadioButton_getText(env:PJNIEnv;this:jobject; RadioButton : jObject) : String;
 Const
  _cFuncName = 'jRadioButton_getText';
  _cFuncSig  = '(Ljava/lang/Object;)Ljava/lang/String;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : jValue;
  _jString : jString;
  _jBoolean: jBoolean;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams.l := RadioButton;
  _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Case _jString = nil of
   True : Result    := '';
   False: begin
           _jBoolean := JNI_False;
           Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
          end;
  end;
 end;

// Java Function
Procedure jRadioButton_setText(env:PJNIEnv;this:jobject;
                            RadioButton : jObject; Str : String);
 Const
  _cFuncName = 'jRadioButton_setText';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := RadioButton;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Procedure jRadioButton_setTextColor (env:PJNIEnv;this:jobject;
                                  RadioButton : jObject; color : DWord);
Const
 _cFuncName = 'jRadioButton_setTextColor';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Function  jRadioButton_isChecked          (env:PJNIEnv;this:jobject; RadioButton : jObject) : Boolean;
Const
 _cFuncName = 'jRadioButton_isChecked';
 _cFuncSig  = '(Ljava/lang/Object;)Z';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
 _jBool   : jBoolean;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := RadioButton;
 _jBool     := env^.CallBooleanMethodA(env,this,_jMethod,@_jParams);
 Result     := Boolean(_jBool);
end;

//
Procedure jRadioButton_setChecked         (env:PJNIEnv;this:jobject;
                                        RadioButton : jObject; value : Boolean);
Const
 _cFuncName = 'jRadioButton_setChecked';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].z := Byte(value);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Font Height ( Pixel )
Procedure jRadioButton_setTextSize (env:PJNIEnv;this:jobject;
                                  RadioButton : jObject; size : DWord);
Const
 _cFuncName = 'jRadioButton_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setId(env:PJNIEnv;this:jobject; RadioButton : jObject; id: DWord);
Const
 _cFuncName = 'jRadioButton_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jRadioButton_setMarginLeft(env:PJNIEnv;this:jobject; RadioButton : jObject; x: DWord);
Const
 _cFuncName = 'jRadioButton_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setMarginTop(env:PJNIEnv;this:jobject; RadioButton : jObject; y: DWord);
Const
 _cFuncName = 'jRadioButton_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jRadioButton_setMarginRight(env:PJNIEnv;this:jobject; RadioButton : jObject; x: DWord);
Const
 _cFuncName = 'jRadioButton_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setMarginBottom(env:PJNIEnv;this:jobject; RadioButton : jObject; y: DWord);
Const
 _cFuncName = 'jRadioButton_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setLParamWidth(env:PJNIEnv;this:jobject; RadioButton : jObject; w: DWord);
Const
 _cFuncName = 'jRadioButton_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setLParamHeight(env:PJNIEnv;this:jobject; RadioButton : jObject; h: DWord);
Const
 _cFuncName = 'jRadioButton_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jRadioButton_addLParamsParentRule(env:PJNIEnv;this:jobject; RadioButton : jObject; rule: DWord);
Const
 _cFuncName = 'jRadioButton_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_addLParamsAnchorRule(env:PJNIEnv;this:jobject; RadioButton : jObject; rule: DWord);
Const
 _cFuncName = 'jRadioButton_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jRadioButton_setLayoutAll(env:PJNIEnv;this:jobject; RadioButton : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jRadioButton_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := RadioButton;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// ProgressBar
//------------------------------------------------------------------------------

// Java Function
Function jProgressBar_Create(env:PJNIEnv;this:jobject;
                             context : jObject; SelfObj : TObject; Style : DWord ) : jObject;
 Const
  _cFuncName = 'jProgressBar_Create';
  _cFuncSig  = '(Landroid/content/Context;II)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..2] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  _jParams[2].i := Style;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jProgressBar_Free (env:PJNIEnv;this:jobject; ProgressBar : jObject);
  Const
   _cFuncName = 'jProgressBar_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ProgressBar;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ProgressBar);
  end;

//
Procedure jProgressBar_setXYWH(env:PJNIEnv;this:jobject;
                               ProgressBar : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jProgressBar_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ProgressBar;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jProgressBar_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ProgressBar : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jProgressBar_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jProgressBar_setParent(env:PJNIEnv;this:jobject;
                                 ProgressBar : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jProgressBar_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ProgressBar;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Function  jProgressBar_getProgress (env:PJNIEnv;this:jobject; ProgressBar : jObject) : Integer;
Const
 _cFuncName = 'jProgressBar_getProgress';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := ProgressBar;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jProgressBar_setProgress (env:PJNIEnv;this:jobject;
                                    ProgressBar : jObject; value : Integer);
Const
 _cFuncName = 'jProgressBar_setProgress';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := value;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setMax (env:PJNIEnv;this:jobject;
                                    ProgressBar : jObject; value : Integer);
Const
 _cFuncName = 'jProgressBar_setMax';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := value;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Function  jProgressBar_getMax (env:PJNIEnv;this:jobject; ProgressBar : jObject) : Integer;
Const
 _cFuncName = 'jProgressBar_getMax';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := ProgressBar;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setId(env:PJNIEnv;this:jobject; ProgressBar : jObject; id: DWord);
Const
 _cFuncName = 'jProgressBar_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jProgressBar_setMarginLeft(env:PJNIEnv;this:jobject; ProgressBar : jObject; x: DWord);
Const
 _cFuncName = 'jProgressBar_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setMarginTop(env:PJNIEnv;this:jobject; ProgressBar : jObject; y: DWord);
Const
 _cFuncName = 'jProgressBar_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jProgressBar_setMarginRight(env:PJNIEnv;this:jobject; ProgressBar : jObject; x: DWord);
Const
 _cFuncName = 'jProgressBar_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setMarginBottom(env:PJNIEnv;this:jobject; ProgressBar : jObject; y: DWord);
Const
 _cFuncName = 'jProgressBar_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setLParamWidth(env:PJNIEnv;this:jobject; ProgressBar : jObject; w: DWord);
Const
 _cFuncName = 'jProgressBar_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setLParamHeight(env:PJNIEnv;this:jobject; ProgressBar : jObject; h: DWord);
Const
 _cFuncName = 'jProgressBar_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jProgressBar_addLParamsParentRule(env:PJNIEnv;this:jobject; ProgressBar : jObject; rule: DWord);
Const
 _cFuncName = 'jProgressBar_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ProgressBar : jObject; rule: DWord);
Const
 _cFuncName = 'jProgressBar_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jProgressBar_setLayoutAll(env:PJNIEnv;this:jobject; ProgressBar : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jProgressBar_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ProgressBar;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// ImageView
//------------------------------------------------------------------------------

//
Function  jImageView_Create  (env:PJNIEnv;this:jobject;
                              context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jImageView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jImageView_Free   (env:PJNIEnv;this:jobject; ImageView : jObject);
  Const
   _cFuncName = 'jImageView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ImageView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ImageView);
  end;

// 
Procedure jImageView_setXYWH(env:PJNIEnv;this:jobject;
                             ImageView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jImageView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jImageView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ImageView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jImageView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


// 
Procedure jImageView_setParent(env:PJNIEnv;this:jobject;
                               ImageView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jImageView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;
 
//
Procedure jImageView_setImage(env:PJNIEnv;this:jobject;
                              ImageView : jObject; Str : String);
 Const
  _cFuncName = 'jImageView_setImage';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//by jmpessoa
Procedure jImageView_setBitmapImage(env:PJNIEnv;this:jobject;
                                    ImageView : jObject; bitmap : jObject);
 Const
  _cFuncName = 'jImageView_setBitmapImage';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/graphics/Bitmap;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageView;
  _jParams[1].l := bitmap;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jImageView_setId(env:PJNIEnv;this:jobject; ImageView : jObject; id: DWord);
Const
 _cFuncName = 'jImageView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setMarginLeft(env:PJNIEnv;this:jobject; ImageView : jObject; x: DWord);
Const
 _cFuncName = 'jImageView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setMarginTop(env:PJNIEnv;this:jobject; ImageView : jObject; y: DWord);
Const
 _cFuncName = 'jImageView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setMarginRight(env:PJNIEnv;this:jobject; ImageView : jObject; x: DWord);
Const
 _cFuncName = 'jImageView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setMarginBottom(env:PJNIEnv;this:jobject; ImageView : jObject; y: DWord);
Const
 _cFuncName = 'jImageView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setLParamWidth(env:PJNIEnv;this:jobject; ImageView : jObject; w: DWord);
Const
 _cFuncName = 'jImageView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setLParamHeight(env:PJNIEnv;this:jobject; ImageView : jObject; h: DWord);
Const
 _cFuncName = 'jImageView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jImageView_addLParamsParentRule(env:PJNIEnv;this:jobject; ImageView : jObject; rule: DWord);
Const
 _cFuncName = 'jImageView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ImageView : jObject; rule: DWord);
Const
 _cFuncName = 'jImageView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageView_setLayoutAll(env:PJNIEnv;this:jobject; ImageView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jImageView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// ListView
//------------------------------------------------------------------------------

//
Function  jListView_Create  (env:PJNIEnv;this:jobject;
                             context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jListView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jListView_Free   (env:PJNIEnv;this:jobject; ListView : jObject);
  Const
   _cFuncName = 'jListView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ListView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ListView);
  end;

//
Procedure jListView_setXYWH(env:PJNIEnv;this:jobject;
                            ListView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jListView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ListView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jListView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ListView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jListView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jListView_setParent(env:PJNIEnv;this:jobject;
                              ListView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jListView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ListView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jListView_setTextColor (env:PJNIEnv;this:jobject;
                                  ListView : jObject; color : DWord);
Const
  _cFuncName = 'jListView_setTextColor';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ListView;
  _jParams[1].i := color;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jListView_setTextSize  (env:PJNIEnv;this:jobject;
                                  ListView : jObject; size  : DWord);
Const
 _cFuncName = 'jListView_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := size;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jListView_setItemPosition    (env:PJNIEnv;this:jobject;
                                        ListView : jObject; Pos: integer; y:Integer );

Const
 _cFuncName = 'jListView_setItemPosition';
 _cFuncSig  = '(Ljava/lang/Object;II)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := Pos;
 _jParams[2].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// Java Function
Procedure jListView_add(env:PJNIEnv;this:jobject; ListView : jObject; Str : String);
 Const
  _cFuncName = 'jListView_add';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod: jMethodID = nil;
  _jParams: array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ListView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

Procedure jListView_clear              (env:PJNIEnv;this:jobject;
                                        ListView : jObject);
Const
 _cFuncName = 'jListView_clear';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l:= ListView;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

Procedure jListView_delete             (env:PJNIEnv;this:jobject;
                                        ListView : jObject; index : integer);
Const
 _cFuncName = 'jListView_delete';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := index;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setId(env:PJNIEnv;this:jobject; ListView : jObject; id: DWord);
Const
 _cFuncName = 'jListView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jListView_setMarginLeft(env:PJNIEnv;this:jobject; ListView : jObject; x: DWord);
Const
 _cFuncName = 'jListView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setMarginTop(env:PJNIEnv;this:jobject; ListView : jObject; y: DWord);
Const
 _cFuncName = 'jListView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


Procedure jListView_setMarginRight(env:PJNIEnv;this:jobject; ListView : jObject; x: DWord);
Const
 _cFuncName = 'jListView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setMarginBottom(env:PJNIEnv;this:jobject; ListView : jObject; y: DWord);
Const
 _cFuncName = 'jListView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setLParamWidth(env:PJNIEnv;this:jobject; ListView : jObject; w: DWord);
Const
 _cFuncName = 'jListView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setLParamHeight(env:PJNIEnv;this:jobject; ListView : jObject; h: DWord);
Const
 _cFuncName = 'jListView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jListView_addLParamsParentRule(env:PJNIEnv;this:jobject; ListView : jObject; rule: DWord);
Const
 _cFuncName = 'jListView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ListView : jObject; rule: DWord);
Const
 _cFuncName = 'jListView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jListView_setLayoutAll(env:PJNIEnv;this:jobject; ListView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jListView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ListView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// ScrollView
//------------------------------------------------------------------------------

//
Function  jScrollView_Create  (env:PJNIEnv;this:jobject;
                               context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jScrollView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jScrollView_Free   (env:PJNIEnv;this:jobject; ScrollView : jObject);
  Const
   _cFuncName = 'jScrollView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ScrollView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ScrollView);
  end;

// 
Procedure jScrollView_setXYWH(env:PJNIEnv;this:jobject;
                              ScrollView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jScrollView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jScrollView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


// 
Procedure jScrollView_setParent(env:PJNIEnv;this:jobject;
                                ScrollView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jScrollView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;
  
//
Procedure jScrollView_setScrollSize(env:PJNIEnv;this:jobject;
                                    ScrollView : jObject; size : integer);
 Const
  _cFuncName = 'jScrollView_setScrollSize';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].i := size;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Function jScrollView_getView(env:PJNIEnv;this:jobject;
                             ScrollView : jObject) : jObject;
 Const 
  _cFuncName = 'jScrollView_getView';
  _cFuncSig  = '(Ljava/lang/Object;)Landroid/view/ViewGroup;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := ScrollView;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 end;

//by jmpessoa
Procedure jScrollView_setId(env:PJNIEnv;this:jobject; ScrollView : jObject; id: DWord);
Const
 _cFuncName = 'jScrollView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jScrollView_setMarginLeft(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Const
 _cFuncName = 'jScrollView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_setMarginTop(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Const
 _cFuncName = 'jScrollView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


Procedure jScrollView_setMarginRight(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Const
 _cFuncName = 'jScrollView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_setMarginBottom(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Const
 _cFuncName = 'jScrollView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_setLParamWidth(env:PJNIEnv;this:jobject; ScrollView : jObject; w: DWord);
Const
 _cFuncName = 'jScrollView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_setLParamHeight(env:PJNIEnv;this:jobject; ScrollView : jObject; h: DWord);
Const
 _cFuncName = 'jScrollView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jScrollView_addLParamsParentRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Const
 _cFuncName = 'jScrollView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Const
 _cFuncName = 'jScrollView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jScrollView_setLayoutAll(env:PJNIEnv;this:jobject; ScrollView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jScrollView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//----------------------------------------
//jPanel by jmpessoa
//----------------------------------------
Function  jPanel_Create  (env:PJNIEnv;this:jobject;
                               context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jPanel_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

////by jmpessoa
Procedure jPanel_Free   (env:PJNIEnv;this:jobject; Panel : jObject);
  Const
   _cFuncName = 'jPanel_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := Panel;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,Panel);
  end;

////by jmpessoa
Procedure jPanel_setXYWH(env:PJNIEnv;this:jobject;
                              Panel : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jPanel_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Panel;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//by jmpessoa
Procedure jPanel_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        Panel : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jPanel_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


////by jmpessoa
Procedure jPanel_setParent(env:PJNIEnv;this:jobject;
                                Panel : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jPanel_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Panel;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//by jmpessoa
Function jPanel_getView(env:PJNIEnv;this:jobject;
                             Panel : jObject) : jObject;
 Const
  _cFuncName = 'jPanel_getView';
  _cFuncSig  = '(Ljava/lang/Object;)Landroid/widget/RelativeLayout;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := Panel;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 end;

//by jmpessoa
Procedure jPanel_setId(env:PJNIEnv;this:jobject; Panel : jObject; id: DWord);
Const
 _cFuncName = 'jPanel_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setMarginLeft(env:PJNIEnv;this:jobject; Panel : jObject; x: DWord);
Const
 _cFuncName = 'jPanel_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setMarginTop(env:PJNIEnv;this:jobject; Panel : jObject; y: DWord);
Const
 _cFuncName = 'jPanel_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setMarginRight(env:PJNIEnv;this:jobject; Panel : jObject; x: DWord);
Const
 _cFuncName = 'jPanel_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setMarginBottom(env:PJNIEnv;this:jobject; Panel : jObject; y: DWord);
Const
 _cFuncName = 'jPanel_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setLParamWidth(env:PJNIEnv;this:jobject; Panel : jObject; w: DWord);
Const
 _cFuncName = 'jPanel_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setLParamHeight(env:PJNIEnv;this:jobject; Panel : jObject; h: DWord);
Const
 _cFuncName = 'jPanel_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
function jPanel_getLParamHeight(env:PJNIEnv;this:jobject; Panel : jObject ): integer;
Const
 _cFuncName = 'jPanel_getLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := Panel;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
function jPanel_getLParamWidth(env:PJNIEnv;this:jobject; Panel : jObject): integer;
Const
 _cFuncName = 'jPanel_getLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := Panel;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_resetLParamsRules(env:PJNIEnv;this:jobject; Panel : jObject);
Const
 _cFuncName = 'jPanel_resetLParamsRules';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..0] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_addLParamsParentRule(env:PJNIEnv;this:jobject; Panel : jObject; rule: DWord);
Const
 _cFuncName = 'jPanel_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_addLParamsAnchorRule(env:PJNIEnv;this:jobject; Panel : jObject; rule: DWord);
Const
 _cFuncName = 'jPanel_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jPanel_setLayoutAll(env:PJNIEnv;this:jobject; Panel : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jPanel_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := Panel;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// HorizontalScrollView
// LORDMAN 2013-09-03
//------------------------------------------------------------------------------
//
Function  jHorizontalScrollView_Create  (env:PJNIEnv;this:jobject;
                                         context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jHorizontalScrollView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jHorizontalScrollView_Free   (env:PJNIEnv;this:jobject; ScrollView : jObject);
  Const
   _cFuncName = 'jHorizontalScrollView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ScrollView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ScrollView);
  end;

//
Procedure jHorizontalScrollView_setXYWH(env:PJNIEnv;this:jobject;
                                        ScrollView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jHorizontalScrollView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jHorizontalScrollView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ScrollView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jHorizontalScrollView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jHorizontalScrollView_setParent(env:PJNIEnv;this:jobject;
                                          ScrollView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jHorizontalScrollView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jHorizontalScrollView_setScrollSize(env:PJNIEnv;this:jobject;
                                              ScrollView : jObject; size : integer);
 Const
  _cFuncName = 'jHorizontalScrollView_setScrollSize';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ScrollView;
  _jParams[1].i := size;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Function jHorizontalScrollView_getView(env:PJNIEnv;this:jobject;
                                       ScrollView : jObject) : jObject;
 Const
  _cFuncName = 'jHorizontalScrollView_getView';
  _cFuncSig  = '(Ljava/lang/Object;)Landroid/view/ViewGroup;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := ScrollView;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 end;

//by jmpessoa
Procedure jHorizontalScrollView_setId(env:PJNIEnv;this:jobject; ScrollView : jObject; id: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jHorizontalScrollView_setMarginLeft(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_setMarginTop(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jHorizontalScrollView_setMarginRight(env:PJNIEnv;this:jobject; ScrollView : jObject; x: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_setMarginBottom(env:PJNIEnv;this:jobject; ScrollView : jObject; y: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_setLParamWidth(env:PJNIEnv;this:jobject; ScrollView : jObject; w: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_setLParamHeight(env:PJNIEnv;this:jobject;
                                       ScrollView : jObject; h: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jHorizontalScrollView_addLParamsParentRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ScrollView : jObject; rule: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jHorizontalScrollView_setLayoutAll(env:PJNIEnv;this:jobject; ScrollView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jHorizontalScrollView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ScrollView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// ViewFlipper
//------------------------------------------------------------------------------

// ViewFlipper
Function  jViewFlipper_Create          (env:PJNIEnv;this:jobject;
                                        context : jObject; SelfObj : TObject ) : jObject;
Const
 _cFuncName = 'jViewFlipper_Create';
 _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := SelfObj;
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 Result := env^.NewGlobalRef(env,Result);
end;

Procedure jViewFlipper_Free            (env:PJNIEnv;this:jobject; ViewFlipper : jObject);
Const
 _cFuncName = 'jViewFlipper_Free';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := ViewFlipper;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteGlobalRef(env,ViewFlipper);
end;

//
Procedure jViewFlipper_setXYWH         (env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject;x,y,w,h : integer);
Const
 _cFuncName = 'jViewFlipper_setXYWH';
 _cFuncSig  = '(Ljava/lang/Object;IIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..4] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := x;
 _jParams[2].i := y;
 _jParams[3].i := w;
 _jParams[4].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jViewFlipper_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setParent       (env:PJNIEnv;this:jobject;
                                        ViewFlipper : jObject;ViewGroup : jObject);
Const
 _cFuncName = 'jViewFlipper_setParent';
 _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].l := ViewGroup;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setId(env:PJNIEnv;this:jobject; ViewFlipper : jObject; id: DWord);
Const
 _cFuncName = 'jViewFlipper_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setMarginLeft(env:PJNIEnv;this:jobject; ViewFlipper : jObject; x: DWord);
Const
 _cFuncName = 'jViewFlipper_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setMarginTop(env:PJNIEnv;this:jobject; ViewFlipper : jObject; y: DWord);
Const
 _cFuncName = 'jViewFlipper_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jViewFlipper_setMarginRight(env:PJNIEnv;this:jobject; ViewFlipper : jObject; x: DWord);
Const
 _cFuncName = 'jViewFlipper_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setMarginBottom(env:PJNIEnv;this:jobject; ViewFlipper : jObject; y: DWord);
Const
 _cFuncName = 'jViewFlipper_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setLParamWidth(env:PJNIEnv;this:jobject; ViewFlipper : jObject; w: DWord);
Const
 _cFuncName = 'jViewFlipper_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setLParamHeight(env:PJNIEnv;this:jobject; ViewFlipper : jObject; h: DWord);
Const
 _cFuncName = 'jViewFlipper_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jViewFlipper_addLParamsParentRule(env:PJNIEnv;this:jobject; ViewFlipper : jObject; rule: DWord);
Const
 _cFuncName = 'jViewFlipper_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ViewFlipper : jObject; rule: DWord);
Const
 _cFuncName = 'jViewFlipper_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jViewFlipper_setLayoutAll(env:PJNIEnv;this:jobject; ViewFlipper : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jViewFlipper_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ViewFlipper;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// WebView
//------------------------------------------------------------------------------

//
Function  jWebView_Create  (env:PJNIEnv;this:jobject;
                            context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jWebView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jWebView_Free   (env:PJNIEnv;this:jobject; WebView : jObject);
  Const
   _cFuncName = 'jWebView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := WebView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,WebView);
  end;

//
Procedure jWebView_setXYWH(env:PJNIEnv;this:jobject;
                           WebView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jWebView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := WebView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jWebView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        WebView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jWebView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//
Procedure jWebView_setParent(env:PJNIEnv;this:jobject;
                             WebView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jWebView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := WebView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jWebView_setJavaScript       (env:PJNIEnv;this:jobject;
                                        WebView : jObject; javascript : boolean);
Const
 _cFuncName = 'jWebView_setJavaScript';
 _cFuncSig  = '(Ljava/lang/Object;Z)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].z := jBool(JavaScript);
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jWebView_loadURL(env:PJNIEnv;this:jobject;
                           WebView : jObject; Str : String);
 Const
  _cFuncName = 'jWebView_loadURL';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := WebView;
  _jParams[1].l := env^.NewStringUTF(env, pchar(Str) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//by jmpessoa
Procedure jWebView_setId(env:PJNIEnv;this:jobject; WebView : jObject; id: DWord);
Const
 _cFuncName = 'jWebView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jWebView_setMarginLeft(env:PJNIEnv;this:jobject; WebView: jObject; x: DWord);
Const
 _cFuncName = 'jWebView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setMarginTop(env:PJNIEnv;this:jobject; WebView: jObject; y: DWord);
Const
 _cFuncName = 'jWebView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jWebView_setMarginRight(env:PJNIEnv;this:jobject; WebView: jObject; x: DWord);
Const
 _cFuncName = 'jWebView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setMarginBottom(env:PJNIEnv;this:jobject; WebView: jObject; y: DWord);
Const
 _cFuncName = 'jWebView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setLParamWidth(env:PJNIEnv;this:jobject; WebView : jObject; w: DWord);
Const
 _cFuncName = 'jWebView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setLParamHeight(env:PJNIEnv;this:jobject; WebView : jObject; h: DWord);
Const
 _cFuncName = 'jWebView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jWebView_addLParamsParentRule(env:PJNIEnv;this:jobject; WebView : jObject; rule: DWord);
Const
 _cFuncName = 'jWebView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; WebView : jObject; rule: DWord);
Const
 _cFuncName = 'jWebView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jWebView_setLayoutAll(env:PJNIEnv;this:jobject; WebView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jWebView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := WebView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// Canvas
//------------------------------------------------------------------------------

Function  jCanvas_Create               (env:PJNIEnv;this:jobject;
                                        SelfObj : TObject) : jObject;
Const
 _cFuncName = 'jCanvas_Create';
 _cFuncSig  = '(I)Ljava/lang/Object;';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := SelfObj;
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Result := env^.NewGlobalRef(env,Result);
end;

Procedure jCanvas_Free                 (env:PJNIEnv;this:jobject; jCanvas : jObject);
Const
 _cFuncName = 'jCanvas_Free';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := jCanvas;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteGlobalRef(env,jCanvas);
end;

//
Procedure jCanvas_setStrokeWidth       (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject;width : single);
Const
 _cFuncName = 'jCanvas_setStrokeWidth';
 _cFuncSig  = '(Ljava/lang/Object;F)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].f := width;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCanvas_setStyle             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; style : integer);
Const
 _cFuncName = 'jCanvas_setStyle';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].i := style;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCanvas_setColor             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; color : DWord  );
Const
 _cFuncName = 'jCanvas_setColor';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].i := color;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCanvas_setTextSize          (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; textsize : single );
Const
 _cFuncName = 'jCanvas_setTextSize';
 _cFuncSig  = '(Ljava/lang/Object;F)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].f := textsize;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCanvas_drawLine             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; x1,y1,x2,y2 : single);
Const
 _cFuncName = 'jCanvas_drawLine';
 _cFuncSig  = '(Ljava/lang/Object;FFFF)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..4] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].F := x1;
 _jParams[2].F := y1;
 _jParams[3].F := x2;
 _jParams[4].F := y2;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

// LORDMAN 2013-08-13
Procedure jCanvas_drawPoint(env:PJNIEnv;this:jobject; jCanvas:jObject; x1,y1:single);
Const
_cFuncName = 'jCanvas_drawPoint';
_cFuncSig  = '(Ljava/lang/Object;FF)V';
Var
_jMethod : jMethodID = nil;
_jParams : Array[0..2] of jValue;
begin
jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
_jParams[0].l := jCanvas;
_jParams[1].F := x1;
_jParams[2].F := y1;
env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jCanvas_drawText             (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; const text : string; x,y : single);
Const
 _cFuncName = 'jCanvas_drawText';
 _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;FF)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..3] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].l := env^.NewStringUTF(env, pchar(text) );
 _jParams[2].F := x;
 _jParams[3].F := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;


Procedure jCanvas_drawBitmap           (env:PJNIEnv;this:jobject;
                                        jCanvas : jObject; bmp : jObject; b,l,r,t : integer);
Const
 _cFuncName = 'jCanvas_drawBitmap';
 _cFuncSig  = '(Ljava/lang/Object;Landroid/graphics/Bitmap;IIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..5] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := jCanvas;
 _jParams[1].l := bmp;
 _jParams[2].i := b;
 _jParams[3].i := l;
 _jParams[4].i := r;
 _jParams[5].i := t;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// Bitmap
//------------------------------------------------------------------------------

//
Function  jBitmap_Create  (env:PJNIEnv;this:jobject;
                           SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jBitmap_Create';
  _cFuncSig  = '(I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jBitmap_Free   (env:PJNIEnv;this:jobject; jbitmap : jObject);
  Const
   _cFuncName = 'jBitmap_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParam  : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParam.l := jbitmap;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
   env^.DeleteGlobalRef(env,jbitmap);
  end;

//
Procedure jBitmap_loadFile(env:PJNIEnv;this:jobject;
                           jbitmap : jObject; filename : String);
 Const
  _cFuncName = 'jBitmap_loadFile';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := jbitmap;
  _jParams[1].l := env^.NewStringUTF(env, pchar(filename) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//
Procedure jBitmap_createBitmap(env:PJNIEnv;this:jobject;
                               jbitmap : jObject; w,h : integer);
 Const
  _cFuncName = 'jBitmap_createBitmap';
  _cFuncSig  = '(Ljava/lang/Object;II)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..2] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := jbitmap;
  _jParams[1].i := w;
  _jParams[2].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jBitmap_getWH(env:PJNIEnv;this:jobject;
                        jbitmap : jObject; var w,h : integer);
 Const
  _cFuncName = 'jBitmap_getWH';
  _cFuncSig  = '(Ljava/lang/Object;)[I';
 Var
  _jMethod   : jMethodID = nil;
  _jParam    : jValue;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  //
  PInt       : PInteger;
  PIntSav    : PInteger;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l  := jbitmap;
  _jIntArray := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  //
  _jBoolean  := JNI_False;
  PInt       := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
  PIntSav    := PInt;
  w          := PInt^; Inc(PInt);
  h          := PInt^; Inc(PInt);
  env^.ReleaseIntArrayElements(env,_jIntArray,PIntSav,0);
 end;

Function  jBitmap_getJavaBitmap (env:PJNIEnv;this:jobject;
                                 jbitmap : jObject) : jObject;
Const
 _cFuncName = 'jBitmap_getJavaBitmap';
 _cFuncSig  = '(Ljava/lang/Object;)Landroid/graphics/Bitmap;';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := jbitmap;
 Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Dbg('Pascal:jBitmap_getJavaBitmap');
end;

//------------------------------------------------------------------------------
// View
//------------------------------------------------------------------------------

//
Function  jView_Create  (env:PJNIEnv;this:jobject;
                         context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jView_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
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
Procedure jView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; View : jObject; rule: DWord);
Const
 _cFuncName = 'jView_addLParamsAnchorRule';
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
Procedure jView_setLayoutAll(env:PJNIEnv;this:jobject; View : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := View;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// jGLSurfaceView
//------------------------------------------------------------------------------

Function  jGLSurfaceView_Create(env:PJNIEnv;this:jobject; 
                                context : jObject; SelfObj : TObject; version : integer) : jObject;
 Const
  _cFuncName = 'jGLSurfaceView_Create';
  _cFuncSig  = '(Landroid/content/Context;II)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..2] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  _jParams[2].i := version;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jGLSurfaceView_Free   (env:PJNIEnv;this:jobject; GLSurfaceView : jObject);
  Const
   _cFuncName = 'jGLSurfaceView_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := GLSurfaceView;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,GLSurfaceView);
  end;

// 
Procedure jGLSurfaceView_setXYWH(env:PJNIEnv;this:jobject;
                                 GLSurfaceView : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jGLSurfaceView_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := GLSurfaceView;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jGLSurfaceView_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        GLSurfaceView : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jGLSurfaceView_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


// 
Procedure jGLSurfaceView_setParent(env:PJNIEnv;this:jobject;
                                   GLSurfaceView : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jGLSurfaceView_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := GLSurfaceView;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;
 
Procedure jGLSurfaceView_SetAutoRefresh(env:PJNIEnv;this:jobject; glView : jObject; Active : Boolean);
 Const
  _cFuncName = 'jGLSurfaceView_SetAutoRefresh';
  _cFuncSig  = '(Ljava/lang/Object;Z)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := glView;
  _jParams[1].z := jBool(Active);
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jGLSurfaceView_Refresh(env:PJNIEnv;this:jobject; glView : jObject);
 Const
  _cFuncName = 'jGLSurfaceView_Refresh';
  _cFuncSig  = '(Ljava/lang/Object;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := glView;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 end;

Procedure jGLSurfaceView_deleteTexture(env:PJNIEnv;this:jobject; glView : jObject; id : Integer);
 Const
  _cFuncName = 'jGLSurfaceView_deleteTexture';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 begin
  gVM^.AttachCurrentThread(gVm,@env,nil);
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := glView;
  _jParams[1].i := id;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jGLSurfaceView_getBmpArray(env:PJNIEnv;this:jobject;filename : String);
 Const
  _cFuncName = 'getBmpArray';
  _cFuncSig  = '(Ljava/lang/String;)[I';
 Var
  _jMethod   : jMethodID = nil;
  _jParam    : jValue;
  _jIntArray : jintArray;
  _jBoolean  : jBoolean;
  //
  Size : Integer;
  PInt : PInteger;
  PIntS: PInteger;
  i    : Integer;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l  := env^.NewStringUTF( env, pchar(filename));
  _jIntArray := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  env^.DeleteLocalRef(env,_jParam.l);
  Size := env^.GetArrayLength(env,_jIntArray);
  dbg('Size: ' + IntToStr(Size) );
  _jBoolean  := JNI_False;
  PInt := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);
  PIntS:= PInt;
  Inc(PIntS,Size-2);
  dbg('width:'  + IntToStr(PintS^)); Inc(PintS);
  dbg('height:' + IntToStr(PintS^));
  env^.ReleaseIntArrayElements(env,_jIntArray,PInt,0);
  dbg('Here...');
 end;

Procedure jGLSurfaceView_requestGLThread(env:PJNIEnv;this:jobject; glView : jObject);
 Const
  _cFuncName = 'jGLSurfaceView_glThread';
  _cFuncSig  = '(Ljava/lang/Object;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  gVM^.AttachCurrentThread(gVm,@env,nil);
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := glView;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 end;

//by jmpessoa
Procedure jGLSurfaceView_setId(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; id: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jGLSurfaceView_setMarginLeft(env:PJNIEnv;this:jobject; GLSurfaceView: jObject; x: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setMarginTop(env:PJNIEnv;this:jobject; GLSurfaceView: jObject; y: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;
Procedure jGLSurfaceView_setMarginRight(env:PJNIEnv;this:jobject; GLSurfaceView: jObject; x: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setMarginBottom(env:PJNIEnv;this:jobject; GLSurfaceView: jObject; y: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setLParamWidth(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; w: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setLParamHeight(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; h: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
function jGLSurfaceView_getLParamHeight(env:PJNIEnv;this:jobject; GLSurfaceView : jObject ): integer;
Const
 _cFuncName = 'jGLSurfaceView_getLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := GLSurfaceView;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

function jGLSurfaceView_getLParamWidth(env:PJNIEnv;this:jobject; GLSurfaceView : jObject): integer;
Const
 _cFuncName = 'jGLSurfaceView_getLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := GLSurfaceView;
 Result     := env^.CallIntMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_addLParamsParentRule(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; rule: DWord);
Const
 _cFuncName = 'jGLSurfaceView_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_addLParamsAnchorRule(env:PJNIEnv;this:jobject; GLSurfaceView : jObject; rule: DWord);
Const
 _cFuncName = 'jGLSurfaceView_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jGLSurfaceView_setLayoutAll(env:PJNIEnv;this:jobject; GLSurfaceView : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jGLSurfaceView_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := GLSurfaceView;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// Timer
//------------------------------------------------------------------------------

Function jTimer_Create (env:PJNIEnv;this:jobject; SelfObj : TObject): jObject;
 Const
  _cFuncName = 'jTimer_Create';
  _cFuncSig  = '(I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := SelfObj;
  Result    := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  Result    := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jTimer_Free   (env:PJNIEnv;this:jobject; Timer : jObject);
  Const
   _cFuncName = 'jTimer_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := Timer;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,Timer);
  end;

Procedure jTimer_SetInterval(env:PJNIEnv;this:jobject; Timer  : jObject; Interval : Integer);
 Const
  _cFuncName = 'jTimer_SetInterval';
  _cFuncSig  = '(Ljava/lang/Object;I)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Timer;
  _jParams[1].i := Interval;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jTimer_SetEnabled (env:PJNIEnv;this:jobject; Timer  : jObject; Active : Boolean);
 Const
  _cFuncName = 'jTimer_SetEnabled';
  _cFuncSig  = '(Ljava/lang/Object;Z)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := Timer;
  _jParams[1].z := jBool(Active);
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//------------------------------------------------------------------------------
// jDialog YN
//------------------------------------------------------------------------------

Function jDialogYN_Create (env:PJNIEnv;this:jobject; SelfObj : TObject;
                           title,msg,y,n : string ): jObject;
 Const
  _cFuncName = 'jDialogYN_Create';
  _cFuncSig  = '(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := SelfObj;
  _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(Msg  ) );
  _jParams[3].l := env^.NewStringUTF(env, pchar(y    ) );
  _jParams[4].l := env^.NewStringUTF(env, pchar(n    ) );
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
  env^.DeleteLocalRef(env,_jParams[3].l);
  env^.DeleteLocalRef(env,_jParams[4].l);
 end;

//
Procedure jDialogYN_Free   (env:PJNIEnv;this:jobject; DialogYN : jObject);
  Const
   _cFuncName = 'jDialogYN_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := DialogYN;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,DialogYN);
  end;

Procedure jDialogYN_Show (env:PJNIEnv;this:jobject; DialogYN: jObject);
Const
 _cFuncName = 'jDialogYN_Show';
 _cFuncSig  = '(Ljava/lang/Object;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := DialogYN;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
end;

//------------------------------------------------------------------------------
// jDialog Progress
//------------------------------------------------------------------------------

Function jDialogProgress_Create (env:PJNIEnv;this:jobject; SelfObj : TObject;
                                 title,msg : string ): jObject;
 Const
  _cFuncName = 'jDialogProgress_Create';
  _cFuncSig  = '(ILjava/lang/String;Ljava/lang/String;)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..2] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := SelfObj;
  _jParams[1].l := env^.NewStringUTF(env, pchar(title) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(Msg  ) );
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
 end;

//
Procedure jDialogProgress_Free (env:PJNIEnv;this:jobject; DialogProgress : jObject);
 Const
  _cFuncName = 'jDialogProgress_Free';
  _cFuncSig  = '(Ljava/lang/Object;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l  := DialogProgress;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
  env^.DeleteGlobalRef(env,DialogProgress);
 end;

//------------------------------------------------------------------------------
// MessageBox , Dialog
//------------------------------------------------------------------------------

Procedure jToast (env:PJNIEnv;this:jobject; Str : String);
 Const
  _cFuncName = 'jToast';
  _cFuncSig  = '(Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l := env^.NewStringUTF(env, pchar(Str) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 env^.DeleteLocalRef(env,_jParam.l);
end;

//------------------------------------------------------------------------------
// jImageBtn
//------------------------------------------------------------------------------

//
Function  jImageBtn_Create  (env:PJNIEnv;this:jobject;
                              context : jObject; SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jImageBtn_Create';
  _cFuncSig  = '(Landroid/content/Context;I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := context;
  _jParams[1].l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jImageBtn_Free   (env:PJNIEnv;this:jobject; ImageBtn : jObject);
  Const
   _cFuncName = 'jImageBtn_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := ImageBtn;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,ImageBtn);
  end;

//
Procedure jImageBtn_setXYWH(env:PJNIEnv;this:jobject;
                            ImageBtn : jObject;x,y,w,h : integer);
 Const
  _cFuncName = 'jImageBtn_setXYWH';
  _cFuncSig  = '(Ljava/lang/Object;IIII)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..4] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageBtn;
  _jParams[1].i := x;
  _jParams[2].i := y;
  _jParams[3].i := w;
  _jParams[4].i := h;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

Procedure jImageBtn_setLeftTopRightBottomWidthHeight(env:PJNIEnv;this:jobject;
                                        ImageBtn : jObject; ml,mt,mr,mb,w,h: integer);
Const
 _cFuncName = 'jImageBtn_setLeftTopRightBottomWidthHeight';
 _cFuncSig  = '(Ljava/lang/Object;IIIIII)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..6] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := ml;
 _jParams[2].i := mt;
 _jParams[3].i := mr;
 _jParams[4].i := mb;
 _jParams[5].i := w;
 _jParams[6].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jImageBtn_setParent(env:PJNIEnv;this:jobject;
                               ImageBtn : jObject;ViewGroup : jObject);
 Const
  _cFuncName = 'jImageBtn_setParent';
  _cFuncSig  = '(Ljava/lang/Object;Landroid/view/ViewGroup;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageBtn;
  _jParams[1].l := ViewGroup;
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end;

//
Procedure jImageBtn_setButton(env:PJNIEnv;this:jobject;
                              ImageBtn: jObject; up,dn : string);
 Const
  _cFuncName = 'jImageBtn_setButton';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..2] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageBtn;
  _jParams[1].l := env^.NewStringUTF(env, pchar(up) );
  _jParams[2].l := env^.NewStringUTF(env, pchar(dn) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
  env^.DeleteLocalRef(env,_jParams[2].l);
 end;

 //by jmpessoa
Procedure jImageBtn_setButtonUp(env:PJNIEnv;this:jobject;
                              ImageBtn: jObject; up: string);
 Const
  _cFuncName = 'jImageBtn_setButtonUp';
  _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageBtn;
  _jParams[1].l := env^.NewStringUTF(env, pchar(up) );
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[1].l);
 end;

//by jmpessoa
Procedure jImageBtn_setButtonDown(env:PJNIEnv;this:jobject;
                             ImageBtn: jObject; dn: string);
Const
 _cFuncName = 'jImageBtn_setButtonDown';
 _cFuncSig  = '(Ljava/lang/Object;Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].l := env^.NewStringUTF(env, pchar(dn) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
end;


// LORDMAN 2013-08-16
Procedure jImageBtn_SetEnabled (env:PJNIEnv;this:jobject; 
                                ImageBtn : jObject; Active   : Boolean);
 Const
  _cFuncName = 'jImageBtn_setEnabled';
  _cFuncSig  = '(Ljava/lang/Object;Z)V';
 Var
  _jMethod : jMethodID = nil;
  _jParams : Array[0..1] of jValue;
 begin
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParams[0].l := ImageBtn;
  _jParams[1].z := jBool(Active);
  env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 end; 

//by jmpessoa
Procedure jImageBtn_setId(env:PJNIEnv;this:jobject; ImageBtn : jObject; id: DWord);
Const
 _cFuncName = 'jImageBtn_setId';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := id;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

Procedure jImageBtn_setMarginLeft(env:PJNIEnv;this:jobject; ImageBtn: jObject; x: DWord);
Const
 _cFuncName = 'jImageBtn_setMarginLeft';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_setMarginTop(env:PJNIEnv;this:jobject; ImageBtn: jObject; y: DWord);
Const
 _cFuncName = 'jImageBtn_setMarginTop';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;
Procedure jImageBtn_setMarginRight(env:PJNIEnv;this:jobject; ImageBtn: jObject; x: DWord);
Const
 _cFuncName = 'jImageBtn_setMarginRight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := x;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_setMarginBottom(env:PJNIEnv;this:jobject; ImageBtn: jObject; y: DWord);
Const
 _cFuncName = 'jImageBtn_setMarginBottom';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := y;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_setLParamWidth(env:PJNIEnv;this:jobject; ImageBtn : jObject; w: DWord);
Const
 _cFuncName = 'jImageBtn_setLParamWidth';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := w;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_setLParamHeight(env:PJNIEnv;this:jobject; ImageBtn : jObject; h: DWord);
Const
 _cFuncName = 'jImageBtn_setLParamHeight';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := h;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//by jmpessoa
Procedure jImageBtn_addLParamsParentRule(env:PJNIEnv;this:jobject; ImageBtn : jObject; rule: DWord);
Const
 _cFuncName = 'jImageBtn_addLParamsParentRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_addLParamsAnchorRule(env:PJNIEnv;this:jobject; ImageBtn : jObject; rule: DWord);
Const
 _cFuncName = 'jImageBtn_addLParamsAnchorRule';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := rule;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//by jmpessoa
Procedure jImageBtn_setLayoutAll(env:PJNIEnv;this:jobject; ImageBtn : jObject;  idAnchor: DWord);
Const
 _cFuncName = 'jImageBtn_setLayoutAll';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..1] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := ImageBtn;
 _jParams[1].i := idAnchor;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//------------------------------------------------------------------------------
// jAsyncTask
//------------------------------------------------------------------------------

//
Function  jAsyncTask_Create  (env:PJNIEnv;this:jobject;
                              SelfObj : TObject) : jObject;
 Const
  _cFuncName = 'jAsyncTask_Create';
  _cFuncSig  = '(I)Ljava/lang/Object;';
 Var
  _jMethod : jMethodID = nil;
  _jParam  : jValue;
 begin
  //dbg('jAsyncTask_Create env:'+IntTostr(integer(env)));
  jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
  _jParam.l := SelfObj;
  Result := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  Result := env^.NewGlobalRef(env,Result);
 end;

//
Procedure jAsyncTask_Free   (env:PJNIEnv;this:jobject; AsyncTask : jObject);
  Const
   _cFuncName = 'jAsyncTask_Free';
   _cFuncSig  = '(Ljava/lang/Object;)V';
  Var
   _jMethod : jMethodID = nil;
   _jParams : jValue;
  begin
   dbg('jAsyncTask_Free env:'+IntTostr(integer(env)));
   jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
   _jParams.l := AsyncTask;
   env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
   env^.DeleteGlobalRef(env,AsyncTask);
  end;

//
procedure jAsyncTask_Execute(env:PJNIEnv;this:jobject; AsyncTask : jObject);
const
 _cFuncName = 'jAsyncTask_Execute';
 _cFuncSig  = '(Ljava/lang/Object;)V';
var
 _jMethod : jMethodID = nil;
 _jParams : jValue;
begin
 //dbg('jAsyncTask_Execute env:'+IntTostr(integer(env)));
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams.l := AsyncTask;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;

//
Procedure jAsyncTask_setProgress(env:PJNIEnv;this:jobject; AsyncTask : jObject;Progress : Integer);
const
 _cFuncName = 'jAsyncTask_setProgress';
 _cFuncSig  = '(Ljava/lang/Object;I)V';
var
 _jMethod : jMethodID = nil;
 _jParams : Array[0..1] of jValue;
begin
 //dbg('jAsyncTask_setProgress env:'+IntTostr(integer(env)));
 gVM^.AttachCurrentThread(gVm,@env,nil);
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := AsyncTask;
 _jParams[1].i := progress;
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
end;


//------------------------------------------------------------------------------
// jHttp_Get
//------------------------------------------------------------------------------

//
Function  jHttp_Get(env:PJNIEnv; this:jobject; URL : String) : String;
Const
 _cFuncName = 'jHttp_get';
 _cFuncSig  = '(Ljava/lang/String;)Ljava/lang/String;';
Var
 _jMethod  : jMethodID = nil;
 _jString  : jString;
 _jBoolean : jBoolean;
 _jParam   : jValue;
begin
 gVM^.AttachCurrentThread(gVm,@env,nil);   //fix by jmpessoa
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l  := env^.NewStringUTF(env, pchar(URL) );
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
 Case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := String( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParam.l);
 dbg('Http_Get:'+ Result);
end;


//by jmpessoa
procedure jSend_Email(env:PJNIEnv;this:jobject; context: jObject;
                       sto: string;
                       scc: string;
                       sbcc: string;
                       ssubject: string;
                       smessage:string);
Const
 _cFuncName = 'jSend_Email';
 _cFuncSig  = '(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String; Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..5] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := env^.NewStringUTF(env, pchar(sto) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(scc) );
 _jParams[3].l := env^.NewStringUTF(env, pchar(sbcc) );
 _jParams[4].l := env^.NewStringUTF(env, pchar(ssubject) );
 _jParams[5].l := env^.NewStringUTF(env, pchar(smessage) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
 env^.DeleteLocalRef(env,_jParams[3].l);
 env^.DeleteLocalRef(env,_jParams[4].l);
 env^.DeleteLocalRef(env,_jParams[5].l);
end;


//by jmpessoa
function jSend_SMS(env:PJNIEnv;this:jobject; context: jObject;
                       toNumber: string;
                       smessage:string): integer;
Const
 _cFuncName = 'jSend_SMS';
 _cFuncSig  = '(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I';
Var
 _jMethod : jMethodID = nil;
 _jParams : array[0..2] of jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := env^.NewStringUTF(env, pchar(toNumber) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(smessage) );
 Result:= env^.CallIntMethodA(env,this,_jMethod,@_jParams);
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
end;

//by jmpessoa
function jContact_getMobileNumberByDisplayName(env:PJNIEnv;this:jobject; context: jObject;
                                               contactName: string): string;
const
 _cFuncName = 'jContact_getMobileNumberByDisplayName';
 _cFuncSig  = '(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;';
var
 _jMethod  : jMethodID = nil;
 _jString  : jString;
 _jBoolean : jBoolean;
 _jParams : array[0..1] of jValue;

begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := env^.NewStringUTF(env, pchar(contactName) );
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParams[1].l);
end;

//by jmpessoa
function jContact_getDisplayNameList(env:PJNIEnv;this:jobject; context: jObject; delimiter: char): string;
const
 _cFuncName = 'jContact_getDisplayNameList';
 _cFuncSig  = '(Landroid/content/Context;C)Ljava/lang/String;';
var
 _jMethod  : jMethodID = nil;
 _jString  : jString;
 _jBoolean : jBoolean;
 _jParams : array[0..1] of jValue;

begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].c := jChar(delimiter);
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
Procedure jTakePhoto(env:PJNIEnv; this:jobject; filename : String);
Const
 _cFuncName = 'takePhoto';
 _cFuncSig  = '(Ljava/lang/String;)V';
Var
 _jMethod : jMethodID = nil;
 _jParam  : jValue;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParam.l:= env^.NewStringUTF(env, pchar(filename) );
 env^.CallVoidMethodA(env,this,_jMethod,@_jParam);
 env^.DeleteLocalRef(env,_jParam.l);
end;

//by jmpessoa   - //Use: path =  App.Path.DCIM
                  //     filename = '/test.jpg
function jCamera_takePhoto(env:PJNIEnv; this:jobject; context: jObject; path: string; filename : String): string;
const
 _cFuncName = 'jCamera_takePhoto';
 _cFuncSig  = '(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;';
var
 _jMethod  : jMethodID = nil;
 _jParams : array[0..2] of jValue;
 _jString  : jString;
 _jBoolean : jBoolean;
begin
 jClassMethod(_cFuncName,_cFuncSig,env,gjClass,_jMethod);
 _jParams[0].l := context;
 _jParams[1].l := env^.NewStringUTF(env, pchar(path) );
 _jParams[2].l := env^.NewStringUTF(env, pchar(filename) );
 _jString   := env^.CallObjectMethodA(env,this,_jMethod,@_jParams);
 // env^.CallVoidMethodA(env,this,_jMethod,@_jParams);
 case _jString = nil of
  True : Result    := '';
  False: begin
          _jBoolean := JNI_False;
          Result    := string( env^.GetStringUTFChars(Env,_jString,@_jBoolean) );
         end;
 end;
 env^.DeleteLocalRef(env,_jParams[1].l);
 env^.DeleteLocalRef(env,_jParams[2].l);
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
Procedure jBenchMark1_Java  (env:PJNIEnv;this:jobject;var mSec : Integer;var value : single);
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

Procedure jBenchMark1_Pascal (env:PJNIEnv;this:jobject;var mSec : Integer;var value : single);
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
