unit xlswriter;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/19/2019 19:38:50]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jXLSWriter = class(jControl)
 private
    //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function CreateWorkbook(_sheet: string; _path: string; _fileName: string): boolean; overload;
    function CreateWorkbook(var _sheets: TDynArrayOfString; _path: string; _fileName: string): boolean; overload;
    function AddCell(_sheetIndex: integer; _column: integer; _row: integer; _content: string): boolean;
 published
   //
end;

function jXLSWriter_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jXLSWriter_jFree(env: PJNIEnv; _jxlswriter: JObject);
function jXLSWriter_CreateWorkbook(env: PJNIEnv; _jxlswriter: JObject; _sheet: string; _path: string; _fileName: string): boolean; overload;
function jXLSWriter_CreateWorkbook(env: PJNIEnv; _jxlswriter: JObject; var _sheets: TDynArrayOfString; _path: string; _fileName: string): boolean; overload;
function jXLSWriter_AddCell(env: PJNIEnv; _jxlswriter: JObject; _sheetIndex: integer; _column: integer; _row: integer; _content: string): boolean;

implementation

{---------  jXLSWriter  --------------}

constructor jXLSWriter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jXLSWriter.Destroy;
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

procedure jXLSWriter.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jXLSWriter.jCreate(): jObject;
begin
   Result:= jXLSWriter_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jXLSWriter.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jXLSWriter_jFree(FjEnv, FjObject);
end;

function jXLSWriter.CreateWorkbook(_sheet: string; _path: string; _fileName: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jXLSWriter_CreateWorkbook(FjEnv, FjObject, _sheet ,_path ,_fileName);
end;

function jXLSWriter.CreateWorkbook(var _sheets: TDynArrayOfString; _path: string; _fileName: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jXLSWriter_CreateWorkbook(FjEnv, FjObject, _sheets ,_path ,_fileName);
end;

function jXLSWriter.AddCell(_sheetIndex: integer; _column: integer; _row: integer; _content: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jXLSWriter_AddCell(FjEnv, FjObject, _sheetIndex ,_column ,_row ,_content);
end;

{-------- jXLSWriter_JNI_Bridge ----------}

function jXLSWriter_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jXLSWriter_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jXLSWriter_jFree(env: PJNIEnv; _jxlswriter: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jxlswriter);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jxlswriter, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jXLSWriter_CreateWorkbook(env: PJNIEnv; _jxlswriter: JObject; _sheet: string; _path: string; _fileName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sheet));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jxlswriter);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateWorkbook', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jxlswriter, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jXLSWriter_CreateWorkbook(env: PJNIEnv; _jxlswriter: JObject; var _sheets: TDynArrayOfString; _path: string; _fileName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  i: integer;
begin
  newSize0:= Length(_sheets);
  jNewArray0:= env^.NewObjectArray(env, newSize0, env^.FindClass(env,'java/lang/String'),env^.NewStringUTF(env, PChar('')));
  for i:= 0 to newSize0 - 1 do
  begin
     env^.SetObjectArrayElement(env,jNewArray0,i,env^.NewStringUTF(env, PChar(_sheets[i])));
  end;
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jxlswriter);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateWorkbook', '([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jxlswriter, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jXLSWriter_AddCell(env: PJNIEnv; _jxlswriter: JObject; _sheetIndex: integer; _column: integer; _row: integer; _content: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sheetIndex;
  jParams[1].i:= _column;
  jParams[2].i:= _row;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_content));
  jCls:= env^.GetObjectClass(env, _jxlswriter);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCell', '(IIILjava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jxlswriter, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
