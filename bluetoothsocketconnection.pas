unit bluetoothsocketconnection;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/15/2014 12:51:10]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jBluetoothSocketConnection = class(jControl)
 private

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetDevice(_device: jObject);
    procedure Connect();  overload;
    procedure Connect(_device: jObject);  overload;
    procedure Run();
    procedure Write(var _buffer: TDynArrayOfJByte);
    procedure Close();

 published

end;

function jBluetoothSocketConnection_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetoothSocketConnection_jFree(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
procedure jBluetoothSocketConnection_SetDevice(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; _device: jObject);
procedure jBluetoothSocketConnection_Connect(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);   overload;
procedure jBluetoothSocketConnection_Connect(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; _device: jObject); overload;
procedure jBluetoothSocketConnection_Run(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
procedure jBluetoothSocketConnection_Write(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; var _buffer: TDynArrayOfJByte);
procedure jBluetoothSocketConnection_Close(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);


implementation

{---------  jBluetoothSocketConnection  --------------}

constructor jBluetoothSocketConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jBluetoothSocketConnection.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jBluetoothSocketConnection.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jBluetoothSocketConnection.jCreate(): jObject;
begin
   Result:= jBluetoothSocketConnection_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jBluetoothSocketConnection.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothSocketConnection.SetDevice(_device: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_SetDevice(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _device);
end;

procedure jBluetoothSocketConnection.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_Connect(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothSocketConnection_SetDevice(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; _device: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _device;
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDevice', '(Landroid/bluetooth/BluetoothDevice;)V');
  env^.CallVoidMethodA(env, _jbluetoothsocketconnection, jMethod, @jParams);
end;

procedure jBluetoothSocketConnection_Connect(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  env^.CallVoidMethod(env, _jbluetoothsocketconnection, jMethod);
end;

procedure jBluetoothSocketConnection.Connect(_device: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_Connect(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _device);
end;

procedure jBluetoothSocketConnection.Run();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_Run(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothSocketConnection.Write(var _buffer: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_Write(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _buffer);
end;

procedure jBluetoothSocketConnection.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothSocketConnection_Close(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

{-------- jBluetoothSocketConnection_JNI_Bridge ----------}

function jBluetoothSocketConnection_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetoothSocketConnection_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBluetoothSocketConnection_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetoothSocketConnection(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jBluetoothSocketConnection_jFree(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetoothsocketconnection, jMethod);
end;


procedure jBluetoothSocketConnection_Connect(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; _device: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _device;
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Landroid/bluetooth/BluetoothDevice;)V');
  env^.CallVoidMethodA(env, _jbluetoothsocketconnection, jMethod, @jParams);
end;


procedure jBluetoothSocketConnection_Run(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Run', '()V');
  env^.CallVoidMethod(env, _jbluetoothsocketconnection, jMethod);
end;


procedure jBluetoothSocketConnection_Write(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject; var _buffer: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_buffer);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_buffer[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B)V');
  env^.CallVoidMethodA(env, _jbluetoothsocketconnection, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jBluetoothSocketConnection_Close(env: PJNIEnv; this: JObject; _jbluetoothsocketconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothsocketconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  env^.CallVoidMethod(env, _jbluetoothsocketconnection, jMethod);
end;

end.
