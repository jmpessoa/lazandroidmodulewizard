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
    procedure Init; override;
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

function  jSoundPool_jCreate(env: PJNIEnv;_Self: int64; _maxstreams : integer; this: jObject): jObject;
function  jSoundPool_SoundPlay(env: PJNIEnv; _jsoundpool: JObject; soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;


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
       jni_free(gApp.jni.jEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jSoundPool.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jSoundPool_jCreate(gApp.jni.jEnv, int64(Self), FMaxStreams, gApp.jni.jThis);

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jSoundPool.SoundLoad(_path: string; _filename: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_i(gApp.jni.jEnv, FjObject, 'SoundLoad', _path ,_filename);
end;

function jSoundPool.SoundLoad(_path: string): integer;
begin

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(gApp.jni.jEnv, FjObject, 'SoundLoad', _path);
end;

procedure jSoundPool.SoundUnload(soundId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SoundUnload', soundId);
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
   Result:= jSoundPool_SoundPlay(gApp.jni.jEnv, FjObject, soundId ,_leftVolume ,_rightVolume ,_priority ,_loop ,_rate);
end;

procedure jSoundPool.StreamSetVolume(streamId: integer; _leftVolume: single; _rightVolume: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iff(gApp.jni.jEnv, FjObject, 'StreamSetVolume', streamId ,_leftVolume ,_rightVolume);
end;

procedure jSoundPool.StreamSetPriority(streamId: integer; _priority: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(gApp.jni.jEnv, FjObject, 'StreamSetPriority', streamId ,_priority);
end;

procedure jSoundPool.StreamSetLoop(streamId: integer; _loop: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(gApp.jni.jEnv, FjObject, 'StreamSetLoop', streamId ,_loop);
end;

procedure jSoundPool.StreamSetRate(streamId: integer; _rate: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_if(gApp.jni.jEnv, FjObject, 'StreamSetRate', streamId ,_rate);
end;

procedure jSoundPool.StreamPause(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'StreamPause', streamId);
end;

procedure jSoundPool.StreamResume(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'StreamResume', streamId);
end;

procedure jSoundPool.StreamStop(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'StreamStop', streamId);
end;

procedure jSoundPool.PauseAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'PauseAll');
end;

procedure jSoundPool.ResumeAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'ResumeAll');
end;

procedure jSoundPool.GenEvent_OnLoadComplete(Obj: jObject; soundId: integer; status: integer);
begin

  if Assigned(FOnLoadComplete) then FOnLoadComplete(Obj, soundId, status);

end;

{-------- jSoundPool_JNI_Bridge ----------}

function jSoundPool_jCreate(env: PJNIEnv;_Self: int64; _maxstreams : integer; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil; 
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jSoundPool_jCreate', '(JI)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].i:= _maxstreams;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then Result := nil;
end;


function jSoundPool_SoundPlay(env: PJNIEnv; _jsoundpool: JObject; soundId: integer; _leftVolume: single; _rightVolume: single; _priority: integer; _loop: integer; _rate: single): integer;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  Result := 0;

  if (env = nil) or (_jsoundpool = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jsoundpool);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SoundPlay', '(IFFIIF)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= soundId;
  jParams[1].f:= _leftVolume;
  jParams[2].f:= _rightVolume;
  jParams[3].i:= _priority;
  jParams[4].i:= _loop;
  jParams[5].f:= _rate;

  Result:= env^.CallIntMethodA(env, _jsoundpool, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls); 

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := 0;
end;



end.
