unit activitylauncher;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnContentPrompt = Procedure(Sender: TObject; out layout: JObject) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [8/24/2016 2:51:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jActivityLauncher = class(jControl)
 private
     //
 protected
     //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure StartActivity(_packageName: string; _javaClassName: string); overload;
    procedure StartActivityForResult(_packageName: string; _javaClassName: string; _requestCode: integer); overload;

    procedure StartActivity(_intent: jObject); overload;
    procedure StartActivityForResult(_intent: jObject; _requestCode: integer); overload;
end;

function jActivityLauncher_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jActivityLauncher_jFree(env: PJNIEnv; _jactivity: JObject);

procedure jActivityLauncher_StartActivity(env: PJNIEnv; _jactivity: JObject; _packageName: string; _javaClassName: string); overload;
procedure jActivityLauncher_StartActivityForResult(env: PJNIEnv; _jactivity: JObject; _packageName: string; _javaClassName: string; _requestCode: integer); overload;

procedure jActivityLauncher_StartActivity(env: PJNIEnv; _jactivity: JObject; _intent: jObject); overload;
procedure jActivityLauncher_StartActivityForResult(env: PJNIEnv; _jactivity: JObject; _intent: jObject; _requestCode: integer); overload;

implementation


uses TypInfo,  Variants;

{---------  jActivityLauncher  --------------}

constructor jActivityLauncher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jActivityLauncher.Destroy;
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

procedure jActivityLauncher.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jActivityLauncher.jCreate(): jObject;
begin
  Result:= jActivityLauncher_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jActivityLauncher.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jActivityLauncher_jFree(FjEnv, FjObject);
end;

procedure jActivityLauncher.StartActivity(_packageName: string; _javaClassName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActivityLauncher_StartActivity(FjEnv, FjObject, _packageName ,_javaClassName);
end;

procedure jActivityLauncher.StartActivityForResult(_packageName: string; _javaClassName: string; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActivityLauncher_StartActivityForResult(FjEnv, FjObject, _packageName ,_javaClassName ,_requestCode);
end;

procedure jActivityLauncher.StartActivity(_intent: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActivityLauncher_StartActivity(FjEnv, FjObject, _intent);
end;

procedure jActivityLauncher.StartActivityForResult(_intent: jObject; _requestCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jActivityLauncher_StartActivityForResult(FjEnv, FjObject, _intent ,_requestCode);
end;

{-------- jActivityLauncher_JNI_Bridge ----------}

function jActivityLauncher_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jActivityLauncher_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jActivityLauncher_jCreate(long _Self) {
  return (java.lang.Object)(new jActivityLauncher(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jActivityLauncher_jFree(env: PJNIEnv; _jactivity: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jactivity);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jactivity, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jActivityLauncher_StartActivity(env: PJNIEnv; _jactivity: JObject; _packageName: string; _javaClassName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_javaClassName));
  jCls:= env^.GetObjectClass(env, _jactivity);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivity', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jactivity, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jActivityLauncher_StartActivityForResult(env: PJNIEnv; _jactivity: JObject; _packageName: string; _javaClassName: string; _requestCode: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_packageName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_javaClassName));
  jParams[2].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jactivity);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityForResult', '(Ljava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jactivity, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jActivityLauncher_StartActivity(env: PJNIEnv; _jactivity: JObject; _intent: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jCls:= env^.GetObjectClass(env, _jactivity);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivity', '(Landroid/content/Intent;)V');
  env^.CallVoidMethodA(env, _jactivity, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jActivityLauncher_StartActivityForResult(env: PJNIEnv; _jactivity: JObject; _intent: jObject; _requestCode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intent;
  jParams[1].i:= _requestCode;
  jCls:= env^.GetObjectClass(env, _jactivity);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityForResult', '(Landroid/content/Intent;I)V');
  env^.CallVoidMethodA(env, _jactivity, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
