unit myhello;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [4/26/2014 19:06:40]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMyHello = class(jControl)
 private

    Fflag: integer;
    Fhello: string;

    procedure SetFlag(_flag: integer);
    function GetFlag(): integer;
    procedure SetHello(_hello: string);
    function GetHello(): string;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate( _flag: integer; _hello: string): jObject;
    procedure jFree();
    function GetStringArray(): TDynArrayOfString;
    function ToUpperStringArray(var _msgArray: TDynArrayOfString): TDynArrayOfString;
    function ConcatStringArray(var _strArrayA: TDynArrayOfString; var _strArrayB: TDynArrayOfString): TDynArrayOfString;
    function GetIntArray(): TDynArrayOfInteger;
    function GetSumIntArray(var _vA: TDynArrayOfInteger; var _vB: TDynArrayOfInteger; _size: integer): TDynArrayOfInteger;
    procedure ShowHello();

 published
    property Flag: integer read GetFlag write SetFlag;      //
    property Hello: string read GetHello write SetHello;    //
end;

function jMyHello_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _flag: integer; _hello: string): jObject;
procedure jMyHello_jFree(env: PJNIEnv; _jmyhello: JObject);
procedure jMyHello_SetFlag(env: PJNIEnv; _jmyhello: JObject; _flag: integer);
function jMyHello_GetFlag(env: PJNIEnv; _jmyhello: JObject): integer;
procedure jMyHello_SetHello(env: PJNIEnv; _jmyhello: JObject; _hello: string);
function jMyHello_GetHello(env: PJNIEnv; _jmyhello: JObject): string;
function jMyHello_GetStringArray(env: PJNIEnv; _jmyhello: JObject): TDynArrayOfString;
function jMyHello_ToUpperStringArray(env: PJNIEnv; _jmyhello: JObject; var _msgArray: TDynArrayOfString): TDynArrayOfString;
function jMyHello_ConcatStringArray(env: PJNIEnv; _jmyhello: JObject; var _strArrayA: TDynArrayOfString; var _strArrayB: TDynArrayOfString): TDynArrayOfString;
function jMyHello_GetIntArray(env: PJNIEnv; _jmyhello: JObject): TDynArrayOfInteger;
function jMyHello_GetSumIntArray(env: PJNIEnv; _jmyhello: JObject; var _vA: TDynArrayOfInteger; var _vB: TDynArrayOfInteger; _size: integer): TDynArrayOfInteger;
procedure jMyHello_ShowHello(env: PJNIEnv; _jmyhello: JObject);


implementation

{---------  jMyHello  --------------}

constructor jMyHello.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jMyHello.Destroy;
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

procedure jMyHello.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  if  Fhello = '' then Fhello:= 'Hello Android World!';
  FjObject:= jCreate(Fflag ,Fhello);
  FInitialized:= True;
end;

function jMyHello.jCreate( _flag: integer; _hello: string): jObject;
begin
  Result:= jMyHello_jCreate(FjEnv, FjThis , int64(Self) ,_flag ,_hello);
end;

procedure jMyHello.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMyHello_jFree(FjEnv, FjObject);
end;

procedure jMyHello.SetFlag(_flag: integer);
begin
  //in designing component state: set value here...
  Fflag:= _flag;
  if FInitialized then
     jMyHello_SetFlag(FjEnv, FjObject, _flag);
end;

function jMyHello.GetFlag(): integer;
begin
  //in designing component state: result value here...
  Result:= Fflag;
  if FInitialized then
   Result:= jMyHello_GetFlag(FjEnv, FjObject);
end;

procedure jMyHello.SetHello(_hello: string);
begin
  //in designing component state: set value here...
  Fhello:= _hello;
  if FInitialized then
     jMyHello_SetHello(FjEnv, FjObject, _hello);
end;

function jMyHello.GetHello(): string;
begin
  //in designing component state: result value here...
  Result:= Fhello;
  if FInitialized then
   Result:= jMyHello_GetHello(FjEnv, FjObject);
end;

function jMyHello.GetStringArray(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMyHello_GetStringArray(FjEnv, FjObject);
end;

function jMyHello.ToUpperStringArray(var _msgArray: TDynArrayOfString): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMyHello_ToUpperStringArray(FjEnv, FjObject, _msgArray);
end;

function jMyHello.ConcatStringArray(var _strArrayA: TDynArrayOfString; var _strArrayB: TDynArrayOfString): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMyHello_ConcatStringArray(FjEnv, FjObject, _strArrayA ,_strArrayB);
end;

function jMyHello.GetIntArray(): TDynArrayOfInteger;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMyHello_GetIntArray(FjEnv, FjObject);
end;

function jMyHello.GetSumIntArray(var _vA: TDynArrayOfInteger; var _vB: TDynArrayOfInteger; _size: integer): TDynArrayOfInteger;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMyHello_GetSumIntArray(FjEnv, FjObject, _vA ,_vB ,_size);
end;

procedure jMyHello.ShowHello();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMyHello_ShowHello(FjEnv, FjObject);
end;

{-------- jMyHello_JNI_Bridge ----------}

function jMyHello_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _flag: integer; _hello: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _flag;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_hello));
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMyHello_jCreate', '(JILjava/lang/String;)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
  env^.DeleteLocalRef(env,jParams[2].l);
end;

(*
//Please, you need insert:

   public java.lang.Object jMyHello_jCreate(long _Self, int _flag, String _hello) {
      return (java.lang.Object)(new jMyHello(this,_Self,_flag,_hello));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jMyHello_jFree(env: PJNIEnv; _jmyhello: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmyhello, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMyHello_SetFlag(env: PJNIEnv; _jmyhello: JObject; _flag: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _flag;
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFlag', '(I)V');
  env^.CallVoidMethodA(env, _jmyhello, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_GetFlag(env: PJNIEnv; _jmyhello: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFlag', '()I');
  Result:= env^.CallIntMethod(env, _jmyhello, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMyHello_SetHello(env: PJNIEnv; _jmyhello: JObject; _hello: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hello));
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHello', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmyhello, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_GetHello(env: PJNIEnv; _jmyhello: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'GetHello', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jmyhello, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_GetStringArray(env: PJNIEnv; _jmyhello: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringArray', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jmyhello, jMethod);
  if jresultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                 jBoo:= JNI_False;
                 Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_ToUpperStringArray(env: PJNIEnv; _jmyhello: JObject; var _msgArray: TDynArrayOfString): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_msgArray); //?
  jNewArray0:= env^.NewObjectArray(env, newSize0,env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_msgArray[i])));
  end;
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'ToUpperStringArray', '([Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jmyhello, jMethod,  @jParams);
  resultSize:= env^.GetArrayLength(env, jResultArray);
  SetLength(Result, resultSize);
  for i:= 0 to resultsize - 1 do
  begin
    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
    case jStr = nil of
       True : Result[i]:= '';
       False: begin
                jBoo:= JNI_False;
                Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
              end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_ConcatStringArray(env: PJNIEnv; _jmyhello: JObject; var _strArrayA: TDynArrayOfString; var _strArrayB: TDynArrayOfString): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_strArrayA); //?
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_strArrayA[i])));
  end;
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_strArrayB); //?
  jNewArray1:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize1 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray1,i,env^.NewStringUTF(env, PChar(_strArrayB[i])));
  end;
  jParams[1].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'ConcatStringArray', '([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jmyhello, jMethod,  @jParams);
  resultSize:= env^.GetArrayLength(env, jResultArray);
  SetLength(Result, resultSize);
  for i:= 0 to resultsize - 1 do
  begin
    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
    case jStr = nil of
       True : Result[i]:= '';
       False: begin
                jBoo:= JNI_False;
                Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
              end;
    end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_GetIntArray(env: PJNIEnv; _jmyhello: JObject): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntArray', '()[I');
  jresultArray:= env^.CallObjectMethod(env, _jmyhello, jMethod);
  resultsize:= env^.GetArrayLength(env, jresultArray);
  SetLength(Result, resultsize);
  env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  env^.DeleteLocalRef(env, jCls);
end;

function jMyHello_GetSumIntArray(env: PJNIEnv; _jmyhello: JObject; var _vA: TDynArrayOfInteger; var _vB: TDynArrayOfInteger; _size: integer): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= _size; //?
  jNewArray0:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, jNewArray0, 0 , newSize0, @_vA[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= _size; //?
  jNewArray1:= env^.NewIntArray(env, newSize1);  // allocate
  env^.SetIntArrayRegion(env, jNewArray1, 0 , newSize1, @_vB[0] {source});
  jParams[1].l:= jNewArray1;
  jParams[2].i:= _size;
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSumIntArray', '([I[II)[I');
  jResultArray:= env^.CallObjectMethodA(env, _jmyhello, jMethod,  @jParams);
  resultSize:= env^.GetArrayLength(env, jResultArray);
  SetLength(Result, resultSize);
  env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMyHello_ShowHello(env: PJNIEnv; _jmyhello: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyhello);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowHello', '()V');
  env^.CallVoidMethod(env, _jmyhello, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
