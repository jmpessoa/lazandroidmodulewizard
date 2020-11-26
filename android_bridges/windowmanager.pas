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
    procedure SetViewFocusable(_value:boolean);//Segator

    procedure RequestDrawOverlayRuntimePermission(_packageName: string; _requestCode: integer);
    procedure RequestIgnoreBatteryOptimizationRuntimePermission(_packageName: string; _requestCode: integer);
    procedure RequestIgnoreBackgrundDataRestrictionRuntimePermission(_packageName: string; _requestCode: integer);
    function IsDrawOverlaysRuntimePermissionNeed(): boolean;
    function CanDrawOverlays(): boolean;
    function IgnoringBatteryOptimizations(): boolean;
    function IgnoringDataRestriction(): boolean;

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
procedure jWindowManager_SetViewFocusable(env: PJNIEnv; _jwindowmanager: JObject; _value: boolean);

procedure jWindowManager_RequestDrawOverlayRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
procedure jWindowManager_RequestIgnoreBatteryOptimizationRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
procedure jWindowManager_RequestIgnoreBackgrundDataRestrictionRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
function jWindowManager_IsDrawOverlaysRuntimePermissionNeed(env: PJNIEnv; _jwindowmanager: JObject): boolean;
function jWindowManager_CanDrawOverlays(env: PJNIEnv; _jwindowmanager: JObject): boolean;
function jWindowManager_IgnoringBatteryOptimizations(env: PJNIEnv; _jwindowmanager: JObject): boolean;
function jWindowManager_IgnoringDataRestriction(env: PJNIEnv; _jwindowmanager: JObject): boolean;

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
  FjObject := jCreate(); if FjObject = nil then exit;
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

//Segator
procedure jWindowManager.SetViewFocusable(_value:boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_SetViewFocusable(FjEnv, FjObject, _value);
end;

procedure jWindowManager.RequestDrawOverlayRuntimePermission(_packageName: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_RequestDrawOverlayRuntimePermission(FjEnv, FjObject, _packageName ,_requestCode);
end;

procedure jWindowManager.RequestIgnoreBackgrundDataRestrictionRuntimePermission(_packageName: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_RequestIgnoreBackgrundDataRestrictionRuntimePermission(FjEnv, FjObject, _packageName ,_requestCode);
end;

procedure jWindowManager.RequestIgnoreBatteryOptimizationRuntimePermission(_packageName: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWindowManager_RequestIgnoreBatteryOptimizationRuntimePermission(FjEnv, FjObject, _packageName ,_requestCode);
end;

function jWindowManager.IsDrawOverlaysRuntimePermissionNeed(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_IsDrawOverlaysRuntimePermissionNeed(FjEnv, FjObject);
end;

function jWindowManager.CanDrawOverlays(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_CanDrawOverlays(FjEnv, FjObject);
end;

function jWindowManager.IgnoringBatteryOptimizations(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_IgnoringBatteryOptimizations(FjEnv, FjObject);
end;

function jWindowManager.IgnoringDataRestriction(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWindowManager_IgnoringDataRestriction(FjEnv, FjObject);
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

//Segator
procedure jWindowManager_SetViewFocusable(env: PJNIEnv; _jwindowmanager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewFocusable', '(Z)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_RequestDrawOverlayRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestDrawOverlayRuntimePermission', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_RequestIgnoreBatteryOptimizationRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestIgnoreBatteryOptimizationRuntimePermission', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWindowManager_RequestIgnoreBackgrundDataRestrictionRuntimePermission(env: PJNIEnv; _jwindowmanager: JObject; _packageName: string; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestIgnoreBackgrundDataRestrictionRuntimePermission', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jwindowmanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jWindowManager_IsDrawOverlaysRuntimePermissionNeed(env: PJNIEnv; _jwindowmanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsDrawOverlaysRuntimePermissionNeed', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwindowmanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWindowManager_CanDrawOverlays(env: PJNIEnv; _jwindowmanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CanDrawOverlays', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwindowmanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWindowManager_IgnoringBatteryOptimizations(env: PJNIEnv; _jwindowmanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IgnoringBatteryOptimizations', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwindowmanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWindowManager_IgnoringDataRestriction(env: PJNIEnv; _jwindowmanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwindowmanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IgnoringDataRestriction', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwindowmanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

end.
