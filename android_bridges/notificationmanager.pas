unit notificationmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [2/3/2015 17:14:54]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jNotificationManager = class(jControl)
 private
    FId: integer;
    FTitle: string;
    FSubject: string;
    FBody: string;
    FIConIdentifier: string;   // ../res/drawable ex: 'ic_launcher'
    FLightsColor: TARGBColorBridge;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Notify(_id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string; _color: TARGBColorBridge); overload;
    procedure Notify(); overload;

    procedure Cancel(_id: integer);
    procedure CancelAll();
    procedure SetLightsColorAndTimes(_color: TARGBColorBridge; _onMills: integer; _offMills: integer);  //TFPColorBridgeArray
    procedure SetLightsColor(_lightsColor: TARGBColorBridge);
    procedure SetLightsEnable(_enable: boolean);

 published
    property Id: integer read FId write FId;
    property Title: string read FTitle write FTitle;
    property Subject: string read FSubject write FSubject;
    property Body: string read FBody write FBody;
    property IConIdentifier: string read FIConIdentifier write FIConIdentifier;
    property LightsColor: TARGBColorBridge read FLightsColor write SetLightsColor;
end;

function jNotificationManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jNotificationManager_jFree(env: PJNIEnv; _jnotificationmanager: JObject);
procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string; _color: DWord);
procedure jNotificationManager_Cancel(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
procedure jNotificationManager_CancelAll(env: PJNIEnv; _jnotificationmanager: JObject);

procedure jNotificationManager_SetLightsColorAndTime(env: PJNIEnv; _jnotificationmanager: JObject; _color: integer; _onMills: integer; _offMills: integer);
procedure jNotificationManager_SetLightsEnable(env: PJNIEnv; _jnotificationmanager: JObject; _enable: boolean);


implementation


{---------  jNotificationManager  --------------}

constructor jNotificationManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
 FId:= 1001;
 FTitle:= 'Lamw';
 FSubject:='Hello';
 FBody:= 'Lamw: Hello System Notification ...';
 FIConIdentifier:= 'ic_launcher';
 FLightsColor:= colbrDefault;
end;

destructor jNotificationManager.Destroy;
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

procedure jNotificationManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jNotificationManager.jCreate(): jObject;
begin
  Result:= jNotificationManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jNotificationManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_jFree(FjEnv, FjObject);
end;

procedure jNotificationManager.Notify(_id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string; _color: TARGBColorBridge);
var
  tempColor: TARGBColorBridge;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     tempColor:= _color;
     if  tempColor = colbrDefault then  tempColor:= colbrBlue;
     jNotificationManager_Notify(FjEnv, FjObject, _id ,_title ,_subject ,_body ,_iconIdentifier,  GetARGB(FCustomColor, tempColor) )
  end;
end;

procedure jNotificationManager.Notify();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     Notify(FId , FTitle, FSubject, FBody, FIconIdentifier, FLightsColor);
  end;
end;

procedure jNotificationManager.Cancel(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_Cancel(FjEnv, FjObject, _id);
end;

procedure jNotificationManager.CancelAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_CancelAll(FjEnv, FjObject);
end;

procedure jNotificationManager.SetLightsColorAndTimes(_color: TARGBColorBridge; _onMills: integer; _offMills: integer);
var
  tempColor: TARGBColorBridge;
begin
  //in designing component state: set value here...
   FLightsColor:= _color;
  if FInitialized then
  begin
    tempColor:= _color;
    if  tempColor = colbrDefault then  tempColor:= colbrBlue;
     jNotificationManager_SetLightsColorAndTime(FjEnv, FjObject, GetARGB(FCustomColor, tempColor) ,_onMills ,_offMills);
  end;
end;

procedure jNotificationManager.SetLightsColor(_lightsColor: TARGBColorBridge);
var
  tempColor: TARGBColorBridge;
begin
 //in designing component state: set value here...
 FLightsColor:= _lightsColor;
 if FInitialized then
 begin
   tempColor:= _lightsColor;
   if  tempColor = colbrDefault then  tempColor:= colbrBlue;
   jNotificationManager_SetLightsColorAndTime(FjEnv, FjObject, GetARGB(FCustomColor, tempColor), -1 , -1);
 end;
end;

procedure jNotificationManager.SetLightsEnable(_enable: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetLightsEnable(FjEnv, FjObject, _enable);
end;

{-------- jNotificationManager_JNI_Bridge ----------}

function jNotificationManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jNotificationManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jNotificationManager_jCreate(long _Self) {
      return (java.lang.Object)(new jNotificationManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jNotificationManager_jFree(env: PJNIEnv; _jnotificationmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jnotificationmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string; _color: DWord);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_subject));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_body));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jParams[5].i:= _color;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Notify', '(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNotificationManager_Cancel(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Cancel', '(I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNotificationManager_CancelAll(env: PJNIEnv; _jnotificationmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CancelAll', '()V');
  env^.CallVoidMethod(env, _jnotificationmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetLightsEnable(env: PJNIEnv; _jnotificationmanager: JObject; _enable: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_enable);
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLightsEnable', '(Z)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetLightsColorAndTime(env: PJNIEnv; _jnotificationmanager: JObject; _color: integer; _onMills: integer; _offMills: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jParams[1].i:= _onMills;
  jParams[2].i:= _offMills;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLightsColorAndTime', '(III)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
