unit ujsescposthermalprinter;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TPrinterConnection = (connBluetooth);  //connTCP,  connUSB

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [5/29/2023 16:02:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}
{jControl template}

jsEscPosThermalPrinter = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetCharsetEncoding(_charsetName: string; _charsetId: integer);
    function InitConnection(_connectionType: TPrinterConnection; _printDpi: integer; _printWitdhMM: single; _printNbrCharacterPerline: integer): boolean;
    function ImageToHexadecimalString(_imageIdentifier: string): string;
    procedure PrintFormattedText(_formattedText: string);


 published

end;

function jsEscPosThermalPrinter_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
procedure jsEscPosThermalPrinter_jFree(env: PJNIEnv; _jsescposthermalprinter: JObject);
procedure jsEscPosThermalPrinter_SetCharsetEncoding(env: PJNIEnv; _jsescposthermalprinter: JObject; _charsetName: string; _charsetId: integer);
function jsEscPosThermalPrinter_InitConnection(env: PJNIEnv; _jsescposthermalprinter: JObject; _connectionType: integer; _printDpi: integer; _printWitdhMM: single; _printNbrCharacterPerline: integer): boolean;
function jsEscPosThermalPrinter_ImageToHexadecimalString(env: PJNIEnv; _jsescposthermalprinter: JObject; _imageIdentifier: string): string;
procedure jsEscPosThermalPrinter_PrintFormattedText(env: PJNIEnv; _jsescposthermalprinter: JObject; _formattedText: string);



implementation

{---------  jsEscPosThermalPrinter  --------------}

constructor jsEscPosThermalPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jsEscPosThermalPrinter.Destroy;
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

procedure jsEscPosThermalPrinter.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jsEscPosThermalPrinter.jCreate(): jObject;
begin
   Result:= jsEscPosThermalPrinter_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsEscPosThermalPrinter.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEscPosThermalPrinter_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsEscPosThermalPrinter.SetCharsetEncoding(_charsetName: string; _charsetId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEscPosThermalPrinter_SetCharsetEncoding(gApp.jni.jEnv, FjObject, _charsetName ,_charsetId);
end;

function jsEscPosThermalPrinter.InitConnection(_connectionType: TPrinterConnection; _printDpi: integer; _printWitdhMM: single; _printNbrCharacterPerline: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEscPosThermalPrinter_InitConnection(gApp.jni.jEnv, FjObject, Ord(_connectionType) ,_printDpi ,_printWitdhMM ,_printNbrCharacterPerline);
end;

function jsEscPosThermalPrinter.ImageToHexadecimalString(_imageIdentifier: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEscPosThermalPrinter_ImageToHexadecimalString(gApp.jni.jEnv, FjObject, _imageIdentifier);
end;

procedure jsEscPosThermalPrinter.PrintFormattedText(_formattedText: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEscPosThermalPrinter_PrintFormattedText(gApp.jni.jEnv, FjObject, _formattedText);
end;

{-------- jsEscPosThermalPrinter_JNI_Bridge ----------}

function jsEscPosThermalPrinter_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
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
  jMethod:= env^.GetMethodID(env, jCls, 'jsEscPosThermalPrinter_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jsEscPosThermalPrinter_jFree(env: PJNIEnv; _jsescposthermalprinter: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsescposthermalprinter = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsescposthermalprinter);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jsescposthermalprinter, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jsEscPosThermalPrinter_SetCharsetEncoding(env: PJNIEnv; _jsescposthermalprinter: JObject; _charsetName: string; _charsetId: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsescposthermalprinter = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsescposthermalprinter);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetCharsetEncoding', '(Ljava/lang/String;I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_charsetName));
  jParams[1].i:= _charsetId;

  env^.CallVoidMethodA(env, _jsescposthermalprinter, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jsEscPosThermalPrinter_InitConnection(env: PJNIEnv; _jsescposthermalprinter: JObject; _connectionType: integer; _printDpi: integer; _printWitdhMM: single; _printNbrCharacterPerline: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsescposthermalprinter = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsescposthermalprinter);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'InitConnection', '(IIFI)Z');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _connectionType;
  jParams[1].i:= _printDpi;
  jParams[2].f:= _printWitdhMM;
  jParams[3].i:= _printNbrCharacterPerline;

  jBoo:= env^.CallBooleanMethodA(env, _jsescposthermalprinter, jMethod, @jParams);

  Result:= boolean(jBoo);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jsEscPosThermalPrinter_ImageToHexadecimalString(env: PJNIEnv; _jsescposthermalprinter: JObject; _imageIdentifier: string): string;
var
  jStr: JString;
  //jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsescposthermalprinter = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsescposthermalprinter);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ImageToHexadecimalString', '(Ljava/lang/String;)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));

  jStr:= env^.CallObjectMethodA(env, _jsescposthermalprinter, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jsEscPosThermalPrinter_PrintFormattedText(env: PJNIEnv; _jsescposthermalprinter: JObject; _formattedText: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jsescposthermalprinter = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsescposthermalprinter);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'PrintFormattedText', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_formattedText));

  env^.CallVoidMethodA(env, _jsescposthermalprinter, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;



end.
