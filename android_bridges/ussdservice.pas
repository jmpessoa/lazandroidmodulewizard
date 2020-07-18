unit ussdservice;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/17/2020 22:20:58]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jUSSDService = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Start();
    procedure Stop();

 published

end;

function jUSSDService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jUSSDService_jFree(env: PJNIEnv; _jussdservice: JObject);
procedure jUSSDService_Start(env: PJNIEnv; _jussdservice: JObject);
procedure jUSSDService_Stop(env: PJNIEnv; _jussdservice: JObject);


implementation

{---------  jUSSDService  --------------}

constructor jUSSDService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jUSSDService.Destroy;
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

procedure jUSSDService.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;

function jUSSDService.jCreate(): jObject;
begin
   Result:= jUSSDService_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jUSSDService.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUSSDService_jFree(FjEnv, FjObject);
end;

procedure jUSSDService.Start();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUSSDService_Start(FjEnv, FjObject);
end;

procedure jUSSDService.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUSSDService_Stop(FjEnv, FjObject);
end;

{-------- jUSSDService_JNI_Bridge ----------}

function jUSSDService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jUSSDService_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jUSSDService_jFree(env: PJNIEnv; _jussdservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jussdservice);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jussdservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jUSSDService_Start(env: PJNIEnv; _jussdservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jussdservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jussdservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jUSSDService_Stop(env: PJNIEnv; _jussdservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jussdservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jussdservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
