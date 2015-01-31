unit mycontrol;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/13/2015 17:47:05]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMyControl = class(jControl)
 private

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

 published

end;

function jMyControl_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jMyControl_jFree(env: PJNIEnv; _jmycontrol: JObject);


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
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jMyControl.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jMyControl.jCreate(): jObject;
begin
   Result:= jMyControl_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jMyControl.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMyControl_jFree(FjEnv, FjObject);
end;

{-------- jMyControl_JNI_Bridge ----------}

function jMyControl_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMyControl_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jMyControl_jCreate(long _Self) {
      return (java.lang.Object)(new jMyControl(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jMyControl_jFree(env: PJNIEnv; _jmycontrol: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmycontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmycontrol, jMethod);
end;



end.
