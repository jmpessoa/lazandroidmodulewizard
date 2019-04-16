unit expression;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/15/2019 14:26:20]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jExpression = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetFormula(_expression: string; var _variables: TDynArrayOfString); overload;
    procedure SetFormula(_expression: string; _variables: array of string); overload;
    procedure SetValue(_variable: string; _value: double);
    function Evaluate(): double;

 published

end;

function jExpression_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jExpression_jFree(env: PJNIEnv; _jexpression: JObject);
procedure jExpression_SetFormula(env: PJNIEnv; _jexpression: JObject; _expression: string; var _variables: TDynArrayOfString); overload;
procedure jExpression_SetFormula(env: PJNIEnv; _jexpression: JObject; _expression: string;  _variables: array of string);  overload;
procedure jExpression_SetValue(env: PJNIEnv; _jexpression: JObject; _variable: string; _value: double);
function jExpression_Evaluate(env: PJNIEnv; _jexpression: JObject): double;

implementation

{---------  jExpression  --------------}

constructor jExpression.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jExpression.Destroy;
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

procedure jExpression.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jExpression.jCreate(): jObject;
begin
   Result:= jExpression_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jExpression.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpression_jFree(FjEnv, FjObject);
end;

procedure jExpression.SetFormula(_expression: string; var _variables: TDynArrayOfString);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpression_SetFormula(FjEnv, FjObject, _expression ,_variables);
end;

procedure jExpression.SetFormula(_expression: string; _variables: array of string);
begin
  if FInitialized then
     jExpression_SetFormula(FjEnv, FjObject, _expression ,_variables);
end;

procedure jExpression.SetValue(_variable: string; _value: double);
begin
  //in designing component state: set value here...
  if FInitialized then
     jExpression_SetValue(FjEnv, FjObject, _variable ,_value);
end;

function jExpression.Evaluate(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jExpression_Evaluate(FjEnv, FjObject);
end;

{-------- jExpression_JNI_Bridge ----------}

function jExpression_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jExpression_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jExpression_jFree(env: PJNIEnv; _jexpression: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpression);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jexpression, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpression_SetFormula(env: PJNIEnv; _jexpression: JObject; _expression: string; var _variables: TDynArrayOfString);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_expression));
  newSize0:= Length(_variables);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_variables[i])));
  end;
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jexpression);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFormula', '(Ljava/lang/String;[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpression, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpression_SetFormula(env: PJNIEnv; _jexpression: JObject; _expression: string; _variables: array of string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_expression));
  newSize0:= Length(_variables);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_variables[i])));
  end;
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jexpression);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFormula', '(Ljava/lang/String;[Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jexpression, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jExpression_SetValue(env: PJNIEnv; _jexpression: JObject; _variable: string; _value: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_variable));
  jParams[1].d:= _value;
  jCls:= env^.GetObjectClass(env, _jexpression);
  jMethod:= env^.GetMethodID(env, jCls, 'SetValue', '(Ljava/lang/String;D)V');
  env^.CallVoidMethodA(env, _jexpression, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jExpression_Evaluate(env: PJNIEnv; _jexpression: JObject): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jexpression);
  jMethod:= env^.GetMethodID(env, jCls, 'Evaluate', '()D');
  Result:= env^.CallDoubleMethod(env, _jexpression, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
