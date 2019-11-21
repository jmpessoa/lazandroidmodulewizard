unit gif;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [11/20/2019 22:11:10]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGif = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function LoadFromRawResource(_gifImageIdentifier: string): jObject;
    function LoadFromAssets(_gifFilename: string): jObject;
    function LoadFromFile(_path: string; _gifFilename: string): jObject;
    procedure Start();
    procedure Stop();

 published

end;

function jGif_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGif_jFree(env: PJNIEnv; _jgif: JObject);
function jGif_LoadFromRawResource(env: PJNIEnv; _jgif: JObject; _gifImageIdentifier: string): jObject;
function jGif_LoadFromAssets(env: PJNIEnv; _jgif: JObject; _gifFilename: string): jObject;
function jGif_LoadFromFile(env: PJNIEnv; _jgif: JObject; _path: string; _gifFilename: string): jObject;
procedure jGif_Start(env: PJNIEnv; _jgif: JObject);
procedure jGif_Stop(env: PJNIEnv; _jgif: JObject);


implementation

{---------  jGif  --------------}

constructor jGif.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGif.Destroy;
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

procedure jGif.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jGif.jCreate(): jObject;
begin
   Result:= jGif_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGif.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGif_jFree(FjEnv, FjObject);
end;

function jGif.LoadFromRawResource(_gifImageIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGif_LoadFromRawResource(FjEnv, FjObject, _gifImageIdentifier);
end;

function jGif.LoadFromAssets(_gifFilename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGif_LoadFromAssets(FjEnv, FjObject, _gifFilename);
end;

function jGif.LoadFromFile(_path: string; _gifFilename: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGif_LoadFromFile(FjEnv, FjObject, _path ,_gifFilename);
end;

procedure jGif.Start();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGif_Start(FjEnv, FjObject);
end;

procedure jGif.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGif_Stop(FjEnv, FjObject);
end;

{-------- jGif_JNI_Bridge ----------}

function jGif_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGif_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGif_jFree(env: PJNIEnv; _jgif: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgif, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGif_LoadFromRawResource(env: PJNIEnv; _jgif: JObject; _gifImageIdentifier: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_gifImageIdentifier));
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromRawResource', '(Ljava/lang/String;)Landroid/graphics/drawable/AnimationDrawable;');
  Result:= env^.CallObjectMethodA(env, _jgif, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGif_LoadFromAssets(env: PJNIEnv; _jgif: JObject; _gifFilename: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_gifFilename));
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromAssets', '(Ljava/lang/String;)Landroid/graphics/drawable/AnimationDrawable;');
  Result:= env^.CallObjectMethodA(env, _jgif, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGif_LoadFromFile(env: PJNIEnv; _jgif: JObject; _path: string; _gifFilename: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_gifFilename));
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFromFile', '(Ljava/lang/String;Ljava/lang/String;)Landroid/graphics/drawable/AnimationDrawable;');
  Result:= env^.CallObjectMethodA(env, _jgif, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGif_Start(env: PJNIEnv; _jgif: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jgif, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGif_Stop(env: PJNIEnv; _jgif: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgif);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jgif, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
