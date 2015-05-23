unit notificationmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

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

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Notify(_id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string); overload;
    procedure Notify(); overload;

    procedure Cancel(_id: integer);
    procedure CancelAll();

 published
    property Id: integer read FId write FId;
    property Title: string read FTitle write FTitle;
    property Subject: string read FSubject write FSubject;
    property Body: string read FBody write FBody;
    property IConIdentifier: string read FIConIdentifier write FIConIdentifier;
end;

function jNotificationManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jNotificationManager_jFree(env: PJNIEnv; _jnotificationmanager: JObject);
procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string);
procedure jNotificationManager_Cancel(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer);
procedure jNotificationManager_CancelAll(env: PJNIEnv; _jnotificationmanager: JObject);


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

procedure jNotificationManager.Notify(_id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_Notify(FjEnv, FjObject, _id ,_title ,_subject ,_body ,_iconIdentifier);
end;

procedure jNotificationManager.Notify();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNotificationManager_Notify(FjEnv, FjObject, FId , FTitle, FSubject, FBody, FIconIdentifier);
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


procedure jNotificationManager_Notify(env: PJNIEnv; _jnotificationmanager: JObject; _id: integer; _title: string; _subject: string; _body: string; _iconIdentifier: string);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_subject));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_body));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jnotificationmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Notify', '(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
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

end.
