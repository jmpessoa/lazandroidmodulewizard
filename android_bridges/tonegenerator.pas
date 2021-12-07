unit tonegenerator;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

//ref: http://android-er.blogspot.com/2014/12/sound-samples-generated-by.html
TToneType  = (ttAbbrAlert, ttAbbrIntercept, ttAbbrReorder, ttAlertAutoRedialLite, ttAlertCallGuard,
              ttAlertIncallLite, ttAlertNetworkLite, ttAnswer, ttCallDropLite, ttCallSignalIsdnInterGroup,
              ttCallSignalIsdnNormal, ttCallSignalIsdnPat3, ttCallSignalIsdnPat5, ttCallSignalIsdnPat6, ttCallSignalIsdnPat7,
              ttCallSignalIsdnPatPingRing, ttCallSignalIsdnPatSpPri, ttConfirm, ttToneLite, ttEmergencyRingBack,
              ttHighL, ttHighPbxL, ttHighPbxSLS, ttHighPbxSS, ttHighPbxSSL, ttHighPbxSX4, ttHighSLS, ttHighSS,
              ttHighSSL, ttHighSS2, ttHighSX4, ttIntercept, ttKeyPadVolumeLite, ttLowL,
              ttLowPbxL, ttLowPbxSLS, ttLowPbxSS, ttLowPbxSSL, ttLowPbxSX4, ttLowSLS, ttLowSS, ttLowSSL, ttLowSS2,
              ttLowSX4, ttMedL, ttMedPbxL, ttMedPbxSLS, ttMedPbxSSL, ttMedPbxSX4, ttMedSLS, ttMedSS, ttMedSSL,
              ttMedSS2, ttMedSX4, ttNetworkBusy, ttNetworkBusyOneShot, ttNetworkCallWaiting, ttNetworkCallUsaRingBack,
              ttOneMinBeep, ttPip, ttPressHoldKeyLite, ttReorder, ttSignalOff, ttSoftErrorLite,
              ttDtmf0, ttDtmf1, ttDtmf2, ttDtmf3, ttDtmf4, ttDtmf5, ttDtmf6, ttDtmf7, ttDtmf8, ttDtmf9,
              ttDtmfA, ttDtmfB, ttDtmfC, ttDtmfD, ttDtmfP, ttDtmfS, ttPropAck, ttPropBeep, ttPropBeep2, ttPropNack, ttPropPrompt,
              ttSupBusy, ttSupCallWaiting, ttSupConfirm, ttSupCongestion, ttSupCongestionAbbrev, ttSupDial, ttSupError,
              ttSupIntercept, ttSupInterceptAbbrev, ttSupPip, ttSupRadioAck, ttSupRadioNotAvail, ttSupRingTone
              );

 TToneStream = (tsMusic=3, tsAlarm=4);

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [12/6/2021 16:45:25]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jToneGenerator = class(jControl)
 private
    FTone: TToneType;
    FDurationMilliseconds : integer;
    FStream: TToneStream;
    FVolume: integer;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate( _stream: integer; _volume: integer): jObject;
    procedure jFree();

    function Play(_toneType: TToneType; _durationMilliseconds: integer): string; overload;
    function Play(_durationMilliseconds: integer): string; overload;
    function Play(): string; overload;

    function GetToneDescription(_toneType: TToneType): string;
    procedure SetVolume(_volume: integer);
    procedure SetStream(_stream: TToneStream);
    procedure Stop();

 published
     property Stream: TToneStream read FStream write SetStream;
     property Volume: integer read FVolume write SetVolume;
     property Tone: TToneType read FTone write FTone;
     property DurationMilliseconds: integer read FDurationMilliseconds write FDurationMilliseconds;

end;

function jToneGenerator_jCreate(env: PJNIEnv;_Self: int64; _stream: integer; _volume: integer; this: jObject): jObject;
procedure jToneGenerator_jFree(env: PJNIEnv; _jtonegenerator: JObject);
function jToneGenerator_Play(env: PJNIEnv; _jtonegenerator: JObject; _toneType: integer; _durationMs: integer): string;
function jToneGenerator_GetToneDescription(env: PJNIEnv; _jtonegenerator: JObject; _toneType: integer): string;
procedure jToneGenerator_SetVolume(env: PJNIEnv; _jtonegenerator: JObject; _volume: integer);
procedure jToneGenerator_SetStream(env: PJNIEnv; _jtonegenerator: JObject; _stream: integer);
procedure jToneGenerator_Stop(env: PJNIEnv; _jtonegenerator: JObject);

implementation

{---------  jToneGenerator  --------------}

constructor jToneGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
 FStream:= tsAlarm;
 FVolume:= 100;
 FTone:=  ttAlertCallGuard;
 FDurationMilliseconds:= 2000;
end;

destructor jToneGenerator.Destroy;
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

procedure jToneGenerator.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(Ord(FStream), FVolume); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jToneGenerator.jCreate( _stream: integer; _volume: integer): jObject;
begin
   Result:= jToneGenerator_jCreate(FjEnv, int64(Self) ,_stream ,_volume, FjThis);
end;

procedure jToneGenerator.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToneGenerator_jFree(FjEnv, FjObject);
end;


function jToneGenerator.Play(_toneType: TToneType; _durationMilliseconds: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToneGenerator_Play(FjEnv, FjObject, Ord(_toneType) ,_durationMilliseconds);
end;

function jToneGenerator.Play(_durationMilliseconds: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToneGenerator_Play(FjEnv, FjObject, Ord(FTone) ,_durationMilliseconds);
end;

function jToneGenerator.Play(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jToneGenerator_Play(FjEnv, FjObject, Ord(FTone) , FDurationMilliseconds);
end;

function jToneGenerator.GetToneDescription(_toneType: TToneType): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToneGenerator_GetToneDescription(FjEnv, FjObject, Ord(_toneType));
end;

procedure jToneGenerator.SetVolume(_volume: integer);
begin
  //in designing component state: set value here...
  FVolume:= _volume;
  if FInitialized then
     jToneGenerator_SetVolume(FjEnv, FjObject, _volume);
end;

procedure jToneGenerator.SetStream(_stream: TToneStream);
begin
  //in designing component state: set value here...
  FStream:= _stream;
  if FInitialized then
     jToneGenerator_SetStream(FjEnv, FjObject, Ord(_stream));
end;

procedure jToneGenerator.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToneGenerator_Stop(FjEnv, FjObject);
end;

{-------- jToneGenerator_JNI_Bridge ----------}

function jToneGenerator_jCreate(env: PJNIEnv;_Self: int64; _stream: integer; _volume: integer; this: jObject): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jToneGenerator_jCreate', '(JII)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].i:= _stream;
  jParams[2].i:= _volume;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jToneGenerator_jFree(env: PJNIEnv; _jtonegenerator: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jtonegenerator, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jToneGenerator_Play(env: PJNIEnv; _jtonegenerator: JObject; _toneType: integer; _durationMs: integer): string;
var
  jStr: JString;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Play', '(II)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _toneType;
  jParams[1].i:= _durationMs;


  jStr:= env^.CallObjectMethodA(env, _jtonegenerator, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jToneGenerator_GetToneDescription(env: PJNIEnv; _jtonegenerator: JObject; _toneType: integer): string;
var
  jStr: JString;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetToneDescription', '(I)Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _toneType;


  jStr:= env^.CallObjectMethodA(env, _jtonegenerator, jMethod, @jParams);

  Result:= GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jToneGenerator_SetVolume(env: PJNIEnv; _jtonegenerator: JObject; _volume: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetVolume', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _volume;

  env^.CallVoidMethodA(env, _jtonegenerator, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jToneGenerator_SetStream(env: PJNIEnv; _jtonegenerator: JObject; _stream: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetStream', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _stream;

  env^.CallVoidMethodA(env, _jtonegenerator, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jToneGenerator_Stop(env: PJNIEnv; _jtonegenerator: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtonegenerator);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jtonegenerator, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
