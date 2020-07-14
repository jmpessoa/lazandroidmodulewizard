unit customspeechtotext;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/13/2020 15:23:13]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

TOnBeginOfSpeech=procedure(Sender:TObject) of object;
TOnSpeechBufferReceived=procedure(Sender:TObject;txtBytes:array of shortint) of object;
TOnEndOfSpeech=procedure(Sender:TObject) of object;
TOnSpeechResults=procedure(Sender:TObject; speechText:string) of object;

jCustomSpeechToText = class(jControl)
 private
    FSpeechLanguage: TSpeechLanguage;
    FOnBeginOfSpeech: TOnBeginOfSpeech;
    FOnSpeechBufferReceived: TOnSpeechBufferReceived;
    FOnEndOfSpeech: TOnEndOfSpeech;
    FOnSpeechResults: TOnSpeechResults;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetLanguage(_language: TSpeechLanguage);
    procedure StartListening();
    procedure StopListening();

    procedure GenEvent_OnBeginOfSpeech(Sender:TObject);
    procedure GenEvent_OnSpeechBufferReceived(Sender:TObject;txtBytes:array of shortint);
    procedure GenEvent_OnEndOfSpeech(Sender:TObject);
    procedure GenEvent_OnSpeechResults(Sender:TObject;txt:string);

 published
    property SpeechLanguage: TSpeechLanguage read FSpeechLanguage write SetLanguage;
    property OnBeginOfSpeech: TOnBeginOfSpeech read FOnBeginOfSpeech write FOnBeginOfSpeech;
    property OnSpeechBufferReceived: TOnSpeechBufferReceived read FOnSpeechBufferReceived write FOnSpeechBufferReceived;
    property OnEndOfSpeech: TOnEndOfSpeech read FOnEndOfSpeech write FOnEndOfSpeech;
    property OnSpeechResults: TOnSpeechResults read FOnSpeechResults write FOnSpeechResults;

end;

function jCustomSpeechToText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jCustomSpeechToText_jFree(env: PJNIEnv; _jcustomspeechtotext: JObject);
procedure jCustomSpeechToText_SetLanguage(env: PJNIEnv; _jcustomspeechtotext: JObject; _language: integer);
procedure jCustomSpeechToText_StartListening(env: PJNIEnv; _jcustomspeechtotext: JObject);
procedure jCustomSpeechToText_StopListening(env: PJNIEnv; _jcustomspeechtotext: JObject);


implementation

{---------  jCustomSpeechToText  --------------}

constructor jCustomSpeechToText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jCustomSpeechToText.Destroy;
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

procedure jCustomSpeechToText.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  if FSpeechLanguage <> slDefault then
     jCustomSpeechToText_SetLanguage(FjEnv, FjObject, Ord(FSpeechLanguage));

  FInitialized:= True;
end;


function jCustomSpeechToText.jCreate(): jObject;
begin
   Result:= jCustomSpeechToText_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jCustomSpeechToText.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomSpeechToText_jFree(FjEnv, FjObject);
end;

procedure jCustomSpeechToText.StartListening();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomSpeechToText_StartListening(FjEnv, FjObject);
end;

procedure jCustomSpeechToText.StopListening();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomSpeechToText_StopListening(FjEnv, FjObject);
end;

procedure jCustomSpeechToText.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomSpeechToText_SetLanguage(FjEnv, FjObject, Ord(_language));
end;

procedure jCustomSpeechToText.GenEvent_OnBeginOfSpeech(Sender:TObject);
begin
  if Assigned(FOnBeginOfSpeech) then FOnBeginOfSpeech(Sender);
end;
procedure jCustomSpeechToText.GenEvent_OnSpeechBufferReceived(Sender:TObject;txtBytes:array of shortint);
begin
  if Assigned(FOnSpeechBufferReceived) then FOnSpeechBufferReceived(Sender,txtBytes);
end;
procedure jCustomSpeechToText.GenEvent_OnEndOfSpeech(Sender:TObject);
begin
  if Assigned(FOnEndOfSpeech) then FOnEndOfSpeech(Sender);
end;
procedure jCustomSpeechToText.GenEvent_OnSpeechResults(Sender:TObject;txt:string);
begin
  if Assigned(FOnSpeechResults) then FOnSpeechResults(Sender,txt);
end;

{-------- jCustomSpeechToText_JNI_Bridge ----------}

function jCustomSpeechToText_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomSpeechToText_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jCustomSpeechToText_jFree(env: PJNIEnv; _jcustomspeechtotext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcustomspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomSpeechToText_SetLanguage(env: PJNIEnv; _jcustomspeechtotext: JObject; _language: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _language;
  jCls:= env^.GetObjectClass(env, _jcustomspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLanguage', '(I)V');
  env^.CallVoidMethodA(env, _jcustomspeechtotext, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomSpeechToText_StartListening(env: PJNIEnv; _jcustomspeechtotext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'StartListening', '()V');
  env^.CallVoidMethod(env, _jcustomspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomSpeechToText_StopListening(env: PJNIEnv; _jcustomspeechtotext: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomspeechtotext);
  jMethod:= env^.GetMethodID(env, jCls, 'StopListening', '()V');
  env^.CallVoidMethod(env, _jcustomspeechtotext, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
