unit gdxtextureregion;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/15/2019 2:28:48]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxTextureRegion = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetTextures(_textureAtlas: jObject);
    function GetRegion(_region: string): jObject;
    procedure Dispose();

 published

end;

function jGdxTextureRegion_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxTextureRegion_jFree(env: PJNIEnv; _jgdxtextureregion: JObject);
procedure jGdxTextureRegion_SetTextures(env: PJNIEnv; _jgdxtextureregion: JObject; _textureAtlas: jObject);
function jGdxTextureRegion_GetRegion(env: PJNIEnv; _jgdxtextureregion: JObject; _region: string): jObject;
procedure jGdxTextureRegion_Dispose(env: PJNIEnv; _jgdxtextureregion: JObject);

implementation

{---------  jGdxTextureRegion  --------------}

constructor jGdxTextureRegion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxTextureRegion.Destroy;
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

procedure jGdxTextureRegion.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jGdxTextureRegion.jCreate(): jObject;
begin
   Result:= jGdxTextureRegion_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGdxTextureRegion.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxTextureRegion_jFree(FjEnv, FjObject);
end;

procedure jGdxTextureRegion.SetTextures(_textureAtlas: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxTextureRegion_SetTextures(FjEnv, FjObject, _textureAtlas);
end;

function jGdxTextureRegion.GetRegion(_region: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTextureRegion_GetRegion(FjEnv, FjObject, _region);
end;

procedure jGdxTextureRegion.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxTextureRegion_Dispose(FjEnv, FjObject);
end;

{-------- jGdxTextureRegion_JNI_Bridge ----------}

function jGdxTextureRegion_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxTextureRegion_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxTextureRegion_jFree(env: PJNIEnv; _jgdxtextureregion: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxtextureregion);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxtextureregion, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxTextureRegion_SetTextures(env: PJNIEnv; _jgdxtextureregion: JObject; _textureAtlas: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _textureAtlas;
  jCls:= env^.GetObjectClass(env, _jgdxtextureregion);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextures', '(Lcom/badlogic/gdx/graphics/g2d/TextureAtlas;)V');
  env^.CallVoidMethodA(env, _jgdxtextureregion, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTextureRegion_GetRegion(env: PJNIEnv; _jgdxtextureregion: JObject; _region: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_region));
  jCls:= env^.GetObjectClass(env, _jgdxtextureregion);
  jMethod:= env^.GetMethodID(env, jCls, 'GetRegion', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/g2d/TextureRegion;');
  Result:= env^.CallObjectMethodA(env, _jgdxtextureregion, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxTextureRegion_Dispose(env: PJNIEnv; _jgdxtextureregion: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxtextureregion);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxtextureregion, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
