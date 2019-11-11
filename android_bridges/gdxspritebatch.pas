unit gdxspritebatch;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/3/2019 1:18:16]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxSpriteBatch = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure BeginBatch();
    procedure DrawTexture(_texture: jObject; _x: single; _y: single);
    procedure EndBatch();
    procedure SetProjectionMatrix(_matrix4: jObject);
    function GetJInstance(): jObject;
    procedure DrawTextureRegion(_textureRegion: jObject; _x: single; _y: single);
    procedure Dispose();

 published

end;

function jGdxSpriteBatch_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxSpriteBatch_jFree(env: PJNIEnv; _gdxspritebatch: JObject);

procedure jGdxSpriteBatch_BeginBatch(env: PJNIEnv; _gdxspritebatch: JObject);
procedure jGdxSpriteBatch_DrawTexture(env: PJNIEnv; _gdxspritebatch: JObject; _texture: jObject; _x: single; _y: single);
procedure jGdxSpriteBatch_EndBatch(env: PJNIEnv; _gdxspritebatch: JObject);

procedure jGdxSpriteBatch_SetProjectionMatrix(env: PJNIEnv; _jgdxspritebatch: JObject; _matrix4: jObject);
function jGdxSpriteBatch_GetJInstance(env: PJNIEnv; _jgdxspritebatch: JObject): jObject;
procedure jGdxSpriteBatch_DrawTextureRegion(env: PJNIEnv; _jgdxspritebatch: JObject; _textureRegion: jObject; _x: single; _y: single);
procedure jGdxSpriteBatch_Dispose(env: PJNIEnv; _jgdxspritebatch: JObject);

implementation

{---------  jGdxSpriteBatch  --------------}

constructor jGdxSpriteBatch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxSpriteBatch.Destroy;
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

procedure jGdxSpriteBatch.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxSpriteBatch.jCreate(): jObject;
begin
   Result:= jGdxSpriteBatch_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGdxSpriteBatch.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxSpriteBatch_jFree(FjEnv, FjObject);
end;

procedure jGdxSpriteBatch.BeginBatch();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_BeginBatch(FjEnv, FjObject);
end;

procedure jGdxSpriteBatch.DrawTexture(_texture: jObject; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_DrawTexture(FjEnv, FjObject, _texture ,_x ,_y);
end;

procedure jGdxSpriteBatch.EndBatch();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_EndBatch(FjEnv, FjObject);
end;

procedure jGdxSpriteBatch.SetProjectionMatrix(_matrix4: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_SetProjectionMatrix(FjEnv, FjObject, _matrix4);
end;

function jGdxSpriteBatch.GetJInstance(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxSpriteBatch_GetJInstance(FjEnv, FjObject);
end;

procedure jGdxSpriteBatch.DrawTextureRegion(_textureRegion: jObject; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_DrawTextureRegion(FjEnv, FjObject, _textureRegion ,_x ,_y);
end;

procedure jGdxSpriteBatch.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSpriteBatch_Dispose(FjEnv, FjObject);
end;

{-------- jGdxSpriteBatch_JNI_Bridge ----------}

function jGdxSpriteBatch_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxSpriteBatch_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jGdxSpriteBatch_jFree(env: PJNIEnv; _gdxspritebatch: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _gdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _gdxspritebatch, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSpriteBatch_BeginBatch(env: PJNIEnv; _gdxspritebatch: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _gdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'BeginBatch', '()V');
  env^.CallVoidMethod(env, _gdxspritebatch, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxSpriteBatch_DrawTexture(env: PJNIEnv; _gdxspritebatch: JObject; _texture: jObject; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _texture;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _gdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTexture', '(Lcom/badlogic/gdx/graphics/Texture;FF)V');
  env^.CallVoidMethodA(env, _gdxspritebatch, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSpriteBatch_EndBatch(env: PJNIEnv; _gdxspritebatch: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _gdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'EndBatch', '()V');
  env^.CallVoidMethod(env, _gdxspritebatch, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSpriteBatch_SetProjectionMatrix(env: PJNIEnv; _jgdxspritebatch: JObject; _matrix4: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _matrix4;
  jCls:= env^.GetObjectClass(env, _jgdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProjectionMatrix', '(Lcom/badlogic/gdx/math/Matrix4;)V');
  env^.CallVoidMethodA(env, _jgdxspritebatch, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxSpriteBatch_GetJInstance(env: PJNIEnv; _jgdxspritebatch: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '()Lcom/badlogic/gdx/graphics/g2d/SpriteBatch;');
  Result:= env^.CallObjectMethod(env, _jgdxspritebatch, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSpriteBatch_DrawTextureRegion(env: PJNIEnv; _jgdxspritebatch: JObject; _textureRegion: jObject; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _textureRegion;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextureRegion', '(Lcom/badlogic/gdx/graphics/g2d/TextureRegion;FF)V');
  env^.CallVoidMethodA(env, _jgdxspritebatch, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSpriteBatch_Dispose(env: PJNIEnv; _jgdxspritebatch: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxspritebatch);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxspritebatch, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
