unit gdxtextureatlas;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/15/2019 2:26:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxTextureAtlas = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure LoadPackFromAssets(_packFilename: string);
    function GetTextureRegion(_region: string): jObject;
    function GetJInstance(): jObject;
    function CreateSprite(_region: string): jObject;
    procedure Dispose();

 published

end;

function jGdxTextureAtlas_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxTextureAtlas_jFree(env: PJNIEnv; _jgdxtextureatlas: JObject);

procedure jGdxTextureAtlas_LoadPackFromAssets(env: PJNIEnv; _jgdxtextureatlas: JObject; _packFilename: string);
function jGdxTextureAtlas_GetTextureRegion(env: PJNIEnv; _jgdxtextureatlas: JObject; _region: string): jObject;
function jGdxTextureAtlas_GetJInstance(env: PJNIEnv; _jgdxtextureatlas: JObject): jObject;
function jGdxTextureAtlas_CreateSprite(env: PJNIEnv; _jgdxtextureatlas: JObject; _region: string): jObject;
procedure jGdxTextureAtlas_Dispose(env: PJNIEnv; _jgdxtextureatlas: JObject);

implementation

{---------  jGdxTextureAtlas  --------------}

constructor jGdxTextureAtlas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxTextureAtlas.Destroy;
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

procedure jGdxTextureAtlas.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxTextureAtlas.jCreate(): jObject;
begin
   Result:= jGdxTextureAtlas_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGdxTextureAtlas.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxTextureAtlas_jFree(FjEnv, FjObject);
end;

procedure jGdxTextureAtlas.LoadPackFromAssets(_packFilename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxTextureAtlas_LoadPackFromAssets(FjEnv, FjObject, _packFilename);
end;

function jGdxTextureAtlas.GetTextureRegion(_region: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTextureAtlas_GetTextureRegion(FjEnv, FjObject, _region);
end;

function jGdxTextureAtlas.GetJInstance(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTextureAtlas_GetJInstance(FjEnv, FjObject);
end;

function jGdxTextureAtlas.CreateSprite(_region: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxTextureAtlas_CreateSprite(FjEnv, FjObject, _region);
end;

procedure jGdxTextureAtlas.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxTextureAtlas_Dispose(FjEnv, FjObject);
end;

{-------- jGdxTextureAtlas_JNI_Bridge ----------}

function jGdxTextureAtlas_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxTextureAtlas_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jGdxTextureAtlas_jFree(env: PJNIEnv; _jgdxtextureatlas: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxtextureatlas, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxTextureAtlas_LoadPackFromAssets(env: PJNIEnv; _jgdxtextureatlas: JObject; _packFilename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packFilename));
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadPackFromAssets', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jgdxtextureatlas, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTextureAtlas_GetTextureRegion(env: PJNIEnv; _jgdxtextureatlas: JObject; _region: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_region));
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextureRegion', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/g2d/TextureRegion;');
  Result:= env^.CallObjectMethodA(env, _jgdxtextureatlas, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTextureAtlas_GetJInstance(env: PJNIEnv; _jgdxtextureatlas: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '()Lcom/badlogic/gdx/graphics/g2d/TextureAtlas;');
  Result:= env^.CallObjectMethod(env, _jgdxtextureatlas, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxTextureAtlas_CreateSprite(env: PJNIEnv; _jgdxtextureatlas: JObject; _region: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_region));
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateSprite', '(Ljava/lang/String;)Lcom/badlogic/gdx/graphics/g2d/Sprite;');
  Result:= env^.CallObjectMethodA(env, _jgdxtextureatlas, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxTextureAtlas_Dispose(env: PJNIEnv; _jgdxtextureatlas: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxtextureatlas);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxtextureatlas, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
