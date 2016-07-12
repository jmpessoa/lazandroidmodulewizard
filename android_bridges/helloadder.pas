unit helloadder;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [2/22/2015 4:45:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jHelloAdder = class(jControl)
 private

 protected

 public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function Add(_a: integer; _b: integer): integer;
    function StringUpperCase(_str: string): string;

    function SQuare(x: integer): integer;
 published

end;

function jHelloAdder_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jHelloAdder_jFree(env: PJNIEnv; _jhelloadder: JObject);
function jHelloAdder_Add(env: PJNIEnv; _jhelloadder: JObject; _a: integer; _b: integer): integer;
function jHelloAdder_StringUpperCase(env: PJNIEnv; _jhelloadder: JObject; _str: string): string;


implementation


{---------  jHelloAdder  --------------}

constructor jHelloAdder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jHelloAdder.Destroy;
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

procedure jHelloAdder.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jHelloAdder.jCreate(): jObject;
begin
   Result:= jHelloAdder_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jHelloAdder.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jHelloAdder_jFree(FjEnv, FjObject);
end;

function jHelloAdder.Add(_a: integer; _b: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHelloAdder_Add(FjEnv, FjObject, _a ,_b);
end;

function jHelloAdder.StringUpperCase(_str: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jHelloAdder_StringUpperCase(FjEnv, FjObject, _str);
end;

function jHelloAdder.SQuare(x: integer): integer;
begin
    Result:= Sqr(x);
end;

{-------- jHelloAdder_JNI_Bridge ----------}

function jHelloAdder_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jHelloAdder_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jHelloAdder_jCreate(long _Self) {
      return (java.lang.Object)(new jHelloAdder(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jHelloAdder_jFree(env: PJNIEnv; _jhelloadder: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jhelloadder);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jhelloadder, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jHelloAdder_Add(env: PJNIEnv; _jhelloadder: JObject; _a: integer; _b: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _a;
  jParams[1].i:= _b;
  jCls:= env^.GetObjectClass(env, _jhelloadder);
  jMethod:= env^.GetMethodID(env, jCls, 'Add', '(II)I');
  Result:= env^.CallIntMethodA(env, _jhelloadder, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jHelloAdder_StringUpperCase(env: PJNIEnv; _jhelloadder: JObject; _str: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_str));
  jCls:= env^.GetObjectClass(env, _jhelloadder);
  jMethod:= env^.GetMethodID(env, jCls, 'StringUpperCase', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jhelloadder, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
