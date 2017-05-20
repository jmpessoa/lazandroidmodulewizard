unit modaldialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TDialogTheme = (thHoloLightDialog, thHoloDialog, thDialog);

{Draft Component code by "Lazarus Android Module Wizard" [5/16/2017 0:28:03]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jModalDialog = class(jControl)
 private
    FTheme: TDialogTheme;
    FCaptionOK: string;
    FCaptionCancel: string;
    FTitle: string;
    FTitleFontSize: integer;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetRequestCode(_requestCode: integer);
    procedure SetDialogTitle(_dialogTitle: string);
    procedure ShowMessage(_packageName: string);
    procedure InputForActivityResult(_packageName: string; var _requestInfo: TDynArrayOfString);
    procedure QuestionForActivityResult(_packageName: string);

    function GetStringValue(_intentData: jObject; _fieldName: string): string;
    function GetIntValue(_intentData: jObject; _fieldName: string): integer;

    procedure SetTheme(_dialogTheme: TDialogTheme);
    procedure SetHasWindowTitle(_hasWindowTitle: boolean);

    procedure SetCaptionButtonOK(_captionBtnOk: string);
    procedure SetCaptionButtonCancel(_captionBtnCancel: string);
    procedure SetTitleFontSize(_fontSize: integer);
    procedure SetInputHint(_hint: string);

 published
    property Theme: TDialogTheme read  FTheme write SetTheme;
    property CaptionOK: string read FCaptionOK write SetCaptionButtonOK;
    property CaptionCancel: string read FCaptionCancel write SetCaptionButtonCancel;
    property Title: string read FTitle write SetDialogTitle;
    property TitleFontSize: integer read FTitleFontSize write SetTitleFontSize;
end;

function jModalDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jModalDialog_jFree(env: PJNIEnv; _jmodaldialog: JObject);

procedure jModalDialog_SetRequestCode(env: PJNIEnv; _jmodaldialog: JObject; _requestCode: integer);
procedure jModalDialog_SetDialogTitle(env: PJNIEnv; _jmodaldialog: JObject; _dialogTitle: string);
procedure jModalDialog_ShowMessage(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string);
procedure jModalDialog_QuestionForActivityResult(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string);
procedure jModalDialog_InputForActivityResult(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string; var _requestInfo: TDynArrayOfString);
function jModalDialog_GetStringValue(env: PJNIEnv; _jmodaldialog: JObject; _intentData: jObject; _fieldName: string): string;
function jModalDialog_GetIntValue(env: PJNIEnv; _jmodaldialog: JObject; _intentData: jObject; _fieldName: string): integer;
procedure jModalDialog_SetTheme(env: PJNIEnv; _jmodaldialog: JObject; _dialogTheme: integer);
procedure jModalDialog_SetHasWindowTitle(env: PJNIEnv; _jmodaldialog: JObject; _hasWindowTitle: boolean);
procedure jModalDialog_SetCaptionButtonOK(env: PJNIEnv; _jmodaldialog: JObject; _captionOk: string);
procedure jModalDialog_SetCaptionButtonCancel(env: PJNIEnv; _jmodaldialog: JObject; _captionCancel: string);
procedure jModalDialog_SetTitleFontSize(env: PJNIEnv; _jmodaldialog: JObject; _fontSize: integer);
procedure jModalDialog_SetInputHint(env: PJNIEnv; _jmodaldialog: JObject; _hint: string);


implementation


{---------  jModalDialog  --------------}

constructor jModalDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  //FDialogType:= dlgInputBox;
  FTheme:= thHoloLightDialog;
  FCaptionOK:= 'OK';
  FCaptionCancel:= 'Cancel';
  FTitleFontSize:= 0;  //default!
  FTitle:= 'LAMW Modal Dialog'
end;

destructor jModalDialog.Destroy;
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
  inherited Destroy;
end;

procedure jModalDialog.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !

  if FTheme <> thHoloLightDialog then
     jModalDialog_SetTheme(FjEnv, FjObject, Ord(FTheme));

  if FCaptionOK <>  'OK' then
    jModalDialog_SetCaptionButtonOK(FjEnv, FjObject, FCaptionOK);

  if FCaptionCancel <> 'Cancel' then
    jModalDialog_SetCaptionButtonCancel(FjEnv, FjObject, FCaptionCancel);

  if FTitleFontSize <> 0 then
     jModalDialog_SetTitleFontSize(FjEnv, FjObject, FTitleFontSize);

  jModalDialog_SetDialogTitle(FjEnv, FjObject, FTitle);

  FInitialized:= True;
end;

function jModalDialog.jCreate(): jObject;
begin
   Result:= jModalDialog_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jModalDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_jFree(FjEnv, FjObject);
end;

procedure jModalDialog.SetRequestCode(_requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_SetRequestCode(FjEnv, FjObject, _requestCode);
end;

procedure jModalDialog.SetDialogTitle(_dialogTitle: string);
begin
  //in designing component state: set value here...
  FTitle:= _dialogTitle;
  if FInitialized then
     jModalDialog_SetDialogTitle(FjEnv, FjObject, _dialogTitle);
end;

procedure jModalDialog.ShowMessage(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_ShowMessage(FjEnv, FjObject, _packageName);
end;

procedure jModalDialog.QuestionForActivityResult(_packageName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_QuestionForActivityResult(FjEnv, FjObject, _packageName);
end;

procedure jModalDialog.InputForActivityResult(_packageName: string; var _requestInfo: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_InputForActivityResult(FjEnv, FjObject, _packageName ,_requestInfo);
end;

function jModalDialog.GetStringValue(_intentData: jObject; _fieldName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jModalDialog_GetStringValue(FjEnv, FjObject, _intentData ,_fieldName);
end;

function jModalDialog.GetIntValue(_intentData: jObject; _fieldName: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jModalDialog_GetIntValue(FjEnv, FjObject, _intentData ,_fieldName);
end;

procedure jModalDialog.SetTheme(_dialogTheme: TDialogTheme);
begin
  //in designing component state: set value here...
  FTheme:= _dialogTheme;
  if FInitialized then
     jModalDialog_SetTheme(FjEnv, FjObject, Ord(_dialogTheme));
end;

procedure jModalDialog.SetHasWindowTitle(_hasWindowTitle: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_SetHasWindowTitle(FjEnv, FjObject, _hasWindowTitle);
end;

procedure jModalDialog.SetCaptionButtonOK(_captionBtnOk: string);
begin
  //in designing component state: set value here...
  FCaptionOK:= _captionBtnOk;
  if FInitialized then
     jModalDialog_SetCaptionButtonOK(FjEnv, FjObject, _captionBtnOk);
end;

procedure jModalDialog.SetCaptionButtonCancel(_captionBtnCancel: string);
begin
  //in designing component state: set value here...
  FCaptionCancel:= _captionBtnCancel;
  if FInitialized then
     jModalDialog_SetCaptionButtonCancel(FjEnv, FjObject, _captionBtnCancel);
end;

procedure jModalDialog.SetTitleFontSize(_fontSize: integer);
begin
  //in designing component state: set value here...
  FTitleFontSize:= _fontSize;
  if FInitialized then
     jModalDialog_SetTitleFontSize(FjEnv, FjObject, _fontSize);
end;

procedure jModalDialog.SetInputHint(_hint: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModalDialog_SetInputHint(FjEnv, FjObject, _hint);
end;

{-------- jModalDialog_JNI_Bridge ----------}

function jModalDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jModalDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jModalDialog_jCreate(long _Self) {
  return (java.lang.Object)(new jModalDialog(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jModalDialog_jFree(env: PJNIEnv; _jmodaldialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmodaldialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jModalDialog_GetStringValue(env: PJNIEnv; _jmodaldialog: JObject; _intentData: jObject; _fieldName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fieldName));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringValue', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jmodaldialog, jMethod, @jParams);
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

function jModalDialog_GetIntValue(env: PJNIEnv; _jmodaldialog: JObject; _intentData: jObject; _fieldName: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fieldName));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntValue', '(Landroid/content/Intent;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jModalDialog_SetTheme(env: PJNIEnv; _jmodaldialog: JObject; _dialogTheme: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _dialogTheme;
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTheme', '(I)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jModalDialog_SetHasWindowTitle(env: PJNIEnv; _jmodaldialog: JObject; _hasWindowTitle: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_hasWindowTitle);
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHasWindowTitle', '(Z)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

(*
procedure jModalDialog_SetDialogType(env: PJNIEnv; _jmodaldialog: JObject; _dialogType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _dialogType;
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDialogType', '(I)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
*)

procedure jModalDialog_SetRequestCode(env: PJNIEnv; _jmodaldialog: JObject; _requestCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRequestCode', '(I)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jModalDialog_SetDialogTitle(env: PJNIEnv; _jmodaldialog: JObject; _dialogTitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dialogTitle));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDialogTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jModalDialog_ShowMessage(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jModalDialog_InputForActivityResult(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string; var _requestInfo: TDynArrayOfString);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  newSize0:= Length(_requestInfo);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_requestInfo[i])));
  end;
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'InputForActivityResult', '(Ljava/lang/String;[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jModalDialog_QuestionForActivityResult(env: PJNIEnv; _jmodaldialog: JObject; _packageName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'QuestionForActivityResult', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jModalDialog_SetCaptionButtonOK(env: PJNIEnv; _jmodaldialog: JObject; _captionOk: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_captionOk));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCaptionButtonOK', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jModalDialog_SetCaptionButtonCancel(env: PJNIEnv; _jmodaldialog: JObject; _captionCancel: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_captionCancel));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCaptionButtonCancel', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jModalDialog_SetTitleFontSize(env: PJNIEnv; _jmodaldialog: JObject; _fontSize: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontSize;
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleFontSize', '(I)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jModalDialog_SetInputHint(env: PJNIEnv; _jmodaldialog: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jmodaldialog);
  jMethod:= env^.GetMethodID(env, jCls, 'SetInputHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmodaldialog, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
