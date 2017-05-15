unit speechtotext;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/12/2017 22:51:37]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSpeechToText = class(jControl)
 private
    FRequestCode: integer;
    FPromptMessage: string;
    FSpeechLanguage: TSpeechLanguage;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SpeakIn();  overload;
    procedure SetPromptMessage(_promptMessage: string);
    procedure SpeakIn(_promptMessage: string); overload;
    procedure SetRequestCode(_requestCode: integer);
    function GetRequestCode(): integer;
    function SpeakOut(_intentData: jObject): string;
    procedure SetLanguage(_language: TSpeechLanguage);


 published
    property RequestCode: integer read GetRequestCode write SetRequestCode;
    property PromptMessage: string read FPromptMessage write SetPromptMessage;
    property SpeechLanguage: TSpeechLanguage read FSpeechLanguage write SetLanguage;

end;

function jSpeechToText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSpeechToText_jFree(env: PJNIEnv; _jspeechtotext: JObject);
procedure jSpeechToText_SpeakIn(env: PJNIEnv; _jspeechtotext: JObject);  overload;
procedure jSpeechToText_SetPromptMessage(env: PJNIEnv; _jspeechtotext: JObject; _promptMessage: string);
procedure jSpeechToText_SpeakIn(env: PJNIEnv; _jspeechtotext: JObject; _promptMessage: string);  overload;
procedure jSpeechToText_SetRequestCode(env: PJNIEnv; _jspeechtotext: JObject; _requestCode: integer);
function jSpeechToText_GetRequestCode(env: PJNIEnv; _jspeechtotext: JObject): integer;
function jSpeechToText_SpeakOut(env: PJNIEnv; _jspeechtotext: JObject; _intentData: jObject): string;
procedure jSpeechToText_SetLanguage(env: PJNIEnv; _jspeechtotext: JObject; _language: integer);


implementation


{---------  jSpeechToText  --------------}

constructor jSpeechToText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
 FPromptMessage:= 'Speech a message to write...';
 FRequestCode:= 1234;
 FSpeechLanguage:= slDefault;
end;

destructor jSpeechToText.Destroy;
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

procedure jSpeechToText.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

  if FRequestCode <> 1234 then
    jSpeechToText_SetRequestCode(FjEnv, FjObject, FRequestCode);

  if FPromptMessage <> '' then
     jSpeechToText_SetPromptMessage(FjEnv, FjObject, FPromptMessage);

  if FSpeechLanguage <> slDefault then
    jSpeechToText_SetLanguage(FjEnv, FjObject, Ord(FSpeechLanguage));

end;


function jSpeechToText.jCreate(): jObject;
begin
   Result:= jSpeechToText_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSpeechToText.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpeechToText_jFree(FjEnv, FjObject);
end;

procedure jSpeechToText.SpeakIn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSpeechToText_SpeakIn(FjEnv, FjObject);
end;

procedure jSpeechToText.SetPromptMessage(_promptMessage: string);
begin
  //in designing component state: set value here...
  FPromptMessage:= _promptMessage;
  if FInitialized then
     jSpeechToText_SetPromptMessage(FjEnv, FjObject, _promptMessage);
end;

procedure jSpeechToText.SpeakIn(_promptMessage: string);
begin
  //in designing component state: set value here...
  FPromptMessage:= _promptMessage;
  if FInitialized then
     jSpeechToText_SpeakIn(FjEnv, FjObject, _promptMessage);
end;

procedure jSpeechToText.SetRequestCode(_requestCode: integer);
begin
  //in designing component state: set value here...
  FRequestCode:= _requestCode;
  if FInitialized then
     jSpeechToText_SetRequestCode(FjEnv, FjObject, _requestCode);
end;

function jSpeechToText.GetRequestCode(): integer;
begin
  //in designing component state: result value here...
  Result:= FRequestCode;
  if FInitialized then
   Result:= jSpeechToText_GetRequestCode(FjEnv, FjObject);
end;

function jSpeechToText.SpeakOut(_intentData: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSpeechToText_SpeakOut(FjEnv, FjObject, _intentData);
end;

procedure jSpeechToText.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FSpeechLanguage:= _language;
  if FInitialized then
     jSpeechToText_SetLanguage(FjEnv, FjObject, Ord(_language));
end;

{-------- jSpeechToText_JNI_Bridge ----------}

function jSpeechToText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSpeechToText_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jSpeechToText_jCreate(long _Self) {
  return (java.lang.Object)(new jSpeechToText(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jSpeechToText_jFree(env: PJNIEnv; _jspeechtotext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpeechToText_SpeakIn(env: PJNIEnv; _jspeechtotext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SpeakIn', '()V');
  env^.CallVoidMethod(env, _jspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpeechToText_SetPromptMessage(env: PJNIEnv; _jspeechtotext: JObject; _promptMessage: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_promptMessage));
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPromptMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspeechtotext, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpeechToText_SpeakIn(env: PJNIEnv; _jspeechtotext: JObject; _promptMessage: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_promptMessage));
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SpeakIn', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jspeechtotext, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSpeechToText_SetRequestCode(env: PJNIEnv; _jspeechtotext: JObject; _requestCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRequestCode', '(I)V');
  env^.CallVoidMethodA(env, _jspeechtotext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSpeechToText_GetRequestCode(env: PJNIEnv; _jspeechtotext: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'GetRequestCode', '()I');
  Result:= env^.CallIntMethod(env, _jspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSpeechToText_SpeakOut(env: PJNIEnv; _jspeechtotext: JObject; _intentData: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SpeakOut', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jspeechtotext, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSpeechToText_SetLanguage(env: PJNIEnv; _jspeechtotext: JObject; _language: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _language;
  jCls:= env^.GetObjectClass(env, _jspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLanguage', '(I)V');
  env^.CallVoidMethodA(env, _jspeechtotext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
