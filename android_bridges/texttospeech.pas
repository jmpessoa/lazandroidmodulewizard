unit texttospeech;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [3/28/2017 0:07:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTextToSpeech = class(jControl)
 private
    FSpeechLanguage: TSpeechLanguage;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SpeakOn(_text: string);
    procedure SpeakAdd(_text: string);
    procedure SetLanguage(_language: TSpeechLanguage);
    procedure SpeakOnline(_text: string; _language: string);

 published
    property SpeechLanguage: TSpeechLanguage read FSpeechLanguage write SetLanguage;

end;

function jTextToSpeech_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTextToSpeech_jFree(env: PJNIEnv; _jtexttospeech: JObject);
procedure jTextToSpeech_Speak(env: PJNIEnv; _jtexttospeech: JObject; _text: string);
procedure jTextToSpeech_SpeakAdd(env: PJNIEnv; _jtexttospeech: JObject; _text: string);
procedure jTextToSpeech_SetLanguage(env: PJNIEnv; _jtexttospeech: JObject; _language: integer);
procedure jTextToSpeech_SpeakOnline(env: PJNIEnv; _jtexttospeech: JObject; _text: string; _language: string);

implementation

{---------  jTextToSpeech  --------------}

constructor jTextToSpeech.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
   FSpeechLanguage:= slDefault;
end;

destructor jTextToSpeech.Destroy;
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

procedure jTextToSpeech.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  if FSpeechLanguage <>  slDefault then
      jTextToSpeech_SetLanguage(FjEnv, FjObject, Ord(FSpeechLanguage));

  FInitialized:= True;
end;

function jTextToSpeech.jCreate(): jObject;
begin
   Result:= jTextToSpeech_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTextToSpeech.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextToSpeech_jFree(FjEnv, FjObject);
end;

procedure jTextToSpeech.SpeakOn(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextToSpeech_Speak(FjEnv, FjObject, _text);
end;

procedure jTextToSpeech.SpeakAdd(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextToSpeech_SpeakAdd(FjEnv, FjObject, _text);
end;

procedure jTextToSpeech.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FSpeechLanguage:= _language;
  if FInitialized then
     jTextToSpeech_SetLanguage(FjEnv, FjObject, Ord(_language));
end;

procedure jTextToSpeech.SpeakOnline(_text: string; _language: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextToSpeech_SpeakOnline(FjEnv, FjObject, _text ,_language);
end;

{-------- jTextToSpeech_JNI_Bridge ----------}

function jTextToSpeech_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTextToSpeech_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jTextToSpeech_jCreate(long _Self) {
  return (java.lang.Object)(new jTextToSpeech(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jTextToSpeech_jFree(env: PJNIEnv; _jtexttospeech: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtexttospeech);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtexttospeech, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextToSpeech_Speak(env: PJNIEnv; _jtexttospeech: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jtexttospeech);
  jMethod:= env^.GetMethodID(env, jCls, 'Speak', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtexttospeech, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextToSpeech_SpeakAdd(env: PJNIEnv; _jtexttospeech: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jtexttospeech);
  jMethod:= env^.GetMethodID(env, jCls, 'SpeakAdd', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtexttospeech, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextToSpeech_SetLanguage(env: PJNIEnv; _jtexttospeech: JObject; _language: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _language;
  jCls:= env^.GetObjectClass(env, _jtexttospeech);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLanguage', '(I)V');
  env^.CallVoidMethodA(env, _jtexttospeech, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextToSpeech_SpeakOnline(env: PJNIEnv; _jtexttospeech: JObject; _text: string; _language: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_language));
  jCls:= env^.GetObjectClass(env, _jtexttospeech);
  jMethod:= env^.GetMethodID(env, jCls, 'SpeakOnline', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtexttospeech, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
