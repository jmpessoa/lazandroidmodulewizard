unit textfilemanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [4/21/2014 13:34:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTextFileManager = class(jControl)
 private
    FFilePath: TFilePath;      //fpathData --> /file

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SaveToFile(_txtContent: string; _filename: string);
    function LoadFromFile(_filename: string): string;
    procedure SaveToSdCardFile(_txtContent: string; _filename: string);
    function LoadFromSdCardFile(_filename: string): string;
    function LoadFromAssetsFile(_filename: string): string;
    procedure CopyToClipboard(_text: string);
    function PasteFromClipboard(): string;

 published

end;

function jTextFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jTextFileManager_jFree(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject);
procedure jTextFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
function jTextFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
procedure jTextFileManager_SaveToSdCardFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
function jTextFileManager_LoadFromSdCardFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
function jTextFileManager_LoadFromAssetsFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
procedure jTextFileManager_CopyToClipboard(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _text: string);
function jTextFileManager_PasteFromClipboard(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject): string;

implementation

{---------  jTextFileManager  --------------}

constructor jTextFileManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FFilePath:= fpathData   //--> /data/data/package/file
end;

destructor jTextFileManager.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jTextFileManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
  //your code here...
end;


function jTextFileManager.jCreate(): jObject;
begin
   Result:= jTextFileManager_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jTextFileManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jTextFileManager.SaveToFile(_txtContent: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_SaveToFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _txtContent ,_filename);
end;

function jTextFileManager.LoadFromFile(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_LoadFromFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

procedure jTextFileManager.SaveToSdCardFile(_txtContent: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_SaveToSdCardFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _txtContent ,_filename);
end;

function jTextFileManager.LoadFromSdCardFile(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_LoadFromSdCardFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

function jTextFileManager.LoadFromAssetsFile(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= jTextFileManager_LoadFromAssetsFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetFilePath(FFilePath)+'/'+_filename);
end;

procedure jTextFileManager.CopyToClipboard(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_CopyToClipboard(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _text);
end;

function jTextFileManager.PasteFromClipboard(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_PasteFromClipboard(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

{-------- jTextFileManager_JNI_Bridge ----------}

function jTextFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTextFileManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jTextFileManager_jCreate(long _Self) {
      return (java.lang.Object)(new jTextFileManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jTextFileManager_jFree(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtextfilemanager, jMethod);
end;

procedure jTextFileManager_SaveToFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txtContent));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

function jTextFileManager_LoadFromFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jTextFileManager_SaveToSdCardFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txtContent));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToSdCardFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
end;

function jTextFileManager_LoadFromSdCardFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromSdCardFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jTextFileManager_LoadFromAssetsFile(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssetsFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jTextFileManager_CopyToClipboard(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jTextFileManager_PasteFromClipboard(env: PJNIEnv; this: JObject; _jtextfilemanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtextfilemanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
end;

end.
