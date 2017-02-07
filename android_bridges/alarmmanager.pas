unit alarmmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/21/2016 22:06:33]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jAlarmManager = class(jControl)
 private
   //
    {FYear: integer;
    FMonthOfYear: integer;
    FDayOfMonth: integer;
    FHourOfDay: integer;
    FMinute: integer;
    FIntentAction: string;
    FPendingIntentId: integer;
    FRepeatInterval: integer; // minutes}
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetYearMonthDay(_year: integer; _month: integer; _day: integer);
    procedure SetHourMinute(_hour: integer; _minute: integer);
    procedure SetRepeatInterval(_RepeatIntervalMinute: integer);
    procedure SetIntentExtraString(_extraName: string; _extraValue: string);

    procedure Clear();
    function Exists(_id: integer; _intentAction: string): boolean;
    function Stop(_id: integer): integer; overload;
    function Stop(): integer;  overload;
    function Start(_intentAction: string): integer;
    function Count(): integer;


 published
    //
end;

function jAlarmManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jAlarmManager_jFree(env: PJNIEnv; _jalarmmanager: JObject);

procedure jAlarmManager_SetYearMonthDay(env: PJNIEnv; _jalarmmanager: JObject; _year: integer; _month: integer; _day: integer);
procedure jAlarmManager_SetHourMinute(env: PJNIEnv; _jalarmmanager: JObject; _hour: integer; _minute: integer);
procedure jAlarmManager_SetRepeatInterval(env: PJNIEnv; _jalarmmanager: JObject; _RepeatIntervalMinute: integer);

procedure jAlarmManager_SetIntentExtraString(env: PJNIEnv; _jalarmmanager: JObject; _extraName: string; _extraValue: string);

procedure jAlarmManager_Clear(env: PJNIEnv; _jalarmmanager: JObject);
function jAlarmManager_Exists(env: PJNIEnv; _jalarmmanager: JObject; _id: integer; _intentAction: string): boolean;
function jAlarmManager_Stop(env: PJNIEnv; _jalarmmanager: JObject; _id: integer): integer;overload;
function jAlarmManager_Stop(env: PJNIEnv; _jalarmmanager: JObject): integer; overload;
function jAlarmManager_Start(env: PJNIEnv; _jalarmmanager: JObject; _intentAction: string): integer;
function jAlarmManager_Count(env: PJNIEnv; _jalarmmanager: JObject): integer;

implementation

{---------  jAlarmManager  --------------}

constructor jAlarmManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jAlarmManager.Destroy;
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

procedure jAlarmManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jAlarmManager.jCreate(): jObject;
begin
   Result:= jAlarmManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jAlarmManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_jFree(FjEnv, FjObject);
end;


procedure jAlarmManager.SetYearMonthDay(_year: integer; _month: integer; _day: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_SetYearMonthDay(FjEnv, FjObject, _year ,_month ,_day);
end;

procedure jAlarmManager.SetHourMinute(_hour: integer; _minute: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_SetHourMinute(FjEnv, FjObject, _hour ,_minute);
end;

procedure jAlarmManager.SetRepeatInterval(_RepeatIntervalMinute: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_SetRepeatInterval(FjEnv, FjObject, _RepeatIntervalMinute);
end;

procedure jAlarmManager.SetIntentExtraString(_extraName: string; _extraValue: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_SetIntentExtraString(FjEnv, FjObject, _extraName ,_extraValue);
end;

procedure jAlarmManager.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAlarmManager_Clear(FjEnv, FjObject);
end;

function jAlarmManager.Exists(_id: integer; _intentAction: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAlarmManager_Exists(FjEnv, FjObject, _id ,_intentAction);
end;

function jAlarmManager.Stop(_id: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAlarmManager_Stop(FjEnv, FjObject, _id);
end;

function jAlarmManager.Stop(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAlarmManager_Stop(FjEnv, FjObject);
end;

function jAlarmManager.Start(_intentAction: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAlarmManager_Start(FjEnv, FjObject, _intentAction);
end;

function jAlarmManager.Count(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAlarmManager_Count(FjEnv, FjObject);
end;

{-------- jAlarmManager_JNI_Bridge ----------}

function jAlarmManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jAlarmManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jAlarmManager_jCreate(long _Self) {
      return (java.lang.Object)(new jAlarmManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jAlarmManager_jFree(env: PJNIEnv; _jalarmmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jalarmmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAlarmManager_SetYearMonthDay(env: PJNIEnv; _jalarmmanager: JObject; _year: integer; _month: integer; _day: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _year;
  jParams[1].i:= _month;
  jParams[2].i:= _day;
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetYearMonthDay', '(III)V');
  env^.CallVoidMethodA(env, _jalarmmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAlarmManager_SetHourMinute(env: PJNIEnv; _jalarmmanager: JObject; _hour: integer; _minute: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _hour;
  jParams[1].i:= _minute;
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHourMinute', '(II)V');
  env^.CallVoidMethodA(env, _jalarmmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAlarmManager_SetRepeatInterval(env: PJNIEnv; _jalarmmanager: JObject; _RepeatIntervalMinute: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _RepeatIntervalMinute;
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRepeatInterval', '(I)V');
  env^.CallVoidMethodA(env, _jalarmmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAlarmManager_SetIntentExtraString(env: PJNIEnv; _jalarmmanager: JObject; _extraName: string; _extraValue: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_extraName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_extraValue));
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIntentExtraString', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jalarmmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAlarmManager_Clear(env: PJNIEnv; _jalarmmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jalarmmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jAlarmManager_Exists(env: PJNIEnv; _jalarmmanager: JObject; _id: integer; _intentAction: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Exists', '(ILjava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jalarmmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jAlarmManager_Stop(env: PJNIEnv; _jalarmmanager: JObject; _id: integer): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '(I)I');
  Result:= env^.CallIntMethodA(env, _jalarmmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jAlarmManager_Stop(env: PJNIEnv; _jalarmmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()I');
  Result:= env^.CallIntMethod(env, _jalarmmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jAlarmManager_Start(env: PJNIEnv; _jalarmmanager: JObject; _intentAction: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jalarmmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jAlarmManager_Count(env: PJNIEnv; _jalarmmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jalarmmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Count', '()I');
  Result:= env^.CallIntMethod(env, _jalarmmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
