unit datepickerdialog;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

 TOnDatePicker = procedure(Sender: TObject;year: integer; monthOfYear: integer; dayOfMonth: integer) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [2/3/2015 22:53:29]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jDatePickerDialog = class(jControl)
 private
    FOnDatePicker: TOnDatePicker;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Show(); overload;
    procedure Show(_year: integer; _monthOfYear: integer; _dayOfMonth: integer); overload;

    procedure GenEvent_OnDatePicker(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

 published
    property OnDatePicker: TOnDatePicker read FOnDatePicker write FOnDatePicker;
end;

function jDatePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

implementation

{---------  jDatePickerDialog  --------------}

constructor jDatePickerDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jDatePickerDialog.Destroy;
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

procedure jDatePickerDialog.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jDatePickerDialog.jCreate(): jObject;
begin
   Result:= jDatePickerDialog_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jDatePickerDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
end;

procedure jDatePickerDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'Show');
end;

procedure jDatePickerDialog.GenEvent_OnDatePicker(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  if Assigned(FOnDatePicker) then FOnDatePicker(Obj, year, monthOfYear, dayOfMonth);
end;

procedure jDatePickerDialog.Show(_year: integer; _monthOfYear: integer; _dayOfMonth: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iii(gApp.jni.jEnv, FjObject, 'Show', _year ,_monthOfYear ,_dayOfMonth);
end;

{-------- jDatePickerDialog_JNI_Bridge ----------}

function jDatePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDatePickerDialog_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jDatePickerDialog_jCreate(long _Self) {
      return (java.lang.Object)(new jDatePickerDialog(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

end.
