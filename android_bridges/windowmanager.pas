unit windowmanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [2/8/2017 0:15:42]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jWindowManager = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure AddView(_floatingView: jObject);
    procedure RemoveView();
    procedure SetViewPosition(_x: integer; _y: integer);
    function GetViewPositionX(): integer;
    function GetViewPositionY(): integer;
    procedure SetViewRoundCorner();
    procedure SetRadiusRoundCorner(_radius: integer);

 published

end;

function jWindowManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jWindowManager_jFree(env: PJNIEnv; _jwindowmanager: JObject);
procedure jWindowManager_AddView(env: PJNIEnv; _jwindowmanager: JObject; _floatingView: jObject);
procedure jWindowManager_RemoveView(env: PJNIEnv; _jwindowmanager: JObject);
procedure jWindowManager_SetViewPosition(env: PJNIEnv; _jwindowmanager: JObject; _x: integer; _y: integer);
function jWindowManager_GetViewPositionX(env: PJNIEnv; _jwindowmanager: JObject): integer;
function jWindowManager_GetViewPositionY(env: PJNIEnv; _jwindowmanager: JObject): integer;
procedure jWindowManager_SetViewRoundCorner(env: PJNIEnv; _jwindowmanager: JObject);
procedure jWindowManager_SetRadiusRoundCorner(env: PJNIEnv; _jwindowmanager: JObject; _radius: integer);


implementation


{---------  jWindowManager  --------------}

constructor jWindowManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jWindowManager.Destroy;
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

procedure jWindowManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jWindowManager.jCreate(): jObject;
begin
   Result:= jWindowManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jWindowManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_jFree(FjEnv, FjObject);
end;

procedure jWindowManager.AddView(_floatingView: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_AddView(FjEnv, FjObject, _floatingView);
end;

procedure jWindowManager.RemoveView();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_RemoveView(FjEnv, FjObject);
end;

procedure jWindowManager.SetViewPosition(_x: integer; _y: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_SetViewPosition(FjEnv, FjObject, _x ,_y);
end;

function jWindowManager.GetViewPositionX(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_GetViewPositionX(FjEnv, FjObject);
end;

function jWindowManager.GetViewPositionY(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_GetViewPositionY(FjEnv, FjObject);
end;

procedure jWindowManager.SetViewRoundCorner();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_SetViewRoundCorner(FjEnv, FjObject);
end;

procedure jWindowManager.SetRadiusRoundCorner(_radius: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_SetRadiusRoundCorner(FjEnv, FjObject, _radius);
end;

{-------- jWindowManager_JNI_Bridge ----------}

function jWindowManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jWindowManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jWindowManager_jCreate(long _Self) {
  return (java.lang.Object)(new jWindowManager(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jWindowManager_jFree(env: PJNIEnv; _jwindowmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jwindowmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jWindowManager_AddView(env: PJNIEnv; _jwindowmanager: JObject; _floatingView: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _floatingView;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddView', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jWindowManager_RemoveView(env: PJNIEnv; _jwindowmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveView', '()V');
  env^.CallVoidMethod(env, _jwindowmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_SetViewPosition(env: PJNIEnv; _jwindowmanager: JObject; _x: integer; _y: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _x;
  jParams[1].i:= _y;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewPosition', '(II)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jWindowManager_GetViewPositionX(env: PJNIEnv; _jwindowmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetViewPositionX', '()I');
  Result:= env^.CallIntMethod(env, _jwindowmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jWindowManager_GetViewPositionY(env: PJNIEnv; _jwindowmanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetViewPositionY', '()I');
  Result:= env^.CallIntMethod(env, _jwindowmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_SetViewRoundCorner(env: PJNIEnv; _jwindowmanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewRoundCorner', '()V');
  env^.CallVoidMethod(env, _jwindowmanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_SetRadiusRoundCorner(env: PJNIEnv; _jwindowmanager: JObject; _radius: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _radius;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRadiusRoundCorner', '(I)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
