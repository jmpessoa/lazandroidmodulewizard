unit gdxtexture;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/3/2019 1:38:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxTexture = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    //function GetNew(_assetsImageFile: string): jObject;
    function GetJInstance(_assetsFileName: string): jObject; overload;
    function GetJInstance(): jObject; overload;
    function LoadFromAssets(_assetsFilename: string): jObject;
    procedure Dispose();

 published

end;

function jGdxTexture_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxTexture_jFree(env: PJNIEnv; _gdxtexture: JObject);
function jGdxTexture_GetNew(env: PJNIEnv; _gdxtexture: JObject; _assetsImageFile: string): jObject;
function jGdxTexture_GetJInstance(env: PJNIEnv; _gdxtexture: JObject; _assetsFileName: string): jObject;overload;
function jGdxTexture_GetJInstance(env: PJNIEnv; _jgdxtexture: JObject): jObject;overload;
function jGdxTexture_LoadFromAssets(env: PJNIEnv; _jgdxtexture: JObject; _assetsFilename: string): jObject;
procedure jGdxTexture_Dispose(env: PJNIEnv; _jgdxtexture: JObject);

implementation

{---------  gdxTexture  --------------}

constructor jGdxTexture.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jGdxTexture.Destroy;
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

procedure jGdxTexture.Init;
begin
  if FInitialized then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jGdxTexture.jCreate(): jObject;
begin
  Result:= jGdxTexture_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jGdxTexture.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxTexture_jFree(gApp.jni.jEnv, FjObject);
end;

(*
function jGdxTexture.GetNew(_assetsImageFile: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTexture_GetNew(gApp.jni.jEnv, FjObject, _assetsImageFile);
end;
*)

function jGdxTexture.GetJInstance(_assetsFileName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTexture_GetJInstance(gApp.jni.jEnv, FjObject, _assetsFileName);
end;

function jGdxTexture.GetJInstance(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTexture_GetJInstance(gApp.jni.jEnv, FjObject);
end;

function jGdxTexture.LoadFromAssets(_assetsFilename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTexture_LoadFromAssets(gApp.jni.jEnv, FjObject, _assetsFilename);
end;

procedure jGdxTexture.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxTexture_Dispose(gApp.jni.jEnv, FjObject);
end;

{-------- gdxTexture_JNI_Bridge ----------}

function jGdxTexture_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxTexture_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxTexture_jFree(env: PJNIEnv; _gdxtexture: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _gdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _gdxtexture, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTexture_GetNew(env: PJNIEnv; _gdxtexture: JObject; _assetsImageFile: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_assetsImageFile));
  jCls:= env^.GetObjectClass(env, _gdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNew', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/Texture;');
  Result:= env^.CallObjectMethodA(env, _gdxtexture, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTexture_GetJInstance(env: PJNIEnv; _gdxtexture: JObject; _assetsFileName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_assetsFileName));
  jCls:= env^.GetObjectClass(env, _gdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/Texture;');
  Result:= env^.CallObjectMethodA(env, _gdxtexture, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTexture_GetJInstance(env: PJNIEnv; _jgdxtexture: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '()Lcom/badlogic/gdx/graphics/Texture;');
  Result:= env^.CallObjectMethod(env, _jgdxtexture, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTexture_LoadFromAssets(env: PJNIEnv; _jgdxtexture: JObject; _assetsFilename: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_assetsFilename));
  jCls:= env^.GetObjectClass(env, _jgdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssets', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/Texture;');
  Result:= env^.CallObjectMethodA(env, _jgdxtexture, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxTexture_Dispose(env: PJNIEnv; _jgdxtexture: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxtexture);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxtexture, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
