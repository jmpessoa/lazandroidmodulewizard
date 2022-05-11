unit gdxbitmapfont;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/5/2019 12:37:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxBitmapFont = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetColor(_red: single; _green: single; _blue: single; _alpha: single);
    procedure DrawText(_batch: jObject; _text: string; _x: single; _y: single);
    procedure SetScaleXY(_scaleXY: single);
    procedure Scale(_amount: single);
    procedure Dispose();

 published

end;

function jGdxBitmapFont_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxBitmapFont_jFree(env: PJNIEnv; _jgdxbitmapfont: JObject);

procedure jGdxBitmapFont_SetColor(env: PJNIEnv; _jgdxbitmapfont: JObject; _red: single; _green: single; _blue: single; _alpha: single);
procedure jGdxBitmapFont_DrawText(env: PJNIEnv; _jgdxbitmapfont: JObject; _batch: jObject; _text: string; _x: single; _y: single);

procedure jGdxBitmapFont_SetScaleXY(env: PJNIEnv; _jgdxbitmapfont: JObject; _scaleXY: single);
procedure jGdxBitmapFont_Scale(env: PJNIEnv; _jgdxbitmapfont: JObject; _amount: single);
procedure jGdxBitmapFont_Dispose(env: PJNIEnv; _jgdxbitmapfont: JObject);

implementation

{---------  jGdxBitmapFont  --------------}

constructor jGdxBitmapFont.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxBitmapFont.Destroy;
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

procedure jGdxBitmapFont.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxBitmapFont.jCreate(): jObject;
begin
   Result:= jGdxBitmapFont_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jGdxBitmapFont.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jGdxBitmapFont.SetColor(_red: single; _green: single; _blue: single; _alpha: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_SetColor(gApp.jni.jEnv, FjObject, _red ,_green ,_blue ,_alpha);
end;

procedure jGdxBitmapFont.DrawText(_batch: jObject; _text: string; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_DrawText(gApp.jni.jEnv, FjObject, _batch ,_text ,_x ,_y);
end;

procedure jGdxBitmapFont.SetScaleXY(_scaleXY: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_SetScaleXY(gApp.jni.jEnv, FjObject, _scaleXY);
end;

procedure jGdxBitmapFont.Scale(_amount: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_Scale(gApp.jni.jEnv, FjObject, _amount);
end;

procedure jGdxBitmapFont.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxBitmapFont_Dispose(gApp.jni.jEnv, FjObject);
end;

{-------- jGdxBitmapFont_JNI_Bridge ----------}

function jGdxBitmapFont_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxBitmapFont_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxBitmapFont_jFree(env: PJNIEnv; _jgdxbitmapfont: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxbitmapfont, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxBitmapFont_SetColor(env: PJNIEnv; _jgdxbitmapfont: JObject; _red: single; _green: single; _blue: single; _alpha: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _red;
  jParams[1].f:= _green;
  jParams[2].f:= _blue;
  jParams[3].f:= _alpha;
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'SetColor', '(FFFF)V');
  env^.CallVoidMethodA(env, _jgdxbitmapfont, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxBitmapFont_DrawText(env: PJNIEnv; _jgdxbitmapfont: JObject; _batch: jObject; _text: string; _x: single; _y: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _batch;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[2].f:= _x;
  jParams[3].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Lcom/badlogic/gdx/graphics/g2d/SpriteBatch;Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jgdxbitmapfont, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxBitmapFont_SetScaleXY(env: PJNIEnv; _jgdxbitmapfont: JObject; _scaleXY: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _scaleXY;
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScaleXY', '(F)V');
  env^.CallVoidMethodA(env, _jgdxbitmapfont, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxBitmapFont_Scale(env: PJNIEnv; _jgdxbitmapfont: JObject; _amount: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _amount;
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'Scale', '(F)V');
  env^.CallVoidMethodA(env, _jgdxbitmapfont, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxBitmapFont_Dispose(env: PJNIEnv; _jgdxbitmapfont: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxbitmapfont);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxbitmapfont, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
