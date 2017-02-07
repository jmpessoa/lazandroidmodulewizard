unit downloadservice;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/26/2016 23:50:23]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jDownloadService = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Start(_urlString: string; _intentActionNotification: string);
    procedure SaveToFile(_filepath: string; _filename: string); overload;
    procedure SaveToFile(_filename: string); overload;

 published

end;

function jDownloadService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jDownloadService_jFree(env: PJNIEnv; _jdownloadservice: JObject);
procedure jDownloadService_Start(env: PJNIEnv; _jdownloadservice: JObject; _urlString: string; _intentAction: string);
procedure jDownloadService_SaveToFile(env: PJNIEnv; _jdownloadservice: JObject; _filepath: string; _filename: string); overload;
procedure jDownloadService_SaveToFile(env: PJNIEnv; _jdownloadservice: JObject; _filename: string); overload;


implementation


{---------  jDownloadService  --------------}

constructor jDownloadService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jDownloadService.Destroy;
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

procedure jDownloadService.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jDownloadService.jCreate(): jObject;
begin
   Result:= jDownloadService_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jDownloadService.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadService_jFree(FjEnv, FjObject);
end;

procedure jDownloadService.Start(_urlString: string; _intentActionNotification: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadService_Start(FjEnv, FjObject, _urlString ,_intentActionNotification);
end;

procedure jDownloadService.SaveToFile(_filepath: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadService_SaveToFile(FjEnv, FjObject,_filepath, _filename);
end;

procedure jDownloadService.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadService_SaveToFile(FjEnv, FjObject, _filename);
end;

{-------- jDownloadService_JNI_Bridge ----------}

function jDownloadService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDownloadService_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jDownloadService_jCreate(long _Self) {
      return (java.lang.Object)(new jDownloadService(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jDownloadService_jFree(env: PJNIEnv; _jdownloadservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdownloadservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDownloadService_Start(env: PJNIEnv; _jdownloadservice: JObject; _urlString: string; _intentAction: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_urlString));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jdownloadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadservice, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDownloadService_SaveToFile(env: PJNIEnv; _jdownloadservice: JObject; _filepath: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filepath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jdownloadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadservice, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDownloadService_SaveToFile(env: PJNIEnv; _jdownloadservice: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jdownloadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadservice, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
