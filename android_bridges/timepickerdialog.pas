unit timepickerdialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnTimePicker = procedure(Sender: TObject; hourOfDay: integer; minute: integer) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [2/3/2015 22:51:56]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTimePickerDialog = class(jControl)
 private
    FOnTimePicker: TOnTimePicker;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Show(); overload;
    procedure Show(_hourOfDay24Based: integer; _minute: integer); overload;

    procedure GenEvent_OnTimePicker(Obj: TObject; hourOfDay: integer; minute: integer);

 published
    property OnTimePicker: TOnTimePicker read FOnTimePicker write FOnTimePicker;
end;

function jTimePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTimePickerDialog_jFree(env: PJNIEnv; _jtimepickerdialog: JObject);
procedure jTimePickerDialog_Show(env: PJNIEnv; _jtimepickerdialog: JObject); overload;
procedure jTimePickerDialog_Show(env: PJNIEnv; _jtimepickerdialog: JObject; _hourOfDay24Based: integer; _minute: integer); overload;


implementation

{---------  jTimePickerDialog  --------------}

constructor jTimePickerDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jTimePickerDialog.Destroy;
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

procedure jTimePickerDialog.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jTimePickerDialog.jCreate(): jObject;
begin
   Result:= jTimePickerDialog_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTimePickerDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTimePickerDialog_jFree(FjEnv, FjObject);
end;

procedure jTimePickerDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTimePickerDialog_Show(FjEnv, FjObject);
end;

procedure jTimePickerDialog.GenEvent_OnTimePicker(Obj: TObject;  hourOfDay: integer; minute: integer);
begin
  if Assigned(FOnTimePicker) then FOnTimePicker(Obj, hourOfDay, minute);
end;

procedure jTimePickerDialog.Show(_hourOfDay24Based: integer; _minute: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTimePickerDialog_Show(FjEnv, FjObject, _hourOfDay24Based ,_minute);
end;

{-------- jTimePickerDialog_JNI_Bridge ----------}

function jTimePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTimePickerDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jTimePickerDialog_jCreate(long _Self) {
      return (java.lang.Object)(new jTimePickerDialog(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jTimePickerDialog_jFree(env: PJNIEnv; _jtimepickerdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtimepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtimepickerdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTimePickerDialog_Show(env: PJNIEnv; _jtimepickerdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtimepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jtimepickerdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTimePickerDialog_Show(env: PJNIEnv; _jtimepickerdialog: JObject; _hourOfDay24Based: integer; _minute: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _hourOfDay24Based;
  jParams[1].i:= _minute;
  jCls:= env^.GetObjectClass(env, _jtimepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(II)V');
  env^.CallVoidMethodA(env, _jtimepickerdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
