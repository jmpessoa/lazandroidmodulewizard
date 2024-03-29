unit texttospeech;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

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
    procedure Init; override;
    procedure jFree();
    procedure SpeakOn(_text: string);
    procedure SpeakAdd(_text: string);
    procedure SetLanguage(_language: TSpeechLanguage);
    procedure SpeakOnline(_text: string; _language: string);

    function  IsLoaded() : boolean; // by ADiV
    function  IsSpeaking() : boolean; // by ADiV
    procedure Stop(); // by ADiV
 published
    property SpeechLanguage: TSpeechLanguage read FSpeechLanguage write SetLanguage;

end;

function jTextToSpeech_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

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

procedure jTextToSpeech.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jTextToSpeech_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

  if FjObject = nil then exit;

  if FSpeechLanguage <>  slDefault then
      SetLanguage(FSpeechLanguage);

  FInitialized:= True;
end;

procedure jTextToSpeech.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
end;

procedure jTextToSpeech.SpeakOn(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'Speak', _text);
end;

procedure jTextToSpeech.SpeakAdd(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'SpeakAdd', _text);
end;

procedure jTextToSpeech.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FSpeechLanguage:= _language;

  if FjObject <> nil then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetLanguage', Ord(_language));
end;

procedure jTextToSpeech.SpeakOnline(_text: string; _language: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(gApp.jni.jEnv, FjObject, 'SpeakOnline', _text ,_language);
end;

// by ADiV
procedure jTextToSpeech.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'Stop');
end;

// by ADiV
function jTextToSpeech.IsSpeaking() : boolean;
begin
 //in designing component state: set value here...
  Result:= False;
  if FInitialized then
     Result:= jni_func_out_z(gApp.jni.jEnv, FjObject, 'IsSpeaking');
end;

// by ADiV
function jTextToSpeech.IsLoaded() : boolean;
begin
 //in designing component state: set value here...
  Result:= False;
  if FInitialized then
     Result:= jni_func_out_z(gApp.jni.jEnv, FjObject, 'IsLoaded');
end;

{-------- jTextToSpeech_JNI_Bridge ----------}

function jTextToSpeech_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jTextToSpeech_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

(*
//Please, you need insert:

public java.lang.Object jTextToSpeech_jCreate(long _Self) {
  return (java.lang.Object)(new jTextToSpeech(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

end.
