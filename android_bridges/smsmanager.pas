unit smsmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [10/13/2018 21:55:45]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSMSManager = class(jControl)
 private
    FHeaderBodyDelimiter: string;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function Send(_phoneNumber: string; _smsMessage: string; _multipartMessage: boolean): boolean; overload;
    function Send(_phoneNumber: string; _smsMessage: string; _packageDeliveredAction: string; _multipartMessage: boolean): boolean; overload;
    function Read(intent: jObject; _headerBodyDelimiter: string): string;  overload;
    function GetInboxCount(): integer;
    function ReadInbox(_index: integer): string;
    function Read(_intent: jObject): string; overload;
    procedure SetHeaderBodyDelimiter(_delimiter: string);


 published
    property HeaderBodyDelimiter: string read FHeaderBodyDelimiter write SetHeaderBodyDelimiter;

end;

function jSMSManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSMSManager_jFree(env: PJNIEnv; _jsmsmanager: JObject);
function jSMSManager_Send(env: PJNIEnv; _jsmsmanager: JObject; phoneNumber: string; msg: string; multipartMessage: boolean): boolean; overload;
function jSMSManager_Send(env: PJNIEnv; _jsmsmanager: JObject; phoneNumber: string; msg: string; packageDeliveredAction: string; multipartMessage: boolean): boolean; overload;
function jSMSManager_Read(env: PJNIEnv; _jsmsmanager: JObject; intent: jObject; addressBodyDelimiter: string): string;  overload;
function jSMSManager_GetInboxCount(env: PJNIEnv; _jsmsmanager: JObject): integer;
function jSMSManager_ReadInbox(env: PJNIEnv; _jsmsmanager: JObject; _index: integer): string;
function jSMSManager_Read(env: PJNIEnv; _jsmsmanager: JObject; _intent: jObject): string; overload;
procedure jSMSManager_SetHeaderBodyDelimiter(env: PJNIEnv; _jsmsmanager: JObject; _delimiter: string);



implementation


{---------  jSMSManager  --------------}

constructor jSMSManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FHeaderBodyDelimiter:= '|';
end;

destructor jSMSManager.Destroy;
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

procedure jSMSManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

  if FHeaderBodyDelimiter <> '|' then
     jSMSManager_SetHeaderBodyDelimiter(FjEnv, FjObject, FHeaderBodyDelimiter);

end;


function jSMSManager.jCreate(): jObject;
begin
   Result:= jSMSManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSMSManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSMSManager_jFree(FjEnv, FjObject);
end;

function jSMSManager.Send(_phoneNumber: string; _smsMessage: string; _multipartMessage: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_Send(FjEnv, FjObject, _phoneNumber ,_smsMessage ,_multipartMessage);
end;

function jSMSManager.Send(_phoneNumber: string; _smsMessage: string; _packageDeliveredAction: string; _multipartMessage: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_Send(FjEnv, FjObject, _phoneNumber ,_smsMessage ,_packageDeliveredAction ,_multipartMessage);
end;

function jSMSManager.Read(intent: jObject; _headerBodyDelimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_Read(FjEnv, FjObject, intent ,_headerBodyDelimiter);
end;

function jSMSManager.GetInboxCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_GetInboxCount(FjEnv, FjObject);
end;

function jSMSManager.ReadInbox(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_ReadInbox(FjEnv, FjObject, _index);
end;

function jSMSManager.Read(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSMSManager_Read(FjEnv, FjObject, _intent);
end;

procedure jSMSManager.SetHeaderBodyDelimiter(_delimiter: string);
begin
  //in designing component state: set value here...
  FHeaderBodyDelimiter:= _delimiter;
  if FInitialized then
     jSMSManager_SetHeaderBodyDelimiter(FjEnv, FjObject, _delimiter);
end;

{-------- jSMSManager_JNI_Bridge ----------}

function jSMSManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSMSManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jSMSManager_jFree(env: PJNIEnv; _jsmsmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsmsmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSMSManager_Send(env: PJNIEnv; _jsmsmanager: JObject; phoneNumber: string; msg: string; multipartMessage: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(phoneNumber));
  jParams[1].l:= env^.NewStringUTF(env, PChar(msg));
  jParams[2].z:= JBool(multipartMessage);
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;Ljava/lang/String;Z)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jsmsmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jSMSManager_Send(env: PJNIEnv; _jsmsmanager: JObject; phoneNumber: string; msg: string; packageDeliveredAction: string; multipartMessage: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(phoneNumber));
  jParams[1].l:= env^.NewStringUTF(env, PChar(msg));
  jParams[2].l:= env^.NewStringUTF(env, PChar(packageDeliveredAction));
  jParams[3].z:= JBool(multipartMessage);
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jsmsmanager, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jSMSManager_Read(env: PJNIEnv; _jsmsmanager: JObject; intent: jObject; addressBodyDelimiter: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(addressBodyDelimiter));
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Read', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsmsmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jSMSManager_GetInboxCount(env: PJNIEnv; _jsmsmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInboxCount', '()I');
  Result:= env^.CallIntMethod(env, _jsmsmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSMSManager_ReadInbox(env: PJNIEnv; _jsmsmanager: JObject; _index: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ReadInbox', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsmsmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jSMSManager_Read(env: PJNIEnv; _jsmsmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Read', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsmsmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSMSManager_SetHeaderBodyDelimiter(env: PJNIEnv; _jsmsmanager: JObject; _delimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jsmsmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeaderBodyDelimiter', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsmsmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
