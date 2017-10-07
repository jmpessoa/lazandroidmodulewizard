unit incomingcallwidgetprovider;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [9/29/2017 21:09:11]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jIncomingCallWidgetProvider = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

 published

end;

function jIncomingCallWidgetProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jIncomingCallWidgetProvider_jFree(env: PJNIEnv; _jIncomingCallwidgetprovider: JObject);


implementation


{---------  jIncomingCallWidgetProvider  --------------}

constructor jIncomingCallWidgetProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jIncomingCallWidgetProvider.Destroy;
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

procedure jIncomingCallWidgetProvider.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jIncomingCallWidgetProvider.jCreate(): jObject;
begin
   Result:= jIncomingCallWidgetProvider_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jIncomingCallWidgetProvider.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jIncomingCallWidgetProvider_jFree(FjEnv, FjObject);
end;

{-------- jIncomingCallWidgetProvider_JNI_Bridge ----------}

function jIncomingCallWidgetProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jIncomingCallWidgetProvider_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jIncomingCallWidgetProvider_jCreate(long _Self) {
  return (java.lang.Object)(new jIncomingCallWidgetProvider(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jIncomingCallWidgetProvider_jFree(env: PJNIEnv; _jIncomingCallwidgetprovider: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jIncomingCallwidgetprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jIncomingCallwidgetprovider, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
