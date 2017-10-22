unit notificationmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TPendingFlag = (pfUpdateCurrent, pfCancelCurrent);

TNotificationPriority = (npDefault, npLow, npHigh, npMin, npMax);

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
    FAutoCancel: boolean;
    FOngoing: boolean;
    FPendingFlag: TPendingFlag;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure Cancel(_id: integer);
    procedure CancelAll();
    procedure SetLightsColorAndTimes(_color: TARGBColorBridge; _onMills: integer; _offMills: integer);  //TFPColorBridgeArray
    procedure SetLightsColor(_lightsColor: TARGBColorBridge);
    procedure SetLightsEnable(_enable: boolean);
    procedure SetOngoing(_value: boolean);
    procedure SetContentIntent(_intent: jObject);  overload;
    procedure SetContentIntent(_intent: jObject; _broadcastRequestCode: integer); overload;
    procedure SetContentIntent(_packageName: string; _activityClassName: string); overload;
    procedure SetContentIntent(_packageName: string; _activityClassName: string; dataName: string; dataValue: string); overload;
    procedure SetIconIdentifier(_iconIdentifier: string);
    procedure SetTitle(_title: string);
    procedure SetSubject(_subject: string);
    procedure SetBody(_body: string);
    procedure SetId(_id: integer);
    procedure Notify();
    procedure SetAutoCancel(_value: boolean);
    procedure SetPendingFlag(_flag: TPendingFlag);
    procedure SetPriority(_priority: TNotificationPriority);

 published
    property Id: integer read FId write SetId;
    property Title: string read FTitle write SetTitle;
    property Subject: string read FSubject write SetSubject;
    property Body: string read FBody write SetBody;
    property IconIdentifier: string read FIConIdentifier write SetIconIdentifier;
    property LightsColor: TARGBColorBridge read FLightsColor write SetLightsColor;
    property AutoCancel: boolean read FAutoCancel write SetAutoCancel;
    property Ongoing: boolean read FOngoing write SetOngoing;
    property PendingFlag: TPendingFlag read FPendingFlag write SetPendingFlag;
end;

function jNotificationManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jNotificationManager_jFree(env: PJNIEnv; _jnotificationmanager: JObject);
procedure jNotificationManager_Cancel(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
procedure jNotificationManager_CancelAll(env: PJNIEnv; _jnotificationmanager: JObject);
procedure jNotificationManager_SetLightsColorAndTime(env: PJNIEnv; _jnotificationmanager: JObject; _color: integer; _onMills: integer; _offMills: integer);
procedure jNotificationManager_SetLightsEnable(env: PJNIEnv; _jnotificationmanager: JObject; _enable: boolean);
procedure jNotificationManager_SetOngoing(env: PJNIEnv; _jnotificationmanager: JObject; _value: boolean);
procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _intent: jObject);overload;
procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _intent: jObject; _broadcastRequestCode: integer);overload;
procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _packageName: string; _activityClassName: string);overload;
procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _packageName: string; _activityClassName: string; dataName: string; dataValue: string);overload;
procedure jNotificationManager_SetIconIdentifier(env: PJNIEnv; _jnotificationmanager: JObject; _iconIdentifier: string);
procedure jNotificationManager_SetTitle(env: PJNIEnv; _jnotificationmanager: JObject; _title: string);
procedure jNotificationManager_SetSubject(env: PJNIEnv; _jnotificationmanager: JObject; _subject: string);
procedure jNotificationManager_SetBody(env: PJNIEnv; _jnotificationmanager: JObject; _body: string);
procedure jNotificationManager_SetId(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject);overload;
procedure jNotificationManager_SetAutoCancel(env: PJNIEnv; _jnotificationmanager: JObject; _value: boolean);
procedure jNotificationManager_SetPendingFlag(env: PJNIEnv; _jnotificationmanager: JObject; _flag: integer);
procedure jNotificationManager_SetPriority(env: PJNIEnv; _jnotificationmanager: JObject; _priority: integer);

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
 FAutoCancel:= True;
 FOngoing:= False;
 FPendingFlag:= pfUpdateCurrent;
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

  jNotificationManager_SetId(FjEnv, FjObject, FId);

  if FAutoCancel <> False then
     jNotificationManager_SetAutoCancel(FjEnv, FjObject, FAutoCancel);

  if FTitle <>  '' then
     jNotificationManager_SetTitle(FjEnv, FjObject,FTitle);

  if FSubject <>  '' then
     jNotificationManager_SetSubject(FjEnv, FjObject, FSubject);

  if FBody <>  '' then
     jNotificationManager_SetBody(FjEnv, FjObject, FBody);

  if FIconIdentifier <>  '' then
     jNotificationManager_SetIconIdentifier(FjEnv, FjObject, FIconIdentifier);

  if FLightsColor <>  colbrDefault then
    jNotificationManager_SetLightsColorAndTime(FjEnv, FjObject, GetARGB(FCustomColor, FLightsColor) ,-1 ,-1);

  if FOngoing <>  False then
     jNotificationManager_SetOngoing(FjEnv, FjObject, FOngoing);

  if FPendingFlag <>  pfUpdateCurrent then
     jNotificationManager_SetPendingFlag(FjEnv, FjObject, Ord(FPendingFlag));

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

procedure jNotificationManager.SetOngoing(_value: boolean);
begin
  //in designing component state: set value here...
  FOngoing:= _value;
  if FInitialized then
     jNotificationManager_SetOngoing(FjEnv, FjObject, _value);
end;

procedure jNotificationManager.SetContentIntent(_intent: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetContentIntent(FjEnv, FjObject, _intent);
end;

procedure jNotificationManager.SetContentIntent(_intent: jObject; _broadcastRequestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetContentIntent(FjEnv, FjObject, _intent ,_broadcastRequestCode);
end;

procedure jNotificationManager.SetContentIntent(_packageName: string; _activityClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetContentIntent(FjEnv, FjObject, _packageName ,_activityClassName);
end;

procedure jNotificationManager.SetContentIntent(_packageName: string; _activityClassName: string; dataName: string; dataValue: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetContentIntent(FjEnv, FjObject, _packageName ,_activityClassName ,dataName ,dataValue);
end;

procedure jNotificationManager.SetIconIdentifier(_iconIdentifier: string);
begin
  //in designing component state: set value here...
  FIconIdentifier:= _iconIdentifier;
  if FInitialized then
     jNotificationManager_SetIconIdentifier(FjEnv, FjObject, _iconIdentifier);
end;

procedure jNotificationManager.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FTitle:= _title;
  if FInitialized then
     jNotificationManager_SetTitle(FjEnv, FjObject, _title);
end;

procedure jNotificationManager.SetSubject(_subject: string);
begin
  //in designing component state: set value here...
  FSubject:= _subject;
  if FInitialized then
     jNotificationManager_SetSubject(FjEnv, FjObject, _subject);
end;

procedure jNotificationManager.SetBody(_body: string);
begin
  //in designing component state: set value here...
  FBody:= _body;
  if FInitialized then
     jNotificationManager_SetBody(FjEnv, FjObject, _body);
end;

procedure jNotificationManager.SetId(_id: integer);
begin
  //in designing component state: set value here...
  FId:= _id;
  if FInitialized then
     jNotificationManager_SetId(FjEnv, FjObject, _id);
end;

procedure jNotificationManager.Notify();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_Notify(FjEnv, FjObject);
end;

procedure jNotificationManager.SetAutoCancel(_value: boolean);
begin
  //in designing component state: set value here...
  FAutoCancel:= _value;
  if FInitialized then
     jNotificationManager_SetAutoCancel(FjEnv, FjObject, _value);
end;

procedure jNotificationManager.SetPendingFlag(_flag: TPendingFlag);
begin
  //in designing component state: set value here...
  FPendingFlag:= _flag;
  if FInitialized then
     jNotificationManager_SetPendingFlag(FjEnv, FjObject, Ord(_flag));
end;

procedure jNotificationManager.SetPriority(_priority: TNotificationPriority);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_SetPriority(FjEnv, FjObject, Ord(_priority) );
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

procedure jNotificationManager_SetOngoing(env: PJNIEnv; _jnotificationmanager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOngoing', '(Z)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _intent: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentIntent', '(Landroid/content/Intent;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _intent: jObject; _broadcastRequestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].i:= _broadcastRequestCode;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentIntent', '(Landroid/content/Intent;I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _packageName: string; _activityClassName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_activityClassName));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentIntent', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetContentIntent(env: PJNIEnv; _jnotificationmanager: JObject; _packageName: string; _activityClassName: string; dataName: string; dataValue: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_activityClassName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(dataName));
  jParams[3].l:= env^.NewStringUTF(env, PChar(dataValue));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentIntent', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetIconIdentifier(env: PJNIEnv; _jnotificationmanager: JObject; _iconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNotificationManager_SetTitle(env: PJNIEnv; _jnotificationmanager: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetSubject(env: PJNIEnv; _jnotificationmanager: JObject; _subject: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_subject));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubject', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetBody(env: PJNIEnv; _jnotificationmanager: JObject; _body: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_body));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBody', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNotificationManager_SetId(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Notify', '()V');
  env^.CallVoidMethod(env, _jnotificationmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetAutoCancel(env: PJNIEnv; _jnotificationmanager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAutoCancel', '(Z)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetPendingFlag(env: PJNIEnv; _jnotificationmanager: JObject; _flag: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _flag;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPendingFlag', '(I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jNotificationManager_SetPriority(env: PJNIEnv; _jnotificationmanager: JObject; _priority: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _priority;
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPriority', '(I)V');
  env^.CallVoidMethodA(env, _jnotificationmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
