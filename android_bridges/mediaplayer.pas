unit mediaplayer;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type


//AudioManager.STREAM_VOICE_CALL//0
//AudioManager.STREAM_SYSTEM //1
//AudioManager.STREAM_RING //2
//AudioManager.STREAM_MUSIC 3
//AudioManager.STREAM_ALARM //4
//AudioManager.STREAM_NOTIFICATION //5

 TAudioStreamType = (astVoiceCall, astSystem, astRing, astMusic, astAlarm, astNotification, astNone);

 TOnPrepared = procedure(Sender: TObject; videoWidth: integer; videoHeight: integer) of Object;
 TOnVideoSizeChanged = procedure(Sender: TObject; videoWidth: integer; videoHeigh: integer) of Object;
 TOnCompletion = procedure(Sender: TObject) of Object;
 TOnTimedText =   procedure(Sender: TObject; timedText: string) of Object;
{Draft Component code by "Lazarus Android Module Wizard" [4/27/2014 0:21:25]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMediaPlayer = class(jControl)
 private
     FOnPrepared: TOnPrepared;
     FOnVideoSizeChanged: TOnVideoSizeChanged;
     FOnCompletion: TOnCompletion;
     FOnTimedText: TOnTimedText;
     FPaused: boolean;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure DeselectTrack(_index: integer);
    procedure Release();
    procedure Reset();
    procedure SetDataSource(_path: string); overload;
    procedure SetDataSource(_path: string; _filename: string); overload;
    procedure Prepare();
    procedure Start();
    procedure Stop();
    procedure Pause();
    function IsPlaying(): boolean;
    function IsPaused(): boolean;
    procedure SeekTo(_millis: integer);
    procedure SetLooping(_looping: boolean);
    function IsLooping(): boolean;
    procedure SelectTrack(_index: integer);
    function GetCurrentPosition(): integer;
    function GetDuration(): integer;
    procedure SetVolume(_leftVolume: single; _rightVolume: single);
    procedure SetDisplay(_surfaceHolder: jObject);
    function GetVideoWidth(): integer;
    function GetVideoHeight(): integer;
    procedure SetScreenOnWhilePlaying(_value: boolean);
    procedure SetAudioStreamType(_audioStreamType: TAudioStreamType);
    procedure SetSurfaceTexture(_surfaceTexture: jObject);
    procedure PrepareAsync();

    procedure GenEvent_OnPrepared(Obj: TObject; videoWidth: integer; videoHeigh: integer);
    procedure GenEvent_OnVideoSizeChanged(Obj: TObject; videoWidth: integer; videoHeight: integer);
    procedure GenEvent_OnCompletion(Obj: TObject);
    procedure GenEvent_pOnMediaPlayerTimedText(Obj: TObject; timedText: string);
 published
    property OnPrepared: TOnPrepared read FOnPrepared write FOnPrepared;
    property OnVideoSizeChanged: TOnVideoSizeChanged read FOnVideoSizeChanged write FOnVideoSizeChanged;
    property OnCompletion: TOnCompletion read FOnCompletion write FOnCompletion;
    property OnTimedText: TOnTimedText read FOnTimedText write FOnTimedText;
end;

function jMediaPlayer_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jMediaPlayer_jFree(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_DeselectTrack(env: PJNIEnv; _jmediaplayer: JObject; _index: integer);
procedure jMediaPlayer_Release(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_Reset(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_SetDataSource(env: PJNIEnv; _jmediaplayer: JObject; _path: string); overload;
procedure jMediaPlayer_SetDataSource(env: PJNIEnv; _jmediaplayer: JObject; _path: string; _filename: string); overload;

procedure jMediaPlayer_Prepare(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_Start(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_Stop(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_Pause(env: PJNIEnv; _jmediaplayer: JObject);
function jMediaPlayer_IsPlaying(env: PJNIEnv; _jmediaplayer: JObject): boolean;
procedure jMediaPlayer_SeekTo(env: PJNIEnv; _jmediaplayer: JObject; _millis: integer);
procedure jMediaPlayer_SetLooping(env: PJNIEnv; _jmediaplayer: JObject; _looping: boolean);
function jMediaPlayer_IsLooping(env: PJNIEnv; _jmediaplayer: JObject): boolean;
procedure jMediaPlayer_SelectTrack(env: PJNIEnv; _jmediaplayer: JObject; _index: integer);
function jMediaPlayer_GetCurrentPosition(env: PJNIEnv; _jmediaplayer: JObject): integer;
function jMediaPlayer_GetDuration(env: PJNIEnv; _jmediaplayer: JObject): integer;
procedure jMediaPlayer_SetVolume(env: PJNIEnv; _jmediaplayer: JObject; _leftVolume: single; _rightVolume: single);

//procedure jMediaPlayer_SetDisplay(env: PJNIEnv; _jmediaplayer: JObject; _surfaceView: jObject);
procedure jMediaPlayer_SetDisplay(env: PJNIEnv; _jmediaplayer: JObject; _surfaceHolder: jObject);

function jMediaPlayer_GetVideoWidth(env: PJNIEnv; _jmediaplayer: JObject): integer;
function jMediaPlayer_GetVideoHeight(env: PJNIEnv; _jmediaplayer: JObject): integer;
procedure jMediaPlayer_SetScreenOnWhilePlaying(env: PJNIEnv; _jmediaplayer: JObject; _value: boolean);
procedure jMediaPlayer_SetAudioStreamType(env: PJNIEnv; _jmediaplayer: JObject; _audioStreamType: integer);
procedure jMediaPlayer_SetSurfaceTexture(env: PJNIEnv; _jmediaplayer: JObject; _surfaceTexture: jObject);
procedure jMediaPlayer_PrepareAsync(env: PJNIEnv; _jmediaplayer: JObject);



implementation

{---------  jMediaPlayer  --------------}

constructor jMediaPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FPaused:= False;
end;

destructor jMediaPlayer.Destroy;
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

procedure jMediaPlayer.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jMediaPlayer.jCreate(): jObject;
begin
   Result:= jMediaPlayer_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jMediaPlayer.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_jFree(FjEnv, FjObject);
end;

procedure jMediaPlayer.DeselectTrack(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_DeselectTrack(FjEnv, FjObject, _index);
end;

procedure jMediaPlayer.Release();
begin
  //in designing component state: set value here...
  FPaused:= False;
  if FInitialized then
     jMediaPlayer_Release(FjEnv, FjObject);
end;

procedure jMediaPlayer.Reset();
begin
  //in designing component state: set value here...
  FPaused:= False;
  if FInitialized then
     jMediaPlayer_Reset(FjEnv, FjObject);
end;

procedure jMediaPlayer.SetDataSource(_path: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetDataSource(FjEnv, FjObject, _path);
end;

procedure jMediaPlayer.Prepare();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_Prepare(FjEnv, FjObject);
end;

procedure jMediaPlayer.Start();
begin
  //in designing component state: set value here...
  FPaused:= False;
  if FInitialized then
     jMediaPlayer_Start(FjEnv, FjObject);
end;

procedure jMediaPlayer.Stop();
begin
  //in designing component state: set value here...
  FPaused:= False;
  if FInitialized then
     jMediaPlayer_Stop(FjEnv, FjObject);
end;

procedure jMediaPlayer.Pause();
begin
  //in designing component state: set value here...
  FPaused:= True;
  if FInitialized then
     jMediaPlayer_Pause(FjEnv, FjObject);
end;

function jMediaPlayer.IsPlaying(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= jMediaPlayer_IsPlaying(FjEnv, FjObject);
end;

function jMediaPlayer.IsPaused(): boolean;
begin
   Result:= FPaused;
end;

procedure jMediaPlayer.SeekTo(_millis: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SeekTo(FjEnv, FjObject, _millis);
end;

procedure jMediaPlayer.SetLooping(_looping: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetLooping(FjEnv, FjObject, _looping);
end;

function jMediaPlayer.IsLooping(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_IsLooping(FjEnv, FjObject);
end;

procedure jMediaPlayer.SelectTrack(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SelectTrack(FjEnv, FjObject, _index);
end;

function jMediaPlayer.GetCurrentPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_GetCurrentPosition(FjEnv, FjObject);
end;

function jMediaPlayer.GetDuration(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_GetDuration(FjEnv, FjObject);
end;

procedure jMediaPlayer.SetVolume(_leftVolume: single; _rightVolume: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetVolume(FjEnv, FjObject, _leftVolume ,_rightVolume);
end;

procedure jMediaPlayer.SetDisplay(_surfaceHolder: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetDisplay(FjEnv, FjObject, _surfaceHolder);
end;

function jMediaPlayer.GetVideoWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_GetVideoWidth(FjEnv, FjObject);
end;

function jMediaPlayer.GetVideoHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_GetVideoHeight(FjEnv, FjObject);
end;

procedure jMediaPlayer.SetScreenOnWhilePlaying(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetScreenOnWhilePlaying(FjEnv, FjObject, _value);
end;

procedure jMediaPlayer.SetAudioStreamType(_audioStreamType: TAudioStreamType);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetAudioStreamType(FjEnv, FjObject, Ord(_audioStreamType));
end;

procedure jMediaPlayer.SetDataSource(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetDataSource(FjEnv, FjObject, _path ,_filename);
end;

procedure jMediaPlayer.SetSurfaceTexture(_surfaceTexture: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_SetSurfaceTexture(FjEnv, FjObject, _surfaceTexture);
end;

procedure jMediaPlayer.PrepareAsync();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_PrepareAsync(FjEnv, FjObject);
end;

procedure jMediaPlayer.GenEvent_OnPrepared(Obj: TObject; videoWidth: integer; videoHeigh: integer);
begin
   if Assigned(FOnPrepared) then FOnPrepared(Obj, videoWidth, videoHeigh);
end;

procedure jMediaPlayer.GenEvent_OnVideoSizeChanged(Obj: TObject; videoWidth: integer; videoHeight: integer);
begin
   if Assigned(FOnVideoSizeChanged) then FOnVideoSizeChanged(Obj, videoWidth, videoHeight);
end;

procedure jMediaPlayer.GenEvent_OnCompletion(Obj: TObject);
begin
   if Assigned(FOnCompletion) then FOnCompletion(Obj);
end;

procedure jMediaPlayer.GenEvent_pOnMediaPlayerTimedText(Obj: TObject; timedText: string);
begin
   if Assigned(FOnTimedText) then FOnTimedText(Obj, timedText);
end;

{-------- jMediaPlayer_JNI_Bridge ----------}

function jMediaPlayer_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMediaPlayer_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jMediaPlayer_jCreate(long _Self) {
      return (java.lang.Object)(new jMediaPlayer(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jMediaPlayer_jFree(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_DeselectTrack(env: PJNIEnv; _jmediaplayer: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'DeselectTrack', '(I)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Release(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Release', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Reset(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Reset', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetDataSource(env: PJNIEnv; _jmediaplayer: JObject; _path: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataSource', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Prepare(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Prepare', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Start(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Stop(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_Pause(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Pause', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMediaPlayer_IsPlaying(env: PJNIEnv; _jmediaplayer: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'IsPlaying', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jmediaplayer, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SeekTo(env: PJNIEnv; _jmediaplayer: JObject; _millis: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _millis;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SeekTo', '(I)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetLooping(env: PJNIEnv; _jmediaplayer: JObject; _looping: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_looping);
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLooping', '(Z)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMediaPlayer_IsLooping(env: PJNIEnv; _jmediaplayer: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'IsLooping', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jmediaplayer, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SelectTrack(env: PJNIEnv; _jmediaplayer: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SelectTrack', '(I)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMediaPlayer_GetCurrentPosition(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCurrentPosition', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMediaPlayer_GetDuration(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDuration', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetVolume(env: PJNIEnv; _jmediaplayer: JObject; _leftVolume: single; _rightVolume: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _leftVolume;
  jParams[1].f:= _rightVolume;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetVolume', '(FF)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetDisplay(env: PJNIEnv; _jmediaplayer: JObject; _surfaceHolder: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _surfaceHolder;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDisplay', '(Landroid/view/SurfaceHolder;)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMediaPlayer_GetVideoWidth(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVideoWidth', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jMediaPlayer_GetVideoHeight(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVideoHeight', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetScreenOnWhilePlaying(env: PJNIEnv; _jmediaplayer: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScreenOnWhilePlaying', '(Z)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetAudioStreamType(env: PJNIEnv; _jmediaplayer: JObject; _audioStreamType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _audioStreamType;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAudioStreamType', '(I)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetDataSource(env: PJNIEnv; _jmediaplayer: JObject; _path: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataSource', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_SetSurfaceTexture(env: PJNIEnv; _jmediaplayer: JObject; _surfaceTexture: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _surfaceTexture;
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSurfaceTexture', '(Landroid/graphics/SurfaceTexture;)V');
  env^.CallVoidMethodA(env, _jmediaplayer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMediaPlayer_PrepareAsync(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'PrepareAsync', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
