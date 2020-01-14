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
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;

function jSoundPool.jCreate(): jObject;
begin
   Result:= jni_create_i(FjEnv, FjThis, Self, 'jSoundPool_jCreate', FMaxStreams);
end;


function jSoundPool.SoundLoad(_path: string; _filename: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_i(FjEnv, FjObject, 'SoundLoad', _path ,_filename);
end;

function jSoundPool.SoundLoad(_path: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(FjEnv, FjObject, 'SoundLoad', _path);
end;

procedure jSoundPool.SoundUnload(soundId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SoundUnload', soundId);
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
     jni_proc_iff(FjEnv, FjObject, 'StreamSetVolume', streamId ,_leftVolume ,_rightVolume);
end;

procedure jSoundPool.StreamSetPriority(streamId: integer; _priority: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(FjEnv, FjObject, 'StreamSetPriority', streamId ,_priority);
end;

procedure jSoundPool.StreamSetLoop(streamId: integer; _loop: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(FjEnv, FjObject, 'StreamSetLoop', streamId ,_loop);
end;

procedure jSoundPool.StreamSetRate(streamId: integer; _rate: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_if(FjEnv, FjObject, 'StreamSetRate', streamId ,_rate);
end;

procedure jSoundPool.StreamPause(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'StreamPause', streamId);
end;

procedure jSoundPool.StreamResume(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'StreamResume', streamId);
end;

procedure jSoundPool.StreamStop(streamId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'StreamStop', streamId);
end;

procedure jSoundPool.PauseAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'PauseAll');
end;

procedure jSoundPool.ResumeAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'ResumeAll');
end;

procedure jSoundPool.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jSoundPool.GenEvent_OnLoadComplete(Obj: jObject; soundId: integer; status: integer);
begin

  if Assigned(FOnLoadComplete) then FOnLoadComplete(Obj, soundId, status);

end;

{-------- jSoundPool_JNI_Bridge ----------}

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



end.
