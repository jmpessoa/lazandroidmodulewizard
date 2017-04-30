unit smswidgetprovider;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [4/23/2017 0:15:48]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSMSWidgetProvider = class(jControl)
 private
    //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

 published
    //
end;

function jSMSWidgetProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSMSWidgetProvider_jFree(env: PJNIEnv; _jsmswidgetprovider: JObject);


implementation


{---------  jSMSWidgetProvider  --------------}

constructor jSMSWidgetProvider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jSMSWidgetProvider.Destroy;
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

procedure jSMSWidgetProvider.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jSMSWidgetProvider.jCreate(): jObject;
begin
   Result:= jSMSWidgetProvider_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSMSWidgetProvider.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSMSWidgetProvider_jFree(FjEnv, FjObject);
end;

{-------- jSMSWidgetProvider_JNI_Bridge ----------}

function jSMSWidgetProvider_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSMSWidgetProvider_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jSMSWidgetProvider_jCreate(long _Self, String _layoutIdentifier, String _onClickIdentifier) {
  return (java.lang.Object)(new jSMSWidgetProvider(this,_Self,_layoutIdentifier,_onClickIdentifier));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jSMSWidgetProvider_jFree(env: PJNIEnv; _jsmswidgetprovider: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsmswidgetprovider);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsmswidgetprovider, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
