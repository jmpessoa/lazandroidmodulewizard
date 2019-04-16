unit sscreenshot;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/15/2019 0:55:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jsScreenShot = class(jControl)
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

function jsScreenShot_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsScreenShot_jFree(env: PJNIEnv; _jsscreenshot: JObject);
function jsScreenShot_TakeScene(env: PJNIEnv; _jsscreenshot: JObject; _referenceView: jObject): jObject;
function jsScreenShot_SaveToFile(env: PJNIEnv; _jsscreenshot: JObject; _fileName: string): string;


implementation

{---------  jsScreenShot  --------------}

constructor jsScreenShot.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jsScreenShot.Destroy;
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

procedure jsScreenShot.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jsScreenShot.jCreate(): jObject;
begin
   Result:= jsScreenShot_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsScreenShot.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsScreenShot_jFree(FjEnv, FjObject);
end;

function jsScreenShot.TakeScene(_referenceView: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsScreenShot_TakeScene(FjEnv, FjObject, _referenceView);
end;

function jsScreenShot.SaveToFile(_fileName: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsScreenShot_SaveToFile(FjEnv, FjObject, _fileName);
end;

{-------- jsScreenShot_JNI_Bridge ----------}

function jsScreenShot_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsScreenShot_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsScreenShot_jFree(env: PJNIEnv; _jsscreenshot: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsscreenshot, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsScreenShot_TakeScene(env: PJNIEnv; _jsscreenshot: JObject; _referenceView: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _referenceView;
  jCls:= env^.GetObjectClass(env, _jsscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'TakeScene', '(Landroid/view/View;)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jsscreenshot, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsScreenShot_SaveToFile(env: PJNIEnv; _jsscreenshot: JObject; _fileName: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jsscreenshot);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsscreenshot, jMethod, @jParams);
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
