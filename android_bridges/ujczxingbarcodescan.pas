unit ujczxingbarcodescan;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TZXingCodeFormat = (zxfUPC_A, zxfUPC_E, zxfEAN_8,zxfEAN_13, zxfRSS_14, //Product Codes
                    zxfCODE_39, zxfCODE_93, zxfCODE_128, zxfITF, zxfRSS_EXPANDED, //Other 1D
                    zxfQR_CODE, zxfDATA_MATRIX, zxfPDF_417); //2D codes

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [3/12/2023 20:23:51]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcZXingBarcodeScan = class(jControl)
 private
    FPrompt: string;
    FCameraId: integer;
    FBeepEnabled: boolean;
    FOrientationLocked: boolean;
    FBarcodeFormat: TZXingCodeFormat;
    FRequestCodeForResult: integer;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    procedure ScanForResult(_barcodeFormat: TZXingCodeFormat; _requestCodeForResult: integer); overload;
    procedure ScanForResult(_barcodeFormat: TZXingCodeFormat); overload;
    procedure ScanForResult(); overload;

    function GetContentFromResult(_intentData: jObject): string;

    procedure SetPrompt(_msg: string);
    procedure SetCameraId(_id: integer);
    procedure SetBeepEnabled(_value: boolean);
    procedure SetOrientationLocked(_value: boolean);
    procedure SetBarcodeFormat(_barcodeFormat: TZXingCodeFormat);
    procedure SetRequestCodeForResult(_requestCode: integer);

 published
    property Prompt: string read FPrompt write SetPrompt;
    property CameraId: integer read FCameraId write SetCameraId;
    property BeepEnabled: boolean read FBeepEnabled write SetBeepEnabled;
    property OrientationLocked: boolean read FOrientationLocked write SetOrientationLocked;
    property BarcodeFormat: TZXingCodeFormat read FBarcodeFormat write SetBarcodeFormat;
    property RequestCodeForResult: integer read FRequestCodeForResult write SetRequestCodeForResult;
end;

function jcZXingBarcodeScan_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
procedure jcZXingBarcodeScan_jFree(env: PJNIEnv; _jczxingbarcodescan: JObject);
procedure jcZXingBarcodeScan_ScanForResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _barcodeFormat: integer; _requestCodeForResult: integer);
function jcZXingBarcodeScan_GetContentFromResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _requestCode: integer; _resultCode: integer; _intentData: jObject): string;
procedure jcZXingBarcodeScan_SetPrompt(env: PJNIEnv; _jczxingbarcodescan: JObject; _msg: string);
procedure jcZXingBarcodeScan_SetCameraId(env: PJNIEnv; _jczxingbarcodescan: JObject; _id: integer);
procedure jcZXingBarcodeScan_SetBeepEnabled(env: PJNIEnv; _jczxingbarcodescan: JObject; _value: boolean);
procedure jcZXingBarcodeScan_SetOrientationLocked(env: PJNIEnv; _jczxingbarcodescan: JObject; _value: boolean);
procedure jcZXingBarcodeScan_SetBarcodeFormat(env: PJNIEnv; _jczxingbarcodescan: JObject; _barcodeFormat: integer);
procedure jcZXingBarcodeScan_SetRequestCodeForResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _requestCode: integer);

implementation

{---------  jcZXingBarcodeScan  --------------}

constructor jcZXingBarcodeScan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FPrompt:= 'Scanning...';
  FBarcodeFormat:= zxfQR_CODE;
  FRequestCodeForResult:= 49374; //default
  FCameraId:= 0;
  FBeepEnabled:= False;
  FOrientationLocked:= False;
end;

destructor jcZXingBarcodeScan.Destroy;
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

procedure jcZXingBarcodeScan.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  if FCameraId <> 0 then
     jcZXingBarcodeScan_SetCameraId(gApp.jni.jEnv, FjObject, FCameraId);

  if FBeepEnabled <> False then
     jcZXingBarcodeScan_SetBeepEnabled(gApp.jni.jEnv, FjObject, FBeepEnabled);

  if FOrientationLocked <> False then
     jcZXingBarcodeScan_SetOrientationLocked(gApp.jni.jEnv, FjObject, FOrientationLocked);

  if  FPrompt <> 'Scanning...'  then
      jcZXingBarcodeScan_SetPrompt(gApp.jni.jEnv, FjObject, FPrompt);

  if FBarcodeFormat <> zxfQR_CODE then
     jcZXingBarcodeScan_SetBarcodeFormat(gApp.jni.jEnv, FjObject, Ord(FBarcodeFormat));

  if FRequestCodeForResult <> 49374 then
     jcZXingBarcodeScan_SetRequestCodeForResult(gApp.jni.jEnv, FjObject, FRequestCodeForResult);

  FInitialized:= True;
end;


function jcZXingBarcodeScan.jCreate(): jObject;
begin
   Result:= jcZXingBarcodeScan_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jcZXingBarcodeScan.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcZXingBarcodeScan_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jcZXingBarcodeScan.ScanForResult(_barcodeFormat: TZXingCodeFormat; _requestCodeForResult: integer);
begin
  //in designing component state: set value here...
  FBarcodeFormat:= _barcodeFormat;
  FRequestCodeForResult:= _requestCodeForResult;

  if FInitialized then
     jcZXingBarcodeScan_ScanForResult(gApp.jni.jEnv, FjObject, Ord(FBarcodeFormat), FRequestCodeForResult);
end;

procedure jcZXingBarcodeScan.ScanForResult(_barcodeFormat: TZXingCodeFormat);
begin
  //in designing component state: set value here...
  FBarcodeFormat:= _barcodeFormat;

  if FInitialized then
      jcZXingBarcodeScan_ScanForResult(gApp.jni.jEnv, FjObject, Ord(FBarcodeFormat), FRequestCodeForResult);
end;

procedure jcZXingBarcodeScan.ScanForResult();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcZXingBarcodeScan_ScanForResult(gApp.jni.jEnv, FjObject, Ord(FBarcodeFormat), FRequestCodeForResult);
end;

function jcZXingBarcodeScan.GetContentFromResult( _intentData: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcZXingBarcodeScan_GetContentFromResult(gApp.jni.jEnv, FjObject, FRequestCodeForResult , Ord(RESULT_OK) ,_intentData);
end;

procedure jcZXingBarcodeScan.SetPrompt(_msg: string);
begin
  //in designing component state: set value here...
  FPrompt:= _msg;
  if FInitialized then
     jcZXingBarcodeScan_SetPrompt(gApp.jni.jEnv, FjObject, _msg);
end;

procedure jcZXingBarcodeScan.SetCameraId(_id: integer);
begin
  //in designing component state: set value here...
  FCameraId:= _id;
  if FInitialized then
     jcZXingBarcodeScan_SetCameraId(gApp.jni.jEnv, FjObject, _id);
end;

procedure jcZXingBarcodeScan.SetBeepEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  FBeepEnabled:= _value;
  if FInitialized then
     jcZXingBarcodeScan_SetBeepEnabled(gApp.jni.jEnv, FjObject, _value);
end;

procedure jcZXingBarcodeScan.SetOrientationLocked(_value: boolean);
begin
  //in designing component state: set value here...
  FOrientationLocked:= _value;
  if FInitialized then
     jcZXingBarcodeScan_SetOrientationLocked(gApp.jni.jEnv, FjObject, _value);
end;


procedure jcZXingBarcodeScan.SetBarcodeFormat(_barcodeFormat: TZXingCodeFormat);
begin
  //in designing component state: set value here...
  FBarcodeFormat:= _barcodeFormat;
  if FInitialized then
     jcZXingBarcodeScan_SetBarcodeFormat(gApp.jni.jEnv, FjObject, Ord(FBarcodeFormat));
end;

procedure jcZXingBarcodeScan.SetRequestCodeForResult(_requestCode: integer);
begin
  //in designing component state: set value here...
  FRequestCodeForResult:= _requestCode;
  if FInitialized then
     jcZXingBarcodeScan_SetRequestCodeForResult(gApp.jni.jEnv, FjObject, FRequestCodeForResult);
end;


{-------- jcZXingBarcodeScan_JNI_Bridge ----------}

function jcZXingBarcodeScan_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
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
  jMethod:= env^.GetMethodID(env, jCls, 'jcZXingBarcodeScan_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jcZXingBarcodeScan_jFree(env: PJNIEnv; _jczxingbarcodescan: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jczxingbarcodescan, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jcZXingBarcodeScan_GetContentFromResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _requestCode: integer; _resultCode: integer; _intentData: jObject): string;
var
  jStr: JString;
  //jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetContentFromResult', '(IILandroid/content/Intent;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _requestCode;
  jParams[1].i:= _resultCode;
  jParams[2].l:= _intentData;

  jStr:= env^.CallObjectMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcZXingBarcodeScan_SetPrompt(env: PJNIEnv; _jczxingbarcodescan: JObject; _msg: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetPrompt', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_msg));

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcZXingBarcodeScan_SetCameraId(env: PJNIEnv; _jczxingbarcodescan: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetCameraId', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _id;

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcZXingBarcodeScan_SetBeepEnabled(env: PJNIEnv; _jczxingbarcodescan: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetBeepEnabled', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcZXingBarcodeScan_SetOrientationLocked(env: PJNIEnv; _jczxingbarcodescan: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrientationLocked', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcZXingBarcodeScan_SetBarcodeFormat(env: PJNIEnv; _jczxingbarcodescan: JObject; _barcodeFormat: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetBarcodeFormat', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _barcodeFormat;

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcZXingBarcodeScan_SetRequestCodeForResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _requestCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetRequestCodeForResult', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _requestCode;

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcZXingBarcodeScan_ScanForResult(env: PJNIEnv; _jczxingbarcodescan: JObject; _barcodeFormat: integer; _requestCodeForResult: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jczxingbarcodescan = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jczxingbarcodescan);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ScanForResult', '(II)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _barcodeFormat;
  jParams[1].i:= _requestCodeForResult;

  env^.CallVoidMethodA(env, _jczxingbarcodescan, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
