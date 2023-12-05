unit modbus;
 
{$mode delphi}
 
interface
 
uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;
 
type
 
{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/9/2021 0:22:46]}
{https://github.com/jmpessoa/lazandroidmodulewizard}
 
TOnModbusConnect=procedure(Sender:TObject;success:boolean;msg:string) of object;
 
{jControl template}
 
jModbus = class(jControl)
 private
     FOnConnect: TOnModbusConnect;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
 
    function msg_: string;
 
    procedure Connect(_hostIP: string; _portNumber: integer);
    function IsConnected(): boolean;
    procedure ReadCoil(_slaveId: integer; _start: integer; _len: integer);
    procedure ReadDiscreteInput(_slaveId: integer; _start: integer; _len: integer);
    procedure ReadHoldingRegisters(_slaveId: integer; _start: integer; _len: integer);
    procedure ReadInputRegisters(_slaveId: integer; _start: integer; _len: integer);
    procedure WriteCoil(_slaveId: integer; _offset: integer; _value: boolean);
    procedure WriteRegister(_slaveId: integer; _offset: integer; _value: integer);
    procedure WriteRegisters(_slaveId: integer; _start: integer; var _shortArrayValues: TDynArrayOfSmallint);
 
    procedure GenEvent_OnModbusConnect(Sender:TObject;success:boolean;msg:string);
 
 published
    property OnConnect: TOnModbusConnect read FOnConnect write FOnConnect;
end;
 
function jModbus_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jModbus_jFree(env: PJNIEnv; _jmodbus: JObject);
function jModbus_msg_(env: PJNIEnv; _jmodbus: JObject): string;
 
procedure jModbus_Connect(env: PJNIEnv; _jmodbus: JObject; _hostIP: string; _portNumber: integer);
function jModbus_IsConnected(env: PJNIEnv; _jmodbus: JObject): boolean;
procedure jModbus_ReadCoil(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
procedure jModbus_ReadDiscreteInput(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
procedure jModbus_ReadHoldingRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
procedure jModbus_ReadInputRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
procedure jModbus_WriteCoil(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _offset: integer; _value: boolean);
procedure jModbus_WriteRegister(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _offset: integer; _value: integer);
procedure jModbus_WriteRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; var _shortArrayValues: TDynArrayOfSmallint);
 
implementation
 
{---------  jModbus  --------------}
 
constructor jModbus.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;
 
destructor jModbus.Destroy;
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
 
procedure jModbus.Init;
begin
 
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !
 
  if FjObject = nil then exit;
 
  FInitialized:= True;
end;
 
 
function jModbus.jCreate(): jObject;
begin
   Result:= jModbus_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;
 
procedure jModbus.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_jFree(gApp.jni.jEnv, FjObject);
end;
 
procedure jModbus.Connect(_hostIP: string; _portNumber: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_Connect(gApp.jni.jEnv, FjObject, _hostIP ,_portNumber);
end;
 
function jModbus.msg_(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jModbus_msg_(gApp.jni.jEnv, FjObject);
end;
 
function jModbus.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jModbus_IsConnected(gApp.jni.jEnv, FjObject);
end;
 
procedure jModbus.ReadCoil(_slaveId: integer; _start: integer; _len: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_ReadCoil(gApp.jni.jEnv, FjObject, _slaveId ,_start ,_len);
end;
 
procedure jModbus.ReadDiscreteInput(_slaveId: integer; _start: integer; _len: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_ReadDiscreteInput(gApp.jni.jEnv, FjObject, _slaveId ,_start ,_len);
end;
 
procedure jModbus.ReadHoldingRegisters(_slaveId: integer; _start: integer; _len: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_ReadHoldingRegisters(gApp.jni.jEnv, FjObject, _slaveId ,_start ,_len);
end;
 
procedure jModbus.ReadInputRegisters(_slaveId: integer; _start: integer; _len: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_ReadInputRegisters(gApp.jni.jEnv, FjObject, _slaveId ,_start ,_len);
end;
 
procedure jModbus.WriteCoil(_slaveId: integer; _offset: integer; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_WriteCoil(gApp.jni.jEnv, FjObject, _slaveId ,_offset ,_value);
end;
 
procedure jModbus.WriteRegister(_slaveId: integer; _offset: integer; _value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_WriteRegister(gApp.jni.jEnv, FjObject, _slaveId ,_offset ,_value);
end;
 
procedure jModbus.WriteRegisters(_slaveId: integer; _start: integer; var _shortArrayValues: TDynArrayOfSmallint);
begin
  //in designing component state: set value here...
  if FInitialized then
     jModbus_WriteRegisters(gApp.jni.jEnv, FjObject, _slaveId ,_start ,_shortArrayValues);
end;
 
procedure jModbus.GenEvent_OnModbusConnect(Sender:TObject;success:boolean;msg:string);
begin
  if Assigned(FOnConnect) then FOnConnect(Sender,success,msg);
end;
 
{-------- jModbus_JNI_Bridge ----------}
 
function jModbus_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  Result := nil;
 
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jModbus_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].j:= _Self;
 
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
 
  Result:= env^.NewGlobalRef(env, Result);
 
  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;
 
 
procedure jModbus_jFree(env: PJNIEnv; _jmodbus: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;
 
  env^.CallVoidMethod(env, _jmodbus, jMethod);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
procedure jModbus_ReadCoil(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ReadCoil', '(III)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _start;
  jParams[2].i:= _len;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_ReadDiscreteInput(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ReadDiscreteInput', '(III)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _start;
  jParams[2].i:= _len;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_ReadHoldingRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ReadHoldingRegisters', '(III)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _start;
  jParams[2].i:= _len;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_ReadInputRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; _len: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ReadInputRegisters', '(III)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _start;
  jParams[2].i:= _len;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_WriteCoil(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _offset: integer; _value: boolean);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'WriteCoil', '(IIZ)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _offset;
  jParams[2].z:= JBool(_value);
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_WriteRegister(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _offset: integer; _value: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'WriteRegister', '(III)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _offset;
  jParams[2].i:= _value;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
procedure jModbus_WriteRegisters(env: PJNIEnv; _jmodbus: JObject; _slaveId: integer; _start: integer; var _shortArrayValues: TDynArrayOfSmallint);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'WriteRegisters', '(II[S)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].i:= _slaveId;
  jParams[1].i:= _start;
  newSize0:= Length(_shortArrayValues);
  jNewArray0:= env^.NewShortArray(env, newSize0);  // allocate
  env^.SetShortArrayRegion(env, jNewArray0, 0 , newSize0, @_shortArrayValues[0] {source});
  jParams[2].l:= jNewArray0;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
procedure jModbus_Connect(env: PJNIEnv; _jmodbus: JObject; _hostIP: string; _portNumber: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;I)V');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hostIP));
  jParams[1].i:= _portNumber;
 
  env^.CallVoidMethodA(env, _jmodbus, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
function jModbus_msg_(env: PJNIEnv; _jmodbus: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jmodbus = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'msg_', '()Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jStr:= env^.CallObjectMethod(env, _jmodbus, jMethod);
 
  Result := GetPStringAndDeleteLocalRef(env, jStr);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
function jModbus_IsConnected(env: PJNIEnv; _jmodbus: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  jCls:= env^.GetObjectClass(env, _jmodbus);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  if jMethod = nil then goto _exceptionOcurred;
 
  jBoo:= env^.CallBooleanMethod(env, _jmodbus, jMethod);
 
  Result:= boolean(jBoo);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
end.
 