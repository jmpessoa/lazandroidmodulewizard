unit downloadmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/27/2016 18:17:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jDownloadManager = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetNotification(_title: string; _description: string);
    procedure SaveToFile(_pathEnv: TEnvDirectory; _filname: string); overload;
    function Start(_urlString: string): TAndroidResult;
    function GetActionDownloadComplete(): string;
    function GetExtras(_intent: jObject; _delimiter: string): string;

    procedure SaveToFile(_filename: string); overload;
    function GetElapsedTimeInSeconds(): integer;

    function GetLocalUriAsString(): string; overload;
    function GetLocalFileName(): string; overload;
    function GetMediaType(): string; overload;
    function GetFileSizeBytes(): integer; overload;
    function GetFileUri(): jObject; overload;

    function GetLocalUriAsString(_intent: jObject): string; overload;
    function GetLocalFileName(_intent: jObject): string; overload;
    function GetMediaType(_intent: jObject): string; overload;
    function GetFileSizeBytes(_intent: jObject): integer; overload;
    function GetFileUri(_intent: jObject): jObject; overload;

 published

end;

function jDownloadManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jDownloadManager_jFree(env: PJNIEnv; _jdownloadmanager: JObject);
procedure jDownloadManager_SetNotification(env: PJNIEnv; _jdownloadmanager: JObject; _title: string; _description: string);
procedure jDownloadManager_SaveToFile(env: PJNIEnv; _jdownloadmanager: JObject; _path: integer; _filname: string); overload;
function jDownloadManager_Start(env: PJNIEnv; _jdownloadmanager: JObject; _urlString: string): integer;
function jDownloadManager_GetActionDownloadComplete(env: PJNIEnv; _jdownloadmanager: JObject): string;
function jDownloadManager_GetExtras(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject; _delimiter: string): string;

procedure jDownloadManager_SaveToFile(env: PJNIEnv; _jdownloadmanager: JObject; _filname: string); overload;
function jDownloadManager_GetElapsedTimeInSeconds(env: PJNIEnv; _jdownloadmanager: JObject): integer;

function jDownloadManager_GetLocalUriAsString(env: PJNIEnv; _jdownloadmanager: JObject): string; overload;
function jDownloadManager_GetLocalFileName(env: PJNIEnv; _jdownloadmanager: JObject): string; overload;
function jDownloadManager_GetMediaType(env: PJNIEnv; _jdownloadmanager: JObject): string; overload;
function jDownloadManager_GetFileSizeBytes(env: PJNIEnv; _jdownloadmanager: JObject): integer; overload;
function jDownloadManager_GetFileUri(env: PJNIEnv; _jdownloadmanager: JObject): jObject; overload;

function jDownloadManager_GetLocalUriAsString(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string; overload;
function jDownloadManager_GetLocalFileName(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string; overload;
function jDownloadManager_GetMediaType(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string; overload;
function jDownloadManager_GetFileSizeBytes(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): integer; overload;
function jDownloadManager_GetFileUri(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): jObject; overload;


implementation


{---------  jDownloadManager  --------------}

constructor jDownloadManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jDownloadManager.Destroy;
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

procedure jDownloadManager.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jDownloadManager.jCreate(): jObject;
begin
   Result:= jDownloadManager_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jDownloadManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadManager_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jDownloadManager.SetNotification(_title: string; _description: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadManager_SetNotification(gApp.jni.jEnv, FjObject, _title ,_description);
end;

procedure jDownloadManager.SaveToFile(_pathEnv: TEnvDirectory; _filname: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadManager_SaveToFile(gApp.jni.jEnv, FjObject, Ord(_pathEnv) ,_filname);
end;

function jDownloadManager.Start(_urlString: string): TAndroidResult;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TAndroidResult(jDownloadManager_Start(gApp.jni.jEnv, FjObject, _urlString));
end;

function jDownloadManager.GetActionDownloadComplete(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetActionDownloadComplete(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetExtras(_intent: jObject; _delimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetExtras(gApp.jni.jEnv, FjObject, _intent ,_delimiter);
end;

function jDownloadManager.GetLocalUriAsString(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetLocalUriAsString(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetLocalFileName(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetLocalFileName(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetMediaType(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetMediaType(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetFileSizeBytes(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetFileSizeBytes(gApp.jni.jEnv, FjObject);
end;

procedure jDownloadManager.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDownloadManager_SaveToFile(gApp.jni.jEnv, FjObject, _filename);
end;

function jDownloadManager.GetElapsedTimeInSeconds(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetElapsedTimeInSeconds(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetFileUri(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetFileUri(gApp.jni.jEnv, FjObject);
end;

function jDownloadManager.GetLocalUriAsString(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetLocalUriAsString(gApp.jni.jEnv, FjObject, _intent);
end;

function jDownloadManager.GetLocalFileName(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetLocalFileName(gApp.jni.jEnv, FjObject, _intent);
end;

function jDownloadManager.GetMediaType(_intent: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetMediaType(gApp.jni.jEnv, FjObject, _intent);
end;

function jDownloadManager.GetFileSizeBytes(_intent: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetFileSizeBytes(gApp.jni.jEnv, FjObject, _intent);
end;

function jDownloadManager.GetFileUri(_intent: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDownloadManager_GetFileUri(gApp.jni.jEnv, FjObject, _intent);
end;

function jDownloadManager_GetLocalUriAsString(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLocalUriAsString', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdownloadmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetLocalFileName(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLocalFileName', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdownloadmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetMediaType(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMediaType', '(Landroid/content/Intent;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdownloadmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetFileSizeBytes(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileSizeBytes', '(Landroid/content/Intent;)I');
  Result:= env^.CallIntMethodA(env, _jdownloadmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetFileUri(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileUri', '(Landroid/content/Intent;)Landroid/net/Uri;');
  Result:= env^.CallObjectMethodA(env, _jdownloadmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

{-------- jDownloadManager_JNI_Bridge ----------}

function jDownloadManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDownloadManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jDownloadManager_jCreate(long _Self) {
      return (java.lang.Object)(new jDownloadManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jDownloadManager_jFree(env: PJNIEnv; _jdownloadmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdownloadmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDownloadManager_SetNotification(env: PJNIEnv; _jdownloadmanager: JObject; _title: string; _description: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_description));
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNotification', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDownloadManager_SaveToFile(env: PJNIEnv; _jdownloadmanager: JObject; _path: integer; _filname: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _path;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filname));
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_Start(env: PJNIEnv; _jdownloadmanager: JObject; _urlString: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_urlString));
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jdownloadmanager, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetActionDownloadComplete(env: PJNIEnv; _jdownloadmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActionDownloadComplete', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdownloadmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetExtras(env: PJNIEnv; _jdownloadmanager: JObject; _intent: jObject; _delimiter: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetExtras', '(Landroid/content/Intent;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdownloadmanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetLocalUriAsString(env: PJNIEnv; _jdownloadmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLocalUriAsString', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdownloadmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetLocalFileName(env: PJNIEnv; _jdownloadmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLocalFileName', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdownloadmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jDownloadManager_GetMediaType(env: PJNIEnv; _jdownloadmanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMediaType', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdownloadmanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetFileSizeBytes(env: PJNIEnv; _jdownloadmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileSizeBytes', '()I');
  Result:= env^.CallIntMethod(env, _jdownloadmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDownloadManager_SaveToFile(env: PJNIEnv; _jdownloadmanager: JObject; _filname: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filname));
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdownloadmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetElapsedTimeInSeconds(env: PJNIEnv; _jdownloadmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetElapsedTimeInSeconds', '()I');
  Result:= env^.CallIntMethod(env, _jdownloadmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jDownloadManager_GetFileUri(env: PJNIEnv; _jdownloadmanager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdownloadmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFileUri', '()Landroid/net/Uri;');
  Result:= env^.CallObjectMethod(env, _jdownloadmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
