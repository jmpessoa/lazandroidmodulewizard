unit barcodegen;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/25/2020 0:50:59]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

TBarFormat1D = (fmCODE_128, fmEAN_8, fmEAN_13, fmITF, fmUPC_A, fmUPC_E, fmCODE_39);

//TBarFormat2D = (fm2QR_CODE, fm2DATA_MATRIX, fm2AZTEC); TODO!

jBarcodeGen = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function GetCode128Bar(_data: string; _width: integer; _height: integer): jObject;
    function GetBar1D(_format: TBarFormat1D; _data: string; _width: integer; _height: integer): jObject;

    function GetEAN8Checksum(_data7digits: string): string;
    function GetEAN13Checksum(_data12digits: string): string;

 published

end;

function jBarcodeGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBarcodeGen_jFree(env: PJNIEnv; _jbarcodegen: JObject);

function jBarcodeGen_Get128Bar(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer): jObject;
function jBarcodeGen_GetBar1D(env: PJNIEnv; _jbarcodegen: JObject; _format: integer; _data: string; _width: integer; _height: integer): jObject;

function jBarcodeGen_GetEAN8Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
function jBarcodeGen_GetEAN13Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data12digits: string): string;

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

procedure jBarcodeGen.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jBarcodeGen.jCreate(): jObject;
begin
   Result:= jBarcodeGen_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jBarcodeGen.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBarcodeGen_jFree(FjEnv, FjObject);
end;

function jBarcodeGen.GetCode128Bar(_data: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_Get128Bar(FjEnv, FjObject, _data ,_width ,_height);
end;

function jBarcodeGen.GetBar1D(_format: TBarFormat1D; _data: string; _width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetBar1D(FjEnv, FjObject, Ord(_format) ,_data ,_width ,_height);
end;

function jBarcodeGen.GetEAN8Checksum(_data7digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetEAN8Checksum(FjEnv, FjObject, _data7digits);
end;

function jBarcodeGen.GetEAN13Checksum(_data12digits: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBarcodeGen_GetEAN13Checksum(FjEnv, FjObject, _data12digits);
end;

{-------- jBarcodeGen_JNI_Bridge ----------}

function jBarcodeGen_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBarcodeGen_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jBarcodeGen_jFree(env: PJNIEnv; _jbarcodegen: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbarcodegen, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBarcodeGen_Get128Bar(env: PJNIEnv; _jbarcodegen: JObject; _data: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data));
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  jMethod:= env^.GetMethodID(env, jCls, 'Get128Bar', '(Ljava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jBarcodeGen_GetBar1D(env: PJNIEnv; _jbarcodegen: JObject; _format: integer; _data: string; _width: integer; _height: integer): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _format;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_data));
  jParams[2].i:= _width;
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBar1D', '(ILjava/lang/String;II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jBarcodeGen_GetEAN8Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data7digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data7digits));
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetEAN8Checksum', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jBarcodeGen_GetEAN13Checksum(env: PJNIEnv; _jbarcodegen: JObject; _data12digits: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_data12digits));
  jCls:= env^.GetObjectClass(env, _jbarcodegen);
  jMethod:= env^.GetMethodID(env, jCls, 'GetEAN13Checksum', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jbarcodegen, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
