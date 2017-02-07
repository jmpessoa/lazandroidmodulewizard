unit fileprovider;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TFileProviderSource = (srcResRaw, srcResDrawable, srcInternal, srcAssets);
{Draft Component code by "Lazarus Android Module Wizard" [1/16/2017 1:06:19]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jFileProvider = class(jControl)
 private
    FFileSource: TFileProviderSource;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function GetTextContent(_textfilename: string): string;
    procedure SetAuthorities(_authorities: string);
    procedure SetFileSource(_filesource: TFileProviderSource);

    function GetImageContent(_imagefilename: string): jObject;
    function GetContent(_filename: string): TDynArrayOfJByte;
 published
    property FileSource: TFileProviderSource read FFileSource write SetFileSource;

end;

function jFileProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jFileProvider_jFree(env: PJNIEnv; _jfileprovider: JObject);
function jFileProvider_GetTextContent(env: PJNIEnv; _jfileprovider: JObject; _fileName: string): string;
procedure jFileProvider_SetAuthorities(env: PJNIEnv; _jfileprovider: JObject; _authorities: string);
procedure jFileProvider_SetFileSource(env: PJNIEnv; _jfileprovider: JObject; _filesource: integer);

function jFileProvider_GetImageContent(env: PJNIEnv; _jfileprovider: JObject; _imagefilename: string): jObject;
function jFileProvider_GetContent(env: PJNIEnv; _jfileprovider: JObject; _filename: string): TDynArrayOfJByte;


implementation


{---------  jFileProvider  --------------}

constructor jFileProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
 FFileSource:=  srcInternal;
end;

destructor jFileProvider.Destroy;
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

procedure jFileProvider.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  jFileProvider_SetFileSource(FjEnv, FjObject, Ord(FFileSource));
end;


function jFileProvider.jCreate(): jObject;
begin
   Result:= jFileProvider_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jFileProvider.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFileProvider_jFree(FjEnv, FjObject);
end;

function jFileProvider.GetTextContent(_textfilename: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jFileProvider_GetTextContent(FjEnv, FjObject, _textfilename);
end;

procedure jFileProvider.SetAuthorities(_authorities: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFileProvider_SetAuthorities(FjEnv, FjObject, _authorities);
end;

procedure jFileProvider.SetFileSource(_filesource: TFileProviderSource);
begin
  //in designing component state: set value here...
  FFileSource:= _filesource;
  if FInitialized then
     jFileProvider_SetFileSource(FjEnv, FjObject, Ord(_filesource));
end;

function jFileProvider.GetImageContent(_imagefilename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jFileProvider_GetImageContent(FjEnv, FjObject, _imagefilename);
end;

function jFileProvider.GetContent(_filename: string): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jFileProvider_GetContent(FjEnv, FjObject, _filename);
end;

{-------- jFileProvider_JNI_Bridge ----------}

function jFileProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jFileProvider_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jFileProvider_jCreate(long _Self) {
  return (java.lang.Object)(new jFileProvider(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jFileProvider_jFree(env: PJNIEnv; _jfileprovider: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jfileprovider, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jFileProvider_GetTextContent(env: PJNIEnv; _jfileprovider: JObject; _fileName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextContent', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jfileprovider, jMethod, @jParams);
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

procedure jFileProvider_SetAuthorities(env: PJNIEnv; _jfileprovider: JObject; _authorities: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_authorities));
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAuthorities', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jfileprovider, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jFileProvider_SetFileSource(env: PJNIEnv; _jfileprovider: JObject; _filesource: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _filesource;
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFileSource', '(I)V');
  env^.CallVoidMethodA(env, _jfileprovider, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jFileProvider_GetImageContent(env: PJNIEnv; _jfileprovider: JObject; _imagefilename: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imagefilename));
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'GetImageContent', '(Ljava/lang/String;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jfileprovider, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jFileProvider_GetContent(env: PJNIEnv; _jfileprovider: JObject; _filename: string): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jfileprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'GetContent', '(Ljava/lang/String;)[B');
  jResultArray:= env^.CallObjectMethodA(env, _jfileprovider, jMethod,  @jParams);
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
