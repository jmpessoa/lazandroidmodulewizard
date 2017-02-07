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
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Show(); overload;
    procedure Show(_year: integer; _monthOfYear: integer; _dayOfMonth: integer); overload;

    procedure GenEvent_OnDatePicker(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

 published
    property OnDatePicker: TOnDatePicker read FOnDatePicker write FOnDatePicker;
end;

function jDatePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jDatePickerDialog_jFree(env: PJNIEnv; _jdatepickerdialog: JObject);
procedure jDatePickerDialog_Show(env: PJNIEnv; _jdatepickerdialog: JObject); overload;
procedure jDatePickerDialog_Show(env: PJNIEnv; _jdatepickerdialog: JObject; _year: integer; _monthOfYear: integer; _dayOfMonth: integer); overload;

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

procedure jDatePickerDialog.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jDatePickerDialog.jCreate(): jObject;
begin
   Result:= jDatePickerDialog_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jDatePickerDialog.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDatePickerDialog_jFree(FjEnv, FjObject);
end;

procedure jDatePickerDialog.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDatePickerDialog_Show(FjEnv, FjObject);
end;

procedure jDatePickerDialog.GenEvent_OnDatePicker(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  if Assigned(FOnDatePicker) then FOnDatePicker(Obj, year, monthOfYear, dayOfMonth);
end;

procedure jDatePickerDialog.Show(_year: integer; _monthOfYear: integer; _dayOfMonth: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDatePickerDialog_Show(FjEnv, FjObject, _year ,_monthOfYear ,_dayOfMonth);
end;

{-------- jDatePickerDialog_JNI_Bridge ----------}

function jDatePickerDialog_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
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


procedure jDatePickerDialog_jFree(env: PJNIEnv; _jdatepickerdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdatepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdatepickerdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDatePickerDialog_Show(env: PJNIEnv; _jdatepickerdialog: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdatepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jdatepickerdialog, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDatePickerDialog_Show(env: PJNIEnv; _jdatepickerdialog: JObject; _year: integer; _monthOfYear: integer; _dayOfMonth: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _year;
  jParams[1].i:= _monthOfYear;
  jParams[2].i:= _dayOfMonth;
  jCls:= env^.GetObjectClass(env, _jdatepickerdialog);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(III)V');
  env^.CallVoidMethodA(env, _jdatepickerdialog, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
