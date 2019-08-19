unit soundpool;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

 TOnLoadComplete = procedure(Sender: TObject; soundId: integer; status: integer) of Object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [12/08/2019 9:44:33]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSoundPool = class(jControl)
 private
    FOnLoadComplete: TOnLoadComplete;
    FMaxStreams : integer;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function  SoundLoad(_path: string; _filename: string): integer; overload;
    function  SoundLoad(_path: string): integer; overload;
    procedure SoundUnload(soundId: integer);
    function  SoundPlay(soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;
    procedure StreamSetVolume(streamId: integer; _leftVolume: single; _rightVolume: single);
    procedure StreamSetPriority(streamId: integer; _priority: integer);
    procedure StreamSetLoop(streamId: integer; _loop: integer);
    procedure StreamSetRate(streamId: integer; _rate: single);
    procedure StreamPause(streamId: integer);
    procedure StreamResume(streamId: integer);
    procedure StreamStop(streamId: integer);
    procedure PauseAll();
    procedure ResumeAll();

    procedure GenEvent_OnLoadComplete(Obj: jObject; soundId: integer; status: integer);
 published
   property MaxStreams : integer read FMaxStreams write FMaxStreams;
   property OnLoadComplete: TOnLoadComplete read FOnLoadComplete write FOnLoadComplete;
end;

function  jSoundPool_jCreate(env: PJNIEnv;_Self: int64; this: jObject; _maxStreams : integer): jObject;
function  jSoundPool_SoundLoad(env: PJNIEnv; _jsoundpool: JObject; _path: string; _filename: string): integer; overload;
function  jSoundPool_SoundLoad(env: PJNIEnv; _jsoundpool: JObject; _path: string): integer; overload;
procedure jSoundPool_SoundUnload(env: PJNIEnv; _jsoundpool: JObject; soundId: integer);
function  jSoundPool_SoundPlay(env: PJNIEnv; _jsoundpool: JObject; soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;
procedure jSoundPool_StreamSetVolume(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _leftVolume: single; _rightVolume: single);
procedure jSoundPool_StreamSetPriority(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _priority: integer);
procedure jSoundPool_StreamSetLoop(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _loop: integer);
procedure jSoundPool_StreamSetRate(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _rate: single);
procedure jSoundPool_StreamPause(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
procedure jSoundPool_StreamResume(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
procedure jSoundPool_StreamStop(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
procedure jSoundPool_PauseAll(env: PJNIEnv; _jsoundpool: JObject);
procedure jSoundPool_ResumeAll(env: PJNIEnv; _jsoundpool: JObject);
procedure jSoundPool_jFree(env: PJNIEnv; _jsoundpool: JObject);


implementation

{---------  jSoundPool  --------------}

constructor jSoundPool.Create(AOwner: TComponent);
begin
 FMaxStreams := 5;

 inherited Create(AOwner);
 //your code here....
end;

destructor jSoundPool.Destroy;
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

procedure jSoundPool.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jSoundPool.jCreate(): jObject;
begin
   Result:= jSoundPool_jCreate(FjEnv, int64(Self), FjThis, FMaxStreams);
end;


function jSoundPool.SoundLoad(_path: string; _filename: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSoundPool_SoundLoad(FjEnv, FjObject, _path ,_filename);
end;

function jSoundPool.SoundLoad(_path: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSoundPool_SoundLoad(FjEnv, FjObject, _path);
end;

procedure jSoundPool.SoundUnload(soundId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_SoundUnload(FjEnv, FjObject, soundId);
end;

(*
     * priority : Example: 1 has less priority than 10,
     *            it will stop those with lower priority.
     *            If you reach the maximum number of sounds allowed
     *
     * loop     : -1 Infinite loop should call the soundStop function to stop the sound.
     *          : 0  Without loop
     *          : Any other non-zero value will cause the sound to repeat the specified
     *            number of times, e.g. a value of 3 causes the sound to play a total of 4 times
     *
     * rate     : The playback rate can also be changed
     *          :  1.0 causes the sound to play at its original
     *          :  The playback rate range is 0.5 to 2.0
     *
     * return streamId of sound;
     * *)

function jSoundPool.SoundPlay(soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSoundPool_SoundPlay(FjEnv, FjObject, soundId ,_leftVolume ,_rightVolume ,_priority ,_loop ,_rate);
end;

procedure jSoundPool.StreamSetVolume(streamId: integer; _leftVolume: single; _rightVolume: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamSetVolume(FjEnv, FjObject, streamId ,_leftVolume ,_rightVolume);
end;

procedure jSoundPool.StreamSetPriority(streamId: integer; _priority: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamSetPriority(FjEnv, FjObject, streamId ,_priority);
end;

procedure jSoundPool.StreamSetLoop(streamId: integer; _loop: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamSetLoop(FjEnv, FjObject, streamId ,_loop);
end;

procedure jSoundPool.StreamSetRate(streamId: integer; _rate: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamSetRate(FjEnv, FjObject, streamId ,_rate);
end;

procedure jSoundPool.StreamPause(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamPause(FjEnv, FjObject, streamId);
end;

procedure jSoundPool.StreamResume(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamResume(FjEnv, FjObject, streamId);
end;

procedure jSoundPool.StreamStop(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_StreamStop(FjEnv, FjObject, streamId);
end;

procedure jSoundPool.PauseAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_PauseAll(FjEnv, FjObject);
end;

procedure jSoundPool.ResumeAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_ResumeAll(FjEnv, FjObject);
end;

procedure jSoundPool.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSoundPool_jFree(FjEnv, FjObject);
end;

procedure jSoundPool.GenEvent_OnLoadComplete(Obj: jObject; soundId: integer; status: integer);
begin

  if Assigned(FOnLoadComplete) then FOnLoadComplete(Obj, soundId, status);

end;

{-------- jSoundPool_JNI_Bridge ----------}

function jSoundPool_jCreate(env: PJNIEnv;_Self: int64; this: jObject; _maxStreams : integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _maxStreams;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSoundPool_jCreate', '(JI)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


function jSoundPool_SoundLoad(env: PJNIEnv; _jsoundpool: JObject; _path: string; _filename: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'SoundLoad', '(Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jsoundpool, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jSoundPool_SoundLoad(env: PJNIEnv; _jsoundpool: JObject; _path: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'SoundLoad', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jsoundpool, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_SoundUnload(env: PJNIEnv; _jsoundpool: JObject; soundId: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= soundId;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'SoundUnload', '(I)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSoundPool_SoundPlay(env: PJNIEnv; _jsoundpool: JObject; soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= soundId;
  jParams[1].f:= _leftVolume;
  jParams[2].f:= _rightVolume;
  jParams[3].i:= _priority;
  jParams[4].i:= _loop;
  jParams[5].f:= _rate;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'SoundPlay', '(IFFIIF)I');
  Result:= env^.CallIntMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamSetVolume(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _leftVolume: single; _rightVolume: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jParams[1].f:= _leftVolume;
  jParams[2].f:= _rightVolume;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamSetVolume', '(IFF)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamSetPriority(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _priority: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jParams[1].i:= _priority;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamSetPriority', '(II)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamSetLoop(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _loop: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jParams[1].i:= _loop;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamSetLoop', '(II)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamSetRate(env: PJNIEnv; _jsoundpool: JObject; streamId: integer; _rate: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jParams[1].f:= _rate;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamSetRate', '(IF)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamPause(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamPause', '(I)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamResume(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamResume', '(I)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_StreamStop(env: PJNIEnv; _jsoundpool: JObject; streamId: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= streamId;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'StreamStop', '(I)V');
  env^.CallVoidMethodA(env, _jsoundpool, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_PauseAll(env: PJNIEnv; _jsoundpool: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'PauseAll', '()V');
  env^.CallVoidMethod(env, _jsoundpool, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_ResumeAll(env: PJNIEnv; _jsoundpool: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'ResumeAll', '()V');
  env^.CallVoidMethod(env, _jsoundpool, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSoundPool_jFree(env: PJNIEnv; _jsoundpool: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsoundpool, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
