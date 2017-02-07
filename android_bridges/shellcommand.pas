unit shellcommand;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

   TOnCommandExecuted = procedure(Sender: TObject; cmdResult: string) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [5/8/2015 20:50:05]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}


jShellCommand = class(jControl)
 private
    FOnCommandExecuted: TOnCommandExecuted;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure ExecuteAsync(_shellCmd: string);
    procedure GenEvent_OnShellCommandExecuted(Obj: TObject; cmdResult: string);
 published
    property OnExecuted: TOnCommandExecuted read FOnCommandExecuted write FOnCommandExecuted;
end;

function jShellCommand_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jShellCommand_jFree(env: PJNIEnv; _jshellcommand: JObject);
procedure jShellCommand_Execute(env: PJNIEnv; _jshellcommand: JObject; _shellCmd: string);


implementation


{---------  jShellCommand  --------------}

constructor jShellCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jShellCommand.Destroy;
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

procedure jShellCommand.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jShellCommand.jCreate(): jObject;
begin
   Result:= jShellCommand_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jShellCommand.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jShellCommand_jFree(FjEnv, FjObject);
end;

procedure jShellCommand.ExecuteAsync(_shellCmd: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jShellCommand_Execute(FjEnv, FjObject, _shellCmd);
end;

procedure jShellCommand.GenEvent_OnShellCommandExecuted(Obj: TObject; cmdResult: string);
begin
   if Assigned(FOnCommandExecuted) then FOnCommandExecuted(Obj, cmdResult);
end;

{-------- jShellCommand_JNI_Bridge ----------}

function jShellCommand_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jShellCommand_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jShellCommand_jCreate(long _Self) {
      return (java.lang.Object)(new jShellCommand(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jShellCommand_jFree(env: PJNIEnv; _jshellcommand: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jshellcommand);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jshellcommand, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jShellCommand_Execute(env: PJNIEnv; _jshellcommand: JObject; _shellCmd: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_shellCmd));
  jCls:= env^.GetObjectClass(env, _jshellcommand);
  jMethod:= env^.GetMethodID(env, jCls, 'Execute', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jshellcommand, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
