unit sharefile;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [10/24/2014 21:21:51]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jShareFile = class(jControl)
 private
     FTransitoryEnvironmentDirectory: TEnvDirectory;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    //_mimetype [lowercase!]:  "image/jpeg" or "text/plain" or "image/*" or "*/*" etc...
    procedure ShareFromSdCard(_filename: string; _mimetype: string);
    procedure ShareFromAssets(_filename: string; _mimetype: string);
    procedure ShareFromInternalAppStorage(_filename: string; _mimetype: string);
    procedure ShareFrom(_fullFilename: string; _mimetype: string);
    procedure SetTransitoryEnvironmentDirectory(_index: TEnvDirectory);

 published
    property TransitoryEnvironmentDirectory: TEnvDirectory read FTransitoryEnvironmentDirectory write SetTransitoryEnvironmentDirectory;

end;

function jShareFile_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jShareFile_jFree(env: PJNIEnv; _jsharefile: JObject);
procedure jShareFile_ShareFromSdCard(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
procedure jShareFile_ShareFromAssets(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
procedure jShareFile_ShareFromInternalAppStorage(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
procedure jShareFile_ShareFrom(env: PJNIEnv; _jsharefile: JObject; _fullFilename: string; _mimetype: string);
procedure jShareFile_SetTransitoryEnvironmentDirectory(env: PJNIEnv; _jsharefile: JObject;_index: integer);


implementation

{---------  jShareFile  --------------}

constructor jShareFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FTransitoryEnvironmentDirectory:= dirDownloads;
end;

destructor jShareFile.Destroy;
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

procedure jShareFile.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
  SetTransitoryEnvironmentDirectory(FTransitoryEnvironmentDirectory);
end;


function jShareFile.jCreate(): jObject;
begin
   Result:= jShareFile_jCreate(gApp.jni.jEnv, gApp.jni.jThis , int64(Self));
end;

procedure jShareFile.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jShareFile_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jShareFile.ShareFromSdCard(_filename: string; _mimetype: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jShareFile_ShareFromSdCard(gApp.jni.jEnv, FjObject, _filename ,LowerCase(_mimetype));
end;

procedure jShareFile.ShareFromAssets(_filename: string; _mimetype: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jShareFile_ShareFromAssets(gApp.jni.jEnv, FjObject, _filename ,LowerCase(_mimetype));
end;

procedure jShareFile.ShareFromInternalAppStorage(_filename: string; _mimetype: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jShareFile_ShareFromInternalAppStorage(gApp.jni.jEnv, FjObject, _filename ,LowerCase(_mimetype));
end;

procedure jShareFile.ShareFrom(_fullFilename: string; _mimetype: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jShareFile_ShareFrom(gApp.jni.jEnv, FjObject, _fullFilename ,LowerCase(_mimetype));
end;

procedure jShareFile.SetTransitoryEnvironmentDirectory(_index: TEnvDirectory);
begin
  //in designing component state: set value here...
  if Ord(_index) < 9 then    //only plublics!
    FTransitoryEnvironmentDirectory:= _index
  else
    FTransitoryEnvironmentDirectory:= dirDownloads;

  if FInitialized then
     jShareFile_SetTransitoryEnvironmentDirectory(gApp.jni.jEnv, FjObject, Ord(FTransitoryEnvironmentDirectory));
end;

{-------- jShareFile_JNI_Bridge ----------}

function jShareFile_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jShareFile_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jShareFile_jCreate(long _Self) {
      return (java.lang.Object)(new jShareFile(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jShareFile_jFree(env: PJNIEnv; _jsharefile: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsharefile, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jShareFile_ShareFromSdCard(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mimetype));
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFromSdCard', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsharefile, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jShareFile_ShareFromAssets(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mimetype));
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFromAssets', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsharefile, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jShareFile_ShareFromInternalAppStorage(env: PJNIEnv; _jsharefile: JObject; _filename: string; _mimetype: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mimetype));
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFromInternalAppStorage', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsharefile, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jShareFile_ShareFrom(env: PJNIEnv; _jsharefile: JObject; _fullFilename: string; _mimetype: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullFilename));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_mimetype));
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFrom', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsharefile, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jShareFile_SetTransitoryEnvironmentDirectory(env: PJNIEnv; _jsharefile: JObject;_index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jsharefile);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTransitoryEnvironmentDirectory', '(I)V');
  env^.CallVoidMethodA(env, _jsharefile, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
