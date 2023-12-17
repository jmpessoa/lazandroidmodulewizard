unit ujsarduinoaflakserial;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;


{Draft Component code by "LAMW: Lazarus Android Module Wizard" [12/15/2023 19:48:24]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}
type

TOnArduinoAflakSerialAttached=procedure(Sender:TObject;usb:JObject) of object;
TOnArduinoAflakSerialDetached=procedure(Sender:TObject) of object;
TOnArduinoAflakSerialMessageReceived=procedure(Sender:TObject;jbytesReceived:array of shortint) of object; //array of shortint
TOnArduinoAflakSerialOpened=procedure(Sender:TObject) of object;
TOnArduinoAflakSerialStatusChanged=procedure(Sender:TObject;statusMessage:string) of object;


jsArduinoAflakSerial = class(jControl)
 private
    FOnAttached: TOnArduinoAflakSerialAttached;
    FOnDetached: TOnArduinoAflakSerialDetached;
    FOnMessageReceived: TOnArduinoAflakSerialMessageReceived;
    FOnOpened: TOnArduinoAflakSerialOpened;
    FOnStatusChanged: TOnArduinoAflakSerialStatusChanged;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    procedure GenEvent_OnArduinoAflakSerialAttached(Sender:TObject;usb:JObject);
    procedure GenEvent_OnArduinoAflakSerialDetached(Sender:TObject);
    procedure GenEvent_OnArduinoAflakSerialMessageReceived(Sender:TObject;jbytesReceived: TDynArrayOfJByte); //array of shortint
    procedure GenEvent_OnArduinoAflakSerialOpened(Sender:TObject);
    procedure GenEvent_OnArduinoAflakSerialStatusChanged(Sender:TObject;statusMessage:string);

    procedure Send(_stringMessage: string);  overload;
    procedure Send(var _jbyteMessage: TDynArrayOfJByte);  overload;
    procedure Open(_usb: jObject);
    procedure Close();
    function JBytesToString(var _jbytes: TDynArrayOfJByte): string;

 published
    property OnAttached: TOnArduinoAflakSerialAttached read FOnAttached write FOnAttached;
    property OnDetached: TOnArduinoAflakSerialDetached read FOnDetached write FOnDetached;
    property OnMessageReceived: TOnArduinoAflakSerialMessageReceived read FOnMessageReceived write FOnMessageReceived;
    property OnOpened: TOnArduinoAflakSerialOpened read FOnOpened write FOnOpened;
    property OnStatusChanged: TOnArduinoAflakSerialStatusChanged read FOnStatusChanged write FOnStatusChanged;
end;

function jsArduinoAflakSerial_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
procedure jsArduinoAflakSerial_jFree(env: PJNIEnv; _jsarduinoaflakserial: JObject);
procedure jsArduinoAflakSerial_Send(env: PJNIEnv; _jsarduinoaflakserial: JObject; _stringMessage: string); overload;
procedure jsArduinoAflakSerial_Send(env: PJNIEnv; _jsarduinoaflakserial: JObject; var _jbyteMessage: TDynArrayOfJByte); overload;
procedure jsArduinoAflakSerial_Open(env: PJNIEnv; _jsarduinoaflakserial: JObject; _usb: jObject);
procedure jsArduinoAflakSerial_Close(env: PJNIEnv; _jsarduinoaflakserial: JObject);
function jsArduinoAflakSerial_JBytesToString(env: PJNIEnv; _jsarduinoaflakserial: JObject; var _jbytes: TDynArrayOfJByte): string;

implementation

{---------  jsArduinoAflakSerial  --------------}

constructor jsArduinoAflakSerial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jsArduinoAflakSerial.Destroy;
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

procedure jsArduinoAflakSerial.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jsArduinoAflakSerial.jCreate(): jObject;
begin
   Result:= jsArduinoAflakSerial_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsArduinoAflakSerial.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsArduinoAflakSerial_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsArduinoAflakSerial.Send(_stringMessage: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsArduinoAflakSerial_Send(gApp.jni.jEnv, FjObject, _stringMessage);
end;

procedure jsArduinoAflakSerial.Send(var _jbyteMessage: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsArduinoAflakSerial_Send(gApp.jni.jEnv, FjObject, _jbyteMessage);
end;

procedure jsArduinoAflakSerial.Open(_usb: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsArduinoAflakSerial_Open(gApp.jni.jEnv, FjObject, _usb);
end;

procedure jsArduinoAflakSerial.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsArduinoAflakSerial_Close(gApp.jni.jEnv, FjObject);
end;

function jsArduinoAflakSerial.JBytesToString(var _jbytes: TDynArrayOfJByte): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsArduinoAflakSerial_JBytesToString(gApp.jni.jEnv, FjObject, _jbytes);
end;

procedure jsArduinoAflakSerial.GenEvent_OnArduinoAflakSerialAttached(Sender:TObject;usb:JObject);
begin
  if Assigned(FOnAttached) then FOnAttached(Sender,usb);
end;
procedure jsArduinoAflakSerial.GenEvent_OnArduinoAflakSerialDetached(Sender:TObject);
begin
  if Assigned(FOnDetached) then FOnDetached(Sender);
end;
procedure jsArduinoAflakSerial.GenEvent_OnArduinoAflakSerialMessageReceived(Sender:TObject;jbytesReceived: TDynArrayOfJByte); //array of shortint
begin
  if Assigned(FOnMessageReceived) then FOnMessageReceived(Sender,jbytesReceived);
end;
procedure jsArduinoAflakSerial.GenEvent_OnArduinoAflakSerialOpened(Sender:TObject);
begin
  if Assigned(FOnOpened) then FOnOpened(Sender);
end;

procedure jsArduinoAflakSerial.GenEvent_OnArduinoAflakSerialStatusChanged(Sender:TObject;statusMessage:string);
begin
  if Assigned(FOnStatusChanged) then FOnStatusChanged(Sender,statusMessage);
end;
{-------- jsArduinoAflakSerial_JNI_Bridge ----------}

function jsArduinoAflakSerial_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
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
  jMethod:= env^.GetMethodID(env, jCls, 'jsArduinoAflakSerial_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _self;
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jsArduinoAflakSerial_jFree(env: PJNIEnv; _jsarduinoaflakserial: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jsarduinoaflakserial, jMethod);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jsArduinoAflakSerial_Send(env: PJNIEnv; _jsarduinoaflakserial: JObject; _stringMessage: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_stringMessage));
  env^.CallVoidMethodA(env, _jsarduinoaflakserial, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jsArduinoAflakSerial_Send(env: PJNIEnv; _jsarduinoaflakserial: JObject; var _jbyteMessage: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '([B)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_jbyteMessage);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_jbyteMessage[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jsarduinoaflakserial, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jsArduinoAflakSerial_Open(env: PJNIEnv; _jsarduinoaflakserial: JObject; _usb: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Open', '(Landroid/hardware/usb/UsbDevice;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _usb;
  env^.CallVoidMethodA(env, _jsarduinoaflakserial, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jsArduinoAflakSerial_Close(env: PJNIEnv; _jsarduinoaflakserial: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jsarduinoaflakserial, jMethod);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jsArduinoAflakSerial_JBytesToString(env: PJNIEnv; _jsarduinoaflakserial: JObject; var _jbytes: TDynArrayOfJByte): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jsarduinoaflakserial = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsarduinoaflakserial);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'JBytesToString', '([B)Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  newSize0:= Length(_jbytes);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_jbytes[0] {source});
  jParams[0].l:= jNewArray0;
  jStr:= env^.CallObjectMethodA(env, _jsarduinoaflakserial, jMethod, @jParams);
  Result:= GetPStringAndDeleteLocalRef(env, jStr);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
