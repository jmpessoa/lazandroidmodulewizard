unit gdxsprite;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/16/2019 0:46:07]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxSprite = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetPosition(_x: single; _y: single);  overload;
    procedure SetRotation(_degrees: single);  overload;
    procedure SetSprite(_sprite: jObject); overload;
    procedure Translate(_offsetX: single; _offsetY: single); overload;
    procedure Rotate90(_clockwise: boolean); overload;
    procedure Rotate(_degrees: single); overload;
    procedure Draw(_batch: jObject; _x: single; _y: single); overload;

    procedure SetSprite(_sprite: jObject; _scale: single); overload;
    procedure SetSprites(_textureAtlas: jObject); overload;
    procedure SetSprites(_textureAtlas: jObject; _scale: single); overload;
    procedure Draw(_batch: jObject; _sprite: string; _x: single; _y: single); overload;
    procedure SetPosition(_sprite: string; _x: single; _y: single); overload;
    procedure SetRotation(_sprite: string; _degrees: single); overload;
    procedure Translate(_sprite: string; _offsetX: single; _offsetY: single); overload;
    procedure Rotate90(_sprite: string; _clockwise: boolean); overload;
    procedure Rotate(_sprite: string; _degrees: single); overload;
    procedure Dispose();

 published

end;

function jGdxSprite_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxSprite_jFree(env: PJNIEnv; _jgdxsprite: JObject);

procedure jGdxSprite_SetPosition(env: PJNIEnv; _jgdxsprite: JObject; _x: single; _y: single); overload;
procedure jGdxSprite_SetRotation(env: PJNIEnv; _jgdxsprite: JObject; _degrees: single); overload;
procedure jGdxSprite_SetSprite(env: PJNIEnv; _jgdxsprite: JObject; _sprite: jObject); overload;
procedure jGdxSprite_Translate(env: PJNIEnv; _jgdxsprite: JObject; _offsetX: single; _offsetY: single); overload;
procedure jGdxSprite_Rotate90(env: PJNIEnv; _jgdxsprite: JObject; _clockwise: boolean); overload;
procedure jGdxSprite_Rotate(env: PJNIEnv; _jgdxsprite: JObject; _degrees: single); overload;
procedure jGdxSprite_Draw(env: PJNIEnv; _jgdxsprite: JObject; _batch: jObject; _x: single; _y: single); overload;
procedure jGdxSprite_SetSprite(env: PJNIEnv; _jgdxsprite: JObject; _sprite: jObject; _scale: single); overload;

procedure jGdxSprite_SetSprites(env: PJNIEnv; _jgdxsprite: JObject; _textureAtlas: jObject); overload;
procedure jGdxSprite_SetSprites(env: PJNIEnv; _jgdxsprite: JObject; _textureAtlas: jObject; _scale: single); overload;
procedure jGdxSprite_Draw(env: PJNIEnv; _jgdxsprite: JObject; _batch: jObject; _sprite: string; x: single; y: single); overload;
procedure jGdxSprite_SetPosition(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _x: single; _y: single); overload;
procedure jGdxSprite_SetRotation(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _degrees: single); overload;
procedure jGdxSprite_Translate(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _offsetX: single; _offsetY: single); overload;
procedure jGdxSprite_Rotate90(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _clockwise: boolean); overload;
procedure jGdxSprite_Rotate(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _degrees: single); overload;
procedure jGdxSprite_Dispose(env: PJNIEnv; _jgdxsprite: JObject);

implementation

{---------  jGdxSprite  --------------}

constructor jGdxSprite.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxSprite.Destroy;
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

procedure jGdxSprite.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxSprite.jCreate(): jObject;
begin
   Result:= jGdxSprite_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGdxSprite.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxSprite_jFree(FjEnv, FjObject);
end;

procedure jGdxSprite.SetPosition(_x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetPosition(FjEnv, FjObject, _x ,_y);
end;

procedure jGdxSprite.SetRotation(_degrees: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetRotation(FjEnv, FjObject, _degrees);
end;

procedure jGdxSprite.SetSprite(_sprite: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetSprite(FjEnv, FjObject, _sprite);
end;

procedure jGdxSprite.Translate(_offsetX: single; _offsetY: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Translate(FjEnv, FjObject, _offsetX ,_offsetY);
end;

procedure jGdxSprite.Rotate90(_clockwise: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Rotate90(FjEnv, FjObject, _clockwise);
end;

procedure jGdxSprite.Rotate(_degrees: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Rotate(FjEnv, FjObject, _degrees);
end;

procedure jGdxSprite.SetSprite(_sprite: jObject; _scale: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetSprite(FjEnv, FjObject, _sprite ,_scale);
end;

procedure jGdxSprite.SetSprites(_textureAtlas: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetSprites(FjEnv, FjObject, _textureAtlas);
end;

procedure jGdxSprite.SetSprites(_textureAtlas: jObject; _scale: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetSprites(FjEnv, FjObject, _textureAtlas ,_scale);
end;

procedure jGdxSprite.Draw(_batch: jObject; _x: single; _y: single); overload;
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Draw(FjEnv, FjObject, _batch,_x ,_y);
end;

procedure jGdxSprite.Draw(_batch: jObject; _sprite: string; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Draw(FjEnv, FjObject, _batch ,_sprite ,_x ,_y);
end;

procedure jGdxSprite.SetPosition(_sprite: string; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetPosition(FjEnv, FjObject, _sprite ,_x ,_y);
end;

procedure jGdxSprite.SetRotation(_sprite: string; _degrees: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_SetRotation(FjEnv, FjObject, _sprite ,_degrees);
end;

procedure jGdxSprite.Translate(_sprite: string; _offsetX: single; _offsetY: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Translate(FjEnv, FjObject, _sprite ,_offsetX ,_offsetY);
end;

procedure jGdxSprite.Rotate90(_sprite: string; _clockwise: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Rotate90(FjEnv, FjObject, _sprite ,_clockwise);
end;

procedure jGdxSprite.Rotate(_sprite: string; _degrees: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Rotate(FjEnv, FjObject, _sprite ,_degrees);
end;

procedure jGdxSprite.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxSprite_Dispose(FjEnv, FjObject);
end;

{-------- jGdxSprite_JNI_Bridge ----------}

function jGdxSprite_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxSprite_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jGdxSprite_jFree(env: PJNIEnv; _jgdxsprite: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxsprite, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetPosition(env: PJNIEnv; _jgdxsprite: JObject; _x: single; _y: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _x;
  jParams[1].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPosition', '(FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetRotation(env: PJNIEnv; _jgdxsprite: JObject; _degrees: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _degrees;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRotation', '(F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetSprite(env: PJNIEnv; _jgdxsprite: JObject; _sprite: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _sprite;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSprite', '(Lcom/badlogic/gdx/graphics/g2d/Sprite;)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Translate(env: PJNIEnv; _jgdxsprite: JObject; _offsetX: single; _offsetY: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _offsetX;
  jParams[1].f:= _offsetY;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Translate', '(FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Rotate90(env: PJNIEnv; _jgdxsprite: JObject; _clockwise: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].z:= JBool(_clockwise);
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Rotate90', '(Z)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Rotate(env: PJNIEnv; _jgdxsprite: JObject; _degrees: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _degrees;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Rotate', '(F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Draw(env: PJNIEnv; _jgdxsprite: JObject; _batch: jObject; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _batch;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Draw', '(Lcom/badlogic/gdx/graphics/g2d/SpriteBatch;FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetSprite(env: PJNIEnv; _jgdxsprite: JObject; _sprite: jObject; _scale: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _sprite;
  jParams[1].f:= _scale;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSprite', '(Lcom/badlogic/gdx/graphics/g2d/Sprite;F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetSprites(env: PJNIEnv; _jgdxsprite: JObject; _textureAtlas: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _textureAtlas;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSprites', '(Lcom/badlogic/gdx/graphics/g2d/TextureAtlas;)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetSprites(env: PJNIEnv; _jgdxsprite: JObject; _textureAtlas: jObject; _scale: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _textureAtlas;
  jParams[1].f:= _scale;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSprites', '(Lcom/badlogic/gdx/graphics/g2d/TextureAtlas;F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Draw(env: PJNIEnv; _jgdxsprite: JObject; _batch: jObject; _sprite: string; x: single; y: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _batch;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[2].f:= x;
  jParams[3].f:= y;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Draw', '(Lcom/badlogic/gdx/graphics/g2d/SpriteBatch;Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetPosition(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPosition', '(Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_SetRotation(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _degrees: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[1].f:= _degrees;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRotation', '(Ljava/lang/String;F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Translate(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _offsetX: single; _offsetY: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[1].f:= _offsetX;
  jParams[2].f:= _offsetY;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Translate', '(Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Rotate90(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _clockwise: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[1].z:= JBool(_clockwise);
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Rotate90', '(Ljava/lang/String;Z)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Rotate(env: PJNIEnv; _jgdxsprite: JObject; _sprite: string; _degrees: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sprite));
  jParams[1].f:= _degrees;
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Rotate', '(Ljava/lang/String;F)V');
  env^.CallVoidMethodA(env, _jgdxsprite, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxSprite_Dispose(env: PJNIEnv; _jgdxsprite: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxsprite);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxsprite, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
