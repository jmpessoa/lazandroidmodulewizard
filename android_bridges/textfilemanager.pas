unit textfilemanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

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
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SaveToFile(_txtContent: string; _filename: string); overload;
    procedure SaveToFile(_txtContent: string;_path: string; _filename: string); overload;
    procedure SaveToFile(_txtContent: string; _envDir: TEnvDirectory; _filename: string); overload;
    function LoadFromFile(_filename: string): string; overload;
    function LoadFromFile(_path: string; _filename: string): string; overload;
    function LoadFromFile(_envDir: TEnvDirectory; _filename: string): string; overload;
    procedure SaveToSdCard(_txtContent: string; _filename: string);
    function LoadFromSdCard(_filename: string): string;
    function LoadFromAssets(_filename: string): string;
    procedure CopyToClipboard(_text: string);
    function PasteFromClipboard(): string;
    procedure CopyContentToClipboard(_filename: string);
    procedure PasteContentFromClipboard(_filename: string);
    //by LMB
    function LoadFromAssetsAsJByteArray(_filePath: string): TDynArrayOfJByte;
    function LoadFromAssetsAsStream(_filePath: string): TMemoryStream;
    function LoadFromAssetsAsText(_filePath: string; IsUTF8: boolean): string;


 published

end;

function jTextFileManager_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jTextFileManager_jFree(env: PJNIEnv; _jtextfilemanager: JObject);
procedure jTextFileManager_SaveToFile(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _filename: string); overload;
procedure jTextFileManager_SaveToFile(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _path: string; _filename: string); overload;
function jTextFileManager_LoadFromFile(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string; overload;
function jTextFileManager_LoadFromFile(env: PJNIEnv; _jtextfilemanager: JObject; _path: string; _filename: string): string; overload;
procedure jTextFileManager_SaveToSdCard(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
function jTextFileManager_LoadFromSdCard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string;
function jTextFileManager_LoadFromAssets(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string;
procedure jTextFileManager_CopyToClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _text: string);
function jTextFileManager_PasteFromClipboard(env: PJNIEnv; _jtextfilemanager: JObject): string;

procedure jTextFileManager_CopyContentToClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string);
procedure jTextFileManager_PasteContentFromClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string);
function jTextFileManager_LoadFromAssetsAsJByteArray(env: PJNIEnv; _jtextfilemanager: JObject; _filePath: string): TDynArrayOfJByte;



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
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jTextFileManager.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
  //your code here...
end;


function jTextFileManager.jCreate(): jObject;
begin
   Result:= jTextFileManager_jCreate(gApp.jni.jEnv, gApp.jni.jThis , int64(Self));
end;

procedure jTextFileManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jTextFileManager.SaveToFile(_txtContent: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_SaveToFile(gApp.jni.jEnv, FjObject, _txtContent ,_filename);
end;

procedure jTextFileManager.SaveToFile(_txtContent: string; _path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_SaveToFile(gApp.jni.jEnv, FjObject, _txtContent ,_path, _filename);
end;

procedure jTextFileManager.SaveToFile(_txtContent: string; _envDir: TEnvDirectory; _filename: string);
begin
  //in designing component state: set value here...
  SaveToFile(_txtContent, (Self.Owner as jForm).GetEnvironmentDirectoryPath(_envDir) ,_filename);
end;

function jTextFileManager.LoadFromFile(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_LoadFromFile(gApp.jni.jEnv, FjObject, _filename);
end;

function jTextFileManager.LoadFromFile(_path: string; _filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_LoadFromFile(gApp.jni.jEnv, FjObject,_path, _filename);
end;

function jTextFileManager.LoadFromFile(_envDir: TEnvDirectory; _filename: string): string; overload;
begin
  Result:= LoadFromFile( (Self.Owner as jForm).GetEnvironmentDirectoryPath(_envDir) ,_filename);
end;

procedure jTextFileManager.SaveToSdCard(_txtContent: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_SaveToSdCard(gApp.jni.jEnv, FjObject, _txtContent ,_filename);
end;

function jTextFileManager.LoadFromSdCard(_filename: string): string;
begin
  //in designing component state: result value here...
  Result:= '';
  if FInitialized then
   Result:= jTextFileManager_LoadFromSdCard(gApp.jni.jEnv, FjObject, _filename);
end;

function jTextFileManager.LoadFromAssets(_filename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= jTextFileManager_LoadFromAssets(gApp.jni.jEnv, FjObject, _filename);
end;

procedure jTextFileManager.CopyToClipboard(_text: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTextFileManager_CopyToClipboard(gApp.jni.jEnv, FjObject, _text);
end;

function jTextFileManager.PasteFromClipboard(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_PasteFromClipboard(gApp.jni.jEnv, FjObject);
end;

procedure jTextFileManager.CopyContentToClipboard(_filename: string);
begin
  //in designing component state: result value here...
  if FInitialized then
     jTextFileManager_CopyContentToClipboard(gApp.jni.jEnv, FjObject, _filename);
end;

procedure jTextFileManager.PasteContentFromClipboard(_filename: string);
begin
  //in designing component state: result value here...
  if FInitialized then
     jTextFileManager_PasteContentFromClipboard(gApp.jni.jEnv, FjObject, _filename);
end;

//LMB
function jTextFileManager.LoadFromAssetsAsJByteArray(_filePath: string): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTextFileManager_LoadFromAssetsAsJByteArray(gApp.jni.jEnv, FjObject, _filePath);
end;

//LMB
function jTextFileManager.LoadFromAssetsAsStream(_filePath: string): TMemoryStream;
var
  buf: TDynArrayOfJByte;
begin
  buf := LoadFromAssetsAsJByteArray(_filePath);
  result := TMemoryStream.Create;
  if length(buf) > 0 then begin
    result.Write(buf[0], length(buf));
    result.Seek(0,0);  // position stream for reading
  end;
end;

//LMB
function jTextFileManager.LoadFromAssetsAsText(_filePath: string; IsUTF8: boolean): string;
var
  s: AnsiString; L: integer; buf: TDynArrayOfJByte;
begin
  s := '';
  result:= '';
  buf:= LoadFromAssetsAsJByteArray(_filePath);
  L:= length(buf);
  if L = 0 then exit; // file not found or empty
  SetLength(s, L); // copy buffer to string
  move(buf[0], s[1], length(buf));
  if IsUTF8 then //
    result := Utf8Decode(s)  //Warning: Implicit string type conversion with potential data loss from "UnicodeString" to "AnsiString"
  else
    result := s;
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

procedure jTextFileManager_jFree(env: PJNIEnv; _jtextfilemanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtextfilemanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_SaveToFile(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
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
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_SaveToFile(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _path: string; _filename: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txtContent));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_LoadFromFile(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string;
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
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_LoadFromFile(env: PJNIEnv; _jtextfilemanager: JObject;_path: string; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_SaveToSdCard(env: PJNIEnv; _jtextfilemanager: JObject; _txtContent: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_txtContent));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToSdCard', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_LoadFromSdCard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromSdCard', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_LoadFromAssets(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssets', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_CopyToClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _text: string);
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
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_PasteFromClipboard(env: PJNIEnv; _jtextfilemanager: JObject): string;
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
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_CopyContentToClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyContentToClipboard', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTextFileManager_PasteContentFromClipboard(env: PJNIEnv; _jtextfilemanager: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteContentFromClipboard', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtextfilemanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jTextFileManager_LoadFromAssetsAsJByteArray(env: PJNIEnv; _jtextfilemanager: JObject; _filePath: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  Result := nil;
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jCls:= env^.GetObjectClass(env, _jtextfilemanager);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssetsAsJByteArray', '(Ljava/lang/String;)[B');
  jResultArray:= env^.CallObjectMethodA(env, _jtextfilemanager, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
