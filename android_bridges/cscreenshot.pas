unit cscreenshot;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/21/2019 12:00:26]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcScreenShot = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function TakeScene(_referenceView: jObject): jObject;
    function SaveToFile(_fileName: string): string;

 published

end;

function jcScreenShot_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcScreenShot_jFree(env: PJNIEnv; _jcscreenshot: JObject);
function jcScreenShot_TakeScene(env: PJNIEnv; _jcscreenshot: JObject; _referenceView: jObject): jObject;
function jcScreenShot_SaveToFile(env: PJNIEnv; _jcscreenshot: JObject; _fileName: string): string;


implementation

{---------  jcScreenShot  --------------}

constructor jcScreenShot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcScreenShot.Destroy;
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

procedure jcScreenShot.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jcScreenShot.jCreate(): jObject;
begin
   Result:= jcScreenShot_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcScreenShot.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcScreenShot_jFree(FjEnv, FjObject);
end;

function jcScreenShot.TakeScene(_referenceView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcScreenShot_TakeScene(FjEnv, FjObject, _referenceView);
end;

function jcScreenShot.SaveToFile(_fileName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcScreenShot_SaveToFile(FjEnv, FjObject, _fileName);
end;

{-------- jcScreenShot_JNI_Bridge ----------}

function jcScreenShot_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcScreenShot_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcScreenShot_jFree(env: PJNIEnv; _jcscreenshot: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcscreenshot, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcScreenShot_TakeScene(env: PJNIEnv; _jcscreenshot: JObject; _referenceView: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _referenceView;
  jCls:= env^.GetObjectClass(env, _jcscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'TakeScene', '(Landroid/view/View;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcscreenshot, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jcScreenShot_SaveToFile(env: PJNIEnv; _jcscreenshot: JObject; _fileName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jcscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcscreenshot, jMethod, @jParams);
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



end.
