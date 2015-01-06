unit mediaplayer;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [4/27/2014 0:21:25]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMediaPlayer = class(jControl)
 private

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
    procedure SetDataSource(_path: string);
    procedure Prepare();
    procedure Start();
    procedure Stop();
    procedure Pause();
    function IsPlaying(): boolean;
    procedure SeekTo(_millis: integer);
    procedure SetLooping(_looping: boolean);
    function IsLooping(): boolean;
    procedure SelectTrack(_index: integer);
    function GetCurrentPosition(): integer;
    function GetDuration(): integer;
    procedure SetVolume(_leftVolume: single; _rightVolume: single);

 published

end;

function jMediaPlayer_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jMediaPlayer_jFree(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_DeselectTrack(env: PJNIEnv; _jmediaplayer: JObject; _index: integer);
procedure jMediaPlayer_Release(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_Reset(env: PJNIEnv; _jmediaplayer: JObject);
procedure jMediaPlayer_SetDataSource(env: PJNIEnv; _jmediaplayer: JObject; _path: string);
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


implementation

{---------  jMediaPlayer  --------------}

constructor jMediaPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
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
  if FInitialized then
     jMediaPlayer_Release(FjEnv, FjObject);
end;

procedure jMediaPlayer.Reset();
begin
  //in designing component state: set value here...
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
  if FInitialized then
     jMediaPlayer_Start(FjEnv, FjObject);
end;

procedure jMediaPlayer.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_Stop(FjEnv, FjObject);
end;

procedure jMediaPlayer.Pause();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaPlayer_Pause(FjEnv, FjObject);
end;

function jMediaPlayer.IsPlaying(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMediaPlayer_IsPlaying(FjEnv, FjObject);
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
end;

procedure jMediaPlayer_Release(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Release', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
end;

procedure jMediaPlayer_Reset(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Reset', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
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
end;

procedure jMediaPlayer_Prepare(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Prepare', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
end;

procedure jMediaPlayer_Start(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
end;

procedure jMediaPlayer_Stop(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
end;

procedure jMediaPlayer_Pause(env: PJNIEnv; _jmediaplayer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'Pause', '()V');
  env^.CallVoidMethod(env, _jmediaplayer, jMethod);
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
end;

function jMediaPlayer_GetCurrentPosition(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCurrentPosition', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
end;

function jMediaPlayer_GetDuration(env: PJNIEnv; _jmediaplayer: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediaplayer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDuration', '()I');
  Result:= env^.CallIntMethod(env, _jmediaplayer, jMethod);
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
end;

end.
