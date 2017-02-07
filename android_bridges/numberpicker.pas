unit numberpicker;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnNumberPicker = procedure(Sender: TObject; oldValue: integer; newValue: integer) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [9/16/2016 22:45:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

 jNumberPickerDialog = class(jControl)
 private
    FOnNumberPicker: TOnNumberPicker;
    FMinValue: integer;
    FMaxValue: integer;
    FValue: integer;
    FTitle: string;
    FWrapSelectorWheel: boolean;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Show(); overload;

    procedure Cancel();
    procedure SetMinValue(_minValue: integer);
    procedure SetMaxValue(_maxValue: integer);
    procedure SetTitle(_title: string);
    procedure SetWrapSelectorWheel(_value: boolean);

    procedure SetValue(_value: integer);
    procedure Show(_title: string); overload;
    procedure SetDisplayedValues(var _values: TDynArrayOfString);
    procedure ClearDisplayedValues();

    procedure GenEvent_OnNumberPicker(Obj: TObject; oldValue: integer; newValue: integer);

 published

    property MinValue: integer read FMinValue write SetMinValue;
    property MaxValue: integer read FMaxValue write SetMaxValue;
    property Value: integer read FValue write SetValue;
    property Title: string read FTitle write SetTitle;
    property WrapSelectorWheel: boolean read FWrapSelectorWheel write SetWrapSelectorWheel;

    property OnNumberPicker: TOnNumberPicker read FOnNumberPicker write FOnNumberPicker;

end;

function jNumberPicker_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jNumberPicker_jFree(env: PJNIEnv; _jnumberpicker: JObject);
procedure jNumberPicker_Show(env: PJNIEnv; _jnumberpicker: JObject); overload;
procedure jNumberPicker_Cancel(env: PJNIEnv; _jnumberpicker: JObject);
procedure jNumberPicker_SetMinValue(env: PJNIEnv; _jnumberpicker: JObject; _minValue: integer);
procedure jNumberPicker_SetMaxValue(env: PJNIEnv; _jnumberpicker: JObject; _maxValue: integer);
procedure jNumberPicker_SetTitle(env: PJNIEnv; _jnumberpicker: JObject; _title: string);
procedure jNumberPicker_SetWrapSelectorWheel(env: PJNIEnv; _jnumberpicker: JObject; _value: boolean);

procedure jNumberPicker_SetValue(env: PJNIEnv; _jnumberpicker: JObject; _value: integer);
procedure jNumberPicker_Show(env: PJNIEnv; _jnumberpicker: JObject; _title: string); overload;
procedure jNumberPicker_SetDisplayedValues(env: PJNIEnv; _jnumberpicker: JObject; var _values: TDynArrayOfString);
procedure jNumberPicker_ClearDisplayedValues(env: PJNIEnv; _jnumberpicker: JObject);

implementation

{---------  jNumberPicker  --------------}

constructor jNumberPickerDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
 FMinValue:= 0;
 FMaxValue:= 10;
 FValue:= 0;
 FTitle:= 'NumberPicker';
 FWrapSelectorWheel:= True;
end;

destructor jNumberPickerDialog.Destroy;
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

procedure jNumberPickerDialog.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !

  if FMinValue <> 0 then
    jNumberPicker_SetMinValue(FjEnv, FjObject, FMinValue);

  if FMaxValue <> 10 then
    jNumberPicker_SetMaxValue(FjEnv, FjObject, FMaxValue);

  if FValue <> 0 then
    jNumberPicker_SetValue(FjEnv, FjObject, FValue);

  if FTitle <> 'NumberPicker' then
    jNumberPicker_SetTitle(FjEnv, FjObject, FTitle);

  if not FWrapSelectorWheel then
    jNumberPicker_SetWrapSelectorWheel(FjEnv, FjObject, FWrapSelectorWheel);

  FInitialized:= True;
end;


function jNumberPickerDialog.jCreate(): jObject;
begin
   Result:= jNumberPicker_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jNumberPickerDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_jFree(FjEnv, FjObject);
end;

procedure jNumberPickerDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_Show(FjEnv, FjObject);
end;

procedure jNumberPickerDialog.Cancel();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_Cancel(FjEnv, FjObject);
end;

procedure jNumberPickerDialog.SetMinValue(_minValue: integer);
begin
  //in designing component state: set value here...
  FMinValue:= _minValue;
  if FInitialized then
     jNumberPicker_SetMinValue(FjEnv, FjObject, _minValue);
end;

procedure jNumberPickerDialog.SetMaxValue(_maxValue: integer);
begin
  //in designing component state: set value here...
  FMaxValue:= _maxValue;
  if FInitialized then
     jNumberPicker_SetMaxValue(FjEnv, FjObject, _maxValue);
end;

procedure jNumberPickerDialog.SetValue(_value: integer);
begin
  //in designing component state: set value here...
  FValue:= _value;
  if FInitialized then
     jNumberPicker_SetValue(FjEnv, FjObject, _value);
end;

procedure jNumberPickerDialog.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FTitle:= _title;
  if FInitialized then
     jNumberPicker_SetTitle(FjEnv, FjObject, _title);
end;

procedure jNumberPickerDialog.SetWrapSelectorWheel(_value: boolean);
begin
  //in designing component state: set value here...
  FWrapSelectorWheel:= _value;
  if FInitialized then
     jNumberPicker_SetWrapSelectorWheel(FjEnv, FjObject, _value);
end;

procedure jNumberPickerDialog.Show(_title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_Show(FjEnv, FjObject, _title);
end;

procedure jNumberPickerDialog.SetDisplayedValues(var _values: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_SetDisplayedValues(FjEnv, FjObject, _values);
end;

procedure jNumberPickerDialog.ClearDisplayedValues();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNumberPicker_ClearDisplayedValues(FjEnv, FjObject);
end;

procedure jNumberPickerDialog.GenEvent_OnNumberPicker(Obj: TObject; oldValue: integer; newValue: integer);
begin
   if Assigned(FOnNumberPicker) then FOnNumberPicker(Obj, oldValue, newValue);
end;

{-------- jNumberPicker_JNI_Bridge ----------}

function jNumberPicker_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jNumberPickerDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jNumberPickerDialog_jCreate(long _Self) {
  return (java.lang.Object)(new jNumberPickerDialog(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jNumberPicker_jFree(env: PJNIEnv; _jnumberpicker: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jnumberpicker, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_Show(env: PJNIEnv; _jnumberpicker: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jnumberpicker, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNumberPicker_Cancel(env: PJNIEnv; _jnumberpicker: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'Cancel', '()V');
  env^.CallVoidMethod(env, _jnumberpicker, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_SetMinValue(env: PJNIEnv; _jnumberpicker: JObject; _minValue: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _minValue;
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinValue', '(I)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_SetMaxValue(env: PJNIEnv; _jnumberpicker: JObject; _maxValue: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _maxValue;
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxValue', '(I)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_SetTitle(env: PJNIEnv; _jnumberpicker: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_SetWrapSelectorWheel(env: PJNIEnv; _jnumberpicker: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWrapSelectorWheel', '(Z)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNumberPicker_SetValue(env: PJNIEnv; _jnumberpicker: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetValue', '(I)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNumberPicker_Show(env: PJNIEnv; _jnumberpicker: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNumberPicker_SetDisplayedValues(env: PJNIEnv; _jnumberpicker: JObject; var _values: TDynArrayOfString);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_values);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_values[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDisplayedValues', '([Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnumberpicker, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNumberPicker_ClearDisplayedValues(env: PJNIEnv; _jnumberpicker: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnumberpicker);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearDisplayedValues', '()V');
  env^.CallVoidMethod(env, _jnumberpicker, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
