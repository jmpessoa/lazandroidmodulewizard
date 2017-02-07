unit udpsocket;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnReceived = procedure(Sender: TObject; content: string;
                       remoteIP: string; remotePort: integer; out listening: boolean) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [9/24/2016 22:25:03]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jUDPSocket = class(jControl)
 private
    FOnReceived: TOnReceived;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Send(_ip: string; _port: integer; _message: string);
    procedure Listen(_port: integer; _bufferLen: integer);
    procedure StopListening();
    procedure SetTimeout(_miliTimeout: integer);

    procedure GenEvent_OnUDPSocketReceived(Obj: TObject; content: string;
                          fromIP: string; fromPort: integer; out listening: boolean);
 published
    property OnReceived: TOnReceived read FOnReceived write FOnReceived;

end;

function jUDPSocket_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jUDPSocket_jFree(env: PJNIEnv; _judpsocket: JObject);
procedure jUDPSocket_Send(env: PJNIEnv; _judpsocket: JObject; _ip: string; _port: integer; _message: string);
procedure jUDPSocket_AsyncListen(env: PJNIEnv; _judpsocket: JObject; _port: integer; _bufferLen: integer);
procedure jUDPSocket_AsyncListenStop(env: PJNIEnv; _judpsocket: JObject);
procedure jUDPSocket_SetTimeout(env: PJNIEnv; _judpsocket: JObject; _miliTimeout: integer);

implementation


{---------  jUDPSocket  --------------}

constructor jUDPSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jUDPSocket.Destroy;
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

procedure jUDPSocket.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jUDPSocket.jCreate(): jObject;
begin
   Result:= jUDPSocket_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jUDPSocket.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUDPSocket_jFree(FjEnv, FjObject);
end;

procedure jUDPSocket.Send(_ip: string; _port: integer; _message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUDPSocket_Send(FjEnv, FjObject, _ip ,_port ,_message);
end;

procedure jUDPSocket.Listen(_port: integer; _bufferLen: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUDPSocket_AsyncListen(FjEnv, FjObject, _port ,_bufferLen);
end;

procedure jUDPSocket.StopListening();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUDPSocket_AsyncListenStop(FjEnv, FjObject);
end;

procedure jUDPSocket.SetTimeout(_miliTimeout: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUDPSocket_SetTimeout(FjEnv, FjObject, _miliTimeout);
end;

procedure jUDPSocket.GenEvent_OnUDPSocketReceived(Obj: TObject; content: string;
                       fromIP: string; fromPort: integer; out listening: boolean);
begin
  if assigned(FOnReceived) then FOnReceived(Obj, content, fromIP, fromPort, listening);
end;

{-------- jUDPSocket_JNI_Bridge ----------}

function jUDPSocket_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jUDPSocket_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jUDPSocket_jCreate(long _Self) {
  return (java.lang.Object)(new jUDPSocket(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jUDPSocket_jFree(env: PJNIEnv; _judpsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _judpsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _judpsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUDPSocket_Send(env: PJNIEnv; _judpsocket: JObject; _ip: string; _port: integer; _message: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_ip));
  jParams[1].i:= _port;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _judpsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _judpsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUDPSocket_AsyncListen(env: PJNIEnv; _judpsocket: JObject; _port: integer; _bufferLen: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _port;
  jParams[1].i:= _bufferLen;
  jCls:= env^.GetObjectClass(env, _judpsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'AsyncListen', '(II)V');
  env^.CallVoidMethodA(env, _judpsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUDPSocket_AsyncListenStop(env: PJNIEnv; _judpsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _judpsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'StopAsyncListen', '()V');
  env^.CallVoidMethod(env, _judpsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUDPSocket_SetTimeout(env: PJNIEnv; _judpsocket: JObject; _miliTimeout: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _miliTimeout;
  jCls:= env^.GetObjectClass(env, _judpsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTimeout', '(I)V');
  env^.CallVoidMethodA(env, _judpsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
