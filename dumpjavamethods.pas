unit dumpjavamethods;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/1/2014 21:10:39]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jDumpJavaMethods = class(jControl)
 private
    FfullJavaClassName: string;
    FObjReferenceName: string;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate( _fullJavaClassName: string): jObject;
    procedure jFree();
    function GetMethodFullSignatureList(): string;
    function GetMethodImplementationList(): string;
    procedure SetStripFullTypeName(_stripFullTypeName: boolean);
    function GetStripFullTypeName(): boolean;
    procedure SetFullJavaClassName(_fullJavaClassName: string);
    function GetFullJavaClassName(): string;
    procedure SetObjReferenceName(_objReferenceName: string);
    function GetObjReferenceName(): string;
    procedure SetDelimiter(_delimiter: string);
    function GetDelimiter(): string;
    function GetMethodHeaderList(): string;
    function GetMethodHeaderListSize(): integer;
    function GetMethodHeaderByIndex(_index: integer): string;
    procedure MaskMethodHeaderByIndex(_index: integer);
    procedure UnMaskMethodHeaderByIndex(_index: integer);
    function GetNoMaskedMethodHeaderList(): string;
    function Extract(): string; overload;
    function Extract(_fullJavaClassName: string; _delimiter: string): string;  overload;
    function GetNoMaskedMethodImplementationByIndex(_index: integer): string;
    function GetNoMaskedMethodImplementationListSize(): integer;
    function GetNoMaskedMethodImplementationList(): string;

 published
    property FullJavaClassName: string read GetFullJavaClassName write SetFullJavaClassName;
    property ObjReferenceName: string read GetObjReferenceName write SetObjReferenceName;

end;

function jDumpJavaMethods_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _fullJavaClassName: string): jObject;
procedure jDumpJavaMethods_jFree(env: PJNIEnv; _jdumpjavamethods: JObject);
function jDumpJavaMethods_GetMethodFullSignatureList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
function jDumpJavaMethods_GetMethodImplementationList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
procedure jDumpJavaMethods_SetStripFullTypeName(env: PJNIEnv; _jdumpjavamethods: JObject; _stripFullTypeName: boolean);
function jDumpJavaMethods_GetStripFullTypeName(env: PJNIEnv; _jdumpjavamethods: JObject): boolean;
procedure jDumpJavaMethods_SetFullJavaClassName(env: PJNIEnv; _jdumpjavamethods: JObject; _fullJavaClassName: string);
function jDumpJavaMethods_GetFullJavaClassName(env: PJNIEnv; _jdumpjavamethods: JObject): string;
procedure jDumpJavaMethods_SetObjReferenceName(env: PJNIEnv; _jdumpjavamethods: JObject; _objReferenceName: string);
function jDumpJavaMethods_GetObjReferenceName(env: PJNIEnv; _jdumpjavamethods: JObject): string;
procedure jDumpJavaMethods_SetDelimiter(env: PJNIEnv; _jdumpjavamethods: JObject; _delimiter: string);
function jDumpJavaMethods_GetDelimiter(env: PJNIEnv; _jdumpjavamethods: JObject): string;
function jDumpJavaMethods_GetMethodHeaderList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
function jDumpJavaMethods_GetMethodHeaderListSize(env: PJNIEnv; _jdumpjavamethods: JObject): integer;
function jDumpJavaMethods_GetMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer): string;
procedure jDumpJavaMethods_MaskMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer);
procedure jDumpJavaMethods_UnMaskMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer);
function jDumpJavaMethods_GetNoMaskedMethodHeaderList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
function jDumpJavaMethods_Extract(env: PJNIEnv; _jdumpjavamethods: JObject): string;  overload;
function jDumpJavaMethods_Extract(env: PJNIEnv; _jdumpjavamethods: JObject; _fullJavaClassName: string; _delimiter: string): string; overload;
function jDumpJavaMethods_GetNoMaskedMethodImplementationByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer): string;
function jDumpJavaMethods_GetNoMaskedMethodImplementationListSize(env: PJNIEnv; _jdumpjavamethods: JObject): integer;
function jDumpJavaMethods_GetNoMaskedMethodImplementationList(env: PJNIEnv; _jdumpjavamethods: JObject): string;


implementation

{---------  jDumpJavaMethods  --------------}

constructor jDumpJavaMethods.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FfullJavaClassName:= 'android.media.MediaPlayer';
end;

destructor jDumpJavaMethods.Destroy;
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

procedure jDumpJavaMethods.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  if FfullJavaClassName = '' then FfullJavaClassName:= 'android.media.MediaPlayer';

  FjObject:= jCreate(FfullJavaClassName);
  FInitialized:= True;

  if FObjReferenceName <> '' then  //others initializations...
     SetObjReferenceName(FObjReferenceName);
end;


function jDumpJavaMethods.jCreate( _fullJavaClassName: string): jObject;
begin
   Result:= jDumpJavaMethods_jCreate(FjEnv, FjThis , int64(Self) ,_fullJavaClassName);
end;

procedure jDumpJavaMethods.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDumpJavaMethods_jFree(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetMethodFullSignatureList(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetMethodFullSignatureList(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetMethodImplementationList(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetMethodImplementationList(FjEnv, FjObject);
end;

procedure jDumpJavaMethods.SetStripFullTypeName(_stripFullTypeName: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDumpJavaMethods_SetStripFullTypeName(FjEnv, FjObject, _stripFullTypeName);
end;

function jDumpJavaMethods.GetStripFullTypeName(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetStripFullTypeName(FjEnv, FjObject);
end;

procedure jDumpJavaMethods.SetFullJavaClassName(_fullJavaClassName: string);
begin
  //in designing component state: set value here...
  FfullJavaClassName:= _fullJavaClassName;
  if FInitialized then
     jDumpJavaMethods_SetFullJavaClassName(FjEnv, FjObject, _fullJavaClassName);
end;

function jDumpJavaMethods.GetFullJavaClassName(): string;
begin
  //in designing component state: result value here...
  Result:= FfullJavaClassName;
  if FInitialized then
   Result:= jDumpJavaMethods_GetFullJavaClassName(FjEnv, FjObject);
end;

procedure jDumpJavaMethods.SetObjReferenceName(_objReferenceName: string);
begin
  //in designing component state: set value here...
  FObjReferenceName:= _objReferenceName;
  if FInitialized then
     jDumpJavaMethods_SetObjReferenceName(FjEnv, FjObject, _objReferenceName);
end;

function jDumpJavaMethods.GetObjReferenceName(): string;
begin
  //in designing component state: result value here...
  Result:= FObjReferenceName;
  if FInitialized then
   Result:= jDumpJavaMethods_GetObjReferenceName(FjEnv, FjObject);
end;

procedure jDumpJavaMethods.SetDelimiter(_delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDumpJavaMethods_SetDelimiter(FjEnv, FjObject, _delimiter);
end;

function jDumpJavaMethods.GetDelimiter(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetDelimiter(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetMethodHeaderList(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetMethodHeaderList(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetMethodHeaderListSize(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetMethodHeaderListSize(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetMethodHeaderByIndex(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetMethodHeaderByIndex(FjEnv, FjObject, _index);
end;

procedure jDumpJavaMethods.MaskMethodHeaderByIndex(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDumpJavaMethods_MaskMethodHeaderByIndex(FjEnv, FjObject, _index);
end;

procedure jDumpJavaMethods.UnMaskMethodHeaderByIndex(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDumpJavaMethods_UnMaskMethodHeaderByIndex(FjEnv, FjObject, _index);
end;

function jDumpJavaMethods.GetNoMaskedMethodHeaderList(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetNoMaskedMethodHeaderList(FjEnv, FjObject);
end;

function jDumpJavaMethods.Extract(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_Extract(FjEnv, FjObject);
end;

function jDumpJavaMethods.Extract(_fullJavaClassName: string; _delimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_Extract(FjEnv, FjObject, _fullJavaClassName ,_delimiter);
end;

function jDumpJavaMethods.GetNoMaskedMethodImplementationByIndex(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetNoMaskedMethodImplementationByIndex(FjEnv, FjObject, _index);
end;

function jDumpJavaMethods.GetNoMaskedMethodImplementationListSize(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetNoMaskedMethodImplementationListSize(FjEnv, FjObject);
end;

function jDumpJavaMethods.GetNoMaskedMethodImplementationList(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDumpJavaMethods_GetNoMaskedMethodImplementationList(FjEnv, FjObject);
end;

{-------- jDumpJavaMethods_JNI_Bridge ----------}

function jDumpJavaMethods_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _fullJavaClassName: string): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fullJavaClassName));
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDumpJavaMethods_jCreate', '(JLjava/lang/String;)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
env^.DeleteLocalRef(env,jParams[1].l);
end;

(*
//Please, you need insert:

   public java.lang.Object jDumpJavaMethods_jCreate(long _Self, String _fullJavaClassName) {
      return (java.lang.Object)(new jDumpJavaMethods(this,_Self,_fullJavaClassName));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jDumpJavaMethods_jFree(env: PJNIEnv; _jdumpjavamethods: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdumpjavamethods, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetMethodFullSignatureList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMethodFullSignatureList', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetMethodImplementationList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMethodImplementationList', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_SetStripFullTypeName(env: PJNIEnv; _jdumpjavamethods: JObject; _stripFullTypeName: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_stripFullTypeName);
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'SetStripFullTypeName', '(Z)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetStripFullTypeName(env: PJNIEnv; _jdumpjavamethods: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStripFullTypeName', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jdumpjavamethods, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_SetFullJavaClassName(env: PJNIEnv; _jdumpjavamethods: JObject; _fullJavaClassName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullJavaClassName));
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFullJavaClassName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetFullJavaClassName(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFullJavaClassName', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_SetObjReferenceName(env: PJNIEnv; _jdumpjavamethods: JObject; _objReferenceName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_objReferenceName));
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'SetObjReferenceName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetObjReferenceName(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetObjReferenceName', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_SetDelimiter(env: PJNIEnv; _jdumpjavamethods: JObject; _delimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDelimiter', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetDelimiter(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDelimiter', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetMethodHeaderList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMethodHeaderList', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetMethodHeaderListSize(env: PJNIEnv; _jdumpjavamethods: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMethodHeaderListSize', '()I');
  Result:= env^.CallIntMethod(env, _jdumpjavamethods, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMethodHeaderByIndex', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_MaskMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'MaskMethodHeaderByIndex', '(I)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDumpJavaMethods_UnMaskMethodHeaderByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'UnMaskMethodHeaderByIndex', '(I)V');
  env^.CallVoidMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetNoMaskedMethodHeaderList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNoMaskedMethodHeaderList', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_Extract(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'Extract', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_Extract(env: PJNIEnv; _jdumpjavamethods: JObject; _fullJavaClassName: string; _delimiter: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullJavaClassName));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'Extract', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetNoMaskedMethodImplementationByIndex(env: PJNIEnv; _jdumpjavamethods: JObject; _index: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNoMaskedMethodImplementationByIndex', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jdumpjavamethods, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetNoMaskedMethodImplementationListSize(env: PJNIEnv; _jdumpjavamethods: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNoMaskedMethodImplementationListSize', '()I');
  Result:= env^.CallIntMethod(env, _jdumpjavamethods, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jDumpJavaMethods_GetNoMaskedMethodImplementationList(env: PJNIEnv; _jdumpjavamethods: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdumpjavamethods);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNoMaskedMethodImplementationList', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jdumpjavamethods, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

end.
