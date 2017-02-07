unit mediarecorder;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type


TAudioSource = (asrcDefault=0, asrcMic=1, asrcVoiceUpLink=2, asrcVoiceDownLink=3, asrcVoiceCall=4,
                asrcCamCorder=5, asrcRecognition=6, asrcVoiceCommunication=7);

TVideoSource = (vsrcDefault = 0, vsrcCamCorder = 1);
{
MediaRecorder.AudioSource.DEFAULT; //0
MediaRecorder.AudioSource.MIC; //1
MediaRecorder.AudioSource.VOICE_UPLINK; //2
MediaRecorder.AudioSource.VOICE_DOWNLINK; //3
MediaRecorder.AudioSource.VOICE_CALL; //4

MediaRecorder.AudioSource.CAMCORDER; //5
MediaRecorder.AudioSource.VOICE_RECOGNITION; //6
MediaRecorder.AudioSource.VOICE_COMMUNICATION; //7


}

TOutputFormat = (fmtDefault=0, fmtThreeGpp=1, fmtMpeg4=2,
                 fmtAmrNB=3 , fmtAmrWB=4, fmtAacAdts=6);
{
int i = MediaRecorder.OutputFormat.DEFAULT; // 0
int i = MediaRecorder.OutputFormat.THREE_GPP; //1
int i = MediaRecorder.OutputFormat.MPEG_4; //2
int i = MediaRecorder.OutputFormat.AMR_NB; //3
int i = MediaRecorder.OutputFormat.AMR_WB; //4
int i = MediaRecorder.OutputFormat.AAC_ADTS; //6

}

{Draft Component code by "Lazarus Android Module Wizard" [6/29/2016 1:34:36]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMediaRecorder = class(jControl)
 private
    //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetAudioSource(_audioSource: TAudioSource);
    procedure SetVideoSource(_videoSource: TVideoSource);
    procedure SetOutputFormat(_outputFormat: TOutputFormat);
    procedure SetAudioEncoder(_outputEncoderFormat: TOutputFormat);
    procedure SetOutputFile(_fullPathOutputFilename: string); overload;
    procedure SetOutputFile(_path: string; _outputFilename: string); overload;
    procedure Prepare();
    procedure Start();
    procedure Stop();
 published
      //
end;

function jMediaRecorder_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jMediaRecorder_jFree(env: PJNIEnv; _jmediarecorder: JObject);
procedure jMediaRecorder_SetAudioSource(env: PJNIEnv; _jmediarecorder: JObject; _audioSource: integer);
procedure jMediaRecorder_SetVideoSource(env: PJNIEnv; _jmediarecorder: JObject; _videoSource: integer);
procedure jMediaRecorder_SetOutputFormat(env: PJNIEnv; _jmediarecorder: JObject; _outputFormat: integer);
procedure jMediaRecorder_SetAudioEncoder(env: PJNIEnv; _jmediarecorder: JObject; _outputEncoderFormat: integer);

procedure jMediaRecorder_SetOutputFile(env: PJNIEnv; _jmediarecorder: JObject; _fullPathOutputFilename: string);  overload;
procedure jMediaRecorder_SetOutputFile(env: PJNIEnv; _jmediarecorder: JObject; _path: string; _outputFilename: string); overload;

procedure jMediaRecorder_Prepare(env: PJNIEnv; _jmediarecorder: JObject);
procedure jMediaRecorder_Start(env: PJNIEnv; _jmediarecorder: JObject);
procedure jMediaRecorder_Stop(env: PJNIEnv; _jmediarecorder: JObject);


implementation


{---------  jMediaRecorder  --------------}

constructor jMediaRecorder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jMediaRecorder.Destroy;
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

procedure jMediaRecorder.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jMediaRecorder.jCreate(): jObject;
begin
   Result:= jMediaRecorder_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jMediaRecorder.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_jFree(FjEnv, FjObject);
end;

procedure jMediaRecorder.SetAudioSource(_audioSource: TAudioSource);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetAudioSource(FjEnv, FjObject, Ord(_audioSource));
end;

procedure jMediaRecorder.SetVideoSource(_videoSource: TVideoSource);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetVideoSource(FjEnv, FjObject, Ord(_videoSource));
end;

procedure jMediaRecorder.SetOutputFormat(_outputFormat: TOutputFormat);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetOutputFormat(FjEnv, FjObject, Ord(_outputFormat));
end;

procedure jMediaRecorder.SetAudioEncoder(_outputEncoderFormat: TOutputFormat);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetAudioEncoder(FjEnv, FjObject, Ord(_outputEncoderFormat));
end;

procedure jMediaRecorder.SetOutputFile(_fullPathOutputFilename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetOutputFile(FjEnv, FjObject, _fullPathOutputFilename);
end;

procedure jMediaRecorder.SetOutputFile(_path: string; _outputFilename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_SetOutputFile(FjEnv, FjObject, _path ,_outputFilename);
end;

procedure jMediaRecorder.Prepare();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_Prepare(FjEnv, FjObject);
end;

procedure jMediaRecorder.Start();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_Start(FjEnv, FjObject);
end;

procedure jMediaRecorder.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMediaRecorder_Stop(FjEnv, FjObject);
end;

{-------- jMediaRecorder_JNI_Bridge ----------}

function jMediaRecorder_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMediaRecorder_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jMediaRecorder_jCreate(long _Self) {
      return (java.lang.Object)(new jMediaRecorder(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jMediaRecorder_jFree(env: PJNIEnv; _jmediarecorder: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmediarecorder, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetAudioSource(env: PJNIEnv; _jmediarecorder: JObject; _audioSource: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _audioSource;
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAudioSource', '(I)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetVideoSource(env: PJNIEnv; _jmediarecorder: JObject; _videoSource: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _videoSource;
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetVideoSource', '(I)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetOutputFormat(env: PJNIEnv; _jmediarecorder: JObject; _outputFormat: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _outputFormat;
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOutputFormat', '(I)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetAudioEncoder(env: PJNIEnv; _jmediarecorder: JObject; _outputEncoderFormat: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _outputEncoderFormat;
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAudioEncoder', '(I)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetOutputFile(env: PJNIEnv; _jmediarecorder: JObject; _fullPathOutputFilename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullPathOutputFilename));
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOutputFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_SetOutputFile(env: PJNIEnv; _jmediarecorder: JObject; _path: string; _outputFilename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_outputFilename));
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOutputFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmediarecorder, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_Prepare(env: PJNIEnv; _jmediarecorder: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'Prepare', '()V');
  env^.CallVoidMethod(env, _jmediarecorder, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_Start(env: PJNIEnv; _jmediarecorder: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jmediarecorder, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMediaRecorder_Stop(env: PJNIEnv; _jmediarecorder: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmediarecorder);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jmediarecorder, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
