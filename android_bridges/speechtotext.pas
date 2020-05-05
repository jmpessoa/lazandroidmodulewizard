unit speechtotext;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

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
    procedure jFree();
    function SpeakIn() : boolean;  overload;
    function SpeakIn(_promptMessage: string) : boolean; overload;
    procedure SetPromptMessage(_promptMessage: string);
    procedure SetRequestCode(_requestCode: integer);
    function GetRequestCode(): integer;
    function SpeakOut(_intentData: jObject): string;
    procedure SetLanguage(_language: TSpeechLanguage);


 published
    property RequestCode: integer read GetRequestCode write SetRequestCode;
    property PromptMessage: string read FPromptMessage write SetPromptMessage;
    property SpeechLanguage: TSpeechLanguage read FSpeechLanguage write SetLanguage;

end;


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

  FjObject := jni_create(FjEnv, FjThis, Self, 'jSpeechToText_jCreate');

  if FjObject = nil then exit;

  FInitialized:= True;

  if FRequestCode <> 1234 then
    SetRequestCode(FRequestCode);

  if FPromptMessage <> '' then
     SetPromptMessage(FPromptMessage);

  if FSpeechLanguage <> slDefault then
    SetLanguage(FSpeechLanguage);

end;

procedure jSpeechToText.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

function jSpeechToText.SpeakIn() : boolean;
begin
  result := false;

  //in designing component state: set value here...
  if FInitialized then
   result := jni_func_out_z(FjEnv, FjObject, 'SpeakIn');
end;

procedure jSpeechToText.SetPromptMessage(_promptMessage: string);
begin
  //in designing component state: set value here...
  FPromptMessage:= _promptMessage;
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetPromptMessage', _promptMessage);
end;

function jSpeechToText.SpeakIn(_promptMessage: string) : boolean;
begin
  result := false;
  //in designing component state: set value here...
  FPromptMessage:= _promptMessage;

  if FInitialized then
   result := jni_func_t_out_z(FjEnv, FjObject, 'SpeakIn', FPromptMessage);
end;

procedure jSpeechToText.SetRequestCode(_requestCode: integer);
begin
  //in designing component state: set value here...
  FRequestCode:= _requestCode;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetRequestCode', _requestCode);
end;

function jSpeechToText.GetRequestCode(): integer;
begin
  //in designing component state: result value here...
  Result:= FRequestCode;
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetRequestCode');
end;

function jSpeechToText.SpeakOut(_intentData: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_int_out_t(FjEnv, FjObject, 'SpeakOut', _intentData);
end;

procedure jSpeechToText.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FSpeechLanguage:= _language;
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetLanguage', Ord(_language));
end;

end.
