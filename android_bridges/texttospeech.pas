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
    procedure Init(refApp: jApp); override;
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

procedure jTextToSpeech.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jTextToSpeech_jCreate(FjEnv, int64(Self), FjThis);

  if FjObject = nil then exit;

  if FSpeechLanguage <>  slDefault then
      SetLanguage(FSpeechLanguage);

  FInitialized:= True;
end;

procedure jTextToSpeech.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jTextToSpeech.SpeakOn(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'Speak', _text);
end;

procedure jTextToSpeech.SpeakAdd(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SpeakAdd', _text);
end;

procedure jTextToSpeech.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FSpeechLanguage:= _language;

  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'SetLanguage', Ord(_language));
end;

procedure jTextToSpeech.SpeakOnline(_text: string; _language: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tt(FjEnv, FjObject, 'SpeakOnline', _text ,_language);
end;

// by ADiV
procedure jTextToSpeech.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'Stop');
end;

// by ADiV
function jTextToSpeech.IsSpeaking() : boolean;
begin
 //in designing component state: set value here...
  Result:= False;
  if FInitialized then
     Result:= jni_func_out_z(FjEnv, FjObject, 'IsSpeaking');
end;

// by ADiV
function jTextToSpeech.IsLoaded() : boolean;
begin
 //in designing component state: set value here...
  Result:= False;
  if FInitialized then
     Result:= jni_func_out_z(FjEnv, FjObject, 'IsLoaded');
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
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jTextToSpeech_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

(*
//Please, you need insert:

public java.lang.Object jTextToSpeech_jCreate(long _Self) {
  return (java.lang.Object)(new jTextToSpeech(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

end.
