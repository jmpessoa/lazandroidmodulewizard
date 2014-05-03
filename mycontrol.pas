unit mycontrol;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;

type

jMyControl = class(jControl)
 private

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

 published

end;

function jMyControl_jCreate(env: PJNIEnv; this: JObject;Self: int64): jObject;
procedure jMyControl_jFree(env: PJNIEnv; this: JObject; _jmycontrol: JObject);


implementation

{---------  jMyControl  --------------}

constructor jMyControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jMyControl.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jMyControl.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jCreate();
  FInitialized:= True;
  //your code here
end;


function jMyControl.jCreate(): jObject;
begin
   Result:= jMyControl_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jMyControl.jFree();
begin
  if FInitialized then
     jMyControl_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

{-------- jMyControl_JNI_Bridge ----------}

function jMyControl_jCreate(env: PJNIEnv; this: JObject;Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMyControl_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jMyControl_jCreate(long Self) {
      return (java.lang.Object)(new jMyControl(this,Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jMyControl_jFree(env: PJNIEnv; this: JObject; _jmycontrol: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmycontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmycontrol, jMethod);
end;



end.
