unit uploadservice;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [2/24/2019 20:52:52]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jUploadService = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Start(_strURL: string; _formName: string; _intentActionNotification: string);
    procedure UploadFile(_filePath: string; _fileName: string);
    procedure UploadFileFromAssets(_fileName: string);

 published

end;

function jUploadService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jUploadService_jFree(env: PJNIEnv; _juploadservice: JObject);
procedure jUploadService_Start(env: PJNIEnv; _juploadservice: JObject; _strURL: string; _formName: string; _intentActionNotification: string);
procedure jUploadService_UploadFile(env: PJNIEnv; _juploadservice: JObject; _filePath: string; _fileName: string);
procedure jUploadService_UploadFileFromAssets(env: PJNIEnv; _juploadservice: JObject; _fileName: string);


implementation

{---------  jUploadService  --------------}

constructor jUploadService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jUploadService.Destroy;
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

procedure jUploadService.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jUploadService.jCreate(): jObject;
begin
   Result:= jUploadService_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jUploadService.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jUploadService_jFree(FjEnv, FjObject);
end;

procedure jUploadService.Start(_strURL: string; _formName: string; _intentActionNotification: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUploadService_Start(FjEnv, FjObject, _strURL ,_formName ,_intentActionNotification);
end;

procedure jUploadService.UploadFile(_filePath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUploadService_UploadFile(FjEnv, FjObject, _filePath ,_fileName);
end;

procedure jUploadService.UploadFileFromAssets(_fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jUploadService_UploadFileFromAssets(FjEnv, FjObject, _fileName);
end;

{-------- jUploadService_JNI_Bridge ----------}

function jUploadService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jUploadService_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jUploadService_jFree(env: PJNIEnv; _juploadservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _juploadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _juploadservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUploadService_Start(env: PJNIEnv; _juploadservice: JObject; _strURL: string; _formName: string; _intentActionNotification: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_strURL));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_formName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_intentActionNotification));
  jCls:= env^.GetObjectClass(env, _juploadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _juploadservice, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUploadService_UploadFile(env: PJNIEnv; _juploadservice: JObject; _filePath: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _juploadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'UploadFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _juploadservice, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jUploadService_UploadFileFromAssets(env: PJNIEnv; _juploadservice: JObject; _fileName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _juploadservice);
  jMethod:= env^.GetMethodID(env, jCls, 'UploadFileFromAssets', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _juploadservice, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
