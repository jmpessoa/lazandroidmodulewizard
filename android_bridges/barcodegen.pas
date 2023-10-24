unit barcodegen;
 
{$mode delphi}
 
interface
 
uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;
 
type
 
{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/15/2023 13:29:23]}
{https://github.com/jmpessoa/lazandroidmodulewizard}
 
{jControl template}
 TBarFormat1D = (fmCODE_128, fmEAN_8, fmEAN_13, fmITF, fmUPC_A, fmUPC_E, fmCODE_39);
 
jBarcodeGen = class(jControl)
 private
 
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    function QRCode(text: string; width: integer; height: integer): jObject;
    function Get128Bar(_data: string; _width: integer; _height: integer): jObject;
    function GetUPCAChecksum(_data11digits: string): string;
    function GetUPCEChecksum(_data7digits: string): string;
    function GetCode39Checksum(_dataCode: string): string;
    function GetEAN13Checksum(_data12digits: string): string;
    function GetEAN8Checksum(_data7digits: string): string;
    function GetBar1D(_format: integer; _data: string; _width: integer; _height: integer): jObject;
    function GetBar2D(_data: string; _width: integer; _height: integer; _format: integer): jObject;
 
 published
 
end;
 
function jBarcodeGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBarcodeGen_jFree(env: PJNIEnv; _jbarcodegen: JObject);
function jBarcodeGen_QRCode(env: PJNIEnv; _jbarcodegen: JObject; text: string; width: integer; height: integer): jObject;
function jBarcodeGen_Get128Bar(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer): jObject;
function jBarcodeGen_GetUPCAChecksum(env: PJNIEnv; _jbarcodegen: JObject; _data11digits: string): string;
function jBarcodeGen_GetUPCEChecksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
function jBarcodeGen_GetCode39Checksum(env: PJNIEnv; _jbarcodegen: JObject; _dataCode: string): string;
function jBarcodeGen_GetEAN13Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data12digits: string): string;
function jBarcodeGen_GetEAN8Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
function jBarcodeGen_GetBar1D(env: PJNIEnv; _jbarcodegen: JObject; _format: integer; _data: string; _width: integer; _height: integer): jObject;
function jBarcodeGen_GetBar2D(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer; _format: integer): jObject;
 
 
implementation
 
{---------  jBarcodeGen  --------------}
 
constructor jBarcodeGen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;
 
destructor jBarcodeGen.Destroy;
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
 
procedure jBarcodeGen.Init;
begin
 
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !
 
  if FjObject = nil then exit;
 
  FInitialized:= True;
end;
 
 
function jBarcodeGen.jCreate(): jObject;
begin
   Result:= jBarcodeGen_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;
 
procedure jBarcodeGen.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBarcodeGen_jFree(gApp.jni.jEnv, FjObject);
end;
 
function jBarcodeGen.QRCode(text: string; width: integer; height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_QRCode(gApp.jni.jEnv, FjObject, text ,width ,height);
end;
 
function jBarcodeGen.Get128Bar(_data: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_Get128Bar(gApp.jni.jEnv, FjObject, _data ,_width ,_height);
end;
 
function jBarcodeGen.GetUPCAChecksum(_data11digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetUPCAChecksum(gApp.jni.jEnv, FjObject, _data11digits);
end;
 
function jBarcodeGen.GetUPCEChecksum(_data7digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetUPCEChecksum(gApp.jni.jEnv, FjObject, _data7digits);
end;
 
function jBarcodeGen.GetCode39Checksum(_dataCode: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetCode39Checksum(gApp.jni.jEnv, FjObject, _dataCode);
end;
 
function jBarcodeGen.GetEAN13Checksum(_data12digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetEAN13Checksum(gApp.jni.jEnv, FjObject, _data12digits);
end;
 
function jBarcodeGen.GetEAN8Checksum(_data7digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetEAN8Checksum(gApp.jni.jEnv, FjObject, _data7digits);
end;
 
function jBarcodeGen.GetBar1D(_format: integer; _data: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetBar1D(gApp.jni.jEnv, FjObject, _format ,_data ,_width ,_height);
end;
 
function jBarcodeGen.GetBar2D(_data: string; _width: integer; _height: integer; _format: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetBar2D(gApp.jni.jEnv, FjObject, _data ,_width ,_height ,_format);
end;
 
{-------- jBarcodeGen_JNI_Bridge ----------}
 
function jBarcodeGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  Result := nil;
 
  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jBarcodeGen_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;
 
  jParams[0].j:= _Self;
 
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
 
  Result:= env^.NewGlobalRef(env, Result);
 
  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;
 
 
procedure jBarcodeGen_jFree(env: PJNIEnv; _jbarcodegen: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  env^.CallVoidMethod(env, _jbarcodegen, jMethod);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_QRCode(env: PJNIEnv; _jbarcodegen: JObject; text: string; width: integer; height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'QRCode', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(text));
  jParams[1].i:= width;
  jParams[2].i:= height;
 
 
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_Get128Bar(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Get128Bar', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
 
 
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetUPCAChecksum(env: PJNIEnv; _jbarcodegen: JObject; _data11digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetUPCAChecksum', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data11digits));
 
 
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
 
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetUPCEChecksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetUPCEChecksum', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data7digits));
 
 
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
 
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetCode39Checksum(env: PJNIEnv; _jbarcodegen: JObject; _dataCode: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetCode39Checksum', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_dataCode));
 
 
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
 
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetEAN13Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data12digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetEAN13Checksum', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data12digits));
 
 
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
 
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetEAN8Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetEAN8Checksum', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data7digits));
 
 
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
 
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetBar1D(env: PJNIEnv; _jbarcodegen: JObject; _format: integer; _data: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBar1D', '(ILjava/lang/String;II)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].i:= _format;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_data));
  jParams[2].i:= _width;
  jParams[3].i:= _height;
 
 
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
 
function jBarcodeGen_GetBar2D(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer; _format: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
 
  if (env = nil) or (_jbarcodegen = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBar2D', '(Ljava/lang/String;III)Landroid/graphics/Bitmap;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
 
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jParams[3].i:= _format;
 
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
 
  env^.DeleteLocalRef(env, jCls);
 
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;
 
end.
