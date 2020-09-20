unit netapi;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/19/2020 15:29:30]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jNetApi = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function OpenDevice(ip: string; iPort: integer): boolean;
    procedure CloseDevice();
    function GetDeviceSystemInfo(bDevAdr: byte; var pucSystemInfo: TDynArrayOfJByte): boolean;
    function ReadDeviceOneParam(bDevAdr: byte; pucDevParamAddr: byte; var pValue: TDynArrayOfJByte): boolean;
    function SetDeviceOneParam(bDevAdr: byte; pucDevParamAddr: byte; pValue: byte): boolean;
    function StopRead(bDevAdr: byte): boolean;
    function StartRead(bDevAdr: byte): boolean;
    function InventoryG2(bDevAdr: byte; var pBuffer: TDynArrayOfJByte; var Totallen: TDynArrayOfInteger; var CardNum: TDynArrayOfInteger): boolean;
    function WriteEPCG2(bDevAdr: byte; var Password: TDynArrayOfJByte; var WriteEPC: TDynArrayOfJByte; WriteEPClen: byte): boolean;
    function ReadCardG2(bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; ReadEPClen: byte; var Data: TDynArrayOfJByte): boolean;
    function WriteCardG2(bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; Writelen: byte; var Writedata: TDynArrayOfJByte): boolean;
    function RelayOn(bDevAdr: byte): boolean;
    function RelayOff(bDevAdr: byte): boolean;
    function ClearTagBuf(): boolean;
    function GetTagBuf(var pBuf: TDynArrayOfJByte; var pLength: TDynArrayOfInteger; var pTagNumber: TDynArrayOfInteger): byte;
    function SetFreq(bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
    function ReadFreq(bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;

 published

end;

function jNetApi_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jNetApi_jFree(env: PJNIEnv; _jnetapi: JObject);

function jNetApi_OpenDevice(env: PJNIEnv; _jnetapi: JObject; ip: string; iPort: integer): boolean;
procedure jNetApi_CloseDevice(env: PJNIEnv; _jnetapi: JObject);
function jNetApi_GetDeviceSystemInfo(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pucSystemInfo: TDynArrayOfJByte): boolean;
function jNetApi_ReadDeviceOneParam(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; pucDevParamAddr: byte; var pValue: TDynArrayOfJByte): boolean;
function jNetApi_SetDeviceOneParam(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; pucDevParamAddr: byte; pValue: byte): boolean;
function jNetApi_StopRead(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
function jNetApi_StartRead(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
function jNetApi_InventoryG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pBuffer: TDynArrayOfJByte; var Totallen: TDynArrayOfInteger; var CardNum: TDynArrayOfInteger): boolean;
function jNetApi_WriteEPCG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; var WriteEPC: TDynArrayOfJByte; WriteEPClen: byte): boolean;
function jNetApi_ReadCardG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; ReadEPClen: byte; var Data: TDynArrayOfJByte): boolean;
function jNetApi_WriteCardG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; Writelen: byte; var Writedata: TDynArrayOfJByte): boolean;
function jNetApi_RelayOn(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
function jNetApi_RelayOff(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
function jNetApi_ClearTagBuf(env: PJNIEnv; _jnetapi: JObject): boolean;
function jNetApi_GetTagBuf(env: PJNIEnv; _jnetapi: JObject; var pBuf: TDynArrayOfJByte; var pLength: TDynArrayOfInteger; var pTagNumber: TDynArrayOfInteger): byte;
function jNetApi_SetFreq(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
function jNetApi_ReadFreq(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;


implementation

{---------  jNetApi  --------------}

constructor jNetApi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jNetApi.Destroy;
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

procedure jNetApi.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jNetApi.jCreate(): jObject;
begin
   Result:= jNetApi_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jNetApi.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNetApi_jFree(FjEnv, FjObject);
end;

function jNetApi.OpenDevice(ip: string; iPort: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_OpenDevice(FjEnv, FjObject, ip ,iPort);
end;

procedure jNetApi.CloseDevice();
begin
  //in designing component state: set value here...
  if FInitialized then
     jNetApi_CloseDevice(FjEnv, FjObject);
end;

function jNetApi.GetDeviceSystemInfo(bDevAdr: byte; var pucSystemInfo: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_GetDeviceSystemInfo(FjEnv, FjObject, bDevAdr ,pucSystemInfo);
end;

function jNetApi.ReadDeviceOneParam(bDevAdr: byte; pucDevParamAddr: byte; var pValue: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_ReadDeviceOneParam(FjEnv, FjObject, bDevAdr ,pucDevParamAddr ,pValue);
end;

function jNetApi.SetDeviceOneParam(bDevAdr: byte; pucDevParamAddr: byte; pValue: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_SetDeviceOneParam(FjEnv, FjObject, bDevAdr ,pucDevParamAddr ,pValue);
end;

function jNetApi.StopRead(bDevAdr: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_StopRead(FjEnv, FjObject, bDevAdr);
end;

function jNetApi.StartRead(bDevAdr: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_StartRead(FjEnv, FjObject, bDevAdr);
end;

function jNetApi.InventoryG2(bDevAdr: byte; var pBuffer: TDynArrayOfJByte; var Totallen: TDynArrayOfInteger; var CardNum: TDynArrayOfInteger): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_InventoryG2(FjEnv, FjObject, bDevAdr ,pBuffer ,Totallen ,CardNum);
end;

function jNetApi.WriteEPCG2(bDevAdr: byte; var Password: TDynArrayOfJByte; var WriteEPC: TDynArrayOfJByte; WriteEPClen: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_WriteEPCG2(FjEnv, FjObject, bDevAdr ,Password ,WriteEPC ,WriteEPClen);
end;

function jNetApi.ReadCardG2(bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; ReadEPClen: byte; var Data: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_ReadCardG2(FjEnv, FjObject, bDevAdr ,Password ,Mem ,WordPtr ,ReadEPClen ,Data);
end;

function jNetApi.WriteCardG2(bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; Writelen: byte; var Writedata: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_WriteCardG2(FjEnv, FjObject, bDevAdr ,Password ,Mem ,WordPtr ,Writelen ,Writedata);
end;

function jNetApi.RelayOn(bDevAdr: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_RelayOn(FjEnv, FjObject, bDevAdr);
end;

function jNetApi.RelayOff(bDevAdr: byte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_RelayOff(FjEnv, FjObject, bDevAdr);
end;

function jNetApi.ClearTagBuf(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_ClearTagBuf(FjEnv, FjObject);
end;

function jNetApi.GetTagBuf(var pBuf: TDynArrayOfJByte; var pLength: TDynArrayOfInteger; var pTagNumber: TDynArrayOfInteger): byte;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_GetTagBuf(FjEnv, FjObject, pBuf ,pLength ,pTagNumber);
end;

function jNetApi.SetFreq(bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_SetFreq(FjEnv, FjObject, bDevAdr ,pFreq);
end;

function jNetApi.ReadFreq(bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jNetApi_ReadFreq(FjEnv, FjObject, bDevAdr ,pFreq);
end;

{-------- jNetApi_JNI_Bridge ----------}

function jNetApi_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jNetApi_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jNetApi_jFree(env: PJNIEnv; _jnetapi: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jnetapi, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jNetApi_OpenDevice(env: PJNIEnv; _jnetapi: JObject; ip: string; iPort: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(ip));
  jParams[1].i:= iPort;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'OpenDevice', '(Ljava/lang/String;I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jNetApi_CloseDevice(env: PJNIEnv; _jnetapi: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseDevice', '()V');
  env^.CallVoidMethod(env, _jnetapi, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_GetDeviceSystemInfo(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pucSystemInfo: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(pucSystemInfo);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pucSystemInfo[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceSystemInfo', '(B[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_ReadDeviceOneParam(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; pucDevParamAddr: byte; var pValue: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  jParams[1].b:= pucDevParamAddr;
  newSize0:= Length(pValue);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pValue[0] {source});
  jParams[2].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'ReadDeviceOneParam', '(BB[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_SetDeviceOneParam(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; pucDevParamAddr: byte; pValue: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= bDevAdr;
  jParams[1].b:= pucDevParamAddr;
  jParams[2].b:= pValue;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDeviceOneParam', '(BBB)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_StopRead(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= bDevAdr;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'StopRead', '(B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_StartRead(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= bDevAdr;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'StartRead', '(B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_InventoryG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pBuffer: TDynArrayOfJByte; var Totallen: TDynArrayOfInteger; var CardNum: TDynArrayOfInteger): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
  newSize2: integer;
  jNewArray2: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(pBuffer);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pBuffer[0] {source});
  jParams[1].l:= jNewArray0;
  newSize1:= Length(Totallen);
  jNewArray1:= env^.NewIntArray(env, newSize1);  // allocate
  env^.SetIntArrayRegion(env, jNewArray1, 0 , newSize1, @Totallen[0] {source});
  jParams[2].l:= jNewArray1;
  newSize2:= Length(CardNum);
  jNewArray2:= env^.NewIntArray(env, newSize2);  // allocate
  env^.SetIntArrayRegion(env, jNewArray2, 0 , newSize2, @CardNum[0] {source});
  jParams[3].l:= jNewArray2;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'InventoryG2', '(B[B[I[I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_WriteEPCG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; var WriteEPC: TDynArrayOfJByte; WriteEPClen: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(Password);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @Password[0] {source});
  jParams[1].l:= jNewArray0;
  newSize1:= Length(WriteEPC);
  jNewArray1:= env^.NewByteArray(env, newSize1);  // allocate
  env^.SetByteArrayRegion(env, jNewArray1, 0 , newSize1, @WriteEPC[0] {source});
  jParams[2].l:= jNewArray1;
  jParams[3].b:= WriteEPClen;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteEPCG2', '(B[B[BB)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_ReadCardG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; ReadEPClen: byte; var Data: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(Password);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @Password[0] {source});
  jParams[1].l:= jNewArray0;
  jParams[2].b:= Mem;
  jParams[3].b:= WordPtr;
  jParams[4].b:= ReadEPClen;
  newSize1:= Length(Data);
  jNewArray1:= env^.NewByteArray(env, newSize1);  // allocate
  env^.SetByteArrayRegion(env, jNewArray1, 0 , newSize1, @Data[0] {source});
  jParams[5].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'ReadCardG2', '(B[BBBB[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_WriteCardG2(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var Password: TDynArrayOfJByte; Mem: byte; WordPtr: byte; Writelen: byte; var Writedata: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(Password);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @Password[0] {source});
  jParams[1].l:= jNewArray0;
  jParams[2].b:= Mem;
  jParams[3].b:= WordPtr;
  jParams[4].b:= Writelen;
  newSize1:= Length(Writedata);
  jNewArray1:= env^.NewByteArray(env, newSize1);  // allocate
  env^.SetByteArrayRegion(env, jNewArray1, 0 , newSize1, @Writedata[0] {source});
  jParams[5].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteCardG2', '(B[BBBB[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_RelayOn(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= bDevAdr;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'RelayOn', '(B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_RelayOff(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= bDevAdr;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'RelayOff', '(B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_ClearTagBuf(env: PJNIEnv; _jnetapi: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearTagBuf', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jnetapi, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_GetTagBuf(env: PJNIEnv; _jnetapi: JObject; var pBuf: TDynArrayOfJByte; var pLength: TDynArrayOfInteger; var pTagNumber: TDynArrayOfInteger): byte;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
  newSize2: integer;
  jNewArray2: jObject=nil;
begin
  newSize0:= Length(pBuf);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pBuf[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(pLength);
  jNewArray1:= env^.NewIntArray(env, newSize1);  // allocate
  env^.SetIntArrayRegion(env, jNewArray1, 0 , newSize1, @pLength[0] {source});
  jParams[1].l:= jNewArray1;
  newSize2:= Length(pTagNumber);
  jNewArray2:= env^.NewIntArray(env, newSize2);  // allocate
  env^.SetIntArrayRegion(env, jNewArray2, 0 , newSize2, @pTagNumber[0] {source});
  jParams[2].l:= jNewArray2;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTagBuf', '([B[I[I)B');
  Result:= env^.CallByteMethodA(env, _jnetapi, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_SetFreq(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(pFreq);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pFreq[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFreq', '(B[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jNetApi_ReadFreq(env: PJNIEnv; _jnetapi: JObject; bDevAdr: byte; var pFreq: TDynArrayOfJByte): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].b:= bDevAdr;
  newSize0:= Length(pFreq);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @pFreq[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jnetapi);
  jMethod:= env^.GetMethodID(env, jCls, 'ReadFreq', '(B[B)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jnetapi, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
